# Read Excel Data
library(readxl)
Dataset <- read_excel("E:/APRIL/Skill Training/R/Machine Learning/Landslide Susceptibility Assesment/Data/Training Dataset & Testing Dataset.xlsx")
Dataset

# Inspect Data
sample(Dataset, 5)
dim(Dataset)

library(dplyr)
Dataset2 <- select(Dataset,-Sumber)
str(Dataset2) # Found Some issues that L is known as chr (Character)

# Change chr data type into num (numeric) by using gsub
Dataset2$L = as.numeric(gsub(",","", Dataset2$L))
str(Dataset2)

# Split Data Into Training and Testing Data
library(caTools)
set.seed(101)
split <- sample.split(Dataset2$L, SplitRatio = 0.7)
split
train <- subset(Dataset2, split == TRUE)
test <- subset(Dataset2, split == FALSE)
View(train)
View(test)

# Building Logistic Regression Model
logit <-glm(L~.,train, family="binomial")
summary(logit) # summary model

# Implementing Data
## Calling The Background Data
BD <- read_excel("E:/APRIL/Skill Training/R/Machine Learning/Landslide Susceptibility Assesment/Data/Background Data.xlsx")
View(BD)
str(BD)

## Create landslide probability
prob <- predict(logit, newdata = select(BD,-X,-Y), type = "response")
str(prob)
## Change List into a Dataframe
Landslide_Prob <- as.data.frame(do.call(cbind, prob))
Landslide_Prob <- rename(Landslide_Prob , Probability = 1) # Change Columns Name Using index with dplyr 
View(Landslide_Prob)

# Add Probability Value into Background Data Frame
BD$Probability <- Landslide_Prob$Probability 
BD
# Getting New Data Frame with X Y Z(Landslide Probability)
Landslide_Susceptibility <- select(BD, c("X","Y","Probability"))
View(Landslide_Susceptibility)


library(raster)
#Rasterize XYZ
LSM <- rasterFromXYZ(Landslide_Susceptibility)
crs(LSM) <- crs("+proj=utm +zone=49 +south +datum=WGS84 +units=m +no_defs")
writeRaster(LSM, filename ="E:/APRIL/Skill Training/R/Machine Learning/Landslide Susceptibility Assesment/Landslide Susceptibility Map in Pacet District.tif", "GTiff", overwrite=TRUE)
LS_Map = raster("E:/APRIL/Skill Training/R/Machine Learning/Landslide Susceptibility Assesment/Landslide Susceptibility Map in Pacet District.tif")
plot(LS_Map)