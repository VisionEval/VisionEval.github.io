# VE4-UI-tcltk.R

# Provide tcltk UI for VE Installation Setup

require(tcltk,quietly=TRUE)

# Helper function for making an info button
question_button_font <- tkfont.create(size = 11)
info_button <- function(parent.frame,popup.text) {
  # Use \u2753 Unicode character for question mark
  tkbutton(
    parent.frame,
    text = "\u2753", font = question_button_font, fg="green",
    command = function() {
      tkmessageBox(message = popup.text, icon = "info")
    }
  )
}

# Confirm installation location

select.ve.home.dialog <- function(ve.home) {
  
  tt <- tktoplevel()
  tkwm.title(tt, "Select installation directory (VE_HOME)")
  tkwm.maxsize(tt, 800, 10000) # we don't expect to expand vertically

  tcl_original_VE_HOME <- tclVar(ve.home)
  tcl_VE_HOME          <- tclVar(ve.home)
  cancel_VE_HOME       <- tclVar(0)
  popup_open           <- tclVar(0)

  select_directory <- function() {
    if (tclvalue(popup_open)==0) {
      tclvalue(popup_open) <- 1
      tkconfigure(directory_button,state="disable")
      dir_path <- tclvalue(tkchooseDirectory(initialdir=ve.home,title="Select VE_HOME"))
      tclvalue(tcl_VE_HOME) <- if (dir_path != "") {
        dir_path
      } else {
        getwd()
      }
      tclvalue(popup_open) <- 0
      tkconfigure(directory_button,state="normal")
    }
  }

  directory_button <- tkbutton(tt, text = "Change VE_HOME", command = select_directory)
  tkgrid(directory_button, column = 0, row = 0, sticky = "e", padx = 5, pady = 5)

  directory_frame <- tkframe(tt, borderwidth = 2, relief = "groove")
  directory_label <- tklabel(directory_frame,textvariable=tcl_VE_HOME, justify="left")
  tkpack(directory_label,anchor="w",padx=5,pady=5) # pack inside frame

  tkgrid(directory_frame, column = 1, row = 0, sticky="ew", padx = 5, pady = 5)

  tkgrid(
    info_button(tt,
      paste(sep="",
        "VE_HOME is the directory where VisionEval will be installed. ",
        "This home directory should ideally be empty before you continue the installation.\n\n",
        "The default is the directory from which you started R. ",
        "You can use the 'Change VE_HOME' button to pick a different directory (or create a new on) for your installation.\n\n",
        "After the installation is finished, you can set a separate directory to hold your VisionEval models (VE_RUNTIME)."
      )
    ), column=2,row=0,padx=5,pady=5
  )

  # OK and Cancel buttons
  onOK <- function() {
    tkdestroy(tt)
  }
  onCancel <- function() {
    tclvalue(cancel_VE_HOME) <- 1
    tkdestroy(tt)
  }

  button_frame <- tkframe(tt)
  ok_button <- tkbutton(button_frame, text = "Select", command = onOK)
  cancel_button <- tkbutton(button_frame, text="Cancel", command = onCancel)
  tkgrid(ok_button,column=0,row=0,sticky="e",padx=5)
  tkgrid(cancel_button,column=1,row=0,sticky="w",padx=5)
  tkgrid(button_frame, column = 0, row = 1, columnspan=2, sticky="ew", padx = 5, pady = 5)

  tkgrid.columnconfigure(tt, 1, weight = 1) #Make the second column expandable.
  tkgrid.columnconfigure(button_frame,0, weight=1)
  tkgrid.columnconfigure(button_frame,1, weight=1)
  
  tkbind(tt, "<Return>", function() {
    onOK()
  })

  tkwait.window(tt)

  return (
    if ( tclvalue(cancel_VE_HOME) > 0 ) {
      NA
    } else if ( tclvalue(tcl_VE_HOME) != ve.home ) {
      tclvalue(tcl_VE_HOME)
    } else {
      ve.home
    }
  )
}

edit.install.config <- function(config) {

  # Initialize cfg.data
  parse.config <- function(distributions) {
    cfg.data <- data.frame()
    # distributions is a list of lists, each of which describes repositories for a user
    # The inner list has a "user" name and a vector of "repository" names for that user.
    for ( user in distributions ) {
      username <- user$user
      for ( repository in user$repository ) { # list of repositories for user
        cfg.data <- rbind(cfg.data,data.frame(user=username,repository=repository))
      }
    }
    cfg.data[order(cfg.data$user,cfg.data$repository),]
  }
  cfg.data <- parse.config(config$ve.distributions)

  # Start building the tcltk dialog
  tt <- tktoplevel()
  tkwm.title(tt, "Edit Install Configuration")

  changed <- tclVar("No") # change to "Yes" below when edited config needs to be re-loaded.

  newUser <- tclVar("")
  newRepo <- tclVar("")

  # Make the configuration frame
  config_frame <- tkframe(tt) # create this, expecting to destroy it again the first time we build

  build.config.frame <- function() {
    # Returns a tkframe with a set of rows inside it representing the objects
    # Create a data.frame to hold pairs of tclVar objects for each row

    # message("Building config frame:")
    # print(cfg.data)

    # Map the parsed config into a set of display rows (each of which will have a delete button)
    grid.info <- tcl("grid", "info", config_frame)
    if ( length( grid.info ) > 0 ) {
      # message("removing config_frame")
      tcl("grid","remove",config_frame)
      tkdestroy(config_frame)
      config_frame <<- NULL
    }

    config_frame <<- tkframe(tt)
    tkgrid(tklabel(config_frame,text="User/Org"),row=0,column=0,padx=5,pady=5)
    tkgrid(tklabel(config_frame,text="Repository"),row=0,column=1,padx=5,pady=5)
      
    create.trash.button.command <- function(row) {
      as.character(row)
      return(
        function() {
          # message("Removing "row" from cfg.data")
          print(cfg.data)
          cfg.data <<- cfg.data[-row,]
          build.config.frame()
        }
      )
    }
    want.trash.button <- nrow(cfg.data) > 1
    tcl.rows <- list()
    for ( row in 1:nrow(cfg.data) ) {
      tcl.row <- list( row=row, user=tclVar(cfg.data$user[row]), repository=tclVar(cfg.data$repository[row]) )
      tcl.rows[[row]] <- tcl.row
      
      user.edit <- tkentry(config_frame,textvariable=tcl.row$user)
      repository.edit <- tkentry(config_frame,textvariable=tcl.row$repository)
      tkconfigure(user.edit,state="readonly")
      tkconfigure(repository.edit,state="readonly")
      tkgrid(user.edit,row=row,column=0,padx=5,pady=5)
      tkgrid(repository.edit,row=row,column=1,padx=5,pady=5)

      if ( want.trash.button ) {
        trash.button <- tkbutton(config_frame,text="X",fg="red",
          command = create.trash.button.command(row))
        tkgrid(trash.button,row=row,column=2,padx=5,pady=5)
      }
    }
    # message("(Re-)displaying config_frame")
    tkgrid(config_frame,row=1,column=0,sticky="ew",padx=5,pady=5)
    tclvalue(newUser) <- "" # clear these for further input
    tclvalue(newRepo) <- ""
  }

  # Create brief instructions row
  instructions <- tklabel(tt,text="Github repositories to search for core VisionEval releases.")
  tkgrid(instructions,row=0,column=0,sticky="w",padx=5,pady=5)

  # make the configuration frame
  build.config.frame()

  # make a row of tkentry items to gather a new user / repository pair, with a "+" button to
  # add them at the end of cfg.data and call build.config.frame

  entry_frame <- tkframe(tt, borderwidth = 2, relief = "groove")
  user_entry  <- tkentry(entry_frame, textvariable = newUser)
  repo_entry  <- tkentry(entry_frame, textvariable = newRepo)
  new_button  <- tkbutton(entry_frame, text = "Add", fg="green", command = function() {
    nu <- tclvalue(newUser)
    nr <- tclvalue(newRepo)
    if ( all( nzchar(c(nu,nr)) ) ) {
      # Add a row to cfg.data
      # message("Before adding:")
      # print(cfg.data)
      cfg.data <<- rbind(cfg.data,data.frame(user=nu,repository=nr))
      # message("After adding:")
      # print(cfg.data)
      # message("Rebuilding config_frame inside add function")
      build.config.frame()
    } else {
      # Can't add unless both variables have something in them
      # message("No change")
      # message("nu = ",nu," and nr = ",nr)
      tclvalue(newUser) = ""
      tclvalue(newRepo) = ""
    }
  })
  tkgrid(user_entry,row=0,column=0,padx=5,pady=5)
  tkgrid(repo_entry,row=0,column=1,padx=5,pady=5)
  tkgrid(new_button,row=0,column=2,padx=5,pady=5)
  tkgrid(entry_frame,row=2,column=0,sticky="ew",padx=5,pady=5)

  # buttons to "Reset", "Save", or "Return" in a row below the entry frames
  # Reset button sets cfg.data to the default repositories
  #  (but does NOT save it; need to also press Save)
  # Save button repacks the user/repository controls into hierarchical structure, saves it,
  #   and returns "changed<-TRUE" leading to retry
  # Return button cancels dialog without changing anything ("changed<-FALSE")
  onReset <- function() {
    # Reset button returns to edit defaults (without changing any saved file)
    # User still needs to save in order to apply this configuration
    cfg.data <- parse.config(default.config)
    build.config.frame(cfg.data)
  }
  onSave <- function() {
    # iterate cfg.data into a hierarchical list by user / repository
    new.distributions <- list()
    for ( row in 1:nrow(cfg.data) ) {
      new.distributions[[row]] <- list(user=cfg.data$user[row],repository=cfg.data$repository[row])
    }
    yaml::write_yaml(list(ve.distributions=new.distributions), install.config.file, indent=2) # ve.env$ve.home/ve-install-config.yml
    tclvalue(changed) <- "Yes"
    tkdestroy(tt)
  }
  onReturn <- function() {
    tclvalue(changed) <- "No"
    tkdestroy(tt)
  }

  # Window action buttons
  button_frame <- tkframe(tt)
  reset_button  <- tkbutton(button_frame, text = "Reset", command = onReset)
  save_button   <- tkbutton(button_frame, text = "Save", command = onSave)
  return_button <- tkbutton(button_frame, text = "Return", command = onReturn)
  tkgrid(reset_button,row=0,column=0,padx=5,pady=5)
  tkgrid(save_button,row=0,column=1,padx=5,pady=5)
  tkgrid(return_button,row=0,column=2,padx=5,pady=5)
  tkgrid(button_frame,row=3,column=0,padx=5,pady=5)

  # Run the dialog
  tkfocus(tt)
  tkwait.window(tt)

  return(tclvalue(changed))
}

# TclTk dialog to present a list box with choices
# Used to select repositories (if more than one configured), releases, and installers

select.from.list <- function(parent_window, dest_var, items, title="Make a Selection") {
  tt <- tktoplevel(parent = parent_window)
  tkwm.title(tt, title)

  original_var <- tclVar(tclvalue(dest_var))

  Instructions <- tklabel(tt,text=title,justify="center")
  tkgrid(Instructions, row=0, column=0, sticky="ew",pady=5)

  lb.frame <- tkframe(tt,borderwidth=2,relief="solid")
  lb1 <- tklistbox(lb.frame, selectmode = "single", height=0, width=0)

  tkgrid(lb1,row=0,column=0,padx=5,pady=5,sticky="ew")
  tkgrid.columnconfigure(lb.frame,0,weight=1)
  for (item in items) {
    tkinsert(lb1, "end", item)
  }
  tkselection.set(lb1,0)
  tkgrid(lb.frame, row = 1, column = 0, sticky = "ew", padx=5, pady=5)

  onOK <- function() {
    selection <- as.integer(tcl(lb1, "curselection")) + 1
    if (length(selection) > 0) {
      tclvalue(dest_var) <- items[selection]
    }
    tkdestroy(tt)
  }

  onCancel <- function() { # leave dest_var unchanged
    tclvalue(dest_var) <- tclvalue(original_var)
    tkdestroy(tt)
  }

  button.frame <- tkframe(tt)
  ok_button <- tkbutton(button.frame, text = "OK", command = onOK)
  cancel_button <- tkbutton(button.frame, text = "Cancel", command = onCancel)

  tkgrid(ok_button, row = 0, column = 0, padx = 5, pady = 5,sticky="e")
  tkgrid(cancel_button, row = 0, column = 1, padx = 5, pady = 5,sticky="w")
  tkgrid(button.frame,row=2,column=0)

  tkgrid.columnconfigure(tt, 0, weight = 1)
  tkgrid.rowconfigure(tt, 0, weight = 1)

  tkwait.window(tt) # Run the dialog
}

# Helper dialog for selecting installer type (for which releases will be offered)

get.buildtype.dialog <- function() {
  # Dialog values to update
  # Keep track of whether we're doing a runtime or build installation
  # And which repository, release and installer we've selected

  tt <- tktoplevel()
  tkwm.title(tt, "Set up Installation")

  build.type <- tclVar("Release")                 # Options: Release, Build Release Snapshot, Build Local Clone

  options = c("Release","Build Release Snapshot", "Build Local Clone")

  # Build Type Selector
  combo <- tklistbox(tt, height = length(options), selectmode = "single", exportselection = FALSE)
  for (option in options) {
    tkinsert(combo, "end", option)
  }

  # Installation Type Dialog

  radio_frame <- tkframe(tt)
  radio1 <- tkradiobutton(radio_frame, text = "Pre-Built Release (recommended)", variable = build.type, value = options[1])
  radio2 <- tkradiobutton(radio_frame, text = "Build from Release Code", variable = build.type,         value = options[2])
  radio3 <- tkradiobutton(radio_frame, text = "Build from Local Clone", variable = build.type,          value = options[3])

  tkgrid(radio1,row=0,column=0,padx=5,pady=2,sticky="w")
  tkgrid(radio2,row=1,column=0,padx=5,pady=2,sticky="w")
  tkgrid(radio3,row=2,column=0,padx=5,pady=2,sticky="w")
  tkgrid(radio_frame,row=0,column=0,padx=5,pady=5,sticky="w")

  instructions <- paste(sep="",
    "Select how you would like to install VisionEval.\n\n",
    "* Pre-Built Release, the recommend choice, will show available VisionEval releases for your version of R.\n\n",
    "* Build from Release Code will let you select a (very large) release zip file and run its build script.\n\n",
    "* Build from Local Clone is the preferred way to build VisionEval from the ground up.",
    "You will need to install Git, clone the repository, and check out the branch you would like to build",
    " before re-running this installation script.\n\n",
    "Building from a Local Clone is recommended",
    " if you are planning to make code changes you would like to save or to contribute back to the VisionEval project.\n\n",
    "NOTE: If there is not a pre-built release for your version of R or your operating system, you can still select 'Pre-Built Release' ",
    " but it will require you to build the VisionEval packages.\n\n",
    "For any of the build options on Windows, or if there is no pre-built release available, you will need to have installed RTools.",
    "See the VisionEval online documentation for information on obtaining RTools. Mac OS and Linux usually already have the required tools."
  )

  onOK <- function() tkdestroy(tt)
  onCancel <- function() {
    tclvalue(build.type) <- "Cancel"
    tkdestroy(tt)
  }

  button_frame <- tkframe(tt)
  ok_button <- tkbutton(button_frame, text = "OK", command = onOK)
  cancel_button <- tkbutton(button_frame, text = "Cancel", command = onCancel)
  tkgrid(ok_button, row = 0, column = 0, padx = 5, pady = 5, sticky="w")
  tkgrid(cancel_button, row = 0, column = 1, padx = 5, pady = 5, sticky="w")
  tkgrid(info_button(button_frame,instructions), row = 0, column = 2, padx = 5, pady = 10, sticky="e")
  tkgrid.columnconfigure(button_frame,2,weight = 1)
  tkgrid(button_frame,row=1,column=0,padx=5,pady=5,sticky="ew")
  tkgrid.columnconfigure(tt, 0, weight = 1)

  tkwait.window(tt) # Run the dialog

  return( tclvalue(build.type) )
}

############ Dialog to pick an installer from among those available

# Setup dialog navigates all.releases to select an installer to
# download and install.
# load.install.config is a function taking no arguments
setup.dialog <- function(build.type,all.releases,load.install.config,max_width=800) {
  # Dialog values to update
  # different dialog structure depending on build.type
  # "Release" - the classic dialog, presenting repository, release and installer
  # "Build Release Snapshot" - Will work the same, but the installer will the source code zipball
  # "Build Local Clone" - will just run a directory chooser dialog and complain if the directory
  #    does not have a VE-Bootstrap.R script in it.
  # The buttons at the bottom of this dialog should be "Install", "Cancel", and "?" for help
  # The change build type row just presents the selected build type, and picking its button
  #   actually cancels this dialog and returns "TryAgain" in the selected$DoIt element

  # And which repository, release and installer we've selected
  repository <- tclVar("No Repository")  # List box selector from names(all.releases)
  release <- tclVar("No Release")        # List box selector from names(all.releases[[repository]])
  installer <- tclVar("No Installer")    # List box selector for default installer
  doit <- tclVar("No")                   # Change this if user chooses "Install"

  VEValidClone <- function(dir_path) {
    exists <- dir.exists(dir_path) && length ( dir(dir_path,pattern="VE-Bootstrap.R") ) > 0
  }

  # Here's the GUI driver that shows what has been selected to install and allows
  # the user to pick something different.
  tt <- tktoplevel()
  tkwm.title(tt, "Select Installer")
  tkwm.maxsize(tt, max_width, 10000) # we don't expect to expand vertically

  # Actions to gather information
  runtime_button <- tkbutton(tt, text = "Change Installation Type", command = function() {
    tclvalue(doit) <- "TryAgain"
    tkdestroy(tt)
  })
  tkgrid(runtime_button, column = 0, row = 0, sticky = "e", padx = 5, pady = 5)
  runtime_frame <- tkframe(tt, borderwidth = 2, relief = "groove")
  runtime_label <- tklabel(runtime_frame,text=build.type, justify="left")
  tkpack(runtime_label,anchor="w",padx=5,pady=5)
  tkgrid(runtime_frame, column = 1, row = 0, sticky="ew", padx = 5, pady = 5)

  if ( build.type != "Build Local Clone" ) {
    # Classic Dialog
    tclvalue(repository) <- names(all.releases)[1]
    tclvalue(release) <- names(all.releases[[1]])[1]
    tclvalue(installer) <- names(all.releases[[1]][[1]][["assets"]])[1]

    # Button management
    disable_buttons <- function() {
      tkconfigure(repos_button,state="disabled")
      tkconfigure(release_button,state="disabled")
      tkconfigure(installer_button,state="disabled")
      tkconfigure(repos_config,state="disabled")
    }
    enable_buttons <- function() {
      tkconfigure(repos_button,state="normal")
      tkconfigure(release_button,state="normal")
      tkconfigure(installer_button,state="normal")
      tkconfigure(repos_config,state="normal")
    }

    # Button definitions
    repos_button <- tkbutton(tt, text = "Repository", command = function() {
      disable_buttons()
      repos.list <- names(all.releases)
      if ( length(repos.list) < 2 ) return() # Button does nothing if not enough items

      # Run the selection dialog, then look up the selected release and choose the
      # default installer from that release.
      select.from.list(tt,repository,repos.list) # will update repository variable
      release_list <- all.releases[[tclvalue(repository)]]
      tclvalue(release) <- names(release_list)[1] # reset to first release
      inst_list <- release_list[[tclvalue(release)]][["assets"]]
      tclvalue(installer) <- names(inst_list)[1]
      enable_buttons()
    })

    release_button <- tkbutton(tt, text = "Release", state="normal", command = function() {
      disable_buttons()
      release_list <- names(all.releases[[tclvalue(repository)]])
      if ( length(release_list) < 2 ) return() # Do nothing if too few items

      # If release changes, change the installer to the default one.
      select.from.list(tt,release,release_list) # will update repository variable
      inst_list <- all.releases[[tclvalue(repository)]][[tclvalue(release)]][["assets"]]
      tclvalue(installer) <- names(inst_list)[1]
      enable_buttons()
    })

    installer_button <- tkbutton(tt, text = "Installer", state="normal", command = function() {
      disable_buttons()
      installer_list <- names(all.releases[[tclvalue(repository)]][[tclvalue(release)]][["assets"]])
      if ( length(installer_list) < 2 ) return() # Do nothing if there are too few installers
      select.from.list(tt,installer,installer_list) # will update installer variable
      enable_buttons()
    })

    # Display the buttons-
    tkgrid(repos_button, column = 0, row = 1, sticky = "e", padx = 5, pady = 5)
    tkgrid(release_button, column = 0, row = 2, sticky = "e", padx = 5, pady = 5)
    tkgrid(installer_button, column = 0, row = 3, sticky = "e", padx = 5, pady = 5)
    button_row = 4

    # Display the values set by the buttons in label widgets
    # Put the widgets in frames so they resize nicely
    repos_outer_frame <- tkframe(tt)
    repos_frame <- tkframe(repos_outer_frame, borderwidth = 2, relief = "groove")
    repos_label <- tklabel(repos_frame,textvariable=repository, justify="left")
    repos_config <- tkbutton(repos_outer_frame,text="Add Repositories",state="normal",command = function() {
      disable_buttons()
      changed <- edit.install.config(load.install.config())
      if ( changed == "Yes" ) {
        tclvalue(doit) <- "TryAgain"
        tkdestroy(tt)
      }
      enable_buttons()
    })
    tkgrid(repos_frame,row=0,column=0,sticky="ew",padx=5,pady=5)
    tkgrid(repos_label,row=0,column=0,sticky="w",padx=5,pady=5)
    tkgrid(repos_config,row=0,column=1,padx=5,pady=5) # edit install config button
    tkgrid.columnconfigure(repos_outer_frame,0,weight = 1)
    tkgrid(repos_outer_frame, column = 1, row = 1, sticky="ew", padx = 5, pady = 5)

    release_frame <- tkframe(tt, borderwidth = 2, relief = "groove")
    release_label <- tklabel(release_frame,textvariable=release, justify="left")
    tkpack(release_label,anchor="w",padx=5,pady=5)
    tkgrid(release_frame, column = 1, row = 2, sticky="ew", padx = 5, pady = 5)

    installer_frame <- tkframe(tt, borderwidth = 2, relief = "groove")
    installer_label <- tklabel(installer_frame,textvariable=installer, justify="left")
    tkpack(installer_label,anchor="w",padx=5,pady=5)
    tkgrid(installer_frame, column = 1, row = 3, sticky="ew", padx = 5, pady = 5)

    instructions <- if ( build.type == "Release" ) {
      "Release instructions"
    } else {
      "Build Release Snapshot instructions"
    }
  } else { # Build Local Clone
    tclvalue(repository) <- all.releases[[1]] # set in getReleases to ve.home
    repos_button <- tkbutton(tt, text = "Repository Clone Directory", command = function() {
      tkconfigure(repos_button,state="disabled")
      dir_path <- tclvalue(tkchooseDirectory())
      tclvalue(repository) <- if ( ! VEValidClone(dir_path) ) paste(dir_path,"(Not a clone)") else dir_path
      tkconfigure(repos_button,state="normal")
    })
    tkgrid(repos_button, column = 0, row = 1, sticky = "e", padx = 5, pady = 5)

    repos_frame <- tkframe(tt, borderwidth = 2, relief = "groove")
    repos_label <- tklabel(repos_frame,textvariable=repository, justify="left")
    tkpack(repos_label,anchor="w",padx=5,pady=5)
    tkgrid(repos_frame, column = 1, row = 1, sticky="ew", padx = 5, pady = 5)

    button_row <- 2
    instructions <- "Local clone instructions"
  }

  # OK and Cancel buttons
  onOK <- function() {
    if ( build.type == "Build Local Clone" && ! VEValidClone(tclvalue(repository)) ) {
      tclvalue(doit) <- "TryAgain"
    } else {
      tclvalue(doit) <- "Install"
    }
    tkdestroy(tt)
  }

  onCancel <- function() {
    tclvalue(doit) <- "Cancel"
    tkdestroy(tt)
  }

  button_frame <- tkframe(tt)
  ok_button <- tkbutton(button_frame, text = "Install", command = onOK)
  cancel_button <- tkbutton(button_frame, text = "Cancel", command = onCancel)

  tkgrid(ok_button, row = 0, column = 0, padx = 5, pady = 5, sticky="w")
  tkgrid(cancel_button, row = 0, column = 1, padx = 5, pady = 5, sticky="w")
  tkgrid(info_button(button_frame,instructions), row = 0, column = 2, padx = 5, pady = 10, sticky="e")
  tkgrid.columnconfigure(button_frame,2,weight = 1)
  tkgrid(button_frame,row=button_row,column=0,padx=5,pady=5,sticky="ew")

  tkgrid.columnconfigure(tt, 1, weight = 1) #Make the second column in the main frame expandable.

  # These will only work if the focus is on the TK dialog (which doesn't seem to be able to happen
  # without clicking into the dialog window).
  tkbind(tt, "<Return>", function() {
    onOK()
  })
  tkbind(tt, "i", function() {
    onOK()
  })

  tkfocus(tt)
  tkwait.window(tt) # Run the dialog

  return( # Relay tclVar variables back out to calling environment
    list(
      Runtime=build.type,
      Repos=tclvalue(repository),
      Release=tclvalue(release),      # Ignored for Build Local Clone
      Installer=tclvalue(installer),  # Ignored for Build Local Clone
      DoIt=tclvalue(doit)
    )
  )
}
