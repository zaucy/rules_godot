load("@rules_godot//internal:util.bzl", "godot_binary_alias")

package(default_visibility = ["//visibility:public"])

godot_binary_alias("godot")
