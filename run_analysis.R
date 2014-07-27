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
  if (!exists("output") || is.null(output) || length(output) != 10299) {
    testOutput <- read.table( dataRelativePath(testOutputFilename))
    trainOutput <- read.table( dataRelativePath(trainOutputFilename))
    rawOutput <<- rbind(trainOutput, testOutput)
  }
}
readOutputData()
# annotate the output labels with corresponding activity labels
annotateOutputWithFactors <- function() {
  if (
    !exists("output") ||
      is.null(output) ||
        all(levels(output) == c("LAYING","SITTING","STANDING","WALKING","WALKING_DOWNSTAIRS","WALKING_UPSTAIRS"))
    ) {
    labelFilename <- "activity_labels.txt"
    outputLabels <- read.table(
      dataRelativePath(labelFilename),
      stringsAsFactors = TRUE
    )
    output <<- merge( rawOutput, outputLabels, by.y = "V1", all.x = TRUE)$V2
  }
}
annotateOutputWithFactors()

# start assembly of input (X) data frame
readInputData <- function() {
  testInputFilename <- "X_test.txt"
  trainInputFilename <- "X_train.txt"
  if (!exists("input") || is.null(input) || any(dim(input) != c(10299,561))) {
    testInput <- read.table( dataRelativePath(testInputFilename))
    trainInput <- read.table( dataRelativePath(trainInputFilename))
    input <<- rbind(trainInput, testInput)
  }
}
readInputData()

readSubjects <- function() {
  testSubjectFilename <- "subject_test.txt"
  trainSubjectFilename <- "subject_train.txt"
  if (!exists("subjects") || is.null(subjects) || length(subjects) != 10299) {
    testSubjects <- read.table( dataRelativePath(testSubjectFilename))
    trainSunjects <- read.table( dataRelativePath(trainSubjectFilename))
    subjects <<- rbind(testSubjects, trainSunjects)
  }
}
readSubjects()

harData <- cbind(subjects, input, output)

annotate <- function() {  
  featureFilename <- "features.txt"
  featureNames <- read.table( dataRelativePath(featureFilename))
  variableNames <- c("subject", as.character(featureNames[,2]), "activity")
  names(harData) <<- variableNames
}
annotate()

prettifyNames <- function() {
  harNames <- names(harData)
  harNamesT <- sub("^t","timeseries", harNames)
  harNamesTS <- sub("^f","freqency", harNamesT)
  harNamesTSAcc <- sub("Acc","Acceleration", harNamesTS)
  harNamesTSAccGyro <- sub("Gyro","AngularMomentum", harNamesTSAcc)
  harNamesTSAccGyroMag <- sub("Mag","Magnitude", harNamesTSAccGyro)
  harNamesTSAccGyroMagBody <- sub("BodyBody","Body", harNamesTSAccGyroMag)
  harPrettyNames <- harNamesTSAccGyroMagBody
  names(harData) <<- harPrettyNames
}
prettifyNames()

spliceMeansStddevs <- function() {
  harMeansStddevs <<- harData[,c(1,grep("(mean|std).{2}-",names(harData)),563)]
}
spliceMeansStddevs()

aggregateMeanForSubjectActivityGroups <- function () {
  subjectActivityMeans <<- aggregate(harMeansStddevs[,2:49],list(harData$subject, harData$activity),mean)
  names(subjectActivityMeans)[1:2] <<- c("subject","activity")
  #names(subjectActivityMeans)[3:50] <<- gsub("(.+)\.(mean|std)\.+[XYZ]","mean.\1.\2.\3",names(subjectActivityMeans)[3:50])
  groupNames <<- sprintf("subject %i performing activity: %s", subjectActivityMeans$subject, subjectActivityMeans$activity)
  tidySubjectActivityMeansOfMeansStddevs <<- data.frame(group=groupNames,subjectActivityMeans)
  names(tidySubjectActivityMeansOfMeansStddevs) <<- sub("...",".",fixed=TRUE,names(tidySubjectActivityMeansOfMeansStddevs))
  names(tidySubjectActivityMeansOfMeansStddevs)[4:50] <<- paste(names(tidySubjectActivityMeansOfMeansStddevs)[4:50],"groupMean",sep=".")
}
aggregateMeanForSubjectActivityGroups()

writeTidyProjectData <- function() {
  tidyFilename <- "tidyGroupMeans.txt"
  write.table(
    tidySubjectActivityMeansOfMeansStddevs,
    file = dataRelativePath(tidyFilename),
    row.names = FALSE
  )
}
writeTidyProjectData()
