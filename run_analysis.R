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
    if( verbose == TRUE ) print(paste("activityLabels: ", activityLabels))

    # Load data sets
    trainDF <- load_data(paste(traindir,"X_train.txt",sep=.Platform$file.sep))
    testDF <- load_data(paste(testdir,"X_test.txt",sep=.Platform$file.sep))

    # Load the subject data
    trainSubjects <- load_singlecolumn_data_as_vector(paste(traindir,"subject_train.txt",sep=.Platform$file.sep))
    testSubjects <- load_singlecolumn_data_as_vector(paste(testdir,"subject_test.txt",sep=.Platform$file.sep))

    # Load activity data
    trainActivities <- load_singlecolumn_data_as_vector(paste(traindir,"y_train.txt",sep=.Platform$file.sep))
    testActivities <- load_singlecolumn_data_as_vector(paste(testdir,"y_test.txt",sep=.Platform$file.sep))

    # 1. Merges the training and the test sets to create one data set.
    # 2. Extracts only the measurements on the mean and standard deviation for
    #    each measurement.
    # 3. Uses descriptive activity names to name the activities in the data set
    # 4. Appropriately labels the data set with descriptive variable names.
    # 5. Creates a second, independent tidy data set with the average of each
    #    variable for each activity and each subject.
}

# Loading the data set into a data frame
# Input Arguments:
#   srcfile - The file to load
load_data <- function(srcfile){
    df <- emptydataframe()
    result <- tryCatch({
        df <- read.table(srcfile)
    }, warning = function(w) {}, error = function(e) {
        print(paste("ERROR:  ",e))
        stop("Execution halted")
    }, finally = {})
    df
}

# Load subject data
# Input Arguments:
#   filename - The file to load as a data frame, wrapping load_data()
#   columnNr - The column number to extract as a vector
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