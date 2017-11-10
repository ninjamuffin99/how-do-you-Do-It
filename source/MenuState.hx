package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

class MenuState extends FlxState
{
	//5 minutes, in seconds
	public var startTime:Float = 300;
	
	override public function create():Void
	{
        FlxG.mouse.visible = false;
        var bg:FlxSprite = new FlxSprite(0, 0);
        bg.loadGraphic(AssetPaths.title_screen__png, true, 320, 240, true);
        add(bg);
        
        var t:FlxText;
        t = new FlxText(-9, FlxG.height / 2 + 20, FlxG.width, "Press any key to play");
        t.alignment = "right";
        t.color = 0xFFf9d0b4;
        add(t);
        
        if (FlxG.sound.music == null)
        {
            FlxG.sound.playMusic(AssetPaths.bgm__mp3);
        }
        else
        {
            FlxG.sound.music.resume();
            if (!FlxG.sound.music.active)
            {
                FlxG.sound.playMusic(AssetPaths.bgm__mp3);
            }
        }
		
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		
		
		// once music has looped for 5 minutes on this screen, silence it
        if (startTime >= 0)
        {
            if (FlxG.sound.music.active)
            {
                FlxG.sound.music.stop();
            }
        }
		else
		{
			startTime -= FlxG.elapsed;
		}
        
        if (FlxG.keys.justPressed.ANY)
        {
            //FlxG.switchState(new MomLeavingState(new PlayState()));
        }
	}
}