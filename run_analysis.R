rm(list=ls())

features <- read.table("./UCI HAR Dataset/features.txt")
names <- features[,2]

train <- read.table("./UCI HAR Dataset/train/X_train.txt")
colnames(train) <- names
trainLabels <- read.table("./UCI HAR Dataset/train/y_train.txt")
colnames(trainLabels) <- "activityId"
subjectTrain <- read.table("./UCI HAR Dataset/train/subject_train.txt")
colnames(subjectTrain) <- "subjectId"

train <- cbind(trainLabels, subjectTrain, train)

test <- read.table("./UCI HAR Dataset/test/X_test.txt")
colnames(test) <- names
testLabels <- read.table("./UCI HAR Dataset/test/y_test.txt")
colnames(testLabels) <- "activityId"
subjectTest <- read.table("./UCI HAR Dataset/test/subject_test.txt")
colnames(subjectTest) <- "subjectId"

test <- cbind(testLabels, subjectTest, test)

mergedData <- rbind(train, test)

activityLabels <- read.table("./UCI HAR Dataset/activity_labels.txt")
colnames(activityLabels) <- c("activityId", "activity")

meanAndStdDev <- (grepl("mean", names) | grepl("std", names))
result <- mergedData[meanAndStdDev == TRUE]
result <- merge(result, activityLabels, by="activityId", all.x = TRUE)

noActivity <- result[,names(result) != "activity"]
noIds <- noActivity[,names(noActivity) != c("activityId", "subjectId")]

otherResult <- aggregate(noIds, by=list(activityId = noActivity$activityId, subjectId = noActivity$subjectId), mean)
otherResult <- merge(otherResult, activityLabels, by="activityId", all.x = TRUE)

write.table(otherResult, "./result.txt")
