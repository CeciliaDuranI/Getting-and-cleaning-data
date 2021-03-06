##Download data

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download.file(url, destfile ="./data.zip")

unzip("./data.zip")

trainingset <- read.table("./UCI HAR Dataset/train/X_train.txt")
traininglabels <- read.csv("./UCI HAR Dataset/train/y_train.txt", header = FALSE, sep = " ")
trainsubject <- read.csv("./UCI HAR Dataset/train/subject_train.txt",header = FALSE, sep = " ")

testset <- read.table("./UCI HAR Dataset/test/X_test.txt")
testlabel <- read.csv("./UCI HAR Dataset/test/y_test.txt", header = FALSE, sep = " ")
testsubject <- read.csv("./UCI HAR Dataset/test/subject_test.txt",header = FALSE, sep = " ")

variables <- read.csv("./UCI HAR Dataset/features.txt",header = FALSE, sep = " ")

colnames(trainingset) <- variables[,2]

colnames(testset) <- variables[,2]

colnames(testlabel) <- "activity"

colnames(traininglabels) <- "activity"

colnames(testsubject) <- "subject"

colnames(trainsubject) <- "subject"

##Merges the Training and Testing Sets into 1 data set called data.all

test <- cbind(testset,testlabel,testsubject)

training <- cbind(trainingset,traininglabels,trainsubject)

data.all <- rbind(training,test)

##Extracts only the measurements on the mean and standard deviation for each measurement.

prueba <- data.all[,grepl("mean|std", colnames(data.all))]

library(dplyr)

pruebaasc <- data.all %>%
  select(activity,subject)

measuresmeanstd <- cbind(prueba,pruebaasc)

##Uses descriptive activity names to name the activities in the data set

activitylabels <- read.csv("./UCI HAR Dataset/activity_labels.txt",header = FALSE, sep = " ")

measuresmeanstd$activity <- gsub(1,"WALKING",measuresmeanstd$activity)
measuresmeanstd$activity <- gsub(2,"WALKING_UPSTAIRS",measuresmeanstd$activity)
measuresmeanstd$activity <- gsub(3,"WALKING_DOWNSTAIRS",measuresmeanstd$activity)
measuresmeanstd$activity <- gsub(4,"SITTING",measuresmeanstd$activity)
measuresmeanstd$activity <- gsub(5,"STANDING",measuresmeanstd$activity)
measuresmeanstd$activity <- gsub(6,"LAYING",measuresmeanstd$activity)

##Appropriately labels the data set with descriptive variable names

colnames(measuresmeanstd) <- sub("^t","time",colnames(measuresmeanstd))
colnames(measuresmeanstd) <- sub("^f","frequency",colnames(measuresmeanstd))
colnames(measuresmeanstd) <- sub("Acc", "Acceleretion",colnames(measuresmeanstd))
colnames(measuresmeanstd) <- sub("Gyro", "Gyroscope",colnames(measuresmeanstd))
colnames(measuresmeanstd) <- sub("Mag", "Magnitude",colnames(measuresmeanstd))

##From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject

tidy.data <- measuresmeanstd %>%
  group_by(activity,subject) %>%
  summarise_all(mean)
