package;

import box2D.collision.B2AABB;
import box2D.common.math.B2Vec2;
import box2D.dynamics.B2World;
import box2D.dynamics.joints.B2MouseJoint;
import box2D.dynamics.joints.B2MouseJointDef;

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

	public function create(doll:PhysicsDoll, m_world:B2World, bounds:B2AABB):Void
	{
		this.doll = doll;
		this.worldBounds = bounds;

		pos = new B2Vec2();

		var md:B2MouseJointDef = new B2MouseJointDef();
		md.bodyA = m_world.getGroundBody();
		md.bodyB = doll.midriff;
		md.target.set(doll.midriff.getPosition().x, doll.midriff.getPosition().y);
		md.collideConnected = true;
		md.maxForce = 3000 * doll.midriff.getMass();
		m_mouseJoint = try cast(m_world.createJoint(md), B2MouseJoint)
		catch (e:Dynamic) null;
	}

	public function update():Void {}

	public function SetTransform(target:B2Vec2, angle:Float, toss:Bool = false):Void
	{
		var targetAABB:B2AABB = new B2AABB();
		targetAABB.lowerBound.set(target.x, target.y);
		targetAABB.upperBound.set(target.x, target.y);
		if (worldBounds.contains(targetAABB) || toss)
		{
			var midpoint:Float = worldBounds.upperBound.x / 2;
			var lower:Float = midpoint - 1;
			var upper:Float = midpoint + 1;

			if ((m_mouseJoint.getTarget().x < midpoint && target.x < lower) || (m_mouseJoint.getTarget().x > midpoint && target.x > upper))
			{
				m_mouseJoint.setTarget(target);
				this.pos = target;
			}
		}
		doll.midriff.setAngle(angle);
	}

	public function new() {}
}
