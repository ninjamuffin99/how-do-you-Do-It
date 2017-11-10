package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author ninjaMuffin
 */
class Face extends FlxSprite 
{
	public var blush:FlxSprite;

	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		
		loadGraphic(AssetPaths.faces_strip__png, true, 205, 202);
		animation.add("neutral", [0], 1, false);
		animation.add("blink", [2, 3, 2, 0], 12, false);
		animation.add("lookaside", [1, 0], 2, false);
		animation.add("excited", [4]);
		animation.add("disgusted", [5]);
		animation.add("confused", [6]);
		animation.add("surprised", [7]);
		animation.play("neutral");
		FlxG.state.add(this);
		
		blush = new FlxSprite(x, y);
		blush.loadGraphic(AssetPaths.blush__png, false, 205, 202, true);
		FlxG.state.add(blush);
		blush.alpha = 0;
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		var pick:Float = FlxG.random.int(0, 1) * 400;
		if (pick < 1)
		{
			animation.play("lookaside");
		}
		else if (pick < 2)
		{
			animation.play("blink");
		}
		decreaseBlush();
		
	}
	
	public function increaseBlush() : Void
    {
        if (blush.alpha < 1)
        {
            blush.alpha += .2;
        }
    }
	
	public function decreaseBlush():Void
	{
		if (blush.alpha > 0)
		{
			blush.alpha -= 0.002;
		}
	}
	
}