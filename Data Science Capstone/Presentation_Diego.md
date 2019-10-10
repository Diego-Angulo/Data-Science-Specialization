Text Prediction App
========================================================
author: Diego Angulo
date: 9/28/2019
transition: rotate

<small>
Coursera <br/>
Data Sciene Capstone Project Course - #10 <br/>
Johns Hopkins University - Data Science Specialization
</small>

Summary
========================================================

This presentation is part of the final course project within the [Data Science Capstone Course](https://www.coursera.org/learn/data-science-project) on the [Data Science Specialization](https://www.coursera.org/specializations/jhu-data-science) by Johns Hopkins University on [Coursera](https://www.coursera.org/). 

The goal of this project is to build a predictive text product based on the analysis of text data and natural language processing. The interface of this product is presented in an R Shiny App that will predict the next word based on the user's inputs.

All text mining and natural language processing was done with the usage of a variety of well-known R packages.

Data Processing
========================================================
The data used in the model came from a corpus called HC Corpora, that was downloaded from the [Coursera Site](https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip).

Three data samples from the HC Corpora data were created separately (blogs,twitter and news), and then merged into one main file. This sample was cleaned by conversion to lowercase, removing punctuation, links, white space and numbers. 

The data sample was then tokenized into n-grams (contiguous sequence of n items from a given sequence of text or speech). In this project, Bigram, Trigram and Quadgram where used.

Then, this N-Grams were converted into frequency dictionaries as data frames, and later on used for the word prediction.

Application
========================================================
 - App link:  [diegoangulo.shinyapps.io/Text_Prediction_App](https://diegoangulo.shinyapps.io/Text_Prediction_App/) <br/>
 - The user interface is pretty straightforward. Once a word or a sentence input is written in the text box, the app will refresh instantaneously, and the predicted next word will appear in the main panel. <br/>
![Layout](layout.png)

