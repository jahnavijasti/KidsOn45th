# DATA 591, Winter 2018, University of Washington
# Copyright: Kids Helping Kids on 45th
# Author: Gary Gregg

# Clear the console, and the environment.  Take this out when development is
# complete.
# cat("\014")
# rm(list=ls())
# source('my_library.R')

# Declare the target character and target column for quote character
# replacement.
target_char <- get_substitute_quote_char()
target_column <- 12

# Read the data.
file_name <- 'pp_active_products'
cat(paste('Cleaning: \'', build_product_input_file_path(file_name), '\'...',
          sep = ''))
pp_active_products <- read_product_csv(file_name, my_quote = target_char)

# Create the POSIX date fields.
date_fields <- c('date_in', 'date_sold')
date_fields_posix <- build_posix_field_name(date_fields)

# Declare the currency fields.
currency_fields <- c('list_price',
                     'sold_price',
                     'credit_applied')

# Create the normalized date fields.
currency_fields_norm <- build_norm_field_name(currency_fields)

# Create a vector of column names.
my_colnames <- c(
  'index',
  'quantity',
  'quantity_sold_latest',
  'customer_no_product',
  'customer_no_sold',
  'quick_scancode',
  'product_scancode',
  'type_code',
  'condition_code',
  'size_code',
  'notes',
  'p_description',
  date_fields[1],
  date_fields[2],
  'clerk_id_in',
  'clerk_id_sold',
  'void',
  'category',
  currency_fields[1],
  'reduction',
  currency_fields[2],
  'invoice_no',
  'sale_price',
  'sale_item',
  'no_returned',
  currency_fields[3]
)

# Create a vector of enhanced column names.
my_enhanced_colnames <- c(
  my_colnames[1],
  my_colnames[2],
  my_colnames[3],
  my_colnames[4],
  my_colnames[5],
  my_colnames[6],
  my_colnames[7],
  my_colnames[8],
  my_colnames[9],
  my_colnames[10],
  my_colnames[11],
  my_colnames[12],
  my_colnames[13],
  date_fields_posix[1],
  my_colnames[14],
  date_fields_posix[2],
  my_colnames[15],
  my_colnames[16],
  my_colnames[17],
  my_colnames[18],
  my_colnames[19],
  currency_fields_norm[1],
  my_colnames[20],
  my_colnames[21],
  currency_fields_norm[2],
  my_colnames[22],
  my_colnames[23],
  my_colnames[24],
  my_colnames[25],
  my_colnames[26],
  currency_fields_norm[3]
)

# Set column names in the pp_active_products data.
colnames(pp_active_products) <- my_colnames

# Create the POSIX fields in the data.
pp_active_products[,date_fields_posix] <- sapply(seq(1:length(date_fields)),
                                                 FUN = function(x) {

  create_timestamp(pp_active_products[,date_fields[x]])
})

# Create the normalized currency fields in the data.
pp_active_products[,currency_fields_norm] <- sapply(seq(1:length(currency_fields)),
                                                    FUN = function(x) {

  calculate_normalized_price(pp_active_products[,currency_fields[x]],
                             pp_active_products[,date_fields_posix[1]])
})

# Round the other currency fields.
pp_active_products[,currency_fields] <- sapply(seq(1:length(currency_fields)),
                                               FUN = function(x) {

  round_currency(pp_active_products[,currency_fields[x]])
})

# Substitute quote characters in the description field.
pp_active_products[,target_column] <- gsub(get_quote_char(),
                                           target_char,
                                           pp_active_products[,target_column])

# Reorder the pp_active_products data and write the csv file.
write_product_csv(pp_active_products[,my_enhanced_colnames], file_name)

# Clean up...
rm(my_enhanced_colnames)
rm(my_colnames)
rm(currency_fields_norm)
rm(currency_fields)
rm(date_fields_posix)
rm(date_fields)
rm(pp_active_products)
rm(file_name)
rm(target_column)
rm(target_char)
