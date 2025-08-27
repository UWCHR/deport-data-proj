#
# :author: PN
# :date: 2025-06-25
# :license: GPL 2.0 or greater
#
# deport-data-proj/detain-concat/Makefile
#
#

.PHONY: all

all: \
	output/ice_detentions_nov23-jun25.csv.gz \
	output/ice_detentions_nov23-jul25.csv.gz

clean: 
		-rm -r output/*

output/ice_detentions_nov23-jul25.csv.gz: \
	src/detain-concat.R \
	../import/input/2025-08/2025-ICLI-00019_2024-ICFO-39357_ICE_Detentions_LESA-STU_FINAL_Redacted_raw.xlsx
	mkdir -p input output
	Rscript $< \
		--input=../import/input/2025-08/2025-ICLI-00019_2024-ICFO-39357_ICE_Detentions_LESA-STU_FINAL_Redacted_raw.xlsx \
		--log=output/detain-concat.R.log \
		--output=$@

output/ice_detentions_nov23-jun25.csv.gz: \
	src/detain-concat.R \
	../import/input/2025-07/2025-ICLI-00019_2024-ICFO-39357_ICE_Detentions.xlsx
	mkdir -p input output
	Rscript $< \
		--input=../import/input/2025-07/2025-ICLI-00019_2024-ICFO-39357_ICE_Detentions.xlsx \
		--log=output/detain-concat.R.log \
		--output=$@


# End.