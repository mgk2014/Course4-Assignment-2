# plot6.R
# Coursera - course 4, Project 2
# Exploratary Data Analysis
# student: mgk2010
# github URL - insert here...
#
# purpose: create plot 6
#   Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle
#   sources in Los. Which city has seen greater
#   changes over time in motor vehicle emissions?
#
# NOTE = 
#   method to find motor vehicles
#       from p198 of http://www.epa.gov/ttn/chief/net/2011nei/2011_nei_tsdv1_draft2_june2014.pdf
#       SCCs starting with 22010 define the light duty gasoline vehicles including motorcycles, with the exception of 
#       SCCs starting with 220107, which define the heavy duty gasoline vehicles. SCCs starting with 22300 define the 
#       light duty diesel vehicles, with the exception of SCCs starting with 223007 that define the heavy duty diesel 
#       vehicles.
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
png(file = "plot6.png", width = 480, height = 480, units = 'px')

# open the NEI data source and Classification files
NEI <- readRDS(srcFile)
SCC <- readRDS(sourceClassificationsFile)

# All motor vehicles have SCC codes starting with either 22010 or 22300. 
#   Please see notes in the header
#
rowindex <- grep("^22010*", SCC$SCC)
SCCCodes <- as.character(SCC[rowindex, "SCC"])
rowindex <- grep("^22300*", SCC$SCC)
SCCCodes <- c(SCCCodes, as.character(SCC[rowindex, "SCC"]))

# find motor vehicles in Balti and LA
motorVehicleEmissions <- NEI[NEI$SCC %in% SCCCodes, ]
motorVehicleEmissions <- motorVehicleEmissions[motorVehicleEmissions$fips ==  "24510" | 
                motorVehicleEmissions$fips == "06037", c("year", "Emissions", "fips")]

# draw the plot
qplot(year, Emissions, data = motorVehicleEmissions, 
      facets = . ~ fips,
      main = "Vehicle emissions in Los Angeles(06037) and Baltimore(24510)")

# write the file
dev.off()
rm(NEI, SCC, motorVehicleEmissions)
