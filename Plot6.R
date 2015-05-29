#Import necessary libraries
require(ggplot2)

#Import the CSV files
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#Subset the NEI Data Set using the assigned fips
NEI_BCLA <- NEI[NEI$fips=="24510"| NEI$fips=="06037",]

#Combine NEI and SCC data sets using "Mobile" as the reference value for Emissions;
#"Mobile" refers to ALL motor powered vehicles in the data
motorVehicles2 <- grep("Mobile", SCC$EI.Sector, ignore.case = T)
motorVehicles2 <- SCC[motorVehicles2,]
motorVehicles2 <- NEI_BCLA[NEI_BCLA$SCC %in% motorVehicles2$SCC, ]

#motorVehicles2 emissions factor by year
motorVehicles2$year <- factor(motorVehicles2$year, levels=c('1999', '2002', '2005', '2008'))

#Aggregate Emissions and factor by year
Emissions <- aggregate(NEI[, 'Emissions'], by=list(NEI$year), FUN=sum)

#Plot the graph / Export to png in working directory
png(filename='plot6.png', width=1500, height=1000, units='px')

ggplot(data=motorVehicles2, aes(x=year, y=log(Emissions), color=fips)) + guides(fill=F) +
  geom_boxplot(aes(fill=fips)) + stat_boxplot(geom ='errorbar') +
  ylab(expression(paste('Log', ' of PM'[2.5], ' Emissions'))) + xlab('Year') + 
  ggtitle('Baltimore & LA Emissions From Motor Vehicle Sources 1999 to 2008') +
  scale_colour_discrete(name = "City", label = c("LA","Baltimore"))
  

dev.off()