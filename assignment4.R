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

neededvars <- grep("mean|std", features$feature)
neededlabels <- features[neededvars,2]

x_train <- read.delim("./train/X_train.txt", header = FALSE)

x_train_separated <- x_train %>% 
  separate(V1, into = as.character(c(1:561)), sep = c(seq(from = 16, to = 16 *560, by = 16)))

x_train_selected <- select(x_train_separated, c(all_of(neededvars)))

for (i in 1:79){
  names(x_train_selected)[i] <- neededlabels[i]
  }

x_train <- x_train_selected %>% tbl_df()
rm(x_train_selected)
rm(x_train_separated)
x_train <- add_column(x_train, subjects, .before = 1)
x_train <- add_column(x_train, activities, .after = 1)
names(x_train)[2] <- "activity_code"

x_train <- add_column(x_train, activities, .after = 1) %>% 
  add_column(activity_names, .after = 2) %>% 
  select(-V1)