package single_impl;

import haxe.macro.Type;

class Filter {
  
  static public function isSecondary(b:BaseType) 
    return b.isPrivate || b.module != nameOf(b);
    
  static public function nameOf(b:BaseType) 
    return 
      if (b == null) null 
      else b.pack.concat([b.name]).join('.');
  
  static public function getSingleImplementations(types:Array<Type>):Array<{ orphan:ClassType, impl: Null<ClassType> }> {
    var implementations = new Map<String, Array<ClassType>>(),
        interfaces = new Map<String, ClassType>();
      
    //loop through all types to populate said map based on all classes found
    for (t in types)
      switch t {
        case TInst(_.get() => cl, params) if (!cl.isInterface):
          
          var clName = nameOf(cl);
          
          function mark(c:ClassType)
            for (i in c.interfaces) if (i.params.length == 0) {
              var i = i.t.get();
              var name = nameOf(i);
              
              interfaces[name] = i;
              
              switch implementations[name] {
                case null:
                  implementations[name] = [cl];
                case v:
                  v.push(cl);
              }
              
              if (params.length > 0)
                implementations[name].push(cl);//Classes with parameters count twice, so that even if they are the only implementor, they are not elligible for substitution
                
              mark(i);
            }
          mark(cl);
        default:
      }
    
    var ret = [];
    //loop through all interfaces found  
    for (name in implementations.keys())
      switch implementations[name] {
        case []: ret.push({ orphan: interfaces[name], impl: null });
        case [v]: ret.push({ orphan: interfaces[name], impl: v });
        default:
      }    
      
    return ret;
  }
}