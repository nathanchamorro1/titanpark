from fastapi import FastAPI
from fastapi.responses import PlainTextResponse
from prometheus_client import generate_latest, CONTENT_TYPE_LATEST
from sqlalchemy import create_engine, text

app = FastAPI()

# existing route
@app.get("/healthz")
def healthz():
    return {"status": "ok"}

ENGINE = create_engine("postgresql+psycopg2://postgres:postgres@db:5432/titanpark", pool_pre_ping=True)

@app.get("/v1/structures")
def list_structures():
    with ENGINE.connect() as conn:
        rows = conn.execute(text("SELECT id, name FROM parking_structures ORDER BY id")).mappings().all()
        return list(rows)

# new route
@app.get("/readiness")
def readiness():
    return {"status": "ready"}

# new route
@app.get("/metrics")
def metrics():
    data = generate_latest()
    return PlainTextResponse(content=data, media_type=CONTENT_TYPE_LATEST)