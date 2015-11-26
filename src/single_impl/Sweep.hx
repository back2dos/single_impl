package single_impl;

import haxe.macro.Type;
import haxe.macro.Context;

using single_impl.Filter;

class Sweep {
  static function rename(c:ClassType, name:String) {
    c.meta.add(':remove', [], c.pos);
    c.meta.add(':native', [macro $v{name}], c.pos);
    c.exclude();    
  }
  static function use()
    Context.onGenerate(function (types:Array<Type>) 
      for (x in types.getSingleImplementations()) {
        if (!x.orphan.meta.has(':remove'))
          if (!x.orphan.isSecondary())
            if (x.impl == null) 
              rename(x.orphan, 'Dynamic');
            else
              if (!x.impl.isSecondary()) 
                rename(x.orphan, x.impl.nameOf());
      }
    );
  
}