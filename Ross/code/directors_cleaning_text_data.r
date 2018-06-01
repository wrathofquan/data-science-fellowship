### This program loads OCR text data for cleaning
### for the directory of bank directors 

require(dplyr)

## Loading data 

# initializing data frame 
setwd("~/Dropbox/Misc/lib_project/individual PDFs/1900_adobe_txt")
files <- dir() 

con = file("directors_1900v1_blank_100.pdf.txt", "r")
con %>% 
  readLines() %>% 
  as.data.frame() -> txtd

colnames(txtd) <- "text"- 
page1 <- gsub("\\.pdf\\.txt","","directors_1900v1_blank_100.pdf.txt")
txtd$page <- as.integer(gsub("^.......................", "",page1 ))
txtd$method <- "adobe"
txtd$year <- "1900"

# Removing data 
txtd <- txtd[-(1:nrow(txtd)),]

# function for extracting text from txt files, preserving meta-data 
extracttxt <- function(directory,txtd,method,year){ 
  setwd(directory)
  files <- dir() 
  for(f in files){
    print(f)
    con = file(f, "r")
    con %>% 
      readLines() %>% 
      as.data.frame() -> text
    colnames(text) <- "text"
    if(nrow(text) > 0){
      page1 <- gsub("\\.pdf\\.txt","",f)
      text$page <- as.integer(gsub("^.......................", "",page1 ))
      text$method <- method
      text$year <- year
      txtd <- rbind(txtd,text)
    }
  }
  rm(directory)
  rm(files)
  rm(file)
  rm(text)
  return(txtd)
}

# Loading adobe text data 
txtd_adobe_1899 <- extracttxt("~/Dropbox/Misc/lib_project/individual PDFs/1899_adobe_txt", txtd, "adobe", 1899)
txtd_adobe_1901 <- extracttxt("~/Dropbox/Misc/lib_project/individual PDFs/1901_adobe_txt", txtd, "adobe", 1901)
txtd_adobe_1903 <- extracttxt("~/Dropbox/Misc/lib_project/individual PDFs/1903_adobe_txt", txtd, "adobe", 1903)

# Loading Hathi text data
txtd_hathi_1899 <- extracttxt("~/Dropbox/Misc/lib_project/individual PDFs/1899_hathi_txt", txtd, "hathi", 1899)
txtd_hathi_1901 <- extracttxt("~/Dropbox/Misc/lib_project/individual PDFs/1901_hathi_txt", txtd, "hathi", 1901)
txtd_hathi_1903 <- extracttxt("~/Dropbox/Misc/lib_project/individual PDFs/1903_hathi_txt", txtd, "hathi", 1903)

# Saving data for further cleaning
setwd("~/Dropbox/Misc/lib_project/data-science-fellowship/Ross/data")
write.csv(txtd_adobe_1899, "txt_adobe_1899.csv")
write.csv(txtd_adobe_1901, "txt_adobe_1901.csv")
write.csv(txtd_adobe_1903, "txt_adobe_1903.csv")
write.csv(txtd_hathi_1899, "txt_hathi_1899.csv")
write.csv(txtd_hathi_1901, "txt_hathi_1901.csv")
write.csv(txtd_hathi_1903, "txt_hathi_1903.csv")


