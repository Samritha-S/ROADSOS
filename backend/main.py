from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from routers import bundles, config, sync
import database

app = FastAPI(
    title="ROADSoS API",
    description="Road Accident Emergency Operating System Backend",
    version="1.0.0"
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(bundles.router, prefix="/api/v1/bundles")
app.include_router(config.router, prefix="/api/v1/config")
app.include_router(sync.router, prefix="/api/v1/sync")

@app.on_event("startup")
async def startup():
    database.init_db()

@app.get("/")
async def root():
    return {
        "system": "ROADSoS API",
        "version": "1.0.0",
        "status": "operational",
        "description": "Road Accident Emergency Operating System"
    }

@app.get("/health")
async def health():
    return {"status": "healthy"}
