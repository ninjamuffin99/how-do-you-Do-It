import org.flixel.*;
import box2D.dynamics.*;
import box2D.collision.*;
import box2D.collision.shapes.*;
import box2D.common.math.*;

class B2FlxSprite extends FlxSprite
{
    private var ratio : Float = 30;
    
    public var _fixDef : B2FixtureDef;
    public var _bodyDef : B2BodyDef;
    public var _obj : B2Body;
    
    private var _world : B2World;
    
    //Physics params default value
    public var _friction : Float = 0.8;
    public var _restitution : Float = 0.3;
    public var _density : Float = 0.7;
    
    //Default angle
    public var _angle : Float = 0;
    //Default body type
    public var _type : Int = b2Body.b2_dynamicBody;
    
    
    public function new(X : Float, Y : Float, Width : Float, Height : Float, w : B2World)
    {
        super(X, Y);
        
        width = Width;
        height = Height;
        _world = w;
    }
    
    override public function update() : Void
    {
        x = (_obj.GetPosition().x * ratio) - width / 2;
        y = (_obj.GetPosition().y * ratio) - height / 2;
        angle = _obj.GetAngle() * (180 / Math.PI);
        super.update();
    }
    
    public function createBody(myType : Int, _bodyDef : B2BodyDef = null,
            _fixDef : B2FixtureDef = null, _category : Float = 0,
            _mask : Float = 0) : Void
    {
        var boxShape : B2PolygonShape = new B2PolygonShape();
        boxShape.SetAsBox((width / 2) / ratio, (height / 2) / ratio);
        
        if (_fixDef == null)
        {
            _fixDef = new B2FixtureDef();
            _fixDef.density = _density;
            _fixDef.restitution = _restitution;
            _fixDef.friction = _friction;
            _fixDef.filter.categoryBits = _category;
            _fixDef.filter.maskBits = _mask;
        }
        _fixDef.shape = boxShape;
        
        if (_bodyDef == null)
        {
            _bodyDef = new B2BodyDef();
            _bodyDef.position.Set((x + (width / 2)) / ratio, (y + (height / 2)) / ratio);
            _bodyDef.angle = _angle * (Math.PI / 180);
            _bodyDef.type = myType;
        }
        
        _obj = _world.CreateBody(_bodyDef);
        _obj.CreateFixture(_fixDef);
    }
}

