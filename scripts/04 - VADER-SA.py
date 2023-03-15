import nltk
#nltk.download('vader_lexicon')
from nltk.sentiment.vader import SentimentIntensityAnalyzer
import numpy as np
import pandas as pd

sid = SentimentIntensityAnalyzer()

#import data
df = pd.read_csv("C:/Users/simon/OneDrive/Dokumente/UNILU/1 - HS22/1 Creator Economy/_MSA/code/EMT_clean.csv")
df['clean_content'] = df['clean_content'].fillna("NA")

#calculate scores
df['scores'] = df['content'].apply(lambda review: sid.polarity_scores(review))

df['compound']  = df['scores'].apply(lambda score_dict: score_dict['compound'])

def categorize(value):
    if value >= 0.05:
        return 'pos'
    elif value <= -0.05:
        return 'neg'
    else:
        return 'neu'
df['comp_score'] = df['compound'].apply(categorize)

#calculate scores for cleaned data
df['clean_scores'] = df['clean_content'].apply(lambda review: sid.polarity_scores(str(review)))

df['clean_compound']  = df['clean_scores'].apply(lambda score_dict: score_dict['compound'])

df['clean_comp_score'] = df['clean_compound'].apply(categorize)

print(df.head())

df.to_csv("C:/Users/simon/OneDrive/Dokumente/UNILU/1 - HS22/1 Creator Economy/_MSA/code/EMT_VADER.csv", index = False)

print("Task done")