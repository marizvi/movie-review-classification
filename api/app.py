import pandas as pd
import joblib
from flask import Flask, jsonify, request
import nltk
from nltk.corpus import stopwords
from nltk.stem import PorterStemmer

nltk.download('stopwords')

def custom_tokenizer(text):
# Tokenization
    stemmer = PorterStemmer()
    stop_words = set(stopwords.words('english'))

    tokens = text.split()
    
    # Remove stopwords, and stem the words
    processed_tokens = [
        stemmer.stem(token)
        for token in tokens
        if token.lower() not in stop_words
    ]
    
    # Return the processed tokens
    return processed_tokens

app = Flask(__name__)
model = joblib.load('static/grid.pkl')

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

    # print('transform: ',vect.fit_transform(df['phrase'].values))

    #predict
    prediction = list(model.predict(df['phrase'].values))

    return jsonify({'sentiment': str(prediction)})


if __name__=='__main__':
    app.run()

