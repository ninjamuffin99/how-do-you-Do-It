import box2D.dynamics.contacts.B2Contact;
import box2D.dynamics.B2ContactListener;
import box2D.dynamics.*;
import box2D.collision.*;
import box2D.collision.shapes.*;
import box2D.common.math.*;
import box2D.dynamics.joints.*;
import org.flixel.*;

class DollContactListener extends B2ContactListener
{
    @:meta(Embed(source="../assets/toy1.mp3"))
private var SndToy1 : Class<Dynamic>;
    @:meta(Embed(source="../assets/toy2.mp3"))
private var SndToy2 : Class<Dynamic>;
    @:meta(Embed(source="../assets/toy3.mp3"))
private var SndToy3 : Class<Dynamic>;
    @:meta(Embed(source="../assets/toy4.mp3"))
private var SndToy4 : Class<Dynamic>;
    @:meta(Embed(source="../assets/toy5.mp3"))
private var SndToy5 : Class<Dynamic>;
    @:meta(Embed(source="../assets/toy6.mp3"))
private var SndToy6 : Class<Dynamic>;
    @:meta(Embed(source="../assets/toy7.mp3"))
private var SndToy7 : Class<Dynamic>;
    @:meta(Embed(source="../assets/blegh.mp3"))
private var Blegh : Class<Dynamic>;
    @:meta(Embed(source="../assets/confused.mp3"))
private var Confused : Class<Dynamic>;
    @:meta(Embed(source="../assets/hehe.mp3"))
private var Hehe : Class<Dynamic>;
    @:meta(Embed(source="../assets/hmm.mp3"))
private var Hmm : Class<Dynamic>;
    @:meta(Embed(source="../assets/hmph.mp3"))
private var Hmph : Class<Dynamic>;
    @:meta(Embed(source="../assets/kissu.mp3"))
private var Kissu : Class<Dynamic>;
    @:meta(Embed(source="../assets/ooh.mp3"))
private var Ooh : Class<Dynamic>;
    @:meta(Embed(source="../assets/uh.mp3"))
private var Uh : Class<Dynamic>;
    
    public var t : FlxText = new FlxText(200, 200, 100, "COLLIDING");
    public var face : Face;
    public var sex : Float = 0;
    public var isColliding : Bool = false;
    
    public function new(face : Face)
    {
        super();
        this.face = face;
    }
    
    override public function BeginContact(contact : B2Contact) : Void
    {
        var bodyA : B2Fixture = contact.GetFixtureA();
        var bodyB : B2Fixture = contact.GetFixtureB();
        var rand : Float = FlxG.random() * 12;
        
        if (bodyA.IsSensor() && bodyB.IsSensor())
        {
            this.isColliding = true;
            this.face.increaseBlush();
            //A HEAD TO B HEAD
            if (Std.string(bodyA.GetUserData()) == PhysicsDoll.COL_HEAD)
            {
                if (Std.string(bodyB.GetUserData()) == PhysicsDoll.COL_HEAD)
                {
                    this.face.play("excited");
                    if (rand < 1)
                    {
                        FlxG.play(Kissu);
                    }
                }
            }
            //A GROIN TO B GROIN
            if (Std.string(bodyA.GetUserData()) == PhysicsDoll.COL_GROIN)
            {
                if (Std.string(bodyB.GetUserData()) == PhysicsDoll.COL_GROIN)
                {
                    this.face.play("surprised");
                    if (rand < 1)
                    {
                        FlxG.play(Ooh);
                    }
                }
            }
            //A HEAD TO B GROIN
            if (Std.string(bodyA.GetUserData()) == PhysicsDoll.COL_HEAD)
            {
                if (Std.string(bodyB.GetUserData()) == PhysicsDoll.COL_GROIN)
                {
                    this.face.play("disgusted");
                    if (rand < 1)
                    {
                        FlxG.play(Hmph);
                    }
                }
            }
            //B HEAD TO A GROIN
            if (Std.string(bodyB.GetUserData()) == PhysicsDoll.COL_HEAD)
            {
                if (Std.string(bodyA.GetUserData()) == PhysicsDoll.COL_GROIN)
                {
                    this.face.play("disgusted");
                    if (rand < 1)
                    {
                        FlxG.play(Hmm);
                    }
                }
            }
            //A HEAD TO B L HAND
            if (Std.string(bodyA.GetUserData()) == PhysicsDoll.COL_HEAD)
            {
                if (Std.string(bodyB.GetUserData()) == PhysicsDoll.COL_L_HAND)
                {
                    this.face.play("confused");
                    if (rand < 1)
                    {
                        FlxG.play(Uh);
                    }
                }
            }
            //B HEAD TO A L HAND
            if (Std.string(bodyB.GetUserData()) == PhysicsDoll.COL_HEAD)
            {
                if (Std.string(bodyA.GetUserData()) == PhysicsDoll.COL_L_HAND)
                {
                    this.face.play("confused");
                    if (rand < 1)
                    {
                        FlxG.play(Hmm);
                    }
                }
            }
            //A HEAD TO B R HAND
            if (Std.string(bodyA.GetUserData()) == PhysicsDoll.COL_HEAD)
            {
                if (Std.string(bodyB.GetUserData()) == PhysicsDoll.COL_R_HAND)
                {
                    this.face.play("confused");
                    if (rand < 1)
                    {
                        FlxG.play(Uh);
                    }
                }
            }
            //B HEAD TO A R HAND
            if (Std.string(bodyB.GetUserData()) == PhysicsDoll.COL_HEAD)
            {
                if (Std.string(bodyA.GetUserData()) == PhysicsDoll.COL_R_HAND)
                {
                    this.face.play("confused");
                    if (rand < 1)
                    {
                        FlxG.play(Confused);
                    }
                }
            }
            //A GROIN TO B L HAND
            if (Std.string(bodyA.GetUserData()) == PhysicsDoll.COL_GROIN)
            {
                if (Std.string(bodyB.GetUserData()) == PhysicsDoll.COL_L_HAND)
                {
                    this.face.play("excited");
                    if (rand < 1)
                    {
                        FlxG.play(Hehe);
                    }
                }
            }
            //B GROIN TO A L HAND
            if (Std.string(bodyB.GetUserData()) == PhysicsDoll.COL_GROIN)
            {
                if (Std.string(bodyA.GetUserData()) == PhysicsDoll.COL_L_HAND)
                {
                    this.face.play("disgusted");
                    if (rand < 1)
                    {
                        FlxG.play(Blegh);
                    }
                }
            }
            //A GROIN TO B R HAND
            if (Std.string(bodyA.GetUserData()) == PhysicsDoll.COL_GROIN)
            {
                if (Std.string(bodyB.GetUserData()) == PhysicsDoll.COL_R_HAND)
                {
                    this.face.play("disgusted");
                    if (rand < 1)
                    {
                        FlxG.play(Ooh);
                    }
                }
            }
            //B GROIN TO A R HAND
            if (Std.string(bodyB.GetUserData()) == PhysicsDoll.COL_GROIN)
            {
                if (Std.string(bodyA.GetUserData()) == PhysicsDoll.COL_R_HAND)
                {
                    this.face.play("surprised");
                    if (rand < 1)
                    {
                        FlxG.play(Hehe);
                    }
                }
            }
            var pick : Float = FlxG.random() * 12;
            if (pick < 1)
            {
                FlxG.play(SndToy1);
            }
            else if (pick < 2)
            {
                FlxG.play(SndToy2);
            }
            else if (pick < 3)
            {
                FlxG.play(SndToy3);
            }
            else if (pick < 4)
            {
                FlxG.play(SndToy4);
            }
            else if (pick < 5)
            {
                FlxG.play(SndToy5);
            }
            else if (pick < 6)
            {
                FlxG.play(SndToy6);
            }
            else if (pick < 7)
            {
                FlxG.play(SndToy7);
            }
        }
    }
    
    override public function EndContact(contact : B2Contact) : Void
    {
        var bodyA : B2Fixture = contact.GetFixtureA();
        var bodyB : B2Fixture = contact.GetFixtureB();
        
        if (bodyA.IsSensor() && bodyB.IsSensor())
        {
            sex++;
            this.isColliding = false;
        }
    }
}

