---
title: "Practical Machine Learning - Course Project"
subtitle: 'Jhons Hopkins University - Data Science Specialization - Course #8'
author: "Diego Angulo"
date: "July 31, 2019"
output: 
  html_document:
    keep_md: true
---



## **Executive Summary**
This report is a course project within the [Practical Machine Learning Course](https://www.coursera.org/learn/practical-machine-learning) on the [Data Science Specialization](https://www.coursera.org/specializations/jhu-data-science) by Johns Hopkins University on [Coursera](https://www.coursera.org/). 

In this report, we are describing how a machine learning algorithm was built to predict the manner in which 6 participants did an exercise. Using cross validation, specifying what the expected out of sample error was, and why some choices were made. This prediction model was also used to predict 20 different test cases.

##**Background**
Using devices such as Jawbone Up, Nike FuelBand, and Fitbit it is now possible to collect a large amount of data about personal activity relatively inexpensively. These type of devices are part of the quantified self movement - a group of enthusiasts who take measurements about themselves regularly to improve their health, to find patterns in their behavior, or because they are tech geeks. <br/>

One thing that people regularly do is quantify how much of a particular activity they do, but they rarely quantify how well they do it. In this project, your goal will be to use data from accelerometers on the belt, forearm, arm, and dumbell of 6 participants. They were asked to perform barbell lifts correctly and incorrectly in 5 different ways. <br/>

More information is available from the website here: [http://groupware.les.inf.puc-rio.br/har](http://groupware.les.inf.puc-rio.br/har) (see the section on the Weight Lifting Exercise Dataset).<br/>


##**About the Data Set**
 
 **A short extract from the web source:**<br/>
Six young health participants were asked to perform one set of 10 repetitions of the Unilateral Dumbbell Biceps Curl in five different fashions: exactly according to the specification (Class A), throwing the elbows to the front (Class B), lifting the dumbbell only halfway (Class C), lowering the dumbbell only halfway (Class D) and throwing the hips to the front (Class E).
Class A corresponds to the specified execution of the exercise, while the other 4 classes correspond to common mistakes. 
 
The data for this project come from this source: [http://groupware.les.inf.puc-rio.br/har](http://groupware.les.inf.puc-rio.br/har).
 
**Data Authors:** <br/>
Velloso, E.; Bulling, A.; Gellersen, H.; Ugulino, W.; Fuks, H. Qualitative Activity Recognition of Weight Lifting Exercises. Proceedings of 4th International Conference in Cooperation with SIGCHI (Augmented Human '13) . Stuttgart, Germany: ACM SIGCHI, 2013.
 
Special thanks to the above mentioned for allowing their data to be used for academic purposes.

##**Data Processing**
**Setting the working directory and the required libraries.**


```r
 # Setting working directory first
setwd("~/Coursera/8_Data_Science_Specialization/8 Practical Machine Learning/Week 4/Assignment")

 # Removes all objects from the current workspace (R memory)
rm(list=ls())                

 # Libraries
library(knitr)
library(dplyr)
library(rpart)
library(rpart.plot)
library(rattle)
library(randomForest)
library(corrplot)
library(caret)

library(RColorBrewer)
library(gbm)

 # Set seed to create reproducibility
set.seed(12345)
```

**Loading the Data**

```r
TrainData <- read.csv(url("https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv"),header=TRUE)
dim(TrainData)
```

```
## [1] 19622   160
```

```r
ValidData <- read.csv(url("https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv"),header=TRUE)
dim(ValidData)
```

```
## [1]  20 160
```

```r
str(TrainData)
```

```
## 'data.frame':	19622 obs. of  160 variables:
##  $ X                       : int  1 2 3 4 5 6 7 8 9 10 ...
##  $ user_name               : Factor w/ 6 levels "adelmo","carlitos",..: 2 2 2 2 2 2 2 2 2 2 ...
##  $ raw_timestamp_part_1    : int  1323084231 1323084231 1323084231 1323084232 1323084232 1323084232 1323084232 1323084232 1323084232 1323084232 ...
##  $ raw_timestamp_part_2    : int  788290 808298 820366 120339 196328 304277 368296 440390 484323 484434 ...
##  $ cvtd_timestamp          : Factor w/ 20 levels "02/12/2011 13:32",..: 9 9 9 9 9 9 9 9 9 9 ...
##  $ new_window              : Factor w/ 2 levels "no","yes": 1 1 1 1 1 1 1 1 1 1 ...
##  $ num_window              : int  11 11 11 12 12 12 12 12 12 12 ...
##  $ roll_belt               : num  1.41 1.41 1.42 1.48 1.48 1.45 1.42 1.42 1.43 1.45 ...
##  $ pitch_belt              : num  8.07 8.07 8.07 8.05 8.07 8.06 8.09 8.13 8.16 8.17 ...
##  $ yaw_belt                : num  -94.4 -94.4 -94.4 -94.4 -94.4 -94.4 -94.4 -94.4 -94.4 -94.4 ...
##  $ total_accel_belt        : int  3 3 3 3 3 3 3 3 3 3 ...
##  $ kurtosis_roll_belt      : Factor w/ 397 levels "","-0.016850",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ kurtosis_picth_belt     : Factor w/ 317 levels "","-0.021887",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ kurtosis_yaw_belt       : Factor w/ 2 levels "","#DIV/0!": 1 1 1 1 1 1 1 1 1 1 ...
##  $ skewness_roll_belt      : Factor w/ 395 levels "","-0.003095",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ skewness_roll_belt.1    : Factor w/ 338 levels "","-0.005928",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ skewness_yaw_belt       : Factor w/ 2 levels "","#DIV/0!": 1 1 1 1 1 1 1 1 1 1 ...
##  $ max_roll_belt           : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ max_picth_belt          : int  NA NA NA NA NA NA NA NA NA NA ...
##  $ max_yaw_belt            : Factor w/ 68 levels "","-0.1","-0.2",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ min_roll_belt           : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ min_pitch_belt          : int  NA NA NA NA NA NA NA NA NA NA ...
##  $ min_yaw_belt            : Factor w/ 68 levels "","-0.1","-0.2",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ amplitude_roll_belt     : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ amplitude_pitch_belt    : int  NA NA NA NA NA NA NA NA NA NA ...
##  $ amplitude_yaw_belt      : Factor w/ 4 levels "","#DIV/0!","0.00",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ var_total_accel_belt    : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ avg_roll_belt           : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ stddev_roll_belt        : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ var_roll_belt           : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ avg_pitch_belt          : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ stddev_pitch_belt       : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ var_pitch_belt          : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ avg_yaw_belt            : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ stddev_yaw_belt         : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ var_yaw_belt            : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ gyros_belt_x            : num  0 0.02 0 0.02 0.02 0.02 0.02 0.02 0.02 0.03 ...
##  $ gyros_belt_y            : num  0 0 0 0 0.02 0 0 0 0 0 ...
##  $ gyros_belt_z            : num  -0.02 -0.02 -0.02 -0.03 -0.02 -0.02 -0.02 -0.02 -0.02 0 ...
##  $ accel_belt_x            : int  -21 -22 -20 -22 -21 -21 -22 -22 -20 -21 ...
##  $ accel_belt_y            : int  4 4 5 3 2 4 3 4 2 4 ...
##  $ accel_belt_z            : int  22 22 23 21 24 21 21 21 24 22 ...
##  $ magnet_belt_x           : int  -3 -7 -2 -6 -6 0 -4 -2 1 -3 ...
##  $ magnet_belt_y           : int  599 608 600 604 600 603 599 603 602 609 ...
##  $ magnet_belt_z           : int  -313 -311 -305 -310 -302 -312 -311 -313 -312 -308 ...
##  $ roll_arm                : num  -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 ...
##  $ pitch_arm               : num  22.5 22.5 22.5 22.1 22.1 22 21.9 21.8 21.7 21.6 ...
##  $ yaw_arm                 : num  -161 -161 -161 -161 -161 -161 -161 -161 -161 -161 ...
##  $ total_accel_arm         : int  34 34 34 34 34 34 34 34 34 34 ...
##  $ var_accel_arm           : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ avg_roll_arm            : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ stddev_roll_arm         : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ var_roll_arm            : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ avg_pitch_arm           : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ stddev_pitch_arm        : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ var_pitch_arm           : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ avg_yaw_arm             : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ stddev_yaw_arm          : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ var_yaw_arm             : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ gyros_arm_x             : num  0 0.02 0.02 0.02 0 0.02 0 0.02 0.02 0.02 ...
##  $ gyros_arm_y             : num  0 -0.02 -0.02 -0.03 -0.03 -0.03 -0.03 -0.02 -0.03 -0.03 ...
##  $ gyros_arm_z             : num  -0.02 -0.02 -0.02 0.02 0 0 0 0 -0.02 -0.02 ...
##  $ accel_arm_x             : int  -288 -290 -289 -289 -289 -289 -289 -289 -288 -288 ...
##  $ accel_arm_y             : int  109 110 110 111 111 111 111 111 109 110 ...
##  $ accel_arm_z             : int  -123 -125 -126 -123 -123 -122 -125 -124 -122 -124 ...
##  $ magnet_arm_x            : int  -368 -369 -368 -372 -374 -369 -373 -372 -369 -376 ...
##  $ magnet_arm_y            : int  337 337 344 344 337 342 336 338 341 334 ...
##  $ magnet_arm_z            : int  516 513 513 512 506 513 509 510 518 516 ...
##  $ kurtosis_roll_arm       : Factor w/ 330 levels "","-0.02438",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ kurtosis_picth_arm      : Factor w/ 328 levels "","-0.00484",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ kurtosis_yaw_arm        : Factor w/ 395 levels "","-0.01548",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ skewness_roll_arm       : Factor w/ 331 levels "","-0.00051",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ skewness_pitch_arm      : Factor w/ 328 levels "","-0.00184",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ skewness_yaw_arm        : Factor w/ 395 levels "","-0.00311",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ max_roll_arm            : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ max_picth_arm           : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ max_yaw_arm             : int  NA NA NA NA NA NA NA NA NA NA ...
##  $ min_roll_arm            : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ min_pitch_arm           : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ min_yaw_arm             : int  NA NA NA NA NA NA NA NA NA NA ...
##  $ amplitude_roll_arm      : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ amplitude_pitch_arm     : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ amplitude_yaw_arm       : int  NA NA NA NA NA NA NA NA NA NA ...
##  $ roll_dumbbell           : num  13.1 13.1 12.9 13.4 13.4 ...
##  $ pitch_dumbbell          : num  -70.5 -70.6 -70.3 -70.4 -70.4 ...
##  $ yaw_dumbbell            : num  -84.9 -84.7 -85.1 -84.9 -84.9 ...
##  $ kurtosis_roll_dumbbell  : Factor w/ 398 levels "","-0.0035","-0.0073",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ kurtosis_picth_dumbbell : Factor w/ 401 levels "","-0.0163","-0.0233",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ kurtosis_yaw_dumbbell   : Factor w/ 2 levels "","#DIV/0!": 1 1 1 1 1 1 1 1 1 1 ...
##  $ skewness_roll_dumbbell  : Factor w/ 401 levels "","-0.0082","-0.0096",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ skewness_pitch_dumbbell : Factor w/ 402 levels "","-0.0053","-0.0084",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ skewness_yaw_dumbbell   : Factor w/ 2 levels "","#DIV/0!": 1 1 1 1 1 1 1 1 1 1 ...
##  $ max_roll_dumbbell       : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ max_picth_dumbbell      : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ max_yaw_dumbbell        : Factor w/ 73 levels "","-0.1","-0.2",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ min_roll_dumbbell       : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ min_pitch_dumbbell      : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ min_yaw_dumbbell        : Factor w/ 73 levels "","-0.1","-0.2",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ amplitude_roll_dumbbell : num  NA NA NA NA NA NA NA NA NA NA ...
##   [list output truncated]
```


**Data Cleaning**<br/>
The training dataset has 19622 observations, and 160 variables. Some of them contains many NA's or empty values. <br/>
In order to get a clean data, we will remove those columns that have at least 90% of this kind of observations. We can also get rid of the first variables, as they contain ID and timestamp information that is not necessary to build the model. 


```r
 # Removing NA's, empty values, and unnecesary variables in the Trainning dataset.
EmptyCols <- which(colSums(is.na(TrainData) |TrainData=="")>0.9*dim(TrainData)[1]) 
TrainDataClean <- TrainData[,-EmptyCols]
TrainDataClean <- TrainDataClean[,-c(1:7)]
dim(TrainDataClean)
```

```
## [1] 19622    53
```

```r
 # Removing NA's, empty values in the Test dataset.
EmptyCols <- which(colSums(is.na(ValidData) |ValidData=="")>0.9*dim(ValidData)[1]) 
ValidDataClean <- ValidData[,-EmptyCols]
ValidDataClean <- ValidDataClean[,-1]
dim(ValidDataClean)
```

```
## [1] 20 59
```

**Low variation data exclusion** <br/>
Some variables may not contain significant variation in their data. This condition makes them either useless for machine learning, since its presence does not indicate a certain class, or can even lead to overfitting.

```r
 # Low variation data exclusion from the TrainData Dataset
NZV <- nearZeroVar(TrainDataClean)
NZV
```

```
## integer(0)
```
Acording to this, all the current variables report some variation. No more variables need to be removed from the training dataset.

**Data Partitioning for prediction** <br/>
Here, we prepare the data for prediction by splitting the training data into 70% as train data and 30% as test data. This splitting will serve to test the model accuracy.

```r
set.seed(12345) 
inTrain <- createDataPartition(TrainDataClean$classe, p = 0.7, list = FALSE)
TrainData <- TrainDataClean[inTrain, ]
TestData <- TrainDataClean[-inTrain, ]
dim(TrainData)
```

```
## [1] 13737    53
```

After cleaning, the new training data set has only 53 columns.<br/>
The validation data `ValidDataClean` remains the same, as it will be used later to test the predictive model on the 20 cases.

##**Exploratoy Data Analysis**
We can take a look into our data and explore the correlations between all the variables before modeling.


```r
corMatrix <- cor(TrainData[, -53])
corrplot(corMatrix, order = "FPC", method = "color", type = "lower", 
         tl.cex = 0.8, tl.col = rgb(0, 0, 0),mar = c(1, 1, 1, 1), title = "Training Dataset Correlogram")
```

![](Practical_Machine_Learning_Project_files/figure-html/unnamed-chunk-6-1.png)<!-- -->
All the correlations have a darker tone of blue if it's closer to 1, and a darker tone of red when it's closer to -1, which means a stronger relationshipin in both cases.


```r
# Count the number of variables that are highly correlated with another one
M <- abs(cor(TrainData[,-53])); diag(M) <- 0
M <- which(M > 0.8, arr.ind = T)
M <- dim(M)[1]
M
```

```
## [1] 38
```
There are 38 pairs of highly correlated variables. In this cases, you could consider not to include some of these variables. In order to combine some variables to have a simpler model, you could also do a principal components analysis to reduce the model noice (due to averaging). <br/>
For the sake of this academic project, we will not do any of these analysis to continue to the model buidling. 

##**Building the Predictive Model**
To predict the outcome, we will use three different methods to model the regression using the `TrainData` dataset:<br/>
   - Random Forests<br/>
   - Decision Trees<br/>
   - Generalized Boosted Model<br/>
Then, they will be applied to the `TestData` dataset to compare accuracies. The best model will be used to predict 20 different test cases to answer the quiz questions.

##**Cross-Validation**
In order to limit the effects of overfitting, and improve the efficicency of the models, we will use the **cross-validation** technique. Cross-validation is done for each model with K = 3. This is set in the above code chunk using the fitControl object as defined below:


```r
fitControl <- trainControl(method='cv', number = 3)
```

##**Decision Trees Model**

```r
# Decision Trees Model
DT_Model <- train(classe~., data=TrainData, method="rpart", trControl=fitControl)
#  Plot 
fancyRpartPlot(DT_Model$finalModel)
```

![](Practical_Machine_Learning_Project_files/figure-html/unnamed-chunk-9-1.png)<!-- -->

**Now we validate the model on the `testData` to find out how well it performs by looking at the accuracy variable.**


```r
# Testing the model
DT_Predict <- predict(DT_Model,newdata=TestData)
DT_cm <- confusionMatrix(TestData$classe,DT_Predict)

# Display confusion matrix and model accuracy
DT_cm
```

```
## Confusion Matrix and Statistics
## 
##           Reference
## Prediction    A    B    C    D    E
##          A 1494   21  128    0   31
##          B  470  380  289    0    0
##          C  467   29  530    0    0
##          D  438  184  342    0    0
##          E  141  147  277    0  517
## 
## Overall Statistics
##                                           
##                Accuracy : 0.4963          
##                  95% CI : (0.4835, 0.5092)
##     No Information Rate : 0.5115          
##     P-Value [Acc > NIR] : 0.9902          
##                                           
##                   Kappa : 0.3425          
##                                           
##  Mcnemar's Test P-Value : NA              
## 
## Statistics by Class:
## 
##                      Class: A Class: B Class: C Class: D Class: E
## Sensitivity            0.4963  0.49934  0.33844       NA  0.94343
## Specificity            0.9374  0.85187  0.88516   0.8362  0.89414
## Pos Pred Value         0.8925  0.33363  0.51657       NA  0.47782
## Neg Pred Value         0.6400  0.91972  0.78679       NA  0.99355
## Prevalence             0.5115  0.12931  0.26610   0.0000  0.09312
## Detection Rate         0.2539  0.06457  0.09006   0.0000  0.08785
## Detection Prevalence   0.2845  0.19354  0.17434   0.1638  0.18386
## Balanced Accuracy      0.7169  0.67561  0.61180       NA  0.91878
```


```r
# Model Acuracy
DT_cm$overall[1]
```

```
##  Accuracy 
## 0.4963466
```
Using **cross-validation** with three steps, the accuracy of this first model is about 0.496, which is very low. This means that the outcome class will not be predicted very well by the other predictors.

##**Random Forests Model**

```r
# Random Forests Model
RF_Model <- train(classe~., data=TrainData, method="rf", trControl=fitControl, verbose=FALSE)
# Plot
plot(RF_Model,main="RF Model Accuracy by number of predictors")
```

![](Practical_Machine_Learning_Project_files/figure-html/unnamed-chunk-12-1.png)<!-- -->

In this plot, we can notice that the model reaches the highest accuracy with two predictors. With more variables added to the model, the difference in the accuracy is not significant, but still lower. The fact that not all the accuracy is much worse with all the available predictors lets us suggest that there may be some dependencies between them.  

**Now we validate the model on the `testData` to find out how well it performs by looking at the accuracy variable.**

```r
# Testing the model
RF_Predict <- predict(RF_Model,newdata=TestData)
RF_cm <- confusionMatrix(TestData$classe,RF_Predict)

# Display confusion matrix and model accuracy
RF_cm
```

```
## Confusion Matrix and Statistics
## 
##           Reference
## Prediction    A    B    C    D    E
##          A 1673    1    0    0    0
##          B   11 1122    6    0    0
##          C    0   13 1009    4    0
##          D    0    0   24  940    0
##          E    0    0    1    3 1078
## 
## Overall Statistics
##                                           
##                Accuracy : 0.9893          
##                  95% CI : (0.9863, 0.9918)
##     No Information Rate : 0.2862          
##     P-Value [Acc > NIR] : < 2.2e-16       
##                                           
##                   Kappa : 0.9865          
##                                           
##  Mcnemar's Test P-Value : NA              
## 
## Statistics by Class:
## 
##                      Class: A Class: B Class: C Class: D Class: E
## Sensitivity            0.9935   0.9877   0.9702   0.9926   1.0000
## Specificity            0.9998   0.9964   0.9965   0.9951   0.9992
## Pos Pred Value         0.9994   0.9851   0.9834   0.9751   0.9963
## Neg Pred Value         0.9974   0.9971   0.9936   0.9986   1.0000
## Prevalence             0.2862   0.1930   0.1767   0.1609   0.1832
## Detection Rate         0.2843   0.1907   0.1715   0.1597   0.1832
## Detection Prevalence   0.2845   0.1935   0.1743   0.1638   0.1839
## Balanced Accuracy      0.9966   0.9920   0.9833   0.9939   0.9996
```


```r
# Model Acuracy
RF_cm$overall[1]
```

```
##  Accuracy 
## 0.9892948
```
Using **cross-validation** with three steps, the model accuracy is 0.989, which is very good.

```r
plot(RF_Model$finalModel,main="Model error of Random forest model by number of trees")
```

![](Practical_Machine_Learning_Project_files/figure-html/unnamed-chunk-15-1.png)<!-- -->
<br/> We can add to this analysis that using more than about 30 trees does not reduce the error significantly.

##**Generalized Boosted Model**

```r
# Generalized Boosted Model
GBM_Model <- train(classe~., data=TrainData, method="gbm", trControl=fitControl, verbose=FALSE)
#  Plot 
plot(GBM_Model)
```

![](Practical_Machine_Learning_Project_files/figure-html/unnamed-chunk-16-1.png)<!-- -->

**Now we validate the model on the `testData` to find out how well it performs by looking at the accuracy variable.**

```r
# Testing the model
GBM_Predict <- predict(GBM_Model,newdata=TestData)
GBM_cm <- confusionMatrix(TestData$classe,GBM_Predict)

# Display confusion matrix and model accuracy
GBM_cm
```

```
## Confusion Matrix and Statistics
## 
##           Reference
## Prediction    A    B    C    D    E
##          A 1646   15    9    3    1
##          B   38 1061   37    3    0
##          C    0   33  976   16    1
##          D    1    5   41  913    4
##          E    2   15    9   16 1040
## 
## Overall Statistics
##                                           
##                Accuracy : 0.9577          
##                  95% CI : (0.9522, 0.9627)
##     No Information Rate : 0.2867          
##     P-Value [Acc > NIR] : < 2.2e-16       
##                                           
##                   Kappa : 0.9465          
##                                           
##  Mcnemar's Test P-Value : 2.78e-09        
## 
## Statistics by Class:
## 
##                      Class: A Class: B Class: C Class: D Class: E
## Sensitivity            0.9757   0.9398   0.9104   0.9600   0.9943
## Specificity            0.9933   0.9836   0.9896   0.9897   0.9913
## Pos Pred Value         0.9833   0.9315   0.9513   0.9471   0.9612
## Neg Pred Value         0.9903   0.9857   0.9802   0.9923   0.9988
## Prevalence             0.2867   0.1918   0.1822   0.1616   0.1777
## Detection Rate         0.2797   0.1803   0.1658   0.1551   0.1767
## Detection Prevalence   0.2845   0.1935   0.1743   0.1638   0.1839
## Balanced Accuracy      0.9845   0.9617   0.9500   0.9749   0.9928
```


```r
# Model Acuracy
GBM_cm$overall[1]
```

```
## Accuracy 
## 0.957689
```
Using **cross-validation** with three steps, the model accuracy is 0.957, which is very good.


##**Applying the best model to the validation data**
By comparing the accuracy rate values of the three models, it is clear that the 'Random Forest' model is the best one. So will use it to predict the values of classe for the validation data.


```r
# Model Validation 
Prediction_Test <- predict(RF_Model,newdata=ValidDataClean)
Prediction_Test
```

```
##  [1] B A B A A E D B A A B C B A E E A B B B
## Levels: A B C D E
```
