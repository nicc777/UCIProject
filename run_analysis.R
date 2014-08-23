# Function that produces a independent tidy data set with the average of each
# Subject and Activity per Measure
#
# Input Arguments:
#   traindir - Location to the directory containing the training data set
#   testdit  - Location to the directory containing the test data set
#   outfile  - The file name of the tidy data set
# Output:
#   Data set writtent to file. Filename will be the value in outfile

run_analysis <- function(traindir="train", testdir="test", outfile="out.txt"){

    # Load libraries on which we depend.
    library(reshape2)

    ########################################
    # Preperation Phase
    ########################################

    # Load Activity Labels
    activityLabels <- load_singlecolumn_data_as_vector("activity_labels.txt",columnNr=2)

    # Load the features.txt as column labels and prepare the labels for the
    # TIDY set
    dataColumnLabels <- load_singlecolumn_data_as_vector("features.txt",columnNr=2)
    tidyDataLabels <- c(
        grep_labal_names(dataColumnLabels,".*mean.*"),
        grep_labal_names(dataColumnLabels,".*std.*"),
        "ActivityLabel",
        "Subject")

    # Load data sets (data frame) and add the column labels
    trainDF <- load_data(paste(traindir,"X_train.txt",sep=.Platform$file.sep))
    names(trainDF) <- dataColumnLabels
    testDF <- load_data(paste(testdir,"X_test.txt",sep=.Platform$file.sep))
    names(testDF) <- dataColumnLabels

    # Load the subject data (vector - object count corresponds to data frame rows)
    trainSubjects <- load_singlecolumn_data_as_vector(paste(traindir,"subject_train.txt",sep=.Platform$file.sep))
    testSubjects <- load_singlecolumn_data_as_vector(paste(testdir,"subject_test.txt",sep=.Platform$file.sep))

    # Load activity data (vector - object count corresponds to data frame rows)
    trainActivities <- load_singlecolumn_data_as_vector(paste(traindir,"y_train.txt",sep=.Platform$file.sep))
    trainActivities <- remap_activities(trainActivities,activityLabels)
    trainDF[,"ActivityLabel"] <- trainActivities
    testActivities <- load_singlecolumn_data_as_vector(paste(testdir,"y_test.txt",sep=.Platform$file.sep))
    testActivities <- remap_activities(testActivities,activityLabels)
    testDF[,"ActivityLabel"] <- testActivities

    # Add the Subjects to the data sets for training and test data sets
    trainDF[,"Subject"] <- trainSubjects
    testDF[,"Subject"] <- testSubjects

    ########################################
    # Final Phase
    ########################################

    # 1. Merges the training and the test sets to create one data set.
    masterDF <- rbind(trainDF,testDF)

    # 2. Extracts only the measurements on the mean and standard deviation for
    #    each measurement.
    tidyDF1 <- masterDF[,tidyDataLabels]

    # 3. Uses descriptive activity names to name the activities in the data set
    # DONE EARLIER

    # 4. Appropriately labels the data set with descriptive variable names.
    names(tidyDF1) <- gsub_batch(
        names(tidyDF1),
        c("^t","^f","std","\\.","\\(\\)"),
        c("Time","Frequency","StandardDiv","",""))

    # 5. Creates a second, independent tidy data set with the average of each
    #    variable for each activity and each subject.

    # Get the latest descriptive label names of the measures
    measureLabels <- as.vector(names(tidyDF1)[!(names(tidyDF1) %in% c("Subject", "ActivityLabel"))])

    # Prepare data frame and add column names
    tidyDF2 <- prepare_tidy_dataframe(
        sort(unique(as.vector(tidyDF1$Subject))),
        activityLabels,
        measureLabels)
    names(tidyDF2) <- c(
        "Subject",
        "Activity",
        measureLabels)

    # Create a melted data frame for easy extraction and calculation of the
    # avg. for measures, grouped by Subject and Activity
    tidyDF1Melted <- melt(
        tidyDF1,
        id.vars=c("Subject", "ActivityLabel"),
        measure.vars=names(tidyDF1)[!(names(tidyDF1) %in% c("Subject", "ActivityLabel"))],
        variable.name = "varName",
        value.name = "measure")
    # Add a group label for easier identification of Subject, Activity and
    # Measure to the melted data frame
    tidyDF1Melted$GroupLabel <- paste(
        tidyDF1Melted$Subject,
        tidyDF1Melted$ActivityLabel,
        tidyDF1Melted$varName, sep=".")
    # Extract the group labels and start calculating the average for each
    # measure per Subject and Activity. Update tidyDF2 with the result.
    groupLabels <- unique(as.vector(tidyDF1Melted[,"GroupLabel"]))
    for(group in groupLabels){
        elements <- unlist(strsplit(group,"\\."))
        subjRef = elements[1]
        actvRef = elements[2]
        measRef = elements[3]
        meanVal <- mean(tidyDF1Melted[tidyDF1Melted$GroupLabel == group,"measure"])
        tidyDF2[(tidyDF2$Subject==subjRef & tidyDF2$Activity == actvRef),c(measRef)] <- meanVal
    }

    # Write the data to file - text file with TAB seperated values.
    write.table(tidyDF2,outfile, sep = "\t", col.names=TRUE, row.names=FALSE)

}

# Preperation of the final tidy data frame. Pre-populate with each subject and
# activity and set the default value for the average of each measure to NA.
# Input Arguments:
#   subjects   - Vector containing Subjects
#   activities - Activity Labels
#   measures   - Measurement Labels
# Output:
#   Data frame prepared and populated with NA values for each average measure
prepare_tidy_dataframe <- function(subjects, activities, measures){
    subjectCol <- c()
    activityCol <- c()
    for( subjID in subjects){
        for(activityLabel in activities){
            subjectCol <- c(subjectCol, subjID)
            activityCol <- c(activityCol, activityLabel)
        }
    }
    tidyDF <- data.frame(subjectCol, activityCol)
    for( measure in measures){
        tidyDF <- cbind(tidyDF,NA)
    }
    tidyDF
}


# Batch replace labels, using the gsub function
# Input Arghuments:
#   labels   - Column names of a data frame
#   regexV   - Vector containing regex to search for
#   replaceV - Vector (same length as regexV) with the replacement values
# Output:
#   Updated labels
gsub_batch <- function(labels,regexV,replaceV){
    idx = 1
    for(rx in regexV){
        labels <- gsub(rx, replaceV[idx], labels)
        idx <- idx + 1
    }
    labels
}

# Remapping of a vector - replace activity index numbers with a labels
# Input Arguments
#   x - A vector containing activity values, i.e. c(1,1,2,2,3)
#   labels - A vector containing labels, i.e. c("col1","col2")
# Output:
#   A vector with labels
remap_activities <- function(x, labels){
    idx = 1
    for( lbl in labels){
        x <- gsub(idx, lbl, x)
        idx <- idx + 1
    }
    x
}

# Loading the data set into a data frame
# Input Arguments:
#   srcfile - The file to load
# Output:
#   A data frame
load_data <- function(srcfile){
    df <- emptydataframe()
    result <- tryCatch({
        df <- read.table(srcfile)
    }, warning = function(w) {}, error = function(e) {
        message(paste("ERROR:  ",e))
        stop("Execution halted")
    }, finally = {})
    df
}

# Load data and select one column to return as a vector
# Input Arguments:
#   filename - The file to load as a data frame, wrapping load_data()
#   columnNr - The column number to extract as a vector (default=1)
# Output:
#   A vector with the extracted values
load_singlecolumn_data_as_vector <- function(filename, columnNr=1){
    df <- load_data(filename)
    as.vector(df[,columnNr])
}

# Search for only certain label names given a regular expression
# Input Arguments:
#   labels   - The vector containing all the labels
#   regexstr - The string to match in each label
# Output:
#   Vector containing the matching strings
grep_labal_names <- function(labels,regexstr){
    c(grep(regexstr, x=labels, ignore.case=TRUE, value=TRUE))
}

# Creates an empty data frame
emptydataframe <- function(){
    data.frame(Date=as.Date(character()),
               File=character(),
               User=character(),
               stringsAsFactors=FALSE)
}