data[,4:82] <- sapply(data[,4:82],as.numeric)

data <- group_by(data, subjectID, activity_name)

names <- names(data)[4:82]

summary <- summarize_at(data, names, mean)