package;

import box2D.dynamics.B2ContactListener;
import box2D.dynamics.B2Fixture;
import box2D.dynamics.contacts.B2Contact;
import flixel.FlxG;
import flixel.text.FlxText;

/**
 * ...
 * @author ninjaMuffin
 */
class DollContactListener extends B2ContactListener 
{
	public var t : FlxText = new FlxText(200, 200, 100, "COLLIDING");
    public var face : Face;
    public var sex : Float = 0;
    public var isColliding : Bool = false;
    
    public function new(face : Face)
    {
        super();
        this.face = face;
    }
	
    
    override public function beginContact(contact:B2Contact):Void
    {
        var bodyA : B2Fixture = contact.getFixtureA();
        var bodyB : B2Fixture = contact.getFixtureB();
        var rand : Float = FlxG.random.int(0, 1) * 12;
        
        if (bodyA.isSensor() && bodyB.isSensor())
        {
            this.isColliding = true;
            this.face.increaseBlush();
            //A HEAD TO B HEAD
            if (Std.string(bodyA.getUserData()) == PhysicsDoll.COL_HEAD)
            {
                if (Std.string(bodyB.getUserData()) == PhysicsDoll.COL_HEAD)
                {
                    this.face.animation.play("excited");
                    if (rand < 1)
                    {
                        FlxG.sound.play(AssetPaths.kissu__mp3);
                    }
                }
            }
            //A GROIN TO B GROIN
            if (Std.string(bodyA.getUserData()) == PhysicsDoll.COL_GROIN)
            {
                if (Std.string(bodyB.getUserData()) == PhysicsDoll.COL_GROIN)
                {
                    this.face.animation.play("surprised");
                    if (rand < 1)
                    {
                        FlxG.sound.play(AssetPaths.ooh__mp3);
                    }
                }
            }
            //A HEAD TO B GROIN
            if (Std.string(bodyA.getUserData()) == PhysicsDoll.COL_HEAD)
            {
                if (Std.string(bodyB.getUserData()) == PhysicsDoll.COL_GROIN)
                {
                    this.face.animation.play("disgusted");
                    if (rand < 1)
                    {
                        FlxG.sound.play(AssetPaths.hmph__mp3);
                    }
                }
            }
            //B HEAD TO A GROIN
            if (Std.string(bodyB.getUserData()) == PhysicsDoll.COL_HEAD)
            {
                if (Std.string(bodyA.getUserData()) == PhysicsDoll.COL_GROIN)
                {
                    this.face.animation.play("disgusted");
                    if (rand < 1)
                    {
                        FlxG.sound.play(AssetPaths.hmm__mp3);
                    }
                }
            }
            //A HEAD TO B L HAND
            if (Std.string(bodyA.getUserData()) == PhysicsDoll.COL_HEAD)
            {
                if (Std.string(bodyB.getUserData()) == PhysicsDoll.COL_L_HAND)
                {
                    this.face.animation.play("confused");
                    if (rand < 1)
                    {
                        FlxG.sound.play(AssetPaths.uh__mp3);
                    }
                }
            }
            //B HEAD TO A L HAND
            if (Std.string(bodyB.getUserData()) == PhysicsDoll.COL_HEAD)
            {
                if (Std.string(bodyA.getUserData()) == PhysicsDoll.COL_L_HAND)
                {
                    this.face.animation.play("confused");
                    if (rand < 1)
                    {
                        FlxG.sound.play(AssetPaths.hmm__mp3);
                    }
                }
            }
            //A HEAD TO B R HAND
            if (Std.string(bodyA.getUserData()) == PhysicsDoll.COL_HEAD)
            {
                if (Std.string(bodyB.getUserData()) == PhysicsDoll.COL_R_HAND)
                {
                    this.face.animation.play("confused");
                    if (rand < 1)
                    {
                        FlxG.sound.play(AssetPaths.uh__mp3);
                    }
                }
            }
            //B HEAD TO A R HAND
            if (Std.string(bodyB.getUserData()) == PhysicsDoll.COL_HEAD)
            {
                if (Std.string(bodyA.getUserData()) == PhysicsDoll.COL_R_HAND)
                {
                    this.face.animation.play("confused");
                    if (rand < 1)
                    {
                        FlxG.sound.play(AssetPaths.confused__mp3);
                    }
                }
            }
            //A GROIN TO B L HAND
            if (Std.string(bodyA.getUserData()) == PhysicsDoll.COL_GROIN)
            {
                if (Std.string(bodyB.getUserData()) == PhysicsDoll.COL_L_HAND)
                {
                    this.face.animation.play("excited");
                    if (rand < 1)
                    {
                        FlxG.sound.play(AssetPaths.hehe__mp3);
                    }
                }
            }
            //B GROIN TO A L HAND
            if (Std.string(bodyB.getUserData()) == PhysicsDoll.COL_GROIN)
            {
                if (Std.string(bodyA.getUserData()) == PhysicsDoll.COL_L_HAND)
                {
                    this.face.animation.play("disgusted");
                    if (rand < 1)
                    {
                        FlxG.sound.play(AssetPaths.blegh__mp3);
                    }
                }
            }
            //A GROIN TO B R HAND
            if (Std.string(bodyA.getUserData()) == PhysicsDoll.COL_GROIN)
            {
                if (Std.string(bodyB.getUserData()) == PhysicsDoll.COL_R_HAND)
                {
                    this.face.animation.play("disgusted");
                    if (rand < 1)
                    {
                        FlxG.sound.play(AssetPaths.ooh__mp3);
                    }
                }
            }
            //B GROIN TO A R HAND
            if (Std.string(bodyB.getUserData()) == PhysicsDoll.COL_GROIN)
            {
                if (Std.string(bodyA.getUserData()) == PhysicsDoll.COL_R_HAND)
                {
                    this.face.animation.play("surprised");
                    if (rand < 1)
                    {
                        FlxG.sound.play(AssetPaths.hehe__mp3);
                    }
                }
            }
            var pick : Float = FlxG.random.int(0, 1) * 12;
            if (pick < 1)
            {
                FlxG.sound.play(AssetPaths.toy1__mp3);
            }
            else if (pick < 2)
            {
                FlxG.sound.play(AssetPaths.toy2__mp3);
            }
            else if (pick < 3)
            {
                FlxG.sound.play(AssetPaths.toy3__mp3);
            }
            else if (pick < 4)
            {
                FlxG.sound.play(AssetPaths.toy4__mp3);
            }
            else if (pick < 5)
            {
                FlxG.sound.play(AssetPaths.toy5__mp3);
            }
            else if (pick < 6)
            {
                FlxG.sound.play(AssetPaths.toy6__mp3);
            }
            else if (pick < 7)
            {
                FlxG.sound.play(AssetPaths.toy7__mp3);
            }
        }
    }
    
    override public function endContact(contact:B2Contact):Void
    {
        var bodyA : B2Fixture = contact.getFixtureA();
        var bodyB : B2Fixture = contact.getFixtureB();
        
        if (bodyA.isSensor() && bodyB.isSensor())
        {
            sex++;
            this.isColliding = false;
        }
    }
	
}