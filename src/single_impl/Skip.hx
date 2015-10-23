package single_impl;

#if macro
import haxe.macro.Expr;
import haxe.macro.Context;
using haxe.macro.Tools;
#end

class Skip {
  /**
   * This is intended to be called as a `@:genericBuild` macro on an interface that should be substituted, 
   * where `name` is the "."-separated path to the implementor
   */
  macro static function build(name:String):ComplexType {
    
    switch Context.getLocalType() {//this always points to the interface
      case TInst(_.get() => cl, _):
        cl.exclude();//discard it
      default:
    }
    
    var pos = Context.currentPos();
    var sPos = Std.string(pos);
    
    return
      /**
       * Check if we're in an implements clause or not. If we are, return Nada, otherwise the implementation
       * 
       * The check to determine the difference between both cases is very crude. It looks whether the call site is a single line or spans multiple lines,
       * the latter of which is indicative of an `implements` clause. Will fail on single line class declarations or multiline type declarations.
       */
      if (sPos.indexOf('characters') == -1) 
        macro : single_impl.Nada;
      else 
        name.toComplex();
  }
  
}