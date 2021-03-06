# R_Template

This repository contains R template for analysing data from experiments and surveys and justification to follow certain conventions and structures. This document is available at [https://github.com/tuomaseerola/R_template](https://github.com/tuomaseerola/R_template) and as a rendered html at [https://tuomaseerola.github.io/R_template/](https://tuomaseerola.github.io/R_template/). 

If you do have access to computer able to run the software, you can also start the analysis in RStudio and R as an independent process in a browser by using **Binder**, [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/tuomaseerola/R_template/main?urlpath=rstudio).

## Organisation

The folder structure is described in detail in the report, but it the main purposes of the process are clearly separated into separate folders:

* `/data` Data in read-only format (preferably CSV or TSV format).
* `/munge` All operations to pre-process, recode, or trim data.
* `/scr` All actual R scripts used in the analysis.
* `/figures` Outputs from the scripts
* `/docs` Outputs from the reports

In this repository, `contents.R` will be needed to reproduce the analysis in R. It contains an example of how the different stages, structures and processes in the analysis can be executed in a coherent order and manner (i.e., loading, transforming, screening the data, and then visualising, applying statistical analyses, creating figures, and tables). This is designed as a small tutorial for reproducible research from the perspective of our needs in music and science.

`report.Rmd` will create the report that incorporates comments and the actual analyses and produces either html or pdf file (`report.html`, `report.pdf`) in the `docs` folder.

`runtime.txt` and `install.R` are auxiliary files for Binder and not actually needed in the analysis. 

## Caveat

This repository and the documents cannot be considered as a quick _R tutorial_ or a _statistics tutorial_ but simply a way to explain to PG students and collaborators of how clear analyses schemes can be created, followed, and shared. This has helped us to be productive, minimise errors and speak the same language, even though sharing is usually done internally (Dropbox or OneDrive) and only rarely through Github or OSF. For further tutorials, please seek more information about [reproducibility in science](https://ropensci.github.io/reproducibility-guide/sections/introduction/) and [RStudio online learning pages](https://education.rstudio.com).

Tuomas Eerola, Durham University, UK

