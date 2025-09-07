from flask import Flask, render_template
import sqlite3
import pandas as pd

DB_PATH = "data/cups.db"
app = Flask(__name__)

def query_db(query):
    conn = sqlite3.connect(DB_PATH)
    df = pd.read_sql_query(query, conn)
    conn.close()
    return df

@app.route("/")
def index():
    df = query_db("SELECT printer, user, SUM(pages) as total_pages FROM jobs GROUP BY printer, user")
    return render_template("index.html", tables=df.to_html(classes='table table-striped', index=False))

@app.route("/report")
def report():
    df = query_db("SELECT date, SUM(pages) as total_pages FROM jobs GROUP BY date ORDER BY date")
    labels = df['date'].tolist()
    values = df['total_pages'].tolist()
    return render_template("report.html", labels=labels, values=values)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
