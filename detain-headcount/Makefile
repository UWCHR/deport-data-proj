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
	output/headcount_detloc_nov23-jul25.csv.gz \
	output/headcount_citizenship_nov23-jul25.csv.gz

old: \
	output/headcount_detloc_nov23-jun25.csv.gz \
	output/headcount_citizenship_nov23-jun25.csv.gz \
	output/headcount_detloc_nov23-feb25.csv.gz

clean: 
	-rm -r output/*

output/headcount_detloc_nov23-jul25.csv.gz: \
	src/headcount.R \
	input/ice_detentions_nov23-jul25.csv.gz
	mkdir -p input output
	Rscript $< \
		--input=input/ice_detentions_nov23-jul25.csv.gz \
		--group='detention_facility_code' \
		--log=output/headcount.R.log \
		--output=$@

output/headcount_citizenship_nov23-jul25.csv.gz: \
	src/headcount.R \
	input/ice_detentions_nov23-jul25.csv.gz
	mkdir -p input output
	Rscript $< \
		--input=input/ice_detentions_nov23-jul25.csv.gz \
		--group='citizenship_country' \
		--log=output/headcount.R.log \
		--output=$@

output/headcount_detloc_nov23-jun25.csv.gz: \
	src/headcount.R \
	input/ice_detentions_nov23-jun25.csv.gz
	mkdir -p input output
	Rscript $< \
		--input=input/ice_detentions_nov23-jun25.csv.gz \
		--group='detention_facility_code' \
		--log=output/headcount.R.log \
		--output=$@

output/headcount_citizenship_nov23-jun25.csv.gz: \
	src/headcount.R \
	input/ice_detentions_nov23-jun25.csv.gz
	mkdir -p input output
	Rscript $< \
		--input=input/ice_detentions_nov23-jun25.csv.gz \
		--group='citizenship_country' \
		--log=output/headcount.R.log \
		--output=$@

output/headcount_detloc_nov23-feb25.csv.gz: \
	src/headcount.R \
	input/ice_detentions_nov23-feb25.csv.gz
	mkdir -p input output
	Rscript $< \
		--input=input/ice_detentions_nov23-feb25.csv.gz \
		--group='detention_facility_code' \
		--log=output/headcount.R.log \
		--output=$@

# End.