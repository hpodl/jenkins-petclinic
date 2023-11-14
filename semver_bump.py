"""
Script that reads the latest git tag of active repository,
assuming it's a valid semver string and bumps it according
to the second argument.
Arg: MAJOR | MINOR [default] | PATCH

If tags not found or invalid, sets version to 1.0.0.
"""

from sys import argv
from subprocess import run, CalledProcessError

import semver as sv


def bump_version(ver: str, to_bump: str) -> str:
    """
    Bumps semver string `version` based on `to_bump` argument
    """
    to_bump = to_bump.upper()

    try:
        if to_bump == "MAJOR":
            return sv.bump_major(ver)
        elif to_bump == "MINOR":
            return sv.bump_minor(ver)
        elif to_bump == "PATCH":
            return sv.bump_patch(ver)

    except ValueError:
        return "1.0.0"

    print("Specify valid bump target: MAJOR | MINOR | PATCH")
    exit(-1)


if __name__ == "__main__":
    bump = "MINOR"
    if len(argv) == 2:
        bump = argv[1]

    version = ""
    try:
        version = run(
            ["git", "describe", "--tags", "--abbrev=0"], capture_output=True, check=True
        ).stdout

    except CalledProcessError:
        # 'git describe' returned non-zero code, most likely there's no tags
        version = "invalid semver so that it triggers ValueError inside bump_version"

    print(bump_version(version, bump))
