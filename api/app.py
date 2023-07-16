import pandas as pd
import joblib
from flask import Flask, jsonify, request
from nltk.corpus import stopwords
from nltk.stem import PorterStemmer

app = Flask(__name__)

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

    #predict
    prediction = list(model.predict(df['phrase'].values))

    return jsonify({'sentiment': str('prediction')})


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
if __name__=='__main__':
    model = joblib.load('movie_review_model_svc.pkl')
    
    app.run(port=5000, debug=True)