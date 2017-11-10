import org.flixel.*;

class MomReturningState extends TimedState
{
    @:meta(Embed(source="../assets/bgm.mp3"))
private var SndBGM : Class<Dynamic>;
    @:meta(Embed(source="../assets/doorclose.mp3"))
private var doorClose : Class<Dynamic>;
    @:meta(Embed(source="../assets/house.png"))
private var house : Class<Dynamic>;
    @:meta(Embed(source="../assets/outside.png"))
private var outside : Class<Dynamic>;
    @:meta(Embed(source="../assets/girl3.png"))
private var girl3 : Class<Dynamic>;
    @:meta(Embed(source="../assets/girl_caught.png"))
private var girl_caught : Class<Dynamic>;
    @:meta(Embed(source="../assets/girl_notcaught.png"))
private var girl_notcaught : Class<Dynamic>;
    @:meta(Embed(source="../assets/dolls.png"))
private var dolls : Class<Dynamic>;
    @:meta(Embed(source="../assets/mom1.png"))
private var mom : Class<Dynamic>;
    @:meta(Embed(source="../assets/mom_shock.png"))
private var mom_shock : Class<Dynamic>;
    
    public var nextState : FlxState;
    public var time_frame : Float = 0;
    
    public var cameraTrack : FlxSprite;
    public var cam_moving : Bool = false;
    public var cam_target_point : FlxPoint;
    public var scene_time : Float = 1;
    public var current_scene : Float = 1;
    public var girl3_sprite : FlxSprite;
    public var mom_sprite : FlxSprite;
    public var caught : Bool;
    
    public function new(next : EndState, caught : Bool)
    {
        super();
        this.nextState = next;
        this.caught = caught;
    }
    
    override public function create() : Void
    {
        endTime = 7;
        
        cam_target_point = new FlxPoint(389 + (FlxG.width / 2), 52 + FlxG.height / 2);
        
        cameraTrack = new FlxSprite(389 + (FlxG.width / 2), 52 + FlxG.height / 2);
        cameraTrack.visible = false;
        add(cameraTrack);
        FlxG.camera.target = cameraTrack;
        
        var outside_bg : FlxSprite = new FlxSprite(0, 0);
        outside_bg.loadGraphic(outside, true, true, 600, 185, true);
        add(outside_bg);
        outside_bg.scrollFactor = new FlxPoint(.5, .5);
        
        var house_bg : FlxSprite = new FlxSprite(0, 0);
        house_bg.loadGraphic(house, true, true, 1500 / 2, 360, true);
        house_bg.addAnimation("closed", [0], 1, false);
        house_bg.addAnimation("open", [1], 1, false);
        add(house_bg);
        
        if (this.caught)
        {
            girl3_sprite = new FlxSprite(525, 174);
            girl3_sprite.loadGraphic(girl_caught, true, true, 59, 95, true);
        }
        else
        {
            girl3_sprite = new FlxSprite(554, 171);
            girl3_sprite.loadGraphic(girl_notcaught, true, true, 108, 102, true);
        }
        add(girl3_sprite);
        
        if (this.caught)
        {
            mom_sprite = new FlxSprite(22, 29);
            mom_sprite.loadGraphic(mom_shock, true, true, 101, 174, true);
            mom_sprite.addAnimation("run", [0, 1], 3, true);
            mom_sprite.play("run");
        }
        else
        {
            mom_sprite = new FlxSprite(22, 49);
            mom_sprite.loadGraphic(mom, true, true, 77, 151, true);
        }
        add(mom_sprite);
        mom_sprite.alpha = 0;
        
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
        time_frame++;
        if (time_frame == 50)
        {
            FlxG.play(doorClose);
        }
        
        if ((timeFrame / 100) % 3 == 0)
        {
            current_scene++;
            if (current_scene == 2)
            {
                cam_moving = true;
                cam_target_point = new FlxPoint(FlxG.width / 2, FlxG.height / 2);
            }
        }
        
        if (Math.abs(cameraTrack.x - cam_target_point.x) < 10 && Math.abs(cameraTrack.y - cam_target_point.y) < 10)
        {
            cam_moving = false;
            if (current_scene == 2)
            {
                mom_sprite.alpha += .02;
            }
        }
        else
        {
            cameraTrack.velocity.x = cam_target_point.x - cameraTrack.x;
            cameraTrack.velocity.y = cam_target_point.y - cameraTrack.y;
        }
        
        if (current_scene == 2)
        {
            girl3_sprite.alpha -= .02;
        }
    }
    
    override public function endCallback() : Void
    {
        FlxG.switchState(nextState);
    }
}

