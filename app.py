import pandas as pd
import joblib
from flask import Flask, jsonify, request
import nltk
from nltk.corpus import stopwords
from nltk.stem import PorterStemmer


app = Flask(__name__)
# nltk.download('stopwords')

def custom_tokenizer(text):
    # Tokenization
    stemmer = PorterStemmer()
    stop_words = set(stopwords.words('english'))
    tokens = text.split()
    
    # Remove stopwords, stem, and lemmatize the words
    processed_tokens = [
        stemmer.stem(token)
        for token in tokens
        if token.lower() not in stop_words
    ]
    token_string = " ".join(processed_tokens)
    
    # Return the processed tokens
    return token_string

model = joblib.load('grid.pkl')

@app.route("/")
def hello_world():
    return "Hello World!"

@app.route('/predict', methods=['POST'])
def predict():
    # Get Json request    

    feat_data = request.get_json()
    print(feat_data)
    #convert json to dataframe
    df = pd.DataFrame(feat_data)
    df = df.reindex(columns=['phrase'])
    print(df)
    #vectorize
    df['phrase_custom'] = df['phrase'].apply(custom_tokenizer)
    #predict
    prediction = model.predict(df['phrase_custom'].values)
    return jsonify({'sentiment':prediction.tolist()})


if __name__=='__main__':
    app.run(port=5000)

