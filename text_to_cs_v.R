# library(xlsx)
# setwd("//energia.sise/dfs/REDIRECT/tarmo.rahmonen/Documents/Pingekvaliteet/P?ringud")
temp = file.choose()
# 
# for (i in 1:length(temp)){
  temp2= gsub(".txt","",temp)
  tab = read.delim2(temp, sep=",",fileEncoding="UTF-16LE")
  tab = tab[,-ncol(tab)]
  # setwd("C:/Users/tarmo.rahmonen/ISIKLIK")
  write.csv2(tab, paste0(temp2,".csv"), row.names = FALSE)
  
  # write.xlsx(tab, paste0(temp2[i],"_1",".xlsx"),sheetName = "Data")

# }




