import org.flixel.*;

class MenuState extends FlxState
{
    @:meta(Embed(source="../assets/title_screen.png"))
private var ImgBG : Class<Dynamic>;
    @:meta(Embed(source="../assets/bgm.mp3"))
private var SndBGM : Class<Dynamic>;
    
    public var startTime : Float;
    
    override public function create() : Void
    {
        startTime = Date.now().valueOf();
        FlxG.mouse.hide();
        var bg : FlxSprite = new FlxSprite(0, 0);
        bg.loadGraphic(ImgBG, true, true, 320, 240, true);
        add(bg);
        
        var t : FlxText;
        t = new FlxText(-9, FlxG.height / 2 + 20, FlxG.width, "Press any key to play");
        t.alignment = "right";
        t.color = 0xf9d0b4;
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
        
        // once music has looped for 5 minutes on this screen, silence it
        if (Date.now().valueOf() - startTime > 60 * 5 * 1000)
        {
            if (FlxG.music.active)
            {
                FlxG.music.stop();
            }
        }
        
        if (FlxG.keys.any())
        {
            FlxG.switchState(new MomLeavingState(new PlayState()));
        }
    }

    public function new()
    {
        super();
    }
}

