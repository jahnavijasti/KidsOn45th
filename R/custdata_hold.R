# DATA 591, Winter 2018, University of Washington
# Copyright: Kids Helping Kids on 45th
# Author: Gary Gregg

# Clear the console, and the environment.  Take this out when development is
# complete.
# cat("\014")
# rm(list=ls())
# source('my_library.R')

# Read the data.
file_name <- 'hold'
cat(paste('Cleaning: \'', build_custdata_input_file_path(file_name), '\'...',
          sep = ''))
hold <- read_custdata_csv(file_name)

# Create a vector of column names. Set the column names in the users.
my_colnames <- c(
  'last_index',
  'last_invoice'
)

# Set column names in the hold data, and write the csv file.
colnames(hold) <- my_colnames
write_custdata_csv(hold, file_name)

# Clean up...
rm(my_colnames)
rm(hold)
rm(file_name)
