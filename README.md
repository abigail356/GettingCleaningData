### Getting and Cleaning Data Programming Assignment

This repository contains an R script titled run_analysis.R which reads the Samsung Galaxy S Smartphone Accelerometer data from http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones and produces a data frame summarizing the means of a subset of the features by subject and activity. 

The main function for this program is create.dataset(). Calling this function will perform the following steps: 

1. Read the training and test data into a single combined dataset
2. Filter the data to include only the features that represent mean() and std() 
3. Rename the activity factor values as human readable factor names
4. Create a new data frame that summarizes the average for all of the numeric feature values for each subject and activity
5. Assign meaningful names to all features in the new data frame