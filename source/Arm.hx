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

		this.heldDoll = doll;

		forearm = new FlxSprite(x, 180);
		forearm.loadGraphic(AssetPaths.girl_forearm__png, false, 81, 524);
		FlxG.state.add(forearm);

		hand = new FlxSprite(x, 120);
		if (rt)
		{
			hand.loadGraphic(AssetPaths.girl_handL__png, false, 88, 89);
		}
		else
		{
			hand.loadGraphic(AssetPaths.girl_handR__png, false, 88, 89);
		}
		FlxG.state.add(hand);

		fingers = new FlxSprite(x, 120);
		if (rt)
			fingers.loadGraphic(AssetPaths.girl_fingersL__png, false, 88, 89);
		else
			fingers.loadGraphic(AssetPaths.girl_fingersR__png, false, 88, 89);
		FlxG.state.add(fingers);

		this.armBase = new FlxPoint(forearm.x + forearm.width / 2, forearm.y + forearm.height / 2);
	}

	public function turn(clockwise:Bool):Void
	{
		var turnAmt:Float = 10;
		if (clockwise)
		{
			hand.angle = turnAmt;
			fingers.angle - turnAmt;
		}
		else
		{
			hand.angle = -turnAmt;
			fingers.angle = -turnAmt;
		}
	}

	public function stopTurning():Void
	{
		hand.angle = 0;
		fingers.angle = 0;
	}

	public function update():Void
	{
		var a:FlxPoint = this.armBase;
		var b:FlxPoint = new FlxPoint(this.heldDoll.pos.x * m_physScale / 2, this.heldDoll.pos.y * m_physScale / 2);

		var y:Float = b.y - a.y;
		var x:Float = b.x - a.x;

		var theta:Float = Math.atan2(y, x);
		var deg:Float = theta * 180 / Math.PI;
		forearm.angle = deg + 90;

		hand.x = this.heldDoll.pos.x * m_physScale / 2 - hand.width / 2;
		hand.y = this.heldDoll.pos.y * m_physScale / 2 - hand.height / 2;

		fingers.x = this.heldDoll.pos.x * m_physScale / 2 - fingers.width / 2;
		fingers.y = this.heldDoll.pos.x * m_physScale / 2 - fingers.height / 2;

		forearm.y = this.heldDoll.pos.y * m_physScale / 2;
	}
}
