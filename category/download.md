---
layout: category
title: Download
excerpt: "How to download and install VisionEval"
---

## [Get VisionEval Here](https://github.com/VisionEval/VisionEval/releases/download/public-2.0/VE-2.0-Installer-Windows-R4.1.2_2022-01-03.zip)

*Version 2.0. 555 Mb download! Packaged for R 4.1.2*

The link above will download a .zip file containing the following:
 - The VisionEval framework code
 - VE-RSPM, VE-RPAT, VE-State, *_Scenarios, and VE-ScenarioViewer 
 - All necessary R packages

Previous versions are [available here](https://github.com/VisionEval/VisionEval-Dev/releases).

*Developers* can find the latest development branch in `development-next` branch of the [VisionEval-Dev](https://github.com/VisionEval/VisionEval-Dev) repository.

## Install for Windows

After installing R 4.1.2 and downloading the VE Installer from the link above, unzip the folder to the destination folder of your choice.

To complete the installation and start VisionEval, simply:
   - Double-click **<tt>VisionEval.Rproj</tt>**

## Getting Started

Once you have been welcomed to VisionEval, you can follow the instructions under "Editing and Running Models" on the
<a href="https://github.com/VisionEval/VisionEval/wiki/Getting-Started-v2#editing-and-running-models">Getting Started</a> page.
Your destination folder contains everything you need from the VisionEval "sources" folder.

## Requirements

If the above installation steps did not succeed, ensure that you have downloaded the appropriate version of VisionEval to match the version of R that you have installed.

#### R

The current version of VisionEval is built for R, 4.1.2.  If you have a different version installed and cannot install 4.1.2, please contact us at <a href="mailto:info@visioneval.org">info@visioneval.org</a> for a VisionEval built for your R version. 

You can find the <a
href="https://cran.r-project.org/bin/windows/base/" target="_blank">R 4.1.2 installer for Windows here</a>.

#### RStudio 

We strongly recomment using <a href="https://www.rstudio.com/products/rstudio/#Desktop" target="_blank">RStudio</a> to work with VisionEval. RStudio is particularly recommended if you plan to clone and explore the
<a target="_blank" href="https://github.com/VisionEval/VisionEval">Visioneval source code from GitHub</a>, and has become the de facto standard for most R users.

#### Mac/Linux users
VisionEval can be installed from source as well. Contact Jeremy Raw for more information on source installations.

## Questions

Questions about VisionEval installation can be directed to Jeremy.Raw or Daniel.Flynn at dot.gov, or more generally to <a href="mailto:info@visioneval.org">info@visioneval.org</a>.

The installers were built with the using the process described <a target="_blank" href="https://github.com/VisionEval/VisionEval-Dev/blob/development/build/Building.md">here on GitHub</a>

<!-- removed between title and excerpt: <span class="entry-date"><time datetime="{{ post.date | date_to_xmlschema }}">{{ post.date | date: "%B %d, %Y" }}</time></span> -->
