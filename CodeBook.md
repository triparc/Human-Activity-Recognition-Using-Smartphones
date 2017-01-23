1. Reading Datasets: The data files are read using:
- 'features_info.txt': readLines("features_info.txt")
- 'features.txt': read.table("features.txt")
- 'activity_labels.txt': read.table("activity_labels.txt")
- 'train/X_train.txt': fread("train/X_train.txt") from data.table package for fast read
- 'train/y_train.txt': read.table("./train/y_train.txt")
- 'test/X_test.txt': fread("./train/X_train.txt")
- 'test/y_test.txt': read.table("test/y_test.txt")
- 'train/subject_train.txt':read.table("train/subject_train.txt")
- 'test/subject_ttest.txt':read.table("./test/subject_test.txt")
2. Verify the structure of test and train data sets using 'str' statement
3. Verify the dimension of the datasets using 'dim' statement
4. Check for null values present in each column using 'summary' statement
5. Combine Train and test datasets using 'rbind' statement - call this as 'combi' data.frame
6. Rename colument headings with feature names
- Extract feature names from features data.frame using:as.character(features$V2)
- names(combi) <- as.character(features$V2)
7. select features only for mean and standard deviations using 'gsub' statement like:
    names(combi) <- gsub("-mean\\(\\)", "Mean", names(combi))
    names(combi) <- gsub("std\\(\\)", "STD", names(combi))
8. Add subject, activity labels and data using 'cbind' statement
9. Make subject as a factor variable for grouping the data sets by subject and activity labels
  combi$subject <- as.factor(combi$subject)
10. Activity labels are already factor variables
11. Now check if there are 10299 observations and 68 columns and contains only maen and sd measurements 
12. Write the tidy  dataset into a file for future processing
  write.table(combi,row.name = FALSE,file = "data_set.csv") 
13. Now, Create a second, independent tidy data set with the average of each variable for each activity and each subject.  
14. Use dplyr package and group_by and summarize_each function:
  combi_mean <- combi %>%
    group_by(activity_label,subject) %>%
    summarise_each(funs(mean))
 15. write this tide data set into a file
 16. The 2nd file can also be created by this list of statements: using apply/sapply and split statements.
   combi <- data.table(arrange(combi, activity_label, subject))
  combi1 <- select(combi, -c(activity_label))
  gb <- split(combi1, combi$activity_label)
  gb_sub <- lapply(gb, function(x) split(x, x[[1]] ))
  gb_sub <- lapply(gb_sub, function(x) lapply(x, function(y) select(y, -1)))
  gb_mean <- lapply(gb_sub, function(x) lapply(x, function(y) apply(y, 2, mean)))
  combi_mean <- data.frame(gb_mean)
  Activity_Subject <- names(combi_mean)
  combi_mean <- transpose(combi_mean)
  names(combi_mean) <- names(select(combi1, -1))
  combi_mean <- cbind("Activity_Subject" = Activity_Subject, combi_mean )
