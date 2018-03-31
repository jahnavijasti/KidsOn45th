# DATA 591, Winter 2018, University of Washington
# Copyright: Kids Helping Kids on 45th
# Author: Gary Gregg

# Clear the console, and the environment.  Take this out when development is
# complete.
# cat("\014")
# rm(list=ls())
# source('my_library.R')

# Read the data.
file_name <- 'gift_cert'
cat(paste('Cleaning: \'', build_sales_input_file_path(file_name), '\'...',
          sep = ''))
gift_cert <- read_sales_csv(file_name)

# Create the POSIX date fields.
date_fields <- c('the_date')
date_fields_posix <- build_posix_field_name(date_fields)

# Declare the normalized currency fields.
currency_fields <- c('amount', 'applied_balance', 'amount_collected')
currency_fields_norm <- build_norm_field_name(currency_fields)

# Create a vector of column names. Set the column names in the transaction
# types.
my_colnames <- c(
  'id',
  'clerk_id',
  'cert_no',
  'sold_to',
  currency_fields[1],
  currency_fields[2],
  currency_fields[3],
  date_fields[1],
  'notes',
  'donation'
)

# Create a vector of enhanced column names.
my_enhanced_colnames <- c(my_colnames[1],
                          my_colnames[2],
                          my_colnames[3],
                          my_colnames[4],
                          my_colnames[5],
                          currency_fields_norm[1],
                          my_colnames[6],
                          currency_fields_norm[2],
                          my_colnames[7],
                          currency_fields_norm[3],
                          my_colnames[8],
                          date_fields_posix[1],
                          my_colnames[9],
                          my_colnames[10])

# Set column names in the gift_cert data, and write the csv file.
colnames(gift_cert) <- my_colnames

# Create the POSIX fields in the data.
gift_cert[,date_fields_posix] <- sapply(seq(1:length(date_fields)),
                                        FUN = function(x) {
  create_timestamp(gift_cert[,date_fields[x]])
})

# Create the normalized currency fields in the data.
gift_cert[,currency_fields_norm] <- sapply(seq(1:length(currency_fields)),
                                          FUN = function(x) {
                                            
  calculate_normalized_price(gift_cert[,currency_fields[x]],
                             gift_cert[,date_fields_posix[1]])
})

# Round the other currency fields.
gift_cert[,currency_fields] <- sapply(seq(1:length(currency_fields)),
                                     FUN = function(x) {

  round_currency(gift_cert[,currency_fields[x]])
})

# Reorder the gift_cert data and write the csv file.
write_sales_csv(gift_cert[,my_enhanced_colnames], file_name)

# Clean up...
rm(my_enhanced_colnames)
rm(my_colnames)
rm(currency_fields_norm)
rm(currency_fields)
rm(date_fields_posix)
rm(date_fields)
rm(gift_cert)
rm(file_name)
