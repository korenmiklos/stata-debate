import excel "https://github.com/korenmiklos/r-python-stata/raw/main/Polls-per-user-CEU_R_Python_Stata_2022.xlsx", firstrow clear
* first line is metadata
drop in 1

rename AreyouatCEUViennaoronline location
rename AFTERDebateWhichcodingscr after
rename StartWhichcodingscripting before 
rename Whichwasthemostconvincingte team

keep location before after team

* limit to users who answered the first question
keep if !missing(before)
replace after = "dropped out" if missing(after)

* drop "other" options
drop if before == "Other" | after == "Other"

tabulate before after

/*
 [Start] Which coding |
 (scripting) language |   [AFTER Debate] Which coding (scripting)
     should a student |  language should a student (first) master
(first) master for Da |    Python          R      Stata  dropped.. |     Total
----------------------+--------------------------------------------+----------
               Python |        14          1          2         14 |        31 
                    R |         6         13          2         14 |        35 
                Stata |         5          1         12         21 |        39 
----------------------+--------------------------------------------+----------
                Total |        25         15         16         49 |       105 
*/

* Who said Stata is not a programming language?!
foreach lang in Python R Stata {
    count if before != "`lang'" & after == "`lang'"
    scalar switch_to_`lang' = r(N)
    * do not count dropouts as abandoning a langage
    count if before == "`lang'" & after != "`lang'" & after != "dropped out"
    scalar switch_from_`lang' = r(N)
    scalar difference_`lang' = switch_to_`lang' - switch_from_`lang'
}
scalar list difference_Python
scalar list difference_Stata
scalar list difference_R

/*
difference_Python =          8
difference_Stata =         -2
difference_R =         -6
*/