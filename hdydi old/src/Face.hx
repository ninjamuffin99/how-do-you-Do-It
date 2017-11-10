import org.flixel.*;

class Face extends FlxSprite
{
    @:meta(Embed(source="../assets/faces_strip.png"))
private var ImgFace : Class<Dynamic>;
    @:meta(Embed(source="../assets/blush.png"))
private var ImgBlush : Class<Dynamic>;
    
    public var blush : FlxSprite;
    
    public function new(x : Float, y : Float)
    {
        super(x, y);
        loadGraphic(ImgFace, true, true, 205, 202, true);
        addAnimation("neutral", [0], 1, false);
        addAnimation("blink", [2, 3, 2, 0], 12, false);
        addAnimation("lookaside", [1, 0], 2, false);
        addAnimation("excited", [4]);
        addAnimation("disgusted", [5]);
        addAnimation("confused", [6]);
        addAnimation("surprised", [7]);
        play("neutral");
        FlxG.state.add(this);
        
        blush = new FlxSprite(x, y);
        blush.loadGraphic(ImgBlush, true, true, 205, 202, true);
        FlxG.state.add(blush);
        blush.alpha = 0;
    }
    
    override public function update() : Void
    {
        super.update();
        
        var pick : Float = FlxG.random() * 400;
        if (pick < 1)
        {
            play("lookaside");
        }
        else if (pick < 2)
        {
            play("blink");
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
    
    public function decreaseBlush() : Void
    {
        if (blush.alpha > 0)
        {
            blush.alpha -= .002;
        }
    }
}

