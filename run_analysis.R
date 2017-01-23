##############################################################################################
#                       Getting and Cleaning Data Course Project                             #
#                  Human Activity Recognition Using Smartphones Dataset                      #
###############################################################################################
# The purpose of this project is to demonstrate your ability to collect, work with,           #
# and clean a data set. The goal is to prepare tidy data that can be used for later analysis. # 
# You will be graded by your peers on a series of yes/no questions related to the project.    # 
# You will be required to submit: 1) a tidy data set as described below, 2) a link to a       #
# Github repository with your script for performing the analysis, and 3) a code book that     #
# describes the variables, the data, and any transformations or work that you performed to    #
# clean up the data called CodeBook.md. You should also include a README.md in the repo with  #   
# your scripts. This repo explains how all of the scripts work and how they are connected.    #
# One of the most exciting areas in all of data science right now is wearable computing -     #
# see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to    #
# develop the most advanced algorithms to attract new users. The data linked to from the      # 
# course website represent data collected from the accelerometers from the Samsung Galaxy S   #
# smartphone. A full description is available at the site where the data was obtained:        #
# http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones         #
###############################################################################################
# Data for the project:                                                                       #
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip      #
# Create one R script called run_analysis.R that does the following.                          #
# Merges the training and the test sets to create one data set.                               #
# 1. Extracts only the measurements on the mean and standard deviation for each measurement.  #
# 2. Uses descriptive activity names to name the activities in the data set                   #
# 3. Appropriately labels the data set with descriptive variable names.                       #
# 4. From the data set in step 4, creates a second, independent tidy data set with the average# 
# of each variable for each activity and each subject.                                        #
#                                                                                             #
###############################################################################################
run_analysis = function(){
  # Install packages
  library(data.table)
  library(dplyr)
  # Set the directory path
  getwd()
  setwd("E:\\coursera\\Getting and Cleaning Data\\Week4\\Project\\UCI HAR Dataset\\")
  # Read features-info
  features_info <- readLines("./features_info.txt")
  head(features_info)
  # Read Features
  features <- read.table("./features.txt")
  head(features)
  dim(features)
  # Read Activity Labels
  activity_labels <- read.table("./activity_labels.txt")
  head(activity_labels)
  # Read Train Data
  # Let us use read.table/fread to read this data
  train <- fread("./train/X_train.txt")
  dim(train)
  summary(train)
  # Now we are getting required number of features - 561 and no NAs
  # Read Train labels
  train_labels <- read.table("./train/y_train.txt")
  head(train_labels)  
  dim(train_labels)
  # There are 7352 observations in train_labels
  # Read Train Subject data
  subject_train <- read.table("./train/subject_train.txt")
  head(subject_train)     
  # Read Test Data
  test <- fread("./test/X_test.txt")
  head(test)  
  dim(test)
  # test has 2947 observations and 561 columns
  # train and test have have same columns
  # Read Test labels
  test_labels <- read.table("./test/y_test.txt")
  head(test_labels)   
  dim(test_labels)
  # Read Test Subject data
  subject_test <- read.table("./test/subject_test.txt")
  head(subject_test)  
  # Combine train and test data
  combi <- rbind(train, test)
  dim(combi)
  # Combine train and test labels
  combi_labels <- rbind(train_labels, test_labels)
  dim(combi_labels)
  # Combine train and test subjects
  combi_subject <- rbind(subject_train, subject_test)
  # Rename combi_subject to "subject"
  names(combi_subject) <- "subject"
  # Merge combi_label with activity labels
  combi_labels <- merge(combi_labels, activity_labels, by = "V1")
  # Map combi_labels on "V2" amd rename it to "Subject"
  # use deplyr package
  combi_labels <- select(combi_labels, "activity_label"= V2)
  # Rename the columns from combi dataset with feature names
  names(combi) <- as.character(features$V2)
  # select features only for mean and standard deviations
  combi <- select(combi, contains("mean()"), contains("std()"))
  # Rename -mean()/-std() as Mean/STD
  names(combi) <- gsub("-mean\\(\\)", "Mean", names(combi))
  names(combi) <- gsub("std\\(\\)", "STD", names(combi)) 
  # Combine combi_subject, combi_labels and combi into a single dataset
  combi <- cbind(combi_subject, combi_labels, combi)
  dim(combi)
  str(combi)
  # make subject as a factor variable
  combi$subject <- as.factor(combi$subject)
  # There are 10299 observations and 68 columns and contains tidy data for measurements 
  # only for mean and standard deviation and columns are appropriately named
  #############################################################################################
  # Write the tidy  dataset into a file for future processing
  write.table(combi,row.name = FALSE,file = "data_set.txt") 
  # drop unused datsets
  rm(activity_labels, features, features_info, subject_test, subject_train, 
     test, test_labels,train, train_labels)
  gc(verbose = TRUE)
  ###########################################################################################  
  # Creates a second, independent tidy data set with the average of each variable           #
  # for each activity and each subject.                                                     #      
  ###########################################################################################
  combi_mean <- combi %>%
    group_by(activity_label,subject) %>%
    summarise_each(funs(mean))
    # Write the 2nd dataset into directory 
  write.table(combi_mean,row.name = FALSE,file = "tidy_data_set.txt") 
  }