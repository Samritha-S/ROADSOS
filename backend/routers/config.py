from fastapi import APIRouter
from database import get_connection
from models import CountryConfigModel
from typing import List

router = APIRouter()

@router.get("/countries",
    response_model=List[CountryConfigModel])
async def get_all_country_configs():
    """
    Returns all country emergency configurations.
    Flutter app caches these locally.
    """
    conn = get_connection()
    cursor = conn.cursor()
    rows = cursor.execute(
        "SELECT * FROM country_configs"
    ).fetchall()
    conn.close()
    return [dict(row) for row in rows]

@router.get("/countries/{country_code}",
    response_model=CountryConfigModel)
async def get_country_config(country_code: str):
    """
    Returns config for a specific country.
    """
    conn = get_connection()
    cursor = conn.cursor()
    row = cursor.execute("""
        SELECT * FROM country_configs
        WHERE country_code = ?
    """, (country_code,)).fetchone()
    conn.close()

    if not row:
        return CountryConfigModel(
            country_code=country_code,
            country_name="Unknown",
            emergency_number="112",
            ambulance_number="112",
            police_number="112",
            fire_number="112",
            primary_language_code="en",
            currency_code="INR"
        )
    return dict(row)
