from datetime import datetime
from flask import Flask, jsonify, request

app = Flask(__name__)

@app.route("/health", methods=["GET"])
def root():
    return "main route success"

@app.route("/health/cache-me", methods=["GET"])
def cache():
    return "proxy will cache this response"

@app.route("/health/info", methods=["POST"])
def info():
    resp = {
        "host": request.headers["Host"],
        "user-agent": request.headers["User-Agent"],
        "timestamp": datetime.now().isoformat(),
        "data": request.data.decode("utf-8"),
        "form": request.form,
        "json": request.get_json(),
    }
    return jsonify(resp)

@app.route("/health/health-check", methods=["GET"])
def healthcheck():
    return "success"
