from fastapi import APIRouter, HTTPException
from database import get_connection
from models import FacilityModel
from typing import List

router = APIRouter()

@router.get("/{district}",
    response_model=List[FacilityModel])
async def get_bundle_for_district(district: str):
    """
    Returns all active facilities for a given district.
    Used by Flutter app for offline bundle updates.
    """
    conn = get_connection()
    cursor = conn.cursor()
    rows = cursor.execute("""
        SELECT * FROM facilities
        WHERE district = ? AND is_active = 1
    """, (district,)).fetchall()
    conn.close()

    if not rows:
        raise HTTPException(
            status_code=404,
            detail=f"No facilities found for district: {district}"
        )
    return [dict(row) for row in rows]

@router.get("/country/{country_code}",
    response_model=List[FacilityModel])
async def get_bundle_for_country(country_code: str):
    """
    Returns all active facilities for a country.
    """
    conn = get_connection()
    cursor = conn.cursor()
    rows = cursor.execute("""
        SELECT * FROM facilities
        WHERE country_code = ? AND is_active = 1
    """, (country_code,)).fetchall()
    conn.close()
    return [dict(row) for row in rows]

@router.get("/",
    response_model=List[str])
async def list_available_districts():
    """
    Returns list of all districts with facility data.
    """
    conn = get_connection()
    cursor = conn.cursor()
    rows = cursor.execute("""
        SELECT DISTINCT district FROM facilities
        WHERE is_active = 1
        ORDER BY district
    """).fetchall()
    conn.close()
    return [row['district'] for row in rows]
