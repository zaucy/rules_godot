# rules_godot

At the moment rules_godot only gives an executable target to run Godot and has only been tested on Windows.

```sh
bazel run @godot//:godot
```

## License

This repository is licensed under MIT. Keep in mind that these rules download [Godot](https://godotengine.org) which [has it's own license](https://godotengine.org/license) you must adhere to.
