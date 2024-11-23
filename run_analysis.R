# Load necessary libraries
library(dplyr)
rm(list = ls())

# ******************************************************************************
# Task1: Merges the training and the test sets to create one data set.

# ******************************************************************************
# *************Read common data
# ******************************************************************************
# ******************************************************************************
# Load activity DS
#Each row indentifies distinct activity
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
colnames(activity_labels)<- c("ActivityID", "Activity")
  # > head(activity_labels)
  # ActivityID      Activity
  # 1             1            WALKING
  # 2             2   WALKING_UPSTAIRS
  # 3             3 WALKING_DOWNSTAIRS
  # 4             4            SITTING
  # 5             5           STANDING
  # 6             6             LAYING
  # > nrow(activity_labels)
  # [1] 6

# ******************************************************************************
# Load a DS with 561 distinct features
features <- read.table("UCI HAR Dataset/features.txt")
colnames(features)<- c("FeatureID", "Feature")
  # > str(features)
  # 'data.frame':	561 obs. of  2 variables:
  #   $ FeatureID: int  1 2 3 4 5 6 7 8 9 10 ...
  #   $ Feature  : chr  "tBodyAcc-mean()-X" "tBodyAcc-mean()-Y" "tBodyAcc-mean()-Z" "tBodyAcc-std()-X" ...

# ******************************************************************************
# **********Read Train data
# ******************************************************************************
# ******************************************************************************
# Load training features data
X_train <- read.table("UCI HAR Dataset/train/X_train.txt")
# Each row represents an observation with 561 features, corresponding to a specific activity and subject.
  # names(X_train)
  # "V1",....."V561"
  # head(X_train, 2)
  # V1          V2         V3         V4          V5         ...  V561       
  # 1 0.2885845 -0.02029417 -0.1329051 -0.9952786 -0.9831106 ...  -0.9135264 
  # > nrow(X_train)
  # [1] 7352
#Give meaningful names to columns from Features DS
colnames(X_train) <- features$Feature
  # > str(X_train)
  # 'data.frame':	7352 obs. of  561 variables:
  # $ tBodyAcc-mean()-X                   : num  0.289 0.278 0.28 0.279 0.277 ...
  # $ tBodyAcc-mean()-Y                   : num  -0.0203 -0.0164 -0.0195 -0.0262 -0.0166 ...
  # $ tBodyAcc-mean()-Z                   : num  -0.133 -0.124 -0.113 -0.123 -0.115 ...
  # $ tBodyAcc-std()-X                    : num  -0.995 -0.998 -0.995 -0.996 -0.998 ...
  # $ tBodyAcc-std()-Y                    : num  -0.983 -0.975 -0.967 -0.983 -0.981 ...
  # $ tBodyAcc-std()-Z                    : num  -0.914 -0.96 -0.979 -0.991 -0.99 ...
  # $ tBodyAcc-mad()-X                    : num  -0.995 -0.999 -0.997 -0.997 -0.998 ...
  # $ tBodyAcc-mad()-Y                    : num  -0.983 -0.975 -0.964 -0.983 -0.98 ...
  # ........
  
# ******************************************************************************
#Load train Activitiy IDs  
#Each row represent an activity id per observation
# Its range is from 1 to 6
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
  # > str(y_train)
  # 'data.frame':	7352 obs. of  1 variable:
  #   $ V1: int  5 5 5 5 5 5 5 5 5 5 ...
  # > unique(y_train)
  # V1
  # 1    5
  # 28   4
  # 52   6
  # 79   1
  # 126  3
  # 151  2
# Rename columns
colnames(y_train) <- c("ActivityID")
  # > str(y_train)
  # 'data.frame':	7352 obs. of  1 variable:
  #   $ ActivityID: int  5 5 5 5 5 5 5 5 5 5 ...

# ******************************************************************************
# Each row identifies the subject who performed the activity for each window sample. 
# Its range is from 1 to 30. 
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
colnames(subject_train) <- c("Subject")
  # > str(subject_train)
  # 'data.frame':	7352 obs. of  1 variable:
  #   $ V1: int  1 1 1 1 1 1 1 1 1 1 ...
  # > unique(subject_train)
  # V1
  # 1     1
  # 348   3
  # 689   5
  # 991   6
  # 1316  7
  # 1624  8
  # 1905 11
  # 2221 14
  # 2544 15
  # 2872 16
  # 3238 17
  # 3606 19
  # 3966 21
  # 4374 22
  # 4695 23
  # 5067 25
  # 5476 26
  # 5868 27
  # 6244 28
  # 6626 29
  # 6970 30

# ******************************************************************************
# Bind columns
train<- cbind(subject_train,y_train, X_train)

# ******************************************************************************
# **Clean temporary tables
rm("subject_train","X_train","y_train")


# ******************************************************************************
# ******************************************************************************
# ***Repeat the steps for test data
# ******************************************************************************
  # Load test features data
  X_test <- read.table("UCI HAR Dataset/test/X_test.txt")
  #Give meaningful names to columns from Features DS
  colnames(X_test) <- features$Feature
  # ******************************************************************************
  #Load test Activitiy IDs  
  #Each row represent an activity id per observation
  # Its range is from 1 to 6
  y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
  # Rename columns
  colnames(y_test) <- c("ActivityID")
  # ******************************************************************************
  # Each row identifies the subject who performed the activity for each window sample. 
  # Its range is from 1 to 30. 
  subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
  colnames(subject_test) <- c("Subject")
  # ******************************************************************************
  # Bind columns
  test<- cbind(subject_test,y_test, X_test)

  # ******************************************************************************
  # **Clean temporary tables
  rm("subject_test","X_test","y_test")
# ******************************************************************************
DS<-rbind(test,train)
rm("test","train")
# ******************************************************************************
# ******************************************************************************
# ******************************************************************************
# Task2: Extracts only the measurements on the mean and standard deviation for each measurement. 
# Identify columns with mean or std
names(DS)
mean_std_features <- grep("Subject|ActivityID|mean\\(\\)|std\\(\\)", names(DS))
# Subset the X dataset
DS <- DS[, mean_std_features]
rm(mean_std_features)


#Task 3: Uses descriptive activity names to name the activities in the data set
DS <- merge(DS, activity_labels, by = "ActivityID")
# Move the last column to the first place
DS <- DS[, c(ncol(DS), 1:(ncol(DS) - 1))]
DS <- DS %>%
  select(-ActivityID)

object.size(DS)
# 5572216 bytes
DS$Activity <- factor(DS$Activity)
DS$Subject <- factor(DS$Subject)
str(DS)
# data.frame':	10299 obs. of  68 variables:
#  $ Activity                   : Factor w/ 6 levels "LAYING","SITTING",..: 4 4 4 4 4 4 4 4 4 4 ...
#  $ Subject                    : Factor w/ 30 levels "1","2","3","4",..: 7 21 7 7 18 7 7 7 11 21 ...
#  $ tBodyAcc-mean()-X          : num  0.269 0.262 0.238 0.245 0.249 ...
#  $ tBodyAcc-mean()-Y          : num  0.00789 -0.01622 0.0021 -0.03155 -0.02112 ...
