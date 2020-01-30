def godot_binary_alias(name):
    native.alias(
        name = name,
        actual = select({
            # "@bazel_tools//src/conditions:linux_x86_64": "",
            "@bazel_tools//src/conditions:darwin_x86_64": "@godot_osx_64//:{}".format(name),
            "@bazel_tools//src/conditions:darwin": "@godot_osx_64//:{}".format(name),
            "@bazel_tools//src/conditions:host_windows": "@godot_win64//:{}".format(name),
            "@bazel_tools//src/conditions:host_windows_msvc": "@godot_win64//:{}".format(name),
            "@bazel_tools//src/conditions:host_windows_msys": "@godot_win64//:{}".format(name),
        }),
    )
