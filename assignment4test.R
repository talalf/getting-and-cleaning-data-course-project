subjects <- read.delim("./test/subject_test.txt", header = FALSE) %>% tbl_df() %>%
  rename(subjectID = V1)

labels <- read.delim("activity_labels.txt", header = FALSE) %>%
  separate(V1, into = c("activity_code","activity_name"), sep = " ")

activities <- read.delim("./test/y_test.txt", header = FALSE)

activity_labels <- read.delim("activity_labels.txt", header = FALSE, sep = "")

activity_names <- data.frame(activity_name = activity_labels[activities[,1],2])

features <- read.delim("features.txt", header = FALSE) %>%
  separate(V1, into = c("ID","feature"), sep = " ")

features$feature <- features$feature

neededvars <- grep("mean|std", features$feature)
neededlabels <- features[neededvars,2]

x_test <- read.delim("./test/X_test.txt", header = FALSE)

x_test_separated <- x_test %>% 
  separate(V1, into = as.character(c(1:561)), sep = c(seq(from = 16, to = 16 *560, by = 16)))

x_test_selected <- select(x_test_separated, c(all_of(neededvars)))

for (i in 1:79){
  names(x_test_selected)[i] <- neededlabels[i]
}

x_test <- x_test_selected %>% tbl_df()
rm(x_test_selected)
rm(x_test_separated)
x_test <- add_column(x_test, subjects, .before = 1)
x_test <- add_column(x_test, activities, .after = 1)
names(x_test)[2] <- "activity_code"

x_test <- add_column(x_test, activities, .after = 1) %>% 
  add_column(activity_names, .after = 2) %>% 
  select(-V1)

## Remove unnecessary variables

rm(list = as.character(c("activities","activity_labels","activity_names",
                         "features","labels","subjects","i","neededlabels",
                         "neededvars")))

## Combine the cleaned test and train datasets

data <- rbind(x_test, x_train)