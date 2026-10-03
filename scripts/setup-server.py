#!/usr/bin/env python3
"""Generate private RTSP settings; never deploy or rotate existing secrets."""
import argparse
import base64
import hashlib
import ipaddress
import json
import os
from pathlib import Path
import re
import secrets


def valid_host(value):
    try:
        address = ipaddress.ip_address(value)
        if address.version != 4:
            raise ValueError("Use an IPv4 address or hostname")
        return value
    except ValueError:
        if len(value) > 253 or not all(
            re.fullmatch(r"[A-Za-z0-9](?:[A-Za-z0-9-]{0,61}[A-Za-z0-9])?", label)
            for label in value.split(".")
        ):
            raise argparse.ArgumentTypeError("Use an IPv4 address or hostname, without a port")
        return value


def initialize(server, host):
    private = server / "private"
    private.mkdir(mode=0o700, exist_ok=True)
    private.chmod(0o700)
    credential_file = private / "credentials.json"
    if credential_file.exists():
        credentials = json.loads(credential_file.read_text())
    else:
        credentials = {key: secrets.token_hex(24) for key in ("publish", "read")}
        credential_file.write_text(json.dumps(credentials, indent=2) + "\n")
    credential_file.chmod(0o600)
    if set(credentials) != {"publish", "read"} or not all(
        isinstance(value, str) and re.fullmatch(r"[a-f0-9]{48}", value)
        for value in credentials.values()
    ):
        raise ValueError("Invalid existing credentials; refusing to rotate or overwrite them")
    config = (server / "mediamtx.yml.in").read_text()
    for key in ("publish", "read"):
        digest = base64.b64encode(hashlib.sha256(credentials[key].encode()).digest()).decode()
        config = config.replace(f"__{key.upper()}_HASH__", digest)
    urls = (
        f"Mac publish URL: rtsp://mac_publish:{credentials['publish']}@{host}:8554/ai_workspace\n"
        f"Camera read URL: rtsp://camera_read:{credentials['read']}@{host}:8554/ai_workspace\n"
    )
    for name, content in (("mediamtx.yml", config), ("connection.txt", urls)):
        path = private / name
        path.write_text(content)
        path.chmod(0o600)
    return private


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--host", required=True, type=valid_host, help="Linux server LAN address")
    args = parser.parse_args()
    os.umask(0o077)
    directory = initialize(Path(__file__).resolve().parent.parent / "server", args.host)
    print(f"Settings ready: {directory}/connection.txt (contains secrets; do not upload)")
    print("Next, on Linux: cd server && sudo docker compose up -d")
