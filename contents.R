# contents.R
# Part of R_template by Tuomas Eerola, https://github.com/tuomaseerola/R_template/
#
# R template with actual data from Annaliese Grimaud's experiment (a validation study of the expression in music)
# Data collected 2019-2020 by Annaliese Grimaud in her PhD project at Durham University.
#
# Template updated 2/2/2021

#### INITIALISE: SET PATH, CLEAR MEMORY AND LOAD LIBRARIES -----------------------------------
#setwd('~/Desktop/tutorial/exp3_StimuliRevalidationStudy/')
rm(list=ls(all=TRUE))                     # Cleans the R memory, just in case
source('scr/load_libraries.R')            # Loads the necessary R libraries

#### READ data (from Qualtrics TSV)  ---------------------------------------------------------
source('scr/read_data_survey.R')          # Produces data matrix v with a lot of variables

#### MUNGE data (preprocess, recode, etc.)  --------------------------------------------------
source('munge/rename_variables.R')        # Renames most of the columns in the v
source('munge/recode_instruments.R')      # Produces df from v that contains all data in long form

#### DIAGNOSE data ---------------------------------------------------------------------------
source('scr/demographics_info.R')         # Reports the N and Age and musical expertise
source('scr/interrater_reliability.R')    # Runs quality checks, response speed, reliability
source('scr/visualise.R')                 # Visualizes few aspects of the data

#### ANALYSE data ---------------------------------------------------------------------------
source('scr/compare_means.R')             # Compares Sources and Tracks across Emotion Scales
source('scr/table1.R')                    # Creates an example table (means and variance of sadness)
source('scr/figure1.R')                   # Creates Figure 1 for manuscript

print("All scripts completed")
