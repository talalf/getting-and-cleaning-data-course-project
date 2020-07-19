## This script takes raw data from accelerometers located across disparate file sources and combines
## them into a new tidy dataset called "data". It then summarises the data according to
## subjectID and activity_name and provides the mean for each combination of subjectID and activity_name
## in a final output data table called "summary". 
## The first part of the script extracts and tidies the train dataset; the next part does the same for 
## the test dataset. The final part makes the new dataset and summarises the means.
##For more information please see the readme.
## -----------

# load necessary packages, set working directory and load data from .txt files
library(tidyverse)

setwd("./datafiles/UCI HAR Dataset/")

subjects <- read.delim("./train/subject_train.txt", header = FALSE) %>% tbl_df() %>%
  rename(subjectID = V1)

labels <- read.delim("activity_labels.txt", header = FALSE) %>%
  separate(V1, into = c("activity_code","activity_name"), sep = " ")

activities <- read.delim("./train/y_train.txt", header = FALSE)

activity_labels <- read.delim("activity_labels.txt", header = FALSE, sep = "")

activity_names <- data.frame(activity_name = activity_labels[activities[,1],2])

features <- read.delim("features.txt", header = FALSE) %>%
  separate(V1, into = c("ID","feature"), sep = " ")

features$feature <- features$feature

neededvars <- grep("mean|std", features$feature) #only some variables are wanted (mean and std) so these are extracted here
neededlabels <- features[neededvars,2]

x_train <- read.delim("./train/X_train.txt", header = FALSE)

# The .txt file had all observed values in one column so I separated them out into different columns 
# (I noticed that each observation had a fixed legnth of 16 characters)

x_train_separated <- x_train %>% 
  separate(V1, into = as.character(c(1:561)), sep = c(seq(from = 16, to = 16 *560, by = 16)))

x_train_selected <- select(x_train_separated, c(all_of(neededvars)))

#this for loop was to assign proper variable names rather than have the columns be V1, V2 etc...
## i.e. according to question, this it to satisfy part 4. "labels the data set with descriptive variable names"

for (i in 1:79){
  names(x_train_selected)[i] <- neededlabels[i]
  }

x_train <- x_train_selected %>% tbl_df()

#removing unneeded variables
rm(x_train_selected)
rm(x_train_separated)

#adding subjectID and activity_code columns

x_train <- add_column(x_train, subjects, .before = 1)
x_train <- add_column(x_train, activities, .after = 1)
names(x_train)[2] <- "activity_code"

#adding activity_names columns
x_train <- add_column(x_train, activities, .after = 1) %>% 
  add_column(activity_names, .after = 2) %>% 
  select(-V1)

## the train dataset has now been cleaned and added as x_train