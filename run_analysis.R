# Function to the training and test data sets and produce a independent tidy
# data set with the average of each variable for each activity and each subject
#
# Input Arguments:
#   traindir - Location to the directory containing the training data set
#   testdit  - Location to the directory containing the test data set
#   outfile  - The file name of the tidy data set

run_analysis <- function(traindir="train", testdir="test", outfile="out.txt",verbose=FALSE){
    # Preperation: Load the data sets, each into a seperate data frame

    # Load Activity Labels
    activityLabels <- load_singlecolumn_data_as_vector("activity_labels.txt",columnNr=2)
    if( verbose == TRUE ) message(paste("activityLabels: ", activityLabels,"\n"))

    # Load the features.txt as column labels
    dataColumnLabels <- load_singlecolumn_data_as_vector("features.txt",columnNr=2)
    if( verbose == TRUE ) message(paste("dataColumnLabels: ", head(dataColumnLabels),"\n"))

    # Load data sets (data frame)
    trainDF <- load_data(paste(traindir,"X_train.txt",sep=.Platform$file.sep))
    names(trainDF) <- dataColumnLabels
    if( verbose == TRUE ) message(paste("trainDF: nr of rows: ", nrow(trainDF)))
    testDF <- load_data(paste(testdir,"X_test.txt",sep=.Platform$file.sep))
    names(testDF) <- dataColumnLabels
    if( verbose == TRUE ) message(paste("testDF: nr of rows: ", nrow(testDF)))

    # Load the subject data (vector - object count corresponds to data frame rows)
    trainSubjects <- load_singlecolumn_data_as_vector(paste(traindir,"subject_train.txt",sep=.Platform$file.sep))
    if( verbose == TRUE ) message(paste("trainSubjects: nr of subjects: ", length(trainSubjects)))
    testSubjects <- load_singlecolumn_data_as_vector(paste(testdir,"subject_test.txt",sep=.Platform$file.sep))
    if( verbose == TRUE ) message(paste("testSubjects: nr of subjects: ", length(testSubjects)))

    # Load activity data (vector - object count corresponds to data frame rows)
    trainActivities <- load_singlecolumn_data_as_vector(paste(traindir,"y_train.txt",sep=.Platform$file.sep))
    trainActivities <- remap_activities(trainActivities,activityLabels)
    trainDF[,"train.ActivityLabel"] <- trainActivities
    if( verbose == TRUE ) message(paste("trainActivities: nr of subjects: ", length(trainActivities)))
    testActivities <- load_singlecolumn_data_as_vector(paste(testdir,"y_test.txt",sep=.Platform$file.sep))
    testActivities <- remap_activities(testActivities,activityLabels)
    testDF[,"test.ActivityLabel"] <- testActivities
    if( verbose == TRUE ) message(paste("testActivities: nr of subjects: ", length(testActivities)))

    # Add the Subjects to the data sets for training and test data sets
    trainDF[,"train.Subject"] <- trainSubjects
    testDF[,"test.Subject"] <- testSubjects

    #x <<- testDF      # > View(head(x[,c(500:563)]))      # IGNORE!!! Mark for delete
    #y <<- trainDF

    # 1. Merges the training and the test sets to create one data set.
    # 2. Extracts only the measurements on the mean and standard deviation for
    #    each measurement.
    # 3. Uses descriptive activity names to name the activities in the data set
    # 4. Appropriately labels the data set with descriptive variable names.
    # 5. Creates a second, independent tidy data set with the average of each
    #    variable for each activity and each subject.
}

# Remapping of a vector - replace activity index numbers with a labels
# Input Arguments
#   x - A vector containing activity values, i.e. c(1,1,2,2,3)
#   labels - A vector containing labels, i.e. c("col1","col2")
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
load_singlecolumn_data_as_vector <- function(filename, columnNr=1){
    df <- load_data(filename)
    as.vector(df[,columnNr])
}

# Function to create an empty data frame
emptydataframe <- function(){
    data.frame(Date=as.Date(character()),
               File=character(),
               User=character(),
               stringsAsFactors=FALSE)
}