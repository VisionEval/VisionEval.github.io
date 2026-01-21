---
layout: category
title: Download
excerpt: "How to download and install VisionEval"
---

## Try the new installer script mechanism.

Copy the following line of code to an instance of R with its working directory set to where you want to install
VisionEvel.

If you would like to review the script before running it,
just [visit it in your browser](https://visioneval.github.io/assets/install/VE4-install.R).

{% include codeHeader.html %}
```R
source(ve.url<-"https://visioneval.github.io/assets/install/VE4-install.R")
```

The one-liner will download and run the VisionEval 4 installer script. The script will retrieve
VisionEval packages from a selected VisionEval GitHub release (default: the latest release). There
are a couple of different installation options you can pick from (default: install binary VisionEval
packages for Windows). Pre-built packages are currently only available for Windows R 4.4.0 and later
versions.

## Install for Windows

VisionEval should start automatically after you finish the installation. If you chose one of the
source code installations (downloading a snapshot or using a local clone) you will still need to
run `ve.build()` (with RTools installed) to create a runnable version, then do `ve.run()` to start it.

Once you have a running version, the folders you set up as your "VE_HOME" (location of VisionEval
code) and "VE_RUNTIME" (location of VisionEval models) will contain startup files to launch
VisionEval with your version of R. Navigate to either of these folders, then double click
one of the startup files:

  - `launch_RX.Y.bat` to launch the standard R GUI with VisionEval
  - `Startup.Rdata` to launch R by its automatic association with an .Rdata file (but that may not work right
    if you have multiple versions of R installed and the R version that launches automatically does
    not have VisionEval installed)
  - `VisionEval.Rproj` to launch RStudio with VisionEval running (you'll need to have RStudio installed of course)

## Getting Started

Once R starts and you have been welcomed to VisionEval, you can follow the instructions under
"Workflow" and "Editing and Running Models" on the
[Getting Started]({{site.url}}/docs/getting-started.html#editrun) page.

## Requirements

#### R

The current version of VisionEval is built for recent versions of R (R 4.4 and later). If you have a
different version installed and cannot install one of the supported versions (and if you can't or
don't want to do the full build yourself), please contact <a href="mailto:info@visioneval.org">the
VisionEval support team</a>. You can [get R here](https://cran.r-project.org).

#### RStudio

Many people find the <a href="https://posit.co/download/rstudio-desktop/" target="_blank">RStudio</a> development
environment convenient for working with VisionEval.

RStudio is particularly recommended if you plan to clone and explore the
<a target="_blank" href="https://github.com/VisionEval/VisionEval-4">Visioneval source code from GitHub</a>,
and it is very popular among regular R users.

#### Mac/Linux users
VisionEval can be installed from source as well. Contact <a href="mailto:info@visioneval.org">the
VisionEval support team</a> for more information on source installations. It's a tedious process,
but should work provided you have a capacious server (probably 16Gb RAM needed) and the patience to
incrementally install quite a few operating system packages.

## Questions

Questions about VisionEval installation can be directed to <a href="mailto:info@visioneval.org">the
VisionEval support team</a>

The installers were built using the process described
<a target="_blank" href="https://github.com/VisionEval/VisionEval-4">in the README.md file on GitHub</a>

<!-- removed between title and excerpt: <span class="entry-date"><time datetime="{{ post.date | date_to_xmlschema }}">{{ post.date | date: "%B %d, %Y" }}</time></span> -->
