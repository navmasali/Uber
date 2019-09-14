#Install and load the required packages
install.packages("lubridate")
install.packages("stringr")
install.packages("ggplot2")
install.packages("gridExtra")
library(stringr)
library(lubridate)
library(ggplot2)
library(gridExtra)

#Import the Uber data set

uber_requests <- read.csv("Uber Request Data.csv", stringsAsFactors = F)

#Exmaine the structure of the data frame

str(uber_requests)

#Clean the Request and drop timestamp columns
uber_requests$Request.timestamp <- parse_date_time(uber_requests$Request.timestamp, orders = c("d/m/y H:M", "d-m-y H:M:S"), locale = "eng")

uber_requests$Drop.timestamp <- parse_date_time(uber_requests$Drop.timestamp, orders = c("d/m/y H:M", "d-m-y H:M:S"), locale = "eng")


#Converting the columns Pickup point, Status, driver id to factors

uber_requests$Status <- factor(uber_requests$Status)
uber_requests$Pickup.point <- factor(uber_requests$Pickup.point)
uber_requests$Driver.id <- factor(uber_requests$Driver.id)

#Deriving the columns hour and min from the request and drop timestamp columns
uber_requests$Request.hour <- format(uber_requests$Request.timestamp,"%H")
uber_requests$Request.min <- format(uber_requests$Request.timestamp, "%M")
uber_requests$Drop.hour <- format(uber_requests$Drop.timestamp, "%H")
uber_requests$Drop.min <- format(uber_requests$Drop.timestamp, "%M")



#Plots to visualize the cab requests in segmented analysis.
#Plot is segmented on Pickup points ie. Airport and City and then 
#segmented on Status of the trip ie. Cancelled, no cabs available, trip completed
# Thus illustrating bivariate segmented analysis.

airport_plot <- ggplot(subset(uber_requests,uber_requests$Pickup.point == "Airport"), aes(Request.hour, fill=Status)) + geom_bar() + ylim(0,600)
airport_plot <- airport_plot + labs(title ="From Airport", x = "Hours of the day", y = "No. of cab requests")
airport_plot

city_plot    <- ggplot(subset(uber_requests,uber_requests$Pickup.point == "City"), aes(Request.hour, fill=Status)) + geom_bar() + ylim(0,600)
city_plot <- city_plot + labs(title = "From City" ,x = "Hours of the day", y = "No. of cab requests")
city_plot

grid.arrange(airport_plot, city_plot, nrow = 2)

#Bar plots are chosen for visualization because they clearly show the numbers,
# and aesthetics with 'Hours of the day' on x axis
# and filled by "status of the trip" which clearly illustrates 
# how many rides were cancelled, no cabs available, trip completed.

#Writing the csv to import into tableau
write.csv(uber_requests, "uber_requests.csv")
