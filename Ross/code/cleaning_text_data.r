### This program loads OCR text data for cleaning
### of Parliamentary elecion results 1832-1885, Craig (1979). 

## Loading data 

# initializing data frame 
setwd("~/Dropbox/Misc/lib_project/data-science-fellowship/Ross/data/gocr_pgm_txt")
files <- dir() 
txtd <- read.table("electionresults-024.txt", sep = "\n")
colnames(txtd) <- "text"
txtd$page <- as.integer(gsub("[^0-9]","",file))
txtd$method <- "gocr"
txtd <- txtd[-c(1:(nrow(txtd))),]

# function for extracting text from txt files, preserving meta-data 
extracttxt <- function(directory,txtd,method, delim){ 
  setwd(directory)
  files <- dir() 
  for(file in files){
    print(file)
    text <- read.table(eval(file), quote = "", sep = delim, row.names = NULL)
    colnames(text) <- "text"
    if(nrow(text) > 0){
    text$page <- as.integer(gsub("[^0-9]","",file))
    text$method <- method
    txtd <- rbind(txtd,text)
    }
  }
  rm(directory)
  rm(files)
  rm(file)
  rm(text)
  return(txtd)
}

# Loading gocr text data 
txtd_gocr <- extracttxt("~/Dropbox/Misc/lib_project/data-science-fellowship/Ross/data/gocr_pgm_txt", txtd, "gocr", "\n")

# Loading ocrad text data
txtd_ocrad <- extracttxt("~/Dropbox/Misc/lib_project/data-science-fellowship/Ross/data/ocrad_pgm_txt", txtd, "ocrad", "\n")

# Loading adobe text data 
txtd_adobe <- extracttxt("~/Dropbox/Misc/lib_project/data-science-fellowship/Ross/data/adobe_txt", txtd, "adobe", "\n")

# Loading hathi text data
txtd_hathi <- extracttxt("~/Dropbox/Misc/lib_project/data-science-fellowship/Ross/data/hathi_txt", txtd, "hathi", "\n")

# Loading tesseract text data 
txtd_tesseract <- extracttxt("~/Dropbox/Misc/lib_project/data-science-fellowship/Ross/data/tesseract_pgm_txt", txtd, "tesseract", "$")
