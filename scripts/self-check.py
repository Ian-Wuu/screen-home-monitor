#!/usr/bin/env python3
"""Check config generation, credential reuse, permissions, and input rejection."""
import importlib.util
from pathlib import Path
import shutil
import tempfile

root = Path(__file__).resolve().parent.parent
spec = importlib.util.spec_from_file_location("setup_server", root / "scripts/setup-server.py")
setup = importlib.util.module_from_spec(spec)
spec.loader.exec_module(setup)
with tempfile.TemporaryDirectory() as temporary:
    server = Path(temporary)
    shutil.copyfile(root / "server/mediamtx.yml.in", server / "mediamtx.yml.in")
    private = setup.initialize(server, "screen-server.local")
    before = (private / "credentials.json").read_bytes()
    setup.initialize(server, "192.0.2.10")
    assert before == (private / "credentials.json").read_bytes()
    config = (private / "mediamtx.yml").read_text()
    assert "__" not in config and config.count("sha256:") == 2
    assert "overridePublisher: false" in config
    assert "192.0.2.10:8554/ai_workspace" in (private / "connection.txt").read_text()
    assert private.stat().st_mode & 0o777 == 0o700
    for path in private.iterdir():
        assert path.stat().st_mode & 0o777 == 0o600
    for bad in ("host:8554", "x/y", "x\npass", "$(id)", "-bad", "", "::1"):
        try:
            setup.valid_host(bad)
        except Exception:
            pass
        else:
            raise AssertionError(f"Invalid host accepted: {bad!r}")
    (private / "credentials.json").write_text('{"publish":"broken"}')
    try:
        setup.initialize(server, "screen-server.local")
    except ValueError:
        pass
    else:
        raise AssertionError("Corrupt credentials were silently replaced")
print("Server configuration self-check passed")
