import org.flixel.*;

class EndState extends FlxState
{
    public var times : Float;
    public var caught : Bool;
    public var startTime : Float;
    
    public function new(sex : Float, caught : Bool)
    {
        super();
        times = sex;
        this.caught = caught;
    }
    
    override public function create() : Void
    {
        startTime = Date.now().valueOf();
        var t : FlxText;
        FlxG.mouse.hide();
        var textWidth : Float = FlxG.width;
        if (times == 1)
        {
            t = new FlxText(0, FlxG.height / 2 - 50, textWidth, "You might have done sex\n" + times + " time...?");
            t.setFormat("Minecraftia-Regular", 16, 0xffffffff, "center");
            add(t);
        }
        else
        {
            t = new FlxText(0, FlxG.height / 2 - 50, textWidth, "You might have done sex\n" + times + " times...?");
            t.setFormat("Minecraftia-Regular", 16, 0xffffffff, "center");
            add(t);
        }
        if (this.caught)
        {
            t.text += "\nEep! Mom saw!";
        }
        else
        {
            t.text += "\nAnd you didn't get caught!";
        }
        t = new FlxText(0, FlxG.height - 40, FlxG.width, "Press any key to play again");
        t.setFormat("Minecraftia-Regular", 16, 0xffffffff, "center");
        add(t);
    }
    
    override public function update() : Void
    {
        super.update();
        
        if (Date.now().valueOf() - startTime > 30 * 1000)
        {
            FlxG.switchState(new MenuState());
        }
        
        if (FlxG.keys.any())
        {
            FlxG.switchState(new MomLeavingState(new PlayState()));
        }
    }
}

