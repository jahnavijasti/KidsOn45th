# DATA 591, Winter 2018, University of Washington
# Copyright: Kids Helping Kids on 45th
# Author: Gary Gregg
#
# This script attempts to answer the question: What has been the
# month-over-month number of items purchased per transaction?

# Clear the console, and the environment.
cat("\014")
rm(list=ls())

# Source the library.
cat(paste('The working directory is: \'', getwd()), '\'...', sep = '')
source('my_library.R')

# Calculates the average number of items purchased per transaction per month.
#
# Note: We count all items purchased by one customer on one day as one
# transction.  It is possible, however, that a customer could have made more
# than one visit to the store in one day, and purchased items each time.  We
# count this as one transaction.
calculate_average_items_purchased_per_month <- function(data_frame) {
  
  # Declare the column names in the result.
  column_names <- c('month_cut',
                    'mean_items_purchased',
                    'month_start')
  
  # Declare the time interval of interest.
  interval = 'month'
  
  # Aggregate the sum of quantity sold by customer and date sold.
  by_customer_and_date <- aggregate(
    quantity_sold_latest ~ customer_no_sold + date_sold, data = data_frame,
    sum)
  
  # Make a cut of the date sold by month.
  by_customer_and_date$month_cut <- cut(
    as.Date(by_customer_and_date$date_sold,
            format=get_kids_on_45th_date_format()), breaks = interval,
    labels = F)
  
  # Aggregate again by the month cut, and take the mean.
  mean_per_month <- aggregate(quantity_sold_latest ~ month_cut,
                              data = by_customer_and_date, mean)
  
  # Now add a month start field.
  mean_per_month$month_start <-
    seq(as.Date(get_interval_start(by_customer_and_date, min, interval)),
        as.Date(get_interval_start(by_customer_and_date, max, interval)),
        by = interval)
  
  # Change the column names.  Reorder the columns, and return.
  colnames(mean_per_month) <- column_names
  mean_per_month[,c(column_names[1], column_names[3], column_names[2])]
}

# Plots mean items purchased by month.
do_plot <- function(mean_items_purchased_by_month, title, legend_position) {
  
  # Create a linear model of mean items purchased by month, and get a summary
  # of the model.
  my_model <- lm(mean_items_purchased ~ month_cut,
                 data = mean_items_purchased_by_month)
  my_summary <- summary(my_model)
  
  # Create labels for a plot.
  my_labels <- c(as.Date(cut(min(mean_items_purchased_by_month$month_start[1]
                                 - 1), breaks = 'month')),
                 mean_items_purchased_by_month$month_start)
  
  # Create itervals at which ticks will be shown on the x-axis.
  intervals <- seq(mean_items_purchased_by_month$month_cut[1] - 1,
                   mean_items_purchased_by_month$month_cut[nrow(mean_items_purchased_by_month)],
                   10)
  
  # Plot means items purchased by month, but leave off the x-axis tick marks.
  plot(mean_items_purchased ~ month_cut,
       data = mean_items_purchased_by_month,
       xaxt = 'n',
       xlab = 'Date',
       ylab = 'Mean Items Purchased per Transaction',
       las  = 1,
       main = title)
  
  # Put on our own x-axis tick marks. Put in a trend line from the model.
  axis(1, at=intervals, labels = format(my_labels[intervals + 1], '%b %y'))
  my_color <- 'red'
  abline(my_model, col = my_color)
  
  # Declare a few more local variables.
  my_digits <- 2
  my_format <- 'e'
  
  # Draw a legend with the slope of the trend line and its p-value
  # signficance.
  legend(legend_position[1], legend_position[2],
         legend = c(paste('Slope:',
                          formatC(my_model$coefficients['month_cut'],
                                  format = my_format, digits = my_digits),
                          'per month; P-value:',
                          formatC(my_summary$coefficients[8],
                                  format = my_format, digits = my_digits))),
         col = my_color, lty=1:2, cex=0.8)
}

# Read pp_sold_products.  It comes in several pieces. Exclude store purchased
# items.
pp_sold_products <- read_clean_sales_csv_in_pieces('pp_sold_products',
                                                   get_sales_sold_products_piece_count())
exclude_store <- pp_sold_products[pp_sold_products$customer_no_sold != store_id,]

# Declare a factor of exploration paths.
cases <- as.factor(seq(1:5))
current_case <- cases[1]

# Case 1: Both consignment and new.
if (cases[1] == current_case) {
  
  # Calculate average items purchased per month.
  do_plot(calculate_average_items_purchased_per_month(exclude_store),
          'Consignment and New Items Purchased by Customers', c(40., 4.9))
  
# Case 2: Only consignment items.
} else if (cases[2] == current_case) {
  
  # Calculate average consignment items purchased per month.
  do_plot(calculate_average_items_purchased_per_month(
    exclude_store[exclude_store$customer_no_product != new_product_id,]),
          'Consignment Items Purchased by Customers', c(40., 4.7))
  
# Case 3: Only new items.
} else if (cases[3] == current_case) {
  
  # Calculate average new items purchased per month.
  do_plot(calculate_average_items_purchased_per_month(
    exclude_store[exclude_store$customer_no_product == new_product_id,]),
    'New Items Purchased by Customers', c(40., 2.8))
  
# Undefined cases.
} else {
  
  # Just put a message on the console.
  cat(paste('Case number', current_case, 'is currently undefined.'))
}

# Clean up...
rm(current_case)
rm(cases)
rm(exclude_store)
rm(pp_sold_products)
rm(do_plot)
rm(calculate_average_items_purchased_per_month)
