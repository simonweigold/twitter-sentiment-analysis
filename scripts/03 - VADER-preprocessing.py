import pandas as pd
import html
import re
import nltk
from nltk.stem import WordNetLemmatizer
#nltk.download('punkt')
import numpy as np

df = pd.read_csv("C:/Users/simon/OneDrive/Dokumente/UNILU/1 - HS22/1 Creator Economy/_MSA/code/EMT.csv")

#clone content
df['clean_content'] = df['content']

#remove "..." from all entries
df['clean_content'] = df['clean_content'].str.replace('\.\.\.','')

#parse HTML characters to UTF-8 format
df['clean_content'] = df['clean_content'].apply(lambda x: html.unescape(x))

#remove hyperlinks
df['clean_content'] = df['clean_content'].apply(lambda x: re.sub(r'<[^>]*>', '', x))
df['clean_content'] = df['clean_content'].apply(lambda x: re.sub(r'http\S+', '', x))

#remove numbers
df['clean_content'] = df['clean_content'].apply(lambda x: re.sub(r'\d+', '', x))

#remove tweet-specific syntax
df['clean_content'] = df['clean_content'].apply(lambda x: re.sub(r'(@\w+|#\w+|RT\s+@\w+)', '', x))

#lemmatize words
#nltk.download('averaged_perceptron_tagger')
#nltk.download('wordnet')
lemmatizer = WordNetLemmatizer()
def lemmatize_text(text):
    tokens = nltk.word_tokenize(text)
    tagged_tokens = nltk.pos_tag(tokens)
    pos_map = {'N': 'n', 'V': 'v', 'R': 'r', 'J': 'a'}
    lemmatized_tokens = [lemmatizer.lemmatize(token, pos=pos_map.get(tag[0], 'n')) for token, tag in tagged_tokens]
    return ' '.join(lemmatized_tokens)
df['clean_content'] = df['clean_content'].apply(lemmatize_text)

#remove double or more spaces
def remove_extra_spaces(text):
    return re.sub('\s{2,}', ' ', text)
df['clean_content'] = df['clean_content'].apply(remove_extra_spaces)

#introduce missing values
df['clean_content'] = df['clean_content'].fillna('NA')
#missing values for contents too short
def replace_short_strings(val):
    if len(val) <= 3:
        return 'NA'
    else:
        return val
df['clean_content'] = df['clean_content'].apply(replace_short_strings)

#convert clean_content from float to int
df['clean_content'] = df['clean_content'].astype(df['content'].dtype)
# define a lambda function to encode each string to UTF-8
encode_utf8 = lambda s: s.encode('utf-8', 'ignore').decode('utf-8')
# apply the function to the column
df['clean_content'] = df['clean_content'].apply(encode_utf8)
#print(df.dtypes)

df.to_csv("C:/Users/simon/OneDrive/Dokumente/UNILU/1 - HS22/1 Creator Economy/_MSA/code/EMT_clean.csv", index = False)

print(df.head())
