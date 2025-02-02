from flask import Flask, jsonify, request
from datetime import datetime

# Initialize a Flask application
app = Flask(__name__)

# Define a route for the root URL "/"
@app.route("/", methods=["GET"])
def get_time():
    return jsonify({
        "timestamp": datetime.utcnow(),
        "ip": request.remote_addr
    })

# Run the Flask app
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=18630)