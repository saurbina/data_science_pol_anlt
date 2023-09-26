rm(list=ls())
getwd()
setwd('/Volumes/TOSHIBA EXT/1.1_Columbia University/Fall 2023/POLSGU4716_001_2023_3 - Data Science for Political Analytics/data_science_pol_anlt/Classes/')
## read in and transform data set with turnout in presidential election years 1980-2014

library(tidyverse)

## read in data from US Elections Project https://www.electproject.org/election-data

## read in raw data as obtained from web site

library(readxl)

to80_14.df <- read_excel("1980-2014 November General Election orig.xlsx")

## read in csv version of the file

to80_14_csv.df <- read.csv("1980-2014 November General Election.csv")

## check variables in data object

str(to80_14_csv.df)

## read in touched up excel file

to80_14.df <- read_excel("1980-2014 November General Election fixed varnames.xlsx")

## check variables in data object

str(to80_14.df)

## let's keep only a few variables

to80_14_sub.df <- to80_14.df %>% select("State","Year","VEP Highest Office")

## might want to do some clean up

to80_14.df  <- to80_14.df %>% mutate(to_vep = `VEP Highest Office`) %>%
    filter(!is.na(to_vep))

## check to make sure we have 50 states + DC

to80_14.df %>% distinct(State)

## uh oh; need to see more

to80_14.df %>% distinct(State) %>% print(n = 53)

## more clean up: let's drop US 

to80_14.df  <- to80_14.df %>%
    filter(State != "United States" &
           State != "United States (Excl. Louisiana)")

to80_14.df %>% distinct(State) %>% print(n = 53)

## fancier

to80_14_alt.df  <- to80_14.df %>% filter(!str_detect(State,"United"))

identical(to80_14.df,to80_14_alt.df)

## plot time series for NY state

to_ny_80_14.df  <- to80_14.df %>% mutate(state=tolower(State)) %>%
    filter(State=="New York")

ggplot(data = to_ny_80_14.df, aes(x = Year, y = to_vep)) +
  geom_line(color = "#00AFBB") 

## drop midterms

to_ny_potus_80_12.df  <- to_ny_80_14.df %>%
    filter(Year == 1980| Year == 1984 | Year == 1988 | Year == 1992 |
           Year == 1996 | Year == 2000 | Year == 2004 | Year ==
           2008 | Year == 2012 | Year == 2016 | Year == 2020)


## or fancier:

potus_yrs  <- c(1980, 1984, 1988, 1992, 1996, 2000, 2004, 2008, 2012, 2016, 2020)

to_ny_potus_80_12_alt.df  <- to_ny_80_14.df %>% filter(Year %in% potus_yrs)

identical(to_ny_potus_80_12.df,to_ny_potus_80_12_alt.df)

ggplot(data = to_ny_potus_80_12.df, aes(x = Year, y = to_vep)) +
  geom_line(color = "#00AFBB")

## or 

{
    ggplot(data = to_ny_potus_80_12.df, aes(x = Year, y = to_vep)) +
        geom_line(color = "#00AFBB") +
        labs(title="Turnout in presidential elections, New York State 1980-2012", 
    y="% turnout for voting eligible population")
    } %>% ggsave(filename = "turnout_ny_1980_2020.png")


## could also save to a ggplot object and use ggsave with that

## compute mean turnout for whole sample

to80_14.df %>% summarize(mean(to_vep))

## compute mean and std. dev. for each state

to80_14.df %>% group_by(State) %>%
    summarize(mean(to_vep), sd(to_vep)) %>%
    print(n=51)

## produce a panel plot including all states

to_potus_80_12.df  <- to80_14.df %>% filter(Year %in% potus_yrs)

## Nope:

ggplot(data = to_potus_80_12.df, aes(x = Year, y = to_vep)) +
  geom_line(color = "#00AFBB")

## geom_line is just treating this a single time series, connecting
## points for different states in the same year

## one way to do this

ggplot(to_potus_80_12.df,
       mapping = aes(x = Year,
                     y = to_vep)) +
    geom_line(mapping = aes(group = State))

## add color

ggplot(to_potus_80_12.df, aes(x = Year, y = to_vep)) + 
    geom_line(aes(color = State))

## to save png file

{
ggplot(to_potus_80_12.df, aes(x = Year, y = to_vep)) + 
    geom_line(aes(color = State)) +
    labs(title="Turnout in presidential elections, 1980-2012", 
    y="% turnout for voting eligible population")
} %>% ggsave(filename = "turnout_potus_1980_2012.png")


## make distribution plot

to_potus_80_12.df %>% ggplot(aes(x=to_vep)) +
    geom_density()

to_potus_80_12.df %>% drop_na(to_vep) %>% ggplot(aes(x=to_vep)) +
    geom_density() +
    labs(x="Voting Eligible Turnout")
