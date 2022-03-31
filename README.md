Test repository for adding extra dependencies programatically via haskell.nix.


### Goal

Take a flake input and a list of subdirectories. Add the cabal packages defined there as dependencies to the main package (`mypackage`).

### Approach

Generate package definitions for each dependency package with `cabal-to-nix`, add them to the package's `pkg-def-extras`. 


### Result

````nix develop````
```
...
[__1] unknown package: mydep (dependency of mypackage)
...
```
Cabal can't find the package.


### So...

What else needs to be added to the package? Build the package and add it to `hsPkgs`? or `packages` in modules?
