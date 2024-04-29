

class ConfigPath:
    def __init__(self):
        self.debug = None
        self.release = None


class OpenUsdPath:
    def __init__(self):
        self.rootDir = ConfigPath()


class Python:
    def __init__(self):
        self.enabled = False
        self.executable = ConfigPath()
        self.library = ConfigPath()
        # self.includeDir = None
        # self.pythonPath = None


class MaterialX:
    def __init__(self):
        self.enabled = False
        # TODO:


def dirpath(path):
    import os
    return os.path.dirname(path)


def install(
        outputDestination: str,
        usdVersion: str,
        pythonVersion: str,
        pythonPath: str,
        debug: bool,
        release: bool):
    import os
    import jinja2
    from mgr.utils import generatePath

    from mgr.install import install, OpenUsdPath, Python
    openUsd = OpenUsdPath()
    openUsd.rootDir.release = generatePath(
        outputDestination, usdVersion, pythonVersion, "release").replace("\\", "/") if release else None
    openUsd.rootDir.debug = generatePath(
        outputDestination, usdVersion, pythonVersion, "debug").replace("\\", "/") if debug else None
    python = Python()
    python.enabled = (pythonVersion is not None)
    if python.enabled:
        python.executable.debug = os.path.join(pythonPath, "python_d.exe").replace("\\", "/") if debug else None
        python.executable.release = os.path.join(pythonPath, "python.exe").replace("\\", "/") if release else None
        python.library.debug = os.path.join(pythonPath, "libs/python39_d.lib").replace("\\", "/") if debug else None
        python.library.release = os.path.join(pythonPath, "libs/python39.lib").replace("\\", "/") if release else None

    cmakeRoot = os.path.join("templates", f"usd-{usdVersion}", "cmake")
    targetRoot = os.path.join(cmakeRoot, f"py{pythonVersion}" if pythonVersion else "_")

    j2env = jinja2.Environment(loader=jinja2.FileSystemLoader([cmakeRoot, targetRoot]))
    j2env.filters["dirpath"] = dirpath

    args = dict(
        openUsd=openUsd,
        python=python,
        # materialX=materialX if materialX else MaterialX(),
        materialX=MaterialX(),
    )
    files = ["openusdConfig.cmake"]

    for file in os.listdir(targetRoot):
        files.append(file)

    for file in files:
        template = j2env.get_template(file)
        output = template.render(**args)
        with open(os.path.join(generatePath(outputDestination, usdVersion, pythonVersion, None), file), mode="w") as fp:
            fp.write(output)


if __name__ == "__main__":
    openUsd = OpenUsdPath()
    openUsd.rootDir.release = "S:/dist/pxr/OpenUSD-23.11/install/usd"
    openUsd.rootDir.debug = "S:/dist/pxr/OpenUSD-23.11/install/usd_d"
    python = Python()
    python.enabled = False
    python.executable.debug = "C:/Users/shirao/AppData/Local/Programs/Python/Python39/python_d.exe"
    python.executable.release = "C:/Users/shirao/AppData/Local/Programs/Python/Python39/python.exe"
    python.library.debug = "C:/Users/shirao/AppData/Local/Programs/Python/Python39/libs/python39_d.lib"
    python.library.release = "C:/Users/shirao/AppData/Local/Programs/Python/Python39/libs/python39.lib"
    python = None
    install("2311", "win64", "_", "test", openUsd, python=python)
