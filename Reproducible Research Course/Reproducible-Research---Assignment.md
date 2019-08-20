---
title: "Reproducible Research Course - Final Project"
subtitle: "Jhons Hopkins University - Data Science Specialization on Coursera - Course #5"
author: "Diego Angulo"
date: "June 18, 2019"
output: 
  html_document:
    keep_md: true
---





## **Executive Summary**
This report is a course project within the [Reproducible Research Course](https://www.coursera.org/learn/reproducible-research) on the [Data Science Specialization](https://www.coursera.org/specializations/jhu-data-science) by Johns Hopkins University on [Coursera](https://www.coursera.org/). 

The basic goal of this assignment is to explore the NOAA Storm Database and answer some basic questions about severe weather events. You must use the database to answer the questions below and show the code for your entire analysis. Your analysis can consist of tables, figures, or other summaries. You may use any R package you want to support your analysis.

##**Project instructions**
Your data analysis must address the following questions: <br/>

 - Across the United States, which types of events (as indicated in the EVTYPE variable) are most  - harmful with respect to population health? <br/>
 
 - Across the United States, which types of events have the greatest economic consequences?

Consider writing your report as if it were to be read by a government or municipal manager who might be responsible for preparing for severe weather events and will need to prioritize resources for different types of events. However, there is no need to make any specific recommendations in your report.

## Synopsis

Storms and other severe weather events can cause both public health and economic problems for communities and municipalities. Many severe events can result in fatalities, injuries, and property damage, and preventing such outcomes to the extent possible is a key concern.

This project involves exploring the U.S. National Oceanic and Atmospheric Administration's (NOAA) storm database. This database tracks characteristics of major storms and weather events in the United States, including when and where they occur, as well as estimates of any fatalities, injuries, and property damage.

## Documentation

- [Storm Data Documentation](https://d396qusza40orc.cloudfront.net/repdata%2Fpeer2_doc%2Fpd01016005curr.pdf) with information about how the variables are constructed/defined. <br/>
- National Climatic Data Center Storm Events.  
[FAQ](https://d396qusza40orc.cloudfront.net/repdata%2Fpeer2_doc%2FNCDC%20Storm%20Events-FAQ%20Page.pdf)


## Data Processing

**1- Libraries**


```r
library(dplyr)
library(ggplot2)
```


**2- Download the raw data from** [HERE](https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2), **and load it into R Studio.**


```r
# Setting working directory first
setwd("~/Coursera/8_Data_Science_Specialization/5_Reproducible_Research/Week_4/Assignment")

# Downloading .ZIP containing Data
if(!file.exists("repdata_data_StormData.csv.bz2")) {
    download.file("https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2", 
                  destfile = "repdata_data_StormData.csv.bz2", 
                  method = "curl")
}

# Loading the Data
A_1_StormData <- read.csv("repdata_data_StormData.csv.bz2") 
A_1_StormData <- data.frame(lapply(A_1_StormData, as.character), stringsAsFactors=FALSE)
```


**3- For this study we will only keep `EVTYPE`, and the variables related to the impact on population health and economic consequences.**


```r
# EVTYPES variable is converted to Uppercase to avoid any case-sensitive duplicates during data processing
A_2_StormData <- A_1_StormData[, c("EVTYPE", "FATALITIES", "INJURIES", "PROPDMG", "PROPDMGEXP", "CROPDMG", "CROPDMGEXP")]
A_2_StormData$EVTYPE <- toupper(A_2_StormData$EVTYPE) 
```

<table class="table table-striped" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> EVTYPE </th>
   <th style="text-align:left;"> FATALITIES </th>
   <th style="text-align:left;"> INJURIES </th>
   <th style="text-align:left;"> PROPDMG </th>
   <th style="text-align:left;"> PROPDMGEXP </th>
   <th style="text-align:left;"> CROPDMG </th>
   <th style="text-align:left;"> CROPDMGEXP </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> TORNADO </td>
   <td style="text-align:left;"> 0 </td>
   <td style="text-align:left;"> 15 </td>
   <td style="text-align:left;"> 25 </td>
   <td style="text-align:left;"> K </td>
   <td style="text-align:left;"> 0 </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;"> TORNADO </td>
   <td style="text-align:left;"> 0 </td>
   <td style="text-align:left;"> 0 </td>
   <td style="text-align:left;"> 2.5 </td>
   <td style="text-align:left;"> K </td>
   <td style="text-align:left;"> 0 </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;"> TORNADO </td>
   <td style="text-align:left;"> 0 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> 25 </td>
   <td style="text-align:left;"> K </td>
   <td style="text-align:left;"> 0 </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;"> TORNADO </td>
   <td style="text-align:left;"> 0 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> 2.5 </td>
   <td style="text-align:left;"> K </td>
   <td style="text-align:left;"> 0 </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;"> TORNADO </td>
   <td style="text-align:left;"> 0 </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:left;"> 2.5 </td>
   <td style="text-align:left;"> K </td>
   <td style="text-align:left;"> 0 </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;"> TORNADO </td>
   <td style="text-align:left;"> 0 </td>
   <td style="text-align:left;"> 6 </td>
   <td style="text-align:left;"> 2.5 </td>
   <td style="text-align:left;"> K </td>
   <td style="text-align:left;"> 0 </td>
   <td style="text-align:left;">  </td>
  </tr>
</tbody>
</table>

Let's take a look at `EVTYPE` variable in the data. 


```r
# Number of possible events that are in the data.
N_Events_Data <- arrange(count(A_2_StormData, EVTYPE),EVTYPE, desc(n))
N_Events_Data <- dim(N_Events_Data)[1]
```

There are 898 different types of events in the data. We will relabel them according to the events listed in the Documentation in order to generate concise results.


**4- Here is the complete list of all the possible type of events according to the documentation (Pages 2-4). **



<table class="table table-striped" style="width: auto !important; margin-left: auto; margin-right: auto;">
<tbody>
  <tr>
   <td style="text-align:left;"> ASTRONOMICAL LOW TIDE </td>
   <td style="text-align:left;"> DUST DEVIL </td>
   <td style="text-align:left;"> HEAVY SNOW </td>
   <td style="text-align:left;"> MARINE HIGH WIND </td>
   <td style="text-align:left;"> TORNADO </td>
  </tr>
  <tr>
   <td style="text-align:left;"> AVALANCHE </td>
   <td style="text-align:left;"> DUST STORM </td>
   <td style="text-align:left;"> HIGH SURF </td>
   <td style="text-align:left;"> MARINE STRONG WIND </td>
   <td style="text-align:left;"> TROPICAL DEPRESSION </td>
  </tr>
  <tr>
   <td style="text-align:left;"> BLIZZARD </td>
   <td style="text-align:left;"> EXTREME COLD/WIND CHILL </td>
   <td style="text-align:left;"> HIGH WIND </td>
   <td style="text-align:left;"> MARINE THUNDERSTORM WIND </td>
   <td style="text-align:left;"> TROPICAL STORM </td>
  </tr>
  <tr>
   <td style="text-align:left;"> COASTAL FLOOD </td>
   <td style="text-align:left;"> FLOOD/FLASH FLOOD </td>
   <td style="text-align:left;"> HURRICANE/TYPHOON </td>
   <td style="text-align:left;"> RIP CURRENT </td>
   <td style="text-align:left;"> TSUNAMI </td>
  </tr>
  <tr>
   <td style="text-align:left;"> COLD/WIND CHILL </td>
   <td style="text-align:left;"> FREEZING FOG </td>
   <td style="text-align:left;"> ICE STORM </td>
   <td style="text-align:left;"> SEICHE </td>
   <td style="text-align:left;"> VOLCANIC ASH </td>
  </tr>
  <tr>
   <td style="text-align:left;"> DEBRIS FLOW </td>
   <td style="text-align:left;"> FUNNEL CLOUD </td>
   <td style="text-align:left;"> LAKESHORE FLOOD </td>
   <td style="text-align:left;"> SLEET </td>
   <td style="text-align:left;"> WATERSPOUT </td>
  </tr>
  <tr>
   <td style="text-align:left;"> DENSE FOG </td>
   <td style="text-align:left;"> HAIL </td>
   <td style="text-align:left;"> LAKE-EFFECT SNOW </td>
   <td style="text-align:left;"> STORM TIDE </td>
   <td style="text-align:left;"> WILDFIRE </td>
  </tr>
  <tr>
   <td style="text-align:left;"> DENSE SMOKE </td>
   <td style="text-align:left;"> HEAT </td>
   <td style="text-align:left;"> LIGHTNING </td>
   <td style="text-align:left;"> STRONG WIND </td>
   <td style="text-align:left;"> WINTER STORM </td>
  </tr>
  <tr>
   <td style="text-align:left;"> DROUGHT </td>
   <td style="text-align:left;"> HEAVY RAIN </td>
   <td style="text-align:left;"> MARINE HAIL </td>
   <td style="text-align:left;"> THUNDERSTORM WIND </td>
   <td style="text-align:left;"> WINTER WEATHER </td>
  </tr>
</tbody>
</table>

There are 45 different types of events in the documentation. Which means that `EVTYPE` variable in the data, is very inconsistent.


**5- Lets fix `EVTYPE` events in the data**


**Multiple Events**

Some event labels are multiple (e.g., "HEAVY SNOW/HIGH WINDS/FREEZING"). If (and only if) `EVTYPE` starts with an event listed in the documentation (`A_3_Doc_Events`), we will prioritize that name as more relevant.

In the example, "HEAVY SNOW/HIGH WINDS/FREEZING" starts with "HEAVY SNOW". As you can find this event in the documentation list `A_3_Doc_Events`, we will replace "HEAVY SNOW/HIGH WINDS/FREEZING" with just "HEAVY SNOW".


```r
for(i in seq_along(A_3_Doc_Events$EVTYPE)) {
    A_2_StormData$EVTYPE[grepl(paste("^", A_3_Doc_Events$EVTYPE[i], sep = ""), A_2_StormData$EVTYPE,ignore.case = TRUE)]  <- A_3_Doc_Events$EVTYPE[i]
} ; rm(i)
```


**Similar Events**

Some labels like "HIGH WINDS" and "HIGH WIND" are similar. In this example, we will replace "HIGH WINDS" for "HIGH WIND" because it is in the Documentation.

There are many cases like this, and we can't fix all of them because we are doing this manually. We will focus only on the most frequent ones.


```r
A_2_StormData$EVTYPE[grepl("COASTAL FLOOD", A_2_StormData$EVTYPE,ignore.case = TRUE)]  <- "COASTAL FLOOD"
A_2_StormData$EVTYPE[grepl("FLOOD|FLASH", A_2_StormData$EVTYPE,ignore.case = TRUE)]  <- "FLOOD/FLASH FLOOD"

A_2_StormData$EVTYPE[grepl("HEAT", A_2_StormData$EVTYPE,ignore.case = TRUE)]  <- "HEAT"

A_2_StormData$EVTYPE[grepl("FOG", A_2_StormData$EVTYPE,ignore.case = TRUE)]  <- "DENSE FOG"
A_2_StormData$EVTYPE[grepl("STORM SURGE", A_2_StormData$EVTYPE,ignore.case = TRUE)]  <- "STORM TIDE"
A_2_StormData$EVTYPE[grepl("RAIN|STREAM", A_2_StormData$EVTYPE,ignore.case = TRUE)]  <- "HEAVY RAIN"
A_2_StormData$EVTYPE[grepl("HURRICANE|TYPHOON", A_2_StormData$EVTYPE,ignore.case = TRUE)]  <- "HURRICANE/TYPHOON"

A_2_StormData$EVTYPE[grepl("LAKE", A_2_StormData$EVTYPE,ignore.case = TRUE)]  <- "LAKE-EFFECT SNOW"
A_2_StormData$EVTYPE[grepl("SNOW", A_2_StormData$EVTYPE,ignore.case = TRUE)]  <- "HEAVY SNOW" 

A_2_StormData$EVTYPE[grepl("FROST/FREEZE|FREEZE|FROST|ICE", A_2_StormData$EVTYPE,ignore.case = TRUE)]  <- "ICE STORM"

A_2_StormData$EVTYPE[grepl("WILD", A_2_StormData$EVTYPE,ignore.case = TRUE)]  <- "WILDFIRE"

A_2_StormData$EVTYPE[grepl("EXTREME", A_2_StormData$EVTYPE,ignore.case = TRUE)]  <- "EXTREME COLD/WIND CHILL"  
A_2_StormData$EVTYPE[grepl("COLD|WIND CHILL", A_2_StormData$EVTYPE,ignore.case = TRUE)]  <- "COLD/WIND CHILL" 

A_2_StormData$EVTYPE[grepl("TSTM WIND|THUNDERSTORM WIND|THUNDERSTORM WINDS", A_2_StormData$EVTYPE,ignore.case = TRUE)]  <- "THUNDERSTORM WIND" 
A_2_StormData$EVTYPE[grepl("HIGH WINDS", A_2_StormData$EVTYPE,ignore.case = TRUE)]  <- "HIGH WIND"
A_2_StormData$EVTYPE[grepl("STRONG WINDS", A_2_StormData$EVTYPE,ignore.case = TRUE)]  <- "STRONG WIND"
A_2_StormData$EVTYPE[grepl("WIND", A_2_StormData$EVTYPE,ignore.case = TRUE)]  <- "STRONG WIND"


# How many possible events are in the data now?
N_Events_Data2 <- rename(arrange(count(A_2_StormData, EVTYPE),EVTYPE, desc(n)), Events = EVTYPE)
N_Events_Data2 <- dim(N_Events_Data2)[1]
```

We have reduced `EVTYPE` from 898 different events in the data, to 369.

**6- Now let's sum the rows in the data where `EVTYPE` labels still don't match the documentation list.**



<table class="table table-striped" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> In_Documentation </th>
   <th style="text-align:right;"> N </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> No </td>
   <td style="text-align:right;"> 4413 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Yes </td>
   <td style="text-align:right;"> 897884 </td>
  </tr>
</tbody>
</table>

Only 0.5% of the data rows have events that are not properly labeled. Which means that `EVTYPE` variable is much more consistent now.

**7- Magnitude variables fixing**

Lets take a look at `PROPDMGEXP` and `CROPDMGEXP`.


```r
table(A_1_StormData$PROPDMGEXP)
```

```
## 
##             -      ?      +      0      1      2      3      4      5 
## 465934      1      8      5    216     25     13      4      4     28 
##      6      7      8      B      h      H      K      m      M 
##      4      5      1     40      1      6 424665      7  11330
```

```r
table(A_1_StormData$CROPDMGEXP)
```

```
## 
##             ?      0      2      B      k      K      m      M 
## 618413      7     19      1      9     21 281832      1   1994
```

As we can see, PROPDMGEXP and CROPDMGEXP are not consistent. They should only take the values of H, K, M, B or O. Let's fix that.


```r
# Transformation 
A_2_StormData$PROPDMGEXP<-factor(A_2_StormData$PROPDMGEXP,levels=c("H","K","M","B","h","m","O"))
A_2_StormData$PROPDMGEXP[is.na(A_2_StormData$PROPDMGEXP)] <- "O"

A_2_StormData$CROPDMGEXP<-factor(A_2_StormData$CROPDMGEXP,levels=c("K","M","B","k","m","O"))
A_2_StormData$CROPDMGEXP[is.na(A_2_StormData$CROPDMGEXP)] <- "O"

A_2_StormData$PROPDMGEXP <- as.character(A_2_StormData$PROPDMGEXP)
A_2_StormData$CROPDMGEXP <- as.character(A_2_StormData$CROPDMGEXP)

A_2_StormData$PROPDMGMLT <- 0
A_2_StormData$CROPDMGMLT <- 0

# Replace Magnitud character values into it's numer equivalent
A_2_StormData$PROPDMGMLT[grepl("h", A_2_StormData$PROPDMGEXP,ignore.case = TRUE)]<-100
A_2_StormData$PROPDMGMLT[grepl("k", A_2_StormData$PROPDMGEXP,ignore.case = TRUE)]<-1000
A_2_StormData$PROPDMGMLT[grepl("m", A_2_StormData$PROPDMGEXP,ignore.case = TRUE)]<-1000000
A_2_StormData$PROPDMGMLT[grepl("b", A_2_StormData$PROPDMGEXP,ignore.case = TRUE)]<-1000000000
A_2_StormData$PROPDMGMLT[grepl("o", A_2_StormData$PROPDMGEXP,ignore.case = TRUE)]<-1

A_2_StormData$CROPDMGMLT[grepl("k", A_2_StormData$CROPDMGEXP,ignore.case = TRUE)]<-1000
A_2_StormData$CROPDMGMLT[grepl("m", A_2_StormData$CROPDMGEXP,ignore.case = TRUE)]<-1000000
A_2_StormData$CROPDMGMLT[grepl("b", A_2_StormData$CROPDMGEXP,ignore.case = TRUE)]<-1000000000
A_2_StormData$CROPDMGMLT[grepl("o", A_2_StormData$CROPDMGEXP,ignore.case = TRUE)]<-1
```

After this arranges, we can see that `PROPDMGEXP` and `CROPDMGEXP` are consistent now.


```r
table(A_2_StormData$PROPDMGEXP)
```

```
## 
##      B      h      H      K      m      M      O 
##     40      1      6 424665      7  11330 466248
```

```r
table(A_2_StormData$CROPDMGEXP)
```

```
## 
##      B      k      K      m      M      O 
##      9     21 281832      1   1994 618440
```

So now we can calculate the exact amount of Property Damage `PROPDMG` and Crop Damage `CROPDMG`.


```r
# Convert Property Damage and Crop Damage to full number format
A_2_StormData$PROPDMG <- as.numeric(A_2_StormData$PROPDMG) * A_2_StormData$PROPDMGMLT
A_2_StormData$CROPDMG <- as.numeric(A_2_StormData$CROPDMG) * A_2_StormData$CROPDMGMLT
```

## Results/Answers:

**1-  Across the United States, which types of events (as indicated in the EVTYPE variable) are most harmful with respect to population health?**

Let's create a table and a chart with the events that reports the most frecuent `FATALITIES` and `INJURIES`.


```r
A_5_Health <- aggregate(cbind(as.numeric(FATALITIES),as.numeric(INJURIES)) ~ EVTYPE, data = A_2_StormData, sum, na.rm=TRUE)

names(A_5_Health) <- c("EVTYPE", "FATALITIES","INJURIES")

A_5_Health$TOTAL <- A_5_Health$FATALITIES + A_5_Health$INJURIES

A_5_Health <- arrange(A_5_Health, desc(TOTAL))
```

<table class="table table-striped" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> EVTYPE </th>
   <th style="text-align:right;"> FATALITIES </th>
   <th style="text-align:right;"> INJURIES </th>
   <th style="text-align:right;"> TOTAL </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> TORNADO </td>
   <td style="text-align:right;"> 5633 </td>
   <td style="text-align:right;"> 91346 </td>
   <td style="text-align:right;"> 96979 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> STRONG WIND </td>
   <td style="text-align:right;"> 1657 </td>
   <td style="text-align:right;"> 11734 </td>
   <td style="text-align:right;"> 13391 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> HEAT </td>
   <td style="text-align:right;"> 3138 </td>
   <td style="text-align:right;"> 9224 </td>
   <td style="text-align:right;"> 12362 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FLOOD/FLASH FLOOD </td>
   <td style="text-align:right;"> 1525 </td>
   <td style="text-align:right;"> 8604 </td>
   <td style="text-align:right;"> 10129 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> LIGHTNING </td>
   <td style="text-align:right;"> 816 </td>
   <td style="text-align:right;"> 5230 </td>
   <td style="text-align:right;"> 6046 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ICE STORM </td>
   <td style="text-align:right;"> 99 </td>
   <td style="text-align:right;"> 2155 </td>
   <td style="text-align:right;"> 2254 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> WILDFIRE </td>
   <td style="text-align:right;"> 90 </td>
   <td style="text-align:right;"> 1606 </td>
   <td style="text-align:right;"> 1696 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> WINTER STORM </td>
   <td style="text-align:right;"> 206 </td>
   <td style="text-align:right;"> 1321 </td>
   <td style="text-align:right;"> 1527 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> HURRICANE/TYPHOON </td>
   <td style="text-align:right;"> 135 </td>
   <td style="text-align:right;"> 1333 </td>
   <td style="text-align:right;"> 1468 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> HAIL </td>
   <td style="text-align:right;"> 15 </td>
   <td style="text-align:right;"> 1361 </td>
   <td style="text-align:right;"> 1376 </td>
  </tr>
</tbody>
</table>

<img src="Reproducible-Research---Assignment_files/figure-html/unnamed-chunk-11-1.png" style="display: block; margin: auto;" />

Tornados are by far the most harmful events with respect to population health.

**2-  Across the United States, which types of events have the greatest economic consequences?**

Let's create a table with the events that have the most frecuent `PROPDMG` and `CROPDMG`.


```r
A_6_DMG <- aggregate(cbind(as.numeric(PROPDMG),as.numeric(CROPDMG)) ~ EVTYPE, data = A_2_StormData, sum, na.rm=TRUE)
names(A_6_DMG) <- c("EVTYPE", "PROPDMG","CROPDMG") 

A_6_DMG$TOTAL <- A_6_DMG$PROPDMG + A_6_DMG$CROPDMG

A_6_DMG <- arrange(A_6_DMG, desc(TOTAL))
```

<table class="table table-striped" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> EVTYPE </th>
   <th style="text-align:right;"> PROPDMG </th>
   <th style="text-align:right;"> CROPDMG </th>
   <th style="text-align:right;"> TOTAL </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> FLOOD/FLASH FLOOD </td>
   <td style="text-align:right;"> 167529740932 </td>
   <td style="text-align:right;"> 12380109100 </td>
   <td style="text-align:right;"> 179909850032 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> HURRICANE/TYPHOON </td>
   <td style="text-align:right;"> 85356410010 </td>
   <td style="text-align:right;"> 5516117800 </td>
   <td style="text-align:right;"> 90872527810 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> TORNADO </td>
   <td style="text-align:right;"> 56937160779 </td>
   <td style="text-align:right;"> 414953270 </td>
   <td style="text-align:right;"> 57352114049 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> STORM TIDE </td>
   <td style="text-align:right;"> 47964724000 </td>
   <td style="text-align:right;"> 855000 </td>
   <td style="text-align:right;"> 47965579000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> STRONG WIND </td>
   <td style="text-align:right;"> 17747390679 </td>
   <td style="text-align:right;"> 3445560088 </td>
   <td style="text-align:right;"> 21192950767 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> HAIL </td>
   <td style="text-align:right;"> 15732267543 </td>
   <td style="text-align:right;"> 3025954473 </td>
   <td style="text-align:right;"> 18758222016 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> DROUGHT </td>
   <td style="text-align:right;"> 1046106000 </td>
   <td style="text-align:right;"> 13972566000 </td>
   <td style="text-align:right;"> 15018672000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ICE STORM </td>
   <td style="text-align:right;"> 3981204360 </td>
   <td style="text-align:right;"> 7019175300 </td>
   <td style="text-align:right;"> 11000379660 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> WILDFIRE </td>
   <td style="text-align:right;"> 8491563500 </td>
   <td style="text-align:right;"> 402781630 </td>
   <td style="text-align:right;"> 8894345130 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> TROPICAL STORM </td>
   <td style="text-align:right;"> 7703890550 </td>
   <td style="text-align:right;"> 678346000 </td>
   <td style="text-align:right;"> 8382236550 </td>
  </tr>
</tbody>
</table>

<img src="Reproducible-Research---Assignment_files/figure-html/unnamed-chunk-14-1.png" style="display: block; margin: auto;" />
Floods are the events that reports the greatest economic consequences.
