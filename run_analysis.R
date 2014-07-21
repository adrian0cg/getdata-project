# util functions
dataRelativePath <- function (trainOutputFilename) {
  paste(dataDir,trainOutputFilename,sep="/")
}

# get source data from web
downloadSourceData <- function() {
  remoteUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  localFilename <<- "UCI-HAR-Dataset.zip"
  if (!file.exists(localFilename)) {
    download.file(
      remoteUrl,
      localFilename,
      method = "curl"
    )      
  }
}
downloadSourceData()
# prepare source data
extractSourceData <- function() {
  dataDir <<- "data"
  unzip(
    localFilename,
    exdir = dataDir,
    junkpaths = TRUE,
    overwrite = FALSE
  )
}
extractSourceData()

# start assembly of label output (y) data frame
readOutputData <- function() {
  testOutputFilename <- "y_test.txt"
  trainOutputFilename <- "y_train.txt"
  testOutput <- read.table( dataRelativePath(testOutputFilename))
  trainOutput <- read.table( dataRelativePath(trainOutputFilename))
  output <<- rbind(trainOutput, testOutput)
}
readOutputData()
# annotate the output labels with corresponding activity labels
annotateOutputWithFactors <- function() {
  labelFilename <- "activity_labels.txt"
  outputLabels <- read.table(
    dataRelativePath(labelFilename),
    stringsAsFactors = TRUE
  )
  activities <<- merge( output, outputLabels, by.y = "V1", all.x = TRUE)
}
annotateOutputWithFactors()

# start assembly of input (X) data frame
readInputData <- function() {
  testInputFilename <- "X_test.txt"
  trainInputFilename <- "X_train.txt"
  testInput <- read.table( dataRelativePath(testInputFilename))
  trainInput <- read.table( dataRelativePath(trainInputFilename))
  input <<- rbind(trainInput, testInput)
}
#readInputData()