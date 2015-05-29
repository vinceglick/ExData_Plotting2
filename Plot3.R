#Import necessary libraries
require(ggplot2)

#Import the CSV files
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#Subset the NEI Data Set into sample set
NEI_sampling <- NEI[sample(nrow(NEI), size=5000, replace=F), ]

#Subset Emissions by assigned fips and factor by year
MD <- subset(NEI, fips == 24510)
MD$year <- factor(MD$year, levels=c('1999', '2002', '2005', '2008'))


#Aggregate Emissions by year
Emissions <- aggregate(NEI[, 'Emissions'], by=list(NEI$year), FUN=sum)

#Plot the graph / Export to png in working directory
png(filename='plot3.png', width=800, height=500, units='px')

ggplot(data=MD, aes(x=year, y=log(Emissions), color=type)) + guides(fill=F) +
  geom_boxplot(aes(fill=type)) + stat_boxplot(geom ='errorbar') +
  ylab(expression(paste('Log', ' of PM'[2.5], ' Emissions'))) + xlab('Year') + 
  ggtitle('Emissions per Type in Baltimore City, Maryland') + geom_jitter(alpha=0.10)

dev.off()