## zipf holds the downloaded zipped folder
u <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
zipf <- download.file(u, "./data.zip", method = "curl")
unzip("./data.zip")

## Data is sep by ';' and we are reading about 4K rows around that time (staring at 66000)
## Just to extract headers
h <- read.table("./household_power_consumption.txt", header=TRUE, sep=";", nrows=1)
## Extract the data
d <- read.table("./household_power_consumption.txt", header=TRUE, sep=";", skip = 66000, nrows=4000)
colnames(d) <- colnames(h)

## mutate filter desired dates with dplyr package
library(dplyr)
d <- mutate(d, dt = paste(Date, Time, sep=" "))
d$Date <- as.Date(d$Date, format = "%d/%m/%Y")
d <- filter(d, Date >= as.Date("2007-02-01"), Date < as.Date("2007-02-03"))
d$dt <- strptime(d$dt, "%d/%m/%Y %H:%M:%S")

## now the graphs
par(mfrow = c(2,2), mar = c(4,4,2,1), ps = 10)

## Plot 1/1
plot(d$dt, d$Global_active_power, type="n", ylab = "Global Active Power (kilowatts)", xlab = "")
lines(d$dt, d$Global_active_power, type="l")

## Plot 1/2
plot(d$dt, d$Voltage, type="n", ylab = "Voltage", xlab = "datetime")
lines(d$dt, d$Voltage, type="l")

## Plot 2/1
plot(d$dt, d$Sub_metering_1, type="n", ylab = "Energy sub metering", xlab = "")
lines(d$dt, d$Sub_metering_1, type="l")
lines(d$dt, d$Sub_metering_2, type="l", col="red")
lines(d$dt, d$Sub_metering_3, type="l", col="blue")
legend("topright", bty = "n", y.intersp = 0.5, text.width = strwidth("Sub_metering_10"), lty = "solid", col=c("black", "red", "blue"), legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))

## Plot 2/2
plot(d$dt, d$Global_reactive_power, type="n", ylab = "Global_reactive_power", xlab = "datetime")
lines(d$dt, d$Global_reactive_power, type="l")

## Copy to PNG
dev.copy(png, filename="./plot4.png")
## Shutting the PNG device
dev.off()