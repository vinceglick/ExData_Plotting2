#Import necessary libraries
require(ggplot2)

#Import the CSV files
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#Subset the NEI Data Set into sample set
NEI_sampling <- NEI[sample(nrow(NEI), size=5000, replace=F), ]

#Display the Short.Name for examination
levels(SCC$Short.Name)

#combine NEI and SCC data sets using "coal" as the reference value for Emissions
coal <- grep("coal", SCC$Short.Name, ignore.case = T)
coal <- SCC[coal, ]
coal <- NEI[NEI$SCC %in% coal$SCC, ]

#Coal emissions factor by year
coal$year <- factor(coal$year, levels=c('1999', '2002', '2005', '2008'))

#Aggregate Emissions and factor by year
coalEmissions <- aggregate(coal$Emissions, by=list(coal$year), FUN=sum)

#Plot the graph / Export to png in working directory
png(filename='plot4.png', width=800, height=500, units='px')

ggplot(data=coal, aes(x=year, y=log(Emissions))) + facet_grid(. ~ type) + guides(fill=F) +
  geom_boxplot(aes(fill=type)) + stat_boxplot(geom ='errorbar') +
  ylab(expression(paste('Log', ' of PM'[2.5], ' Emissions'))) + xlab('Year') + 
  ggtitle('Emissions From Coal Combustion-related Sources 1999 to 2008') +
  geom_jitter(alpha=0.10)

dev.off()
