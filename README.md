# Human Activity Recognition Using Smartphones Dataset

## Overview

This project uses the **Human Activity Recognition Using Smartphones Dataset** to classify human activities based on accelerometer and gyroscope data collected from a smartphone. The dataset includes six activities performed by 30 participants, using a Samsung Galaxy S II smartphone equipped with an accelerometer and gyroscope.

## Data Description

The dataset includes data for the following activities:

- WALKING
- WALKING_UPSTAIRS
- WALKING_DOWNSTAIRS
- SITTING
- STANDING
- LAYING

Each activity is recorded with 561 distinct features derived from accelerometer and gyroscope signals in both the time and frequency domains.

### Data Collection

- The data was collected from 30 participants aged between 19 and 48 years.
- A smartphone was worn on the waist of the participants while they performed the activities.
- The accelerometer and gyroscope recorded 3-axial linear acceleration and angular velocity at a constant rate of 50Hz.
- The data is pre-processed and separated into two sets: **training** and **testing**, with 70% of the data used for training and 30% for testing.

The data is taken from this site: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

When downloaded and exported the should be "UCI HAR Dataset" folder in your working directory.
## Data Files

The dataset is structured into the following files:

### Common Files
- `activity_labels.txt`: Contains the mapping between activity IDs and their corresponding activity labels.
- `features.txt`: Contains the mapping between Feature IDs and their corresponding feature labels.
````
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
colnames(activity_labels)<- c("ActivityID", "Activity")
  # ActivityID      Activity
  # 1             1            WALKING
  # 2             2   WALKING_UPSTAIRS
  # 3             3 WALKING_DOWNSTAIRS
````
Load a DS with 561 distinct features
````
features <- read.table("UCI HAR Dataset/features.txt")
colnames(features)<- c("FeatureID", "Feature")
# head(features)  
# FeatureID           Feature
# 1         1 tBodyAcc-mean()-X
# 2         2 tBodyAcc-mean()-Y
# 3         3 tBodyAcc-mean()-Z
````

### Training Set
- `train/X_train.txt`: Training set with 561 features for each observation.
- `train/y_train.txt`: Activity labels corresponding to the training set.
- `train/subject_train.txt`: Subject identifiers for each observation in the training set.
````
X_train <- read.table("UCI HAR Dataset/train/X_train.txt")
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
````
Load activities ids per observation
````
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
colnames(y_train) <- c("ActivityID")
  # > str(y_train)
  # 'data.frame':	7352 obs. of  1 variable:
  #   $ ActivityID: int  5 5 5 5 5 5 5 5 5 5 ...
````
Load subject id per observation
Each row identifies the subject who performed the activity for each window sample. 
Its range is from 1 to 30. 
````
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
colnames(subject_train) <- c("Subject")
  # > str(subject_train)
  # 'data.frame':	7352 obs. of  1 variable:
  #   $ Subject: int  1 1 1 1 1 1 1 1 1 1 ...
````

Bind columns of Subject,Activity, Values
````
train<- cbind(subject_train,y_train, X_train)
````



### Test Set
- `test/X_test.txt`: Test set with 561 features for each observation.
- `test/y_test.txt`: Activity labels corresponding to the test set.
- `test/subject_test.txt`: Subject identifiers for each observation in the test set.

##### Repeat the steps for Test data
Bind columns of Subject,Activity, Values
````
test<- cbind(subject_test,y_test, X_test)
````

## Project Tasks

### Task 1: Merging Training and Test Sets
The training and test datasets are merged into one dataset, combining the subject, activity ID, and feature data.
````
DS<-rbind(test,train)
````


### Task 2: Extracting Mean and Standard Deviation Features
Currently it has these columns
````
> names(DS)
  [1] "Subject"                              "ActivityID"                           "tBodyAcc-mean()-X"                   
  [4] "tBodyAcc-mean()-Y"                    "tBodyAcc-mean()-Z"                    "tBodyAcc-std()-X"                    
  [7] "tBodyAcc-std()-Y"                     "tBodyAcc-std()-Z"                     "tBodyAcc-mad()-X"                    
 [10] "tBodyAcc-mad()-Y"                     "tBodyAcc-mad()-Z"                     "tBodyAcc-max()-X"                    
 [13] "tBodyAcc-max()-Y"                     "tBodyAcc-max()-Z"                     "tBodyAcc-min()-X"                    
 [16] "tBodyAcc-min()-Y"                     "tBodyAcc-min()-Z"                     "tBodyAcc-sma()"                      
 [19] "tBodyAcc-energy()-X"                  "tBodyAcc-energy()-Y"                  "tBodyAcc-energy()-Z"                 
 [22] "tBodyAcc-iqr()-X"                     "tBodyAcc-iqr()-Y"                     "tBodyAcc-iqr()-Z"   
 ...
 ````

We'll select those with mean() or std() in name
````
mean_std_features <- grep("Subject|ActivityID|mean\\(\\)|std\\(\\)", names(DS))
# Subset the X dataset
DS <- DS[, mean_std_features]
````
We search fo first two columns and those with mean() or std() in name.
Now DS has only 68 variables.

### Task 3: Descriptive Activity Names
Activity IDs are replaced with descriptive activity names (e.g., "WALKING", "SITTING", etc.) to make the dataset more readable.
````
#create a new column Activity, that will contain activity description.
DS <- merge(DS, activity_labels, by = "ActivityID")
# Move the last column to the first place
DS <- DS[, c(ncol(DS), 1:(ncol(DS) - 1))]
#Remove the column Activity
DS <- DS %>%
  select(-ActivityID)
> head(DS)
  Activity Subject tBodyAcc-mean()-X tBodyAcc-mean()-Y tBodyAcc-mean()-Z tBodyAcc-std()-X tBodyAcc-std()-Y tBodyAcc-std()-Z
1  WALKING       7         0.2693013       0.007891765       -0.05068156       -0.2641125       0.03238187      0.101279520
2  WALKING      21         0.2623422      -0.016215306       -0.11446522       -0.4152037       0.14611843     -0.109972740
3  WALKING       7         0.2383207       0.002102952       -0.04988110       -0.3376397       0.05634718      0.002905308
4  WALKING       7         0.2447143      -0.031546655       -0.18135387       -0.3111923       0.09768091      0.098291710
5  WALKING      18         0.2490386      -0.021118537       -0.12493361       -0.4909403      -0.19766633     -0.584283980
6  WALKING       7         0.2046162      -0.067271336       -0.14010421       -0.4240322      -0.01125670     -0.050086781

````

### Task 4: Renaming Columns
Columns are renamed to make them more descriptive. For example, columns starting with "t" are renamed to indicate that they represent time-domain features, and columns starting with "f" are renamed to indicate frequency-domain features.
if starts with t-"tBodyAcc_mean()_Y"=>"Time_BodyAcc_mean()_Y"
if starts with f-"fBodyAcc_mean()_Y"=>"Frequency_BodyAcc_mean()_Y"
````
# rename column names
tidy <- DS %>%
  # Apply a transformation to column names based on a specified function.
  rename_with(
    # The tilde (~) is used to define an anonymous function.
    # `grepl("^t", .)` checks if the column name starts with the letter "t".
    # If it starts with "t", rename as Time_ and replace "-" with "_".
    ~ ifelse(grepl("^t", .), 
             paste0("Time_", gsub("-", "_", sub("^t", "", .))),  # For time-domain, prefix with "Time_" and replace "-" with "_"
             ifelse(grepl("^f", .), 
                    paste0("Frequency_", gsub("-", "_", sub("^f", "", .))),  # For frequency-domain, prefix with "Frequency_" and replace "-" with "_"
                    .)  # If neither "t" nor "f", leave the column name as is
    ),
    everything()  # Apply the transformation to all columns
  )
names(tidy)
 [1] "Activity"                             "Subject"                              "Time_BodyAcc_mean()_X"               
 [4] "Time_BodyAcc_mean()_Y"                "Time_BodyAcc_mean()_Z"                "Time_BodyAcc_std()_X"                
 [7] "Time_BodyAcc_std()_Y"                 "Time_BodyAcc_std()_Z"                 "Time_GravityAcc_mean()_X"            
[10] "Time_GravityAcc_mean()_Y"             "Time_GravityAcc_mean()_Z"             "Time_GravityAcc_std()_X"             
[13] "Time_GravityAcc_std()_Y"              "Time_GravityAcc_std()_Z"              "Time_BodyAccJerk_mean()_X"           
[16] "Time_BodyAccJerk_mean()_Y"            "Time_BodyAccJerk_mean()_Z"            "Time_BodyAccJerk_std()_X"            
[19] "Time_BodyAccJerk_std()_Y"             "Time_BodyAccJerk_std()_Z"             "Time_BodyGyro_mean()_X"              
[22] "Time_BodyGyro_mean()_Y"               "Time_BodyGyro_mean()_Z"               "Time_BodyGyro_std()_X"               
[25] "Time_BodyGyro_std()_Y"                "Time_BodyGyro_std()_Z"                "Time_BodyGyroJerk_mean()_X"          
[28] "Time_BodyGyroJerk_mean()_Y"           "Time_BodyGyroJerk_mean()_Z"           "Time_BodyGyroJerk_std()_X"   
````

Remove parentesis
````
tidy <- tidy %>%
  rename_with(~ gsub("[()]", "", .), everything())  # Replace () in all column names
names(tidy)
# > names(tidy)
# [1] "Activity"                           "Subject"                            "Time_BodyAcc_mean_X"               
# [4] "Time_BodyAcc_mean_Y"                "Time_BodyAcc_mean_Z"                "Time_BodyAcc_std_X"                
# [7] "Time_BodyAcc_std_Y"                 "Time_BodyAcc_std_Z"                 "Time_GravityAcc_mean_X"            
# [10] "Time_GravityAcc_mean_Y"             "Time_GravityAcc_mean_Z"             "Time_GravityAcc_std_X"             
# [13] "Time_GravityAcc_std_Y"              "Time_GravityAcc_std_Z"              "Time_BodyAccJerk_mean_X"           
# [16] "Time_BodyAccJerk_mean_Y"            "Time_BodyAccJerk_mean_Z"            "Time_BodyAccJerk_std_X"            
# [19] "Time_BodyAccJerk_std_Y"             "Time_BodyAccJerk_std_Z"             "Time_BodyGyro_mean_X"              
# [22] "Time_BodyGyro_mean_Y"               "Time_BodyGyro_mean_Z"               "Time_BodyGyro_std_X"               
# [25] "Time_BodyGyro_std_Y"                "Time_BodyGyro_std_Z"                "Time_BodyGyroJerk_mean_X"          
# [28] "Time_BodyGyroJerk_mean_Y"           "Time_BodyGyroJerk_mean_Z"           "Time_BodyGyroJerk_std_X"           
````

### Task 5: Tidying the Data
The dataset is tidied by pivoting it from a wide format to a long format, with separate columns for the domain, feature, variable, and axis.

Now we have a case of multiple variables in columns.
We have cases with 
"Domain", "Feature","Variable","Axis"
"Domain", "Feature","Variable"
````
tidy<-pivot_longer(tidy, 
             cols = -c(Activity, Subject),  # Keep Activity and Subject columns intact
             names_to = c("Domain", "Feature","Variable","Axis"), 
             names_sep = "_")
````

Remove duplicated after separating columns
````
tidy <- tidy[!duplicated(tidy), ]
````


### Task 6: Calculating the Average for Each Activity and Subject
The average of each variable is calculated for each activity and subject, creating a summary dataset.
````
# Calculate the average of each variable for each Activity and each Subject
tidy_avg <- tidy %>%
  # Group by Activity, Subject, Feature, and Measurement
  group_by(Activity, Subject, Domain, Feature, Variable ,Axis) %>%  
  summarise(
    Average = mean(value, na.rm = TRUE), 
    .groups = 'drop'  
    # This argument is used to drop the grouping after summarization. 
    # It makes sure the resulting dataset is no longer grouped, 
    # so you can continue with further operations if needed.
  )  # Calculate the average of the value column
````
Clean environment
````
rm(DS,activity_labels,features, tidy)
````
Establish factors
````
tidy_avg$Domain   <- factor(tidy_avg$Domain )
tidy_avg$Feature    <- factor(tidy_avg$Feature  )
tidy_avg$Axis        <- factor(tidy_avg$Axis      )
tidy_avg$Variable        <- factor(tidy_avg$Variable      )
> str(tidy_avg)
tibble [11,880 x 7] (S3: tbl_df/tbl/data.frame)
 $ Activity: Factor w/ 6 levels "LAYING","SITTING",..: 1 1 1 1 1 1 1 1 1 1 ...
 $ Subject : Factor w/ 30 levels "1","2","3","4",..: 1 1 1 1 1 1 1 1 1 1 ...
 $ Domain  : Factor w/ 2 levels "Frequency","Time": 1 1 1 1 1 1 1 1 1 1 ...
 $ Feature : Factor w/ 13 levels "BodyAcc","BodyAccJerk",..: 1 1 1 1 1 1 2 2 2 2 ...
 $ Variable: Factor w/ 2 levels "mean","std": 1 1 1 2 2 2 1 1 1 2 ...
 $ Axis    : Factor w/ 3 levels "X","Y","Z": 1 2 3 1 2 3 1 2 3 1 ...
 $ Average : num [1:11880] -0.939 -0.867 -0.883 -0.924 -0.834 ...
````

## Output

The final output of the project is a tidy dataset `tidy_avg.txt` that contains the average values of each variable for each activity and each subject.

````
write.table(tidy_avg, file = "tidy_avg.txt", sep = ",", row.names = FALSE, col.names = TRUE)
````
## How to Run the Code

1. Download the dataset from the **UCI Machine Learning Repository** or your local dataset source.
2. Load the necessary R libraries (e.g., `dplyr`, `tidyr`).
3. Run the provided R script to perform the data processing tasks.
4. The final tidy dataset will be saved as `tidy_avg.txt`.

## License

This dataset is distributed AS-IS, and any commercial use is prohibited. Please refer to the dataset's [license](https://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) for more details.

## Acknowledgements

This dataset is provided by:

- Jorge L. Reyes-Ortiz
- Davide Anguita
- Alessandro Ghio
- Luca Oneto

For further inquiries, you can contact the creators via email: **activityrecognition@smartlab.ws**

