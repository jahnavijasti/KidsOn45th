# DATA 591, Winter 2018, University of Washington
# Copyright: Kids Helping Kids on 45th
# Author: Gary Gregg

# Clear the console, and the environment.  Take this out when development is
# complete.
# cat("\014")
# rm(list=ls())
# source('my_library.R')

# Read the data.
file_name <- 'customers'
cat(paste('Cleaning: \'', build_custdata_input_file_path(file_name), '\'...',
          sep = ''))
customers <- read_custdata_csv(file_name)

# Create the POSIX date fields.
date_fields <- c('date_added', 'birthday', 'last_update')
date_fields_posix <- build_posix_field_name(date_fields)

# Create a vector of column names.
my_colnames <- c('id',
                 'customer_id',
                 date_fields[1],
                 'first_name',
                 'last_name',
                 'middle_initial',
                 'street',
                 'apt_no',
                 'city',
                 'state',
                 'zip',
                 'phone',
                 'fax',
                 'alt_phone',
                 'notes',
                 date_fields[2],
                 'mailing_list',
                 'no_of_children',
                 'other_stat_1',
                 'other_stat_2',
                 'other_stat_3',
                 'other_stat_4',
                 'other_stat_5',
                 date_fields[3])

# Create a vector of enhanced column names.
my_enhanced_colnames <- c(my_colnames[1],
                          my_colnames[2],
                          my_colnames[3],
                          date_fields_posix[1],
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
                          my_colnames[14],
                          my_colnames[15],
                          my_colnames[16],
                          date_fields_posix[2],
                          my_colnames[17],
                          my_colnames[18],
                          my_colnames[19],
                          my_colnames[20],
                          my_colnames[21],
                          my_colnames[22],
                          my_colnames[23],
                          my_colnames[24],
                          date_fields_posix[3]
                          )

# Set column names in the customers data.
colnames(customers) <- my_colnames

# Create the POSIX fields in the data.
customers[,date_fields_posix] <- sapply(seq(1:length(date_fields)),
                                        FUN = function(x) {
                                                
  create_timestamp(customers[,date_fields[x]])
})

# Reorder the customers data and write the csv file.
write_custdata_csv(customers[,my_enhanced_colnames], file_name)

# Clean up...
rm(my_enhanced_colnames)
rm(my_colnames)
rm(date_fields_posix)
rm(date_fields)
rm(customers)
rm(file_name)
