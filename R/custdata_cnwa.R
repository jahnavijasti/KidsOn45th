# DATA 591, Winter 2018, University of Washington
# Copyright: Kids Helping Kids on 45th
# Author: Gary Gregg

# Clear the console, and the environment.  Take this out when development is
# complete.
# cat("\014")
# rm(list=ls())
# source('my_library.R')

# Read the data.
file_name <- 'cnwa'
cat(paste('Cleaning: \'', build_custdata_input_file_path(file_name), '\'...',
          sep = ''))
cnwa <- read_custdata_csv(file_name)

# Create a vector of column names. Set the column names in the users.
my_colnames <- c('customer_no')

# Set column names in the cnwa data, and write the csv file.
colnames(cnwa) <- my_colnames
write_custdata_csv(cnwa, file_name)

# Clean up...
rm(my_colnames)
rm(cnwa)
rm(file_name)
