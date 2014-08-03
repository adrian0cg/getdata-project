setwd("~/Documents/R-DataScience/getdata/project/data")
# activities
y_test <- read.table("y_test.txt")
y_train <- read.table("y_train.txt")
y <- rbind(y_train, y_test)
# subjects
subject_test <- read.table("subject_test.txt")
subject_train <- read.table("subject_train.txt")
subjects <- rbind(subject_train, subject_test)
# combined
subjectActivities <- data.frame(subject=subjects,activityRaw=y)
names(subjectActivities) <- c("subject","activityRaw")
# labels
activityLabels <- read.table("activity_labels.txt")
names(activityLabels) <- c("activityRaw", "activity")
# merge all
subjectActivityLabeled <- merge(subjectActivities,activityLabels)
# count observations
table(subjectActivityLabeled[,c("subject","activity")])