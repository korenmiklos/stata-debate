# Julia code

using DataFrames, DataFramesMeta, GLM, Plots

# load hotel price data
price_data = DataFrame(readtable("hotels-europe_price.dta"))

# add hotel features (location, stars, ratings, etc.)
features = DataFrame(readtable("hotels-europe_features.dta"))
data = @join(price_data, features, on=:hotel_id, kind=:left)

# replace high prices with 1000
data.price[data.price .> 1000] .= 1000

# regress price on ratings, stars, plus month, weekend dummies
data = DataFramesMeta.transform(data, :month => categorical, :weekend => categorical)
formula = @formula(price ~ rating + stars + [month] + [weekend])
result = fit!(GLM(formula, data, Normal(), IdentityLink()), FastLmWeights())

# You want to spend a weekend at a 5-star hotel. Which country has the best quality-price ratio?
five_star_data = data[data.stars .== 5, :]
summary = @by(five_star_data, :country, price = :price => mean, rating = :rating => mean)

# label variables
rename!(summary, Dict(:price => "Price (€)", :rating => "Rating (1 to 5)"))

# scatter plot
scatter(summary.Price_€, summary.Rating_1_to_5, grid=false, legend=:none, theme=:economist)
