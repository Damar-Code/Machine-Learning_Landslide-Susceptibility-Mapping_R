# Read Excel Data
library(readxl)
Dataset <- read_excel("E:/APRIL/Skill Training/R/Machine Learning/Landslide Susceptibility Assesment/Data/Training Dataset & Testing Dataset.xlsx")
Dataset

# Inspect Data
sample_n(Dataset, 5)
dim(Dataset)

library(dplyr)
Dataset2 <- select(Dataset,-Sumber)

# Split Data Into Training and Testing Data
library(caTools)
set.seed(101)
split <- sample.split(Dataset2$L, SplitRatio = 0.7)
split
train <- subset(Dataset2, split == TRUE)
test <- subset(Dataset2, split == FALSE)
View(train)
View(test)
