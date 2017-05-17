###0.1 call packages

library(dplyr)
library(stringr)

###1.1 download and unzip dataset

download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip","C:/Users/tszajko003/Documents/rr/")
unzip("C:/Users/tszajko003/Documents/rr/getdata%2Fprojectfiles%2FUCI HAR Dataset.zip")

###1.2 getting test files 

setwd("C:/Users/tszajko003/Documents/rr/UCI HAR Dataset/test")

filenames <- list.files(pattern="*.txt")

for (i in filenames) {
  filepath <- file.path(paste("C:/Users/tszajko003/Documents/rr/UCI HAR Dataset/test/",i,sep=""))
  assign(i,read.table(filepath))
}

setwd("C:/Users/tszajko003/Documents/rr/UCI HAR Dataset/test/Inertial Signals")

filenames <- list.files(pattern="*.txt")

for (i in filenames) {
  filepath <- file.path(paste("C:/Users/tszajko003/Documents/rr/UCI HAR Dataset/test/Inertial Signals/",i,sep=""))
  assign(i,read.table(filepath))
}

###1.3 getting train files 

setwd("C:/Users/tszajko003/Documents/rr/UCI HAR Dataset/train")

filenames <- list.files(pattern="*.txt")

for (i in filenames) {
  filepath <- file.path(paste("C:/Users/tszajko003/Documents/rr/UCI HAR Dataset/train/",i,sep=""))
  assign(i,read.table(filepath))
}

setwd("C:/Users/tszajko003/Documents/rr/UCI HAR Dataset/train/Inertial Signals")

filenames <- list.files(pattern="*.txt")

for (i in filenames) {
  filepath <- file.path(paste("C:/Users/tszajko003/Documents/rr/UCI HAR Dataset/train/Inertial Signals/",i,sep=""))
  assign(i,read.table(filepath))
}

###1.4 gathering all test and train files, creating merged file names 

TE_files <- ls(pattern="test")
TR_files <- ls(pattern="train")
merged_files <- gsub("test", "",TE_files)

###1.5 binding test and train items 

for (i in 1:12) {
  assign(paste("a_",merged_files[i],sep=""),rbind(eval(parse(text=TE_files[i])),eval(parse(text=TR_files[i]))))
}

###2.1 selecting mean an std_dv measurements 

setwd("C:/Users/tszajko003/Documents/rr/UCI HAR Dataset/")

features <- read.table(paste(getwd(),"/features.txt",sep=""))

###2.2 looking for cols that contain mean/std 
features_mean <- features[grep("mean",features$V2),]
features_std <- features[grep("std",features$V2),]
features_list <- rbind(features_mean,features_std)

###2.3 getting colnumbers for all mean/std cols and extracting cols from X_ to Selected_X
features_col <- features_list[["V1"]]
Selected_X <- a_X_.txt[,features_col]

##2.4 renaming cols in order to avoid duplications 
a_subject_.txt <- rename(a_subject_.txt, SubjectiD = V1)
a_y_.txt <- rename(a_y_.txt, ActivityID = V1)

##2.5 creating merged data 
merged_data <- cbind(a_subject_.txt,a_y_.txt,Selected_X)

##3.1 getting and merging activity data 
activity_table <- read.table("C:/Users/tszajko003/Documents/rr/UCI HAR Dataset/activity_labels.txt")
activity_table <- rename(activity_table, ActivityName = V2)
merged_data2 <- merge(merged_data,activity_table,by.x="ActivityID",by.y="V1")

##4.1 swapping old column names with the ones from feature list
newnames <- c("ActivityID","SubjectID",as.character(features_list$V2),"ActivityName")
oldnames <- names(merged_data2)
names(merged_data2) <- str_replace(string=names(merged_data2),pattern=oldnames, replacement=newnames)

##5.1 creating tidy data set
merged_data3 <- merged_data2 %>% group_by(ActivityID, SubjectID, ActivityName) %>% summarise_each(funs(mean))