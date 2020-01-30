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
    strip_prefix = "rules_godot-fd69549a2bd0bfb9d031ae0d38f1c976dbf969c8",
    url = "https://github.com/zaucy/rules_godot/archive/fd69549a2bd0bfb9d031ae0d38f1c976dbf969c8.zip",
    sha256 = "d5bca5e26dbae0586d4fb5c6c55ce17f7a76cced7c1953007b2d61624e033826",
)

load("@rules_godot//:index.bzl", "godot_repositories")

godot_repositories()
```

## License

This repository is licensed under MIT. Keep in mind that these rules download [Godot](https://godotengine.org) which [has it's own license](https://godotengine.org/license) you must adhere to.
