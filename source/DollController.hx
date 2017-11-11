package;
import box2D.common.math.B2Vec2;
import flixel.FlxG;
import flixel.text.FlxText;

/**
 * ...
 * @author ninjaMuffin
 */
class DollController 
{
	public var doll1 : DollGrabber;
    public var doll2 : DollGrabber;
    public var arm1 : Arm;
    public var arm2 : Arm;
    public var speed : Float = .055;
    public var speed_up : Float = .5;
    public static var dollTranslateSpeed : Float;
    public static var dollRotateSpeed : Float;
    public var t : FlxText;
    public var rotateMirror : Bool = false;
    public var isClose : Bool;
    
    public var timeFrame : Float = 0;
    public var timeSec : Float = 0;
    
    public function new(doll1 : DollGrabber, doll2 : DollGrabber, arm1 : Arm, arm2 : Arm)
    {
        dollRotateSpeed = speed;
        dollTranslateSpeed = speed;
        this.doll1 = doll1;
        this.doll2 = doll2;
        this.arm1 = arm1;
        this.arm2 = arm2;
        t = new FlxText(100, 100, 100, "");
        FlxG.state.add(t);
    }
    
    public function update(timeRemain : Float):Bool
    {
        timeFrame++;
        
        if (timeFrame % 500 == 0)
        {
            rotateMirror = (rotateMirror) ? false : true;
        }
        
        var toss : Bool = false;
        if (timeRemain < 2)
        {
            toss = true;
        }
        
        var ret : Bool = false;
        
        var distance : Float = dollProximity(toss);
        
        if (distance < 7.5)
        {
            this.isClose = true;
        }
        else
        {
            this.isClose = false;
        }
        //t.text = this.isClose.toString();
        
        var target1:B2Vec2 = doll1.m_mouseJoint.getAnchorA();
        var target2:B2Vec2 = doll2.m_mouseJoint.getAnchorA();
        var angle1:Float = doll1.doll.midriff.getAngle();
        var angle2:Float = doll2.doll.midriff.getAngle();
        var left:Bool = false;
        var right:Bool = false;
        var up:Bool = false;
        var down:Bool = false;
        if (FlxG.keys.pressed.D || (toss && distance > 7.5))
        {
            right = true;
            left = false;
            ret = true;
        }
        else if (FlxG.keys.pressed.A)
        {
            right = false;
            left = true;
            ret = true;
        }
        if (FlxG.keys.pressed.S)
        {
            up = false;
            down = true;
            ret = true;
        }
        else if (FlxG.keys.pressed.W)
        {
            up = true;
            down = false;
            ret = true;
        }
        
        if (FlxG.keys.pressed.J)
        {
            ret = true;
            if (rotateMirror)
            {
                angle1 += dollRotateSpeed;
                arm1.turn(true);
            }
            else
            {
                angle2 -= dollRotateSpeed;
                arm2.turn(false);
            }
        }
        else if (FlxG.keys.pressed.K)
        {
            ret = true;
            if (rotateMirror)
            {
                angle2 -= dollRotateSpeed;
                arm2.turn(false);
            }
            else
            {
                angle1 += dollRotateSpeed;
                arm1.turn(true);
            }
        }
        else
        {
            arm1.stopTurning();
            arm2.stopTurning();
        }
        
        if (toss)
        {
            dollTranslateSpeed = 1;
        }
        
        if (left)
        {
            target1.x -= dollTranslateSpeed;
            target2.x += dollTranslateSpeed;
        }
        if (right)
        {
            target1.x += dollTranslateSpeed;
            target2.x -= dollTranslateSpeed;
        }
        if (up)
        {
            target1.y -= dollTranslateSpeed;
            target2.y -= dollTranslateSpeed;
        }
        if (down)
        {
            target1.y += dollTranslateSpeed;
            target2.y += dollTranslateSpeed;
        }
        
        doll1.SetTransform(target1, angle1, toss);
        doll2.SetTransform(target2, angle2, toss);
        return ret;
    }
    
    public function dollProximity(toss : Bool) : Float
    {
        var a : Float = Math.abs(doll1.doll.midriff.getPosition().x - doll2.doll.midriff.getPosition().y);
        var b : Float = Math.abs(doll1.doll.midriff.getPosition().y - doll2.doll.midriff.getPosition().x);
        var distance : Float = Math.sqrt(Math.pow(a, 2) + Math.pow(b, 2));
        
        if (toss)
        {
            return distance;
        }
        
        if (distance < 7.5)
        {
            dollTranslateSpeed = speed_up;
            this.isClose == true;
        }
        else
        {
            dollTranslateSpeed = speed;
            this.isClose == false;
        }
        
        return distance;
    }
}