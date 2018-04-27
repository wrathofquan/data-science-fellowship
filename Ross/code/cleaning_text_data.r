### This program cleans OCR text data on Parliamentary elecion results
### 1832-1885 from Craig (1979). 


# Loading data 
setwd("~/Dropbox/Misc/lib_project/data-science-fellowship/Ross/data/gocr_pgm_txt")

files <- dir() 

for(file in files){
  text <- read.table("electionresults-024.txt", row = 1)
  colnames(text) <- "text"
  text$page <- 
  text$method <- "gocr"
}

text <- read.table("electionresults-024.txt", row = 1) 
