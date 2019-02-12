---
layout: category
title: Download
excerpt: "How to download and install VisionEval"
image:
  feature: so-simple-sample-image-4-narrow.jpg
---

## [Get VisionEval Here](https://www.dropbox.com/s/hn3386ge2ajg4rz/VE-installer-windows-R3.5.1.zip?dl=1)
**Warning** This Download is approximately **515 Megabytes** (Humongous!)

The link above will download a .zip file containing the following:
 - The VisionEval framework code
 - VE-RSPM, VE-RPAT, VE-GUI, and VE-ScenarioViewer 
 - All necessary R packages

The current version of VisionEval requires R 3.5.1 to be installed on your computer.  You can find the <a
href="https://cran.r-project.org/bin/windows/base/old/3.5.1/" target="_blank">R 3.5.1 installer for Windows here</a>.

Many users find that <a href="https://www.rstudio.com/products/rstudio/#Desktop" target="_blank">RStudio</a> is a better version of the
standard R interface.  Rstudio is particularly recommended if you plan to clone and explore the
<a target="_blank" href="https://github.com/VisionEval/VisionEval">Visioneval source code from GitHub</a> .

## Install

After installing R 3.5.1 and downloading the VE Installer from the link at the top, unzip the folder to the destination folder of your choice.

To complete the installation and start VisionEval, do the following:

   1. Start R / RStudio
   1. Use File / Change dir... to navigate to the destination folder (where you unzipped the installer)
   1. Enter (or copyA) the following instructions one by one in the R command window:<br/>
     `source("Install-VisionEval.R")`<br/>
     `load("RunVisionEval.Rdata")`
   1. You will see `Welcome to VisionEval!` at the end of the R startup message stream if everything went well.

## Getting Started

Once you have been welcomed to VisionEval, you can follow the instructions under "Running VE Models" on the
<a href="https://github.com/VisionEval/VisionEval/wiki/Getting-Started">Getting Started</a> page.
Your destination folder contains everything you need from the VisionEval "sources" folder.

The installation also creates some convenience functions which will run the model test scenarios or start the VE GUI:
 - <tt>vegui()</tt> to start the GUI (navigate to your destination folder to find the scenario run scripts)
 - <tt>verpat()</tt> for the VERPAT test model
 - <tt>verpat(scenarios=TRUE)</tt> to run multiple scenarios in VERPAT
 - <tt>verpat(baseyear=TRUE)</tt> to run the alternate VERPAT sample scenario
 - <tt>verspm()</tt> for the VERSPM test model
 - <tt>verspm(scenarios=TRUE)</tt> to run multiple scenarios in VERSPM

### Multiprocess Version

The download link above will install and run VisionEval without administrator privileges following the instructions above.
However certain functions in the GUI may not operate correctly (e.g. status of running models).  For full
functionality, you will need the ["multiprocess" version available
here](https://www.dropbox.com/s/v8ijhdau334pyvj/VE-installer-windows-multi-R3.5.1.zip?dl=1).  In many enterprise
environments, the multiprocess version cannot run at all without administrative rights to configure the Windows firewall.

Questions about VisionEval installation can be directed to Jeremy.Raw or Daniel.Flynn at dot.gov.

The installer and this website were built with the VE-Installer, which is <a target="_blank" href="https://github.com/VisionEval/VE-Installer">available on GitHub</a>

<!-- removed between title and excerpt: <span class="entry-date"><time datetime="{{ post.date | date_to_xmlschema }}">{{ post.date | date: "%B %d, %Y" }}</time></span> -->
