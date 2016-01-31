# assumption: the current working directory is the root of the unzipped package
library(dplyr)

# First, merge all X sets (test + train)
# X contains 561 values of 16 characters.

X_cols = rep(16, 561)
# read the data from X_test:
X_test = read.fwf('test/X_test.txt', widths = X_cols)
# and from X_train:
X_train = read.fwf('train/X_train.txt', widths = X_cols)
# and combine them
X = rbind(X_test, X_train)
X = tbl_df(X)

remove(X_cols, X_test, X_train)

# read the features for the X vectors and appropriately label the variables
colnames(X) = read.csv('features.txt', header = FALSE, sep = " ")[,2]

# create the mean and stddev data table
X_ms = X[,grepl('mean', colnames(X))|grepl('std', colnames(X))]


# For y: only 1 variable of 2 chars per line
y_test = read.fwf('test/y_test.txt', 2)
y_train = read.fwf('train/y_train.txt', 2)
y = rbind(y_test, y_train)

remove(y_test, y_train)

#add the activity labels to the measurements

lbl = read.csv('activity_labels.txt', header=FALSE, sep = " ")
y = merge(y, labels)[,2]

# join the measurements
result = cbind(y, X_ms)
result = tbl_df(result)
result = rename(result, activity=y)

# The data in 'result' is now according to step 4 in the assignment

# now create a new data set that averages the variables for each subject and each activity

# Add the subjects: also only 1 variable of 2 chars per line
subject_test = read.fwf('test/subject_test.txt', 2)
subject_train = read.fwf('train/subject_train.txt', 2)
subject = rbind(subject_test, subject_train)

remove(subject_test, subject_train)

measurements_with_subjects = tbl_df(cbind(subject, result))
mws = rename(measurement_with_subjects,subject=V1)

# rename the column names to prevent problems later on
colnames(mws) = gsub('-', '.', gsub("[()]", '', colnames(mws)))

all_averages = summarize(mws, mean(tBodyAcc.mean.X),mean(tBodyAcc.mean.Y),mean(tBodyAcc.mean.Z),mean(tBodyAcc.std.X),mean(tBodyAcc.std.Y),mean(tBodyAcc.std.Z),mean(tGravityAcc.mean.X),mean(tGravityAcc.mean.Y),mean(tGravityAcc.mean.Z),mean(tGravityAcc.std.X),mean(tGravityAcc.std.Y),mean(tGravityAcc.std.Z),mean(tBodyAccJerk.mean.X),mean(tBodyAccJerk.mean.Y),mean(tBodyAccJerk.mean.Z),mean(tBodyAccJerk.std.X),mean(tBodyAccJerk.std.Y),mean(tBodyAccJerk.std.Z),mean(tBodyGyro.mean.X),mean(tBodyGyro.mean.Y),mean(tBodyGyro.mean.Z),mean(tBodyGyro.std.X),mean(tBodyGyro.std.Y),mean(tBodyGyro.std.Z),mean(tBodyGyroJerk.mean.X),mean(tBodyGyroJerk.mean.Y),mean(tBodyGyroJerk.mean.Z),mean(tBodyGyroJerk.std.X),mean(tBodyGyroJerk.std.Y),mean(tBodyGyroJerk.std.Z),mean(tBodyAccMag.mean),mean(tBodyAccMag.std),mean(tGravityAccMag.mean),mean(tGravityAccMag.std),mean(tBodyAccJerkMag.mean),mean(tBodyAccJerkMag.std),mean(tBodyGyroMag.mean),mean(tBodyGyroMag.std),mean(tBodyGyroJerkMag.mean),mean(tBodyGyroJerkMag.std),mean(fBodyAcc.mean.X),mean(fBodyAcc.mean.Y),mean(fBodyAcc.mean.Z),mean(fBodyAcc.std.X),mean(fBodyAcc.std.Y),mean(fBodyAcc.std.Z),mean(fBodyAcc.meanFreq.X),mean(fBodyAcc.meanFreq.Y),mean(fBodyAcc.meanFreq.Z),mean(fBodyAccJerk.mean.X),mean(fBodyAccJerk.mean.Y),mean(fBodyAccJerk.mean.Z),mean(fBodyAccJerk.std.X),mean(fBodyAccJerk.std.Y),mean(fBodyAccJerk.std.Z),mean(fBodyAccJerk.meanFreq.X),mean(fBodyAccJerk.meanFreq.Y),mean(fBodyAccJerk.meanFreq.Z),mean(fBodyGyro.mean.X),mean(fBodyGyro.mean.Y),mean(fBodyGyro.mean.Z),mean(fBodyGyro.std.X),mean(fBodyGyro.std.Y),mean(fBodyGyro.std.Z),mean(fBodyGyro.meanFreq.X),mean(fBodyGyro.meanFreq.Y),mean(fBodyGyro.meanFreq.Z),mean(fBodyAccMag.mean),mean(fBodyAccMag.std),mean(fBodyAccMag.meanFreq),mean(fBodyBodyAccJerkMag.mean),mean(fBodyBodyAccJerkMag.std),mean(fBodyBodyAccJerkMag.meanFreq),mean(fBodyBodyGyroMag.mean),mean(fBodyBodyGyroMag.std),mean(fBodyBodyGyroMag.meanFreq),mean(fBodyBodyGyroJerkMag.mean),mean(fBodyBodyGyroJerkMag.std),mean(fBodyBodyGyroJerkMag.meanFreq))
