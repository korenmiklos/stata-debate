import delimited "data/restud-labels.csv", clear varnames(1)
keep if strpos(label, "Software") > 0
replace label = substr(label, 10, .)

replace label = "Csharp" if label == "C#"

generate V = 1
generate i = _n
reshape wide V, i(i) j(label) string
unab vars: V*
collapse (sum) `vars'
generate i = 1
reshape long V, i(i) j(label) string

generate lang = .
replace lang = 4 if label == "Stata"
replace lang = 3 if label == "Matlab"
replace lang = 2 if label == "R"
replace lang = 1 if label == "Python"

label define IV 4 "Stata" 3 "Matlab" 2 "R" 1 "Python"
label values lang IV

twoway dropline V lang, scheme(economist) horizontal ylab(#4, value) xtitle(Number of articles using) ytitle("") 
graph export "img/restud.png", replace width(1000)