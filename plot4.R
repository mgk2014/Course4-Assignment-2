# plot4.R
# Coursera - course 4, Project 2
# Exploratary Data Analysis
# student: mgk2010
# github URL - insert here...
#
# purpose: create plot 4
#   Plot Across the United States, how have emissions from coal combustion-related 
#       sources changed from 1999–2008?
#
# NOTE = I have chosen to use EI.Sector variable in the SCC data set to find sources
#       that are coal based. This could be optimized further to find very specific coal sources,
#       however i have chosen to restrict the subsetting to "Coal" only
#

library(ggplot2)

srcFile <- "./data/summarySCC_PM25.rds"
srcData <- "./data/summarySCC_PM25.zip"
sourceClassificationsFile <- "./data/Source_Classification_Code.rds"
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

# open a PNG device
png(file = "plot4.png", width = 480, height = 480, units = 'px')

# open the NEI data source
NEI <- readRDS(srcFile)
SCC <- readRDS(sourceClassificationsFile)

# Find coal combustion relaetd sources, within the EI.Sector variable in the SCC data-set
rowindex <- grep("[cC]oal", SCC$EI.Sector)

# get the SCC codes for Coal related sources.
SCCCodesForCoal <- SCC[rowindex, "SCC"]

# subset the NEI data frame with the relevant SCC codes
coalBasedEmissionsData <- NEI[NEI$SCC %in% SCCCodesForCoal, ]
nrow(coalBasedEmissionsData)

# plot the graph
qplot(year, Emissions, 
      data = coalBasedEmissionsData,
      main = "Emissions from Coal Combusion Related Sources in United States")

# write the file
dev.off()
rm(coalBasedEmissionsData, NEI, SCC)
