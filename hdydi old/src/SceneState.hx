import org.flixel.*;

class SceneState extends TimedState
{
    @:meta(Embed(source="../assets/bgm.mp3"))
private var SndBGM : Class<Dynamic>;
    
    public var _text : String;
    public var nextState : FlxState;
    
    public function new(_text : String, next : FlxState)
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
        
        if (FlxG.music == null)
        {
            FlxG.playMusic(SndBGM, ggj.VOLUME);
        }
        else
        {
            FlxG.music.resume();
            if (!FlxG.music.active)
            {
                FlxG.playMusic(SndBGM, ggj.VOLUME);
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

