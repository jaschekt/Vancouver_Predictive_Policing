library(tidyverse)
library(writexl)
library(readxl)

# Here we combine the multiple sheets of the excel file
crime_combined <- read_excel("C:/Users/codyg/Desktop/ML/Machine_Learning/cs540/Project/crime_data_original.xlsx",
																	sheet = "2003")
for(year in 2004:2018){
	y <- toString(year)
next_year <- read_excel("C:/Users/codyg/Desktop/ML/Machine_Learning/cs540/Project/crime_data_original.xlsx",
												sheet = y)
crime_combined <- rbind(crime_combined,next_year)
print(nrow(crime_combined))
}

# Remove all offense against person, Homicide. They don't have any XY data
crime_combined <- subset(crime_combined,crime_combined$TYPE!="Offence Against a Person")
crime_combined <- subset(crime_combined,crime_combined$TYPE!="Homicide")


# Here I convert all Theft types to the same, and all B&E to the same
crime_combined$TYPE[grepl("Theft from",crime_combined$TYPE)]<-"Theft"
crime_combined$TYPE[grepl("Bicycle",crime_combined$TYPE)]<-"Theft"
crime_combined$TYPE[grepl("Other",crime_combined$TYPE)]<-"Theft"
crime_combined$TYPE[grepl("Break",crime_combined$TYPE)]<- "Break and Enter"

# Combine Vehicle collisions
crime_combined$TYPE[grepl("Pedestrian",crime_combined$TYPE)]<-"Vehicle Collision or Pedestrian Hit"

View(crime_combined)

setwd("C:/Users/codyg/Desktop/ML/Machine_Learning/cs540/Project")
unlink("crime_combined.xlsx")
write_xlsx(x = crime_combined, "crime_combined.xlsx", col_names = TRUE)
