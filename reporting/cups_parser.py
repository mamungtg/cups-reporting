import os
import sqlite3
from datetime import datetime

DB_PATH = "cups.db"
LOG_FILE = "/var/log/cups/page_log"

def init_db():
    conn = sqlite3.connect(DB_PATH)
    c = conn.cursor()
    c.execute('''CREATE TABLE IF NOT EXISTS jobs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        printer TEXT,
        user TEXT,
        job_id INTEGER,
        date TEXT,
        pages INTEGER
    )''')
    conn.commit()
    conn.close()

def parse_logs():
    if not os.path.exists(LOG_FILE):
        return

    conn = sqlite3.connect(DB_PATH)
    c = conn.cursor()

    with open(LOG_FILE, "r") as f:
        for line in f:
            parts = line.strip().split()
            if len(parts) >= 5:
                printer, user, job_id, date_time, pages = parts[:5]
                date = datetime.strptime(date_time.split("T")[0], "%Y-%m-%d").date()
                c.execute("INSERT INTO jobs (printer,user,job_id,date,pages) VALUES (?,?,?,?,?)",
                          (printer, user, job_id, date, pages))
    conn.commit()
    conn.close()

if __name__ == "__main__":
    init_db()
    parse_logs()
