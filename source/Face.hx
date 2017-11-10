package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author ninjaMuffin
 */
class Face extends FlxSprite 
{

	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		
		loadGraphic(AssetPaths.faces_strip__png, true, 205, 202);
		animation.add("neutral", [0], 1, false);
		animation.add("blink", [2, 3, 2, 0], 12, false);
		animation.add("lookaside", [1, 0], 2, false);
		animation.
	}
	
}