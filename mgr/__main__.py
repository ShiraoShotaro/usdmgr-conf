import sys
import os


def main(args):
    from mgr.download import download
    from mgr.install import install
    if not os.path.isdir(args.output):
        raise RuntimeError(f"{args.output} is not existing.")

    if args.python == "off":
        args.python = None

    outputDestination = os.path.abspath(args.output)
    download(outputDestination, args.usd, args.python, args.debug, args.release)
    install(outputDestination, args.usd, args.python, args.pythonPath, args.debug, args.release)


if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument("output", type=str, help="Path to output directory")
    parser.add_argument("--usd",
                        choices=["2311"],
                        default="2311",
                        help="USD Version")
    parser.add_argument("--python",
                        choices=["off", "39"],
                        default="off",
                        help="Python version. (Default: Disable python.)")
    parser.add_argument("--debug",
                        action="store_true",
                        default=False,
                        help="With Debug.")
    parser.add_argument("--no-debug",
                        action="store_false",
                        dest="debug",
                        help="Without Debug.")
    parser.add_argument("--release",
                        action="store_true",
                        default=True,
                        help="With Release.")
    parser.add_argument("--no-release",
                        action="store_false",
                        dest="release",
                        help="Without Release.")
    parser.add_argument("--pythonPath", type=str, default=None,
                        help="python がインストールされているディレクトリパス.")
    args = parser.parse_args()

    if args.debug is False and args.release is False:
        exit(0)

    main(args)
