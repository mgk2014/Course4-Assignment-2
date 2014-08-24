# plot2.R
# Coursera - course 4, Project 2
# Exploratary Data Analysis
# student: mgk2010
# github URL - insert here...
#
# purpose: create plot 2 
#   check growth/decline of total emissions in Baltimore City in NEI data
#

library(plyr)

srcFile <- "./data/summarySCC_PM25.rds"
srcData <- "./data/summarySCC_PM25.zip"
srcDataUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"

# Ensure the data exists in the ./data directory, if not download and unzip it
#
if (!file.exists(srcFile)) {
    if (!file.exists(srcData)){
        if(!file.exists("data")) dir.create("data")
        download.file(srcDataUrl, srcData, method="curl")
    }
    unzip(srcData, exdir = "./data")
}

# set the options to not show scientific notations when plots are drawn
options(scipen=5)

# open a PNG device
png(file = "plot2.png", width = 500, height = 500, units = 'px')
par(mar = c(5,5,3,2))

# open the NEI data source
NEI <- readRDS(srcFile)

# subet to get data for Baltimore city only
balti <- NEI[NEI$fips == "24510", ]

# aggregate data for Baltimore
balti <- ddply(balti, .(year), summarize, total=sum(Emissions))   # will NOT summarize

# plot using base plotting system
plot(balti$year, balti$total, type = "l", xlab = "years", 
     ylab = "Emissions (Tons)")
title(main = "Plot 2 - Total PM2.5 Emissions in Baltimore from 1999-2008")


# write the file
dev.off()

# remove data that is no longer needed
rm(NEI, balti)
