package example;

class A implements I {
  public function new() { }
  public function aMethod() 
    trace('Lo and behold: aMethod just got called!'); 
}

interface SubType { }

class B implements SubType {
  public function new() {}
}