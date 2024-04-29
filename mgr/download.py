import os
import gdown
import shutil
import zstd
import tarfile
import io
import stat
import glob
from mgr import utils


_gurls = {
    "2311": {
        None: {
            "release": "1MoNvFv7XztzsLPN_TbGrflmqDlXt7PSa",
            "debug": "1cL_NqYdzAZkBHJEIg8_838ysnNbYwO3k",
        },
        "39": {
            "release": "1kLDVrlJ5lC-bx69KQD2-4JfTmS1qVSyU",
        },
    }
}


def download(dest: str, usdVersion: str, pythonVersion: str, debug: bool, release: bool):
    url = None

    configs = []
    if debug:
        configs.append("debug")
    if release:
        configs.append("release")

    for cfg in configs:
        try:
            url = "https://drive.google.com/uc?id={}".format(_gurls[usdVersion][pythonVersion][cfg])
        except KeyError:
            print(f"Not found: USD{usdVersion}, python{pythonVersion}, {cfg}")
            continue

        output = utils.generatePath(dest, usdVersion, pythonVersion, cfg)
        downloadDest = os.path.join(output, "package")
        if not os.path.exists(downloadDest):
            if os.path.exists(output):
                shutil.rmtree(output)
            os.makedirs(output, exist_ok=True)
            gdown.download(url, downloadDest)

        for root in os.listdir(output):
            if root != "package":
                for path in glob.glob(f"{output}/{root}/**", recursive=True):
                    if os.path.isfile(path) and not os.access(path, os.W_OK):
                        os.chmod(path, stat.S_IWUSR)
                print(f"Remove directory: {output}/{root}")
                shutil.rmtree(os.path.join(output, root))

        with open(downloadDest, mode="rb") as src:
            # TODO: SHA check
            dcdata = zstd.ZSTD_uncompress(src.read())

        dcdata_flo = io.BytesIO(dcdata)
        tar = tarfile.open(fileobj=dcdata_flo)
        for member in tar.getmembers():
            print(f"Extract: {member.name}")
            tar.extract(member, output)
