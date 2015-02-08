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

d$Date <- as.Date(d$Date, "%d/%m/%Y")

## now the histogram
hist(d$Global_active_power, main="Global Active Power", xlab = "Global Active Power (kilowatts)", ylab = "Frequency", col="red")

## Copy to PNG
dev.copy(png, filename="./plot1.png")
## Shutting the PNG device
dev.off()