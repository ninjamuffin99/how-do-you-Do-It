package;

import box2D.dynamics.B2World;
import box2D.dynamics.joints.B2MouseJoint;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

class PlayState extends TimedState
{
	
	public var m_physScale:Float = 30;
    public var m_world:B2World;
    public var m_mouseJoint:B2MouseJoint;
    public var dollLGrabber:DollGrabber;
    public var dollRGrabber:DollGrabber;
    public var dollL:PhysicsDoll;
    public var dollR:PhysicsDoll;
    public var dollController:DollController;
    public var dollCollision:DollContactListener;
    public static var mouseXWorldPhys:Float;
    public static var mouseYWorldPhys:Float;
    public static var mouseXWorld : Float;
    public static var mouseYWorld : Float;
    
    public var thinking : ScrollingText;
    public var thinking_two : ScrollingText;
    public var thinking_counter : Float = 0;
    public var bubble_width : Float = FlxG.width / 2;
    public var face : Face;
    public var body : FlxSprite;
    public var lArm : Arm;
    public var rArm : Arm;
    
    public var debugText : FlxText;
    public var started : Bool;
    public var smoke : FlxSprite;
    public var howText1 : FlxText;
    public var howText2 : FlxText;
	
	override public function create():Void
	{
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}