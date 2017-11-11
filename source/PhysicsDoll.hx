package;
import box2D.collision.shapes.B2CircleShape;
import box2D.collision.shapes.B2PolygonShape;
import box2D.common.math.B2Vec2;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2BodyDef;
import box2D.dynamics.B2FilterData;
import box2D.dynamics.B2FixtureDef;
import box2D.dynamics.B2World;
import box2D.dynamics.joints.B2RevoluteJointDef;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;

/**
 * ...
 * @author ninjaMuffin
 */
class PhysicsDoll 
{
	
    public var m_world:B2World;
    public var m_physScale:Float = 30;
    public var midriff:B2Body;
    public var torso3:B2Body;
    public var spriteType : Float;
    
    public var headSprite:FlxSprite;
    public var chestSprite:FlxSprite;
    public var hipsSprite:FlxSprite;
    public var armLSprite:FlxSprite;
    public var armRSprite:FlxSprite;
    public var legLSprite:FlxSprite;
    public var legRSprite:FlxSprite;
    public var footLSprite:FlxSprite;
    public var footRSprite:FlxSprite;
    
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
    
	public function create(_world:B2World, start:FlxPoint, spriteType:Int = ATYPE):Void
	{
		m_world = _world;
		this.spriteType = spriteType;
		
		var circ:B2CircleShape;
		var box:B2PolygonShape;
		var bd:B2BodyDef = new B2BodyDef();
		var jd:B2RevoluteJointDef = new B2RevoluteJointDef();
		var fixtureDef:B2FixtureDef = new B2FixtureDef();
		var startX:Float = start.x;
		var startY:Float = start.y;
		
		// BODIES
		// set these to dynamic bodies
		bd.type = B2Body.b2_dynamicBody;
		
		// Head
		circ = new B2CircleShape(20 / m_physScale);
		fixtureDef.shape = circ;
		fixtureDef.density = 1;
		fixtureDef.friction = 0.4;
		fixtureDef.restitution = 0.3;
		var headY:Float = 10;
		
		if (spriteType == BTYPE)
		{
			headY = 30;
		}
		
		bd.position.set(startX / m_physScale, (startY = headY) / m_physScale);
		head = m_world.createBody(bd);
		fixtureDef.isSensor = true;
		fixtureDef.userData = COL_HEAD;
		head.createFixture(fixtureDef);
		fixtureDef.isSensor = false;
		
		// Torsso1
		box = new B2PolygonShape();
		box.setAsBox(30 / m_physScale, 30 / m_physScale);
		fixtureDef.shape = box;
		fixtureDef.density = 1.0;
		fixtureDef.friction = 0.4;
		fixtureDef.restitution = 0.1;
		var filterData:B2FilterData = new B2FilterData();
		filterData.maskBits = TORSOMASK;
		filterData.categoryBits = TORSOCAT;
		fixtureDef.filter = filterData;
		bd.position.set(startX / m_physScale, (startY + 28) / m_physScale);
		torso1 = m_world.createBody(bd);
		torso1.createFixture(fixtureDef);
		
		// Torso2
		box = new B2PolygonShape();
        box.setAsBox(22 / m_physScale, 22 / m_physScale);
        fixtureDef.shape = box;
        bd.position.set(startX / m_physScale, (startY + 85) / m_physScale);
        bd.fixedRotation = true;
        var torso2 : B2Body = m_world.createBody(bd);
        torso2.createFixture(fixtureDef);
        bd.fixedRotation = false;
        midriff = torso2;
        // Torso3
        box = new B2PolygonShape();
        box.setAsBox(15 / m_physScale, 10 / m_physScale);
        fixtureDef.shape = box;
        bd.position.set(startX / m_physScale, (startY + 115) / m_physScale);
        torso3 = m_world.createBody(bd);
        fixtureDef.isSensor = true;
        fixtureDef.userData = COL_GROIN;
        torso3.createFixture(fixtureDef);
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
        box.setAsBox(56 / m_physScale, 6.5 / m_physScale);
        fixtureDef.shape = box;
        var armSpace : Float = 90;
        var armHeight : Float = 10;
        if (spriteType == ATYPE)
        {
            armSpace = 70;
            armHeight = 15;
        }
        bd.position.set((startX - armSpace) / m_physScale, (startY + armHeight) / m_physScale);
        upperArmL = m_world.createBody(bd);
		upperArmL.createFixture(fixtureDef);
        // L Hand
        box = new B2PolygonShape();
        box.setAsBox(10 / m_physScale, 10 / m_physScale);
        fixtureDef.shape = box;
        bd.position.set((startX - 150) / m_physScale, (startY + armHeight) / m_physScale);
        l_hand = m_world.createBody(bd);
        fixtureDef.isSensor = true;
        fixtureDef.userData = COL_L_HAND;
        l_hand.createFixture(fixtureDef);
        fixtureDef.isSensor = false;
        bd.fixedRotation = false;
        // R
        box = new B2PolygonShape();
        box.setAsBox(56 / m_physScale, 6.5 / m_physScale);
        fixtureDef.shape = box;
        bd.position.set((startX + armSpace) / m_physScale, (startY + armHeight) / m_physScale);
        upperArmR = m_world.createBody(bd);
        upperArmR.createFixture(fixtureDef);
        // R Hand
        box = new B2PolygonShape();
        box.setAsBox(10 / m_physScale, 10 / m_physScale);
        fixtureDef.shape = box;
        bd.position.set((startX + 150) / m_physScale, (startY + armHeight) / m_physScale);
        r_hand = m_world.createBody(bd);
        fixtureDef.isSensor = true;
        fixtureDef.userData = COL_R_HAND;
        r_hand.createFixture(fixtureDef);
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
        box.setAsBox(7.5 / m_physScale, 66 / m_physScale);
        fixtureDef.shape = box;
        bd.position.set((startX - LEGSPACING) / m_physScale, (startY + 170) / m_physScale);
        upperLegL = m_world.createBody(bd);
        upperLegL.createFixture(fixtureDef);
        // R
        box = new B2PolygonShape();
        box.setAsBox(7.5 / m_physScale, 66 / m_physScale);
        fixtureDef.shape = box;
        bd.position.set((startX + LEGSPACING) / m_physScale, (startY + 170) / m_physScale);
        upperLegR = m_world.createBody(bd);
        upperLegR.createFixture(fixtureDef);
        
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
        box.setAsBox(6 / m_physScale, 10 / m_physScale);
        fixtureDef.shape = box;
        bd.position.set((startX - LEGSPACING) / m_physScale, (startY + 247) / m_physScale);
        lowerLegL = m_world.createBody(bd);
        lowerLegL.createFixture(fixtureDef);
        // R
        box = new B2PolygonShape();
        box.setAsBox(6 / m_physScale, 10 / m_physScale);
        fixtureDef.shape = box;
        bd.position.set((startX + LEGSPACING) / m_physScale, (startY + 247) / m_physScale);
        lowerLegR = m_world.createBody(bd);
        lowerLegR.createFixture(fixtureDef);
        
        
        // JOINTS
        jd.enableLimit = true;
        
        // Head to shoulders
        jd.lowerAngle = -10 / (180 / Math.PI);
        jd.upperAngle = 10 / (180 / Math.PI);
        jd.initialize(torso1, head, new B2Vec2(startX / m_physScale, (startY - 3) / m_physScale));
        m_world.createJoint(jd);
        
        // Upper arm to shoulders
        // L
        var shoulderJointSpace : Float = 32;
        if (spriteType == ATYPE)
        {
            shoulderJointSpace = 22;
        }
        jd.lowerAngle = -85 / (180 / Math.PI);
        jd.upperAngle = 10 / (180 / Math.PI);
        jd.initialize(torso1, upperArmL, new B2Vec2((startX - shoulderJointSpace) / m_physScale, (startY + 10) / m_physScale));
        m_world.createJoint(jd);
        // L Hand to L Arm
        jd.lowerAngle = -125 / (180 / Math.PI);
        jd.upperAngle = 125 / (180 / Math.PI);
        jd.initialize(upperArmL, l_hand, new B2Vec2((startX - 150) / m_physScale, (startY + armHeight) / m_physScale));
        m_world.createJoint(jd);
        // R
        jd.lowerAngle = -10 / (180 / Math.PI);
        jd.upperAngle = 85 / (180 / Math.PI);
        jd.initialize(torso1, upperArmR, new B2Vec2((startX + shoulderJointSpace) / m_physScale, (startY + 10) / m_physScale));
        m_world.createJoint(jd);
        // R Hand to R Arm
        jd.lowerAngle = -125 / (180 / Math.PI);
        jd.upperAngle = 125 / (180 / Math.PI);
        jd.initialize(upperArmR, r_hand, new B2Vec2((startX + 150) / m_physScale, (startY + armHeight) / m_physScale));
        m_world.createJoint(jd);
        
        // Shoulders/stomach
        jd.lowerAngle = -15 / (180 / Math.PI);
        jd.upperAngle = 15 / (180 / Math.PI);
        jd.initialize(torso1, torso2, new B2Vec2(startX / m_physScale, (startY + 65) / m_physScale));
        m_world.createJoint(jd);
        
        // stomach to hitbox
        jd.lowerAngle = -15 / (180 / Math.PI);
        jd.upperAngle = 15 / (180 / Math.PI);
        jd.initialize(torso2, torso3, new B2Vec2(startX / m_physScale, (startY + 65) / m_physScale));
        m_world.createJoint(jd);
        
        // Torso to upper leg
        // L
        jd.lowerAngle = -5 / (180 / Math.PI);
        jd.upperAngle = 45 / (180 / Math.PI);
        jd.initialize(torso2, upperLegL, new B2Vec2((startX - LEGSPACING) / m_physScale, (startY + 96) / m_physScale));
        m_world.createJoint(jd);
        // R
        jd.lowerAngle = -45 / (180 / Math.PI);
        jd.upperAngle = 5 / (180 / Math.PI);
        jd.initialize(torso2, upperLegR, new B2Vec2((startX + LEGSPACING) / m_physScale, (startY + 96) / m_physScale));
        m_world.createJoint(jd);
        
        // Upper leg to lower leg
        // L
        jd.lowerAngle = 10 / (180 / Math.PI);
        jd.upperAngle = 40 / (180 / Math.PI);
        jd.initialize(upperLegL, lowerLegL, new B2Vec2((startX - LEGSPACING) / m_physScale, (startY + 235) / m_physScale));
        m_world.createJoint(jd);
        // R
        jd.lowerAngle = -40 / (180 / Math.PI);
        jd.upperAngle = 10 / (180 / Math.PI);
        jd.initialize(upperLegR, lowerLegR, new B2Vec2((startX + LEGSPACING) / m_physScale, (startY + 235) / m_physScale));
        m_world.createJoint(jd);
        
        setupSprites();
	}
	public function update():Void
	{
		headSprite.x = (head.getPosition().x * m_physScale / 2) - headSprite.width / 2;
        headSprite.y = (head.getPosition().y * m_physScale / 2) - headSprite.height / 2;
        headSprite.angle = head.getAngle() * (180 / Math.PI);
        
        chestSprite.x = (torso1.getPosition().x * m_physScale / 2) - chestSprite.width / 2;
        chestSprite.y = (torso1.getPosition().y * m_physScale / 2) - chestSprite.height / 2;
        chestSprite.angle = torso1.getAngle() * (180 / Math.PI);
        
        hipsSprite.x = (midriff.getPosition().x * m_physScale / 2) - hipsSprite.width / 2;
        hipsSprite.y = (midriff.getPosition().y * m_physScale / 2) - hipsSprite.height / 2;
        hipsSprite.angle = midriff.getAngle() * (180 / Math.PI);
        
        armLSprite.x = (upperArmR.getPosition().x * m_physScale / 2) - armLSprite.width / 2;
        if (spriteType == ATYPE)
        {
            armLSprite.y = (upperArmR.getPosition().y * m_physScale / 2) - armLSprite.height / 2 - 3;
        }
        else if (spriteType == BTYPE)
        {
            armLSprite.y = (upperArmR.getPosition().y * m_physScale / 2) - armLSprite.height / 2;
        }
        armLSprite.angle = upperArmR.getAngle() * (180 / Math.PI);
        
        armRSprite.x = (upperArmL.getPosition().x * m_physScale / 2) - armRSprite.width / 2;
        armRSprite.y = (upperArmL.getPosition().y * m_physScale / 2) - armRSprite.height / 2;
        armRSprite.angle = upperArmL.getAngle() * (180 / Math.PI);
        
        legRSprite.x = (upperLegL.getPosition().x * m_physScale / 2) - legRSprite.width / 2;
        legRSprite.y = (upperLegL.getPosition().y * m_physScale / 2) - legRSprite.height / 2;
        legRSprite.angle = upperLegL.getAngle() * (180 / Math.PI);
        
        legLSprite.x = (upperLegR.getPosition().x * m_physScale / 2) - legLSprite.width / 2;
        legLSprite.y = (upperLegR.getPosition().y * m_physScale / 2) - legLSprite.height / 2;
        legLSprite.angle = upperLegR.getAngle() * (180 / Math.PI);
        
        footLSprite.x = (lowerLegR.getPosition().x * m_physScale / 2) - footLSprite.width / 2;
        footLSprite.y = (lowerLegR.getPosition().y * m_physScale / 2) - footLSprite.height / 2;
        footLSprite.angle = lowerLegR.getAngle() * (180 / Math.PI);
        
        footRSprite.x = (lowerLegL.getPosition().x * m_physScale / 2) - footRSprite.width / 2;
        footRSprite.y = (lowerLegL.getPosition().y * m_physScale / 2) - footRSprite.height / 2;
        footRSprite.angle = lowerLegL.getAngle() * (180 / Math.PI);
	}
	
	public function setupSprites():Void
	{
		headSprite = new FlxSprite();
		chestSprite = new FlxSprite();
		hipsSprite = new FlxSprite();
		armLSprite = new FlxSprite();
		armRSprite = new FlxSprite();
		legLSprite = new FlxSprite();
		legRSprite = new FlxSprite();
		footLSprite = new FlxSprite();
		footRSprite = new FlxSprite();
		
		if (spriteType == ATYPE)
		{
			headSprite.loadGraphic(AssetPaths.barb_head__png, false, 35, 40);
            chestSprite.loadGraphic(AssetPaths.barb_chest__png, false, 29, 40);
            hipsSprite.loadGraphic(AssetPaths.barb_hips__png, false, 28, 24);
            armLSprite.loadGraphic(AssetPaths.barb_armL__png, false, 55, 44);
            armRSprite.loadGraphic(AssetPaths.barb_armR__png, false, 55, 44);
            legLSprite.loadGraphic(AssetPaths.barb_legL__png, false, 19, 84);
            legRSprite.loadGraphic(AssetPaths.barb_legR__png, false, 19, 84);
            footLSprite.loadGraphic(AssetPaths.barb_footL__png, false, 9, 17);
            footRSprite.loadGraphic(AssetPaths.barb_footR__png, false, 9, 17);
		}
		else if (spriteType == BTYPE)
        {
            headSprite.loadGraphic(AssetPaths.ken_head__png, false, 28, 30);
            chestSprite.loadGraphic(AssetPaths.ken_chest__png, false, 47, 47);
            hipsSprite.loadGraphic(AssetPaths.ken_hips__png, false, 32, 32);
            armLSprite.loadGraphic(AssetPaths.ken_armL__png, false, 66, 14);
            armRSprite.loadGraphic(AssetPaths.ken_armR__png, false, 66, 14);
            legLSprite.loadGraphic(AssetPaths.ken_legL__png, false, 19, 82);
            legRSprite.loadGraphic(AssetPaths.ken_legR__png, false, 19, 82);
            footLSprite.loadGraphic(AssetPaths.ken_footL__png, false, 23, 14);
            footRSprite.loadGraphic(AssetPaths.ken_footR__png, false, 23, 14);
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