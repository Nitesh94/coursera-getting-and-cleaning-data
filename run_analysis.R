library(reshape2)

# Download the dataset:
if (!file.exists("getdata_dataset.zip")){
    url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
    download.file(url, "getdata_dataset.zip", method="curl")
}

# Unzip the downloaded dataset
if (!file.exists("UCI HAR Dataset")) { 
    unzip("getdata_dataset.zip")
}

# Reading all the test data
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

# Reading all the train data
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/Y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

# Merging both test and train data together
x_data <- rbind(x_test,x_train)
y_data <- rbind(y_test,y_train)

# Merging test and train subject data
subject <- rbind(subject_test,subject_train)

# Reading features
features <- read.table("features.txt")

# Selecting values with mean() and std() in 2nd coloumn
required_features <- grep("-(mean|std)\\(\\)", features[, "V2"])

# Taking only the required data from x_data
x_data <- x_data[, required_features]

# correcting the column names of x_data
names(x_data) <- features[required_features, 2]

# Reading activity_labels
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")

# Correcting activity names in y_data
y_data[,1] <- activity_labels[y_data[,1],2]

# Correcting y_data and x_data column name
names(y_data) <- "activity"
names(subject) <- "subject"

# Combining all the data into a single one
combined_data <- cbind(x_data,y_data,subject)

# Modifying column names of combined data
names(combined_data) <- sub("-(mean)\\(\\)-","Mean",names(combined_data))
names(combined_data) <- sub("-(std)\\(\\)-","Std",names(combined_data))
names(combined_data) <- sub("-(mean)\\(\\)","Mean",names(combined_data))
names(combined_data) <- sub("-(std)\\(\\)","Std",names(combined_data))

# Calculating mean and storing the data frame
melted_data <- melt(combined_data, id = c("subject", "activity"))
mean_data <- dcast(melted_data,subject + activity ~ variable, mean)
write.table(mean_data,"UCI HAR Dataset/ActivityRecognition.txt",row.names = FALSE)