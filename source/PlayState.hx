package;

import box2D.collision.B2AABB;
import box2D.collision.shapes.B2PolygonShape;
import box2D.collision.shapes.B2Shape;
import box2D.common.math.B2Vec2;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2BodyDef;
import box2D.dynamics.B2DebugDraw;
import box2D.dynamics.B2Fixture;
import box2D.dynamics.B2World;
import box2D.dynamics.joints.B2MouseJoint;
import box2D.dynamics.joints.B2MouseJointDef;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import openfl.display.Sprite;

class PlayState extends TimedState
{
	
	public var m_physScale:Float = 30;
    public var m_world:B2World;
    public var m_mouseJoint:B2MouseJoint;
    public var dollLGrabber:DollGrabber;
    public var dollRGrabber:DollGrabber;
    public var dollL:PhysicsDoll;
    public var dollR:PhysicsDoll;
    public var dollController:DollController;
    public var dollCollision:DollContactListener;
    public static var mouseXWorldPhys:Float;
    public static var mouseYWorldPhys:Float;
    public static var mouseXWorld : Float;
    public static var mouseYWorld : Float;
    
    public var thinking:ScrollingText;
    public var thinking_two:ScrollingText;
    public var thinking_counter:Float = 0;
    public var bubble_width:Float = FlxG.width / 2;
    public var face:Face;
    public var body:FlxSprite;
    public var lArm:Arm;
    public var rArm:Arm;
    
    public var debugText:FlxText;
    public var started:Bool;
    public var smoke:FlxSprite;
    public var howText1:FlxText;
    public var howText2:FlxText;
	
	override public function create():Void
	{
		started = false;
		
		var bg:FlxSprite = new FlxSprite();
		bg.loadGraphic(AssetPaths.mainbg__png, false, 320, 240);
		add(bg);
		
		setupWorld();
		
		body = new FlxSprite(-70, 56);
        body.loadGraphic(AssetPaths.girl_body__png, false, 294, 190, true);
        add(body);
        
        face = new Face(-10, -68);
        
        thinking = new ScrollingText();
        add(thinking);
        
        var startY : Float = 200;
        var startX : Float = 170;
        
        var worldAABB:B2AABB = new B2AABB();
        worldAABB.lowerBound.set(0, 220 / m_physScale);
        worldAABB.upperBound.set(640 / m_physScale, 480 / m_physScale);
        
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
        m_world.setContactListener(dollCollision);
        
        startX = 510;
        position = new FlxPoint(startX, startY);
        dollR = new PhysicsDoll();
        dollR.create(m_world, position, PhysicsDoll.BTYPE);
        dollRGrabber.create(dollR, m_world, worldAABB);
        
        dollController = new DollController(dollRGrabber, dollLGrabber, rArm, lArm);
        
        smoke = new FlxSprite(0, 0);
        smoke.makeGraphic(640, 480, 0x55000000);
        add(smoke);
        
        howText1 = new FlxText(FlxG.width - 200, FlxG.height / 2, FlxG.width, "Use WASD to move your arms.");
        howText1.setFormat("Minecraftia-Regular", 8, 0xffffffff, "left");
        //howText1.size = 14;
        howText2 = new FlxText(FlxG.width - 200, FlxG.height / 2 + 20, FlxG.width, "Use J or K to rotate a doll.");
        howText2.setFormat("Minecraftia-Regular", 8, 0xffffffff, "left");
        //howText2.size = 14;
        add(howText1);
        add(howText2);
        
        if (FlxG.sound.music == null)
        {
            FlxG.sound.playMusic(AssetPaths.bgm__mp3);
        }
        else
        {
            FlxG.sound.music.resume();
            if (!FlxG.sound.music.active)
            {
                FlxG.sound.playMusic(AssetPaths.bgm__mp3);
            }
        }
		
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
        
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
        
        m_world.step(1.0 / 30.0, 10, 10);
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
            FlxG.sound.play(AssetPaths.carleave__mp3);
        }
        else if (this.timeFrame == 22 * 100)
        {
            FlxG.sound.play(AssetPaths.garageopen__mp3);
        }
        else if (this.timeFrame == 25 * 100)
        {
            FlxG.sound.play(AssetPaths.cardoor__mp3);
        }
        else if (this.timeFrame == 29 * 100)
        {
            FlxG.sound.play(AssetPaths.dooropen__mp3);
        }
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
        
        if (FlxG.mouse.pressed && m_mouseJoint == null)
        {
            var body:B2Body = GetBodyAtMouse();
            
            if (body != null)
            {
                var md:B2MouseJointDef = new B2MouseJointDef();
                md.bodyA = m_world.getGroundBody();
                md.bodyB = body;
                md.target.set(mouseXWorldPhys, mouseYWorldPhys);
                md.collideConnected = true;
                md.maxForce = 300.0 * body.getMass();
                //m_mouseJoint = try cast(m_world.CreateJoint(md), b2MouseJoint) catch(e:Dynamic) null;
                body.setAwake(true);
            }
        }
        
        // mouse release
        if (!FlxG.mouse.pressed)
        {
            if (m_mouseJoint != null)
            {
                m_world.destroyJoint(m_mouseJoint);
                m_mouseJoint = null;
            }
        }
        
        // mouse move
        if (m_mouseJoint != null)
        {
            var p2 : B2Vec2 = new B2Vec2(mouseXWorldPhys, mouseYWorldPhys);
            m_mouseJoint.setTarget(p2);
        }
    }
	
	private var mousePVec : B2Vec2 = new B2Vec2();
    public function GetBodyAtMouse(includeStatic:Bool = false):B2Body
    // Make a small box.
    {
        
        mousePVec.set(mouseXWorldPhys, mouseYWorldPhys);
        var aabb : B2AABB = new B2AABB();
        aabb.lowerBound.set(mouseXWorldPhys - 0.001, mouseYWorldPhys - 0.001);
        aabb.upperBound.set(mouseXWorldPhys + 0.001, mouseYWorldPhys + 0.001);
        var body:B2Body = null;
        var fixture:B2Fixture;
        
        // Query the world for overlapping shapes.
        function GetBodyCallback(fixture : B2Fixture) : Bool
        {
            var shape:B2Shape = fixture.getShape();
            if (fixture.getBody().getType() != B2Body.b2_staticBody || includeStatic)
            {
                var inside : Bool = shape.testPoint(fixture.getBody().getTransform(), mousePVec);
                if (inside)
                {
                    body = fixture.getBody();
                    return false;
                }
            }
            return true;
        };
        m_world.queryAABB(GetBodyCallback, aabb);
        return body;
    }
	
	private function setupWorld():Void
	{
		var gravity:B2Vec2 = new B2Vec2(0, 9.8);
		m_world = new B2World(gravity, true);
		var dbgDraw:B2DebugDraw = new B2DebugDraw();
		var dbgSprite:Sprite = new Sprite();
		FlxG.stage.addChild(dbgSprite);
		dbgDraw.setSprite(dbgSprite);
		dbgDraw.setDrawScale(30);
		dbgDraw.setFillAlpha(0.3);
		dbgDraw.setLineThickness(1);
		dbgDraw.setFlags(B2DebugDraw.e_shapeBit | B2DebugDraw.e_jointBit);
		m_world.setDebugDraw(dbgDraw);
		
		// Create border of boxes
		var wall:B2PolygonShape = new B2PolygonShape();
		var wallBd:B2BodyDef = new B2BodyDef();
		var wallB:B2Body;
		
		// Left
		wallBd.position.set( -95 / m_physScale, 480 / m_physScale / 2);
		wall.setAsBox(100 / m_physScale, 480 / m_physScale / 2);
		// commented out code in OG
		//wallB = m_world.CreateBody(wallBd);
        //wallB.CreateFixture2(wall);
		//Right
		wallBd.position.set((640 + 95) / m_physScale, 480 / m_physScale / 2);
		//more commented out code?? what a mystery :O
		//wallB = m_world.CreateBody(wallBd);
        //wallB.CreateFixture2(wall);
        // Top
		wallBd.position.set(640 / m_physScale / 2, -95 / m_physScale);
		wall.setAsBox(680 / m_physScale / 2, 100 / m_physScale);
		// *emoji that is thinking that Tyler Glaiel uses a lot*
		//wallB = m_world.CreateBody(wallBd);
        //wallB.CreateFixture2(wall);
        // Bottom
		wallBd.position.set(640 / m_physScale / 2, (480 + 95) / m_physScale);
	}
	
}