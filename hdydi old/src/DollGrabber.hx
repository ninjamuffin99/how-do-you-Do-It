import org.flixel.*;
import box2D.dynamics.*;
import box2D.collision.*;
import box2D.collision.shapes.*;
import box2D.common.math.*;
import box2D.dynamics.joints.*;

class DollGrabber
{
    public var m_mouseJoint : B2MouseJoint;
    public var doll : PhysicsDoll;
    public var worldBounds : B2AABB;
    public var pos : B2Vec2;
    
    public function create(doll : PhysicsDoll, m_world : B2World,
            bounds : B2AABB) : Void
    {
        this.doll = doll;
        this.worldBounds = bounds;
        
        var md : B2MouseJointDef = new B2MouseJointDef();
        md.bodyA = m_world.GetGroundBody();
        md.bodyB = doll.midriff;
        md.target.Set(doll.midriff.GetPosition().x, doll.midriff.GetPosition().y);
        md.collideConnected = true;
        md.maxForce = 3000.0 * doll.midriff.GetMass();
        m_mouseJoint = try cast(m_world.CreateJoint(md), b2MouseJoint) catch(e:Dynamic) null;
    }
    
    public function update() : Void
    {
    }
    
    public function SetTransform(target : B2Vec2, angle : Float, toss : Bool = false) : Void
    {
        var targetAABB : B2AABB = new B2AABB();
        targetAABB.lowerBound.Set(target.x, target.y);
        targetAABB.upperBound.Set(target.x, target.y);
        if (worldBounds.Contains(targetAABB) || toss)
        {
            var midpoint : Float = worldBounds.upperBound.x / 2;
            var lower : Float = midpoint - 1;
            var upper : Float = midpoint + 1;
            
            if ((m_mouseJoint.GetTarget().x < midpoint && target.x < lower) ||
                (m_mouseJoint.GetTarget().x > midpoint && target.x > upper))
            {
                m_mouseJoint.SetTarget(target);
                this.pos = target;
            }
        }
        doll.midriff.SetAngle(angle);
    }

    public function new()
    {
    }
}

