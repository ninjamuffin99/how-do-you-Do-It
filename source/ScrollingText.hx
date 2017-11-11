package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;

/**
 * ...
 * @author ninjaMuffin
 */
class ScrollingText extends FlxText 
{

	public var thoughts : Array<Dynamic> = new Array<Dynamic>(
        "...she's gone.", 
        "Rose... Jack...", 
        "Why was it so cloudy in there?", 
        "In the car on the Titanic...", 
        "Clouds don't go in cars...", 
        "They were hugging all like...", 
        "I don't hug mommy like that.", 
        "I hope she doesn't see this...", 
        "Don't... people usually stand and hug?", 
        "What kind of a hug is a hug on the floor?", 
        "Like this...?", 
        "How many hugs are there?", 
        "There's a lot about hugging I don't know.", 
        "I hope she doesn't see this...", 
        "They kissed too...", 
        "Kissing seems nice.", 
        "Mimi said that grown-ups have sex and...", 
        "Maybe sex is lot of kissing and hugging.", 
        "Mom doesn't like that word...", 
        "Why doesn't she like it?", 
        "I hope she doesn't see this...", 
        "Why doesn't she like... sex?", 
        "I wish I knew what sex was.");
    public var thought_bubble : String = "";
    public var bubble_width : Float = FlxG.width / 2;
    public var pos_x : Float = FlxG.width - 105;
    public var pos_y : Float = 15;
    public var counter : Float = 0;
    public var frame_counter : Float = 0;
    public var paused : Bool = true;
    public var thought_img : FlxSprite;
    public var c1 : Float = 0;
    
    public function new()
    {
        super(pos_x, pos_y, 90, Reflect.field(thoughts, Std.string(counter)));
        // this.setFormat("Minecraftia-Regular", 8, 0xff000000, "left");
        thought_img = new FlxSprite(178, 3);
        thought_img.loadGraphic(AssetPaths.thoughts__png, true, 420 / 3, 114);
        thought_img.addAnimation("mid", [1], 12, false);
        thought_img.addAnimation("small", [2], 12, false);
        FlxG.state.add(thought_img);
        thought_img.play("mid");
        this.color = 0xFFAAAAAA;
    }
    
    override public function update():Void
    {
        super.update();
        frame_counter++;
        c1++;
        
        if (c1 > 200)
        {
            thought_img.animation.play("mid");
        }
        
        if (c1 > 300)
        {
            thought_img.animation.play("small");
        }
        
        if (c1 > 400)
        {
            thought_img.animation.play("mid");
            c1 = 0;
        }
        
        if (frame_counter % 150 == 0 && !paused)
        {
            counter++;
            if (counter >= thoughts.length)
            {
                counter = 0;
            }
            this.text = Reflect.field(thoughts, Std.string(counter));
        }
    }
	
}