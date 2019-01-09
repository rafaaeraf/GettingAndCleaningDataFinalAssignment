# Extracts only the measurements on the mean and standard deviation for each measurement.
baseDirectory <- getwd()
subjectTest <- readLines(paste0(baseDirectory, "/test/subject_test.txt"))
xTest <- read.table(paste0(baseDirectory, "/test/X_test.txt"))
yTest <- readLines(paste0(baseDirectory, "/test/y_test.txt"))
subjectTrain <- readLines(paste0(baseDirectory, "/train/subject_train.txt"))
xTrain <- read.table(paste0(baseDirectory, "/train/X_train.txt"))
yTrain <- readLines(paste0(baseDirectory, "/train/y_train.txt"))

# Uses descriptive activity names to name the activities in the data set
activityLabels <- read.table(paste0(baseDirectory, "/activity_labels.txt"))
for (i in seq(nrow(activityLabels))) {
    yTest[yTest == i] <- as.character(activityLabels[i, "V2"])
    yTrain[yTrain == i] <- as.character(activityLabels[i, "V2"])
}

# Appropriately labels the data set with descriptive variable names.
features <- read.table(paste0(baseDirectory, "/features.txt"))
names(xTest) <- features$V2
names(xTrain) <- features$V2

# Merges the training and the test sets to create one data set.
test <- data.frame(subject = subjectTest, data_type = "Test", y = yTest)
test <- cbind(test, xTest)
train <- data.frame(subject = subjectTrain, data_type = "Train", y = yTrain)
train <- cbind(train, xTrain)
data <- rbind(train, test)
write.csv(data, paste0(baseDirectory, "/tidyData.csv"))

# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
meansData <- aggregate(data[, 4:ncol(data)], list(subject = data$subject, activity = data$y), mean)
write.table(meansData, paste0(baseDirectory, "/meansData.txt"), row.names = FALSE)