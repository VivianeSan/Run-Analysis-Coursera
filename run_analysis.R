library(reshape)
library(plyr)

activityLavels <-read.table("./UCI HAR Dataset/activity_labels.txt", col.names = c("activity_id", "activity_name"))
features <-read.table("./UCI HAR Dataset/features.txt", col.names = c("feature_id", "feature_name"))

subject_train_file <- "./UCI HAR Dataset/_train/subject_train.txt"
x_train_file <- "./UCI HAR Dataset/_train/X_train.txt"
y_train_file <- "./UCI HAR Dataset/_train/y_train.txt"

x_train <-read.table(x_train_file)
names(x_train) <- features$feature_name

y_train <-read.table(y_train_file)
x_train$Activity <-  factor(y_train$V1, activityLavels$activity_id, ordered=T, labels=activityLavels$activity_name)

x_train$Subject <- read.table(subject_train_file, col.names = c("Subject" ))$Subject

subject_test_file  <- "./UCI HAR Dataset/_test/subject_test.txt"
x_test_file  <- "./UCI HAR Dataset/_test/X_test.txt"
y_test_file  <- "./UCI HAR Dataset/_test/y_test.txt"

x_test <-read.table(x_test_file)
names(x_test) <- features$feature_name

y_test <-read.table(y_test_file)
x_test$Activity <-  factor(y_test$V1, activityLavels$activity_id, ordered=T, labels=activityLavels$activity_name)

x_test$Subject <- read.table(subject_test_file, col.names = c("Subject" ))$Subject

mergeData <- rbind(x_train, x_test)[grep("Activity|Subject|mean|std", names(x_test))]
mergeData <- melt(mergeData, id=c("Subject", "Activity"))

results <- ddply(mergeData, c("Activity", "Subject", "variable"), function(df){mean(df$value)})

names(results) <- c("Activity", "Subject", "Variable", "Value")

write.table( results, "results.txt", row.name=FALSE) 