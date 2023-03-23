# twitter-sentiment-analysis
This repository displays the code used for a research paper analysing the acquisition of Twitter by Elon Musk.

# overview: scripts
01 - data collection
scraping of tweets in the months of October and November 2022; query: "Elon Musk Twitter"

02 - data consolidation
because of the large nature of the collected data, the collection process was split in several parts. This script merges all files into one.

03 - VADER-preprocessing
text pre-processing for VADER sentiment analysis

04 - VADER-SA
VADER sentiment analysis

05 - RoBERTa-SA
pre-procssing for and conduction of RoBerta sentiment analysis

06 - Analysis
preparing of files from the sentiment analyses and visualisation of data
