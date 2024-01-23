---
layout: category
title: Download
excerpt: "How to download and install VisionEval"
---

## Get VisionEval Here (The next release is under construction; please check back shortly)

*Version 3.1. 468 Mb download! Packaged for R 4.3.2*

The link above will download a .zip file containing the following:
 - The VisionEval framework code
 - VE-RSPM, VE-RPAT, and VE-State sample models
 - All necessary R packages

Other R versions for the latest release are [available here](https://github.com/VisionEval/VisionEval-Dev/releases/latest) (Scroll down to the Assets section).
Installers for older releases can [also be found on Github](https://github.com/VisionEval/VisionEval-Dev/releases).

*Developers* can find the latest development branch in the `development` branch of the [VisionEval-Dev](https://github.com/VisionEval/VisionEval-Dev) repository.

## Install for Windows

You can find complete instructions in the [VisionEval Getting Started documentation]({{ site.url }}/docs/getting-started.html)
You will first need to install a supported version of R and (if you can RStudio).

After installing R (see *Requirements* below) and downloading the corresponding VE Installer for that R version from the link above, unzip the folder to the destination folder of your choice.

To complete the installation and start VisionEval with RStudio, simply:
   - Double-click **<tt>VisionEval.Rproj</tt>**

You can also start VisionEval in the standard R GUI by double-clicking <tt>launch.bat</tt>.
Please see [further setup instructions]({{ site.url }}/docs/getting-started.html#starting-visioneval-from-the-rgui ) if <tt>launch.bat</tt> seems not to work.

## Getting Started

Once you have been welcomed to VisionEval, you can follow the instructions under "Editing and Running Models" on the [Getting Started]({{ site.url }}/docs/getting-started.html#editrun) page.
Your destination folder contains everything you need from the VisionEval "sources" folder.

## Requirements

If the above installation steps did not succeed, ensure that you have downloaded the appropriate version of VisionEval to match the version of R that you have installed.

#### R

The current version of VisionEval is built for recent versions of R.  If you have a different version installed and cannot install one of the supported versions, please contact <a href="mailto:jeremy.raw@dot.gov">Jeremy Raw</a>.
You can [get R here](https://cran.r-project.org).

#### RStudio

We recommend using <a href="https://www.rstudio.com/products/rstudio/#Desktop" target="_blank">RStudio</a> to work with VisionEval. RStudio is particularly recommended if you plan to clone and explore the
<a target="_blank" href="https://github.com/VisionEval/VisionEval">Visioneval source code from GitHub</a>, and it is very popular among regular R users.

#### Mac/Linux users
VisionEval can be installed from source as well. Contact <a href="mailto:jeremy.raw@dot.gov">Jeremy Raw</a> for more information on source installations.

## Questions

Questions about VisionEval installation can be directed to Jeremy.Raw or Scott.Smith at dot.gov, or more generally to <a href="mailto:jeremy.raw@dot.gov">jeremy.raw@dot.gov</a>.

The installers were built using the process described <a target="_blank" href="https://github.com/VisionEval/VisionEval-Dev/blob/development/build/Building.md">here on GitHub</a>

<!-- removed between title and excerpt: <span class="entry-date"><time datetime="{{ post.date | date_to_xmlschema }}">{{ post.date | date: "%B %d, %Y" }}</time></span> -->
