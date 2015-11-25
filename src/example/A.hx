package example;

class A implements I {
  public function new() { 
    var sub:SubType = new B();
    function foo(sub:SubType) { }
    foo2(new D()); 
  }
  public function aMethod() 
    trace('Lo and behold: aMethod just got called!'); 
    
  //public function foo(sub:SubType) {}
  //public function bar(sub:I2) {}
  public function foo2(sub:SubType2) {
    
  }
}

interface SubType { }
interface SubType2 { }

class B implements SubType {
  public function new() {}
}

class C implements I2 {
  
}