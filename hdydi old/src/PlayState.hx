import org.flixel.*;
import box2D.dynamics.*;
import box2D.collision.*;
import box2D.collision.shapes.*;
import box2D.common.math.*;
import box2D.dynamics.joints.*;
import flash.display.*;

class PlayState extends TimedState
{
    @:meta(Embed(source="../assets/bgm.mp3"))
private var SndBGM : Class<Dynamic>;
    @:meta(Embed(source="../assets/girl_body.png"))
private var ImgBody : Class<Dynamic>;
    @:meta(Embed(source="../assets/mainbg.png"))
private var ImgBG : Class<Dynamic>;
    @:meta(Embed(source="../assets/garageopen.mp3"))
private var garageOpen : Class<Dynamic>;
    @:meta(Embed(source="../assets/cardoor.mp3"))
private var carDoor : Class<Dynamic>;
    @:meta(Embed(source="../assets/cararrive.mp3"))
private var carArrive : Class<Dynamic>;
    @:meta(Embed(source="../assets/dooropen.mp3"))
private var doorOpen : Class<Dynamic>;
    @:meta(Embed(source="../assets/Minecraftia2.ttf",fontFamily="Minecraftia-Regular",embedAsCFF="false"))
public var FontPix : String;
    
    public var m_physScale : Float = 30;
    public var m_world : B2World;
    public var m_mouseJoint : B2MouseJoint;
    public var dollLGrabber : DollGrabber;
    public var dollRGrabber : DollGrabber;
    public var dollL : PhysicsDoll;
    public var dollR : PhysicsDoll;
    public var dollController : DollController;
    public var dollCollision : DollContactListener;
    public static var mouseXWorldPhys : Float;
    public static var mouseYWorldPhys : Float;
    public static var mouseXWorld : Float;
    public static var mouseYWorld : Float;
    
    public var thinking : ScrollingText;
    public var thinking_two : ScrollingText;
    public var thinking_counter : Float = 0;
    public var bubble_width : Float = FlxG.width / 2;
    public var face : Face;
    public var body : FlxSprite;
    public var lArm : Arm;
    public var rArm : Arm;
    
    public var debugText : FlxText;
    public var started : Bool;
    public var smoke : FlxSprite;
    public var howText1 : FlxText;
    public var howText2 : FlxText;
    
    override public function create() : Void
    {
        started = false;
        
        var bg : FlxSprite = new FlxSprite(0, 0);
        bg.loadGraphic(ImgBG, true, true, 320, 240, true);
        add(bg);
        
        debugText = new FlxText(10, 30, FlxG.width, "");
        add(debugText);
        
        setupWorld();
        
        body = new FlxSprite(-70, 56);
        body.loadGraphic(ImgBody, true, true, 294, 190, true);
        add(body);
        
        face = new Face(-10, -68);
        
        thinking = new ScrollingText();
        add(thinking);
        
        var startY : Float = 200;
        var startX : Float = 170;
        
        var worldAABB : B2AABB = new B2AABB();
        worldAABB.lowerBound.Set(0, 220 / m_physScale);
        worldAABB.upperBound.Set(640 / m_physScale, 480 / m_physScale);
        
        dollRGrabber = new DollGrabber();
        dollLGrabber = new DollGrabber();
        
        lArm = new Arm(50, dollLGrabber, false);
        rArm = new Arm(220, dollRGrabber, true);
        
        var position : FlxPoint = new FlxPoint(startX, startY);
        dollL = new PhysicsDoll();
        dollL.create(m_world, position, PhysicsDoll.ATYPE);
        dollLGrabber.create(dollL, m_world, worldAABB);
        
        //setup collision listener
        dollCollision = new DollContactListener(face);
        m_world.SetContactListener(dollCollision);
        
        startX = 510;
        position = new FlxPoint(startX, startY);
        dollR = new PhysicsDoll();
        dollR.create(m_world, position, PhysicsDoll.BTYPE);
        dollRGrabber.create(dollR, m_world, worldAABB);
        
        dollController = new DollController(dollRGrabber, dollLGrabber, rArm, lArm);
        
        smoke = new FlxSprite(0, 0);
        smoke.makeGraphic(640, 480);
        smoke.fill(0x55000000);
        add(smoke);
        
        howText1 = new FlxText(FlxG.width - 200, FlxG.height / 2, FlxG.width, "Use WASD to move your arms.");
        howText1.setFormat("Minecraftia-Regular", 8, 0xffffffff, "left");
        //howText1.size = 14;
        howText2 = new FlxText(FlxG.width - 200, FlxG.height / 2 + 20, FlxG.width, "Use J or K to rotate a doll.");
        howText2.setFormat("Minecraftia-Regular", 8, 0xffffffff, "left");
        //howText2.size = 14;
        add(howText1);
        add(howText2);
        
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
        
        if (timeFrame % 100 == 0 && !started)
        {
            endTime++;
        }
        
        if (dollController.update(endTime - timeSec))
        {
            started = true;
        }
        
        if (started)
        {
            thinking.paused = false;
            FlxG.state.remove(smoke);
            FlxG.state.remove(howText1);
            FlxG.state.remove(howText2);
        }
        
        UpdateMouseWorld();
        MouseDrag();
        
        m_world.Step(1.0 / 30.0, 10, 10);
        //m_world.DrawDebugData();
        
        dollL.update();
        dollR.update();
        dollLGrabber.update();
        dollRGrabber.update();
        
        lArm.update();
        rArm.update();
        
        face.update();
        
        /*if(thinking.pos_x > bubble_width){
        thinking_counter
        thinking_two = new ScrollingText();
        add(thinking_two);
        }*/
        
        if (this.timeFrame == 20 * 100)
        {
            FlxG.play(carArrive);
        }
        else if (this.timeFrame == 22 * 100)
        {
            FlxG.play(garageOpen);
        }
        else if (this.timeFrame == 25 * 100)
        {
            FlxG.play(carDoor);
        }
        else if (this.timeFrame == 29 * 100)
        {
            FlxG.play(doorOpen);
        }
    }
    
    override public function endCallback() : Void
    {
        FlxG.switchState(new MomReturningState(new EndState(dollCollision.sex, dollController.isClose), dollController.isClose));
    }
    
    public function UpdateMouseWorld() : Void
    {
        mouseXWorldPhys = (FlxG.mouse.screenX) / m_physScale;
        mouseYWorldPhys = (FlxG.mouse.screenY) / m_physScale;
        mouseXWorld = (FlxG.mouse.screenX);
        mouseYWorld = (FlxG.mouse.screenY);
    }
    
    public function MouseDrag() : Void
    // mouse press
    {
        
        if (FlxG.mouse.pressed() && m_mouseJoint == null)
        {
            var body : B2Body = GetBodyAtMouse();
            
            if (body != null)
            {
                var md : B2MouseJointDef = new B2MouseJointDef();
                md.bodyA = m_world.GetGroundBody();
                md.bodyB = body;
                md.target.Set(mouseXWorldPhys, mouseYWorldPhys);
                md.collideConnected = true;
                md.maxForce = 300.0 * body.GetMass();
                m_mouseJoint = try cast(m_world.CreateJoint(md), b2MouseJoint) catch(e:Dynamic) null;
                body.SetAwake(true);
            }
        }
        
        // mouse release
        if (!FlxG.mouse.pressed())
        {
            if (m_mouseJoint != null)
            {
                m_world.DestroyJoint(m_mouseJoint);
                m_mouseJoint = null;
            }
        }
        
        // mouse move
        if (m_mouseJoint != null)
        {
            var p2 : B2Vec2 = new B2Vec2(mouseXWorldPhys, mouseYWorldPhys);
            m_mouseJoint.SetTarget(p2);
        }
    }
    
    private var mousePVec : B2Vec2 = new B2Vec2();
    public function GetBodyAtMouse(includeStatic : Bool = false) : B2Body
    // Make a small box.
    {
        
        mousePVec.Set(mouseXWorldPhys, mouseYWorldPhys);
        var aabb : B2AABB = new B2AABB();
        aabb.lowerBound.Set(mouseXWorldPhys - 0.001, mouseYWorldPhys - 0.001);
        aabb.upperBound.Set(mouseXWorldPhys + 0.001, mouseYWorldPhys + 0.001);
        var body : B2Body = null;
        var fixture : B2Fixture;
        
        // Query the world for overlapping shapes.
        function GetBodyCallback(fixture : B2Fixture) : Bool
        {
            var shape : B2Shape = fixture.GetShape();
            if (fixture.GetBody().GetType() != b2Body.b2_staticBody || includeStatic)
            {
                var inside : Bool = shape.TestPoint(fixture.GetBody().GetTransform(), mousePVec);
                if (inside)
                {
                    body = fixture.GetBody();
                    return false;
                }
            }
            return true;
        };
        m_world.QueryAABB(GetBodyCallback, aabb);
        return body;
    }
    
    private function setupWorld() : Void
    {
        var gravity : B2Vec2 = new B2Vec2(0, 9.8);
        m_world = new B2World(gravity, true);
        
        var dbgDraw : B2DebugDraw = new B2DebugDraw();
        var dbgSprite : Sprite = new Sprite();
        FlxG.stage.addChild(dbgSprite);
        dbgDraw.SetSprite(dbgSprite);
        dbgDraw.SetDrawScale(30.0);
        dbgDraw.SetFillAlpha(0.3);
        dbgDraw.SetLineThickness(1.0);
        dbgDraw.SetFlags(b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit);
        m_world.SetDebugDraw(dbgDraw);
        
        // Create border of boxes
        var wall : B2PolygonShape = new B2PolygonShape();
        var wallBd : B2BodyDef = new B2BodyDef();
        var wallB : B2Body;
        
        // Left
        wallBd.position.Set(-95 / m_physScale, 480 / m_physScale / 2);
        wall.SetAsBox(100 / m_physScale, 480 / m_physScale / 2);
        //wallB = m_world.CreateBody(wallBd);
        //wallB.CreateFixture2(wall);
        // Right
        wallBd.position.Set((640 + 95) / m_physScale, 480 / m_physScale / 2);
        //wallB = m_world.CreateBody(wallBd);
        //wallB.CreateFixture2(wall);
        // Top
        wallBd.position.Set(640 / m_physScale / 2, -95 / m_physScale);
        wall.SetAsBox(680 / m_physScale / 2, 100 / m_physScale);
        //wallB = m_world.CreateBody(wallBd);
        //wallB.CreateFixture2(wall);
        // Bottom
        wallBd.position.Set(640 / m_physScale / 2, (480 + 95) / m_physScale);
    }

    public function new()
    {
        super();
    }
}

