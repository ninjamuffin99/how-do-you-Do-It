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

package box2D.dynamics.contacts;

import box2D.dynamics.*;
import box2D.dynamics.contacts.*;
import box2D.collision.shapes.*;
import box2D.collision.*;
import box2D.common.math.*;
import box2D.common.*;
import box2D.common.B2internal;

//typedef b2Contact* b2ContactCreateFcn(b2Shape* shape1, b2Shape* shape2, b2BlockAllocator* allocator);
//typedef void b2ContactDestroyFcn(b2Contact* contact, b2BlockAllocator* allocator);
/**
* The class manages contact between two shapes. A contact exists for each overlapping
* AABB in the broad-phase (except if filtered). Therefore a contact object may exist
* that has no contact points.
*/
class B2Contact
{
    /**
	 * Get the contact manifold. Do not modify the manifold unless you understand the
	 * internals of Box2D
	 */
    public function GetManifold() : B2Manifold
    {
        return m_manifold;
    }
    
    /**
	 * Get the world manifold
	 */
    public function GetWorldManifold(worldManifold : B2WorldManifold) : Void
    {
        var bodyA : B2Body = m_fixtureA.GetBody();
        var bodyB : B2Body = m_fixtureB.GetBody();
        var shapeA : B2Shape = m_fixtureA.GetShape();
        var shapeB : B2Shape = m_fixtureB.GetShape();
        
        worldManifold.Initialize(m_manifold, bodyA.GetTransform(), shapeA.m_radius, bodyB.GetTransform(), shapeB.m_radius);
    }
    
    /**
	 * Is this contact touching.
	 */
    public function IsTouching() : Bool
    {
        return (m_flags & e_touchingFlag) == e_touchingFlag;
    }
    
    /**
	 * Does this contact generate TOI events for continuous simulation
	 */
    public function IsContinuous() : Bool
    {
        return (m_flags & e_continuousFlag) == e_continuousFlag;
    }
    
    /**
	 * Change this to be a sensor or-non-sensor contact.
	 */
    public function SetSensor(sensor : Bool) : Void
    {
        if (sensor)
        {
            m_flags = m_flags | e_sensorFlag;
        }
        else
        {
            m_flags = m_flags & as3hx.Compat.parseInt(~e_sensorFlag);
        }
    }
    
    /**
	 * Is this contact a sensor?
	 */
    public function IsSensor() : Bool
    {
        return (m_flags & e_sensorFlag) == e_sensorFlag;
    }
    
    /**
	 * Enable/disable this contact. This can be used inside the pre-solve
	 * contact listener. The contact is only disabled for the current
	 * time step (or sub-step in continuous collision).
	 */
    public function SetEnabled(flag : Bool) : Void
    {
        if (flag)
        {
            m_flags = m_flags | e_enabledFlag;
        }
        else
        {
            m_flags = m_flags & as3hx.Compat.parseInt(~e_enabledFlag);
        }
    }
    
    /**
	 * Has this contact been disabled?
	 * @return
	 */
    public function IsEnabled() : Bool
    {
        return (m_flags & e_enabledFlag) == e_enabledFlag;
    }
    
    /**
	* Get the next contact in the world's contact list.
	*/
    public function GetNext() : B2Contact
    {
        return m_next;
    }
    
    /**
	* Get the first fixture in this contact.
	*/
    public function GetFixtureA() : B2Fixture
    {
        return m_fixtureA;
    }
    
    /**
	* Get the second fixture in this contact.
	*/
    public function GetFixtureB() : B2Fixture
    {
        return m_fixtureB;
    }
    
    /**
	 * Flag this contact for filtering. Filtering will occur the next time step.
	 */
    public function FlagForFiltering() : Void
    {
        m_flags = m_flags | e_filterFlag;
    }
    
    //--------------- Internals Below -------------------
    
    // m_flags
    // enum
    // This contact should not participate in Solve
    // The contact equivalent of sensors
    private static var e_sensorFlag : Int = 0x0001;
    // Generate TOI events.
    private static var e_continuousFlag : Int = 0x0002;
    // Used when crawling contact graph when forming islands.
    private static var e_islandFlag : Int = 0x0004;
    // Used in SolveTOI to indicate the cached toi value is still valid.
    private static var e_toiFlag : Int = 0x0008;
    // Set when shapes are touching
    private static var e_touchingFlag : Int = 0x0010;
    // This contact can be disabled (by user)
    private static var e_enabledFlag : Int = 0x0020;
    // This contact needs filtering because a fixture filter was changed.
    private static var e_filterFlag : Int = 0x0040;
    
    public function new()
    {  // Real work is done in Reset  
        
    }
    
    /** @private */
    private function Reset(fixtureA : B2Fixture = null, fixtureB : B2Fixture = null) : Void
    {
        m_flags = e_enabledFlag;
        
        if (fixtureA == null || fixtureB == null)
        {
            m_fixtureA = null;
            m_fixtureB = null;
            return;
        }
        
        if (fixtureA.IsSensor() || fixtureB.IsSensor())
        {
            m_flags = m_flags | e_sensorFlag;
        }
        
        var bodyA : B2Body = fixtureA.GetBody();
        var bodyB : B2Body = fixtureB.GetBody();
        
        if (bodyA.GetType() != b2Body.b2_dynamicBody || bodyA.IsBullet() || bodyB.GetType() != b2Body.b2_dynamicBody || bodyB.IsBullet())
        {
            m_flags = m_flags | e_continuousFlag;
        }
        
        m_fixtureA = fixtureA;
        m_fixtureB = fixtureB;
        
        m_manifold.m_pointCount = 0;
        
        m_prev = null;
        m_next = null;
        
        m_nodeA.contact = null;
        m_nodeA.prev = null;
        m_nodeA.next = null;
        m_nodeA.other = null;
        
        m_nodeB.contact = null;
        m_nodeB.prev = null;
        m_nodeB.next = null;
        m_nodeB.other = null;
    }
    
    private function Update(listener : B2ContactListener) : Void
    // Swap old & new manifold
    {
        
        var tManifold : B2Manifold = m_oldManifold;
        m_oldManifold = m_manifold;
        m_manifold = tManifold;
        
        // Re-enable this contact
        m_flags = m_flags | e_enabledFlag;
        
        var touching : Bool = false;
        var wasTouching : Bool = (m_flags & e_touchingFlag) == e_touchingFlag;
        
        var bodyA : B2Body = m_fixtureA.m_body;
        var bodyB : B2Body = m_fixtureB.m_body;
        
        var aabbOverlap : Bool = m_fixtureA.m_aabb.TestOverlap(m_fixtureB.m_aabb);
        
        // Is this contat a sensor?
        if ((m_flags & e_sensorFlag) != 0)
        {
            if (aabbOverlap)
            {
                var shapeA : B2Shape = m_fixtureA.GetShape();
                var shapeB : B2Shape = m_fixtureB.GetShape();
                var xfA : B2Transform = bodyA.GetTransform();
                var xfB : B2Transform = bodyB.GetTransform();
                touching = b2Shape.TestOverlap(shapeA, xfA, shapeB, xfB);
            }
            
            // Sensors don't generate manifolds
            m_manifold.m_pointCount = 0;
        }
        // Slow contacts don't generate TOI events.
        else
        {
            
            if (bodyA.GetType() != b2Body.b2_dynamicBody || bodyA.IsBullet() || bodyB.GetType() != b2Body.b2_dynamicBody || bodyB.IsBullet())
            {
                m_flags = m_flags | e_continuousFlag;
            }
            else
            {
                m_flags = m_flags & as3hx.Compat.parseInt(~e_continuousFlag);
            }
            
            if (aabbOverlap)
            {
                Evaluate();
                
                touching = m_manifold.m_pointCount > 0;
                
                // Match old contact ids to new contact ids and copy the
                // stored impulses to warm start the solver.
                for (i in 0...m_manifold.m_pointCount)
                {
                    var mp2 : B2ManifoldPoint = m_manifold.m_points[i];
                    mp2.m_normalImpulse = 0.0;
                    mp2.m_tangentImpulse = 0.0;
                    var id2 : B2ContactID = mp2.m_id;
                    
                    for (j in 0...m_oldManifold.m_pointCount)
                    {
                        var mp1 : B2ManifoldPoint = m_oldManifold.m_points[j];
                        
                        if (mp1.m_id.key == id2.key)
                        {
                            mp2.m_normalImpulse = mp1.m_normalImpulse;
                            mp2.m_tangentImpulse = mp1.m_tangentImpulse;
                            break;
                        }
                    }
                }
            }
            else
            {
                m_manifold.m_pointCount = 0;
            }
            if (touching != wasTouching)
            {
                bodyA.SetAwake(true);
                bodyB.SetAwake(true);
            }
        }
        
        if (touching)
        {
            m_flags = m_flags | e_touchingFlag;
        }
        else
        {
            m_flags = m_flags & as3hx.Compat.parseInt(~e_touchingFlag);
        }
        
        if (wasTouching == false && touching == true)
        {
            listener.BeginContact(this);
        }
        
        if (wasTouching == true && touching == false)
        {
            listener.EndContact(this);
        }
        
        if ((m_flags & e_sensorFlag) == 0)
        {
            listener.PreSolve(this, m_oldManifold);
        }
    }
    
    //virtual ~b2Contact() {}
    
    private function Evaluate() : Void
    {
    }
    
    private static var s_input : B2TOIInput = new B2TOIInput();
    private function ComputeTOI(sweepA : B2Sweep, sweepB : B2Sweep) : Float
    {
        s_input.proxyA.Set(m_fixtureA.GetShape());
        s_input.proxyB.Set(m_fixtureB.GetShape());
        s_input.sweepA = sweepA;
        s_input.sweepB = sweepB;
        s_input.tolerance = b2Settings.b2_linearSlop;
        return b2TimeOfImpact.TimeOfImpact(s_input);
    }
    
    private var m_flags : Int;
    
    // World pool and list pointers.
    private var m_prev : B2Contact;
    private var m_next : B2Contact;
    
    // Nodes for connecting bodies.
    private var m_nodeA : B2ContactEdge = new B2ContactEdge();
    private var m_nodeB : B2ContactEdge = new B2ContactEdge();
    
    private var m_fixtureA : B2Fixture;
    private var m_fixtureB : B2Fixture;
    
    private var m_manifold : B2Manifold = new B2Manifold();
    private var m_oldManifold : B2Manifold = new B2Manifold();
    
    private var m_toi : Float;
}



