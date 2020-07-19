data[,4:82] <- sapply(data[,4:82],as.numeric)

data <- group_by(data, activity_name)

names <- names(data)[4:82]

summary_by_activity <- summarize_at(data, names, mean)

data <- group_by(data, subjectID)

names <- names(data)[4:82]

summary_by_subject <- summarize_at(data, names, mean)