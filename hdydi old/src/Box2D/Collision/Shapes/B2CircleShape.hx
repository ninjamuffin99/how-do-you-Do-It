/*
* Copyright (c) 2006-2007 Erin Catto http://www.gphysics.com
*
* This software is provided 'as-is', without any express or implied
* warranty.  In no event will the authors be held liable for any damages
* arising from the use of this software.
* Permission is granted to anyone to use this software for any purpose,
* including commercial applications, and to alter it and redistribute it
* freely, subject to the following restrictions:
* 1. The origin of this software must not be misrepresented; you must not
* claim that you wrote the original software. If you use this software
* in a product, an acknowledgment in the product documentation would be
* appreciated but is not required.
* 2. Altered source versions must be plainly marked as such, and must not be
* misrepresented as being the original software.
* 3. This notice may not be removed or altered from any source distribution.
*/

package box2D.collision.shapes;

import box2D.common.math.*;
import box2D.common.*;
import box2D.collision.shapes.*;
import box2D.dynamics.*;
import box2D.collision.*;
import box2D.common.B2internal;

/**
* A circle shape.
* @see b2CircleDef
*/
class B2CircleShape extends B2Shape
{
    override public function Copy() : B2Shape
    {
        var s : B2Shape = new B2CircleShape();
        s.Set(this);
        return s;
    }
    
    override public function Set(other : B2Shape) : Void
    {
        super.Set(other);
        if (Std.is(other, b2CircleShape))
        {
            var other2 : B2CircleShape = try cast(other, b2CircleShape) catch(e:Dynamic) null;
            m_p.SetV(other2.m_p);
        }
    }
    
    /**
	* @inheritDoc
	*/
    override public function TestPoint(transform : B2Transform, p : B2Vec2) : Bool
    //b2Vec2 center = transform.position + b2Mul(transform.R, m_p);
    {
        
        var tMat : B2Mat22 = transform.R;
        var dX : Float = transform.position.x + (tMat.col1.x * m_p.x + tMat.col2.x * m_p.y);
        var dY : Float = transform.position.y + (tMat.col1.y * m_p.x + tMat.col2.y * m_p.y);
        //b2Vec2 d = p - center;
        dX = p.x - dX;
        dY = p.y - dY;
        //return b2Dot(d, d) <= m_radius * m_radius;
        return (dX * dX + dY * dY) <= m_radius * m_radius;
    }
    
    /**
	* @inheritDoc
	*/
    override public function RayCast(output : B2RayCastOutput, input : B2RayCastInput, transform : B2Transform) : Bool
    //b2Vec2 position = transform.position + b2Mul(transform.R, m_p);
    {
        
        var tMat : B2Mat22 = transform.R;
        var positionX : Float = transform.position.x + (tMat.col1.x * m_p.x + tMat.col2.x * m_p.y);
        var positionY : Float = transform.position.y + (tMat.col1.y * m_p.x + tMat.col2.y * m_p.y);
        
        //b2Vec2 s = input.p1 - position;
        var sX : Float = input.p1.x - positionX;
        var sY : Float = input.p1.y - positionY;
        //float32 b = b2Dot(s, s) - m_radius * m_radius;
        var b : Float = (sX * sX + sY * sY) - m_radius * m_radius;
        
        /*/new as3hx.Compat.Regex(' Does the segment start inside the circle?
		if (b < 0.0)
		{
			output.fraction = 0;
			output.hit = e_startsInsideCollide;
			return;
		}*', "")  //b2Vec2 r = input.p2 - input.p1;    // Solve quadratic equation.  ;
        
        
        
        
        
        var rX : Float = input.p2.x - input.p1.x;
        var rY : Float = input.p2.y - input.p1.y;
        //float32 c =  b2Dot(s, r);
        var c : Float = (sX * rX + sY * rY);
        //float32 rr = b2Dot(r, r);
        var rr : Float = (rX * rX + rY * rY);
        var sigma : Float = c * c - rr * b;
        
        // Check for negative discriminant and short segment.
        if (sigma < 0.0 || rr < as3hx.Compat.FLOAT_MIN)
        {
            return false;
        }
        
        // Find the point of intersection of the line with the circle.
        var a : Float = -(c + Math.sqrt(sigma));
        
        // Is the intersection point on the segment?
        if (0.0 <= a && a <= input.maxFraction * rr)
        {
            a /= rr;
            output.fraction = a;
            // manual inline of: output.normal = s + a * r;
            output.normal.x = sX + a * rX;
            output.normal.y = sY + a * rY;
            output.normal.Normalize();
            return true;
        }
        
        return false;
    }
    
    /**
	* @inheritDoc
	*/
    override public function ComputeAABB(aabb : B2AABB, transform : B2Transform) : Void
    //b2Vec2 p = transform.position + b2Mul(transform.R, m_p);
    {
        
        var tMat : B2Mat22 = transform.R;
        var pX : Float = transform.position.x + (tMat.col1.x * m_p.x + tMat.col2.x * m_p.y);
        var pY : Float = transform.position.y + (tMat.col1.y * m_p.x + tMat.col2.y * m_p.y);
        aabb.lowerBound.Set(pX - m_radius, pY - m_radius);
        aabb.upperBound.Set(pX + m_radius, pY + m_radius);
    }
    
    /**
	* @inheritDoc
	*/
    override public function ComputeMass(massData : B2MassData, density : Float) : Void
    {
        massData.mass = density * b2Settings.b2_pi * m_radius * m_radius;
        massData.center.SetV(m_p);
        
        // inertia about the local origin
        //massData.I = massData.mass * (0.5 * m_radius * m_radius + b2Dot(m_p, m_p));
        massData.I = massData.mass * (0.5 * m_radius * m_radius + (m_p.x * m_p.x + m_p.y * m_p.y));
    }
    
    /**
	* @inheritDoc
	*/
    override public function ComputeSubmergedArea(
            normal : B2Vec2,
            offset : Float,
            xf : B2Transform,
            c : B2Vec2) : Float
    {
        var p : B2Vec2 = b2Math.MulX(xf, m_p);
        var l : Float = -(b2Math.Dot(normal, p) - offset);
        
        if (l < -m_radius + as3hx.Compat.FLOAT_MIN)
        
        //Completely dry{
            
            return 0;
        }
        if (l > m_radius)
        
        //Completely wet{
            
            c.SetV(p);
            return Math.PI * m_radius * m_radius;
        }
        
        //Magic
        var r2 : Float = m_radius * m_radius;
        var l2 : Float = l * l;
        var area : Float = r2 * (Math.asin(l / m_radius) + Math.PI / 2) + l * Math.sqrt(r2 - l2);
        var com : Float = -2 / 3 * Math.pow(r2 - l2, 1.5) / area;
        
        c.x = p.x + normal.x * com;
        c.y = p.y + normal.y * com;
        
        return area;
    }
    
    /**
	 * Get the local position of this circle in its parent body.
	 */
    public function GetLocalPosition() : B2Vec2
    {
        return m_p;
    }
    
    /**
	 * Set the local position of this circle in its parent body.
	 */
    public function SetLocalPosition(position : B2Vec2) : Void
    {
        m_p.SetV(position);
    }
    
    /**
	 * Get the radius of the circle
	 */
    public function GetRadius() : Float
    {
        return m_radius;
    }
    
    /**
	 * Set the radius of the circle
	 */
    public function SetRadius(radius : Float) : Void
    {
        m_radius = radius;
    }
    
    public function new(radius : Float = 0)
    {
        super();
        m_type = e_circleShape;
        m_radius = radius;
    }
    
    // Local position in parent body
    private var m_p : B2Vec2 = new B2Vec2();
}


