library(tidyverse)
library(writexl)
library(readxl)

setwd("C:/Users/codyg/Desktop/ML/Machine_Learning/cs540/Project")

# Import data
crime_combined <- read_excel("crime_combined.xlsx")

# Create Factors and check to see if the structure is proper
crime_combined$TYPE <- factor(crime_combined$TYPE )
summary(crime_combined)

# Histogram of Type of crime over each year, exclude 2018
png(file="type_vs_year.png",height = 477,width = 722)
crime_combined %>% 
	filter(YEAR!=2018) %>% 
	ggplot(aes(YEAR))+
		scale_x_discrete(limits=c(2003,2008,2013,2017))+
		facet_wrap(~ TYPE, scales ="free")+
		geom_histogram(fill=heat.colors(1),color="black",bins=14)+
	theme_bw()+
	theme(axis.title.x=element_text(face="bold",size = 15),
				axis.title.y = element_blank(),
				axis.text.y = element_blank(),
				axis.ticks.y = element_blank())
dev.off()
# Notice here that there is a spike in almost all types of crime for 2008
# and following that an steady decrease in most until another rise in 2013

# Histogram of Type of crime over each month for all years
png(file="type_vs_month.png",height = 477,width = 722)
ggplot(crime_combined,aes(MONTH))+
	facet_wrap(~TYPE,scales="free")+
	scale_x_discrete(limits=1:12)+
	geom_histogram(fill=topo.colors(1),color="black",bins=12)+
	theme_bw()+
	theme(axis.title.x=element_text(face="bold",size = 15),
				axis.title.y = element_blank(),
				axis.text.y = element_blank(),
				axis.ticks.y = element_blank())
dev.off()
# Not much can be said here, which makes this perfect for a HMM. There isn't anything
# I can extract as all types seem to be near constant for each year.
# A hypothesis test should be done here to confirm.

#Histogram of Type of crime aginst each day,
png(file="type_vs_day.png",height = 477,width = 722)
crime_combined %>% 
	ggplot(aes(DAY))+
	facet_wrap(~TYPE,scales="free")+
	geom_histogram(fill="green3",color="black",bins=31)+
	theme_bw()+
	theme(axis.title.x=element_text(face="bold",size = 15),
				axis.title.y = element_blank(),
				axis.text.y = element_blank(),
				axis.ticks.y = element_blank())
dev.off()
# Clearly day 31 doesn't happen for ever month so it is noticably lower in count
# Theft is the majority of crime, and it seems there is a spike of crime at the beginning
# and middle of the month.

# Histogram of Type of crime vs Hour
png(file="type_vs_hour.png",height = 477,width = 722)
crime_combined %>% 
	ggplot(aes(HOUR))+
	scale_x_discrete(limits=c(0,6,12,18,24))+
	facet_wrap(~TYPE,scales="free")+
	geom_histogram(color="black",bins=24)+
	theme_bw()+
	theme(axis.title.x=element_text(face="bold",size = 15),
				axis.title.y = element_blank(),
				axis.text.y = element_blank(),
				axis.ticks.y = element_blank())
dev.off()





# Plot the frequency and density curves respectively
crime_combined %>% 
	filter(YEAR!=2018) %>% 
	ggplot(aes(DAY))+
		facet_wrap(~TYPE,scales="free")+
		geom_freqpoly(bins=31,color="red")+
		theme_bw()

crime_combined %>% 
	filter(YEAR!=2018) %>% 
	ggplot(aes(DAY))+
		facet_wrap(~TYPE,scales="free")+
		geom_density(color="red")+
		theme_bw()


	