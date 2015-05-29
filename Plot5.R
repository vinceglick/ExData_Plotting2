#Import necessary libraries
require(ggplot2)

#Import the CSV files
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#Subset the NEI Data Set using the assigned fips
NEI_BC <- NEI[NEI$fips=="24510",]

#combine NEI and SCC data sets using "Mobile" as the reference value for Emissions
motorVehicles <- grep("Mobile", SCC$EI.Sector, ignore.case = T)
motorVehicles <- SCC[motorVehicles,]
motorVehicles <- NEI_BC[NEI_BC$SCC %in% motorVehicles$SCC, ]
motorVehicles <- NEI[NEI$SCC %in% motorVehicles$SCC, ]

#motorVehicles emissions factor by year
motorVehicles$year <- factor(motorVehicles$year, levels=c('1999', '2002', '2005', '2008'))

#Aggregate Emissions and factor by year
Emissions <- aggregate(NEI[, 'Emissions'], by=list(NEI$year), FUN=sum)

#Plot the graph / Export to png in working directory
png(filename='plot5.png', width=1500, height=1000, units='px')

ggplot(data=motorVehicles, aes(x=year, y=log(Emissions), color=type)) + guides(fill=F) +
  geom_boxplot(aes(fill=type)) + stat_boxplot(geom ='errorbar') +
  ylab(expression(paste('Log', ' of PM'[2.5], ' Emissions'))) + xlab('Year') + 
  ggtitle('Baltimore Emissions From Motor Vehicle Sources 1999 to 2008') 


dev.off()