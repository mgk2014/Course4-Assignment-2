# plot3.R
# Coursera - course 4, Project 2
# Exploratary Data Analysis
# student: mgk2010
# github URL - insert here...
#
# purpose: create plot 3
#   Plot the growth/decline of types of Emissions in Baltimore city
#
# method = There are a few outliers in Balti that skew the results, means towards higher ends 
#       and affect the interpretation of the data
#       I have removed all emissions > 100, as these represent ~ 1% of the total data in balti
#
library(ggplot2)

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
png(file = "plot3.png", width = 640, height = 640, units = 'px')


# open the NEI data source
NEI <- readRDS(srcFile)

# subet to get data for Baltimore city only
balti <- NEI[NEI$fips == "24510", ]

g <- ggplot(balti, aes(year, Emissions))
g + geom_point() + geom_smooth(method = "lm") + 
    facet_grid(. ~ type) + 
    coord_cartesian(ylim = c(-1,100)) +   # remove outliers, pls see notes above
    labs(y = "Emissions (Tons)") + 
    theme_bw(base_family = "Times") +
    ggtitle(expression(atop("Emission changes in Baltimore by Type of Source", atop(italic("OUTLIERS REMOVED"), ""))))

# write the file
dev.off()
rm(NEI, balti)


