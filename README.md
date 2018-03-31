# KidsOn45th
Capstone Project for Kids Helping Kids on 45th

## Deliverables to the Sponsor
Find in the Documents subdirectory the following: 1) Final report to the sponsor from March 2018 in PDF format (Findings & Recommendations for Kids on 45th); 2) Proposal for our sponsor from December 2017 in MS Word, Open Office and PDF formats (Proposal for Kids on 45th DATA 590 Final); 3) Project fair poster from March 2018 in MS Powerpoint format (Kids on 45th Poser); 4) Data pipeline document from November 2017 in MS Word, Open Office and PDF format (Data Pipeline Document).

## Primary Research Product for Sponsor
The research team has authored a 44 page results and recommendations document.  This is located in the Documents subdirectory (also mentioned above, and below).  The title of the document is “Findings & Recommendation for Kids on 45th” and is provided in PDF format from a Google Docs original.

## Public Tableau Website for this Project
https://public.tableau.com/profile/jahnavi.jasti#!/

## Subdirectories
The repository contains the products of the data analysis for Kids on 45th.  Kids on 45th is a mixed new item, and consignment item retail store in the Wallingford neighborhood of Seattle, Washington.  The team performing the research consisted of Gary Gregg, Jahnavi Jasti and Abhishek Varma.  Research was conducted in an ongoing basis from September 2017 through March 2018.  This repository is divided into several subdirectories, described as follows:

### Custdata
This subdirectory contains the tables of the Custdata database supplied by Kids on 45th.  Custdata was one of four, legacy MS Access databases owned by the previous owners of the enterprise.  Here included are the CSV exports of seven of the actual database tables in the database, along with “cleaned” versions of each.  Clean versions of the tables have a “clean” prefix to their names.  See a description of the cleaning process further in this file.

### Documents
This subdirectory contains, among other items, project fair poster images created by Jahnavi Jasti, the capstone fair flyer, a data definition spreadsheet, a data pipeline document, the final report delivered to Kids on 45th, fair poster comments prepared by Gary Gregg for other 1st cohort projects, and a proposal document for this project.  See the “Deliverables to the Sponsor” section, above.

### Inflation
Inflation data supplied by the city of Seattle, Washington, to cover the period during which legacy sales data had been collected by the previous owners of Kids on 45th.  Here contained is only a CSV dump of the data.  See the final report for a link to the publicly available inflation data provided by the City of Seattle.

### Product
This subdirectory contains the tables of the Product database supplied by Kids on 45th.  Product was one of four, legacy MS Access databases owned by the previous owners of the enterprise.  Here included are the CSV exports of six of the actual database tables in the database, along with “cleaned” versions of each.  Clean versions of the table have a “clean” prefix to their names.  See a description of the cleaning process further in this file.

### R
This directory contains R programming language code created by Gary Gregg to clean the databases, and to produce research answers and visualizations for Gary’s results.  The research questions are numbered 1 through 5.  A cursory examination of either the R code, or the visualizations for any research question should be self-explanatory for the nature of the research.  Visualizations files are included as both image and PDF formats in each research question subdirectory.  These will also be found as figures in the final report.  Fourteen of the twenty-four figures in the report are R code generated, and eight are Tableau generated images.  See the public Tableau website link, above.

### Sales
This subdirectory contains the tables of the Sales database supplied by Kids on 45th.  Sales was one of four, legacy MS Access databases owned by the previous owners of the enterprise.  Here included are the CSV exports of eight of the actual database tables in the database, along with “cleaned” versions of each.  Clean versions of the tables have a “clean” prefix to their names.  See a description of the cleaning process further in this file.

### Scandata
This subdirectory contains the tables of the Scandata database supplied by Kids on 45th.  Scandata was one of four, legacy MS Access databases owned by the previous owners of the enterprise.  Here included are the CSV exports of two of the actual database tables in the database, along with “cleaned” versions of each.  Clean versions of the tables have a “clean” prefix to their names.  See a description of the cleaning process further in this file.

### Sponsor Meeting Minutes
Minutes for each of the meetings that the research team conducted with the sponsors, Elise and Bookis Worthy, owners of Kids on 45th.

### Standup Meeting Minutes
Minutes for each of the meetings that the research team conducted with their faculty advisor, Megan Ursula.

### Team Meeting Minutes
Minutes of each of the meetings that the research team held among themselves.

## Cleaning Process for the Access Database Tables
This information may prove most useful to anyone doing subsequent research on these data.  Where both a date, and currency value appear in any database table, we have normalized the data to June 2017.  This will allow apples-to-apples comparisons of currency values where this is desirable.  The cleaning code is contained in R subdirectory of this repository.  It works by assigning to each date a seconds elapsed offset from the beginning of the UNIX epoch (1 January 1970).  It then uses an interpolative spline function constructed from the inflation data supplied by the city of Seattle.  A CPI index for June 2017 is multiplied by the currency amount, and then divided by the CPI index for the supplied date.

Each “cleaned” database table that contains at least one date and at least one currency field had two fields added: 1) the seconds elapsed from the beginning of the UNIX epoch (these have a “_posix” suffix appended to the name of the original field); 2) the currency field adjusted to June 2017 (these have a “_norm” suffix appended to the name of the original field).  Some tables have date-in fields, date-sold fields, and currency amounts for list price and sold price.  Where these occur, list prices have been normalized using the date-in field, and sold prices have been normalized using the date-sold field.  Tables with date-in and date-sold therefore have four additional fields, two with “_posix” suffixes, and two with “_norm” prefixes.  One pair of these apply to date-in, the other to date-sold.

Other steps included in the cleaning process were to normalize the column names in each table, and rounding each currency value to two decimal places.

## Conclusions, and Recommendations for Future Work
Our sponsors have already modified their data acquisition activities to better support analysis activities.  We strongly recommend that they examine our database design included in the final report.  Our thoughts are that there is little to be gained by more time spent with these legacy sales data.  However, if desirable, it might be useful when examining currency fields in the legacy data that the future analysis use the “normalized” currency amounts for June 2017 that we had created (see above).  These normalized currency amounts are side-by-side with the unmodified amounts in the tables where they occur.

Supplemental note as of 15 March, 2018: A late-developing theory is that changes in international exchange rates are responsible for a multi-year cyclicity in the SRP of new items available at Kids on 45th, and at other retail locations such as Target or Fred Meyer.  This, in turn, may be responsible for similar, though seemingly uncorrelated cycles in the prices for consignment items since 2007.  The idea is that the availability of cheaper new items may be a causitive factor for the general decline in consignment item sales.  There may be new confirming, or refuting additions that relate to this theory added to this repository before we present our final report to Elise and Bookis Worthy on 16 March 2018.

## Other Notes
The final report supplied in the Documents subdirectory is that which was supplied to Elise and Bookis Worthy at the conclusion of the research in March 2018.  Other documents supplied to the principals during the course of this research included the project proposal, the data pipeline, and all standup and sponsor meeting minutes.  All are available in this repository.  See the subdirectory descriptions, above.

Thank you, it’s been a pleasure to work with you!
The Research Team

