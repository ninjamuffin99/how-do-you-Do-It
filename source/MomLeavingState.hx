package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxPoint;
import flixel.util.FlxTimer;

/**
 * ...
 * @author ninjaMuffin
 */
class MomLeavingState extends TimedState
{
	public var mom_sprite:FlxSprite;
	public var girl1_sprite:FlxSprite;
	public var scene_time:Float = 3;
	public var current_scene:Float = 1;
	public var cameraTrack:FlxSprite;
	public var cam_moving:Bool = false;
	public var cam_target_point:FlxPoint;
	public var car_sprite:FlxSprite;
	public var girl2_sprite:FlxSprite;
	public var girl3_sprite:FlxSprite;
	public var dolls_sprite:FlxSprite;
	public var girlAnimLock:Bool = false;
	public var sceneLock:Bool = false;

	public var nextState:FlxState;
	public var time_frame:Float = 0;

	public function new(next:FlxState)
	{
		super();

		this.nextState = next;
	}

	override public function create():Void
	{
		FlxTimer.wait(12, () -> endCallback());

		cam_target_point = new FlxPoint(FlxG.width / 2, FlxG.height / 2);

		cameraTrack = new FlxSprite(FlxG.width / 2, FlxG.height / 2);
		cameraTrack.visible = false;
		add(cameraTrack);
		FlxG.camera.target = cameraTrack;

		var outside_bg:FlxSprite = new FlxSprite(0, 0);
		outside_bg.loadGraphic(AssetPaths.outside__png, true, 600, 185, true);
		add(outside_bg);
		outside_bg.scrollFactor.set(0.5, 0.5);

		car_sprite = new FlxSprite(250, 69);
		car_sprite.loadGraphic(AssetPaths.car__png, false, 104, 54);
		car_sprite.alpha = 0;
		add(car_sprite);
		car_sprite.scrollFactor.set(0.7, 0.7);

		var house_bg:FlxSprite = new FlxSprite();
		house_bg.loadGraphic(AssetPaths.house__png, true, Std.int(1500 / 2), 360);
		house_bg.animation.add("closed", [0], 1, false);
		house_bg.animation.add("open", [1], 1, false);
		add(house_bg);

		mom_sprite = new FlxSprite(22, 49);
		mom_sprite.loadGraphic(AssetPaths.mom1__png, false, 77, 151);
		add(mom_sprite);

		girl1_sprite = new FlxSprite(110, 98);
		girl1_sprite.loadGraphic(AssetPaths.girl1__png, false, 44, 121);
		add(girl1_sprite);

		girl2_sprite = new FlxSprite(293, 82);
		girl2_sprite.loadGraphic(AssetPaths.girl2__png, true, Std.int(216 / 4), 99);
		girl2_sprite.animation.add("run", [0, 1, 2, 3], 10, false);
		girl2_sprite.alpha = 0;
		add(girl2_sprite);

		girl3_sprite = new FlxSprite(525, 174);
		girl3_sprite.loadGraphic(AssetPaths.girl3__png, false, 60, 101);
		girl3_sprite.alpha = 0;
		add(girl3_sprite);

		dolls_sprite = new FlxSprite(598, 178);
		dolls_sprite.loadGraphic(AssetPaths.dolls__png, false, 76, 55);
		dolls_sprite.alpha = 0;
		add(dolls_sprite);

		if (FlxG.sound.music == null)
			FlxG.sound.playMusic(AssetPaths.bgm__mp3);
		else
		{
			FlxG.sound.music.resume();
			if (!FlxG.sound.music.active)
				FlxG.sound.playMusic(AssetPaths.bgm__mp3);
		}

		FlxG.sound.play(AssetPaths.dooropen__mp3);

		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if ((timeFrame / 100) % 3 == 0)
		{
			current_scene++;
			if (current_scene == 2)
			{
				FlxG.sound.play(AssetPaths.doorclose__mp3);
				cam_moving = true;
				cam_target_point.set(176 + (FlxG.width / 2), FlxG.height / 2);
			}
			if (current_scene == 3)
			{
				cam_moving = true;
				cam_target_point.set(389 + (FlxG.width / 2), 52 + FlxG.height / 2);
			}
		}

		if (Math.abs(cameraTrack.x - cam_target_point.x) < 10 && Math.abs(cameraTrack.y - cam_target_point.y) < 10)
		{
			cam_moving = false;
			if (current_scene == 2)
			{
				car_sprite.alpha += 0.02;
				girl2_sprite.alpha += 0.02;
				if (!girlAnimLock && girl2_sprite.alpha >= 1)
				{
					girl2_sprite.animation.play("run");
					FlxG.sound.play(AssetPaths.carleave__mp3);
					girlAnimLock = true;
				}
				if (!sceneLock)
				{
					sceneLock = true;
					FlxG.sound.play(AssetPaths.cardoor__mp3);
				}
			}
			if (current_scene == 3)
			{
				dolls_sprite.alpha += 0.02;
				girl3_sprite.alpha += 0.02;
			}
		}
		else
		{
			cameraTrack.velocity.x = cam_target_point.x - cameraTrack.x;
			cameraTrack.velocity.y = cam_target_point.y - cameraTrack.y;
		}

		if (current_scene == 2)
		{
			girl1_sprite.alpha -= 0.02;
			mom_sprite.alpha -= 0.02;
		}
		if (current_scene == 3)
		{
			girl2_sprite.alpha -= 0.02;
			car_sprite.alpha -= 0.02;
		}
	}

	override public function endCallback():Void
	{
		FlxG.switchState(nextState);
	}
}
