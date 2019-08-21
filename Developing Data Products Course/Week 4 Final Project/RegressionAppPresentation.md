Regression App
========================================================
author: Diego Angulo
date: 8/19/2019
transition: rotate

<small>
Coursera <br/>
Developing Data Products Course - #9 <br/>
Johns Hopkins University - Data Science Specialization
</small>

Summary
========================================================
This presentation is the final course project within the [Developing Data Products Course](https://www.coursera.org/learn/data-products) on the [Data Science Specialization](https://www.coursera.org/specializations/jhu-data-science) by Johns Hopkins University on [Coursera](https://www.coursera.org/). 

Using the `mtcars` data set included in R, we creating a data product that displays a linear regression model. The product function predicts the value of the outcome "Number of Miles Per Gallon of Gasoline" of a car, with the most relevant independent variables found in the data set.

The Application includes the following:
========================================================
- Form of Input used: 
    - Radio Button
    - Slider    

- Reactive output displayed as a result of server calculations

- The server.R and ui.R codes are posted on github at: <https://github.com/Diego-Angulo/Data-Science-Specialization/tree/master/Developing%20Data%20Products%20Course/Week%204%20Final%20Project>

- The App can be found at: <https://diegoangulo.shinyapps.io/regressionapp/>

Part of the Data used:
========================================================

```r
head(mtcars, n = 5)
```

```
                   mpg cyl disp  hp drat    wt  qsec vs am gear carb
Mazda RX4         21.0   6  160 110 3.90 2.620 16.46  0  1    4    4
Mazda RX4 Wag     21.0   6  160 110 3.90 2.875 17.02  0  1    4    4
Datsun 710        22.8   4  108  93 3.85 2.320 18.61  1  1    4    1
Hornet 4 Drive    21.4   6  258 110 3.08 3.215 19.44  1  0    3    1
Hornet Sportabout 18.7   8  360 175 3.15 3.440 17.02  0  0    3    2
```

App layout:
========================================================
![App](app.png)

