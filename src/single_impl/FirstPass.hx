package single_impl;

import haxe.macro.Compiler;
import haxe.macro.Context;
import haxe.macro.Type;

using single_impl.Filter;

class FirstPass {
  /**
   * This is where the magic happens!
   */
  static function use() {
    #if second_pass
      return;//skip the second pass
    #end
    
    var args = Sys.args();
    
    //We require --no-output but have to remove it for the second pass
    if (!args.remove('--no-output'))
      Context.fatalError('Can only call `--macro single_impl.FirstPass.use()` with `--no-output` or `-D second_pass`', Context.currentPos());
    
    //Await the end of compilation
    Context.onGenerate(function (types:Array<Type>) {
      for (x in types.getSingleImplementations()) {
        args.push('--macro');
        args.push('addGlobalMetadata(\'${x.orphan.nameOf()}\', \'@:genericBuild(single_impl.Skip.build(\\\'${x.impl.nameOf()}\\\'))\', false, true, false)');        
      }
        
        
      args.push('-D');
      args.push('second_pass');
      
      Sys.command('haxe', args);
    });
    
  }
  
}