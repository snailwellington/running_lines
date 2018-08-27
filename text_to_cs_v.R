
temp = file.choose()
temp2= gsub(".txt","",temp)
  tab = read.delim2(temp, sep=",",fileEncoding="UTF-16LE")
  tab = tab[,-ncol(tab)]

  
  names(tab) <- c("start","end",
                 "I1_min","I1_max",
                 "I2_min","I2_max",
                 "I3_min","I3_max",
                 "U12_min","U12_max",
                 "U23_min","U23_max",
                 "U31_min","U31_max")
  
  write.csv2(tab, paste0(temp2,".csv"), row.names = FALSE)



