CodeBook for Tidy Data Set
==========================

Summary
-------

The tidied data set contains the average (mean) of each measurement grouped by Subject and Activity Type.

For example, the value in column "TimeBodyAcc-mean-X" is the average (mean) for a Subject doing a certain Activity.

If the column name ends in a "-X", "-Y" or "-Z", in indicated the X, Y or Z axxis for the measurement.

Column names starting with "Time" indicate the measurements in time. See the original data set "features_info.txt" for details.

Column names starting with Frequency is the average (mean) of the measurements after calculating the Fast Fourier Transform values. See the original data set "features_info.txt" file for details.

Columns
-------

```
Subject
	Definition: Subject identifier
	Value Type: INTEGER 

Activity
	Definition: Descriptive activity name
	Value Type: STRING
```

For the rest of the column definitions, refer to the summary and original CodeBook, which is also copied and modified below:

Feature Selection 
=================

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

```
TimeBodyAcc-XYZ
TimeGravityAcc-XYZ
TimeBodyAccJerk-XYZ
TimeBodyGyro-XYZ
TimeBodyGyroJerk-XYZ
TimeBodyAccMag
TimeGravityAccMag
TimeBodyAccJerkMag
TimeBodyGyroMag
TimeBodyGyroJerkMag
FrequencyBodyAcc-XYZ
FrequencyBodyAccJerk-XYZ
FrequencyBodyGyro-XYZ
FrequencyBodyAccMag
FrequencyBodyAccJerkMag
FrequencyBodyGyroMag
FrequencyBodyGyroJerkMag
```

The set of variables that were estimated from these signals are: 

```
mean: Mean value
StanderdDiv: Standard deviation
meanFreq: Weighted average of the frequency components to obtain a mean frequency
```

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

```
gravityMean
TimeBodyAccMean
TimeBodyAccJerkMean
TimeBodyGyroMean
TimeBodyGyroJerkMean
```
