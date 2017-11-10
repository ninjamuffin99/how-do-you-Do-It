package;
import box2D.collision.B2AABB;
import box2D.common.math.B2Vec2;
import box2D.dynamics.joints.B2MouseJoint;

/**
 * ...
 * @author ninjaMuffin
 */
class DollGrabber 
{

	public var m_mouseJoint:B2MouseJoint;
	public var doll:PhysicsDoll;
	public var worldBounds:B2AABB;
	public var pos:B2Vec2;
	
	public function new() 
	{
		
	}
	
}