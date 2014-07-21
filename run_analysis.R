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

extractSourceData <- function() {
  dataDir <- "data"
  unzip(
    localFilename,
    exdir = dataDir,
    junkpaths = TRUE,
    overwrite = FALSE
  )
}
extractSourceData()