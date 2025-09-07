import os
import sqlite3
import pandas as pd
from flask import Flask, render_template

app = Flask(__name__)

DB_PATH = "/data/jobs.db"   # <-- persistent path

def query_db(query):
    conn = sqlite3.connect(DB_PATH)
    df = pd.read_sql_query(query, conn)
    conn.close()
    return df

@app.route("/")
def index():
    try:
        df = query_db("SELECT printer, user, SUM(pages) as total_pages FROM jobs GROUP BY printer, user")
        if df.empty:
            return "<h2>No print jobs found</h2>"
        return render_template("report.html", tables=[df.to_html(classes='data')], titles=df.columns.values)
    except Exception as e:
        return f"<h2>Error: {e}</h2>"
