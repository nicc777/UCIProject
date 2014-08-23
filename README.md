UCIProject
==========

R function to create a data set with the average of each measure for each activity and each subject from the original UCI data sets

Data Source
-----------

Here is the data required for the project: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

Assumptions
-----------

The R script assumes you have R installed and that the source data above has been downloaded and unzipped.

Script: run_analysis.R
----------------------

This script does the following:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

You can specify the following input arguments for the function 'run_analysis':

* traindir - Location to the directory containing the training data set (default="train")
* testdit  - Location to the directory containing the test data set (default="test")
* outfile  - The file name of the tidy data set (default="out.txt")

Typically you only need to run it as run_analysis()

Result
------

The result is written to a file specified in the run_analysis.R file by outfile.

The code book for this file is located in this repository with the name CodeBook.md

Performance Notes
-----------------

The code has not been optimized for speed. It may run slow on some older systems.
