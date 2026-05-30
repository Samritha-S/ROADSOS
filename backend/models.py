from pydantic import BaseModel
from typing import Optional, List
from datetime import datetime

class FacilityModel(BaseModel):
    id: str
    name: str
    latitude: float
    longitude: float
    phone: str
    secondary_phone: Optional[str] = None
    service_type: str
    emergency_tier: str
    country_code: str
    district: str
    source_tier: str
    confidence_score: float
    last_verified: str
    is_active: bool = True

class CountryConfigModel(BaseModel):
    country_code: str
    country_name: str
    emergency_number: str
    ambulance_number: str
    police_number: str
    fire_number: str
    primary_language_code: str
    currency_code: str

class IncidentSyncModel(BaseModel):
    id: str
    created_at: str
    latitude: Optional[float] = None
    longitude: Optional[float] = None
    triage_result: Optional[str] = None
    timeline: str = '[]'
    services_contacted_ids: str = '[]'
    family_alerted: bool = False
    family_alerted_at: Optional[str] = None
    bystander_count: int = 0
    current_state: str
    resolved_at: Optional[str] = None
    country_code: str = 'IN'
