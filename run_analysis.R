library(data.table)
library(tidyr)
library(dplyr)

# Working in the train directory to load data
setwd("./UCI HAR Dataset/train")

# Listing of current files
files <- list.files()
files <- files [2:4]

subject = c("subject_train", "X_train", "y_train")

for (i in 1:3)
{
        data  <- files [i]
        data <- read.csv(files[i], na.strings = "NA" )
        subject[i] <- data
}

# Data frame Train
DT_train <- as.data.table(subject)
colnames(DT_train)<- c("subject", "X", "y")

# Working in the test directory to load data
setwd("../")
setwd("../")
setwd("./UCI HAR Dataset/test")

# Listing of current files
files <- list.files()
files <- files [2:4]

subject = c("subject_test", "X_test", "y_test")

for (i in 1:3)
{
        data  <- files [i]
        data <- read.csv(files[i], na.strings = "NA" )
        subject[i] <- data
}

# Data frame Test
DT_test <- as.data.table(subject)
colnames(DT_test)<-  c("subject", "X", "y")

# A single data frame with the result of train and test
DT <- rbind(DT_train, DT_test)
DT_bis <- DT

#Some clean up
rm(data)
rm(subject)
rm(files)
#Returm to Documents folder
setwd("../")
setwd("../")

#Extract only the measurements on the mean and standard deviation for each measurement

# number of rows od DT
nrows = dim(DT)[1]

# Initiate the first calculation
DT_bis <- separate_rows(DT[1,], X, convert = TRUE)
DT_bis <- na.omit(DT_bis)
moy = mean(unlist(DT_bis[,2]))
std = sd(unlist(DT_bis[,2]))
tidy <- c(DT_bis[1,1], moy, std, DT_bis[1,3])

for (j in 2:nrows)
{
        DT_bis <- separate_rows(DT[j,], X, convert = TRUE)
        DT_bis <- na.omit(DT_bis)
        moy = mean(unlist(DT_bis[,2]))
        std = sd(unlist(DT_bis[,2]))
        tidy <- rbind(tidy, c(DT_bis[1,1], moy, std, DT_bis[1,3]) )
        rm(DT_bis)
}

colnames(tidy) <- c("subject","mean","sd", "activity")

# Return as a data table
data <- as.data.table(tidy)
rm(tidy)

# Use descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names

# Working in the HAR directory  directory to get activity labels
setwd("./UCI HAR Dataset")

files <- list.files()
files <- files [1]

activity <- read.table(files, sep = " ")
head(activity)
#
#V1                 V2
#1  1            WALKING
#2  2   WALKING_UPSTAIRS
#3  3 WALKING_DOWNSTAIRS
#4  4            SITTING
#5  5           STANDING
#6  6             LAYING

#Return to main directory
setwd("../")

# NOTE: After multiple attempts to change the integer into a character according to the table above,
# I decided to keep using the integer for the next step

# Average of each variable per activity and per subset
# NOTE: Since I was digging with much effort without clear results,
# I swicthed on the old proven method with 2 loops. Would likely know a more 
# convenient and efficient way

new_data <- data[-c(1:nrows),]
new_data <- select(new_data, -3)

for (ind in (1:30))
{
        for (act in (1:6))
        {
          d <-  data %>%
                select(subject, mean , activity)    %>%
                filter(subject == ind, activity == act) 
          
          d   %>%     mutate (mean = mean(as.numeric(d$mean))) 
          
          new_data <- rbind(new_data, d[1,])     
        }
}

# Create a data set od previous step as a txt file

new_data$subject  <- unlist(new_data$subject)
new_data$mean  <- unlist(new_data$mean)
new_data$activity  <- unlist(new_data$activity)
write.table(new_data, file = "tidy.txt", row.name = FALSE, sep="   ")


