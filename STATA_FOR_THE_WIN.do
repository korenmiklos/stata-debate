* Hotel price data
use "hotels-europe_price.dta", clear

* Add hotel features (location, stars, ratings, etc.)
merge m:1 hotel_id using "hotels-europe_features.dta"

* 
replace price = 1000 if price > 1000

* Regress price on ratings, stars, plus month, weekend dummies
regress price rating stars i.month i.weekend, vce(cluster country)

* You want to spend a weekend at a 5-star hotel. Which country has the best quality-price ratio?
keep if stars == 5
collapse (mean) price (mean) rating, by(country)

label variable price "Price (€)"
label variable rating "Rating (1 to 5)"

scatter price rating, scheme(economist)