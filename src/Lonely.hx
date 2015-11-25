package;

class Lonely
{
    public static function main()
    {
        var i : ILonelyInterface = new LonelyImplementation();

        i.doSomething();
    }

    static function doAThing(i : ILonelyInterface) : Int
    {
        i.doSomething();
        return 100;
    }
}


interface ILonelyInterface
{
    function doSomething() : Void;
}


private class LonelyImplementation implements ILonelyInterface
{
    public function doSomething() : Void
    {
        trace("Hello, world!");
    }

    public function new()
    {
    }
}