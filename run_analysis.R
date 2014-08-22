# Function to the training and test data sets and produce a independent tidy
# data set with the average of each variable for each activity and each subject
#
# Input Arguments:
#   traindir - Location to the directory containing the training data set
#   testdit  - Location to the directory containing the test data set
#   outfile  - The file name of the tidy data set

run_analysis <- function(traindir="train", testdir="test", outfile="out.txt"){
    # Preperation: Load the data sets, each into a seperate data frame
    trainDF <- load_data(triandir)
    testDF <- load_data(testdir)
    # 1. Merges the training and the test sets to create one data set.
    # 2. Extracts only the measurements on the mean and standard deviation for
    #    each measurement.
    # 3. Uses descriptive activity names to name the activities in the data set
    # 4. Appropriately labels the data set with descriptive variable names.
    # 5. Creates a second, independent tidy data set with the average of each
    #    variable for each activity and each subject.
}

# Loading the data set into a data frame
load_data <- function(srcdir){
    df <- emptydataframe()
    result <- tryCatch({
        # x
    }, warning = function(w) {}, error = function(e) {
        print(paste("ERROR:  ",e))
        stop("Execution halted")
    }, finally = {})
    df
}

# Function to create an empty data frame
emptydataframe <- function(){
    data.frame(Date=as.Date(character()),
               File=character(),
               User=character(),
               stringsAsFactors=FALSE)
}