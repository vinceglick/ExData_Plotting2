#Import the CSV files
SCC <- readRDS("Source_Classification_Code.rds")
NEI <- readRDS("summarySCC_PM25.rds")

#Subset the NEI Data Set into sample set
NEI_sampling <- NEI[sample(nrow(NEI), size=5000, replace=F), ]

#Subset the Emissions by assigned fips
MD <- subset(NEI, fips=='24510')


#Plot the graph / Export to png in working directory
png(filename='plot2.png')

barplot(tapply(X=MD$Emissions, INDEX=MD$year, FUN=sum), 
        main='Total Emission in Baltimore City, MD', 
        xlab='Year', ylab=expression('PM'[2.5]))

dev.off()