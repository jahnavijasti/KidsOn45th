setwd("~/Desktop/Capstone")

library(tidyr)
library(base)
library(stats)

productData <- read.csv("PP_SOLD_PRODUCTS.csv")

product <- separate(productData, Date_in, into = c("date_in", "time_in"), sep = " ")
product <- separate(product, Date_Sold, into = c("date_Sold", "time_sold"), sep = " ")


summary(product)

### Number of days to sell the product
product$daysOnShelf <- difftime(strptime(product$date_Sold, format = "%m/%d/%y"),
                 strptime(product$date_in, format = "%m/%d/%y"), units = "days")

avgDays <- aggregate(daysOnShelf ~ Category, 
                     product[product$Customer_no_product != 999,], 
                     mean)


### Number of items in each category
category <- data.frame(table(product$Category))

## Average list price in each category
avgListPrice <- aggregate(Listprice ~ Category, product, mean)

## Average sold price in each category
avgSoldPrice <- aggregate(Soldprice ~ Category, product, mean)

## Average List and Sold Price
ListSoldPrice <- data.frame(avgListPrice$Category, avgListPrice$Listprice, avgSoldPrice$Soldprice)


##Most frequent price For category 1
cat1 <- data.frame(table(product[product$Category==1,]$Soldprice))

##Most frequent price For category 2
cat2 <- data.frame(table(product[product$Category==2,]$Soldprice))

##Most frequent price For category 3
cat3 <- data.frame(table(product[product$Category==3,]$Soldprice))

##Most frequent price For category 4
cat4 <- data.frame(table(product[product$Category==4,]$Soldprice))

##Most frequent price For category 5
cat5 <- data.frame(table(product[product$Category==5,]$Soldprice))

##Most frequent price For category MISC
catMISC <- data.frame(table(product[product$Category=="MISC",]$Soldprice))

#### Average sales monthly/yearly

product$date_Sold <- as.POSIXct(product$date_Sold, format = "%m/%d/%y")
library(data.table)
meanSales <- setDT(product)[, date := as.IDate(date_Sold)
            ][, .(mn_amt = mean(Soldprice)), by = .(yr = year(date), mon = months(date))]

aggregate(mn_amt ~ mon, meanSales, sum)
aggregate(mn_amt ~ yr, meanSales, sum)


### Number of items per condition
table(product$CONDITION_CODE)

## Average number of days to sell per condition
aggregate(days ~ CONDITION_CODE, product, mean)

## Average selling price per condition
aggregate(Soldprice ~ CONDITION_CODE, product, mean)

############ SIZE

### Number of items per size
table(product$SIZE_CODE)

## Average number of days to sell per size
aggregate(days ~ SIZE_CODE, product, mean)

## Average selling price per size
aggregate(Soldprice ~ SIZE_CODE, product[product[,"Soldprice"] > 0 ,], summary)


## Number of sales per clerk
clerkdf <- data.frame(table(product$Clerk_ID_Sold))
colnames(clerkdf) <- c("Clerk_Name", "Number_of_sales")
clerkdf$Percent_Sales <- (clerkdf$Number_of_sales/sum(clerkdf$Number_of_sales))*100
plot(x = clerkdf$Clerk_Name, y = clerkdf$Percent_Sales, type = "p")


## Category 1
prod1 <- subset(product, Category == 1)
prod1df <- aggregate(daysOnShelf ~ Soldprice, prod1, mean)
cond1df <- aggregate(daysOnShelf ~ CONDITION_CODE, prod1, mean)


## Category 2
prod2 <- subset(product, Category == 2)
prod2df <- aggregate(daysOnShelf ~ Soldprice, prod2, mean)
cond2df <- aggregate(daysOnShelf ~ CONDITION_CODE, prod2, mean)

## Category 3
prod3 <- subset(product, Category == 3)
prod3df <- aggregate(daysOnShelf ~ Soldprice, prod3, mean)
cond3df <- aggregate(daysOnShelf ~ CONDITION_CODE, prod3, mean)

## Category 4
prod4 <- subset(product, Category == 4)
prod4df <- aggregate(daysOnShelf  ~ Soldprice, prod4, mean)
cond4df <- aggregate(daysOnShelf ~ CONDITION_CODE, prod4, mean)


## Category 5
prod5 <- subset(product, Category == 5)
prod5df <- aggregate(daysOnShelf ~ Soldprice, prod5, mean)
cond5df <- aggregate(daysOnShelf ~ CONDITION_CODE, prod5, mean)





### For merge
library(data.table)

DT <- as.data.table(product[product$Customr_no_sold !=600,])
productSale <- data.frame(DT[, list(TotalAmount = sum(Soldprice), NumerOfProducts = .N
                                    ), by = list(Customer = Customr_no_sold, Date_sold = date_Sold,
                                                                      Invoice.)])
productSale$Date_sold <- as.Date(productSale$Date_sold, format = "%m/%d/%y")



####### Categories 
cat1 <- subset(product, Category == 1)
category1 <- data.frame(table(cat1$P_Description))

cat2 <- subset(product, Category == 2)
category2 <- data.frame(table(cat2$P_Description))

cat3 <- subset(product, Category == 3)
category3 <- data.frame(table(cat3$P_Description))

cat4 <- subset(product, Category == 4)
category4 <- data.frame(table(cat4$P_Description))

cat5 <- subset(product, Category == 5)
category5 <- data.frame(table(cat5$P_Description))

