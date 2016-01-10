# Script for reading data and generating plots for Coursera: Exploratory Data Analysis Week1 project

# Set up directories and read data
# rm(list = ls())

localWorkingDirectory <- getwd()
dataURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
dataDir <- paste(localWorkingDirectory, "/hpc/", sep = "")
if (!file.exists(dataDir)) dir.create(dataDir) 
zipfilename <-  paste(dataDir, "hpcdata.zip", sep = "")
download.file(dataURL, zipfilename)

# Get file name of compressed file

datafilename <- unzip(zipfilename, list = TRUE)$Name

# Un-zip compressed file in dataDir

unzip(zipfilename, exdir = dataDir, unzip = "internal")

# Read household_power_consumption data

filename <- paste(dataDir, datafilename, sep = "")

colNames <-names(read.table(filename, nrow = 1, header = TRUE, sep = ";"))

# Identify first row to be read "first" and the number of rows to be read "ndata"

first <- grep("1/2/2007", readLines(filename))[1]
last <- grep("3/2/2007", readLines(filename))[1]
ndata <- last - first
hpcdata <- read.table(filename, header = FALSE, na.strings = "?", col.names = colNames,
                      sep = ";", skip = first-1, nrow = ndata)

# Convert Date and Time variables to POSIXlt variable datetime.

hpcdata$datetime <- strptime(paste(as.character(hpcdata$Date), as.character(hpcdata$Time)), "%d/%m/%Y %H:%M:%S")

# Plot4

png(filename = "plot4.png", height = 480, width = 480)
par(mfrow = c(2,2))
with(hpcdata, plot(datetime, Global_active_power, type = "l", ylab = "Global Active Power", xlab = ""))

with(hpcdata, plot(datetime, Voltage, type = "l"))

with(hpcdata, plot(datetime, Sub_metering_1, type = "l", ylab = "Energy sub metering", xlab = ""))
with(hpcdata, lines(datetime, Sub_metering_2, col = "red"))
with(hpcdata, lines(datetime, Sub_metering_3, col = "blue"))
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty = 1, col = c("black", "red", "blue"), bty = "n", cex = 0.8)

with(hpcdata, plot(datetime, Global_reactive_power, type = "l"))

dev.off()

# Remove directory and files created by Plot4.R

file.remove(zipfilename)
file.remove(filename)
# unlink(dataDir)

# Remove variables created by Plot4.R

rm("colNames", "dataDir", "datafilename", "dataURL", "filename", "first", "hpcdata", "last",
   "localWorkingDirectory", "ndata", "zipfilename")