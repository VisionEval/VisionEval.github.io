# VisionEval installation script
# Author: Jeremy Raw

# General script overview:

# - Create ve.env (passed through to VEStart or VEBuild/Boostrap)
#
# - Load VE_HOME and get user to confirm location via dialog
#   * Ideally, option for text dialog (initial text request)
#   * Copy ve-install-config.yml if new VE_HOME selected

# - Load and create ve.lib within VE_HOME (once selected)
#   * Create ve-inst-lib for packages using by VE4-install itself
#     (So we can load them again if needed into final ve-lib)

# - Identify ve-install-config.yml if it exists and edit with dialog
#   * If file does not exist, just insert default repositories
#   * Dialog can re-write ve-install-config.yml in VE_HOME  

# - Main installation process
#   * Get releases and select installer (tcltk dialog)
#   * Three installation options
#     - Package release (binary, library or source) where available
#       If VE_BUILD is set in .Renviron, also consider releases in VE_BUILD/install
#     - Release zipball (for VE-Bootstrap.R build)
#     - Local Repository Clone (dialog to browse directory)
#       (just relays to VE-Bootstrap.R but keeps VE_HOME/ve-lib and built locations from installer)
#   * Result is a file to download

# - Fetch/Download the installer (easy for local clone!) to VE_HOME/download

# - Unzip to suitable location:
#     * WinLibrary goes straight into ve-lib/x.y, overwriting what is there, then running update against
#         CRAN + BioConductor
#       Get the x.y from the MANIFEST pkgType
#     * WinBinary unzips into VE_HOME/install/<contriburl> then does install.packages (eventually with pak, see below)
#     * SourcePkgs unzips into VE_HOME/install/<contriburl> then does install.packages (eventually with pak, see below)
#     * Source code (zip) ("zipball" for release) unzips into VE_SOURCE (zipfile interior folder names subfolder)
#       This zipball gets a VisionEval snapshot repository and does the standard build

# NOTE: Source packages require a consistent RTools installation on Windows
#  On Linux or Mac, many of the packages have "SystemRequirements" (OS packages that need to be installed)
# TODO: Implement installation of SystemRequirements using the "pak" package (from RStudio)
#  https://pak.r-lib.org/reference/sysreqs.html
#  Using pak will require replacing the standard "install.packages" for the non-VE dependencies
# TODO: Use pak within VEBuild::ve.build() so we can run ve.build on non-Windows machines

# - Complete the installation
#     * WinLibrary:
#         Is done just by unzipping
#     * WinBinary
#         Does install/update packages to ve-lib using contriburl plus CRAN/BioConductor
#     * SourcePkgs
#         Checks for and installs RTools if necessary (kick o)
#         Does install/update packages to ve-lib using contriburl plus CRAN/BioConductor
#     * Zipball
#         Checks for and installs RTools if necssary (kick over to manual download/install)
#         Checks for VE-Bootstrap.R in unzipped VE_SOURCE subfolder and sources that script
#         (Effectively starting a build process, using VE_HOME from the installer environment)
#         TODO: change the build script to respect VE_SOURCE

# - Start VisionEval

######## Load the user interface

# Get UI Script location
if ( ! exists("ve.url") ) {
  message("If the install doesn't work, please assign the URL or file directory of this script to ve.url")
  message("e.g. 'source(ve.url<-\"https://visioneval.org/assets/install/VE4-install.R\")'")
  ve.url <- file.path(getwd(),"VE4-Install.R") # Might work in a testing environment
}

# Identify UI Script
caps <- capabilities()
using.tcltk <- if ( isTRUE(caps["tcltk"]) ) {
  UI.script <- file.path(dirname(ve.url),"VE4-UI-tcltk.R")
  load.tcltk <- try( suppressWarnings(source(UI.script)), silent=TRUE )
  if ( inherits(load.tcltk,"try-error") ) FALSE else TRUE
} else FALSE
if ( isFALSE(using.tcltk)  ) {
  message("Dialogs are not available for installation; installing most recent available release")
  # Load text interface functions (just uses defaults all the way through for latest useful release)
  select.ve.home.dialog <- function(ve.home) ve.home

  get.buildtype.dialog  <- function() {
    # For now, this just tries to do a Release build type
    return( "Release" )
  }

  setup.dialog          <- function(build.type,all.releases,load.install.config,...) {
    if ( build.type != "Release" ) stop(call.=FALSE,"Unsupported build type - need full dialogs to pick types other than 'Release'")
    # Returns the "selected" structure (first in installer in the first release in the first repository)
    list(
      Runtime   = build.type,
      Repos     = names(all.releases)[1],
      Release   = names(all.releases[[1]])[1],
      Installer = names(all.releases[[1]][[1]][["assets"]])[1],
      DoIt      = "Install"
    )
  }
}

# Set up the working enviroment

cache.releases <- FALSE
# remove comment on the following to cache online release information (Warning: won't update if the release changes)
# cache.releases <- TRUE

####### Establish working environment

# Note that this differs in subtle but important ways from the working environment set up in
#   VEBuild::LoadBuildScripts or in VE-Bootstrap.R. It's bare bones and just enough to situate the
#   installer.

ve.env <- if ( ! "ve.env" %in% search() ) {
  attach(NULL,name="ve.env")
} else {
  as.environment("ve.env")
}

# Allow user to pre-select ve.home rather than go through the dialog below
# If VE_INSTALL is set, we'll go do our work there rather than VE_HOME (for testing the script)
ve.env.list <- ls(ve.env)
ve.home <- Sys.getenv("VE_INSTALL",NA)  # VE_INSTALL can be used as a bare VE_HOME for testing
if ( is.na(ve.home) ) {
  if ( ! "ve.home" %in% ve.env.list || is.na(ve.env$ve.home) ) {
    ve.home <- Sys.getenv("VE_HOME",NA)
    if ( is.na(ve.home) ) {
      home.from <- "getwd()"
      ve.home <- getwd()
    } else {
      home.from <- "VE_HOME"
      ve.env$ve.home <- ve.home
    }
  } else {
    home.from <- "Existing ve.env$ve.home"
    ve.home <- ve.env$ve.home
  }
} else {
  home.from <- "VE_INSTALL"
  Sys.setenv(VE_HOME=ve.home) # override VE_HOME with VE_INSTALL for the remainder of testing
  ve.env$ve.home <- ve.home
}
message("VE_HOME is ",ve.home)

# UI FUNCTION: select.ve.home.dialog(ve.home) # returns ve.home

old.ve.home <- ve.home
ve.home <- select.ve.home.dialog(ve.home)
if ( is.na(ve.home) ) stop(call.=FALSE,"Installation cancelled at user request.")
if ( dir.exists(ve.home) ) {
  ve.env$ve.home <- ve.home
  # Salvage old ve-install-config.yml if it exists
  if ( file.exists( old.install.config.file <- file.path(old.ve.home,"ve-install-config.yml") ) ) {
    file.copy(old.install.config.file, ve.home)
  }
  setwd(ve.home)
} else stop(call.=FALSE,"Installation Cancelled. VE_HOME directory does not exist")

ve.env$this.R <- paste(c(R.version["major"],R.version["minor"]),collapse=".")
ve.env$two.digit.R <- tools::file_path_sans_ext(this.R)

# Set ve-lib installation location
ve.env$ve.lib <- file.path(ve.home,"ve-lib",ve.env$two.digit.R)
if ( ! dir.exists(ve.env$ve.lib) ) dir.create(ve.env$ve.lib,recursive=TRUE)
if ( ! ve.lib %in% .libPaths() ) .libPaths(c(ve.lib)) # will remove extra libraries

# Create another library for instalation packages (yaml, rjson, BiocManager)
# That will enable us to install or update instances for the overall VE installation
inst.lib <- file.path(ve.home,"ve-inst-lib (remove)",ve.env$two.digit.R)
if ( ! dir.exists(inst.lib) ) dir.create(inst.lib,recursive=TRUE)

install.config.file <- file.path(ve.env$ve.home,"ve-install-config.yml")

####### Load Configuration File

if ( ! requireNamespace("yaml",lib.loc=inst.lib,quietly=TRUE) ) {
  install.packages("yaml",repos="https://cloud.r-project.org",lib=inst.lib)
  requireNamespace("yaml",lib.loc=inst.lib,quietly=TRUE)
}

# Edit installation configuration

default.ve.repository <- list(
  list(user="visioneval",repository=c("visioneval-4"))   # release repository
)
default.config <- list(ve.distributions=default.ve.repository)

load.install.config <- function() {

  # Create default configuration structure
  return (
    if ( file.exists(install.config.file) ) {
      load.config <- try( silent=TRUE, yaml::yaml.load_file(install.config.file) ) # will throw error if file is improperly configured
      if ( ! is.list(load.config) ) default.config else load.config
    } else default.config
  )

}

####### process the installation

installVisionEval <- function(cache=cache.releases) { # no function parameters right now
  installer <- selectInstaller(cache=cache)   # pick an available installer (config handled internally)
  retrieved <- fetchInstaller(installer) # confirms downloaded location and MANIFEST type
  launch    <- doInstallation(retrieved) # launch selects "end user" or "builder"
}

####### getAllReleases from distributions (plus local built if any)

# Test file names for installer.pattern
# files <- c(
#   "VE-Installer_Source_2025-03-21.zip",
#   "VE-Installer_Windows-R4.4_2025-03-21.zip",
#   "VE-Installer_WinLibrary-R4.4_2025-03-21.zip"
# )
# Repository ZipBall for building comes as "Build_Source_207439148.zip"
#   where the gaggle of numbers is the Github release ID

installer.pattern <- paste0(
  "VE-Installer_",                                          # .* will be the VE Version
  paste0("((WinLibrary|Windows)-R",two.digit.R,"|Source)"), # The type of installer 
  "_.*\\.zip$"
)

isVEInstaller <- function(filename) all(grepl(installer.pattern,filename))

getReleases <- function(build.type,cache=FALSE) {
  # Option to cache results during testing so as not to hit Github API over and over (they are rate limited)
  if ( ! requireNamespace("rjson",lib.loc=inst.lib,quietly=TRUE) ) {
    install.packages("rjson",repos="https://cloud.r-project.org",lib=inst.lib)
    requireNamespace("rjson",lib.loc=inst.lib,quietly=TRUE)
  }
  if ( file.exists(test.file<-paste0("Test-Skip-Download-",build.type,".json")) ) {
    # NOTE: uncomment lines below to save JSON locally for testing
    # You don't want to do that generally since it will block release updates.
    all.releases <- rjson::fromJSON(file=test.file,simplify=FALSE)
    message("\n##### USING TEST FILE for ",build.type," !!! #####")
  } else {
    # Gather information about Releases
    # 1. Pre-built release (download) "Release"
    # 2. Snapshot of a release (download) "Build Release Snapshot" - skips installer selection and returns zipball
    # 3. Repository clone (already present) "Build Local Clone" - returns empty all.releases
    all.releases <- list()
    if ( build.type == "Build Local Clone" ) {
      all.releases <- ve.env$ve.home
      return(all.releases) # no releases: hunt for local github clone with a VE-Bootstrap.R
    }
    config <- load.install.config() # ve-install-config.yml may be changed by get.buildtype.dialog
    for ( distro in config$ve.distributions ) {
      dist.user <- distro$user
      for ( repo in distro$repository ) {
        repo.name <- paste(dist.user,repo,sep="/")
        # message("Processing ",repo.name)
        # Check for repository existence
        repo.addr <- paste0("https://api.github.com/repos/",dist.user,"/",repo)
        check.repo <- base::curlGetHeaders(repo.addr)
        repo.status <- attr(check.repo,'status')
        if ( is.null(repo.status) || repo.status!=200 ) {
          message("Cannot Find Github Repository: ",repo.addr," (",repo.status,")")
          next
        }
        releases <- rjson::fromJSON(file=paste0(repo.addr,"/releases"))
        if ( cache ) {
          # Cache results during testing (only saves one; use for inspecting structure)
          writeLines(rjson::toJSON(releases,indent=2),con="Raw-release.json")
        }
        release.data <- list()
        for ( r in releases ) {
          r.temp <- list(
            release=r$name,
            date=r$published_at,
            id=r$id
          )
          # The zipball is the complete snapshot of the repository tag
          # that was built into the release. You can use that to set up
          # a VisionEval ve.build() installation without messing with Git.
          if (build.type == "Build Release Snapshot" ) {
            installers <- list()
            zbname <- paste0("Build_Source_",r$id,".zip")
            zipball <- list()
            zipball[[zbname]] <- list(
              timeout = 1200,
              url     = r$zipball_url,
              file    = zbname
            )
            installers[[zbname]] <- zipball
            r.temp$assets <- zipball
            release.data[[length(release.data)+1]] <- r.temp
          } else {
            # Full list of release assets

            # message("Processing release: ",r$name)
            installers <- list()
            for ( a in r$assets ) {
              a.temp <- list(
                timeout = as.integer(round(a$size/750000,0)),
                url     = a$browser_download_url,
                file    = basename(a$browser_download_url)
              )
              if ( isVEInstaller( a.temp$file ) ) {
                # message(a.temp$file," IS an installer")
                installers[[length(installers)+1]] <- a.temp
              } # else {
                #   message(a.temp$file," is NOT an installer (",installer.pattern,")")
                # }
            }
            if ( length(installers) > 0 ) { # got a valid release
              installer.names <- sapply( installers,function(i) i$file )
              installers <- installers [ # put them in order of desirability
                c(
                  grep("Windows",installer.names),
                  grep("WinLibrary",installer.names),
                  grep("Source",installer.names)
                )
              ]
              names(installers) <- sapply( installers,function(i) i$file )
              r.temp$assets <- installers
              release.data[[length(release.data)+1]] <- r.temp
              # message("Release: ",r.temp$release)
            } # else silently skip releases that do not have VE40 installers
          }
        }
        if ( length(release.data) > 0 ) {
          names(release.data) <- sapply( release.data,function(r) paste0(r$release,":",r$date) )
          all.releases[[repo.name]] <- release.data
        } else {
          message("No releases found with valid installers in ",repo.name)
        }
      }
    }
    # If we're doing standard releases, create a virtual release for installers we may have built
    # locally. This is intended for testing the install script with updated local installers.
    if ( build.type == "Release" && ! is.na(ve.build <- Sys.getenv("VE_BUILD",NA) ) ) {
      message("ve.build = ",ve.build)
      if ( dir.exists(local.releases <- file.path(ve.build,"install") ) ) { # Locally built installers
        release.data <- list()
        for ( release.name in rev(dir(local.releases,full.names=TRUE)) ) {
          if ( ! dir.exists(release.name) ) next # may be a file not a folder
          local.installers <- rev(dir(release.name,full.names=TRUE))
          local.installers <- local.installers [ # put them in order of desirability
            c(
              grep("Windows",local.installers),
              grep("WinLibrary",local.installers),
              grep("Source",local.installers)
            )
          ]
          local.files <- list()
          for ( file in local.installers ) {
            if( isVEInstaller(file) ) {
              local.files[[basename(file)]] <- list(
                timeout = 0,
                url     = "file",
                file    = file
              )
            }
          }
          if ( length(local.files) > 0 ) {
            release.name <- basename(release.name)
            r.temp <- list( 
              release=release.name,
              date=as.character(Sys.Date()),
              id=0,
              assets=local.files
            )
            release.data[[release.name]] <- r.temp
          }
        }
        if ( length(release.data) > 0 ) {
          all.releases[["Locally Built Installers"]] <- release.data
        } else message("No local installers have been built for ",this.R)
      }
    }
    if ( cache ) {
      # Cache release results for use during testing
      message("Saving test file")
      writeLines(rjson::toJSON(all.releases,indent=2),con=test.file)
      stop(call.=FALSE,"Stop to review all.releases")
    }
  }
    
  return(all.releases)
}

selectInstaller <- function(cache=FALSE) {

  repeat {
    build.type <- get.buildtype.dialog()
    if ( is.na(build.type) || build.type=="Cancel" ) stop(call.=FALSE,"Installation cancelled from build type selection dialog.")
    all.releases <- getReleases(build.type,cache=cache)
    selected <- setup.dialog(build.type,all.releases,load.install.config) # different dialog versions depending on release type
    if ( ! selected$DoIt == "TryAgain") {
      if ( selected$DoIt != "Install" ) stop(call.=FALSE,"Installation cancelled from installer selection dialog")
      break
    }
  }

  if ( selected$Runtime != "Build Local Clone" ) {
    repo <- selected$Repos
    release <- selected$Release
    installer <- all.releases[[repo]][[release]][["assets"]][[selected$Installer]]
  } else {
    installer <- list(
      Repos=selected$Repos
    )
  }
  installer$installType <- selected$Runtime
  return(installer)
}

####### Download the installer and report what was retrieved (or if it failed)

installTypes <- data.frame(
  pattern = c(
    "WinLibrary-R",
    "Windows-R",
    "^Build_Source_",
    "_Source_"
  ),
  type = c(
    "WinLibrary",
    "Windows",
    "BuildSource",
    "Source"
  )
)

installTypeOf <- function(retrieved) { # retrieved is a file name
  for ( p in 1:nrow(installTypes) ) {
    if ( grepl(installTypes$pattern[p],basename(retrieved)) ) return(installTypes$type[p])
  }
  return("Unknown")
}

fetchInstaller <- function(installer) {
  # Place downloaded files in ve.home/download
  # return downloaded file name and type of installation expected
  # File name has attribute distinguishing VE Installer from Github snapshot (Source Code)
  if ( installer$installType == "Build Local Clone" ) {
    retrieved <- installer$Repos
    attr(retrieved,"InstallType") <- "LocalClone"
  } else {
    download <- file.path(ve.home,"download")
    if ( ! dir.exists( download ) ) dir.create(download,recursive=TRUE)
    if ( ! basename(installer$file) %in% dir(download) ) { # Shorten restart if there was a previous download
      if ( installer$url == "file" ) {
        file.copy(installer$file, download) # Copy local installer
      } else { # need to download it
        options(timeout = max(installer$timeout, getOption("timeout")))
        message("Timeout: ",getOption("timeout")," seconds")
        destfile <- file.path(download,installer$file)
        download.file(installer$url,destfile=destfile,method="libcurl",mode="wb")
        # use method=libcurl so download.file follows redirect links
      }
    } else {
      message("Installer has already been downloaded.")
      message("Installer can be found in ",download)
      message("installer$file is ",installer$file)
      message("For a clean install, remove the downloads directory in VE_HOME")
    }
    retrieved <- dir(download,full.names=TRUE,pattern=basename(installer$file))
    attr(retrieved,"InstallType") <- installTypeOf(retrieved)
  }
  message("InstallType is ",attr(retrieved,"InstallType"))
  invisible(retrieved) # name of downloaded file with attribute stating "Runtime" or "Build" install type
}

####### Perform the installation based on the downloaded installer type and information

doInstallation <- function(retrieved) {
  # Dispatch based on retrieved$localfile and InstallType attribute
  # LocalClone just launches VE-Bootstrap.R from the local clone directory
  # VE built installers:
  # WinLibrary replaces corresponding ve-lib packages with packages from installer
  #   - Remove them first based on folder names
  #   - Then copy the entire new package into place
  # WinBinary always installs ve-lib with binary packages it contains
  #   - Update existing packages from CRAN and BioConductor
  #   - Just install directly (will overwrite any package already there)
  #   - Set up so the repository list can find needed files in CRAN or BioConductor
  # Source always installs ve-lib with source packages it contains
  #   - Update existing packages from CRAN and BioConductor
  #   - Just install directly (will overwite any package already there)
  #   - Set up so the repository list can find needed files in CRAN or BioConductor
  # return launch function loading VEStart or VE-Bootstrap.R as desired
  # Source Code Zipball 
  # Unzip into build-source Location
  # Load VE-Bootstrap.R, with ve.sources set to the unzipped zipball
  # VE_HOME can stay the same, VE_BUILD created within VE_HOME, VE_SOURCE set to
  #   absolute path of "sources" subfolder in unzipped source tree.
  # When VE-Bootstrap.R does ve.build() it saves VE_SOURCE to .Renviron
  # Return a function to launch VE (bootstrap or load VEStart)
  # Return a text error message if install failed.
  installType <- attr(retrieved,"InstallType")
  confirm <- if ( using.tcltk ) {
    tkmessageBox(
      title = "Complete Installation?", icon = "question", type = "yesno",
      message = paste(
        "Ready to install:\n\n",retrieved,
        "\nInstallation Type: ",installType,  
        "\n\nWould you like to proceed?"
      )
    )
  } else {
    conf.yn <- askYesNo("Complete Installation?",prompts="Y/N/C") # Text confirmation
    if ( conf.yn) "yes" else "no"
  }
      
  if ( as.character(confirm) != "yes" ) {
    stop("Installation cancelled. Restart to try again.",call.=FALSE)
  }

  if ( installType == "LocalClone" ) {
    # LocalClone is just looking at a directory containing VE-Bootstrap.R
    # Point VE_SOURCE at it, then run its VE_Bootstrap.R
    Sys.setenv(
      VE_SOURCE=file.path(retrieved)
    ) # 
    return(
      function() {
        bootstrap <- file.path(retrieved,"VE-Bootstrap.R")
        if ( ! file.exists(bootstrap) ) stop("Installation failed: could not load ", bootstrap)
        source(bootstrap)
      }
    )
  } else {
    if ( installType %in% c("WinLibrary","Windows","Source") ) {
      if ( installType == "WinLibrary" ) {
        # This is a pre-installed WinBinary, with all dependencies (like VE installers before 4.0)
        # Unzip directly into ve.lib
        lst <- unzip(retrieved,list=TRUE)
        # Find any packages already in ve.lib and remove those
        replacements <- file.path(ve.lib,sub("/$","",lst[grep("^[^/]+/$",lst$Name),"Name"]))
        replacements <- replacements[dir.exists(replacements)]
        if ( length(replacements) > 0 ) {
          unlink(replacements,recursive=TRUE)
        }
        # Unzip the replacement packages straight into ve.lib
        message("Unzipping : ",retrieved)
        message("Into      : ",ve.lib)
        unzip(retrieved,exdir=ve.lib) # simply extract the download back into ve-lib
      } else {
        # Ensure presence of needed packages
        if ( ! requireNamespace("BiocManager",lib.loc=inst.lib,quietly=TRUE) ) {
          install.packages("BiocManager",repos="https://cloud.r-project.org",lib=inst.lib)
          requireNamespace("BiocManager",lib.loc=inst.lib,quietly=TRUE)
        }
        # unzip the single MANIFEST file
        mfc<-unz(retrieved,"MANIFEST","r")
        manifest <- read.dcf(mfc)
        close(mfc)
        manifest <- manifest[1,] # turn matrix into named character vector
        pkgType <- manifest["pkgType"]
        destination <- sub("/","",manifest["Destination"])
        ve.repos <- dirname(retrieved)
        exdir <- file.path(ve.repos,destination)
        message("Unzipping : ",retrieved)
        message("Into      : ",exdir)
        unzip(retrieved,exdir=exdir)
        # Now install those packages plus dependencies online that may be needed
        install.repos <-paste0("file:///",ve.repos)
        all.repos <- c(
          install.repos,
          BiocManager::repositories() # includes https://cran.r-project.org
        )
        available <- available.packages(repos=install.repos,type=pkgType)
        packages <- available[,"Package"]
        install.packages(pkgs=packages,repos=all.repos,lib=ve.lib,type=pkgType)
      }
      return(
        # TODO: this appears to be using an earlier VE_HOME setup if that was hanging out
        # in the environment. Need to push our own notion of ve.home back through Sys.setenv
        # so we get the right ve-lib.
        function() {
          if ( ! require(VEStart,quietly=TRUE) ) stop("Installation failed: could not load VEStart")
          startVisionEval(ve.runtime=NA) # ve.runtime=NA says to ignore any VE_RUNTIME set in environment
        }
      )
    } else if ( installType == "BuildSource" ) {
      # Unzip to downloads (zip will have an inner top directory)
      message("Would unzip: ",retrieved)
      exdir <- dirname(retrieved)
      message("Into:        ",exdir)
      exname <- sub("/$","",unzip(retrieved,list=TRUE)[1,"Name"])

      # Unzip the build source distribution (may take a while!)
      ve.source.root <- file.path(ve.home,"build-source")
      if ( dir.exists(ve.source.root) ) {
        message("build-source directory already exists.")
        stop("Please remove ",ve.source.root," and try install again")
      }
      unzip(retrieved,exdir=exdir) # creates exname subdirectory
      file.rename(file.path(exdir,exname),ve.source.root)

      # Point VE-Bootstrap.R to the right stuff
      Sys.setenv(VE_SOURCE=file.path(ve.source.root,"sources"))

      return(
        function() {
          bootstrap <- file.path(ve.source.root,"VE-Bootstrap.R")
          if ( ! file.exists(bootstrap) ) stop("Installation failed: could not load ",bootstrap)
          source(bootstrap)
        }
      )
    }
  }
  return( function() { message("The installation did not finish properly. Please retry.") } )
}

####### Run the configured installation

launch <- installVisionEval(cache.releases)
if ( is.function(launch) ) launch() else stop(call.=FALSE,"Installation failed:\n",as.character(launch),"\nPlease retry.")
