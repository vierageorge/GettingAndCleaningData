##########################################
#Getting and Cleaning Data Course Project#
##########################################

#URL to download the data from
data_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

#Download data and unzip
dest_file_path = "./project_data.zip"
download.file(data_url, destfile =dest_file_path)
unzip(dest_file_path)

#libraries to be used
library(plyr)

#Read features and activity files
features <- read.table('./UCI HAR Dataset/features.txt')
activity_labels <- read.table('./UCI HAR Dataset/activity_labels.txt')

#Read training data
subject_train <- read.table('./UCI HAR Dataset/train/subject_train.txt')
X_train <- read.table('./UCI HAR Dataset/train/X_train.txt')
y_train <- read.table('./UCI HAR Dataset/train/y_train.txt')

#Read test data
subject_test <- read.table('./UCI HAR Dataset/test/subject_test.txt')
X_test <- read.table('./UCI HAR Dataset/test/X_test.txt')
y_test <- read.table('./UCI HAR Dataset/test/y_test.txt')

#Set descriptive labels for every variable 
colnames(features) <- c("feature_id","feature_name")
colnames(activity_labels) <- c("activity_id","activity_name")
colnames(subject_train) <- "subject_id"
colnames(subject_test) <- "subject_id"
colnames(X_train) <- features[,"feature_name"]
colnames(X_test) <- features[,"feature_name"]
colnames(y_train) <- "activity_id"
colnames(y_test) <- "activity_id"


#Merge features(x), labels(y) and subject
train_data <- cbind(subject_train, y_train, X_train)
test_data <- cbind(subject_test, y_test, X_test)

#Merge train and test
data <- rbind(train_data, test_data)

#Extract features with mean and std. Also, keep subject and labels (y)
data <- data[ , grepl("mean|std|subject_id|activity_id", names(data))]

#Include descriptive activity names and tidy up removing activity_id
data <- join(data, activity_labels, by = "activity_id")
data$activity_id <- NULL

#Create new dataframe with means of the features
data_means = ddply(data, c("subject_id","activity_name"), numcolwise(mean))

write.table(data,"dataset_detailed.txt", row.name=FALSE)
write.table(data_means,"dataset_average.txt", row.name=FALSE)
