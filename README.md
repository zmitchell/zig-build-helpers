# zig-build-helpers

It's a little known fact that if you import a dependency in `build.zig` you import _its_ `build.zig`. This means that you can create a `build.zig` that contains a "library" of sorts for common operations in build scripts.

One example is adding a `zig build check` step so that `zls` can provide better feedback while editing. The `addCheckStep` helper makes it such that you don't need to remember how to do this yourself. Similarly, the `zig build run` step can be added with the `addRunStep` helper.

## License

Licensed under either of

 * Apache License, Version 2.0, ([LICENSE-APACHE](LICENSE-APACHE) or http://www.apache.org/licenses/LICENSE-2.0)
 * MIT license ([LICENSE-MIT](LICENSE-MIT) or http://opensource.org/licenses/MIT)

at your option.

### Contribution

Unless you explicitly state otherwise, any contribution intentionally
submitted for inclusion in the work by you, as defined in the Apache-2.0
license, shall be dual licensed as above, without any additional terms or
conditions.
