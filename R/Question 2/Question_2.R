# Copyright: Kids Helping Kids on 45th
# DATA 591: University of Washington, Spring 2018
# Author: Gary Gregg
#
# This script attempts to answer the question: Has per-month average
# balance-due in the sales table tracked inflation?

# Clear the console, and the environment.
cat("\014")
rm(list=ls())

# Source the library.
cat(paste('The working directory is: \'', getwd()), '\'...', sep = '')
source('my_library.R')

# Read the sales data from sales, and make a cut by month.
sales <- read_clean_sales_csv('sales')
sales$cut <- cut(as.Date(sales$the_date, format = get_kids_on_45th_date_format()),
                 breaks = 'months', labels = F)

# Take the mean of the balance due by month. Take only complete cases into
# consideration.
sales_by_month <- aggregate(balance_due ~ cut, data = sales, mean)
sales_by_month <- sales_by_month[complete.cases(sales_by_month),]

# Make a scatterplot of balance due versus month.
par(mfrow=c(1,1))
plot(balance_due ~ cut, data = sales_by_month,
     main='Mean Balance Due by Month Is Not Keeping Pace with Inflation',
     xaxt = 'n',
     xlab='Date', ylab = 'Mean Balance Due in Dollars', yaxt='n')
axis(2, at=axTicks(2), labels=sprintf('$%s', axTicks(2)), las=1)

# Create custom tickmarks for the X axis.
my_labels <- c('Jan 2007',
               'Sep 2008',
               'May 2010',
               'Jan 2012',
               'Sep 2013',
               'May 2015',
               'Jan 2017')
axis(1, at=seq(0, 120, 20), labels = my_labels)

# Declare colors for the trendlines that follow.
actual_trendline_color <- 'red'
expected_trendline_color <- 'dark green'

# Build a price model based on the real data. Draw a trendline.
coefficient_name <- 'cut'
price_model = lm(log(balance_due) ~ cut, data = sales_by_month)
x <- seq(-10., 130., 0.001)
lines(x, exp(price_model$coefficients['(Intercept)'] +
               x * price_model$coefficients[coefficient_name]),
      col=actual_trendline_color)

# Declare and initialize format, and month cuts for first and last months.
my_format <- get_inflation_date_format()
first_month <- min(sales$cut, na.rm = T)
last_month <- max(sales$cut, na.rm = T)

# Determine what the model thinks mean balance due should be at month zero.
at_zero <- exp(predict(price_model, data.frame(cut = first_month)))

# Determine what the same value *should* be based on the trend of inflation.
at_last <- at_zero *
  cpi_function(create_timestamp('15-04-17', my_format)) /
  cpi_function(create_timestamp('15-01-07', my_format))

# Build a data frame with the expected sales by month.
expected_sales_by_month <- data.frame(cut = c(first_month, last_month),
                                      balance_due = c(at_zero, at_last))

# Build an expected price model. Draw a trendline.
expected_model <- lm(log(balance_due) ~ cut, data = expected_sales_by_month)
lines(x, exp(expected_model$coefficients['(Intercept)'] +
               x * expected_model$coefficients[coefficient_name]),
      col=expected_trendline_color)

# Declare a few more local variables.
my_digits <- 4
my_format <- 'e'

# Create a legend...
my_separator <- '\t'
my_legend <- c(paste('Expected:',
                     formatC(expected_model$coefficients[coefficient_name],
                             format = my_format, digits = my_digits),
                     sep = my_separator),
               paste('Actual:\t',
                     formatC(price_model$coefficients[coefficient_name],
                             format = my_format, digits = my_digits),
                     sep = my_separator)
               )

# ...and draw the legend.
line_type <- 1
legend('topleft', legend = my_legend, lty=c(line_type, line_type),
       col = c(expected_trendline_color, actual_trendline_color))

# Clean up...
rm(line_type)
rm(my_legend)
rm(my_separator)
rm(my_format)
rm(my_digits)
rm(expected_model)
rm(expected_sales_by_month)
rm(at_last)
rm(at_zero)
rm(last_month)
rm(first_month)
rm(x)
rm(price_model)
rm(coefficient_name)
rm(expected_trendline_color)
rm(actual_trendline_color)
rm(sales_by_month)
rm(sales)
