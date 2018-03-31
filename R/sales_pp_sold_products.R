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
file_name <- 'pp_sold_products'
cat(paste('Cleaning: \'', build_sales_input_file_path(file_name), '\'...',
          sep = ''))
pp_sold_products <- read_sales_csv(file_name, my_quote = target_char)

# Create the POSIX date fields.
date_fields <- c('date_in', 'date_sold')
date_fields_posix <- build_posix_field_name(date_fields)

# Declare the currency fields.
date_in_currency_fields <- c('listprice')
date_sold_currency_fields <- c('soldprice', 'credit_applied')

# Create the normalized currency fields.
date_in_currency_fields_norm <- build_norm_field_name(date_in_currency_fields)
date_sold_currency_fields_norm <-
  build_norm_field_name(date_sold_currency_fields)

# Create a vector of column names.
my_colnames <- c('index',
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
                 date_in_currency_fields[1],
                 'reduction',
                 date_sold_currency_fields[1],
                 'invoice_no',
                 'return',
                 'sale_price',
                 'sale_item',
                 'no_returned',
                 date_sold_currency_fields[2])

# Create a vector of enhanced column names.
my_enhanced_colnames <- c(my_colnames[1],
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
                          date_in_currency_fields_norm[1],
                          my_colnames[20],
                          my_colnames[21],
                          date_sold_currency_fields_norm[1],
                          my_colnames[22],
                          my_colnames[23],
                          my_colnames[24],
                          my_colnames[25],
                          my_colnames[26],
                          date_sold_currency_fields_norm[2])

# Set column names in the pp_sold_products data. Substitute quote characters in
# the description field.
colnames(pp_sold_products) <- my_colnames
pp_sold_products[,target_column] <- gsub(get_quote_char(),
                                        target_char,
                                        pp_sold_products[,target_column])

# Create the POSIX fields in the data.
pp_sold_products[,date_fields_posix] <- sapply(seq(1:length(date_fields)),
                                               FUN = function(x) {
                                                
  create_timestamp(pp_sold_products[,date_fields[x]])
})

# Create the normalized date-in currency fields in the data.
pp_sold_products[,date_in_currency_fields_norm] <- sapply(
  seq(1:length(date_in_currency_fields)), FUN = function(x) {

  calculate_normalized_price(pp_sold_products[,date_in_currency_fields[x]],
                             pp_sold_products[,date_fields_posix[1]])
})

# Create the normalized date-sold currency fields in the data.
pp_sold_products[,date_sold_currency_fields_norm] <- sapply(
  seq(1:length(date_sold_currency_fields)), FUN = function(x) {
    
    calculate_normalized_price(
      pp_sold_products[,date_sold_currency_fields[x]],
      pp_sold_products[,date_fields_posix[2]])
  })

# Round the other date-in currency fields.
pp_sold_products[,date_in_currency_fields] =
  sapply(seq(1:length(date_in_currency_fields)),
         FUN = function(x) {
           
  round_currency(pp_sold_products[,date_in_currency_fields[x]])
})

# Round the other date-sold currency fields.
pp_sold_products[,date_sold_currency_fields] =
  sapply(seq(1:length(date_sold_currency_fields)),
         FUN = function(x) {
           
           round_currency(pp_sold_products[,date_sold_currency_fields[x]])
         })

# Reorder the pp_sold_products data and write the csv file in 3 pieces.
write_sales_csv_in_pieces(pp_sold_products[,my_enhanced_colnames],
                          file_name, get_sales_sold_products_piece_count())

# Clean up...
rm(my_enhanced_colnames)
rm(my_colnames)
rm(date_sold_currency_fields_norm)
rm(date_in_currency_fields_norm)
rm(date_sold_currency_fields)
rm(date_in_currency_fields)
rm(date_fields_posix)
rm(date_fields)
rm(pp_sold_products)
rm(file_name)
rm(target_column)
rm(target_char)
