# Getting and Cleaning Data Project

## Steps

1. Get the data from the provided URL. The data will be downloaded to the same path where the R script is located and the project_data.zip file will be created. After that, data will be unzipped to "UCI HAR Dataset" folder.
```R
data_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
dest_file_path <- "./project_data.zip"
download.file(data_url, destfile =dest_file_path)
unzip(dest_file_path)
```

2. Read features and activity_labels files
```R
features <- read.table('./UCI HAR Dataset/features.txt')
activity_labels <- read.table('./UCI HAR Dataset/activity_labels.txt')
```

3. Read training data.
```R
subject_train <- read.table('./UCI HAR Dataset/train/subject_train.txt')
X_train <- read.table('./UCI HAR Dataset/train/X_train.txt')
y_train <- read.table('./UCI HAR Dataset/train/y_train.txt')
```

4. Read test data.
```R
subject_test <- read.table('./UCI HAR Dataset/test/subject_test.txt')
X_test <- read.table('./UCI HAR Dataset/test/X_test.txt')
y_test <- read.table('./UCI HAR Dataset/test/y_test.txt')
```

5. Set descriptive labels for every variable
```R
colnames(features) <- c("feature_id","feature_name")
colnames(activity_labels) <- c("activity_id","activity_name")
colnames(subject_train) <- "subject_id"
colnames(subject_test) <- "subject_id"
colnames(X_train) <- features[,"feature_name"]
colnames(X_test) <- features[,"feature_name"]
colnames(y_train) <- "activity_id"
colnames(y_test) <- "activity_id"
```

6. Merge features(x), labels(y) and subject
```R
train_data <- cbind(subject_train, y_train, X_train)
test_data <- cbind(subject_test, y_test, X_test)
```

7. Merge train and test
```R
data <- rbind(train_data, test_data)
```

8. Extract features with mean and std. Also, keep subject and labels (y)
```R
data <- data[ , grepl("mean|std|subject_id|activity_id", names(data))]
```

9. Include descriptive activity names and tidy up removing activity_id
```R
data <- join(data, activity_labels, by = "activity_id")
data$activity_id <- NULL
```

10. Create new dataframe with means of the features
```R
data_means <- ddply(data, c("subject_id","activity_name"), numcolwise(mean))
```

11. Generate txt files with the requested data. Theses files will be located in the same path as the R script.
```R
write.table(data,"dataset_detailed.txt", row.name=FALSE)
write.table(data_means,"dataset_average.txt", row.name=FALSE)
```
