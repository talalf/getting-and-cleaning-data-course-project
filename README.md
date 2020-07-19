# Getting and Cleaning Data Course Project

The file "run_analysis.R" can be run in R through source("run_analysis.R") once the working directory is set as the main directory of the repository. Clone the entire directory and run the following in R:

``` {R}
  source("run_analysis.R")
```

There is a codebook available which specifies what each column name means in the cleaned data sets (coodebook.md).

## Functions of run_analysis.R

1. Takes the X_train.txt and X_test.txt data and separates out the recorded measurements (561 measurements per record).
2. Selects the relevant mean and std deviation values (by use of the grep command)
3. Merges subjectID and activity information from the provided subject_train.txt and y_train.txt or y_test.txt files.
4. Combines test and train data
5. Summarises data by grouping into subjectID * activity_name (i.e. it shows the mean for subject 1 walking, subject 1 sitting, so on for all combinations of subjectIDs and activity_names).
6. The output data is stored as a dataframe within R called summary. I have also output this as a text file. You can run the code yourself and generate the file if you so wish.
