from datetime import datetime
from flask import Flask, jsonify, request

app = Flask(__name__)
methods = ["GET", "POST", "DELETE", "PATCH"]

@app.route("/api/cache-me", methods=methods)
def cache():
    return "nginx will cache this response"

@app.route("/api/info", methods=methods)
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

@app.route("/api/health-check", methods=methods)
def healthcheck():
    return "success"
