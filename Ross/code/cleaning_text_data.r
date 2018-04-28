### This program cleans OCR text data on Parliamentary elecion results
### 1832-1885 from Craig (1979). 


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

# Loading tesseract text data 
txtd_tesseract <- extracttxt("~/Dropbox/Misc/lib_project/data-science-fellowship/Ross/data/tesseract_pgm_txt", txtd, "tesseract", "$")

## Loading hathi data 
setwd("~/Dropbox/Misc/lib_project/data-science-fellowship/Ross/data/")
txtd_hathi <- read.table("election_results_hathi.txt", sep = "\n", quote = "")

# Removing unnecessary hathi data 
txtd_hathi <- txtd_hathi[475:21587,]

# Attempting to split the hathi data into pages
txtd_hathi <- as.data.frame(txtd_hathi)
colnames(txtd_hathi) <- c("text")
txtd_hathi$rownum <- 1:nrow(txtd_hathi)
txtd_hathi$text <- as.character(txtd_hathi$text)

txtd_hathi$pg1 <- as.numeric(txtd_hathi$text)

txtd_hathi$pgr <-  (615/21113)*txtd_hathi$rownum 

txtd_hathi$pg2 <- ifelse( (txtd_hathi$pg1 - txtd_hathi$pgr)^2/txtd_hathi$pgr < 6, txtd_hathi$pg1 , NA)

fit <- loess(pg2 ~ pgr, txtd_hathi)
txtd_hathi$pgl <- predict(fit, txtd_hathi) 
txtd_hathi$pg3 <- ifelse((txtd_hathi$pg2-txtd_hathi$pgl)^2 < 35, txtd_hathi$pg2,NA)

# fixing early entries
txtd_hathi$pg3[1:50] <- txtd_hathi$pg1[1:50]
txtd_hathi$pg3[is.na(txtd_hathi$pg3)] <- 0 


txtd_hathi$flag <- 0
for(i in 2:nrow(txtd_hathi)){
  if(txtd_hathi$pg3[i] == 0){
    txtd_hathi$pg3[i] <- txtd_hathi$pg3[i-1]
  }
}

fit2 <- loess(pg3~pgr, txtd_hathi, span =0.1)
txtd_hathi$pgl2 <- predict(fit2, txtd_hathi)
txtd_hathi$pg4 <-ifelse((txtd_hathi$pg3- txtd_hathi$pgl2)^2 > 4, 0, txtd_hathi$pg3)

for(i in 2:nrow(txtd_hathi)){
  if(txtd_hathi$pg4[i] == 0){
    txtd_hathi$pg4[i] <- txtd_hathi$pg4[i-1]
  }
}

txtd_hathi$flag <- 0
for(i in 2:nrow(txtd_hathi)){
  txtd_hathi$flag[i] < as.numeric( (txtd_hathi$pg4[i] - txtd_hathi$pg4[i-1])^2 > 4  )
}

# Since there are no flags raised, we finalize the page number and drop intermediate variables
txtd_hathi$page <- txtd_hathi$

## Loading Adobe data 

  
  


