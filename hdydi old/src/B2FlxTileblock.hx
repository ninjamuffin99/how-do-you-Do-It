import org.flixel.*;
import box2D.dynamics.*;
import box2D.collision.*;
import box2D.collision.shapes.*;
import box2D.common.math.*;

class B2FlxTileblock extends FlxTileblock
{
    
    private var ratio : Float = 30;
    
    public var _fixDef : B2FixtureDef;
    public var _bodyDef : B2BodyDef;
    public var _obj : B2Body;
    
    //References
    private var _world : B2World;
    
    //Physics params default value
    public var _friction : Float = 0.8;
    public var _restitution : Float = 0.3;
    public var _density : Float = 0.7;
    
    //Default angle
    public var _angle : Float = 0;
    //Default body type
    public var _type : Int = b2Body.b2_staticBody;
    
    public function new(X : Float, Y : Float, Width : Float, Height : Float, w : B2World)
    {
        super(X, Y, Width, Height);
        _world = w;
    }
    
    public function createBody() : Void
    {
        var boxShape : B2PolygonShape = new B2PolygonShape();
        boxShape.SetAsBox((width / 2) / ratio, (height / 2) / ratio);
        
        _fixDef = new B2FixtureDef();
        _fixDef.density = _density;
        _fixDef.restitution = _restitution;
        _fixDef.friction = _friction;
        _fixDef.shape = boxShape;
        
        _bodyDef = new B2BodyDef();
        _bodyDef.position.Set((x + (width / 2)) / ratio, (y + (height / 2)) / ratio);
        _bodyDef.angle = _angle * (Math.PI / 180);
        _bodyDef.type = _type;
        
        _obj = _world.CreateBody(_bodyDef);
        _obj.CreateFixture(_fixDef);
    }
}
