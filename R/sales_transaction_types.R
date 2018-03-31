# DATA 591, Winter 2018, University of Washington
# Copyright: Kids Helping Kids on 45th
# Author: Gary Gregg

# Clear the console, and the environment.  Take this out when development is
# complete.
# cat("\014")
# rm(list=ls())
# source('my_library.R')

# Read the data.
file_name <- 'transaction_types'
cat(paste('Cleaning: \'', build_sales_input_file_path(file_name), '\'...',
          sep = ''))
transaction_types <- read_sales_csv(file_name)

# Create a vector of column names. Set the column names in the
# transaction_types.
my_colnames <- c(
  'transaction_type',
  'notes'
)

# Set column names in the transaction_types data, and write the csv file.
colnames(transaction_types) <- my_colnames
write_sales_csv(transaction_types, file_name)

# Clean up...
rm(my_colnames)
rm(transaction_types)
rm(file_name)
