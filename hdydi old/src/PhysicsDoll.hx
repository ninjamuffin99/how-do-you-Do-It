import org.flixel.*;
import box2D.dynamics.*;
import box2D.collision.*;
import box2D.collision.shapes.*;
import box2D.common.math.*;
import box2D.dynamics.joints.*;

class PhysicsDoll
{
    @:meta(Embed(source="../assets/barb_head.png"))
private var ImgFHead : Class<Dynamic>;
    @:meta(Embed(source="../assets/barb_chest.png"))
private var ImgFChest : Class<Dynamic>;
    @:meta(Embed(source="../assets/barb_hips.png"))
private var ImgFHips : Class<Dynamic>;
    @:meta(Embed(source="../assets/barb_armL.png"))
private var ImgFArmL : Class<Dynamic>;
    @:meta(Embed(source="../assets/barb_armR.png"))
private var ImgFArmR : Class<Dynamic>;
    @:meta(Embed(source="../assets/barb_legL.png"))
private var ImgFLegL : Class<Dynamic>;
    @:meta(Embed(source="../assets/barb_legR.png"))
private var ImgFLegR : Class<Dynamic>;
    @:meta(Embed(source="../assets/barb_footL.png"))
private var ImgFFootL : Class<Dynamic>;
    @:meta(Embed(source="../assets/barb_footR.png"))
private var ImgFFootR : Class<Dynamic>;
    @:meta(Embed(source="../assets/ken_head.png"))
private var ImgMHead : Class<Dynamic>;
    @:meta(Embed(source="../assets/ken_chest.png"))
private var ImgMChest : Class<Dynamic>;
    @:meta(Embed(source="../assets/ken_hips.png"))
private var ImgMHips : Class<Dynamic>;
    @:meta(Embed(source="../assets/ken_armL.png"))
private var ImgMArmL : Class<Dynamic>;
    @:meta(Embed(source="../assets/ken_armR.png"))
private var ImgMArmR : Class<Dynamic>;
    @:meta(Embed(source="../assets/ken_legL.png"))
private var ImgMLegL : Class<Dynamic>;
    @:meta(Embed(source="../assets/ken_legR.png"))
private var ImgMLegR : Class<Dynamic>;
    @:meta(Embed(source="../assets/ken_footL.png"))
private var ImgMFootL : Class<Dynamic>;
    @:meta(Embed(source="../assets/ken_footR.png"))
private var ImgMFootR : Class<Dynamic>;
    
    public var m_world : B2World;
    public var m_physScale : Float = 30;
    public var midriff : B2Body;
    public var torso3 : B2Body;
    public var spriteType : Float;
    
    public var headSprite : FlxSprite;
    public var chestSprite : FlxSprite;
    public var hipsSprite : FlxSprite;
    public var armLSprite : FlxSprite;
    public var armRSprite : FlxSprite;
    public var legLSprite : FlxSprite;
    public var legRSprite : FlxSprite;
    public var footLSprite : FlxSprite;
    public var footRSprite : FlxSprite;
    
    public var head : B2Body;
    public var torso1 : B2Body;
    public var upperArmL : B2Body;
    public var upperArmR : B2Body;
    public var l_hand : B2Body;
    public var r_hand : B2Body;
    public var upperLegL : B2Body;
    public var upperLegR : B2Body;
    public var lowerLegL : B2Body;
    public var lowerLegR : B2Body;
    
    private var LEGSPACING(default, never) : Float = 18;
    
    public static inline var ATYPE : Int = 0;  // lady  
    public static inline var BTYPE : Int = 1;  // dude  
    
    private var LEGAMASK(default, never) : Int = 0x0002;
    private var LEGACAT(default, never) : Int = 0x0002;
    private var LEGBMASK(default, never) : Int = 0x0004;
    private var LEGBCAT(default, never) : Int = 0x0004;
    private var TORSOMASK(default, never) : Int = 0xFFFF;
    private var TORSOCAT(default, never) : Int = 0x0010;
    private var ARMMASK(default, never) : Int = 0xFFFF;
    private var ARMCAT(default, never) : Int = 0x0020;
    private var FOOTMASK(default, never) : Int = 0xFFEF;
    private var FOOTCAT(default, never) : Int = 0x0008;
    
    public static inline var COL_HEAD : String = "HEAD";
    public static inline var COL_L_HAND : String = "L_HAND";
    public static inline var COL_R_HAND : String = "R_HAND";
    public static inline var COL_GROIN : String = "GROIN";
    
    public function create(_world : B2World, start : FlxPoint,
            spriteType : Int = ATYPE) : Void
    {
        m_world = _world;
        this.spriteType = spriteType;
        
        var circ : B2CircleShape;
        var box : B2PolygonShape;
        var bd : B2BodyDef = new B2BodyDef();
        var jd : B2RevoluteJointDef = new B2RevoluteJointDef();
        var fixtureDef : B2FixtureDef = new B2FixtureDef();
        var startX : Float = start.x;
        var startY : Float = start.y;
        
        // BODIES
        // Set these to dynamic bodies
        bd.type = b2Body.b2_dynamicBody;
        
        // Head
        circ = new B2CircleShape(20 / m_physScale);
        fixtureDef.shape = circ;
        fixtureDef.density = 1.0;
        fixtureDef.friction = 0.4;
        fixtureDef.restitution = 0.3;
        var headY : Float = 10;
        if (spriteType == BTYPE)
        {
            headY = 30;
        }
        bd.position.Set(startX / m_physScale, (startY - headY) / m_physScale);
        head = m_world.CreateBody(bd);
        fixtureDef.isSensor = true;
        fixtureDef.userData = COL_HEAD;
        head.CreateFixture(fixtureDef);
        fixtureDef.isSensor = false;
        
        // Torso1
        box = new B2PolygonShape();
        box.SetAsBox(30 / m_physScale, 30 / m_physScale);
        fixtureDef.shape = box;
        fixtureDef.density = 1.0;
        fixtureDef.friction = 0.4;
        fixtureDef.restitution = 0.1;
        filterData = new B2FilterData();
        filterData.maskBits = TORSOMASK;
        filterData.categoryBits = TORSOCAT;
        fixtureDef.filter = filterData;
        bd.position.Set(startX / m_physScale, (startY + 28) / m_physScale);
        torso1 = m_world.CreateBody(bd);
        torso1.CreateFixture(fixtureDef);
        // Torso2
        box = new B2PolygonShape();
        box.SetAsBox(22 / m_physScale, 22 / m_physScale);
        fixtureDef.shape = box;
        bd.position.Set(startX / m_physScale, (startY + 85) / m_physScale);
        bd.fixedRotation = true;
        var torso2 : B2Body = m_world.CreateBody(bd);
        torso2.CreateFixture(fixtureDef);
        bd.fixedRotation = false;
        midriff = torso2;
        // Torso3
        box = new B2PolygonShape();
        box.SetAsBox(15 / m_physScale, 10 / m_physScale);
        fixtureDef.shape = box;
        bd.position.Set(startX / m_physScale, (startY + 115) / m_physScale);
        torso3 = m_world.CreateBody(bd);
        fixtureDef.isSensor = true;
        fixtureDef.userData = COL_GROIN;
        torso3.CreateFixture(fixtureDef);
        fixtureDef.isSensor = false;
        bd.fixedRotation = false;
        
        // UpperArm
        fixtureDef.density = 1.0;
        fixtureDef.friction = 0.4;
        fixtureDef.restitution = 0.1;
        filterData = new B2FilterData();
        filterData.maskBits = ARMMASK;
        filterData.categoryBits = ARMCAT;
        fixtureDef.filter = filterData;
        // L
        box = new B2PolygonShape();
        box.SetAsBox(56 / m_physScale, 6.5 / m_physScale);
        fixtureDef.shape = box;
        var armSpace : Float = 90;
        var armHeight : Float = 10;
        if (spriteType == ATYPE)
        {
            armSpace = 70;
            armHeight = 15;
        }
        bd.position.Set((startX - armSpace) / m_physScale, (startY + armHeight) / m_physScale);
        upperArmL = m_world.CreateBody(bd);
        upperArmL.CreateFixture(fixtureDef);
        // L Hand
        box = new B2PolygonShape();
        box.SetAsBox(10 / m_physScale, 10 / m_physScale);
        fixtureDef.shape = box;
        bd.position.Set((startX - 150) / m_physScale, (startY + armHeight) / m_physScale);
        l_hand = m_world.CreateBody(bd);
        fixtureDef.isSensor = true;
        fixtureDef.userData = COL_L_HAND;
        l_hand.CreateFixture(fixtureDef);
        fixtureDef.isSensor = false;
        bd.fixedRotation = false;
        // R
        box = new B2PolygonShape();
        box.SetAsBox(56 / m_physScale, 6.5 / m_physScale);
        fixtureDef.shape = box;
        bd.position.Set((startX + armSpace) / m_physScale, (startY + armHeight) / m_physScale);
        upperArmR = m_world.CreateBody(bd);
        upperArmR.CreateFixture(fixtureDef);
        // R Hand
        box = new B2PolygonShape();
        box.SetAsBox(10 / m_physScale, 10 / m_physScale);
        fixtureDef.shape = box;
        bd.position.Set((startX + 150) / m_physScale, (startY + armHeight) / m_physScale);
        r_hand = m_world.CreateBody(bd);
        fixtureDef.isSensor = true;
        fixtureDef.userData = COL_R_HAND;
        r_hand.CreateFixture(fixtureDef);
        fixtureDef.isSensor = false;
        bd.fixedRotation = false;
        
        // UpperLeg
        fixtureDef.density = 1.0;
        fixtureDef.friction = 0.4;
        fixtureDef.restitution = 0.1;
        var filterData : B2FilterData = new B2FilterData();
        filterData.maskBits = LEGAMASK;
        filterData.categoryBits = LEGACAT;
        if (spriteType == BTYPE)
        {
            filterData.maskBits = LEGBMASK;
            filterData.categoryBits = LEGBCAT;
        }
        fixtureDef.filter = filterData;
        // L
        box = new B2PolygonShape();
        box.SetAsBox(7.5 / m_physScale, 66 / m_physScale);
        fixtureDef.shape = box;
        bd.position.Set((startX - LEGSPACING) / m_physScale, (startY + 170) / m_physScale);
        upperLegL = m_world.CreateBody(bd);
        upperLegL.CreateFixture(fixtureDef);
        // R
        box = new B2PolygonShape();
        box.SetAsBox(7.5 / m_physScale, 66 / m_physScale);
        fixtureDef.shape = box;
        bd.position.Set((startX + LEGSPACING) / m_physScale, (startY + 170) / m_physScale);
        upperLegR = m_world.CreateBody(bd);
        upperLegR.CreateFixture(fixtureDef);
        
        // LowerLeg
        fixtureDef.density = 1.0;
        fixtureDef.friction = 0.4;
        fixtureDef.restitution = 0.1;
        filterData = new B2FilterData();
        filterData.maskBits = FOOTMASK;
        filterData.categoryBits = FOOTCAT;
        fixtureDef.filter = filterData;
        // L
        box = new B2PolygonShape();
        box.SetAsBox(6 / m_physScale, 10 / m_physScale);
        fixtureDef.shape = box;
        bd.position.Set((startX - LEGSPACING) / m_physScale, (startY + 247) / m_physScale);
        lowerLegL = m_world.CreateBody(bd);
        lowerLegL.CreateFixture(fixtureDef);
        // R
        box = new B2PolygonShape();
        box.SetAsBox(6 / m_physScale, 10 / m_physScale);
        fixtureDef.shape = box;
        bd.position.Set((startX + LEGSPACING) / m_physScale, (startY + 247) / m_physScale);
        lowerLegR = m_world.CreateBody(bd);
        lowerLegR.CreateFixture(fixtureDef);
        
        
        // JOINTS
        jd.enableLimit = true;
        
        // Head to shoulders
        jd.lowerAngle = -10 / (180 / Math.PI);
        jd.upperAngle = 10 / (180 / Math.PI);
        jd.Initialize(torso1, head, new B2Vec2(startX / m_physScale, (startY - 3) / m_physScale));
        m_world.CreateJoint(jd);
        
        // Upper arm to shoulders
        // L
        var shoulderJointSpace : Float = 32;
        if (spriteType == ATYPE)
        {
            shoulderJointSpace = 22;
        }
        jd.lowerAngle = -85 / (180 / Math.PI);
        jd.upperAngle = 10 / (180 / Math.PI);
        jd.Initialize(torso1, upperArmL, new B2Vec2((startX - shoulderJointSpace) / m_physScale, (startY + 10) / m_physScale));
        m_world.CreateJoint(jd);
        // L Hand to L Arm
        jd.lowerAngle = -125 / (180 / Math.PI);
        jd.upperAngle = 125 / (180 / Math.PI);
        jd.Initialize(upperArmL, l_hand, new B2Vec2((startX - 150) / m_physScale, (startY + armHeight) / m_physScale));
        m_world.CreateJoint(jd);
        // R
        jd.lowerAngle = -10 / (180 / Math.PI);
        jd.upperAngle = 85 / (180 / Math.PI);
        jd.Initialize(torso1, upperArmR, new B2Vec2((startX + shoulderJointSpace) / m_physScale, (startY + 10) / m_physScale));
        m_world.CreateJoint(jd);
        // R Hand to R Arm
        jd.lowerAngle = -125 / (180 / Math.PI);
        jd.upperAngle = 125 / (180 / Math.PI);
        jd.Initialize(upperArmR, r_hand, new B2Vec2((startX + 150) / m_physScale, (startY + armHeight) / m_physScale));
        m_world.CreateJoint(jd);
        
        // Shoulders/stomach
        jd.lowerAngle = -15 / (180 / Math.PI);
        jd.upperAngle = 15 / (180 / Math.PI);
        jd.Initialize(torso1, torso2, new B2Vec2(startX / m_physScale, (startY + 65) / m_physScale));
        m_world.CreateJoint(jd);
        
        // stomach to hitbox
        jd.lowerAngle = -15 / (180 / Math.PI);
        jd.upperAngle = 15 / (180 / Math.PI);
        jd.Initialize(torso2, torso3, new B2Vec2(startX / m_physScale, (startY + 65) / m_physScale));
        m_world.CreateJoint(jd);
        
        // Torso to upper leg
        // L
        jd.lowerAngle = -5 / (180 / Math.PI);
        jd.upperAngle = 45 / (180 / Math.PI);
        jd.Initialize(torso2, upperLegL, new B2Vec2((startX - LEGSPACING) / m_physScale, (startY + 96) / m_physScale));
        m_world.CreateJoint(jd);
        // R
        jd.lowerAngle = -45 / (180 / Math.PI);
        jd.upperAngle = 5 / (180 / Math.PI);
        jd.Initialize(torso2, upperLegR, new B2Vec2((startX + LEGSPACING) / m_physScale, (startY + 96) / m_physScale));
        m_world.CreateJoint(jd);
        
        // Upper leg to lower leg
        // L
        jd.lowerAngle = 10 / (180 / Math.PI);
        jd.upperAngle = 40 / (180 / Math.PI);
        jd.Initialize(upperLegL, lowerLegL, new B2Vec2((startX - LEGSPACING) / m_physScale, (startY + 235) / m_physScale));
        m_world.CreateJoint(jd);
        // R
        jd.lowerAngle = -40 / (180 / Math.PI);
        jd.upperAngle = 10 / (180 / Math.PI);
        jd.Initialize(upperLegR, lowerLegR, new B2Vec2((startX + LEGSPACING) / m_physScale, (startY + 235) / m_physScale));
        m_world.CreateJoint(jd);
        
        setupSprites();
    }
    
    public function update() : Void
    {
        headSprite.x = (head.GetPosition().x * m_physScale / 2) - headSprite.width / 2;
        headSprite.y = (head.GetPosition().y * m_physScale / 2) - headSprite.height / 2;
        headSprite.angle = head.GetAngle() * (180 / Math.PI);
        
        chestSprite.x = (torso1.GetPosition().x * m_physScale / 2) - chestSprite.width / 2;
        chestSprite.y = (torso1.GetPosition().y * m_physScale / 2) - chestSprite.height / 2;
        chestSprite.angle = torso1.GetAngle() * (180 / Math.PI);
        
        hipsSprite.x = (midriff.GetPosition().x * m_physScale / 2) - hipsSprite.width / 2;
        hipsSprite.y = (midriff.GetPosition().y * m_physScale / 2) - hipsSprite.height / 2;
        hipsSprite.angle = midriff.GetAngle() * (180 / Math.PI);
        
        armLSprite.x = (upperArmR.GetPosition().x * m_physScale / 2) - armLSprite.width / 2;
        if (spriteType == ATYPE)
        {
            armLSprite.y = (upperArmR.GetPosition().y * m_physScale / 2) - armLSprite.height / 2 - 3;
        }
        else if (spriteType == BTYPE)
        {
            armLSprite.y = (upperArmR.GetPosition().y * m_physScale / 2) - armLSprite.height / 2;
        }
        armLSprite.angle = upperArmR.GetAngle() * (180 / Math.PI);
        
        armRSprite.x = (upperArmL.GetPosition().x * m_physScale / 2) - armRSprite.width / 2;
        armRSprite.y = (upperArmL.GetPosition().y * m_physScale / 2) - armRSprite.height / 2;
        armRSprite.angle = upperArmL.GetAngle() * (180 / Math.PI);
        
        legRSprite.x = (upperLegL.GetPosition().x * m_physScale / 2) - legRSprite.width / 2;
        legRSprite.y = (upperLegL.GetPosition().y * m_physScale / 2) - legRSprite.height / 2;
        legRSprite.angle = upperLegL.GetAngle() * (180 / Math.PI);
        
        legLSprite.x = (upperLegR.GetPosition().x * m_physScale / 2) - legLSprite.width / 2;
        legLSprite.y = (upperLegR.GetPosition().y * m_physScale / 2) - legLSprite.height / 2;
        legLSprite.angle = upperLegR.GetAngle() * (180 / Math.PI);
        
        footLSprite.x = (lowerLegR.GetPosition().x * m_physScale / 2) - footLSprite.width / 2;
        footLSprite.y = (lowerLegR.GetPosition().y * m_physScale / 2) - footLSprite.height / 2;
        footLSprite.angle = lowerLegR.GetAngle() * (180 / Math.PI);
        
        footRSprite.x = (lowerLegL.GetPosition().x * m_physScale / 2) - footRSprite.width / 2;
        footRSprite.y = (lowerLegL.GetPosition().y * m_physScale / 2) - footRSprite.height / 2;
        footRSprite.angle = lowerLegL.GetAngle() * (180 / Math.PI);
    }
    
    public function setupSprites() : Void
    {
        headSprite = new FlxSprite(0, 0);
        chestSprite = new FlxSprite(0, 0);
        hipsSprite = new FlxSprite(0, 0);
        armLSprite = new FlxSprite(0, 0);
        armRSprite = new FlxSprite(0, 0);
        legLSprite = new FlxSprite(0, 0);
        legRSprite = new FlxSprite(0, 0);
        footLSprite = new FlxSprite(0, 0);
        footRSprite = new FlxSprite(0, 0);
        if (spriteType == ATYPE)
        {
            headSprite.loadGraphic(ImgFHead, true, true, 35, 40, true);
            chestSprite.loadGraphic(ImgFChest, true, true, 29, 40, true);
            hipsSprite.loadGraphic(ImgFHips, true, true, 28, 24, true);
            armLSprite.loadGraphic(ImgFArmL, true, true, 55, 44, true);
            armRSprite.loadGraphic(ImgFArmR, true, true, 55, 44, true);
            legLSprite.loadGraphic(ImgFLegL, true, true, 19, 84, true);
            legRSprite.loadGraphic(ImgFLegR, true, true, 19, 84, true);
            footLSprite.loadGraphic(ImgFFootL, true, true, 9, 17, true);
            footRSprite.loadGraphic(ImgFFootR, true, true, 9, 17, true);
        }
        else if (spriteType == BTYPE)
        {
            headSprite.loadGraphic(ImgMHead, true, true, 28, 30, true);
            chestSprite.loadGraphic(ImgMChest, true, true, 47, 47, true);
            hipsSprite.loadGraphic(ImgMHips, true, true, 32, 32, true);
            armLSprite.loadGraphic(ImgMArmL, true, true, 66, 14, true);
            armRSprite.loadGraphic(ImgMArmR, true, true, 66, 14, true);
            legLSprite.loadGraphic(ImgMLegL, true, true, 19, 82, true);
            legRSprite.loadGraphic(ImgMLegR, true, true, 19, 82, true);
            footLSprite.loadGraphic(ImgMFootL, true, true, 23, 14, true);
            footRSprite.loadGraphic(ImgMFootR, true, true, 23, 14, true);
        }
        FlxG.state.add(armLSprite);
        FlxG.state.add(armRSprite);
        FlxG.state.add(hipsSprite);
        FlxG.state.add(legLSprite);
        FlxG.state.add(legRSprite);
        FlxG.state.add(footLSprite);
        FlxG.state.add(footRSprite);
        FlxG.state.add(chestSprite);
        FlxG.state.add(headSprite);
    }

    public function new()
    {
    }
}

