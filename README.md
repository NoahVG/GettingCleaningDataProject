README

# GettingCleaningDataProject
Course Project for Getting and Cleaning Data course

This script takes the data from the "Human Activity Recognition Using Smartphones" experiment, 
combines the test and training data, and creates a table of the average of each factor measured, 
by each volunteer number and each type of activity

To run the R script, you'll need to change the working directory (the first line of code, setwd(), to wherever the UCI HAR Dataset is saved on your computer.

 (To read the table of means that is in a text file in r, save it and then run the following code (from David Hood) in Rstudio)  **OR just run the R code, since it will automatically open the table of means for you**
    data <- read.table("file_path", header = TRUE) 
    View(data)

**The R script includes comments explaining each step**
