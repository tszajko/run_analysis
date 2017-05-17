This README document provides insights for run_analysis.R script that was prepared for the Coursera Getting and Cleaning Data Course Project. 
The assignment requiresus to download data collected from the accelerometers from the Samsung Galaxy S smartphone.
The data is available at the following URL: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
The description of the data is available at the following URL: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
Instructions for the project were defined as follows: 
  1. Merges the training and the test sets to create one data set.
  2. Extracts only the measurements on the mean and standard deviation for each measurement.
  3. Uses descriptive activity names to name the activities in the data set
  4. Appropriately labels the data set with descriptive variable names.
  5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
  
 The code was created corresponding to this activity list, while certain tasks were split into second level segments in order to properly address the complexity of the tasks. 
 The following section covers the basic logic for each of the code segments:
 
 0.1. We load two packages required for the script.
 
 1.1. Zipped data is downloaded ("download.file") and unzipped ("unzip") to the working directory.
 
 1.2. The data is unzipped to the "UCI HAR DATASET" that contains two folders, "test" and "train". The script defines the filepath for all files in the core "test" directory and its subdirectory "Inertial Signals" The "read.table" function is used to read all txt files and assign them to a new variable derived from their filename. 
 
 1.3. The process described in section 1.2. is repeated for the "train" directory. 
 
 1.4. A list containing all "test" and "train" files / variables is created using the "ls(pattern)" function. The core filename for the merged files is defined by omitting the "test" word from the "test" filenames using "gsub".
 
 1.5. Files are merged using the "rbind function" that puts all "train" rows under the "test" values for each files in the folder. All newly created variables are assigned with a new name that adds "a_" before its core name.
 
 2.1. The file containing all measurement names is imported to a new data frame called "features".
 
 2.2. Mean and std variables are selected from the "features" DF using "grep" to find "mean" and "std" patterns. The two sets are merged to a comprehensive "features_list".
 
 2.3. The column numbers are subtracted from "features_list" in a new variable called "features_col". We extract required data from variable "a_X_.txt" that contains all measurement data by using the column numbers stored in "features_list".
 
 2.4. In order to avoid column name duplication (as original files do not have column names), we rename the columns of the two additionally required files ("SubjectID" and "ActivityID").
 
 2.5. We create the merged data set "merged_data" using "cbind" for the three source data files (outputs of 2.3. and 2.4.)
 
 3.1. Activity labels are imported from the source data "activity_labels.txt" while column name is changed to "ActivityName". We use "cbind" to join this data to "merged_data" and create "merged_data2".
 
 4.1. We extract current column names of "merged_data2" to "oldnames" and create the desired "newnames" variable based on already named columns ("ActivityID","SubjectID","ActivityName") and the elements of "features_list" translated to string using "as.character".  "merged_data2" columns are renamed using the "str_replace" function with "oldnames" and "newnames".
 
 5.1. We use "summarize_each" with the grouping variables ("ActivityID","SubjectID","ActivityName") to create "merged_data3". 
 
