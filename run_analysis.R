# R script for the getting and cleaning data course project

# This Script:
# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement. 
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names. 
# Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
#
#The resulting dataset is called 'resultaat.txt'

# First, download and unzip the data that is used:

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download.file(url, destfile="dataset.zip", method="curl")

dataset <- "dataset.zip"

unzip(dataset)


# Change WD to the freshly unzipped directory

setwd("./UCI HAR Dataset")


# Read the six .txt files with data:

X_test = read.table("./test/X_test.txt")

y_test = read.table("./test/y_test.txt")

subject_test = read.table("./test/subject_test.txt")

y_train = read.table("./train/y_train.txt")

X_train = read.table("./train/X_train.txt")

subject_train = read.table("./train/subject_train.txt")

featuresdf = read.table("./features.txt")


# Read the headings from the features.txt file and apply them to the dataset:

headings = featuresdf$V2

colnames(X_test) = headings

colnames(X_train) = headings


# Rename the column labels 'V1' to 'activity:

library(plyr)

y_test <- rename(y_test, c(V1="activity"))

y_train <- rename(y_train, c(V1="activity"))


# Read the various types of activities and replace the numbers that ID the activities with the actual activities: 
# Replace the names of the activities with ther Lower Case equivalent:

activities = read.table("./activity_labels.txt")

activitiesLC = tolower(levels(activities$V2))

y_test$activity = factor(y_test$activity, labels = activitiesLC)

y_train$activity = factor(y_train$activity, labels = activitiesLC)


# Replace the 'V1' in the headers of the subjectID columns with 'subjectid':

subject_test <- rename(subject_test, c(V1="subjectid"))

subject_train <- rename(subject_train, c(V1="subjectid"))


# Combine the three 'test' and 'train' sets into two complete 'test' and 'train' sets at column level:

test = cbind(X_test, subject_test, y_test)

train = cbind(X_train, subject_train, y_train)


# Combine the newly created 'test' and 'train' sets together at row level

combined = rbind(test,train)


# Extract the mean, sd, ID and activity as the assignment descibes:

pattern = "mean|std|subjectid|activity"


# create a tidy dataset with the required columns:

tidydata = combined[,grep(pattern, names(combined), value=TRUE)]


# remove special characters from the column names, make them all Lower Case:

goodlabels = gsub("\\(|\\)|-|,","", names(tidydata))

names(tidydata) <- tolower(goodlabels)


# Almost ready, create a complete set summarized by subjectid:

klaar = ddply(tidydata, .(activity, subjectid), numcolwise(mean))


# Write the result to a file with name 'resultaat.txt':

write.table(klaar, file="resultaat.txt", sep = "\t", append=FALSE)


