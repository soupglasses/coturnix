import argparse
import os
import sys
import json
import subprocess
from enum import Enum
from pathlib import Path
from http.client import HTTPSConnection

from genpatch.helper import find_upwards

Style = Enum("Style", ["BUILTIN", "LIB", "SELF"])


CWD = os.getcwd()
PROJECT_NAME = "coturnix"
HEADERS = {
    "Accept": "application/json, text/plain; charset=utf-8",
    "User-Agent": "getpatch/0.0.1",
}


def choose_style(style: str) -> Style:
    # for PROJECT_NAME: if in CWD -> self, if in flake.lock -> lib, otherwise builtin
    match style:
        case "builtin":
            return Style.BUILTIN
        case "lib":
            return Style.LIB
        case "self":
            return Style.SELF
        case "auto":
            if PROJECT_NAME in CWD:
                return Style.SELF

            if flake_lock_path := find_upwards(Path(CWD), "flake.lock"):
                with open(flake_lock_path, "r") as flake_lock:
                    # TODO: This is very hacky way to "parse" the json file.
                    if PROJECT_NAME in flake_lock.read():
                        return Style.LIB

            return Style.BUILTIN
        case _:
            raise Exception(f"Unknown Style type: {style!r}")


def fetch_nixpkgs_pr_metadata(pr: str):
    conn = HTTPSConnection("api.github.com")
    conn.request("GET", f"/repos/NixOS/nixpkgs/pulls/{pr}", {}, HEADERS)
    response = conn.getresponse()
    if response.status != 200:
        data = response.read().decode("utf-8")
        conn.close()
        raise Exception(f"Failure {response.status} {response.reason}: " + data)
    else:
        data = json.load(response)
        conn.close()
    return data


def print_nixpkgs_pr(pr_number, metadata, style: Style = Style.BUILTIN) -> None:
    latest_commit = metadata["head"]["sha"]
    base_commit = metadata["base"]["sha"]
    last_updated_at = metadata["updated_at"][:10]
    pr_title = metadata["title"]
    patch_url = f"https://github.com/NixOS/nixpkgs/compare/{base_commit}...{latest_commit}.patch"
    sha256_sum = subprocess.run(
        ["nix-prefetch-url", "--quiet", patch_url],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    ).stdout.decode("utf-8")[:-1]
    lib_name = "self" if style == Style.SELF else PROJECT_NAME

    print(
        f"# {pr_title} [{last_updated_at}]",
        "-",
        f"https://nixpk.gs/pr-tracker.html?pr={pr_number}",
    )
    if style == Style.BUILTIN:
        print(
            "(builtins.fetchurl {",
            f'  url = "{patch_url}";',
            f'  sha256 = "{sha256_sum}";',
            "})",
            sep="\n",
        )
    else:
        print(
            f"({lib_name}.lib.fetchPatchFromNixpkgs {{",
            f'  from = "{base_commit}";',
            f'  to = "{latest_commit}";',
            f'  sha256 = "{sha256_sum}";',
            "})",
            sep="\n",
        )

def main():
    parser = argparse.ArgumentParser(
        prog="genpatch",
        description="generates static nixpkgs pr patch urls for use in patching nixpkgs",
    )
    parser.add_argument("pr", nargs="+", help="a pr number from nixpkgs's github page")
    parser.add_argument(
        "--style",
        choices=("builtin", "lib", "self", "auto"),
        default="auto",
        help="choose function style to return",
    )
    user_input = parser.parse_args(sys.argv[1:])

    style = choose_style(user_input.style)
    for pr_number in user_input.pr:
        pr_metadata = fetch_nixpkgs_pr_metadata(pr_number)
        print_nixpkgs_pr(pr_number, pr_metadata, style=style)

if __name__ == "__main__":
    main()
