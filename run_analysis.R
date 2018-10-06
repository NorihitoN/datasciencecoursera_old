# This file should be saved in the parent directory of UCI HAR Dataset directory
# load test and train data
xtest <- read.table("./UCI HAR Dataset/test/X_test.txt")
xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt")
ytest <- read.table("./UCI HAR Dataset/test/Y_test.txt", col.names = "Activity")
ytrain <- read.table("./UCI HAR Dataset/train/Y_train.txt", col.names = "Activity")

# load Subject data 
sub_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", col.names = "Subject")
sub_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", col.names = "Subject")

# load feature names data
features <- read.table("./UCI HAR Dataset/features.txt", col.names = c("index","featureName"))
#activityLabels <- read.table("./UCI HAR Dataset/activity_labels.txt", col.names = c("classLabel","activityName"))

# extract index and featureName which contain "mean()" and "std()" in features vector
indexFeature <- features[(grepl("mean()", features[,2]) 
                        | grepl("std()", features[,2])) ,][,1]
nameFeature <- as.character(features[(grepl("mean()", features[,2]) 
                      | grepl("std()", features[,2])) ,][,2])

# combine train and test data set for extracted feature data set.
xdata <- rbind(xtrain, xtest) %>%
    select(indexFeature)
names(xdata) <- nameFeature

# combine y(Activity number) train and test data set.
ydata <- rbind(ytrain, ytest)

# combine subject(Subject number) train and test data set.
sub_data <- rbind(sub_train, sub_test)

# combine all dataset(feature, activity, subject dataset)
# combined dataset is grouped by subject and activity,
# and summarise the mean value of each feature column for each subject and activity.
data <- cbind(xdata, ydata, sub_data) %>%
    group_by(Subject, Activity) %>%
    summarise_all(funs(mean))

# save the summarised data in the above as "tidyData.txt"
fwrite(x = data, file = "tidyData.txt", quote = FALSE)

