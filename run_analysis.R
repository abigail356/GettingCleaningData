library(plyr)

# This script reads the Samsung Galaxy S Smartphone Accelerometer data from 
# http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 
# and produces a data frame summarizing the means of a subset of the features by subject and activity. 
# 
# The main function for this program is create.dataset(). Calling this function will perform the following steps: 
#     
# 1. Read the training and test data into a single combined dataset
# 2. Filter the data to include only the features that represent mean() and std() 
# 3. Rename the activity factor values as human readable factor names
# 4. Create a new data frame that summarizes the average for all of the numeric feature values for each 
# subject and activity
# 5. Assign meaningful names to all features in the new data frame

# Get the merged datasets and then create a new dataset that creates a second, 
# independent tidy data set with the average of each variable for each activity and each subject.
create.dataset <- function () { 
    dsAll <- merge.datasets()
    
    # Split the rows by subject and activity and compute the column means
    meansAll <- ddply(dsAll,.(subject,activity),function (x) colMeans(x[,3:ncol(dsAll)]))
    
    # Rename the columns to show that they are mean values computed from the original dataset
    cnames <- colnames(meansAll[,3:ncol(meansAll)])
    cnames <- sapply(cnames,function (x) paste0("Subject-Activity-Mean-",x))
    colnames(meansAll) <- c('subject','activity',cnames)
    
    meansAll
    }


# Read training and test datasets and merge them together
merge.datasets <- function () {
    features <- read.table('./features.txt',stringsAsFactors = FALSE)[,2]
    
    dsTrain <-read.dataset('train',features)
    dsTest <-read.dataset('test',features)
    dsAll <- rbind(dsTrain,dsTest)
    dsAll
}


# Reads a single data set (specified as train or test) and joins the subject and activity 
# labels with the data values.
# Renames activity values to human readable labels
# Filters data to only include mean and stddev values
read.dataset <- function (ds,features) { 
    dsActivities <- read.table(file.path(ds,paste0('y_',ds,'.txt')),colClasses="factor",col.names=c("activity"))
    dsSubjects <-read.table(file.path(ds,paste0('subject_',ds,'.txt')),colClasses="factor",col.names=c("subject"))
    
    dsData <- read.table(file.path(ds,paste0('X_',ds,'.txt')),colClasses="numeric",col.names=features)
    colnames(dsData) <- sapply(colnames(dsData),function (x) gsub("[.]+","-",x))
    # Filter data to mean and std only
    dsData <- dsData[,grep("-mean-|-std-",colnames(dsData))]
    
    # Rename activity factor values 
    activityNames <-read.table('./activity_labels.txt',row.names=1,stringsAsFactors=FALSE)
    actv <- activityNames[,1]
    names(actv) <- rownames(activityNames)
    dsActivities[,1] <- revalue(dsActivities[,1],actv)
    
    cbind(dsSubjects,dsActivities,dsData)
    }




