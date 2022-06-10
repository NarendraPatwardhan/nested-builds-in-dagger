# Nested Builds in Dagger

This is a minimal repository to explore nesting inside docker.#Build with the primary purpose of overcoming the limitations mentioned in https://github.com/dagger/dagger/issues/1466

The primary logic to replace current docker.#Build resides in build.cue

A comparative build (old-style flattened and new nested) is defined in image.cue.

To perform the comparison, run the following commands:

1. Fetch dependencies
```
dagger project update
```

2. Build and print comparison
```
make run
```

The result should print images that are identical.