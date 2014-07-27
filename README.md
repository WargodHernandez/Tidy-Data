Tidy-Data
=========

Data for the project is automatically downloaded in the script from the following address: 
	https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
======================================
Script Steps are below.


Includes the function Install_If_Required to load all required packages 

We use the following packages to execute the script.

Install_If_Required(c("data.table", "matrixStats", "plyr", "reshape2", "fBasics"))
	

Step 1
=======
 Downloads the zipped files from the provided URL if they don't already exist in work directory
 Merges the training and the test sets to create one data set.
 The unzip function unzips the files and places them in the extract directory specified
 it will overwrite the files each time they are extracted
 Modify the features data with expanded descriptions
 Read the files
 column bind the data frames,
 append the the two files into one data set
 renames the rows according to the features

Step 2
=======
 Extracts only the measurements on the mean and standard deviation for each measurement. 
 calculate out the mean and SD for each measurement and place in a separate table

Step 3 & 4
========
 Uses descriptive activity names to name the activities in the data set
 Labels the data set with descriptive activity names. 
 add the activity labels to the full data set

Step 5
========
 In order to use dcast we must ensure the columns to cast are factors. Subject is currently a integer so first we must convert this.
 Assign the column names of full_set1 to a vector 
 For each of the two variables, label and subject, create a new tables with the average of each variable for each activity and each subject. 
 Assign a new column to each table with the indicator if the table is a subject or a label.
 Align the column names of the first two columns so both tables have the same column names and can be bound together
 bind the two columns together.

Step 6
========
Output the tidy data table to a text file for later upload, and set the row names not to be outputted.

The outputted tidy data set has the following column names:
=========================================
1) variable - this indicates whether the row represents the average for a subject or label

2) value - this indicates the value for the subject or label for which we are calculating averages

3) The remainig columns represent each individual measurement for which we are taking averages.
