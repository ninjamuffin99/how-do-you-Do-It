import org.flixel.*;

class TimedState extends FlxState
{
    public var timeFrame : Float = 0;
    public var timeSec : Float = 0;
    public var endTime : Float = 30;
    
    override public function update() : Void
    {
        super.update();
        timeFrame++;
        
        if (timeFrame % 100 == 0)
        {
            timeSec++;
        }
        
        if (timeSec == this.endTime)
        {
            this.endCallback();
        }
    }
    
    public function endCallback() : Void
    {
    }

    public function new()
    {
        super();
    }
}
