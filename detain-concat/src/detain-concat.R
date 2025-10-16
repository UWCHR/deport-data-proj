# ---
# title: "Concatenate June 2025 detentions data"
# author:
# - "[Phil Neff](https://github.com/philneff)"
# date: 2025-06-25
# copyright: UWCHR, GPL 3.0
# ---

library(pacman)
p_load(argparse, logger, tidyverse, readxl)

parser <- ArgumentParser()
parser$add_argument("--input", default = "import/input/2025-ICLI-00019_2024-ICFO-39357_ICE_Detentions_LESA-STU_FINAL_unprotected.xlsx")
parser$add_argument("--log", default = "detain-concat/output/detain-concat.R.log")
parser$add_argument("--output", default = "detain-concat/output/ice_detentions_nov23-jun25.csv.gz")
args <- parser$parse_args()

# append log file
f = args$log
log_appender(appender_file(f))

df1 <- read_excel(args$input, sheet=1, skip=6) %>%
	janitor::clean_names() %>% 
	mutate(stay_book_in_date_time = ymd_hms(stay_book_in_date_time),
	         book_in_date_time = ymd_hms(book_in_date_time),
	         detention_book_out_date_time = ymd_hms(detention_book_out_date_time),
	         stay_book_out_date_time = ymd_hms(stay_book_out_date_time),
	         stay_book_out_date = ymd(stay_book_out_date))
df2 <- read_excel(args$input, sheet=2, skip=6) %>%
	janitor::clean_names() %>% 
	mutate(stay_book_in_date_time = ymd_hms(stay_book_in_date_time),
	         book_in_date_time = ymd_hms(book_in_date_time),
	         detention_book_out_date_time = ymd_hms(detention_book_out_date_time),
	         stay_book_out_date_time = ymd_hms(stay_book_out_date_time),
	         stay_book_out_date = ymd(stay_book_out_date))

names_1 <- names(df1)
names_2 <- names(df2)

stopifnot(names_1 == names_2)

df <- rbind(df1, df2)

predrop <- nrow(df)
df <- unique(df)
postdrop <- nrow(df)

log_info("Duplicates dropped: {predrop - postdrop}")

write_delim(df, args$output, delim='|')

# END