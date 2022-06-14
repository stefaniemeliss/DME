# this r script summarises the behavioural analysis and creates the plots for the publication

##################################################################  
############################ set ups  ############################ 
##################################################################  

# clear workspace
rm(list = ls())

# load libraries and functions
library(ggplot2)
library(psych)
library(reshape2)
library(dplyr)
library(lme4)
library(lmerTest)
library(car)
library(lsmeans)
source("anovakun_482.txt") # anovakun package retrieved from http://riseki.php.xdomain.jp/index.php?ANOVA君%2FANOVA君の使い方

# read in data set
df <- read.csv("data.csv")

##################################################################################
############################ behavioural assessments  ############################ 
##################################################################################

# POST QUESTIONS ASKED AT THE END OF THE EXPERIMENT

# intrinsic motivation after the scanning
# post1.	It was fun to do the easy task
# post2.	It was boring to do the easy task (reversely coded)
# post3.	It was enjoyable to do the easy task
# post4.	It was fun to do the moderately difficult task
# post5.	It was boring to do the moderately difficult task (reversely coded)
# post6.	It was enjoyable to do the moderately difficult task
# post7.	It was fun to do the very difficult task
# post8.	It was boring to do the very difficult task (reversely coded)
# post9.	It was enjoyable to do the very difficult task
# post10.	It was fun to do the watchstop task
# post11.	It was boring to do the watchstop task (reversely coded)
# post12.	It was enjoyable to do the watchstop task

# calculate the score of intrinsic motivation for each level of chance of success
# df$mot_high <- (8 + df$post1 - df$post2 + df$post3)/3 # high chance of success
# df$mot_mod <- (8 + df$post4 - df$post5 + df$post6)/3 # moderate chance of success
# df$mot_low <- (8 + df$post7 - df$post8 + df$post9)/3 # extremely-low chance of success
# df$mot_ws <- (8 + df$post10 - df$post11 + df$post12)/3 # watch stop

# calculate Cronbach's alpha for the items for capturing intrinsic motivation for each level of success
mot_high <- df[,c("post1", "post2", "post3")] # high chance of success
psych::alpha(mot_high, keys = "post2") # post2 reversely coded
mot_mod <- df[,c("post4", "post5", "post6")] # moderate chance of success
psych::alpha(mot_mod, keys = "post5") # post5 reversely coded
mot_low <- df[,c("post7", "post8", "post9")] # extremely-low chance of success
psych::alpha(mot_low, keys = "post8") # post8 reversely coded
mot_ws <- df[,c("post10", "post11", "post12")] # watch stop
psych::alpha(mot_ws, keys = "post11") # post11 reversely coded

# post happiness
#post21.	I felt happy when I see the cue of the easy task
#post23.	I felt happy when I see the cue of the moderately difficult task
#post25.	I felt happy when I see the cue of the very difficult task
#post27   I felt happy when I see the cue of the watchstop task

# post dissappointment
#post22.	I got dissappointed when I see the cue of the easy task
#post24.	I got dissappointed when I see the cue of the moderately difficult task
#post26.	I got dissappointed when I see the cue of the very difficult task
#post28.	I got dissappointed when I see the cue of the watchstop task

# calculate rewarding value: recode disappointment items and combine them with happiness
# df$post22_r <- car::recode(df$post22, "1=7; 2=6; 3=5; 4=4; 5=3; 6=2; 7=1" )
# df$post24_r <- car::recode(df$post24, "1=7; 2=6; 3=5; 4=4; 5=3; 6=2; 7=1" )
# df$post26_r <- car::recode(df$post26, "1=7; 2=6; 3=5; 4=4; 5=3; 6=2; 7=1" )
# df$post28_r <- car::recode(df$post28, "1=7; 2=6; 3=5; 4=4; 5=3; 6=2; 7=1" )

# calculate the correlations between the items
cor(df$post21, df$post22_r) # extremely-low chance of success
cor(df$post23, df$post24_r) # moderate chance of success
cor(df$post25, df$post26_r) # high chance of success
cor(df$post27, df$post28_r) # watch stop

# calculate the score of reward value for each level of chance of success
# df$val_high <- (df$post21 + df$post22_r)/2 # high chance of success
# df$val_mod <- (df$post23 + df$post24_r)/2 # moderate chance of success
# df$val_low <- (df$post25 + df$post26_r)/2 # extremely-low chance of success
# df$val_ws <- (df$post27 + df$post28_r)/2 # watch stop

######################################################################   
########################## CONTRAST ESTIMATES ######################## 
######################################################################   

# the contrast estimates come from the 2017_DME/GLM/GLM1/2nd-level/ANOVA/TwoWay/SWWS_/SPM.mat file
# ROIs created in marsbar (Build ROI --> point coordinate --> peak voxel [-8 6 -8] and [10 6 -8]
# ./voxel_left_peak_-8_6_-8_roi.mat & ./voxel_right_peak_10_6_-10_roi.mat

# df$left_low: extremely-low chance of success (left peak)
# df$left_mod: moderate chance of success (left peak)
# df$left_high: high chance of success (left peak)

# df$right_low: extremely-low chance of success (right peak)
# df$right_mod: moderate chance of success (right peak)
# df$right_high: high chance of success (right peak)

#######################################################################
########################## 3  x 3  MIXED ANOVA ######################## 
#######################################################################

# between factor group: no-reward, reward, or gambling
# within-factor chance of success: high chance, moderate chance, or extremely-low chance

# DEPENDENT VARIABLE 1: ratings of intrinsic motivation #
# create data frame in long format
df_mot <- melt(df, id.vars = c("id", "cond"), measure.vars = c("mot_low", "mot_mod", "mot_high") )
names(df_mot) <- c("id", "cond", "measurement", "rating")
df_mot$chance_success <- ifelse(df_mot$measurement == "mot_low", "extremely-low",
                               ifelse(df_mot$measurement == "mot_mod", "moderate",
                                      ifelse(df_mot$measurement == "mot_high", "high",NA)))
df_mot$linear <- ifelse(df_mot$measurement == "mot_low", "-1",
                                ifelse(df_mot$measurement == "mot_mod", "0",
                                       ifelse(df_mot$measurement == "mot_high", "1",NA)))
df_mot$quadratic <- ifelse(df_mot$measurement == "mot_low", "-1",
                        ifelse(df_mot$measurement == "mot_mod", "2",
                               ifelse(df_mot$measurement == "mot_high", "-1",NA)))

# specify anovakun
anovakun_mot <- df_mot
anovakun_mot <- anovakun_mot[,c("id", "cond", "chance_success", "rating")]
anovakun(anovakun_mot, "AsB", 3, 3, long = T, geta = T)



# DEPENDENT VARIABLE 2: ratings of rewarding value #
# create data frame in long format
df_val <- melt(df, id.vars = c("id", "cond"), measure.vars = c("val_low", "val_mod", "val_high") )
names(df_val) <- c("id", "cond", "measurement", "rating")
df_val$chance_success <- ifelse(df_val$measurement == "val_low", "extremely-low",
                                ifelse(df_val$measurement == "val_mod", "moderate",
                                       ifelse(df_val$measurement == "val_high", "high",NA)))
# specify anovakun
anovakun_val <- df_val
anovakun_val <- anovakun_val[,c("id", "cond", "chance_success", "rating")]
anovakun(anovakun_val, "AsB", 3, 3, long = T, geta = T)



########################################################################
############################ Trend Analysis ############################ 
########################################################################

# DEPENDENT VARIABLE 1: ratings of intrinsic motivation #
# compute mean of intrinsic motivation for each group for each level of chance of success
df_mot %>% 
  group_by(cond, chance_success) %>% 
  summarise_all(mean)
# compute mean of intrinsic motivation for all groups for each level of chance of success
tapply(df_mot$rating, df_mot$chance_success, mean)

# define variable contrast: 
# examining the orthogonal linear and the quadratic effects of chance of success for each group. 
df_mot$contrast <- 
  # no-reward group: resulting in a decrease in intrinsic motivation as chance of success increases
  ifelse(df_mot$cond == "No-reward" & df_mot$chance_success == "extremely-low", 1,
         ifelse(df_mot$cond == "No-reward" & df_mot$chance_success == "moderate", 0,
                ifelse(df_mot$cond == "No-reward" & df_mot$chance_success == "high", -1, 
                       # reward group: resulting in a quadratic relationship between intrinsic motivation and chance of success
                       ifelse(df_mot$cond == "Reward" & df_mot$chance_success == "extremely-low", -1,
                              ifelse(df_mot$cond == "Reward" & df_mot$chance_success == "moderate", 2,
                                     ifelse(df_mot$cond == "Reward" & df_mot$chance_success == "high", -1, 
                                            # resulting in an increase in intrinsic motivation as chance of success increases in gambling group
                                            ifelse(df_mot$cond == "Gambling" & df_mot$chance_success == "extremely-low", -1,
                                                   ifelse(df_mot$cond == "Gambling" & df_mot$chance_success == "moderate", 0,
                                                          ifelse(df_mot$cond == "Gambling" & df_mot$chance_success == "high", 1, NA 
                                                          )))))))))

# compute LME with the defined contrast as predictor for intrinsic motivation across all groups
trend_mot <- lmer(rating ~ 1 + contrast + (1 + contrast | id), data = df_mot, REML = F)
summary(trend_mot)

# specify aov_car whole sample
aovcar_mot <- afex::aov_car(rating ~ cond*measurement + Error(id / measurement), data = df_mot) # specify model
aovcar_mot
lsm_mot <- lsmeans(aovcar_mot, specs = ~ cond*measurement) # get mean values per measurement and group
lsm_mot
# look at contrast: gambling-low=-1, control-low=1, reward-low=-1; gambling-mod=0, control-mod=0, reward-mod=2; gambling-high=1, control-high=-1, reward-high=-1
contrast(lsm_mot, list(mycon = c(-1,1,-1,0,0,2,1,-1,-1))) 


# specify the aov_car and test for polynomial contrasts for each group
# no-reward
df_mot_c <- subset(df_mot, df_mot$cond == "No-reward") # subset data
aovcar_mot_c <- afex::aov_car(rating ~ measurement + Error(id / measurement), data = df_mot_c) # specify model
aovcar_mot_c
lsm_mot_c <- lsmeans(aovcar_mot_c, specs = ~ measurement) # get mean values per measurement
contrast(lsm_mot_c, "poly") # look at polynomial contrasts
# reward
df_mot_r <- subset(df_mot, df_mot$cond == "Reward") # subset data
aovcar_mot_r <- afex::aov_car(rating ~ measurement + Error(id / measurement), data = df_mot_r) # specify model
aovcar_mot_r
lsm_mot_r <- lsmeans(aovcar_mot_r, specs = ~ measurement) # get mean values per measurement
contrast(lsm_mot_r, "poly") # look at polynomial contrasts
# gambling
df_mot_g <- subset(df_mot, df_mot$cond == "Gambling") # subset data
aovcar_mot_g <- afex::aov_car(rating ~ measurement + Error(id / measurement), data = df_mot_g) # specify model
aovcar_mot_g
lsm_mot_g <- lsmeans(aovcar_mot_g, specs = ~ measurement) # get mean values per measurement
contrast(lsm_mot_g, "poly") # look at polynomial contrasts


# DEPENDENT VARIABLE 2: ratings of rewarding value #
# compute mean of reward value for each group for each level of chance of success
df_val %>% 
  group_by(cond, chance_success) %>% 
  summarise_all(mean)
# compute mean of reward value for all groups for each level of chance of success
tapply(df_val$rating, df_val$chance_success, mean)

# define variable contrast: 
# examining the orthogonal linear effects  of chance of success for each group
df_val$contrast <- 
  # no-reward group: resulting in a decrease in rewarding value as chance of success increases
  ifelse(df_val$cond == "No-reward" & df_val$chance_success == "extremely-low", 1,
         ifelse(df_val$cond == "No-reward" & df_val$chance_success == "moderate", 0,
                ifelse(df_val$cond == "No-reward" & df_val$chance_success == "high", -1, 
                       # reward group: resulting in an increase in rewarding value as chance of success increases
                       ifelse(df_val$cond == "Reward" & df_val$chance_success == "extremely-low", -1,
                              ifelse(df_val$cond == "Reward" & df_val$chance_success == "moderate", 0,
                                     ifelse(df_val$cond == "Reward" & df_val$chance_success == "high", 1, 
                                            # gambling group: resulting in an increase in rewarding value as chance of success increases
                                            ifelse(df_val$cond == "Gambling" & df_val$chance_success == "extremely-low", -1,
                                                   ifelse(df_val$cond == "Gambling" & df_val$chance_success == "moderate", 0,
                                                          ifelse(df_val$cond == "Gambling" & df_val$chance_success == "high", 1, NA 
                                                          )))))))))

# compute LME with the defined contrast as predictor for rewarding value across all groups
trend_val <- lmer(rating ~ 1 + contrast + (1 + contrast | id), data = df_val, REML = F)
summary(trend_val)

# specify aov_car
aovcar_val <- afex::aov_car(rating ~ cond*measurement + Error(id / measurement), data = df_val) # specify model
aovcar_val
lsm_val <- lsmeans(aovcar_val, specs = ~ cond*measurement) # get mean values per measurement and group
lsm_val
# look at contrast: gambling-low=-1, control-low=1, reward-low=-1; gambling-mod=0, control-mod=0, reward-mod=0; gambling-high=1, control-high=-1, reward-high=1
contrast(lsm_val, list(mycon = c(-1,1,-1,0,0,0,1,-1,1))) 


# specify the aov_car and test for polynomial contrasts for each group
# no-reward
df_val_c <- subset(df_val, df_val$cond == "No-reward") # subset data
aovcar_val_c <- afex::aov_car(rating ~ measurement + Error(id / measurement), data = df_val_c) # specify model
aovcar_val_c
lsm_val_c <- lsmeans(aovcar_val_c, specs = ~ measurement) # get mean values per measurement
contrast(lsm_val_c, "poly") # look at polynomial contrasts
# reward
df_val_r <- subset(df_val, df_val$cond == "Reward") # subset data
aovcar_val_r <- afex::aov_car(rating ~ measurement + Error(id / measurement), data = df_val_r) # specify model
aovcar_val_r
lsm_val_r <- lsmeans(aovcar_val_r, specs = ~ measurement) # get mean values per measurement
contrast(lsm_val_r, "poly") # look at polynomial contrasts
# gambling
df_val_g <- subset(df_val, df_val$cond == "Gambling") # subset data
aovcar_val_g <- afex::aov_car(rating ~ measurement + Error(id / measurement), data = df_val_g) # specify model
aovcar_val_g
lsm_val_g <- lsmeans(aovcar_val_g, specs = ~ measurement) # get mean values per measurement
contrast(lsm_val_g, "poly") # look at polynomial contrasts


#################################################################################  
############################ code to create Figure 2 ############################ 
#################################################################################  

# define variables used in the graph
varWithin <- "Chance of success" #fill
levelWithinReordered <- c("High", "Moderate", "Extremely-low")
groupNames <- c("No-reward", "Reward", "Gambling")
title <- c("(A) Intrinsic motivation", "(B) Rewarding value", "(C) Activation pattern at (9 5 -8) and (-9 5 -8)")
title <- c("(A) Intrinsic motivation", "(B) Rewarding value", "(C) Activation pattern at (10 6 -10) and (-8 6 -10)")
xLab <- "Experimental group"
yLab <- c("Rating", "Contrast estimate SW - WS")

titleSize <- 16
axisSize <- 12

## (A) INTRINSIC MOTIVATION ##
# get descriptes of the ratings of intrinsic motivation for each group
mot <- describeBy(df[, c( "mot_high", "mot_mod", "mot_low")], group=df$cond)
# combine the ratings for each group in a data frama
graph_mot <- as.data.frame(rbind(mot$`No-reward`, mot$Reward, mot$Gambling))
graph_mot$cond <- rep(groupNames, each = 3)
graph_mot$vars <- as.factor(graph_mot$vars)
levels(graph_mot$vars) <- levelWithinReordered

# use ggplot to create a bar graph including SE
outg_A <- ggplot(graph_mot, aes(cond, mean, fill = vars)) + theme_classic()
outg_A <- outg_A + geom_bar(stat="identity", position="dodge") + geom_errorbar(aes(ymin=mean-se, ymax=mean+se), width=.1, position=position_dodge(0.9)) + 
  scale_x_discrete(limits=groupNames) + labs(x=xLab, y=yLab[1], fill = varWithin, title = title[1]) +
  theme(axis.text=element_text(size=axisSize), axis.title=element_text(size=axisSize, face="bold"), title=element_text(size = titleSize, face="bold"), legend.title = element_text(size=axisSize), legend.text = element_text(size = axisSize)) + 
  coord_cartesian(ylim = c(1, 7)) + scale_fill_brewer(palette = 14)
outg_A
ggsave("Figure2A.jpeg")


## (B) REWRADING VALUE ##
# get descriptes of the ratings of rewarding value for each group
val <- describeBy(df[, c("val_high", "val_mod", "val_low")], group=df$cond)
# combine the ratings for each group in a data frama
outposgraphValue <- as.data.frame(rbind(val$`No-reward`, val$Reward, val$Gambling))
outposgraphValue$cond <-rep(groupNames, each = 3)
outposgraphValue$vars <- as.factor(outposgraphValue$vars)
levels(outposgraphValue$vars) <-  levelWithinReordered

# use ggplot to create a bar graph including SE
outg_B <- ggplot(outposgraphValue, aes(cond, mean, fill = vars)) + theme_classic()
outg_B <- outg_B + geom_bar(stat="identity", position="dodge") + geom_errorbar(aes(ymin=mean-se, ymax=mean+se), width=.1, position=position_dodge(0.9)) + 
  scale_x_discrete(limits=groupNames) + labs(x=xLab, y=yLab[1], fill = varWithin, title = title[2]) +
  theme(axis.text=element_text(size=axisSize), axis.title=element_text(size=axisSize, face="bold"), title=element_text(size = titleSize, face="bold"), legend.title = element_text(size=axisSize), legend.text = element_text(size = axisSize)) + 
  coord_cartesian(ylim = c(1, 7)) + scale_fill_brewer(palette = 14)
outg_B
ggsave("Figure2B.jpeg")

## (C) ACTIVATION PATTERN ##

# computing average between left and right peak voxel
df$avg_low <- (df$left_low + df$right_low)/2
df$avg_mod <- (df$left_mod + df$right_mod)/2
df$avg_high <- (df$left_high + df$right_high)/2

# creating data frame for plotting purposes
peak <- describeBy(df[, c("avg_high", "avg_mod", "avg_low" )], group=df$cond)
#peak <- describeBy(df[, c("left_high", "left_mod", "left_low" )], group=df$cond)
#peak <- describeBy(df[, c("right_high", "right_mod", "right_low" )], group=df$cond)

graph_peak <- as.data.frame(rbind(peak$`No-reward`, peak$Reward, peak$Gambling))
graph_peak$cond <- rep(groupNames, each = 3)

graph_peak$vars <- as.factor(graph_peak$vars)
levels(graph_peak$vars) <- levelWithinReordered

# plotting contrast estimates
outg_C <- ggplot(graph_peak, aes(cond, mean, fill = vars))  + theme_classic()
outg_C <- outg_C + geom_bar(stat="identity", position="dodge") + geom_errorbar(aes(ymin=mean-se, ymax=mean+se), width=.1, position=position_dodge(0.9)) +
  scale_x_discrete(limits=groupNames) + labs(x=xLab, y=yLab[2], fill = varWithin, title = title[3]) +
  theme(axis.text=element_text(size=axisSize), axis.title=element_text(size=axisSize, face="bold"), title=element_text(size = titleSize, face="bold"), legend.title = element_text(size=axisSize), legend.text = element_text(size = axisSize)) + 
  coord_cartesian(ylim = c(-1, 11)) + scale_fill_brewer(palette = 14)
outg_C
ggsave("Figure2C.jpeg")

# combine all images
ggpubr::ggarrange(outg_A, outg_B, outg_C,
                  #labels = c("A", "B", "C"),
                  ncol = 2, nrow = 2, 
                  common.legend = TRUE, legend="bottom")
ggsave("Figure2.jpeg", height = 15, width = 30, units = "cm")

#################################################################################  
##################### extract values for parametric modulation ################## 
#################################################################################  

# create folder to save files
dir.create(file.path(getwd(), "param_mod"))
setwd(file.path(getwd(), "param_mod"))


# define scan IDs
subjects <-  as.character(df$scan)

# define list of modulators
modulator <- c("mot_low", "mot_mod", "mot_high", 
               "val_low", "val_mod", "val_high")
value <- numeric(length(modulator))

# name = "KM13121702"
for (name in subjects){
  
  # create df
  parametric_mod <- data.frame(modulator, value)
  
  # loop through all modulators
  for (m in seq_along(modulator)){
    
    # extract the subject's raw value for each parametric modulator
    parametric_mod$value[m] <- df[df$scan == paste0(name), paste0(modulator[m])]
    
  }
  
  # compute mean value for motivation and rewarding value
  mean_mot <- mean(parametric_mod$value[grepl("mot", parametric_mod$modulator)])
  mean_val <- mean(parametric_mod$value[grepl("val", parametric_mod$modulator)])
  
  # create new df for centered values
  parametric_mod_c <- data.frame(modulator, value)
  
  # change name of modulators
  parametric_mod_c$modulator <- paste0(parametric_mod_c$modulator, "_c")
  
  # compute centered values for motivation and rewarding value
  
  # loop through all modulators
  for (m in seq_along(modulator)){
    
    if (grepl("mot", modulator[m])) {
      
      # substract mean mot from raw value
      parametric_mod_c$value[m] <- df[df$scan == paste0(name), paste0(modulator[m])] - mean_mot
      
    } else {
      
      # substract mean mot from raw value
      parametric_mod_c$value[m] <- df[df$scan == paste0(name), paste0(modulator[m])] - mean_val
      
    }
    
  }
  
  # combine raw values and centered values
  parametric_mod <- rbind(parametric_mod, parametric_mod_c)
  
  # compute correlation between demeaned emotion and motivation
  mot_c <- parametric_mod_c$value[grepl("mot", parametric_mod_c$modulator)]
  val_c <- parametric_mod_c$value[grepl("val", parametric_mod_c$modulator)]
  cor <-  cor(mot_c, val_c)
  print(paste(name, df$cond[df$scan == paste(name)], cor))
  print(paste(name, df$cond[df$scan == paste(name)], "SD mot:", round(sd(mot_c), 2), "SD val:", round(sd(val_c), 2), ""))
  
  # add correlation to df
  df$cor[df$scan == paste(name)] <- cor
  
  # save as tsv
  write.table(parametric_mod, file = paste0(name, "_param_mod.txt"), sep="\t", col.names = F, row.names = F)

  # remove objects no longer needed
  rm(parametric_mod, parametric_mod_c, mean_mot, mean_val, val_c, mot_c)
}

