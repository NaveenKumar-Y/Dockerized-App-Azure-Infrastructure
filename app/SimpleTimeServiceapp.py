from flask import Flask, jsonify, request
from datetime import datetime

app = Flask(__name__)

@app.route("/", methods=["GET"])
def get_time():
    return jsonify({
        "timestamp": datetime.utcnow(),
        "ip": request.headers.get('X-Forwarded-For', request.remote_addr) #request.remote_addr   
    })


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=18630)
