#
# :author: PN
# :date: 2024-07-19
# :license: GPL 2.0 or greater
#
# ice-detain/unique-stays/Makefile
#
#

.PHONY: all

all: \
	output/ice_detentions_nov23-jul25.csv.gz

old: \
	output/ice_detentions_nov23-jun25.csv.gz \
	output/ice_detentions_nov23-feb25.csv.gz

clean: 
		-rm -r output/*

output/ice_detentions_nov23-jul25.csv.gz: \
	src/unique-stays.R \
	input/ice_detentions_nov23-jul25.csv.gz 
	Rscript $< \
		--input=ice_detentions_nov23-jul25.csv.gz \
		--log=output/unique-stays.R.log \
		--output=$@

output/ice_detentions_nov23-jun25.csv.gz: \
	src/unique-stays.R \
	input/ice_detentions_nov23-jun25.csv.gz 
	Rscript $< \
		--input=ice_detentions_nov23-jun25.csv.gz \
		--log=output/unique-stays.R.log \
		--output=$@

output/ice_detentions_nov23-feb25.csv.gz: \
	src/unique-stays-feb25.R \
	../import/input/ICE_Detentions_2025-ICLI-00019_2024-ICFO-39357_LESA-STU_FINAL_raw.xlsx 
	Rscript $< \
		--input=ICE_Detentions_2025-ICLI-00019_2024-ICFO-39357_LESA-STU_FINAL_raw.xlsx \
		--log=output/unique-stays.R.log \
		--output=$@


# End.