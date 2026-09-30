#!/usr/bin/env python3
"""Download a one-off snapshot of EV charging stations from Open Charge Map.

The snapshot is stored as a small JSON file (data/ocm_athens_snapshot.json) and is
used by tools/build_sample_data.py to build the sample data in src/EVPoint_dump.sql.
You only need to run this once; the resulting file is committed to the repository
so the database can be rebuilt without network access or an API key.

Usage (Linux, macOS, WSL, or Windows with Python 3):

    export OCM_API_KEY=your_key_here          # PowerShell: $env:OCM_API_KEY="your_key_here"
    python3 tools/fetch_ocm.py

Get a free API key by registering at https://openchargemap.org (see the API
documentation there). The key is read from the environment and is never written to
disk. Only technical fields are kept in the snapshot: user comments, contact details,
media and account data returned by the API are deliberately dropped.

Data: Open Charge Map, https://openchargemap.org, community data under CC BY 4.0.
Imported third-party records keep the licence of their data provider; the provider
name and licence summary are stored with every station.
"""

import argparse
import datetime as dt
import json
import os
import sys
import urllib.error
import urllib.parse
import urllib.request
from pathlib import Path

DEFAULT_BASE_URL = "https://api.openchargemap.io/v3"
USER_AGENT = (
    "EVPointDB-course-sample/1.0 (https://github.com/johnkouk469/DatabasesCourse2021)"
)


def get(d, *path, default=None):
    """Safe nested lookup: get(poi, 'AddressInfo', 'Title')."""
    for key in path:
        if not isinstance(d, dict):
            return default
        d = d.get(key)
    return default if d is None else d


def fetch(base_url, key, params):
    """Call the /poi endpoint and return the decoded JSON; exit with a message on errors."""
    url = base_url.rstrip("/") + "/poi?" + urllib.parse.urlencode(params)
    req = urllib.request.Request(
        url, headers={"X-API-Key": key, "User-Agent": USER_AGENT}
    )
    try:
        with urllib.request.urlopen(req, timeout=60) as resp:
            return json.load(resp)
    except urllib.error.HTTPError as err:
        if err.code in (401, 403):
            sys.exit(
                f"The API rejected the request (HTTP {err.code}). "
                "Check that OCM_API_KEY is a valid key."
            )
        if err.code == 429:
            sys.exit("Rate limit reached (HTTP 429). Wait a while and try again.")
        sys.exit(f"HTTP error {err.code} from the API.")
    except urllib.error.URLError as err:
        sys.exit(f"Could not reach the API: {err.reason}")


def sanitize(poi):
    """Keep only the technical fields needed for the database."""
    connections = []
    for c in poi.get("Connections") or []:
        connections.append(
            {
                "type": get(c, "ConnectionType", "Title"),
                "type_id": c.get("ConnectionTypeID"),
                "power_kw": c.get("PowerKW"),
                "quantity": c.get("Quantity") or 1,
                "status": get(c, "StatusType", "Title"),
                "operational": get(c, "StatusType", "IsOperational"),
            }
        )
    return {
        "ocm_id": poi.get("ID"),
        "title": get(poi, "AddressInfo", "Title"),
        "town": get(poi, "AddressInfo", "Town"),
        "latitude": get(poi, "AddressInfo", "Latitude"),
        "longitude": get(poi, "AddressInfo", "Longitude"),
        "operator": get(poi, "OperatorInfo", "Title"),
        "status": get(poi, "StatusType", "Title"),
        "operational": get(poi, "StatusType", "IsOperational"),
        "date_last_verified": poi.get("DateLastVerified"),
        "data_provider": get(poi, "DataProvider", "Title"),
        "data_provider_license": get(poi, "DataProvider", "License"),
        "data_provider_open_licensed": get(poi, "DataProvider", "IsOpenDataLicensed"),
        "connections": connections,
    }


def main():
    """Download the stations, strip them to technical fields and save the snapshot."""
    parser = argparse.ArgumentParser(
        description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter
    )
    parser.add_argument(
        "--lat", type=float, default=37.9838, help="centre latitude (default: Athens)"
    )
    parser.add_argument(
        "--lon", type=float, default=23.7275, help="centre longitude (default: Athens)"
    )
    parser.add_argument(
        "--distance", type=float, default=15, help="radius in km (default: 15)"
    )
    parser.add_argument(
        "--country", default="GR", help="ISO country code (default: GR)"
    )
    parser.add_argument(
        "--max",
        type=int,
        default=300,
        help="maximum stations to download (default: 300)",
    )
    parser.add_argument(
        "--out",
        default=None,
        help="output file (default: data/ocm_athens_snapshot.json)",
    )
    parser.add_argument(
        "--base-url", default=DEFAULT_BASE_URL, help=argparse.SUPPRESS
    )  # for tests
    args = parser.parse_args()

    key = os.environ.get("OCM_API_KEY", "").strip()
    if not key:
        sys.exit(
            "Set the OCM_API_KEY environment variable to your Open Charge Map API key first."
        )

    root = Path(__file__).resolve().parent.parent
    out = Path(args.out) if args.out else root / "data" / "ocm_athens_snapshot.json"

    params = {
        "output": "json",
        "countrycode": args.country,
        "latitude": args.lat,
        "longitude": args.lon,
        "distance": args.distance,
        "distanceunit": "KM",
        "maxresults": args.max,
        "compact": "false",
        "verbose": "false",
    }
    print(
        f"Requesting up to {args.max} stations within {args.distance:g} km "
        f"of ({args.lat:g}, {args.lon:g})..."
    )
    pois = fetch(args.base_url, key, params)
    if not isinstance(pois, list):
        sys.exit("Unexpected response from the API (expected a list of stations).")

    stations = [sanitize(p) for p in pois]
    stations = [
        s for s in stations if s["latitude"] is not None and s["longitude"] is not None
    ]
    stations.sort(key=lambda s: s["ocm_id"] or 0)

    snapshot = {
        "source": "Open Charge Map (https://openchargemap.org)",
        "license": "Creative Commons Attribution 4.0 International (CC BY 4.0); "
        "imported records keep the licence of their data provider",
        "fetched_at_utc": dt.datetime.now(dt.timezone.utc).strftime("%Y-%m-%d"),
        "query": {
            k: v for k, v in params.items() if k not in ("output", "compact", "verbose")
        },
        "stations": stations,
    }
    out.parent.mkdir(parents=True, exist_ok=True)
    with open(out, "w", encoding="utf-8") as fh:
        json.dump(snapshot, fh, ensure_ascii=False, indent=1)
        fh.write("\n")
    print(f"Saved {len(stations)} stations to {out}")


if __name__ == "__main__":
    main()
