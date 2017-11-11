package;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxPoint;

/**
 * ...
 * @author ninjaMuffin
 */
class MomReturningState extends TimedState 
{
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
        
        cam_target_point.set(389 + (FlxG.width / 2), 52 + FlxG.height / 2);
        
        cameraTrack = new FlxSprite(389 + (FlxG.width / 2), 52 + FlxG.height / 2);
        cameraTrack.visible = false;
        add(cameraTrack);
        FlxG.camera.target = cameraTrack;
        
        var outside_bg : FlxSprite = new FlxSprite(0, 0);
        outside_bg.loadGraphic(outside, false, 600, 185);
        add(outside_bg);
        outside_bg.scrollFactor.set(.5, .5);
        
        var house_bg : FlxSprite = new FlxSprite(0, 0);
        house_bg.loadGraphic(house, true, Std.int(1500 / 2), 360);
        house_bg.animation.add("closed", [0], 1, false);
        house_bg.animation.add("open", [1], 1, false);
        add(house_bg);
        
        if (this.caught)
        {
            girl3_sprite = new FlxSprite(525, 174);
            girl3_sprite.loadGraphic(girl_caught,false, 59, 95);
        }
        else
        {
            girl3_sprite = new FlxSprite(554, 171);
            girl3_sprite.loadGraphic(girl_notcaught, false, 108, 102);
        }
        add(girl3_sprite);
        
        if (this.caught)
        {
            mom_sprite = new FlxSprite(22, 29);
            mom_sprite.loadGraphic(mom_shock, true, 101, 174);
            mom_sprite.animation.add("run", [0, 1], 3, true);
            mom_sprite.animation.play("run");
        }
        else
        {
            mom_sprite = new FlxSprite(22, 49);
            mom_sprite.loadGraphic(mom, false, 77, 151);
        }
        add(mom_sprite);
        mom_sprite.alpha = 0;
        
        if (FlxG.sound.music == null)
        {
            FlxG.playMusic(AssetPaths.bgm__mp3);
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
        time_frame++;
        if (time_frame == 50)
        {
            FlxG.sound.play(AssetPaths.doorclose__mp3);
        }
        
        if ((timeFrame / 100) % 3 == 0)
        {
            current_scene++;
            if (current_scene == 2)
            {
                cam_moving = true;
                cam_target_point.set(FlxG.width / 2, FlxG.height / 2);
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