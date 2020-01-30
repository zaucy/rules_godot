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

_godot_osx_64_build_file_content = """
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

def _godot_alias_repository(rctx):
    rctx.template(rctx.path("BUILD.bazel"), rctx.attr.build_file)

godot_alias_repository = repository_rule(
    implementation = _godot_alias_repository,
    local = True,
    attrs = {
        "build_file": attr.label(
            mandatory = True,
            allow_single_file = True,
        ),
    },
)

_godot_repositories = {
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
        "godot_osx_64": struct(
            urls = ["https://downloads.tuxfamily.org/godotengine/3.2/Godot_v3.2-stable_osx.64.zip"],
            sha256 = "3b85748ed69db31e7c024a06df863f228e2f5ed8cf0587551bc64ce72b498c88",
            build_file_content = _godot_osx_64_build_file_content,
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

def godot_repositories(version = "3.2"):

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

    godot_alias_repository(
        name = "godot",
        build_file = "@rules_godot//internal:godot_alias_repository.BUILD.tpl",
    )
