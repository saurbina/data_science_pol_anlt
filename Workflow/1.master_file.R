
################################################## Preámbulo #################################################

# Remove objects and clean terminal
cat("\014") 
rm(list = ls())

########################################### Load Packages #####################################################
library("tidyverse")

################################################# Directorios #################################################


# Change the line below to set your own working directory

folder <- "/Volumes/TOSHIBA EXT/1. Colorism revisited/workflow_ta"
dircode     <- paste0(folder,"/code/") 
dirdata 	  <- paste0(folder,"/data/") 
dirresults  <- paste0(folder,"/results/");  dirresults


############################################# Data ################################################# 


# Set working directory
getwd()
setwd(dirdata)
getwd()

mydata <- read.csv("NLSY97.csv")
  

########################################## DATA EXPLORATION ##############################################


# Llama otro R script que contiene análisis. 
# Organizar el trabajo de esta manera permite que el código sea más legible y manejable.


# Establece el directorio de trabajo correspondiente
setwd(dircode)
source("2_Exploration.R")


############################################ RECODIFICATION #################################################


# Establece el directorio de trabajo correspondiente
setwd(dircode)

source("3_recoding.R")


############################################## DATA ANALYSIS #################################################


# Set working directory
setwd(dircode)

source("4_analyses.R")
