# Load: activity labels
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")

# Load: data column names
features <- read.table("./UCI HAR Dataset/features.txt", colClasses = c("integer","character"))

x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

#Merges the training and the test sets to create one data set.
train <- cbind(x_train,y_train, subject_train)
test <- cbind(x_test,y_test, subject_test)
data <- rbind(train,test)

#Extracts only the measurements on the mean and standard deviation for each measurement. 
bool_features <- grepl("mean|std", features$V2)
features_ms <- features[bool_features,2]
all_bool_features <- c(bool_features, TRUE, TRUE)
data_ms <- data[,all_bool_features]

#Uses descriptive activity names to name the activities in the data set
data_ms_act <-  merge(data_ms, activity_labels, by.x="V1.1", by.y = "V1", all = TRUE)

#Appropriately labels the data set with descriptive variable names. 
colnames(data_ms_act) <- c("Activity_Id", features_ms,"Subject","Activity")

#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
tidyData <- aggregate(. ~Subject + Activity, data_ms_act, mean)
write.table(tidyData, "tidy.txt",sep=",",row.names = FALSE)

