---
layout: category
title: Download
excerpt: "How to download and install VisionEval"
image:
  feature: so-simple-sample-image-4-narrow.jpg
---

## [Get VisionEval Here](https://github.com/VisionEval/VisionEval/releases/download/v0.1/VE-installer-windows-R3.5.2.2019-03-11.zip)

*Note: 600 Mb download!*

The link above will download a .zip file containing the following:
 - The VisionEval framework code
 - VE-RSPM, VE-RPAT, VE-GUI, VE-State and VE-ScenarioViewer 
 - All necessary R packages

## Install for Windows

After installing R 3.5.2 and downloading the VE Installer from the link at the top, unzip the folder to the destination folder of your choice.

To complete the installation and start VisionEval, simply:
   - Double-click **<tt>VisionEval.bat</tt>**

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


## Requirements

If the above installation steps did not succeed, ensure that you have downloaded the appropriate version of VisionEval to match the version of R that you have installed.

#### R
The current version of VisionEval works best with R 3.5.2 to be installed on your computer.  If you currently have another version of R installed, you can go to the [GitHub release page](https://github.com/VisionEval/VisionEval/releases) to download VisionEval for R 3.4.4 or 3.5.1.

You can find the <a
href="https://cran.r-project.org/bin/windows/base/old/3.5.2/" target="_blank">R 3.5.2 installer for Windows here</a>.

#### RStudio (optional)
Many users find that <a href="https://www.rstudio.com/products/rstudio/#Desktop" target="_blank">RStudio</a> is a better version of the
standard R interface.  RStudio is particularly recommended if you plan to clone and explore the
<a target="_blank" href="https://github.com/VisionEval/VisionEval">Visioneval source code from GitHub</a> .

## Questions

Questions about VisionEval installation can be directed to Jeremy.Raw or Daniel.Flynn at dot.gov.

The installer and this website were built with the VE-Installer, which is <a target="_blank" href="https://github.com/VisionEval/VE-Installer">available on GitHub</a>

<!-- removed between title and excerpt: <span class="entry-date"><time datetime="{{ post.date | date_to_xmlschema }}">{{ post.date | date: "%B %d, %Y" }}</time></span> -->
