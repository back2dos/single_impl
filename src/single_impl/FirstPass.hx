package single_impl;
import haxe.macro.Compiler;
import haxe.macro.Context;
import haxe.macro.Type;

class FirstPass {
  static function nameOf(b:BaseType) 
    return b.pack.concat([b.name]).join('.');
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
      //Maps interface names to implementations
      var interfaces = new Map<String, Array<String>>();
      
      //loop through all types to populate said map based on all classes found
      for (t in types)
        switch t {
          case TInst(_.get() => cl, params) if (!cl.isInterface):
            
            var clName = nameOf(cl);
            
            for (i in cl.interfaces) if (i.params.length == 0) {
              
              var name = nameOf(i.t.get());
              
              switch interfaces[name] {
                case null:
                  interfaces[name] = [clName];
                case v:
                  v.push(clName);
              }
              
              if (params.length > 0)
                interfaces[name].push(clName);//Classes with parameters count twice, so that even if they are the only implementor, they are not elligble for substitution
            }
          default:
        }
        
      //loop through all interfaces found  
      for (name in interfaces.keys())
        switch interfaces[name] {
          case []: //no implementations - do something?
          case [v]:
            //this somewhat cryptic compiler macro adds the appropriate @:genericBuild metadata to our interface
            args.push('--macro');
            args.push('addGlobalMetadata(\'$name\', \'@:genericBuild(single_impl.Skip.build(\\\'$v\\\'))\', false, true, false)');
          default:
        }
        
      args.push('-D');
      args.push('second_pass');
      
      Sys.command('haxe', args);
    });
    
  }
  
}