
import os


def generatePath(dest: str, usdVersion: str, pythonVersion: str, cfg: str):
    path = os.path.join(dest, f"usd-{usdVersion}", f"py{pythonVersion}" if pythonVersion else "_")
    if cfg is not None:
        path = os.path.join(path, cfg)
    return path
