import json
import requests
import time
from collections import defaultdict

# Facility tag definitions and corresponding type identifiers
FACILITY_TAGS = {
    'hospital': {'amenity': 'hospital'},
    'police': {'amenity': 'police'},
    'ambulance_station': {'amenity': 'ambulance_station'},
    'clinic': {'amenity': 'clinic'},
    'car_repair': {'shop': 'car_repair'},
    'tyres': {'shop': 'tyres'},
}

# Target regions per country
REGIONS = {
    'IN': [
        'Tamil Nadu', 'Maharashtra', 'Delhi', 'Karnataka',
        'Telangana', 'West Bengal', 'Gujarat', 'Rajasthan',
        'Uttar Pradesh', 'Punjab', 'Kerala'
    ],
    'GB': ['England', 'Scotland', 'Wales'],
    'US': ['New York', 'California', 'Texas', 'Illinois', 'Florida']
}

OVERPASS_URL = 'https://overpass-api.de/api/interpreter'
HEADERS = {
    'User-Agent': 'RoadSOS OSM fetch script/1.0',
    'Accept': 'application/json'
}

def build_query():
    """Create an Overpass QL query that retrieves all requested facility tags.
    The query pulls both nodes and ways. Filtering for name and phone/contact:phone
    is performed later in Python because Overpass does not reliably handle the
    "contact:phone" key in the same way as "phone".
    """
    parts = []
    for tags in FACILITY_TAGS.values():
        filter_str = ''.join(f'["{k}"="{v}"]' for k, v in tags.items())
        parts.append(f'node{filter_str}')
        parts.append(f'way{filter_str}')
    query_body = "\n  ".join(parts)
    query = f"[out:json][timeout:180];\n(\n  {query_body}\n);\nout center;"
    return query

def fetch_overpass():
    query = build_query()
    for attempt in range(3):
        try:
            resp = requests.post(OVERPASS_URL, data={'data': query}, headers=HEADERS, timeout=180)
            resp.raise_for_status()
            return resp.json()
        except requests.HTTPError:
            if resp.status_code in (429, 502, 503, 504):
                time.sleep(5 * (attempt + 1))
                continue
            raise
    raise RuntimeError('Failed to fetch data from Overpass after retries')

def extract_facilities(data):
    facilities = []
    for el in data.get('elements', []):
        tags = el.get('tags', {})
        # Identify facility type
        ftype = None
        for typ, tag_dict in FACILITY_TAGS.items():
            if all(tags.get(k) == v for k, v in tag_dict.items()):
                ftype = typ
                break
        if not ftype:
            continue
        # Required tags
        name = tags.get('name')
        phone = tags.get('phone') or tags.get('contact:phone')
        if not (name and phone):
            continue
        # Coordinates
        if el['type'] == 'node':
            lat = el.get('lat')
            lon = el.get('lon')
        else:
            center = el.get('center', {})
            lat = center.get('lat')
            lon = center.get('lon')
        if lat is None or lon is None:
            continue
        # Country code (addr:country or country_code)
        country = tags.get('addr:country') or tags.get('country_code')
        if not country:
            continue
        country = country.upper()
        # District / city name
        district = tags.get('addr:city') or tags.get('addr:town') or tags.get('addr:suburb') or ''
        # Region / state filter
        region = tags.get('addr:state') or tags.get('addr:province') or ''
        if country in REGIONS:
            allowed = [r.lower() for r in REGIONS[country]]
            if region and region.lower() not in allowed:
                continue
        else:
            continue
        facilities.append({
            'name': name,
            'latitude': lat,
            'longitude': lon,
            'phone': phone,
            'type': ftype,
            'country': country,
            'district': district
        })
    return facilities

def write_json(facilities):
    out_path = 'osm_facilities.json'
    with open(out_path, 'w', encoding='utf-8') as f:
        json.dump({'facilities': facilities}, f, ensure_ascii=False, indent=2)
    return out_path

def summary(facilities):
    total = len(facilities)
    by_country = defaultdict(int)
    by_type = defaultdict(int)
    for fac in facilities:
        by_country[fac['country']] += 1
        by_type[fac['type']] += 1
    print(f"Total facilities fetched: {total}")
    print("By country:")
    for c, n in by_country.items():
        print(f"  {c}: {n}")
    print("By type:")
    for t, n in by_type.items():
        print(f"  {t}: {n}")
    print('\nFirst 5 entries:')
    for fac in facilities[:5]:
        print(json.dumps(fac, ensure_ascii=False))

def main():
    print('Fetching OSM data ...')
    data = fetch_overpass()
    facilities = extract_facilities(data)
    write_json(facilities)
    summary(facilities)

if __name__ == '__main__':
    main()
