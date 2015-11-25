package single_impl;

import haxe.macro.Type;
import haxe.macro.Context;

using single_impl.Filter;

class Sweep {

  static function use() {
    Context.onGenerate(function (types:Array<Type>) {
      for (x in types.getSingleImplementations()) {
        if (!x.orphan.meta.has(':remove')) {
          x.orphan.meta.add(':remove', [], x.impl.pos);
          x.orphan.meta.add(':native', [macro $v{x.impl.nameOf()}], x.impl.pos);
          x.orphan.exclude();
        }
      }
    });
  }
  
}