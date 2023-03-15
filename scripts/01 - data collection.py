import snscrape.modules.twitter as sntwitter
import pandas as pd
from tqdm import tqdm


query = "Elon Musk Twitter until:2022-12-01 since:2022-11-01"
tweets = []
limit = 3000000


for tweet in tqdm(sntwitter.TwitterSearchScraper(query).get_items(), total = limit):
    if len(tweets) == limit:
        break
    else:
        data = [
            tweet.date,
            tweet.id,
            tweet.content,
            tweet.user.username,
            tweet.likeCount,
            tweet.retweetCount
        ]
        tweets3.append(data)
        
df = pd.DataFrame(
    tweets, columns = ["date", "id", "content", "username", "like_count", "retweet_count"]
    )

# save to csv
df.to_csv('Elon-Musk-Twitter-November.csv')

