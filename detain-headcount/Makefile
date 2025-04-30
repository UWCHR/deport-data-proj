#
# :author: PN
# :date: 2024-07-19
# :license: GPL 2.0 or greater
#
# ice-detain/headcount/Makefile
#
#

.PHONY: all

all: \
	output/headcount_detloc_nov23-feb25.csv.gz

clean: 
	-rm -r output/*

output/headcount_detloc_nov23-feb25.csv.gz: \
	src/headcount.R \
	input/ice_detentions_nov23-feb25.csv.gz
	mkdir -p output
	Rscript $< \
		--input=input/ice_detentions_nov23-feb25.csv.gz \
		--group='detention_facility_code' \
		--log=output/headcount.R.log \
		--output=$@

# End.