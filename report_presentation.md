<style>
.reveal h1, .reveal h2, .reveal h3 {
  word-wrap: normal;
  -moz-hyphens: none;
}
.footer {
    color: black;
    background: #E8E8E8;
    position: fixed;
    top: 90%;
    text-align:center;
    width:100%;
}
.exclaim .reveal .state-background {
  background: lightskyblue;
} 
.exclaim .reveal h1,
.exclaim .reveal h2,
.exclaim .reveal p {
}
.small-code pre code {
  font-size: 1em;
}
</style>

<style>
div.blue { background-color:#e6f0ff; border-radius: 5px; padding: 20px;}
</style>



Data analysis I: Basics
========================================================
author: Tuomas Eerola
date: 22/11/2021
autosize: true
font-family: 'Helvetica'
R_template and tutorial in R
========================================================


Assumes that you have 
- _RStudio_
- Basic understanding of _RStudio_ workspace, path, and environment (Chapter 6.5 in _Scientific Musicology_) 
- the materials downloaded from [https://github.com/tuomaseerola/R_template](https://github.com/tuomaseerola/R_template) 
  * Tip 1: use the green "Code" button to "Download zip" file
  * Tip 2: extract this into a convenient location on your computer and open `contents.R` with _RStudio_

**White slides** refer to the `contents.R` 

**Blue slides** refer to questions to you 

These slides are available at: [https://tuomaseerola.github.io/R_template/report_presentation.html](https://tuomaseerola.github.io/R_template/report_presentation.html)


Initialise the analysis
========================================================
class: small-code


```r
## INITIALISE: SET PATH, CLEAR MEMORY AND LOAD LIBRARIES
rm(list=ls(all=TRUE))                 # Cleans the R memory, just in case
source('scr/load_libraries.R')        # Loads the necessary R libraries
```

If you get errors at this stage with new installation of R, they might refer to the special libraries that were loaded or installed in `libraries.R`. This script should install the required libraries for you such as `ggplot2`, but there might be issues with your particular setup.

Question: What are packages? (1)
========================================
type: exclaim

* Why R utilises separate **packages** (libraries in your system)?
* There are 18,419 of these in [CRAN](https://cran.r-project.org)
* Popular ones are
  * `ggplot2`, A grammar of graphics in R
  * `dplyr`, a grammar of data manipulation
  * `tidyr`, a collection of package development tools
  * `foreign`, read data stored by Minitab, S, SAS, SPSS
  
Question: What are packages? (2)
========================================
type: exclaim
class: small-code

To check what you might already have in your _R_, type:

```r
search()
```

```
 [1] ".GlobalEnv"        "package:pbkrtest"  "package:emmeans"  
 [4] "package:lmerTest"  "package:lme4"      "package:Matrix"   
 [7] "package:tidyr"     "package:stringr"   "package:reshape2" 
[10] "package:dplyr"     "package:psych"     "package:ggplot2"  
[13] "package:knitr"     "package:stats"     "package:graphics" 
[16] "package:grDevices" "package:utils"     "package:datasets" 
[19] "package:methods"   "Autoloads"         "package:base"     
```
If you don't have a library installed, just type


```r
install.packages("ggplot2")
```
After installation, you can load the library for your project with 

```r
library(ggplot2)
```
Question: What are packages? (3)
========================================
type: exclaim

![Installation vs library (Analogy and image credit to Dianne Cook of Monash University.)](install_vs_library.jpeg)

Load, preprocess and diagnose
========================================================
class: small-code

All these operations are sometimes called _data carpentry_.

```r
## READ data
source('scr/read_data_survey.R')      # Produces data frame v 
```

```
N x Variables:119 131
```

Question: What is the script doing?
========================================
type: exclaim
class: small-code

This is the only line that matters with `read_data_survey.R`:


```r
v <- read.csv('data/Emotion_Identification_N119_noheader.tsv', header=TRUE, sep = "\t")
```

* note how `folder` and `filename` is specified. Adopt a good filenaming convention for your files. No spaces, and clearly label the status of the data (date or N). 
* see `header`
* separator (if not specified, assumes comma-separation)
* <span style="color:red;">DANGER: file-encoding can be a problem</span> (<span style="color:green;">_UTF-8_ is safe</span>)

Question: What if the data is in Excel?
========================================
type: exclaim
class: small-code

If you have the data in an Excel file, you can either 
* convert these into CSV or TSV or 
* utilise `readxl` library and then run:


```r
library(readxl)
v <- read_excel('my_data.xlsx')
```

* `read_excel` has a lot of options (read specific sheets etc.)
* <span style="color:red;">DANGER: Excel files have known deficiencies (date conventions, support for a limited number of columns, version differences, and it is a proprietary format)</span>
  
Question: What is the structure of the data at this point?
===================================
type: exclaim

### 1 What is the size of the data?

### 2. What variables we have? 

### 3. What type of variables we have?

### 4. What do we infer from the column names?

Useful commands: `dim`, `head`, `str`, `is.na`, `View`.


```r
#head(v)
```


Data munging
========================================
In the next step this raw data will be munged, that is, pre-processed in several ways. Pre-processing can have multiple steps, here these have broken into two:

1. First operation carries out a long list of renaming the variables (columns in the data, `rename_variables.R`). This can be avoided if the data has these names already, and it is quite useful to try to embed meaningful variables names to the data collection (coding them into the experiment or into the survey and especially if you use manually input the data). 

```r
source('munge/rename_variables.R')        # Renames the columns of the v
```

What happened in this munging
========================================
type: exclaim
class: small-code

* Can you explain the main changes from the raw data?

Here's an extract of `rename_variables.R`

```r
#### 1. Rename variable headers ---------------------------------------------------
colnames(v)[colnames(v)=="Duration..in.seconds."]<-"Time"
colnames(v)[colnames(v)=="Q3"]<-"Age"
colnames(v)[colnames(v)=="Q4"]<-"Gender"
# .... 

# Note:
# Track rating renamed, where OG = original track and PT = participants' track
# Middle number is number of track, and emotion names at end are the different emotion rating scales

colnames(v)[colnames(v)=="Q14_1"]<-"OG_01_SADNESS"
colnames(v)[colnames(v)=="Q14_2"]<-"OG_01_CALMNESS"
colnames(v)[colnames(v)=="Q14_3"]<-"OG_01_JOY"
```

Recode instruments (1): Trim unnecessary variables and tidy up
====================================
class: small-code


```r
source('munge/recode_instruments.R')      # Produces df (long-form) from v
```

So plenty of things happen in the `recoding_instruments.R`. Let's look inside the script.

### 1. Trim variables

The script will drop all columns mentioned in the `select` command; they are mentioned with negative (-) in from of them, means dropping. 

```r
# eliminating unnecessary columns
v <- dplyr::select(v,-StartDate,-EndDate,-Status,-IPAddress,-Progress,-RecordedDate,-ResponseId,-RecipientLastName,-RecipientFirstName,-RecipientEmail,-ExternalReference,-LocationLatitude,-LocationLongitude,-DistributionChannel,-UserLanguage,-Q1,-Q12_1, -Q12_2, -Q12_3, -Q12_4, -Q12_5, -Q12_6, -Q12_7)
```
Recode instruments: Add IDs
====================================
class: small-code

For convenience, add participant ID's

```r
v$ID <- c(1:length(v$Age)) # Status = dataframe length
v$PID <- paste("S",sprintf("%03d", v$ID),sep="")
v$PID<-factor(v$PID)
ind<-colnames(v)!='ID'
v <- v[, ind]  ## Delete ID and just retain PID
head(v)
```

Recode instruments: Turn categorical vars into labelled factors
====================================
class: small-code

This is done to increase clarity. And helps any future analysis as well.

```r
v$Gender <- factor(v$Gender,levels=c(1,2,3),labels = c('Male','Female','Other'))
v$MusicalExpertise <- factor(v$MusicalExpertise,levels = c(1,2,3,4,5,6),
                             labels = c("NonMusician","Music-Loving NonMusician",
                                        "Amateur","Serious Amateur Musician","Semi-Pro","Pro"))
v$MusicalExpertiseBinary<-factor(v$MusicalExpertise,
                                 levels = levels(v$MusicalExpertise),
                                 labels=c('Nonmusician','Nonmusician','Musician','Musician','Musician','Musician'))
```

Recode instruments: Eliminate incomplete responses
====================================
class: small-code

Here we first created a row to identify the NAs (missing values) in the dataset, 
afterwards we created a threshold of 95% completion rate. If participants completed 
more than 95% of the survey, we keep them.


```r
v$NAS <- rowSums(is.na(v[, 11:108]))
NAS <- 100 - (v$NAS/nrow(v))*100
threshold <- 95
good_ones <- NAS >= threshold
v <- v[good_ones, ]
v <- v[,1:110] # drop NAS 
print(paste('Trimmed data: N=',nrow(v)))
```

```
[1] "Trimmed data: N= 91"
```

```r
head(v)
```

```
  Time Finished Age Gender Country         MusicalExpertise PreferredGenre
1  628        1  26 Female     107 Serious Amateur Musician      Classical
2 2700        1  22   Male     185              NonMusician      Indie Pop
3  922        1  55 Female     185                      Pro      Classical
4  792        1  29 Female     107 Music-Loving NonMusician            Pop
5 5963        1  26 Female       9                 Semi-Pro            pop
6 1500        1  36   Male     185 Music-Loving NonMusician      Indie pop
  InstrumentPlayer                   Instrument MusicalTraining OG_01_SADNESS
1               35                        Piano              13             6
2               36                                                          6
3               35 Piano, flute, voice, violin               50             5
4               36                                                          4
5               35                        piano              22             6
6               36                                                          5
  OG_01_CALMNESS OG_01_JOY OG_01_ANGER OG_01_FEAR OG_01_POWER OG_01_SURPRISE
1              4         1           1          3           1              1
2              1         1           1          3           1              1
3              4         1           1          1           1              3
4              4         1           3          3           1              1
5              6         3           3          1           1              1
6              3         1           1          1           1              1
  OG_02_SADNESS OG_02_CALMNESS OG_02_JOY OG_02_ANGER OG_02_FEAR OG_02_POWER
1             1              3         6           1          3           3
2             1              5         6           1          1           1
3             1              3         6           1          1           5
4             1              1         6           1          1           6
5             1              1         6           1          1           5
6             1              1         6           1          1           1
  OG_02_SURPRISE OG_03_SADNESS OG_03_CALMNESS OG_03_JOY OG_03_ANGER OG_03_FEAR
1              4             1              6         4           1          1
2              1             3              4         1           1          1
3              3             3              6         3           1          1
4              3             1              6         3           1          1
5              6             5              5         4           1          1
6              1             1              4         1           1          1
  OG_03_POWER OG_03_SURPRISE OG_04_SADNESS OG_04_CALMNESS OG_04_JOY OG_04_ANGER
1           3              1             3              1         1           5
2           1              1             1              1         1           6
3           1              1             1              1         1           4
4           1              1             3              4         1           4
5           3              3             4              4         1           5
6           1              1             1              1         1           4
  OG_04_FEAR OG_04_POWER OG_04_SURPRISE OG_05_SADNESS OG_05_CALMNESS OG_05_JOY
1          4           5              3             1              1         4
2          3           3              1             1              1         1
3          3           6              3             3              1         1
4          4           1              1             1              3         1
5          5           6              6             4              1         1
6          6           3              1             1              1         1
  OG_05_ANGER OG_05_FEAR OG_05_POWER OG_05_SURPRISE OG_06_SADNESS
1           3          5           6              3             3
2           1          3           5              1             1
3           6          4           5              4             1
4           1          3           1              1             1
5           6          6           5              6             1
6           1          4           1              5             1
  OG_06_CALMNESS OG_06_JOY OG_06_ANGER OG_06_FEAR OG_06_POWER OG_06_SURPRISE
1              1         1           4          4           4              1
2              1         3           1          1           4              3
3              1         3           4          1           5              1
4              1         4           1          1           5              4
5              1         1           5          5           5              5
6              1         1           1          3           1              3
  OG_07_SADNESS OG_07_CALMNESS OG_07_JOY OG_07_ANGER OG_07_FEAR OG_07_POWER
1             4              3         4           3          3           4
2             4              5         1           1          1           1
3             3              3         3           4          3           6
4             3              5         3           1          1           4
5             5              3         3           3          4           5
6             3              1         1           1          3           3
  OG_07_SURPRISE PT_01_SADNESS PT_01_CALMNESS PT_01_JOY PT_01_ANGER PT_01_FEAR
1              4             5              3         1           1          3
2              4             1              3         3           1          1
3              5             6              5         1           1          1
4              1             6              4         1           3          4
5              5             5              5         3           3          4
6              3             5              3         1           1          1
  PT_01_POWER PT_01_SURPRISE PT_02_SADNESS PT_02_CALMNESS PT_02_JOY PT_02_ANGER
1           5              1             3              3         5           1
2           3              1             1              3         6           1
3           4              1             1              3         5           3
4           1              1             1              1         6           1
5           3              5             1              3         5           3
6           1              1             1              1         5           1
  PT_02_FEAR PT_02_POWER PT_02_SURPRISE PT_03_SADNESS PT_03_CALMNESS PT_03_JOY
1          1           4              4             4              6         5
2          1           1              3             1              5         1
3          1           5              3             1              5         4
4          1           5              4             1              6         3
5          1           5              5             5              5         4
6          1           3              3             3              1         3
  PT_03_ANGER PT_03_FEAR PT_03_POWER PT_03_SURPRISE PT_04_SADNESS
1           1          1           6              1             3
2           1          1           3              1             1
3           1          1           4              1             4
4           1          1           3              1             3
5           3          3           4              1             5
6           1          1           1              1             1
  PT_04_CALMNESS PT_04_JOY PT_04_ANGER PT_04_FEAR PT_04_POWER PT_04_SURPRISE
1              1         3           3          4           4              1
2              1         1           3          1           6              1
3              3         1           3          5           4              4
4              1         1           4          5           1              1
5              1         5           5          5           5              5
6              1         1           1          4           1              3
  PT_05_SADNESS PT_05_CALMNESS PT_05_JOY PT_05_ANGER PT_05_FEAR PT_05_POWER
1             3              3         5           4          5           5
2             1              1         1           1          6           1
3             4              4         3           1          6           4
4             1              4         4           1          1           4
5             4              3         3           5          5           5
6             1              1         1           1          3           3
  PT_05_SURPRISE PT_06_SADNESS PT_06_CALMNESS PT_06_JOY PT_06_ANGER PT_06_FEAR
1              4             1              3         6           1          1
2              1             1              1         1           3          1
3              3             1              4         5           1          1
4              3             1              4         3           1          1
5              6             5              4         3           4          3
6              3             1              3         5           1          1
  PT_06_POWER PT_06_SURPRISE PT_07_SADNESS PT_07_CALMNESS PT_07_JOY PT_07_ANGER
1           4              3             3              1         6           1
2           4              1             1              1         6           1
3           4              1             3              1         1           1
4           3              3             1              3         4           1
5           1              4             4              1         5           4
6           1              1             1              1         5           1
  PT_07_FEAR PT_07_POWER PT_07_SURPRISE PID MusicalExpertiseBinary
1          3           5              4  S1               Musician
2          1           1              3  S2            Nonmusician
3          1           5              6  S3               Musician
4          1           4              4  S4            Nonmusician
5          1           5              6  S5               Musician
6          1           4              1  S6            Nonmusician
```

Recode instruments: Convert into long-format
====================================
class: small-code

Pull out emotions and tracks from the data (convert to long-form) and collapse across all 14 tracks. 

```r
df <- pivot_longer(v,cols = 11:108) # These are the columns with ratings
df$Track<-df$name
df$Track <- gsub("[A-Z][A-Z]_", "", df$Track) #function to substitute every "_POWER" with "" in df$variable
df$Track <- gsub("_[A-Z]+$", "", df$Track) #function to substitute every "_POWER" with "" in df$variable

df$Source <- gsub("_[0-9][0-9]_[A-Z]+$", "", df$name) # take out source (OG and PTs ie own vs participant generated)
df$Scale <- gsub("[A-Z][A-Z]_[0-9][0-9]_", "", df$name) # take out scale

df$Track<-factor(df$Track,levels = c('01','02','03','04','05','06','07'),labels = c('Sadness','Joy','Calmness','Anger','Fear','Power','Surprise'))
df$Source<-factor(df$Source,levels = c('OG','PT'),labels = c('Exp1','Exp2'))

colnames(df)[colnames(df)=='value']<-'Rating'
df$Rating <- dplyr::recode(df$Rating, `1` = 1L, `3` = 2L, '4' = 3L, '5' = 4L, '6' = 5L) #  "1" = "1", "3" = "2", "4" = "3", "5"="4", "6" = "5
df$Scale<-factor(df$Scale)
df$PreferredGenre<-factor(df$PreferredGenre)
```

Recode instruments: Drop unnecessary columns
====================================
class: small-code

Finally we have a clean final data frame on long format.













```
processing file: report_presentation.Rpres
Quitting from lines 296-298 (report_presentation.Rpres) 
Error: Can't subset columns that don't exist.
x Column `variable` doesn't exist.
Backtrace:
     █
  1. ├─knitr::knit(...)
  2. │ └─knitr:::process_file(text, output)
  3. │   ├─base::withCallingHandlers(...)
  4. │   ├─knitr:::process_group(group)
  5. │   └─knitr:::process_group.block(group)
  6. │     └─knitr:::call_block(x)
  7. │       └─knitr:::block_exec(params)
  8. │         └─knitr:::eng_r(options)
  9. │           ├─knitr:::in_dir(...)
 10. │           └─knitr:::evaluate(...)
 11. │             └─evaluate::evaluate(...)
 12. │               └─evaluate:::evaluate_call(...)
 13. │                 ├─evaluate:::timing_fn(...)
 14. │                 ├─base:::handle(...)
 15. │                 ├─base::withCallingHandlers(...)
 16. │                 ├─base::withVisible(eval(expr, envir, enclos))
 17. │                 └─base::eval(expr, envir, enclos)
 18. │                   └─base::eval(expr, envir, enclos)
 19. ├─dplyr::select(...)
 20. └─dplyr:::select.data.frame(...)
 21.   └─tidyselect::eval_select(expr(c(...)), .data)
 22.     └─tidyselect:::eval_select_impl(...)
 23.       ├─tidyselect:::with_subscript_errors(...)
 24.       │ ├─base::tryCatch(...)
 25.       │ │ └─base:::tryCatchList(expr, classes, parentenv, handlers)
 26.       │ │   └─base:::tryCatchOne(expr, names, parentenv, handlers[[1L]])
 27.       │ │     └─base:::doTryCatch(return(expr), name, parentenv, handler)
 28.       │ └─tidyselect:::instrument_base_errors(expr)
 29.       │   └─base::withCallingHandlers(...)
 30.       └─tidyselect:::vars_select_eval(...)
 31.         └─tidyselect:::walk_data_tree(expr, data_mask, context_mask)
 32.           └─tidyselect:::eval_c(expr, data_mask, context_mask)
 33.             └─tidyselect:::reduce_sels(node, data_mask, context_mask, init = init)
 34.               └─tidyselect:::walk_data_tree(new, data_mask, context_mask)
 35.                 └─tidyselect:::as_indices_sel_impl(...)
 36.                   └─tidyselect:::as_indices_impl(x, vars, strict = strict)
 37.                     └─tidyselect:::chr_as_locations(x, vars)
 38.                       └─vctrs::vec_as_location(x, n = length(vars), names = vars)
 39.                         └─(function () ...
 40.                           └─vctrs:::stop_subscript_oob(...)
 41.                             └─vctrs:::stop_subscript(...)
Execution halted
```
