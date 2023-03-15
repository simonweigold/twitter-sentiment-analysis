library(rio)
library(tidyverse)
library(openxlsx)
library(here)

EMT_roBERTa <- import(here::here("EMT_VADER_roBERTa.csv"))
EMT_VADER <- import(here::here("EMT_VADER.csv"))

#categorise roBERTa values
EMT_roBERTa$roBERTa_category <- c("Negative", "Neutral", "Positive")[apply(EMT_roBERTa[, c("Negative", "Neutral", "Positive")], 1, which.max)]

#reformat date
EMT_VADER$daydate <- as.Date(EMT_VADER$date)
EMT_roBERTa$daydate <- as.Date(EMT_roBERTa$date)

#export for qualitative analysis
quali1 <- sample_n(EMT_roBERTa, 200)
quali2 <- EMT_VADER[with(EMT_VADER, order(-like_count)),]
quali2 <- quali2[1:50,]
quali <- bind_rows(quali1, quali2)
write.csv(quali, here::here("quali.csv"))
write.xlsx(quali, here::here("quali.xlsx"))

#gain first insight
mean(EMT_VADER$compound)
mean(EMT_VADER$clean_compound)

mean(EMT_roBERTa$Negative)
mean(EMT_roBERTa$Neutral)
mean(EMT_roBERTa$Positive)

table(EMT_roBERTa$roBERTa_category)
table(EMT_VADER$comp_score)
table(EMT_VADER$clean_comp_score)


#volume of tweets per day
a <- EMT_VADER %>% 
  ggplot() +
  geom_freqpoly(aes(x=daydate), col="dodgerblue4") +
  xlab("Date") +
  ylab("Frequency") +
  scale_y_continuous(labels = scales::comma) +
  theme(axis.text = element_text(color="black", size=12, family="serif"),
        axis.text.x = element_text(color="black", size=12, family="serif"),
        axis.ticks.x = element_line(),
        axis.ticks.y = element_line(),
        axis.line.x = element_line(size=0.5, color="grey"),
        axis.line.y = element_line(size=0.5, color="grey"),
        panel.grid = element_line(color = "honeydew2",
                                  size = 0.5,
                                  linetype = 1),
        panel.background = element_rect(fill="white"),
        plot.margin = margin(10,10,10,10),
        plot.title = element_text(color="black", size=16, family="serif"),
        plot.subtitle = element_text(color="grey26", size=14, family="serif"),
        legend.text = element_text(color="black", size=12, family="serif"),
        text = element_text(color="black", size=14, family="serif")
  )
ggsave(a,
       filename = "volume-per-day.png",
       path = here::here("Sentiment Analysis", "visualisations"),
       device = "png",
       width = 6, height = 4, units = "in",
       dpi = 600
       )

#average sentiment per day
#VADER data preparation
df_means_VADER <- EMT_VADER %>%
  group_by(daydate) %>%
  summarize(mean_compound = mean(compound))

df_means_clean_VADER <- EMT_VADER %>%
  group_by(daydate) %>% 
  summarize(mean_clean_compound = mean(clean_compound))

df_means_VADER <- cbind(df_means_VADER, df_means_clean_VADER)

df_means_VADER <- df_means_VADER %>% select(c(1,2,4))

#VADER visualisation
b <- df_means_VADER %>% 
  ggplot() +
  geom_line(aes(x=daydate, y=mean_compound), col="dodgerblue4") +
  geom_line(aes(x=daydate, y=mean_clean_compound), col="dodgerblue2") +
  xlab("Date") +
  ylab("Sentiment") +
  scale_x_date(date_minor_breaks = "1 day") +
  theme(axis.text = element_text(color="black", size=12, family="serif"),
        axis.text.x = element_text(color="black", size=12, family="serif"),
        axis.ticks.x = element_line(),
        axis.ticks.y = element_line(),
        axis.line.x = element_line(size=0.5, color="grey"),
        axis.line.y = element_line(size=0.5, color="grey"),
        panel.grid = element_line(color = "honeydew2",
                                  size = 0.5,
                                  linetype = 1),
        panel.background = element_rect(fill="white"),
        plot.margin = margin(10,10,10,10),
        plot.title = element_text(color="black", size=16, family="serif"),
        plot.subtitle = element_text(color="grey26", size=14, family="serif"),
        legend.text = element_text(color="black", size=12, family="serif"),
        text = element_text(color="black", size=14, family="serif")
  )
ggsave(b,
       filename = "VADER-SA-over-time.png",
       path = here::here("Sentiment Analysis", "visualisations"),
       device = "png",
       width = 6, height = 4, units = "in",
       dpi = 600
)

#RoBERTa data preparation
df_means_roBERTa <- EMT_roBERTa %>% 
  group_by(daydate) %>% 
  summarize(across(c(Negative, Neutral, Positive), mean))

#RoBERTa visualisation
#colours <- c("Positive" = "green4", "Neutral" = "dodgerblue4", "Negative" = "red3")
c <- df_means_roBERTa %>% 
  ggplot() +
  geom_line(aes(x=daydate, y=Positive), col="green4") +
  geom_line(aes(x=daydate, y=Neutral), col="dodgerblue4") +
  geom_line(aes(x=daydate, y=Negative), col="red3") +
  xlab("Date") +
  ylab("Sentiment") +
  scale_x_date(date_minor_breaks = "1 day") +
  #scale_color_manual(values = colours) +
  theme(axis.text = element_text(color="black", size=12, family="serif"),
        axis.text.x = element_text(color="black", size=12, family="serif"),
        axis.ticks.x = element_line(),
        axis.ticks.y = element_line(),
        axis.line.x = element_line(size=0.5, color="grey"),
        axis.line.y = element_line(size=0.5, color="grey"),
        panel.grid = element_line(color = "honeydew2",
                                  size = 0.5,
                                  linetype = 1),
        panel.background = element_rect(fill="white"),
        plot.margin = margin(10,10,10,10),
        plot.title = element_text(color="black", size=16, family="serif"),
        plot.subtitle = element_text(color="grey26", size=14, family="serif"),
        legend.text = element_text(color="black", size=12, family="serif"),
        text = element_text(color="black", size=14, family="serif")
  )
ggsave(c,
       filename = "RoBERTa-SA-over-time.png",
       path = here::here("Sentiment Analysis", "visualisations"),
       device = "png",
       width = 6, height = 4, units = "in",
       dpi = 600
)
