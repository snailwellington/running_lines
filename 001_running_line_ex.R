
library(tidyverse)
library(gifski)




# Select sample dataset ---------------------------------------------------

ds <- read_csv2("fault_wave.csv")
# ## rename the columns
# names(ds) <- c("start","end",
#                "I1_min","I1_max",
#                "I2_min","I2_max",
#                "I3_min","I3_max",
#                "U12_min","U12_max",
#                "U23_min","U23_max",
#                "U31_min","U31_max")

## gather the columns

plot_data <- ds %>% 
  select(1,3:length(ds)) %>% 
  gather(key = "phase", value = measurement, I1_min:U31_max) %>% ## 
  separate(phase, c("phase","meas_type"), sep = "_") %>% ## separating phase and measurement types (min/max)
  spread(key = meas_type, value = measurement) %>% ## spreading min max measurements
  mutate(plot_type = ifelse(str_detect(phase,"I") == TRUE, "current","voltage")) %>% ## separating current and voltage measurements
  group_by(phase) %>% 
  mutate(id = row_number()) ## adding ID-s to not mess with timestamps




# Generate frames for gif -------------------------------------------------

time_1 <- Sys.time()
for (row in 1:nrow(ds)){
# for (row in 1:40){
  
  tmp_plot <- ggplot(data = subset(plot_data,id <= row))+
    facet_grid(plot_type~., scales = "free_y")+
    geom_ribbon(aes(x = id, ymin = min, ymax = max, color = phase), fill = "grey80")+
    geom_point(data = subset(subset(plot_data,id == row)), aes(x = id, y = max),
               color = "grey20", size = 2, alpha = 0.5)+
    scale_x_continuous(limits = c(0, nrow(ds)))+
    theme_minimal()
  
  tmp_row <- row
  
  while (nchar(tmp_row) < 4){
    tmp_row <- paste0("0",tmp_row)
  }
    
  # print(tmp_plot)
  ggsave(filename = paste0("gif_output/image_",tmp_row,".png"), plot = tmp_plot, width = 8, height = 4.5, dpi = 288)
  print(paste0(row,"/",nrow(ds)))
}

time_2 <- Sys.time()
print(time_2-time_1)

# Compile the gif with gifski ---------------------------------------------


image_list <- list.files(path = "gif_output/", pattern = ".png")

gifski::gifski(png_files = paste0("gif_output/",image_list), gif_file = "gif_output.gif", width = 800, height = 450, delay = 0.035)



# Running the script for fixed view ---------------------------------------


time_1 <- Sys.time()
for (row in 1:nrow(ds)){
  # for (row in 1:40){
  
  tmp_plot <- ggplot(data = subset(plot_data,id <= row))+
    facet_grid(plot_type~., scales = "free_y")+
    geom_ribbon(aes(x = id, ymin = min, ymax = max, color = phase), fill = "grey80")+
    geom_point(data = subset(subset(plot_data,id == row)), aes(x = id, y = max),
               color = "grey20", size = 2, alpha = 0.5)+
    scale_x_continuous(limits = c(row-40, row))+
    theme_minimal()
  
  tmp_row <- row
  
  while (nchar(tmp_row) < 4){
    tmp_row <- paste0("0",tmp_row)
  }
  
  # print(tmp_plot)
  ggsave(filename = paste0("gif_output/test/image_",tmp_row,".png"), plot = tmp_plot, width = 8, height = 4.5, dpi = 288)
  print(paste0(row,"/",nrow(ds)))
}

time_2 <- Sys.time()
print(time_2-time_1)
# Compile the gif with gifski ---------------------------------------------


image_list <- list.files(path = "gif_output/test/", pattern = ".png")

gifski::gifski(png_files = paste0("gif_output/test/",image_list), gif_file = "gif_fixed_view.gif", width = 800, height = 450, delay = 0.05)

