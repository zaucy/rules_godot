# rules_godot

At the moment rules_godot only gives an executable target to run Godot and has only been tested on Windows.

```sh
bazel run @godot//:godot
```

## Install

Add rules_godot to your `WORKSPACE` file

```python
http_archive(
    name = "rules_godot",
    strip_prefix = "rules_godot-262f1497b8ebab6c0e7b25d653683146987e0c3d",
    url = "https://github.com/zaucy/rules_godot/archive/262f1497b8ebab6c0e7b25d653683146987e0c3d.zip",
    sha256 = "3f05765db213f1558e0241d321f3c90df799199238e7c2e7cbb28590550b63a6",
)

load("@rules_godot//:index.bzl", "godot_repositories")
godot_repositories()
```

## License

This repository is licensed under MIT. Keep in mind that these rules download [Godot](https://godotengine.org) which [has it's own license](https://godotengine.org/license) you must adhere to.
