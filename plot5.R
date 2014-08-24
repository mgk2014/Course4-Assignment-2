# plot5.R
# Coursera - course 4, Project 2
# Exploratary Data Analysis
# student: mgk2010
# github URL - insert here...
#
# purpose: create plot 5
#   How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore
#       City?
#
# NOTE = 
#   method to find motor vehicles
#       from p198 of http://www.epa.gov/ttn/chief/net/2011nei/2011_nei_tsdv1_draft2_june2014.pdf
#       SCCs starting with 22010 define the light duty gasoline vehicles including motorcycles, with the exception of 
#       SCCs starting with 220107, which define the heavy duty gasoline vehicles. SCCs starting with 22300 define the 
#       light duty diesel vehicles, with the exception of SCCs starting with 223007 that define the heavy duty diesel 
#       vehicles.
#   outliers
#       I have removed the last 1% from the motor vehicles data, as it impedes in data visualization
#       I did this by using the quantile function and picked up readins until the 99th percentile only
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
png(file = "plot5.png", width = 480, height = 480, units = 'px')

# open the NEI data source
NEI <- readRDS(srcFile)
SCC <- readRDS(sourceClassificationsFile)

# All motor vehicles have SCC codes starting with either 22010 or 22300. 
#   Please see notes in the header
#
rowindex <- grep("^22010*", SCC$SCC)
SCCCodes <- as.character(SCC[rowindex, "SCC"])
rowindex <- grep("^22300*", SCC$SCC)
SCCCodes <- c(SCCCodes, as.character(SCC[rowindex, "SCC"]))

# find motor vehicles in Balti 
motorVehicleEmissions <- NEI[NEI$SCC %in% SCCCodes & NEI$fips == "24510", ]

# find and remove the outliers - take 99th percentile only. Please see notes in filed header above
q <- quantile(motorVehicleEmissions$Emissions, probs = seq(0,1,0.01))
topPercentile <- q[[100]]

g <- ggplot(motorVehicleEmissions, aes(year, Emissions))
g + geom_point() + geom_smooth(method = "lm") + 
    labs(y = "Emissions (Tons)") + 
    theme_bw(base_family = "Times") +
    coord_cartesian(ylim = c(0,topPercentile)) +   # remove outliers, pls see notes above
    ggtitle(expression(atop("Emission changes in Baltimore for Motor Vehicles", atop(italic("OUTLIERS REMOVED"), ""))))


# write the file
dev.off()
rm(NEI, SCC,motorVehicleEmissions )
