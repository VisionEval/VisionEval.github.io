---
layout: category
title: Download
excerpt: "How to download and install VisionEval"
image:
  feature: so-simple-sample-image-4-narrow.jpg
search_omit: true
---


## <a href="https://github.com/VisionEval/VE-Installer/releases/download/builder-0.2/VE-installer-windows-R3.5.1.zip">Get VisionEval Here</a> 

The link above will download a .zip file from containing the following:
 - The VisionEval framework code
 - VE-RSPM, VE-RPAT, VE-GUI, and VE-ScenarioViewer 
 - All necessary R packages
 
The current version of VisionEval requires R 3.5.1 to be installed on the user's computer (<a href="https://cran.r-project.org/bin/windows/base/release.htm">Windows version here</a>). <a href="https://www.rstudio.com/products/rstudio/#Desktop">RStudio</a> is recommended as a development environment.

This 260 Mb .zip file is built with the VE-Installer, built <a target="_blank" href="https://github.com/VisionEval/VE-Installer">here on GitHub</a>

Advanced users can get VisionEval also by cloning the working version of the
 <a target="_blank" href="https://github.com/VisionEval/VisionEval">VisionEval repository on GitHub</a>.
 
 
## Install

After downloading, unzip the folder to any destination on your computer.

Then either:
- Double-click Install-VisionEval.bat from that folder, and follow the instruction (Windows users).
- Double-click RunVisionEval.RData to launch R running VisionEval

- Start R / RStudio
	- Use File / Change dir... to navigate to the folder where you unzipped the installer
	- Enter the R function call: <tt>source("Install-VisionEval.R")</tt> to install
	- Run the VisionEval startup R script: <tt>load("RunVisionEval.Rdata")</tt> to start VisionEval
	- You will see <tt>"Welcome to VisionEval!"</tt> at the end of the R startup message stream if everything went well.
	- After that, you can the <a href="https://github.com/gregorbj/VisionEval/wiki/Getting-Started">Getting Started</a> instructions, or use the convenience functions <tt>vegui()</tt>, <tt>verpat()</tt> or <tt>verspm()</tt>.


<!-- removed between title and excerpt: <span class="entry-date"><time datetime="{{ post.date | date_to_xmlschema }}">{{ post.date | date: "%B %d, %Y" }}</time></span> -->