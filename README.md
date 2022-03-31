Test repository for adding extra dependencies programatically via haskell.nix.


### Goal

Take a flake input and a list of subdirectories. Add the cabal packages defined there as dependencies to the main package (`mypackage`).

### Approach

Generate package definitions for each dependency package with `cabal-to-nix`, add them to the package's `pkg-def-extras`. 


Result:

````nix develop````
```
...
[__1] unknown package: mydep (dependency of mypackage)
...
```
Cabal can't find the package.

This is because `cabalProject` first calls `callCabalProjectToNix` which doesn't use `pkg-def-extras`.


### What now?

`callCabalProjectToNix` has two ways to include extra packages:

    - via `cabalProjectLocal` and friends
    - via `configureArgs` `--package-db`

Let's try to generate a package db with haskell.nix and use `--package-db`.
