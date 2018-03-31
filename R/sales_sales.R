# DATA 591, Winter 2018, University of Washington
# Copyright: Kids Helping Kids on 45th
# Author: Gary Gregg

# Clear the console, and the environment.  Take this out when development is
# complete.
# cat("\014")
# rm(list=ls())
# source('my_library.R')

# Read the data.
file_name <- 'sales'
cat(paste('Cleaning: \'', build_sales_input_file_path(file_name), '\'...',
          sep = ''))
sales <- read_sales_csv(file_name)

# Create the POSIX date fields.
date_fields <- c('the_date')
date_fields_posix <- build_posix_field_name(date_fields)

# Declare the currency fields.
currency_fields <- c('sub_total',
                     'credit_total',
                     'tax_total',
                     'balance_due',
                     'shipping',
                     'invoice_total',
                     'return_total',
                     'sales_total_sub',
                     'cash_returns_sub',
                     'credit_returns_sub',
                     'credit_returns_notax',
                     'discount_total',
                     'invoice_discount',
                     'credit_before',
                     'credit_after')

# Create the normalized date fields.
currency_fields_norm <- build_norm_field_name(currency_fields)

# Create a vector of column names.
my_colnames <- c(
  'invoice_no',
  currency_fields[1],
  currency_fields[2],
  currency_fields[3],
  currency_fields[4],
  'clerk_id',
  'sold_to',
  'terms',
  currency_fields[5],
  'apply_con_bal',
  currency_fields[6],
  currency_fields[7],
  currency_fields[8],
  currency_fields[9],
  currency_fields[10],
  currency_fields[11],
  date_fields[1],
  currency_fields[12],
  currency_fields[13],
  currency_fields[14],
  currency_fields[15]
)

# Create a vector of enhanced column names.
my_enhanced_colnames <- c(
  my_colnames[1],
  my_colnames[2],
  currency_fields_norm[1],
  my_colnames[3],
  currency_fields_norm[2],
  my_colnames[4],
  currency_fields_norm[3],
  my_colnames[5],
  currency_fields_norm[4],
  my_colnames[6],
  my_colnames[7],
  my_colnames[8],
  my_colnames[9],
  currency_fields_norm[5],
  my_colnames[10],
  my_colnames[11],
  currency_fields_norm[6],
  my_colnames[12],
  currency_fields_norm[7],
  my_colnames[13],
  currency_fields_norm[8],
  my_colnames[14],
  currency_fields_norm[9],
  my_colnames[15],
  currency_fields_norm[10],
  my_colnames[16],
  currency_fields_norm[11],
  my_colnames[17],
  date_fields_posix[1],
  my_colnames[18],
  currency_fields_norm[12],
  my_colnames[19],
  currency_fields_norm[13],
  my_colnames[20],
  currency_fields_norm[14],
  my_colnames[21],
  currency_fields_norm[15]
)

# Set column names in the sales data.
colnames(sales) <- my_colnames

# Create the POSIX fields in the data.
sales[,date_fields_posix] <- sapply(seq(1:length(date_fields)),
                                    FUN = function(x) {
  create_timestamp(sales[,date_fields[x]])
})

# Create the normalized currency fields in the data.
sales[,currency_fields_norm] <- sapply(seq(1:length(currency_fields)),
                                      FUN = function(x) {

  calculate_normalized_price(sales[,currency_fields[x]],
                             sales[,date_fields_posix[1]])
})

# Round the other currency fields.
sales[,currency_fields] <- sapply(seq(1:length(currency_fields)),
                                 FUN = function(x) {

  round_currency(sales[,currency_fields[x]])
})

# Reorder the sales data and write the csv file.
write_sales_csv(sales[,my_enhanced_colnames], file_name)

# Clean up...
rm(my_enhanced_colnames)
rm(my_colnames)
rm(currency_fields_norm)
rm(currency_fields)
rm(date_fields_posix)
rm(date_fields)
rm(sales)
rm(file_name)
