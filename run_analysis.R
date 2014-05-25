setwd("/home/liry/D/GetCleanData")
library(reshape2)
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
              "dataset.zip","wget")
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
cbind(inTest,tests,testy,testx) -> Test
cbind(inTrain,trains,trainy,trainx) -> Train
rbind(Test,Train)->dataset.1

dataset.1[,c("group","subject","actives",names(dataset.1)[grep('mean\\(|std',names(dataset.1))])] ->dataset.2
dataset.2$actives <- actives[dataset.2$actives,2]
write.table(dataset.2,"datasetfor1-4.txt",quote=FALSE,row.names=FALSE)
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
