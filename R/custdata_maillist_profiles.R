# DATA 591, Winter 2018, University of Washington
# Copyright: Kids Helping Kids on 45th
# Author: Gary Gregg

# Clear the console, and the environment.  Take this out when development is
# complete.
# cat("\014")
# rm(list=ls())
# source('my_library.R')

# Read the data.
file_name <- 'maillist_profiles'
cat(paste('Cleaning: \'', build_custdata_input_file_path(file_name), '\'...',
          sep = ''))
maillist_profiles <- read_custdata_csv(file_name)

# Create the POSIX date fields.
date_fields <- c('date_added', 'start_date', 'end_date')
date_fields_posix <- build_posix_field_name(date_fields)

# Create a vector of column names.
my_colnames <- c('id',
                 'mail_list_profile',
                 'customer_id',
                 date_fields[1],
                 'last_name',
                 'city',
                 'state',
                 'zip',
                 'phone',
                 'notes',
                 date_fields[2],
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
                          date_fields_posix[2],
                          my_colnames[12],
                          date_fields_posix[3])

# Set column names in the maillist_profiles data.
colnames(maillist_profiles) <- my_colnames

# Create the POSIX fields in the data.
maillist_profiles[,date_fields_posix] <- sapply(seq(1:length(date_fields)),
                                                FUN = function(x) {
                                                
  create_timestamp(maillist_profiles[,date_fields[x]])
})

# Reorder the maillist_profiles data and write the csv file.
write_custdata_csv(maillist_profiles[,my_enhanced_colnames], file_name)

# Clean up...
rm(my_enhanced_colnames)
rm(my_colnames)
rm(date_fields_posix)
rm(date_fields)
rm(maillist_profiles)
rm(file_name)
