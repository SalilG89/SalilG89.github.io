
library(plyr)

##download.data = function() {
  
  
  if (!file.exists("UCIHARdata")) {
    dir.create("UCIHARdata")
                                  }
  if (!file.exists("UCIHARdata/UCI HAR Dataset")) {
    # download the data
    ZipURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    FileLoc ="UCIHARdata/UCI_HAR_data.zip"
    ##message("Downloading data")
    download.file(ZipURL, destfile = FileLoc)
    unzip(FileLoc, exdir="UCIHARdata")
                                            }
            ##               }

##download.data()


featuresDF <- read.csv('./UCIHARdata/UCI HAR Dataset/features.txt', sep = ' ', header = FALSE)
featuresDF <- as.character(featuresDF[,2])

trainDF.x <- read.table('./UCIHARdata/UCI HAR Dataset/train/X_train.txt')
trainDF.activity <- read.csv('./UCIHARdata/UCI HAR Dataset/train/y_train.txt', sep = ' ', header = FALSE)
trainDF.subject <- read.csv('./UCIHARdata/UCI HAR Dataset/train/subject_train.txt', sep = ' ', header = FALSE)

trainDF <-  data.frame(trainDF.subject, trainDF.activity , trainDF.x)
names(trainDF) <- c(c('subject', 'activity'), featuresDF)

testDF.x <- read.table('./UCIHARdata/UCI HAR Dataset/test/X_test.txt')
testDF.activity <- read.csv('./UCIHARdata/UCI HAR Dataset/test/y_test.txt', sep = ' ', header = FALSE)
testDF.subject <- read.csv('./UCIHARdata/UCI HAR Dataset/test/subject_test.txt', sep = ' ', header = FALSE)

testDF <-  data.frame(testDF.subject, testDF.activity, testDF.x)
names(testDF) <- c(c('subject', 'activity'), featuresDF)


traintestDF  <- rbind(trainDF, testDF)

col.select <- grep('mean|std', featuresDF)
selectData <- traintestDF[,c(1,2,col.select + 2)]





activity_labels <- read.table('./UCIHARdata/UCI HAR Dataset/activity_labels.txt', header = FALSE)
activity_labels <- as.character(activity_labels[,2])
selectData$activity <- activity_labels[selectData$activity]




DescriptiveNames <- names(selectData)
DescriptiveNames <- gsub("[(][)]", "", DescriptiveNames)
DescriptiveNames <- gsub("^t", "Time_", DescriptiveNames)
DescriptiveNames <- gsub("^f", "FrequencY_", DescriptiveNames)
DescriptiveNames <- gsub("Acc", "Accelerometer", DescriptiveNames)
DescriptiveNames <- gsub("Gyro", "Gyroscope", DescriptiveNames)
DescriptiveNames <- gsub("Mag", "Magnitude", DescriptiveNames)
DescriptiveNames <- gsub("-mean-", "Mean", DescriptiveNames)
DescriptiveNames <- gsub("-std-", "StandardDeviation", DescriptiveNames)
DescriptiveNames <- gsub("-", "_", DescriptiveNames)
names(selectData) <- DescriptiveNames



tidydf <- aggregate(selectData[,3:81], by = list(activity = selectData$activity, subject = selectData$subject),FUN = mean)
write.table(x = tidydf, file = "myTidyDataframe.txt", row.names = FALSE)



