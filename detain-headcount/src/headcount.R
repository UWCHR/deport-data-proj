# ---
# title: "Generate ICE detention headcounts"
# author:
# - "[Phil Neff](https://github.com/philneff)"
# date: 2024-02-13
# copyright: UWCHR, GPL 3.0
# ---

library(pacman)
p_load(argparse, logger, tidyverse, arrow, lubridate, zoo, digest)

options(dplyr.summarise.inform = FALSE)

parser <- ArgumentParser()
parser$add_argument("--input", default = "input/ice_detentions_nov23-jul25.csv.gz")
parser$add_argument("--group", default = "detention_facility_code")
parser$add_argument("--log", default = "output/headcount.R.log")
parser$add_argument("--output", default = "output/headcount_nov23-jul25.csv.gz")
args <- parser$parse_args()

# append log file
f = args$log
log_appender(appender_file(f))

df <- read_delim(here::here('detain-headcount', args$input), delim='|') %>% 
  janitor::clean_names() %>% 
  mutate(stay_book_in_date_time = ymd_hms(stay_book_in_date_time),
         book_in_date_time = ymd_hms(book_in_date_time),
         detention_book_out_date_time = ymd_hms(detention_book_out_date_time),
         stay_book_out_date_time = ymd_hms(stay_book_out_date_time),
         )

# problems(df)

log_info("Total rows in: {nrow(df)}")

# skimr::skim(df)

timeline_start <- min(as.Date(df$book_in_date_time), na.rm=TRUE)
timeline_end <- max(as.Date(df$detention_book_out_date_time), na.rm=TRUE)
timeline_start_midnight <- as.POSIXct(paste(timeline_start, "00:00:00"), tz = "UTC") 
timeline_end_midnight <- as.POSIXct(paste(timeline_end, "00:00:00"), tz = "UTC") 
timeline <- seq(timeline_start_midnight, timeline_end_midnight, by='day')

group_vars <- unlist(str_split(args$group, ", "))

for (i in length(group_vars)) {
  var <- group_vars[i]
  df[[var]] <- factor(df[[var]], levels = sort(unique(df[[var]])))
}


# Fill `detention_book_out_date_time` with date of release of data for minimum stay lengths

max_date <- max(df$detention_book_out_date_time, na.rm=TRUE)

df <- df %>% 
  mutate(detention_book_out_date_time = case_when(is.na(detention_book_out_date_time) ~ max_date,
                                                  TRUE ~ detention_book_out_date_time))

headcounter <- function(date, group_vars) {
  
  in_range <- df[df$book_in_date_time <= date & df$detention_book_out_date_time > date,]
  
  in_range %>% 
    group_by(across(all_of(group_vars))) %>% 
    summarize(n = n()) %>% 
    complete(fill = list(n = 0)) %>% 
    mutate(date=date)
  
  }

system.time({headcount <- lapply(timeline, headcounter, group_vars=group_vars)})

headcount_data <- map_dfr(headcount, bind_rows)

write_delim(headcount_data, args$output, delim='|')

# END.