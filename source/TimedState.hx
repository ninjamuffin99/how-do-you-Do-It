package;

import flixel.FlxState;

/**
 * ...
 * @author ninjaMuffin
 */
class TimedState extends FlxState 
{
	public var timeFrame:Float = 0;
	public var timeSec:Float = 0;
	public var endTime:Float = 30;

	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		timeFrame++;
		
		if (timeFrame % 100 == 0)
		{
			timeSec++;
		}
		
		if (timeSec == endTime)
			endCallback();
		
		
	}
	
	public function endCallback():Void
	{
		
	}
	
	public function new() 
	{
		super();
	}
	
}