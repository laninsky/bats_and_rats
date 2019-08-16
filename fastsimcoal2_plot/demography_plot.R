# Loading in required libraries
library(tidyverse)

# Setting up matrix for data and reading in table1
data <- matrix(ncol=6,nrow=11)

# Skipping first header row
temp <- readLines("bats_rats_table1.txt")[-1]

# Parsing data out into columns
for (i in 1:11) {
  data[i,c(2,5)] <- gsub(",","",unlist(str_split(temp[(i*2-1)],pattern="\t")))
  data[i,c(1,3,4,6)] <- gsub("\\(|\\)|,","",unlist(str_split(temp[(i*2)],pattern="\t| to ")))  
}

data <- as_tibble(data)
data <- data %>% mutate_all(funs(as.numeric))
data
## A tibble: 11 x 6
#V1       V2         V3        V4        V5        V6
#<dbl>    <dbl>      <dbl>     <dbl>     <dbl>     <dbl>
#  1 35779    47963     216001     63152     81382     83653   
#2 46334    69310     170231    115376    128884    134370   
#3  1627     5071      14816      5052    397530    514415   
#4     7     3809      13906         7        48    566207   
#5    72     6332    6881311         6       905      2066   
#6 15027    32921      60483     59866     48085     78452   
#7 82648    99690     164414    108893     78933    155696   
#8     0.11     0.05       0.6       1.63      2.2       2.36
#9     0.09     0.03       0.76      0.92      1.39      1.5 
#310     0        0.2        0.02      0         0         0.07
#11     0        0.14       0.04      0         0         0.16


# Rows in 'data', from top to bottom
#1 N_North
#2 N_South
#3 N_Ancestral_North
#4 N_Ancestral_South
#5 N_Ancestral_Total
#6 Time_to_change_in_migration_rate_and_pop_size (years)
#7 Time_to_North_South_split (years)
#8 Nm from North to South
#9 Nm from South to North
#10 Nm from Ancestral North to Ancestral South
#11 Nm from Ancestral South to Ancestral North

# Columns in 'data', from left to right
# min_rat, rat, max_rat, min_bat, bat, max_bat

# Getting overall coordinates of plot
max_rat_width <- log(max(data[c(1,3),c(1:3)])) + log(max(data[c(2,4),c(1:3)]))
max_bat_width <- log(max(data[c(1,3),c(4:6)])) + log(max(data[c(2,4),c(4:6)]))
max_species <- max(max_bat_width,max_rat_width)
# Adding in some spacing on the plot for axes/migration arrows etc
additional_plot_space <- min(data[1:5,1:6])-1
# Getting total plot width and midpoint for each species
total_plot_width <- max_species + additional_plot_space
rat_plot_center <- 0-total_plot_width/2
bat_plot_center <- 0+total_plot_width/2

# Creacting the rectangle objects to plot
# xmin xmax ymin ymax for maximum boot
rat_contemp_north_max <- unlist(c((rat_plot_center-additional_plot_space/6-log(data[1,3])),(rat_plot_center-additional_plot_space/6),0,data[6,3]))
bat_contemp_north_max <- unlist(c((bat_plot_center-additional_plot_space/6-log(data[1,6])),(bat_plot_center-additional_plot_space/6),0,data[6,6]))

rat_contemp_south_max <- unlist(c((rat_plot_center+additional_plot_space/6),(log(data[2,3])+rat_plot_center+additional_plot_space/6),0,data[6,3]))
bat_contemp_south_max <- unlist(c((bat_plot_center+additional_plot_space/6),(log(data[2,6])+bat_plot_center+additional_plot_space/6),0,data[6,6]))

rat_anc_north_max <- unlist(c((rat_plot_center-additional_plot_space/6-log(data[3,3])),(rat_plot_center-additional_plot_space/6),data[6,3],data[7,3]))
bat_anc_north_max <- unlist(c((bat_plot_center-additional_plot_space/6-log(data[3,6])),(bat_plot_center-additional_plot_space/6),data[6,6],data[7,6]))

rat_anc_south_max <- unlist(c((rat_plot_center+additional_plot_space/6),(log(data[4,3])+rat_plot_center+additional_plot_space/6),data[6,3],data[7,3]))
bat_anc_south_max <- unlist(c((bat_plot_center+additional_plot_space/6),(log(data[4,6])+bat_plot_center+additional_plot_space/6),data[6,6],data[7,6]))

rat_anc_total_max <- unlist(c((rat_plot_center-(log(data[5,3])/2)),(rat_plot_center+(log(data[5,3])/2)),data[7,3],(data[7,3]+25000)))
bat_anc_total_max <- unlist(c((bat_plot_center-(log(data[5,6])/2)),(bat_plot_center+(log(data[5,6])/2)),data[7,6],(data[7,6]+25000)))

# xmin xmin ymin ymin for minimum boot
rat_contemp_north_min <- unlist(c((rat_plot_center-additional_plot_space/6-log(data[1,1])),(rat_plot_center-additional_plot_space/6),0,data[6,1]))
bat_contemp_north_min <- unlist(c((bat_plot_center-additional_plot_space/6-log(data[1,4])),(bat_plot_center-additional_plot_space/6),0,data[6,4]))

rat_contemp_south_min <- unlist(c((rat_plot_center+additional_plot_space/6),(log(data[2,1])+rat_plot_center+additional_plot_space/6),0,data[6,1]))
bat_contemp_south_min <- unlist(c((bat_plot_center+additional_plot_space/6),(log(data[2,4])+bat_plot_center+additional_plot_space/6),0,data[6,4]))

rat_anc_north_min <- unlist(c((rat_plot_center-additional_plot_space/6-log(data[3,1])),(rat_plot_center-additional_plot_space/6),data[6,1],data[7,1]))
bat_anc_north_min <- unlist(c((bat_plot_center-additional_plot_space/6-log(data[3,4])),(bat_plot_center-additional_plot_space/6),data[6,4],data[7,4]))

rat_anc_south_min <- unlist(c((rat_plot_center+additional_plot_space/6),(log(data[4,1])+rat_plot_center+additional_plot_space/6),data[6,1],data[7,1]))
bat_anc_south_min <- unlist(c((bat_plot_center+additional_plot_space/6),(log(data[4,4])+bat_plot_center+additional_plot_space/6),data[6,4],data[7,4]))

rat_anc_total_min <- unlist(c((rat_plot_center-(log(data[5,1])/2)),(rat_plot_center+(log(data[5,1])/2)),data[7,1],(data[7,1]+25000)))
bat_anc_total_min <- unlist(c((bat_plot_center-(log(data[5,4])/2)),(bat_plot_center+(log(data[5,4])/2)),data[7,4],(data[7,4]+25000)))

# xmin xmin ymin ymin for observed
rat_contemp_north_obs <- unlist(c((rat_plot_center-additional_plot_space/6-log(data[1,2])),(rat_plot_center-additional_plot_space/6),0,data[6,2]))
bat_contemp_north_obs <- unlist(c((bat_plot_center-additional_plot_space/6-log(data[1,5])),(bat_plot_center-additional_plot_space/6),0,data[6,5]))

rat_contemp_south_obs <- unlist(c((rat_plot_center+additional_plot_space/6),(log(data[2,2])+rat_plot_center+additional_plot_space/6),0,data[6,2]))
bat_contemp_south_obs <- unlist(c((bat_plot_center+additional_plot_space/6),(log(data[2,5])+bat_plot_center+additional_plot_space/6),0,data[6,5]))

rat_anc_north_obs <- unlist(c((rat_plot_center-additional_plot_space/6-log(data[3,2])),(rat_plot_center-additional_plot_space/6),data[6,2],data[7,2]))
bat_anc_north_obs <- unlist(c((bat_plot_center-additional_plot_space/6-log(data[3,5])),(bat_plot_center-additional_plot_space/6),data[6,5],data[7,5]))

rat_anc_south_obs <- unlist(c((rat_plot_center+additional_plot_space/6),(log(data[4,2])+rat_plot_center+additional_plot_space/6),data[6,2],data[7,2]))
bat_anc_south_obs <- unlist(c((bat_plot_center+additional_plot_space/6),(log(data[4,5])+bat_plot_center+additional_plot_space/6),data[6,5],data[7,5]))

rat_anc_total_obs <- unlist(c((rat_plot_center-(log(data[5,2])/2)),(rat_plot_center+(log(data[5,2])/2)),data[7,2],(data[7,2]+25000)))
bat_anc_total_obs <- unlist(c((bat_plot_center-(log(data[5,5])/2)),(bat_plot_center+(log(data[5,5])/2)),data[7,5],(data[7,5]+25000)))

# Plotting out the rectangles
maximum_boot <- ggplot() + geom_rect(aes(xmin=rat_contemp_north_max[1],xmax=rat_contemp_north_max[2],ymin=rat_contemp_north_max[3],ymax=rat_contemp_north_max[4]),fill="light grey",colour="dark grey",alpha=0.5) + 
  geom_rect(aes(xmin=bat_contemp_north_max[1],xmax=bat_contemp_north_max[2],ymin=bat_contemp_north_max[3],ymax=bat_contemp_north_max[4]),fill="light grey",colour="dark grey",alpha=0.5) + 
  geom_rect(aes(xmin=rat_contemp_south_max[1],xmax=rat_contemp_south_max[2],ymin=rat_contemp_south_max[3],ymax=rat_contemp_south_max[4]),fill="light grey",colour="dark grey",alpha=0.5) + geom_rect(aes(xmin=bat_contemp_south_max[1],xmax=bat_contemp_south_max[2],ymin=bat_contemp_south_max[3],ymax=bat_contemp_south_max[4]),fill="light grey",colour="dark grey",alpha=0.5) + 
  
  geom_rect(aes(xmin=rat_anc_north_max[1],xmax=rat_anc_north_max[2],ymin=rat_anc_north_max[3],ymax=rat_anc_north_max[4]),fill="light grey",colour="dark grey",alpha=0.5) + 
  geom_rect(aes(xmin=bat_anc_north_max[1],xmax=bat_anc_north_max[2],ymin=bat_anc_north_max[3],ymax=bat_anc_north_max[4]),fill="light grey",colour="dark grey",alpha=0.5) +
  
  geom_rect(aes(xmin=rat_anc_south_max[1],xmax=rat_anc_south_max[2],ymin=rat_anc_south_max[3],ymax=rat_anc_south_max[4]),fill="light grey",colour="dark grey",alpha=0.5) + geom_rect(aes(xmin=bat_anc_south_max[1],xmax=bat_anc_south_max[2],ymin=bat_anc_south_max[3],ymax=bat_anc_south_max[4]),fill="light grey",colour="dark grey",alpha=0.5) +
  
  geom_rect(aes(xmin=rat_anc_total_max[1],xmax=rat_anc_total_max[2],ymin=rat_anc_total_max[3],ymax=rat_anc_total_max[4]),fill="light grey",colour="dark grey",alpha=0.5) + geom_rect(aes(xmin=bat_anc_total_max[1],xmax=bat_anc_total_max[2],ymin=bat_anc_total_max[3],ymax=bat_anc_total_max[4]),fill="light grey",colour="dark grey",alpha=0.5) 
min_max_boot <- maximum_boot + geom_rect(aes(xmin=rat_contemp_north_min[1],xmax=rat_contemp_north_min[2],ymin=rat_contemp_north_min[3],ymax=rat_contemp_north_min[4]),fill="light grey",colour="dark grey",alpha=0.5) + 
  geom_rect(aes(xmin=bat_contemp_north_min[1],xmax=bat_contemp_north_min[2],ymin=bat_contemp_north_min[3],ymax=bat_contemp_north_min[4]),fill="light grey",colour="dark grey",alpha=0.5) + 
  geom_rect(aes(xmin=rat_contemp_south_min[1],xmax=rat_contemp_south_min[2],ymin=rat_contemp_south_min[3],ymax=rat_contemp_south_min[4]),fill="light grey",colour="dark grey",alpha=0.5) + geom_rect(aes(xmin=bat_contemp_south_min[1],xmax=bat_contemp_south_min[2],ymin=bat_contemp_south_min[3],ymax=bat_contemp_south_min[4]),fill="light grey",colour="dark grey",alpha=0.5) + 
  
  geom_rect(aes(xmin=rat_anc_north_min[1],xmax=rat_anc_north_min[2],ymin=rat_anc_north_min[3],ymax=rat_anc_north_min[4]),fill="light grey",colour="dark grey",alpha=0.5) + 
  geom_rect(aes(xmin=bat_anc_north_min[1],xmax=bat_anc_north_min[2],ymin=bat_anc_north_min[3],ymax=bat_anc_north_min[4]),fill="light grey",colour="dark grey",alpha=0.5) +
  
  geom_rect(aes(xmin=rat_anc_south_min[1],xmax=rat_anc_south_min[2],ymin=rat_anc_south_min[3],ymax=rat_anc_south_min[4]),fill="light grey",colour="dark grey",alpha=0.5) + geom_rect(aes(xmin=bat_anc_south_min[1],xmax=bat_anc_south_min[2],ymin=bat_anc_south_min[3],ymax=bat_anc_south_min[4]),fill="light grey",colour="dark grey",alpha=0.5) +
  
  geom_rect(aes(xmin=rat_anc_total_min[1],xmax=rat_anc_total_min[2],ymin=rat_anc_total_min[3],ymax=rat_anc_total_min[4]),fill="light grey",colour="dark grey",alpha=0.5) + geom_rect(aes(xmin=bat_anc_total_min[1],xmax=bat_anc_total_min[2],ymin=bat_anc_total_min[3],ymax=bat_anc_total_min[4]),fill="light grey",colour="dark grey",alpha=0.5)

total_data <-  min_max_boot + geom_rect(aes(xmin=rat_contemp_north_obs[1],xmax=rat_contemp_north_obs[2],ymin=rat_contemp_north_obs[3],ymax=rat_contemp_north_obs[4]),colour="black",fill=NA,size=1) + 
  geom_rect(aes(xmin=bat_contemp_north_obs[1],xmax=bat_contemp_north_obs[2],ymin=bat_contemp_north_obs[3],ymax=bat_contemp_north_obs[4]),colour="black",fill=NA,size=1) + 
  geom_rect(aes(xmin=rat_contemp_south_obs[1],xmax=rat_contemp_south_obs[2],ymin=rat_contemp_south_obs[3],ymax=rat_contemp_south_obs[4]),colour="black",fill=NA,size=1) + geom_rect(aes(xmin=bat_contemp_south_obs[1],xmax=bat_contemp_south_obs[2],ymin=bat_contemp_south_obs[3],ymax=bat_contemp_south_obs[4]),colour="black",fill=NA,size=1) + 
  
  geom_rect(aes(xmin=rat_anc_north_obs[1],xmax=rat_anc_north_obs[2],ymin=rat_anc_north_obs[3],ymax=rat_anc_north_obs[4]),colour="black",fill=NA,size=1) + 
  geom_rect(aes(xmin=bat_anc_north_obs[1],xmax=bat_anc_north_obs[2],ymin=bat_anc_north_obs[3],ymax=bat_anc_north_obs[4]),colour="black",fill=NA,size=1) +
  
  geom_rect(aes(xmin=rat_anc_south_obs[1],xmax=rat_anc_south_obs[2],ymin=rat_anc_south_obs[3],ymax=rat_anc_south_obs[4]),colour="black",fill=NA,size=1) + geom_rect(aes(xmin=bat_anc_south_obs[1],xmax=bat_anc_south_obs[2],ymin=bat_anc_south_obs[3],ymax=bat_anc_south_obs[4]),colour="black",fill=NA,size=1) +
  
  geom_rect(aes(xmin=rat_anc_total_obs[1],xmax=rat_anc_total_obs[2],ymin=rat_anc_total_obs[3],ymax=rat_anc_total_obs[4]),colour="black",fill=NA,size=1) + geom_rect(aes(xmin=bat_anc_total_obs[1],xmax=bat_anc_total_obs[2],ymin=bat_anc_total_obs[3],ymax=bat_anc_total_obs[4]),colour="black",fill=NA,size=1)

# Modifying other aesthetics and adding Ne axis labels
Ne_labels <- total_data +
  theme_bw() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) + geom_segment(aes(y=-10000,yend=-10000,xend=(rat_plot_center-additional_plot_space/6), x=(rat_plot_center-additional_plot_space/6-6*log(10)))) + geom_segment(aes(y=-10000,yend=-15000,x=(rat_plot_center-additional_plot_space/6), xend=(rat_plot_center-additional_plot_space/6))) + geom_segment(aes(y=-10000,yend=-12000,x=(rat_plot_center-additional_plot_space/6-log(10)), xend=(rat_plot_center-additional_plot_space/6-log(10)))) + geom_segment(aes(y=-10000,yend=-15000,x=(rat_plot_center-additional_plot_space/6-log(100)), xend=(rat_plot_center-additional_plot_space/6-log(100)))) + geom_segment(aes(y=-10000,yend=-12000,x=(rat_plot_center-additional_plot_space/6-log(1000)), xend=(rat_plot_center-additional_plot_space/6-log(1000)))) + geom_segment(aes(y=-10000,yend=-15000,x=(rat_plot_center-additional_plot_space/6-log(10000)), xend=(rat_plot_center-additional_plot_space/6-log(10000)))) + geom_segment(aes(y=-10000,yend=-12000,x=(rat_plot_center-additional_plot_space/6-log(100000)), xend=(rat_plot_center-additional_plot_space/6-log(100000))))+ geom_segment(aes(y=-10000,yend=-15000,x=(rat_plot_center-additional_plot_space/6-log(1000000)), xend=(rat_plot_center-additional_plot_space/6-log(1000000)))) + geom_text(aes(label = 0,x=(rat_plot_center-additional_plot_space/6),y=-17500)) + geom_text(aes(label = 10,x=(rat_plot_center-additional_plot_space/6-log(10)),y=-13500)) + geom_text(aes(label = 100,x=(rat_plot_center-additional_plot_space/6-log(100)),y=-17500)) + geom_text(aes(label = "1,000",x=(rat_plot_center-additional_plot_space/6-log(1000)),y=-13500)) + geom_text(aes(label = "10,000",x=(rat_plot_center-additional_plot_space/6-log(10000)),y=-17500)) + geom_text(aes(label = "100,000",x=(rat_plot_center-additional_plot_space/6-log(100000)),y=-13500)) + geom_text(aes(label = "1,000,000",x=(rat_plot_center-additional_plot_space/6-log(1000000)),y=-17500))  + geom_segment(aes(y=-10000,yend=-10000,xend=(rat_plot_center+additional_plot_space/6), x=(rat_plot_center+additional_plot_space/6+6*log(10)))) + geom_segment(aes(y=-10000,yend=-15000,x=(rat_plot_center+additional_plot_space/6), xend=(rat_plot_center+additional_plot_space/6))) + geom_segment(aes(y=-10000,yend=-12000,x=(rat_plot_center+additional_plot_space/6+log(10)), xend=(rat_plot_center+additional_plot_space/6+log(10)))) + geom_segment(aes(y=-10000,yend=-15000,x=(rat_plot_center+additional_plot_space/6+log(100)), xend=(rat_plot_center+additional_plot_space/6+log(100)))) + geom_segment(aes(y=-10000,yend=-12000,x=(rat_plot_center+additional_plot_space/6+log(1000)), xend=(rat_plot_center+additional_plot_space/6+log(1000)))) + geom_segment(aes(y=-10000,yend=-15000,x=(rat_plot_center+additional_plot_space/6+log(10000)), xend=(rat_plot_center+additional_plot_space/6+log(10000)))) + geom_segment(aes(y=-10000,yend=-12000,x=(rat_plot_center+additional_plot_space/6+log(100000)), xend=(rat_plot_center+additional_plot_space/6+log(100000))))+ geom_segment(aes(y=-10000,yend=-15000,x=(rat_plot_center+additional_plot_space/6+log(1000000)), xend=(rat_plot_center+additional_plot_space/6+log(1000000)))) + geom_text(aes(label = 0,x=(rat_plot_center+additional_plot_space/6),y=-17500)) + geom_text(aes(label = 10,x=(rat_plot_center+additional_plot_space/6+log(10)),y=-13500)) + geom_text(aes(label = 100,x=(rat_plot_center+additional_plot_space/6+log(100)),y=-17500)) + geom_text(aes(label = "1,000",x=(rat_plot_center+additional_plot_space/6+log(1000)),y=-13500)) + geom_text(aes(label = "10,000",x=(rat_plot_center+additional_plot_space/6+log(10000)),y=-17500)) + geom_text(aes(label = "100,000",x=(rat_plot_center+additional_plot_space/6+log(100000)),y=-13500))

Ne_bat_rat_labels <- Ne_labels + geom_segment(aes(y=-10000,yend=-10000,xend=(bat_plot_center-additional_plot_space/6), x=(bat_plot_center-additional_plot_space/6-6*log(10)))) + geom_segment(aes(y=-10000,yend=-15000,x=(bat_plot_center-additional_plot_space/6), xend=(bat_plot_center-additional_plot_space/6))) + geom_segment(aes(y=-10000,yend=-12000,x=(bat_plot_center-additional_plot_space/6-log(10)), xend=(bat_plot_center-additional_plot_space/6-log(10)))) + geom_segment(aes(y=-10000,yend=-15000,x=(bat_plot_center-additional_plot_space/6-log(100)), xend=(bat_plot_center-additional_plot_space/6-log(100)))) + geom_segment(aes(y=-10000,yend=-12000,x=(bat_plot_center-additional_plot_space/6-log(1000)), xend=(bat_plot_center-additional_plot_space/6-log(1000)))) + geom_segment(aes(y=-10000,yend=-15000,x=(bat_plot_center-additional_plot_space/6-log(10000)), xend=(bat_plot_center-additional_plot_space/6-log(10000)))) + geom_segment(aes(y=-10000,yend=-12000,x=(bat_plot_center-additional_plot_space/6-log(100000)), xend=(bat_plot_center-additional_plot_space/6-log(100000))))+ geom_segment(aes(y=-10000,yend=-15000,x=(bat_plot_center-additional_plot_space/6-log(1000000)), xend=(bat_plot_center-additional_plot_space/6-log(1000000)))) + geom_text(aes(label = 0,x=(bat_plot_center-additional_plot_space/6),y=-17500)) + geom_text(aes(label = 10,x=(bat_plot_center-additional_plot_space/6-log(10)),y=-13500)) + geom_text(aes(label = 100,x=(bat_plot_center-additional_plot_space/6-log(100)),y=-17500)) + geom_text(aes(label = "1,000",x=(bat_plot_center-additional_plot_space/6-log(1000)),y=-13500)) + geom_text(aes(label = "10,000",x=(bat_plot_center-additional_plot_space/6-log(10000)),y=-17500)) + geom_text(aes(label = "100,000",x=(bat_plot_center-additional_plot_space/6-log(100000)),y=-13500)) + geom_text(aes(label = "1,000,000",x=0,y=-17500))  + geom_segment(aes(y=-10000,yend=-10000,xend=(bat_plot_center+additional_plot_space/6), x=(bat_plot_center+additional_plot_space/6+6*log(10)))) + geom_segment(aes(y=-10000,yend=-15000,x=(bat_plot_center+additional_plot_space/6), xend=(bat_plot_center+additional_plot_space/6))) + geom_segment(aes(y=-10000,yend=-12000,x=(bat_plot_center+additional_plot_space/6+log(10)), xend=(bat_plot_center+additional_plot_space/6+log(10)))) + geom_segment(aes(y=-10000,yend=-15000,x=(bat_plot_center+additional_plot_space/6+log(100)), xend=(bat_plot_center+additional_plot_space/6+log(100)))) + geom_segment(aes(y=-10000,yend=-12000,x=(bat_plot_center+additional_plot_space/6+log(1000)), xend=(bat_plot_center+additional_plot_space/6+log(1000)))) + geom_segment(aes(y=-10000,yend=-15000,x=(bat_plot_center+additional_plot_space/6+log(10000)), xend=(bat_plot_center+additional_plot_space/6+log(10000)))) + geom_segment(aes(y=-10000,yend=-12000,x=(bat_plot_center+additional_plot_space/6+log(100000)), xend=(bat_plot_center+additional_plot_space/6+log(100000))))+ geom_segment(aes(y=-10000,yend=-15000,x=(bat_plot_center+additional_plot_space/6+log(1000000)), xend=(bat_plot_center+additional_plot_space/6+log(1000000)))) + geom_text(aes(label = 0,x=(bat_plot_center+additional_plot_space/6),y=-17500)) + geom_text(aes(label = 10,x=(bat_plot_center+additional_plot_space/6+log(10)),y=-13500)) + geom_text(aes(label = 100,x=(bat_plot_center+additional_plot_space/6+log(100)),y=-17500)) + geom_text(aes(label = "1,000",x=(bat_plot_center+additional_plot_space/6+log(1000)),y=-13500)) + geom_text(aes(label = "10,000",x=(bat_plot_center+additional_plot_space/6+log(10000)),y=-17500)) + geom_text(aes(label = "100,000",x=(bat_plot_center+additional_plot_space/6+log(100000)),y=-13500)) + geom_text(aes(label = "1,000,000",x=(bat_plot_center+additional_plot_space/6+log(1000000)),y=-17500))

# Adding the time scale labels
Ne_bat_rat_labels + geom_segment(aes(y=0,yend=175000,x=-1,xend=-1)) + 
  geom_segment(aes(y=0,yend=175000,x=1,xend=1)) +
  geom_segment(aes(y=0,yend=0,x=-1,xend=1)) +
  geom_segment(aes(y=25000,yend=25000,x=-1,xend=1)) +
  geom_segment(aes(y=50000,yend=50000,x=-1,xend=1)) +
  geom_segment(aes(y=75000,yend=75000,x=-1,xend=1)) +
  geom_segment(aes(y=100000,yend=100000,x=-1,xend=1)) +
  geom_segment(aes(y=125000,yend=125000,x=-1,xend=1)) +
  geom_segment(aes(y=150000,yend=150000,x=-1,xend=1)) +
  geom_segment(aes(y=175000,yend=175000,x=-1,xend=1)) +
  geom_label(aes(label=c("0","25","50","75","100","125","150","175"),x=0,y=c(0,25000,50000,75000,100000,125000,150000,175000)),fill="white",label.size=0) +
  theme(axis.line=element_blank(),axis.text.x=element_blank(),
          axis.text.y=element_blank(),axis.ticks=element_blank(),
          axis.title.x=element_blank(),
          axis.title.y=element_blank(),legend.position="none",
        panel.border=element_blank())


# Saving plot - migration arrows and names will be added in powerpoint/photoshop
ggsave("Figure_3_redo.pdf",width = 15.77, height = 7.63, units = c("in"))




