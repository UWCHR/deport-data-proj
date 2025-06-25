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
	output/ice_detentions_nov23-jun25.csv.gz

clean: 
		-rm -r output/*

output/ice_detentions_nov23-jun25.csv.gz: \
	src/detain-concat.R \
	input/2025-ICLI-00019_2024-ICFO-39357_ICE_Detentions_LESA-STU_FINAL_unprotected_1.csv.gz \
	input/2025-ICLI-00019_2024-ICFO-39357_ICE_Detentions_LESA-STU_FINAL_unprotected_2.csv.gz 
	Rscript $< \
		--input_1=input/2025-ICLI-00019_2024-ICFO-39357_ICE_Detentions_LESA-STU_FINAL_unprotected_1.csv.gz \
		--input_2=input/2025-ICLI-00019_2024-ICFO-39357_ICE_Detentions_LESA-STU_FINAL_unprotected_2.csv.gz \
		--log=output/detain-concat.R.log \
		--output=$@


# End.