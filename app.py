import pandas as pd
import joblib
from flask import Flask, jsonify, request

app = Flask(__name__)

@app.route("/")
def hello_world():
    return "Hello World!"

@app.route('/predict', methods=['POST'])
def predict():
    # Get Json request    
    model = joblib.load('grid_model.pkl')

    feat_data = request.get_json()
    print(feat_data)
    #convert json to dataframe
    df = pd.DataFrame(feat_data)
    df = df.reindex(columns=['phrase'])
    print(df)

    #predict
    prediction = list(model.predict(df['phrase'].values))

    return jsonify({'sentiment': str(prediction)})


if __name__=='__main__':
    app.run()

