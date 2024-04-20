import os


def convert(releaseRoot: str, debugRoot: str, dst: str):
    releaseConfig = list()
    debugConfig = list()

    if releaseRoot:
        with open(os.path.join(releaseRoot, "cmake/pxrTargets.cmake"), mode="r") as fp:
            releaseConfig = fp.readlines()
    if debugRoot:
        with open(os.path.join(debugRoot, "cmake/pxrTargets.cmake"), mode="r") as fp:
            debugConfig = fp.readlines()

    outputLines = list()

    for i in range(len(releaseConfig)):
        releaseLine = releaseConfig[i] if releaseConfig else None
        debugLine = debugConfig[i] if debugConfig else None
        releaseLine = (releaseLine
                       .replace("${_IMPORT_PREFIX}/include", "{{ openUsd.rootDir.release }}/include")
                       .replace(releaseRoot, "{{ openUsd.rootDir.release }}")
                       .replace("pxrTargets", "openusdTargets")) if releaseLine else None
        debugLine = (debugLine
                     .replace("${_IMPORT_PREFIX}/include", "{{ openUsd.rootDir.debug }}/include")
                     .replace(debugRoot, "{{ openUsd.rootDir.debug }}")
                     .replace("pxrTargets", "openusdTargets")) if debugLine else None

        def merge(key: str, rln: str, dln: str):
            # ";" で分離する
            releaseItems = set(rln.strip()[len(key):].strip(' "\n').split(";"))
            debugItems = set(dln.strip()[len(key):].strip(' "\n').split(";"))
            commonItems = releaseItems.intersection(debugItems)
            outItems = list(commonItems)
            outItems += [f"$<$<CONFIG:Debug>:{lb}>" for lb in debugItems.difference(commonItems)]
            outItems += [f"$<$<CONFIG:Release>:{lb}>" for lb in releaseItems.difference(commonItems)]
            return f'  {key} "{";".join(outItems)}"\n'

        if releaseLine is None:
            outputLines.append(debugLine)
        elif debugLine is None:
            outputLines.append(releaseLine)

        elif releaseLine.strip().startswith("INTERFACE_LINK_LIBRARIES")\
                and debugLine.strip().startswith("INTERFACE_LINK_LIBRARIES"):
            ret = merge("INTERFACE_LINK_LIBRARIES", releaseLine, debugLine)
            outputLines.append(ret)

        elif releaseLine.strip().startswith("INTERFACE_INCLUDE_DIRECTORIES")\
                and debugLine.strip().startswith("INTERFACE_INCLUDE_DIRECTORIES"):
            ret = merge("INTERFACE_INCLUDE_DIRECTORIES", releaseLine, debugLine)
            outputLines.append(ret)

        elif releaseLine.strip().startswith("INTERFACE_SYSTEM_INCLUDE_DIRECTORIES")\
                and debugLine.strip().startswith("INTERFACE_SYSTEM_INCLUDE_DIRECTORIES"):
            ret = merge("INTERFACE_SYSTEM_INCLUDE_DIRECTORIES", releaseLine, debugLine)
            outputLines.append(ret)

        elif releaseLine == debugLine:
            outputLines.append(releaseLine)
            continue
        else:
            raise RuntimeError("Unknown line difference. (Release) {} <-> (Debug) {}".format(releaseLine, debugLine))

    with open(os.path.join(dst, "openusdTargets.cmake"), mode="w") as fp:
        fp.writelines(outputLines)

    for root, config in [(releaseRoot, "release"), (debugRoot, "debug")]:
        src = os.path.join(root, f"cmake/pxrTargets-{config}.cmake") if root else None
        if src and os.path.exists(src):
            with open(src, mode="r") as fpr:
                with open(os.path.join(dst, f"openusdTargets-{config}.cmake"), mode="w") as fpw:
                    fpw.write(fpr.read().replace("${_IMPORT_PREFIX}", f"{{{{ openUsd.rootDir.{config} }}}}"))


if __name__ == "__main__":
    convert("S:/dist/pxr/OpenUSD-23.11/install/usd",
            "S:/dist/pxr/OpenUSD-23.11/install/usd_d",
            "usd-2311/cmake/win64/_")

    convert("S:/dist/pxr/OpenUSD-23.11/install/python39",
            "S:/dist/pxr/OpenUSD-23.11/install/python39_d",
            "usd-2311/cmake/win64/py39")
