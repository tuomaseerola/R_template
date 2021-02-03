# Readme: R_Template

These files contains R template for analysing data from experiments and surveys and justification to follow certain conventions and structure. This document is available at [https://github.com/tuomaseerola/R_template](https://github.com/tuomaseerola/R_template). This can also be started as an independent process at binder, [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/tuomaseerola/R_template/main?urlpath=rstudio).

`contents.R` will be needed to reproduce the analysis. It is an example of how the different structures and processes in the analysis can be executed (loading, transforming, screening the data, visualising, applying statistical analyses).


The folder structure I advocate for clarity is describe in detail in the report, but it should have:

* `/data`
* `/munge`
* `/figures`
* `/scr`

`report.Rmd` will create the report that incorporates comments and the actual analyses and produces either html or pdf file (`report.html`, `report.pdf`).

This repository and the documents are not a quick _R tutorial_ nor _statistics tutorial_ but simply a way to explain to PG students and collaborators of how clear analyses schemes can be created, followed, and shared.

Tuomas Eerola, Durham University, UK

