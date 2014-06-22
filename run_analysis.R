url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download.file(url, destfile="dataset.zip", method="curl")

dataset <- "dataset.zip"

unzip(dataset)

setwd("./UCI HAR Dataset")

X_test = read.table("./test/X_test.txt")

y_test = read.table("./test/y_test.txt")

subject_test = read.table("./test/subject_test.txt")

y_train = read.table("./train/y_train.txt")

X_train = read.table("./train/X_train.txt")

subject_train = read.table("./train/subject_train.txt")

featuresdf = read.table("./features.txt")

headings = featuresdf$V2

colnames(X_test) = headings

colnames(X_train) = headings

library(plyr)

y_test <- rename(y_test, c(V1="activity"))

y_train <- rename(y_train, c(V1="activity"))

activities = read.table("./activity_labels.txt")

activitiesLC = tolower(levels(activities$V2))

y_test$activity = factor(y_test$activity, labels = activitiesLC)

y_train$activity = factor(y_train$activity, labels = activitiesLC)

subject_test <- rename(subject_test, c(V1="subjectid"))

subject_train <- rename(subject_train, c(V1="subjectid"))

test = cbind(X_test, subject_test, y_test)

train = cbind(X_train, subject_train, y_train)

combined = rbind(test,train)

pattern = "mean|std|subjectid|activity"

tidydata = combined[,grep(pattern, names(combined), value=TRUE)]

goodlabels = gsub("\\(|\\)|-|,","", names(tidydata))

names(tidydata) <- tolower(goodlabels)

klaar = ddply(tidydata, .(activity, subjectid), numcolwise(mean))

write.table(klaar, file="resultaat.txt", sep = "\t", append=FALSE)