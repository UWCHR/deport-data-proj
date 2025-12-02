# ---
# title: "Output dataset with additional analysis fields per stay"
# author:
# - "[Phil Neff](https://github.com/philneff)"
# date: 2025-04-28
# copyright: UWCHR, GPL 3.0
# ---

library(pacman)
p_load(argparse, logger, tidyverse, tidylog, arrow, lubridate, zoo, digest, readxl)

parser <- ArgumentParser()
parser$add_argument("--input", default = "ice_detentions_nov23-jun25.csv.gz")
parser$add_argument("--log", default = "detain-unique-stays/output/unique-stays.R.log")
parser$add_argument("--output", default = "detain-unique-stays/output/ice_detentions_nov23-jun25.csv.gz")
args <- parser$parse_args()

# append log file
f = args$log
log_appender(appender_file(f))

print("Reading data")

file <- args$input

df <- read_delim(here::here('detain-unique-stays', 'input', file), delim='|') %>% 
  janitor::clean_names() %>% 
  mutate(stay_book_in_date_time = ymd_hms(stay_book_in_date_time),
         book_in_date_time = ymd_hms(book_in_date_time),
         detention_book_out_date_time = ymd_hms(detention_book_out_date_time),
         stay_book_out_date_time = ymd_hms(stay_book_out_date_time),
         stay_book_out_date = ymd(stay_book_out_date))

log_info("Total rows in: {nrow(df)}")

vdigest <- Vectorize(digest)

df <- df %>% rowwise() %>% 
  unite(allCols, sep = "", remove = FALSE) %>% 
  unite(stayCols, c(unique_identifier, stay_book_in_date_time), sep = "", remove = FALSE) %>% 
  mutate(recid = vdigest(allCols),
         stayid = vdigest(stayCols)) %>%
  select(-c(allCols, stayCols))

max_date <- as.POSIXct("2025-07-28 23:59:59", tz = "UTC")

df <- df %>% 
  filter(!is.na(stay_book_in_date_time),
         !is.na(book_in_date_time)) %>% 
  mutate(stay_length = difftime(stay_book_out_date_time,
            stay_book_in_date_time, unit='days'),
         placement_length = difftime(detention_book_out_date_time,
            book_in_date_time, unit='days'),
         stay_length_elapsed = difftime(replace_na(stay_book_out_date_time, max_date),
            stay_book_in_date_time, unit='days'),
         placement_length_elapsed = difftime(replace_na(detention_book_out_date_time, max_date),
            book_in_date_time, unit='days'),
         initial_placement_exact = stay_book_in_date_time == book_in_date_time,
         initial_placement_approx = date(stay_book_in_date_time) == date(book_in_date_time)
         )

df <- df %>% 
  filter(!is.na(unique_identifier)) %>% 
  group_by(unique_identifier) %>% 
  arrange(stay_book_in_date_time, book_in_date_time) %>%
  mutate(total_stays = n_distinct(stay_book_in_date_time),
         total_placements = n(),
         current_stay = is.na(stay_book_out_date_time),
         current_placement = is.na(detention_book_out_date_time),
         stay_count = data.table::rleid(stay_book_in_date_time)) %>% 
  ungroup()

df <- df %>% 
  group_by(stayid) %>% 
  arrange(stay_book_in_date_time, book_in_date_time) %>%
  mutate(placement_count = data.table::rleid(recid),
         stay_placements = n(),
         first_facil = detention_facility_code[[1]], 
         last_facil = detention_facility_code[[length(detention_facility_code)]],
         prev_facil = lag(detention_facility_code, n=1),
         longest_placement_facil = detention_facility_code[which.max(placement_length_elapsed)],
         last_placement = placement_count == stay_placements,
         longest_placement = placement_length_elapsed == max(placement_length_elapsed)
         ) %>% 
  ungroup()

log_info("Rows out: {nrow(df)}")

print("Write out dataset")
# Write out dataset with additional analysis cols
system.time({write_delim(df, args$output, delim='|')})

# # END.