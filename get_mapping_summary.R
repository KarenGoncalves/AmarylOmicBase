#!/usr/bin/env Rscript

# Load required libraries
library(readr, quietly=T) # Write output
library(dplyr, quietly=T) # Format table
library(jsonlite)    # For reading JSON files

# Find all 'run_info.json' files recursively in current directory
fileNames <- list.files(
  path = ".",
  pattern = "run_info.json",
  recursive = TRUE,
  include.dirs = TRUE,
  full.names = TRUE
)

# Process each JSON file
results <- sapply(fileNames, simplify = FALSE, function(x) {
  read_json(x) |>
    as.data.frame() |>
    mutate(
      Replicate = basename(dirname(x)),  # Extract replicate name from folder
      Library_type = ifelse(grepl("_2.fastq", call), "Paired", "Single")
    )
})

# Combine all results into one data frame
summary <- bind_rows(results) |>
  select(-call, -start_time)  # Remove unnecessary columns

# Write the final summary to a tab-delimited file
write_delim(summary, 'mapping_summary.txt', delim = '\t', quote = 'none')
