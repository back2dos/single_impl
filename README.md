# single_impl

Macro based POC to substitute interfaces with only one implementor by said implementor. See https://github.com/HaxeFoundation/haxe/issues/4603

## First approach: `single_impl.FirstPass`  
  
The basic idea is to compile the app in two passes to gather the necessary information. The first pass runs with `--no-output` where in `onGenerate` we determine which interfaces can be eliminated. We then launch a second compilation, where we use `--macro addGlobalMetaData` to add a `@:genericBuild` directive to all interfaces that should be erased, that will do the actual erasing. For the time being we ignore everything that has type parameters to avoid ensuing issues.

The Main.hx in the sources shows the expected results. Here is the result of a somewhat bigger compilation benchmark:
  
```
Total time : 7.735s << second pass
------------------------------------
  filters : 6.353s, 82%
  generate js : 0.018s, 0%
  macro execution : 1.213s, 16%
  other : 0.001s, 0%
  parsing : 0.063s, 1%
  typing : 0.088s, 1%
  
Total time : 14.203s << first + second pass
------------------------------------
  command : 7.761s, 55% << this is caused solely by the second pass
  filters : 6.405s, 45%
  macro execution : 0.003s, 0%
  module cache check : 0.007s, 0%
  other : 0.001s, 0%
  parsing : 0.016s, 0%
  typing : 0.011s, 0%
```

We can see about 100% increase in compilation time, which doesn't seem too surprising.

The approach also works with the compilation server, although it busts the cache of every module that depends on a substituted interface.

Run by either running the FD project or through `haxe single_impl.hxml && node bin/singleimpl.js`. To run benchmark, either use `bechnmark.hxml` instead or add `-D benchmark` and `--times`.

## Second approach: `single_impl.Sweep`

A simpler approach is to sweep all types onGenerate to determine orphans (this is common with the first approach, hence the corresponding code has been moved to `single_impl.Filter`) and then exclude the intefaces from compilation, mark then with `@:remove` and `@:native` to substitute them be the implementation before generation.