The run_analysis.R script performs the following steps to clean the data:
1- Read X_train.txt, y_train.txt and subject_train.txt from the "train" folder and store them in trainData, trainLabel and trainSubject variables respectively.
2- Read X_test.txt, y_test.txt and subject_test.txt from the "test" folder and store them in testData, testLabel and testsubject variables respectively.
3- Concatenate testData to trainData to generate a 10299x561 data frame, DT; concatenate testLabel to trainLabel to generate a 10299x1 data frame, Label; concatenate testSubject to trainSubject to generate a 10299x1 data frame, Subject.
4- Read the features.txt file from the main folder and store the data in a variable called features. We only extract the measurements on the mean and standard deviation. This results in a 66 indices list. We get a subset of DT with the 66 corresponding columns.
5- Clean the column names of the subset. We remove the "()" and "-" symbols in the names.
6- Read the activity_labels.txt file from the main folder and store the data in a variable called activity.
7- Clean the activity names in the second column of activity.  If the name has an underscore between letters, we remove the underscore.
8- Transform the values of Label according to the activity data frame.
9- Combine the Subject, Label and DT by column to get a new cleaned 10299x68 data frame. Properly name the first two columns, "Subject" and "Activity". The "Subject" column contains integers that range from 1 to 30 inclusive; the "Activity" column contains 6 kinds of activity names; the last 66 columns contain measurements that range from -1 to 1 exclusive.
10- Write the CleanedData out to "data.txt" file in current working directory.
11- Finally, generate a second independent tidy data set with the average of each measurement for each activity and each subject. We have 30 unique subjects and 6 unique activities, which result in a 180 combinations of the two. Then, for each combination, we calculate the mean of each measurement with the corresponding combination. So, after initializing the result data frame and performing the two for-loops, we get a 180x68 data frame. Finally, the same operation is performed in a one line command using the functions group_by and summarize_all !
12- Write the result out to "data_with_means.txt" file in current working directory.
