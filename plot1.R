# plot1.R
# Coursera - course 4, Project 2
# Exploratary Data Analysis
# student: mgk2010
# github URL - insert here...
#
# purpose: 
#   Have total emissions from PM decreased in the United States from 1999 to 2008? Using the base
#    plotting system, make a plot showing the total PM emission from all sources for each of the years
#   1999, 2002, 2005, and 2008.
#
# method: leverage ddply package to aggregate the emmissions by year in the NEI data-set
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
png(file = "plot1.png", width = 500, height = 500, units = 'px')
par(mar = c(5,5,3,2))

# open the NEI data source
NEI <- readRDS(srcFile)

# aggregate the data
totalEmissions <- ddply(NEI, .(year), summarize, total=sum(Emissions))

# plot using base plotting system
with (totalEmissions, plot(totalEmissions$year, totalEmissions$total, type = "b", xlab = "Years", ylab = "Emissions (Tons)"))
title(main = "Plot 1 - Total PM2.5 Emissions in United States from 1999-2008")

# write the file
dev.off()

# remove data that is no longer needed
rm(NEI, totalEmissions)
