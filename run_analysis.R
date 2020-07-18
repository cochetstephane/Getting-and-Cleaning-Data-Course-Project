library(data.table)
library(tidyr)
library(dplyr)

# Working in the HAR directory  directory to get activity labels and features list
setwd("./UCI HAR Dataset")

files <- list.files()

activity <- read.table(files[1], sep = " ")
features <- read.table(files[2], sep = " ")
head(activity)
features[1:5,1:2]

dim(activity)  # 6 x 2

dim(features) # 561 x 2

# Working in the train directory to load data
trainData <- read.table("./train/X_train.txt")
dim(trainData)  #7352x561
trainLabel <- read.table("./train/y_train.txt")
table(trainLabel)
trainSubject <- read.table("./train/subject_train.txt")
table(trainSubject)

# Working in the test directory to load data
testData <- read.table("./test/X_test.txt")
dim(testData)
testLabel <- read.table("./test/y_test.txt")
table(testLabel)
testSubject <- read.table("./test/subject_test.txt")
table(testSubject)

# Join the train/test datas
DT<- rbind(trainData,testData)
Label <- rbind(trainLabel, testLabel)
Subject <- rbind(trainSubject,testSubject)

# Question2 : Extracts only the measurements on the mean and standard 
# deviation for each measurement

# List of indices with mean or std
meanStdIndices <- grep("mean\\(\\)|std\\(\\)", features[, 2])

DT <- DT[,meanStdIndices] # Keep the columns in DT with features of mean or std
features <- features[meanStdIndices,2]

# Rename with appropriate name and clean up of the naming
colnames(DT) <- features
dim(DT) # 10299 * 66

names(DT) <- gsub("\\(\\)", "", names(DT)) # remove the () in column names
names(DT) <- gsub("-", "", names(DT)) # remove the - in column names

# Question 3: Use descriptive activity names to name the activities in the data set
Label$V1 <- as.factor(Label$V1)
levels(Label$V1) <- list("WALKING"=1,"WALKING UPSTAIRS"=2,"WALKING DOWNSTAIRS"=3, "SITTING"=4,"STANDING"=5,"LAYING"=6)
colnames(Label) <- "Activity"

# Question 4: Appropriately labels the data set with descriptive activity names
colnames(Subject) <- "Subject"
Cleaned_DT <- cbind(Subject, Label, DT)
dim(Cleaned_DT)   # 10299 x 68
Cleaned_DT [1:5,1:3]
#  Subject Activity    tBodyAcc-mean-X
#1       1 STANDING       0.2885845
#2       1 STANDING       0.2784188
#3       1 STANDING       0.2796531
#4       1 STANDING       0.2791739
#5       1 STANDING       0.2766288

setwd("../")
write.table(Cleaned_DT, "data.txt")

# Question 5: Create a second, independant tidy data set with the average of each variable
# for each activity and each subject
People <- length(table(Subject))  #30
Activity <- length(table(Label))    #6
Column <- dim(Cleaned_DT)[2]    #68
Res <- matrix(NA, nrow = People*Activity, ncol = Column)
result <- as.data.frame(Res)
colnames(result) <- colnames(Cleaned_DT)
activity[,2] <- gsub("_"," ", activity[,2])

row <- 1

for (i in 1:People){
        for (j in 1:Activity){
                result[row,1] <- sort(unique(Subject)[,1][i])
                result[row,2] <- activity[j, 2]
                boolean1 <- i == Cleaned_DT$Subject
                boolean2 <- activity [j,2] == Cleaned_DT$Activity
                result [row, 3: Column] <- colMeans(Cleaned_DT[boolean1&boolean2, 3:Column])
                row <- row +1
        }
}

# A more elegant way to perform the same result: shorter and concise !
tidy_data<- Cleaned_DT %>% group_by(Subject, Activity )%>% summarise_all(mean)

# Create a data set of previous step as a txt file

write.table(result, file = "data_with_means.txt", row.name = FALSE)
