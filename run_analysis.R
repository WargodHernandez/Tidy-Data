# ##############################################################################
# Function used to install packages only if required
# ##############################################################################

Install_If_Required <- function(x){
  for( i in x ){
    #  require returns TRUE invisibly if it was able to load package
    if( ! require( i , character.only = TRUE ) ){
      #  If package was not able to be loaded then re-install
      install.packages( i , dependencies = TRUE )
      #  Load package after installing
      require( i , character.only = TRUE )
    }
  }
}


# ##############################################################################
# List of required Packages
# ##############################################################################

Install_If_Required(c("data.table", "matrixStats", "plyr", "reshape2", "fBasics"))


# ##############################################################################
# Step 1
# Merges the training and the test sets to create one data set.
# ##############################################################################


# Download the zipped files from the provided URL, only if it doesn't already exist
fileURL <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if(!file.exists("./tidydataproject.zip"))
  {
  download.file(fileURL, destfile = "./tidydataproject.zip")
  }

# the unzip function unzips the files and places them in the extract directory specified (exidr) 
# Since LIST is set to false it will not output the file names which were unzipped, 
# it will overwrite the files each time they are extracted

unzip("./tidydataproject.zip", list = FALSE, overwrite = TRUE, exdir = ".")

# Read the X_text files

features <- read.table("~/UCI HAR Dataset/features.txt", quote="\"")

####################################
#  Make Col names more descriptive #
####################################
features[,2]<-gsub("^t", "Time.", features[,2])
features[,2]<-gsub("tBody", "Time.Body", features[,2])
features[,2]<-gsub("^f", "FFT.", features[,2])
features[,2]<-gsub("Acc", ".Acceleration.", features[,2])
features[,2]<-gsub("Body", "Body.", features[,2])
features[,2]<-gsub("Gyro", ".gyroscope.", features[,2])
features[,2]<-gsub("Mag", ".Magnitude.", features[,2])
features[,2]<-gsub("Mean", ".Mean.", features[,2])
features[,2]<-gsub("\\.\\.", ".", features[,2])
features[,2]<-gsub("\\.\\.", ".", features[,2])
features[,2]<-gsub("\\.-", "-", features[,2])
features[,2]<-gsub("\\.,", ",", features[,2])
features[,2]<-gsub("\\.\\)", ")", features[,2])

X_test <- read.table("~/UCI HAR Dataset/test/X_test.txt", quote="\"")
X_train <- read.table("~/UCI HAR Dataset/train/X_train.txt", quote="\"")
subject_test <- read.table("~/UCI HAR Dataset/test/subject_test.txt", quote="\"")
subject_train <- read.table("~/UCI HAR Dataset/train/subject_train.txt", quote="\"")
Y_test <- read.table("~/UCI HAR Dataset/test/Y_test.txt", quote="\"")
Y_train <- read.table("~/UCI HAR Dataset/train/Y_train.txt", quote="\"")
activity_labels <- read.table("~/UCI HAR Dataset/activity_labels.txt", quote="\"")

# column bind the data frames,
test_merge <- cbind(Y_test, subject_test, X_test)
train_merge <- cbind(Y_train, subject_train, X_train)

# append the the two files into one data set
full_set <- rbind(test_merge, train_merge)

# renames the rows according to the features
names <- as.vector(features[,2])
colnames(full_set) <- c("Yset","subject", names)

# ##############################################################################
# Step 2
# Extracts only the measurements on the mean and standard deviation for 
# each measurement. 
# ##############################################################################


# calculate out the mean and SD for each measurement and place in a separate table
means <- colMeans(full_set)
sd <- colStdevs(full_set)

summary <- cbind(c("Yset","subject", names), mean, sd)
colnames(summary) <- c("id","mean", "sd")
summary <- cbind(summary, full_set$Yset)

# ##############################################################################
# Step 3 & 4
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive activity names. 
# ##############################################################################


# add the activity labels to the full data set
full_set1 <- merge(activity_labels, full_set, by.x="V1", by.y="Yset" )
colnames(full_set1) <- c("class", "label", "subject", names)

# ##############################################################################
# Step 5
# Creates a second, independent tidy data set with the average of each 
# variable for each activity and each subject. 
# ##############################################################################


# dcast must ensure the columns to cast are factors. Subject is currently a 
# integer so first we must convert this.
# Assign the column names of full_set1 to a vector 
# For each of the two variables, label and subject, create a new tables with 
# the average of each variable for each activity and each subject. 
# assign a new column to each table with the indicator if the table is a 
# subject or a label.
# Align the column names of the first two columns so both tables have the same
# column names and can be bound together bind the two columns together.

full_set1$subject <- as.factor(full_set1$subject)
col_names <- colnames(full_set1[,4:564])
avg_label <- dcast( melt(full_set1), label ~ col_names, mean)
avg_subject <- dcast( melt(full_set1), subject ~ col_names, mean)
avg_label <- cbind(c("label"), avg_label)
avg_subject <- cbind(c("subject"), avg_subject)
setnames(avg_label,1:2,c("variable", "value"))
setnames(avg_subject,1:2,c("variable", "value"))
tidy_data <- rbind(avg_label, avg_subject)

# ##############################################################################
# Step 6
# Create the tidy data set as a .txt instead of a .csv so it can be 
# uploaded to the coursera project page.
# ##############################################################################


write.table(tidy_data, file="./tidy_data.txt", sep=",", row.names=FALSE)
