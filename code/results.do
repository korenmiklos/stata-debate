import excel "https://github.com/korenmiklos/r-python-stata/raw/main/Polls-per-user-CEU_R_Python_Stata_2022.xlsx", firstrow clear
* first line is metadata
drop in 1

rename AreyouatCEUViennaoronline location
rename AFTERDebateWhichcodingscr after
rename StartWhichcodingscripting before 
rename Whichwasthemostconvincingte team

keep location before after team

* drop "other" options
drop if before == "Other" | after == "Other"
* only keep those that mention these 3 languages at least once
keep if inlist(before, "Stata", "R", "Python") | inlist(after, "Stata", "R", "Python")

tabulate before after, missing

* Who said Stata is not a programming language?!
foreach lang in Python R Stata {
    generate byte switch_to_`lang' = (before != "`lang'" & after == "`lang'")
    generate byte switch_from_`lang' = (before == "`lang'" & after != "`lang'" & after != "dropped out")
    generate difference_`lang' = switch_to_`lang' - switch_from_`lang'
    label variable difference_`lang' "`lang'"
}

graph dot (sum) difference_Python difference_Stata difference_R, scheme(economist) legend(order(3 "R" 2 "Stata" 1 "Python")) 
graph export "img/results.png", width(1000) replace