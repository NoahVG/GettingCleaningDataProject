#sets working directory
setwd("C:/Users/nvegh-gaynor/Documents/Coursera/getting and cleaning data/project/UCI HAR Dataset")
#gets data names and removes first column, since it's just numbers
features<-read.table("features.txt")
features<-features[,2]
#gets train files
train_subject_train<-read.table("train/subject_train.txt")
train_X_train<-read.table("train/X_train.txt")
train_y_train<-read.table("train/y_train.txt")
#replaces y vals with the actual meaning (e.g. 1=walking, etc)
train_y_train[,1]<-ifelse(train_y_train[,1]==1,"WALKING",train_y_train[,1])
train_y_train[,1]<-ifelse(train_y_train[,1]==2,"WALKING_UPSTAIRS",train_y_train[,1])
train_y_train[,1]<-ifelse(train_y_train[,1]==3,"WALKING_DOWNSTAIRS",train_y_train[,1])
train_y_train[,1]<-ifelse(train_y_train[,1]==4,"SITTING",train_y_train[,1])
train_y_train[,1]<-ifelse(train_y_train[,1]==5,"STANDING",train_y_train[,1])
train_y_train[,1]<-ifelse(train_y_train[,1]==6,"LAYING",train_y_train[,1])
#adds names of each data set
names(train_X_train)<-features
#combines train files
train<-cbind(train_subject_train,train_y_train,train_X_train)

#gets test files
test_subject_test<-read.table("test/subject_test.txt")
test_X_test<-read.table("test/X_test.txt")
test_y_test<-read.table("test/y_test.txt")
#replaces y vals with the actual meaning (e.g. 1=walking, etc)
test_y_test[,1]<-ifelse(test_y_test[,1]==1,"WALKING",test_y_test[,1])
test_y_test[,1]<-ifelse(test_y_test[,1]==2,"WALKING_UPSTAIRS",test_y_test[,1])
test_y_test[,1]<-ifelse(test_y_test[,1]==3,"WALKING_DOWNSTAIRS",test_y_test[,1])
test_y_test[,1]<-ifelse(test_y_test[,1]==4,"SITTING",test_y_test[,1])
test_y_test[,1]<-ifelse(test_y_test[,1]==5,"STANDING",test_y_test[,1])
test_y_test[,1]<-ifelse(test_y_test[,1]==6,"LAYING",test_y_test[,1])
#adds names of each data set
names(test_X_test)<-features
#combines test files
test<-cbind(test_subject_test,test_y_test,test_X_test)

#adds a column saying if data is train or test and moves it to the 3rd column (so it's easier to access)
test$type<-"test"
train$type<-"train"
test<-test[,c(1:2,564,3:563)]
train<-train[,c(1:2,564,3:563)]
#combines train and test data
data<-rbind(train,test)
#renames first two columns
names(data)[1]<-"Volunteer number"
names(data)[2]<-"Type of activity"
#gets only mean/std dev cols (any column with a header that contains 'mean' or 'std'), along with the first 3 columns labeling the data
install.packages("dplyr")
library(dplyr)
data_mean<-select(data,(contains("mean")))
data_std_dev<-select(data,contains("std"))
data_labels<-data[,1:3]
data_mean_std<-cbind(data_labels,data_mean,data_std_dev)
#removes spaces from names so they can be called more easily
names(data_mean_std)<-gsub(" ","",names(data_mean_std),)
#changes type variable to numeric so it can be inclded in the mean dataset
data_mean_std$type<-ifelse(data_mean_std$type=="train",1,2)

#creates a table of the means for each volunteer/activity
install.packages("data.table")
library(data.table)
variables<-tail(names(data_mean_std),-2)
mean_table<-data.table(data_mean_std)
mean_table<-mean_table[,lapply(.SD,mean),.SDcols=variables, by=list(mean_table$Volunteernumber,mean_table$Typeofactivity)]

#converts type back to text, changes label column names
setnames(mean_table,mean_table[,1],"VolunteerNumber")
setnames(mean_table,mean_table[,2],"TypeOfActivity")
mean_table$type<-ifelse(mean_table$type==1,"train","test")
#exports table as a text file
write.table(mean_table,"table of means.txt",row.name=FALSE)
#imports and views table from text file
output<-read.table("table of means.txt",header=TRUE)
View(output)
