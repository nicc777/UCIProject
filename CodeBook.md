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

Subject
	Definition: Subject identifier
	Value Type: INTEGER 

Activity
	Definition: Descriptive activity name
	Value Type: STRING

For the rest of the column definitions, refer to the summary and original CodeBook.
