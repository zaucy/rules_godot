load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

_godot_win64_build_file_content = """
package(default_visibility = ["//visibility:public"])
alias(
    name = "godot",
    actual = "Godot_v{version}-stable_win64.exe",
)
"""

_godot_win32_build_file_content = """
package(default_visibility = ["//visibility:public"])
alias(
    name = "godot",
    actual = "Godot_v{version}-stable_win32.exe",
)
"""

_godot_macos_build_file_content = """
package(default_visibility = ["//visibility:public"])
alias(
    name = "godot",
    actual = "Godot.app/Contents/MacOS/Godot",
)
"""

_godot_x11_32_build_file_content = """
package(default_visibility = ["//visibility:public"])
alias(
    name = "godot",
    actual = "Godot_v{version}-stable_x11.32",
)
"""

_godot_x11_64_build_file_content = """
package(default_visibility = ["//visibility:public"])
alias(
    name = "godot",
    actual = "Godot_v{version}-stable_x11.64",
)
"""

def _is_windows(os_name):
    return os_name == "windows 10"

def _rctx_platform_info(rctx):
    os = "unknown"
    cpu = "unknown"

    if _is_windows(rctx.os.name):
        os = "windows"

    if os == "windows":
        # https://docs.microsoft.com/en-us/archive/blogs/david.wang/howto-detect-process-bitness
        if rctx.os.environ["PROCESSOR_ARCHITECTURE"] == "AMD64":
            cpu = "x86_64"
        elif rctx.os.environ["PROCESSOR_ARCHITECTURE"] == "x86":
            cpu = "x86_32"
        elif rctx.os.environ["PROCESSOR_ARCHITEW6432"] == "AMD64":
            cpu = "x86_64"

    return struct(os = os, cpu = cpu)

def _rctx_platforms_cpu(rctx):
    pass

def _alias_repository(rctx):
    platform_info = _rctx_platform_info(rctx)
    platform_key = "%s-%s" % (platform_info.cpu, platform_info.os)

    if not platform_key in rctx.attr.platform_repositories:
        fail("Missing %s in %s platform_repositories" % (platform_key, rctx.name))

    alias_repo_name = rctx.attr.platform_repositories[platform_key]

    common_package_targets = {}

    for common_target in rctx.attr.common_targets:
        common_target_label = Label(common_target)
        if not common_target_label.package in common_package_targets:
            common_package_targets[common_target_label.package] = []
        common_package_targets[common_target_label.package].append(
            common_target_label.name
        )

    for pkg in common_package_targets:
        pkg_prefix = pkg if len(pkg) == 0 else pkg + "/"
        build_file_path = rctx.path(pkg_prefix + "BUILD.bazel");

        build_file_contents = ["package(default_visibility = [\"//visibility:public\"])"]

        for target in common_package_targets[pkg]:
            build_file_contents.append("alias(name = \"%s\", actual = \"@%s//%s:%s\")" % (target, alias_repo_name, pkg, target))

        rctx.file(build_file_path, "\n".join(build_file_contents))

alias_repository = repository_rule(
    implementation = _alias_repository,
    local = True,
    attrs = {
        "common_targets": attr.string_list(
            mandatory = True,
        ),
        "platform_repositories": attr.string_dict(
            mandatory = True,
            doc = "String dictionary where the keys are the format {cpu}-{os} and the value is the repository name for that cpu + os."
        ),
    },
)

_godot_repositories = {
    "3.3.4": {
        "godot_win64": struct(
            urls = ["https://downloads.tuxfamily.org/godotengine/3.3.4/Godot_v3.3.4-stable_win64.exe.zip"],
            sha256 = "d8214d125835b5771883e33c6bb3e12a2d6ee22afdd2807619afc75806a770a7",
            build_file_content = _godot_win64_build_file_content,
        ),
        "godot_win32": struct(
            urls = ["https://downloads.tuxfamily.org/godotengine/3.3.4/Godot_v3.3.4-stable_win32.exe.zip"],
            sha256 = "afa366b1494ad85510bd82379ea3f8d0ab946bdc29c53a555c2fed67a2f11929",
            build_file_content = _godot_win32_build_file_content,
        ),
        "godot_macos": struct(
            urls = ["https://downloads.tuxfamily.org/godotengine/3.3.4/Godot_v3.3.4-stable_osx.universal.zip"],
            sha256 = "acc4392f3ebee7a77e815c0fcf88cab276581bd6b284482298d0f359ddeda1d9",
            build_file_content = _godot_macos_build_file_content,
        ),
        "godot_x11_32": struct(
            urls = ["https://downloads.tuxfamily.org/godotengine/3.3.4/Godot_v3.3.4-stable_x11.32.zip"],
            sha256 = "fa0f525105e05de4fee78ec5bcb95c336f4d788034109be7d5a84072fadfe545",
            build_file_content = _godot_x11_32_build_file_content,
        ),
        "godot_x11_64": struct(
            urls = ["https://downloads.tuxfamily.org/godotengine/3.3.4/Godot_v3.3.4-stable_x11.64.zip"],
            sha256 = "d1c1d2ef314505a64fe37a8f23dd374e7992767e39987f67399641fd46dfeea7",
            build_file_content = _godot_x11_64_build_file_content,
        ),
    },
    "3.2": {
        "godot_win64": struct(
            urls = ["https://downloads.tuxfamily.org/godotengine/3.2/Godot_v3.2-stable_win64.exe.zip"],
            sha256 = "a8c8fdebf939dba0b687c0af9b87b615d23bcbf86184226bd9c23fa93f9eeb23",
            build_file_content = _godot_win64_build_file_content,
        ),
        "godot_win32": struct(
            urls = ["https://downloads.tuxfamily.org/godotengine/3.2/Godot_v3.2-stable_win32.exe.zip"],
            sha256 = "ae83afed5afb53a8c75cab60f813d3b1fa8b4b6b6572e449229883a023a6a7f1",
            build_file_content = _godot_win32_build_file_content,
        ),
        "godot_macos": struct(
            urls = ["https://downloads.tuxfamily.org/godotengine/3.2/Godot_v3.2-stable_osx.64.zip"],
            sha256 = "3b85748ed69db31e7c024a06df863f228e2f5ed8cf0587551bc64ce72b498c88",
            build_file_content = _godot_macos_build_file_content,
        ),
        "godot_x11_32": struct(
            urls = ["https://downloads.tuxfamily.org/godotengine/3.2/Godot_v3.2-stable_x11.32.zip"],
            sha256 = "5634b0f2f0264a855c6f39b4eaa84b1cd75c6c6be26ec10d1e8b9c3892f0f8e5",
            build_file_content = _godot_x11_32_build_file_content,
        ),
        "godot_x11_64": struct(
            urls = ["https://downloads.tuxfamily.org/godotengine/3.2/Godot_v3.2-stable_x11.64.zip"],
            sha256 = "91c383411e300a264dcfde637505574688ec06ba6d6946a53988f93ddaf1e239",
            build_file_content = _godot_x11_64_build_file_content,
        ),
    },
}

def godot_repositories(version = "3.3.4"):

    version_repos = _godot_repositories.get(version, None)

    if version_repos == None:
        fail("godot version {} not supported".format(version))

    for repo in version_repos:
        version_info = version_repos[repo]

        http_archive(
            name = repo,
            urls = version_info.urls,
            sha256 = version_info.sha256,
            build_file_content = version_info.build_file_content.format(
                version = version,
            ),
        )

    alias_repository(
        name = "godot",
        common_targets = [
            "//:godot",
        ],
        platform_repositories = {
            "x86_64-windows": "godot_win64",
            "x86_32-windows": "godot_win32",
        },
    )
