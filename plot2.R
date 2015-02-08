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

## now the line graph
plot(d$dt, d$Global_active_power, type="n", ylab = "Global Active Power (kilowatts)", xlab = "")
lines(d$dt, d$Global_active_power, type="l")

## Copy to PNG
dev.copy(png, filename="./plot2.png")
## Shutting the PNG device
dev.off()