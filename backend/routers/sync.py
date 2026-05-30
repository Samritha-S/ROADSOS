from fastapi import APIRouter
from database import get_connection
from models import IncidentSyncModel

router = APIRouter()

@router.post("/incident")
async def sync_incident(incident: IncidentSyncModel):
    """
    Receives resolved incident data from Flutter app.
    Stores for future analytics.
    """
    try:
        conn = get_connection()
        cursor = conn.cursor()
        cursor.execute("""
            INSERT OR REPLACE INTO incidents VALUES
            (?,?,?,?,?,?,?,?,?,?,?,?,?)
        """, (
            incident.id,
            incident.created_at,
            incident.latitude,
            incident.longitude,
            incident.triage_result,
            incident.timeline,
            incident.services_contacted_ids,
            1 if incident.family_alerted else 0,
            incident.family_alerted_at,
            incident.bystander_count,
            incident.current_state,
            incident.resolved_at,
            incident.country_code,
        ))
        conn.commit()
        conn.close()
        return {
            "status": "synced",
            "incident_id": incident.id
        }
    except Exception as e:
        return {
            "status": "error",
            "message": str(e)
        }
