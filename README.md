# Getting-and-Cleaning-Data-Course-Project
Assigment of lecture 4

- Relevant datas are included in the test and train folders
- The  first opration consists in loading the data defined as colum names subject, X and y (aka activity)
- test and train are asembed to give the DT (data table result)
- X contains a set of measurements which are separated in subsequent rows
- Calculation of mean and standard deviation is then possible for each initial row representing the activity (walking, ...) or an individual X
- It gives the tidy data set with 4 columns (subject, mean, sd and activity) which is transformed as a data table set named data
- A problem is encountered to rename the int label of activity as a character string of the activity. I remain with int values. I value your correction
- Finally, the average of each activity per subset and per activity is given with the data set new_data
