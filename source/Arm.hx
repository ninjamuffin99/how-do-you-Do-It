package;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.text.FlxText;

/**
 * ...
 * @author ninjaMuffin
 */
class Arm 
{
	public var m_physScale:Float = 30;
    
    public var forearm:FlxSprite;
    public var hand:FlxSprite;
    public var fingers:FlxSprite;
    
    public var heldDoll:DollGrabber;
    public var armBase:FlxPoint;
    
    public var debugText:FlxText;
	
	public function new(x:Float, doll:DollGrabber, rt:Bool = false) 
	{
		debugText = new FlxText(0, 30, FlxG.width, "");
		if (rt)
		{
			FlxG.state.add(debugText);
		}
	}
	
}