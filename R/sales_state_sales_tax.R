# DATA 591, Winter 2018, University of Washington
# Copyright: Kids Helping Kids on 45th
# Author: Gary Gregg

# Clear the console, and the environment.  Take this out when development is
# complete.
# cat("\014")
# rm(list=ls())
# source('my_library.R')

# Read the data.
file_name <- 'state_sales_tax'
cat(paste('Cleaning: \'', build_sales_input_file_path(file_name), '\'...',
          sep = ''))
state_sales_tax <- read_sales_csv(file_name)

# Create a vector of column names. Set the column names in the
# state_sales_tax.
my_colnames <- c(
  'id',
  'state',
  'sales_tax',
  'notes'
)

# Set column names in the state_sales_tax data, and write the csv file.
colnames(state_sales_tax) <- my_colnames
write_sales_csv(state_sales_tax, file_name)

# Clean up...
rm(my_colnames)
rm(state_sales_tax)
rm(file_name)
