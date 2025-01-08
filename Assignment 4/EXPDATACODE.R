library("readr")
library(ggplot2)

expdata = read.table("/Users/andrew/Downloads/UW courses/ECON 607/Assignment 4/expdata.csv", sep=",", header = 1)

exp_num = expdata$Exports/1000


plot(expdata$Year, exp_num)
lines(exp_num)

plot1 = ggplot() +
  geom_line(aes(y = exp_num, x = expdata$Year), data = expdata, color='Red') +
  scale_x_continuous(breaks = seq(2008, 2022, 2)) +
  theme(text=element_text(family = "Tahoma"))

plot1 + labs(title = "Canadian Merchandise Export data",
             x = "Year", y = "Dollars of goods exported in billions", 
             caption = "Graph created in R using data from Statistics Canada 2023")
