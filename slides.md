---
title: Why Stata is the best programming language to start data analysis
author: 
  - Milós Koren
  - Márton Fleck
aspectratio: 169
---

## Two-Column Slide
::: columns

:::: column
![](img/Brattle.png)
::::

:::: column
![](img/Compass.png)
::::
::::

## Code Example
\small
```stata
/* Hotel price data */
use "hotels-europe_price.dta", clear
/* Add hotel features (location, stars, ratings, etc.) */
merge m:1 hotel_id using "hotels-europe_features.dta"
/* Censor prices that are too high */
replace price = 1000 if price > 1000
/* Regress price on ratings, stars, plus month, weekend dummies */
regress price rating stars i.month i.weekend, vce(cluster country)
```

## Regression Table
![](img/regression.png)

## Code Example
:::columns
::::column
\small
```stata
keep if stars == 5
collapse (mean) price (mean) rating, 
  by(country)
label variable price "Price (€)"
label variable rating "Rating (1 to 5)"
scatter price rating, scheme(economist)
graph export "img/scatter.png", replace
```
::::
::::column
![](img/scatter.png)
::::
:::