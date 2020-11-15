# Getting-and-cleaning-data
Data Course Project
The purpose of this project is to create one R script called run_analysis.R that does the following:
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## You can copy the script bellow with explanations and run it, to do what is explain over there.

## Download data from the URL provide in the project, unzip it and then read the relevant data for the project (train and test data)

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download.file(url, destfile ="./data.zip")

unzip("./data.zip")

trainingset <- read.table("./UCI HAR Dataset/train/X_train.txt")
traininglabels <- read.csv("./UCI HAR Dataset/train/y_train.txt", header = FALSE, sep = " ")
trainsubject <- read.csv("./UCI HAR Dataset/train/subject_train.txt",header = FALSE, sep = " ")

testset <- read.table("./UCI HAR Dataset/test/X_test.txt")
testlabel <- read.csv("./UCI HAR Dataset/test/y_test.txt", header = FALSE, sep = " ")
testsubject <- read.csv("./UCI HAR Dataset/test/subject_test.txt",header = FALSE, sep = " ")

## Change variable names in order to make them understandable and possible to merge

variables <- read.csv("./UCI HAR Dataset/features.txt",header = FALSE, sep = " ")

colnames(trainingset) <- variables[,2]

colnames(testset) <- variables[,2]

colnames(testlabel) <- "activity"

colnames(traininglabels) <- "activity"

colnames(testsubject) <- "subject"

colnames(trainsubject) <- "subject"

## 1. Merges the Training and Testing Sets into one data set called data.all. This is made by first binding by column different files from test and from training set, and then binding by row those two files (test and training)

test <- cbind(testset,testlabel,testsubject)

training <- cbind(trainingset,traininglabels,trainsubject)

data.all <- rbind(training,test)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement. For this I use regular expression to find "mean or std" on column names. Then I select columns with information about activity and subject.

prueba <- data.all[,grepl("mean|std", colnames(data.all))]

library(dplyr)

pruebaasc <- data.all %>%
  select(activity,subject)

measuresmeanstd <- cbind(prueba,pruebaasc)

## 3. Uses descriptive activity names to name the activities in the data set. I use the information on "activity_labels.txt" to substitute with regular expressions the number in activity column

activitylabels <- read.csv("./UCI HAR Dataset/activity_labels.txt",header = FALSE, sep = " ")

measuresmeanstd$activity <- gsub(1,"WALKING",measuresmeanstd$activity)

measuresmeanstd$activity <- gsub(2,"WALKING_UPSTAIRS",measuresmeanstd$activity)

measuresmeanstd$activity <- gsub(3,"WALKING_DOWNSTAIRS",measuresmeanstd$activity)

measuresmeanstd$activity <- gsub(4,"SITTING",measuresmeanstd$activity)

measuresmeanstd$activity <- gsub(5,"STANDING",measuresmeanstd$activity)

measuresmeanstd$activity <- gsub(6,"LAYING",measuresmeanstd$activity)

## 4. Appropriately labels the data set with descriptive variable names. I change variables names that were not clear (as t,f, Acc, Gyro and Mag) to have full names variable. 

colnames(measuresmeanstd) <- sub("^t","time",colnames(measuresmeanstd))

colnames(measuresmeanstd) <- sub("^f","frequency",colnames(measuresmeanstd))

colnames(measuresmeanstd) <- sub("Acc", "Acceleretion",colnames(measuresmeanstd))

colnames(measuresmeanstd) <- sub("Gyro", "Gyroscope",colnames(measuresmeanstd))

colnames(measuresmeanstd) <- sub("Mag", "Magnitude",colnames(measuresmeanstd))

## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject. I group information by activity and subject and then extract the mean for each variable. The resulting file "tidy.data" has 180 observations for 81 variables.

tidy.data <- measuresmeanstd %>%
  group_by(activity,subject) %>%
  summarise_all(mean)
