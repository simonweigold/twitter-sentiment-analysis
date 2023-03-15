library(rio)
library(tidyverse)
library(lubridate)

#import raw files
nov1 <- import("C:/Users/simon/OneDrive/Dokumente/UNILU/1 - HS22/1 Creator Economy/_MSA/code/Elon-Musk-Twitter-November-9.csv")
nov2 <- import("C:/Users/simon/OneDrive/Dokumente/UNILU/1 - HS22/1 Creator Economy/_MSA/code/Elon-Musk-Twitter-November-1.csv")
nov3 <- import("C:/Users/simon/OneDrive/Dokumente/UNILU/1 - HS22/1 Creator Economy/_MSA/code/Elon-Musk-Twitter-November.csv")
nov4 <- import("C:/Users/simon/OneDrive/Dokumente/UNILU/1 - HS22/1 Creator Economy/_MSA/code/Elon-Musk-Twitter-November-30.csv")
oct1 <- import("C:/Users/simon/OneDrive/Dokumente/UNILU/1 - HS22/1 Creator Economy/_MSA/code/Elon-Musk-Twitter-October.csv")
oct2 <- import("C:/Users/simon/OneDrive/Dokumente/UNILU/1 - HS22/1 Creator Economy/_MSA/code/Elon-Musk-Twitter-October-31.csv")

#select relevant variables
nov1 <- nov1 %>% 
  select(date, id, content, username, like_count, retweet_count)
nov2 <- nov2 %>% 
  select(date, id, content, username, like_count, retweet_count)
nov3 <- nov3 %>% 
  select(date, id, content, username, like_count, retweet_count)
nov4 <- nov4 %>% 
  select(date, id, content, username, like_count, retweet_count)
oct1 <- oct1 %>% 
  select(date, id, content, username, like_count, retweet_count)
oct2 <- oct2 %>% 
  select(date, id, content, username, like_count, retweet_count)

#consolidate all files
EMT <- rbind(oct1, oct2, nov1, nov2, nov3, nov4)
#remove dublicates
EMT <- EMT[!duplicated(EMT$content), ]
#save full collection of tweets
write.csv(EMT, "C:/Users/simon/OneDrive/Dokumente/UNILU/1 - HS22/1 Creator Economy/_MSA/code/EMT.csv")

#import file with VADER variables (processing happens in 03 and 04)
EMT <- import("C:/Users/simon/OneDrive/Dokumente/UNILU/1 - HS22/1 Creator Economy/_MSA/code/EMT_VADER.csv")
#create sample for RoBERTa sentiment analysis
EMT_sampled <- sample_n(EMT, 334140)
#save sample
write.csv(EMT_sampled, "C:/Users/simon/OneDrive/Dokumente/UNILU/1 - HS22/1 Creator Economy/_MSA/code/EMT_sample_for_roBERTa.csv")
