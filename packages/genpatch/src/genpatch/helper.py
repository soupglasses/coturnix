from pathlib import Path

def find_upwards(cwd: Path, filename: str) -> Path | None:
    if cwd == Path(cwd.root) or cwd == cwd.parent:
        return None

    fullpath = cwd / filename
    return fullpath if fullpath.exists() else find_upwards(cwd.parent, filename)
