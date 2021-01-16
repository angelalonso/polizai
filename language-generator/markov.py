import pandas as pd # data processing, CSV file I/O (e.g. pd.read_csv)
import markovify #Markov Chain Generator

inp = pd.read_csv('abcnews-date-text.csv')
inp.head(3)

text_model = markovify.NewlineText(inp.headline_text, state_size = 2)

# Print ten randomly-generated sentences using the built model
for i in range(10):
    print(text_model.make_sentence())
