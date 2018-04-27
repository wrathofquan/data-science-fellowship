### This program cleans OCR text data on Parliamentary elecion results
### 1832-1885 from Craig (1979). 


# Loading data 
setwd("~/Dropbox/Misc/lib_project/data-science-fellowship/Ross/data/gocr_pgm_txt")

files <- dir() 

# initializing data frame 
txtdata <- read.table("electionresults-024.txt", sep = "\n")
colnames(txtdata) <- "text"
txtdata$page <- as.integer(gsub("[^0-9]","",file))
txtdata$method <- "gocr"
txtdata <- txtdata[-c(1:(nrow(txtdata))),]

# extract
for(file in files){
  text <- read.table(eval(file), sep = "\n")
  colnames(text) <- "text"
  if(nrow(text) > 0){
  text$page <- as.integer(gsub("[^0-9]","",file))
  text$method <- "gocr"
  txtdata <- rbind(txtdata,text)
  rm(text)
  }
}

text <- read.table("electionresults-024.txt", row = 1) 
