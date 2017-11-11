package;
import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;

/**
 * ...
 * @author ninjaMuffin
 */
class SceneState extends TimedState 
{
	public var _text:String;
    public var nextState:FlxState;
    
    public function new(_text:String, next:FlxState)
    {
        super();
        this._text = _text;
        this.nextState = next;
    }
    
    override public function create() : Void
    {
        endTime = 2;
        
        var t : FlxText;
        t = new FlxText(0, FlxG.height / 2 - 10, FlxG.width, _text);
        t.size = 16;
        t.alignment = "center";
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
    }
    
    override public function update() : Void
    {
        super.update();
    }
    
    override public function endCallback() : Void
    {
        FlxG.switchState(nextState);
    }
	
}