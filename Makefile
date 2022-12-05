slides.pdf: slides.md img/scatter.png img/restud.png

%.tex: %.md preamble-slides.tex
	pandoc $< \
	    -t beamer \
	    --slide-level 2 \
	    -H preamble-slides.tex \
	    -o $@

%.pdf: %.tex
	cd $(dir $@) && pdflatex -shell-escape $(notdir $<)  && pdflatex -shell-escape $(notdir $<)
	rm $(basename $<).log $(basename $<).nav $(basename $<).aux $(basename $<).snm $(basename $<).toc

img/scatter.png: code/STATA_FOR_THE_WIN.do data/hotels-europe_features.dta data/hotels-europe_price.dta
	stata -b do $<

img/restud.png: code/restud.do data/restud-labels.csv
	stata -b do $<