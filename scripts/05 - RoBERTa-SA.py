from transformers import AutoTokenizer, AutoModelForSequenceClassification
from scipy.special import softmax
import pandas as pd
from tqdm import tqdm

# load model and tokenizer
roberta = f"cardiffnlp/twitter-roberta-base-sentiment"
model = AutoModelForSequenceClassification.from_pretrained(roberta)
tokenizer = AutoTokenizer.from_pretrained(roberta)



df = pd.read_csv("C:/Users/simon/OneDrive/Dokumente/UNILU/1 - HS22/1 Creator Economy/_MSA/code/EMT_sample_for_roBERTa.csv")

# preprocess tweet
def preprocess_tweet(tweet):
    tweet_words = []
    for word in tweet.split(' '):
        if word.startswith('@') and len(word) > 1:
            word = '@user'
        elif word.startswith('http'):
            word = "http"
        tweet_words.append(word)
    return " ".join(tweet_words)

# apply preprocessing function to df
df['preprocessed_text'] = df['content'].apply(preprocess_tweet)



labels = ['Negative', 'Neutral', 'Positive']

# sentiment analysis
def analyze_sentiment(tweet):
    tweet = preprocess_tweet(tweet)
    encoded_tweet = tokenizer(tweet, truncation=True, max_length=511, return_tensors='pt')
    output = model(**encoded_tweet)
    scores = output[0][0].detach().numpy()
    scores = softmax(scores)
    return dict(zip(labels, scores))

# Apply the sentiment analysis to each tweet in the DataFrame
sentiments = []
for tweet in tqdm(df["preprocessed_text"], total = len(df["preprocessed_text"])):
    sentiment = analyze_sentiment(tweet)
    sentiments.append(sentiment)

# Create a new DataFrame with the sentiment analysis results
df_sentiment = pd.DataFrame(sentiments)

# Combine the original DataFrame with the sentiment analysis results
df_final = pd.concat([df, df_sentiment], axis=1)

print(df_final.head())

df_final.to_csv("C:/Users/simon/OneDrive/Dokumente/UNILU/1 - HS22/1 Creator Economy/_MSA/code/EMT_VADER_roBERTa.csv", index = False)

print("Task done")