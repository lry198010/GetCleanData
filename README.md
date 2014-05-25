R Code For Generate the Tidy Data Set
========================================================

This is The R Script to Read, Manuplate and Generate the required data for the project. The process as descripted as follow

## 1.Set workspace and load required library
```
setwd("/home/liry/D/GetCleanData")
library(reshape2)
```
## 2.Use download.file to download the dataset and unzip outside tha R enviroment
```
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
              "dataset.zip","wget")
```
## 3.Read data and rename the variable (features) to corresponding names. The Third and Fourth instruction
Fist read each data according to the Readme and feature_info.txt, and then rename the variable (features) according to the data in "feature.txt", the subject and activities was named manully, and add group information for test or training
```
read.table("test/X_test.txt",header=FALSE)->testx
read.table("test//subject_test.txt",header=FALSE)->tests
read.table("test//y_test.txt",header=FALSE)->testy
read.table("train//X_train.txt",header=FALSE)->trainx
read.table("train//subject_train.txt",header=FALSE)->trains
read.table("train//y_train.txt",header=FALSE)->trainy
read.table("activity_labels.txt",header=FALSE)->actives
read.table("features.txt",header=FALSE)->features

names(testx)<-features$V2
names(trainx)<-features$V2
names(tests)<-c("subject")
names(trains)<-c("subject")
names(testy)<-c("actives")
names(trainy)<-c("actives")
inTest <- data.frame(group = rep("test",length(testx[,1])))
inTrain <- data.frame(group = rep("train",length(trainx[,1])))
```
## 4.Combine all required table to all-in-one data set (dataset.1). The First instruction
```
cbind(inTest,tests,testy,testx) -> Test
cbind(inTrain,trains,trainy,trainx) -> Train
rbind(Test,Train)->dataset.1
```

## 5.Subseting the dataset.1 to required data set (dataset.2). The Second instruction
We first using regular expression extract the requied features, and then directly used extract features in subsetting.
Note, in orde to exclude features like 'meanFreq' from the extract result, character "(" must be include in the regular-expression strings.
```
dataset.1[,c("group","subject","actives",names(dataset.1)[grep('mean\\(|std',names(dataset.1))])] ->dataset.2
dataset.2$actives <- actives[dataset.2$actives,2]
write.table(dataset.2,"datasetfor1-4.txt",quote=FALSE,row.names=FALSE)
```

## 6. Using tapply and melt function to get average measurement value for each measurement (features, or variables)

```
tidydataset <- melt(tapply(dataset.1[,4],list(dataset.1$subject,dataset.1$actives),mean),id=c(1,2,3,4,5,6))
tidydataset$measurement = 4

for(i in 5:length(names(dataset.1))){
  t <- melt(tapply(dataset.1[,i],list(dataset.1$subject,dataset.1$actives),mean),id=c(1,2,3,4,5,6))
  t$measurement=i
  rbind(tidydataset,t)->tidydataset
}
names(tidydataset)<-c("subject","active","meanValue","measurement")
tidydataset$active <- actives[tidydataset$active,2]
tidydataset$measurement <- names(dataset.1)[tidydataset$measurement]
write.table(tidydataset,"tidydataset.txt",quote=FALSE,row.names=FALSE)
```

## The end
