---
layout: category
title: Download
excerpt: "How to download and install VisionEval"
---

## [Get VisionEval Here](https://github.com/VisionEval/VisionEval-Dev/releases/download/V.2.0-Pre-Release_2020-10-21/VE-Installer-Windows-R4.0.2_2020-10-21.zip)

*Note: Version 2.0 pre-release. 534 Mb download! Packaged for R 4.0.2*

The link above will download a .zip file containing the following:
 - The VisionEval framework code
 - VE-RSPM, VE-RPAT, VE-State, *_Scenarios, and VE-ScenarioViewer 
 - All necessary R packages

Previous versions are [available here](https://github.com/VisionEval/VisionEval-Dev/releases).

## Install for Windows

After installing R 4.0.2 and downloading the VE Installer from the link above, unzip the folder to the destination folder of your choice.

To complete the installation and start VisionEval, simply:
   - Double-click **<tt>VisionEval.Rproj</tt>**

## Getting Started

Once you have been welcomed to VisionEval, you can follow the instructions under "Editing and Running Models" on the
<a href="https://github.com/VisionEval/VisionEval/wiki/Getting-Started-v2#editing-and-running-models">Getting Started</a> page.
Your destination folder contains everything you need from the VisionEval "sources" folder.

## Requirements

If the above installation steps did not succeed, ensure that you have downloaded the appropriate version of VisionEval to match the version of R that you have installed.

#### R

<strong>NOTE:</strong>This currently downloads from the `VisionEval-Dev` repository; the official version 2.0 will be released on `VisionEval` when all documentation is complete.

This release (current as of 2021-10-21) provides a VisonEval pre-release installer for the Version 2.0 version. The final Version 2.0, when it is released to the "master" branch and to the main VisionEval repository, will probably be identical to this pre-release.

Remaining work prior to finalizing the 2.0 release includes getting all the Website and Wiki documentation consistent with the code as released.

The current version of VisionEval is built for R, 4.0.2.  If you have a different version installed and cannot install 4.0.2, please contact us at <a href="mailto:info@visioneval.org">info@visioneval.org</a> for a VisionEval built for your R version. 

You can find the <a
href="https://cran.r-project.org/bin/windows/base/old/4.0.2/R-4.0.2-win.exe" target="_blank">R 4.0.2 installer for Windows here</a>.

#### RStudio 

We strongly recomment using <a href="https://www.rstudio.com/products/rstudio/#Desktop" target="_blank">RStudio</a> to work with VisionEval. RStudio is particularly recommended if you plan to clone and explore the
<a target="_blank" href="https://github.com/VisionEval/VisionEval">Visioneval source code from GitHub</a>, and has become the de facto standard for most R users.

#### Mac/Linux users
VisionEval can be installed from source as well. Contact Jeremy Raw for more information on source installations.

## Questions

Questions about VisionEval installation can be directed to Jeremy.Raw or Daniel.Flynn at dot.gov, or more generally to <a href="mailto:info@visioneval.org">info@visioneval.org</a>.

The installers were built with the using the process described <a target="_blank" href="https://github.com/VisionEval/VisionEval-Dev/blob/development/build/Building.md">here on GitHub</a>

<!-- removed between title and excerpt: <span class="entry-date"><time datetime="{{ post.date | date_to_xmlschema }}">{{ post.date | date: "%B %d, %Y" }}</time></span> -->
