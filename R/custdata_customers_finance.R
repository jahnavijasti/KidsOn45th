# DATA 591, Winter 2018, University of Washington
# Copyright: Kids Helping Kids on 45th
# Author: Gary Gregg

# Clear the console, and the environment.  Take this out when development is
# complete.
# cat("\014")
# rm(list=ls())
# source('my_library.R')

# Read the data.
file_name <- 'customers_finance'
cat(paste('Cleaning: \'', build_custdata_input_file_path(file_name), '\'...',
          sep = ''))
customers_finance <- read_custdata_csv(file_name)

# Declare the currency fields.
currency_fields <- c('account_balance',
                     'acc_bal_running_total')

# Create a vector of column names.
my_colnames <- c('index',
                 'customer_no',
                 currency_fields[1],
                 currency_fields[2])

# Set column names in the customers_finance data.
colnames(customers_finance) <- my_colnames

# Round the currency fields.
customers_finance[,currency_fields] <- sapply(seq(1:length(currency_fields)),
                                              FUN = function(x) {

  round_currency(customers_finance[,currency_fields[x]])
})

# Write the customers_finance file.
write_custdata_csv(customers_finance, file_name)

# Clean up...
rm(my_colnames)
rm(currency_fields)
rm(customers_finance)
rm(file_name)
