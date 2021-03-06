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

package box2D.dynamics;

import flash.errors.Error;
import haxe.Constraints.Function;
import box2D.common.math.*;
import box2D.common.*;
import box2D.collision.*;
import box2D.collision.shapes.*;
import box2D.dynamics.*;
import box2D.dynamics.contacts.*;
import box2D.dynamics.controllers.B2Controller;
import box2D.dynamics.controllers.B2ControllerEdge;
import box2D.dynamics.joints.*;
import box2D.common.B2internal;

/**
* The world class manages all physics entities, dynamic simulation,
* and asynchronous queries. 
*/
class B2World
{
    
    // Construct a world object.
    /**
	* @param gravity the world gravity vector.
	* @param doSleep improve performance by not simulating inactive bodies.
	*/
    public function new(gravity : B2Vec2, doSleep : Bool)
    {
        m_destructionListener = null;
        m_debugDraw = null;
        
        m_bodyList = null;
        m_contactList = null;
        m_jointList = null;
        m_controllerList = null;
        
        m_bodyCount = 0;
        m_contactCount = 0;
        m_jointCount = 0;
        m_controllerCount = 0;
        
        m_warmStarting = true;
        m_continuousPhysics = true;
        
        m_allowSleep = doSleep;
        m_gravity = gravity;
        
        m_inv_dt0 = 0.0;
        
        m_contactManager.m_world = this;
        
        var bd : B2BodyDef = new B2BodyDef();
        m_groundBody = cast((bd), CreateBody);
    }
    
    /**
	* Destruct the world. All physics entities are destroyed and all heap memory is released.
	*/
    //~b2World();
    
    /**
	* Register a destruction listener.
	*/
    public function SetDestructionListener(listener : B2DestructionListener) : Void
    {
        m_destructionListener = listener;
    }
    
    /**
	* Register a contact filter to provide specific control over collision.
	* Otherwise the default filter is used (b2_defaultFilter).
	*/
    public function SetContactFilter(filter : B2ContactFilter) : Void
    {
        m_contactManager.m_contactFilter = filter;
    }
    
    /**
	* Register a contact event listener
	*/
    public function SetContactListener(listener : B2ContactListener) : Void
    {
        m_contactManager.m_contactListener = listener;
    }
    
    /**
	* Register a routine for debug drawing. The debug draw functions are called
	* inside the b2World::Step method, so make sure your renderer is ready to
	* consume draw commands when you call Step().
	*/
    public function SetDebugDraw(debugDraw : B2DebugDraw) : Void
    {
        m_debugDraw = debugDraw;
    }
    
    /**
	 * Use the given object as a broadphase.
	 * The old broadphase will not be cleanly emptied.
	 * @warning It is not recommended you call this except immediately after constructing the world.
	 * @warning This function is locked during callbacks.
	 */
    public function SetBroadPhase(broadPhase : IBroadPhase) : Void
    {
        var oldBroadPhase : IBroadPhase = m_contactManager.m_broadPhase;
        m_contactManager.m_broadPhase = broadPhase;
        var b : B2Body = m_bodyList;
        while (b)
        {
            var f : B2Fixture = b.m_fixtureList;
            while (f)
            {
                f.m_proxy = broadPhase.CreateProxy(oldBroadPhase.GetFatAABB(f.m_proxy), f);
                f = f.m_next;
            }
            b = b.m_next;
        }
    }
    
    /**
	* Perform validation of internal data structures.
	*/
    public function Validate() : Void
    {
        m_contactManager.m_broadPhase.Validate();
    }
    
    /**
	* Get the number of broad-phase proxies.
	*/
    public function GetProxyCount() : Int
    {
        return m_contactManager.m_broadPhase.GetProxyCount();
    }
    
    /**
	* Create a rigid body given a definition. No reference to the definition
	* is retained.
	* @warning This function is locked during callbacks.
	*/
    public function CreateBody(def : B2BodyDef) : B2Body
    //b2Settings.b2Assert(m_lock == false);
    {
        
        if (IsLocked() == true)
        {
            return null;
        }
        
        //void* mem = m_blockAllocator.Allocate(sizeof(b2Body));
        var b : B2Body = new B2Body(def, this);
        
        // Add to world doubly linked list.
        b.m_prev = null;
        b.m_next = m_bodyList;
        if (m_bodyList)
        {
            m_bodyList.m_prev = b;
        }
        m_bodyList = b;
        ++m_bodyCount;
        
        return b;
    }
    
    /**
	* Destroy a rigid body given a definition. No reference to the definition
	* is retained. This function is locked during callbacks.
	* @warning This automatically deletes all associated shapes and joints.
	* @warning This function is locked during callbacks.
	*/
    public function DestroyBody(b : B2Body) : Void
    //b2Settings.b2Assert(m_bodyCount > 0);
    {
        
        //b2Settings.b2Assert(m_lock == false);
        if (IsLocked() == true)
        {
            return;
        }
        
        // Delete the attached joints.
        var jn : B2JointEdge = b.m_jointList;
        while (jn)
        {
            var jn0 : B2JointEdge = jn;
            jn = jn.next;
            
            if (m_destructionListener)
            {
                m_destructionListener.SayGoodbyeJoint(jn0.joint);
            }
            
            cast((jn0.joint), DestroyJoint);
        }
        
        // Detach controllers attached to this body
        var coe : B2ControllerEdge = b.m_controllerList;
        while (coe)
        {
            var coe0 : B2ControllerEdge = coe;
            coe = coe.nextController;
            coe0.controller.RemoveBody(b);
        }
        
        // Delete the attached contacts.
        var ce : B2ContactEdge = b.m_contactList;
        while (ce)
        {
            var ce0 : B2ContactEdge = ce;
            ce = ce.next;
            m_contactManager.Destroy(ce0.contact);
        }
        b.m_contactList = null;
        
        // Delete the attached fixtures. This destroys broad-phase
        // proxies.
        var f : B2Fixture = b.m_fixtureList;
        while (f)
        {
            var f0 : B2Fixture = f;
            f = f.m_next;
            
            if (m_destructionListener)
            {
                m_destructionListener.SayGoodbyeFixture(f0);
            }
            
            f0.DestroyProxy(m_contactManager.m_broadPhase);
            f0.Destroy();
        }
        b.m_fixtureList = null;
        b.m_fixtureCount = 0;
        
        // Remove world body list.
        if (b.m_prev)
        {
            b.m_prev.m_next = b.m_next;
        }
        
        if (b.m_next)
        {
            b.m_next.m_prev = b.m_prev;
        }
        
        if (b == m_bodyList)
        {
            m_bodyList = b.m_next;
        }
        
        --m_bodyCount;
    }
    
    /**
	* Create a joint to constrain bodies together. No reference to the definition
	* is retained. This may cause the connected bodies to cease colliding.
	* @warning This function is locked during callbacks.
	*/
    public function CreateJoint(def : B2JointDef) : B2Joint
    //b2Settings.b2Assert(m_lock == false);
    {
        
        
        var j : B2Joint = b2Joint.Create(def, null);
        
        // Connect to the world list.
        j.m_prev = null;
        j.m_next = m_jointList;
        if (m_jointList != null)
        {
            m_jointList.m_prev = j;
        }
        m_jointList = j;
        ++m_jointCount;
        
        // Connect to the bodies' doubly linked lists.
        j.m_edgeA.joint = j;
        j.m_edgeA.other = j.m_bodyB;
        j.m_edgeA.prev = null;
        j.m_edgeA.next = j.m_bodyA.m_jointList;
        if (j.m_bodyA.m_jointList)
        {
            j.m_bodyA.m_jointList.prev = j.m_edgeA;
        }
        j.m_bodyA.m_jointList = j.m_edgeA;
        
        j.m_edgeB.joint = j;
        j.m_edgeB.other = j.m_bodyA;
        j.m_edgeB.prev = null;
        j.m_edgeB.next = j.m_bodyB.m_jointList;
        if (j.m_bodyB.m_jointList)
        {
            j.m_bodyB.m_jointList.prev = j.m_edgeB;
        }
        j.m_bodyB.m_jointList = j.m_edgeB;
        
        var bodyA : B2Body = def.bodyA;
        var bodyB : B2Body = def.bodyB;
        
        // If the joint prevents collisions, then flag any contacts for filtering.
        if (def.collideConnected == false)
        {
            var edge : B2ContactEdge = bodyB.GetContactList();
            while (edge)
            {
                if (edge.other == bodyA)
                
                // Flag the contact for filtering at the next time step (where either{
                    
                    // body is awake).
                    edge.contact.FlagForFiltering();
                }
                
                edge = edge.next;
            }
        }
        
        // Note: creating a joint doesn't wake the bodies.
        
        return j;
    }
    
    /**
	* Destroy a joint. This may cause the connected bodies to begin colliding.
	* @warning This function is locked during callbacks.
	*/
    public function DestroyJoint(j : B2Joint) : Void
    //b2Settings.b2Assert(m_lock == false);
    {
        
        
        var collideConnected : Bool = j.m_collideConnected;
        
        // Remove from the doubly linked list.
        if (j.m_prev)
        {
            j.m_prev.m_next = j.m_next;
        }
        
        if (j.m_next)
        {
            j.m_next.m_prev = j.m_prev;
        }
        
        if (j == m_jointList)
        {
            m_jointList = j.m_next;
        }
        
        // Disconnect from island graph.
        var bodyA : B2Body = j.m_bodyA;
        var bodyB : B2Body = j.m_bodyB;
        
        // Wake up connected bodies.
        bodyA.SetAwake(true);
        bodyB.SetAwake(true);
        
        // Remove from body 1.
        if (j.m_edgeA.prev)
        {
            j.m_edgeA.prev.next = j.m_edgeA.next;
        }
        
        if (j.m_edgeA.next)
        {
            j.m_edgeA.next.prev = j.m_edgeA.prev;
        }
        
        if (j.m_edgeA == bodyA.m_jointList)
        {
            bodyA.m_jointList = j.m_edgeA.next;
        }
        
        j.m_edgeA.prev = null;
        j.m_edgeA.next = null;
        
        // Remove from body 2
        if (j.m_edgeB.prev)
        {
            j.m_edgeB.prev.next = j.m_edgeB.next;
        }
        
        if (j.m_edgeB.next)
        {
            j.m_edgeB.next.prev = j.m_edgeB.prev;
        }
        
        if (j.m_edgeB == bodyB.m_jointList)
        {
            bodyB.m_jointList = j.m_edgeB.next;
        }
        
        j.m_edgeB.prev = null;
        j.m_edgeB.next = null;
        
        b2Joint.Destroy(j, null);
        
        //b2Settings.b2Assert(m_jointCount > 0);
        --m_jointCount;
        
        // If the joint prevents collisions, then flag any contacts for filtering.
        if (collideConnected == false)
        {
            var edge : B2ContactEdge = bodyB.GetContactList();
            while (edge)
            {
                if (edge.other == bodyA)
                
                // Flag the contact for filtering at the next time step (where either{
                    
                    // body is awake).
                    edge.contact.FlagForFiltering();
                }
                
                edge = edge.next;
            }
        }
    }
    
    /**
	 * Add a controller to the world list
	 */
    public function AddController(c : B2Controller) : B2Controller
    {
        c.m_next = m_controllerList;
        c.m_prev = null;
        m_controllerList = c;
        
        c.m_world = this;
        
        m_controllerCount++;
        
        return c;
    }
    
    public function RemoveController(c : B2Controller) : Void
    //TODO: Remove bodies from controller
    {
        
        if (c.m_prev)
        {
            c.m_prev.m_next = c.m_next;
        }
        if (c.m_next)
        {
            c.m_next.m_prev = c.m_prev;
        }
        if (m_controllerList == c)
        {
            m_controllerList = c.m_next;
        }
        
        m_controllerCount--;
    }
    
    public function CreateController(controller : B2Controller) : B2Controller
    {
        if (controller.m_world != this)
        {
            throw new Error("Controller can only be a member of one world");
        }
        
        controller.m_next = m_controllerList;
        controller.m_prev = null;
        if (m_controllerList != null)
        {
            m_controllerList.m_prev = controller;
        }
        m_controllerList = controller;
        ++m_controllerCount;
        
        controller.m_world = this;
        
        return controller;
    }
    
    public function DestroyController(controller : B2Controller) : Void
    //b2Settings.b2Assert(m_controllerCount > 0);
    {
        
        controller.Clear();
        if (controller.m_next)
        {
            controller.m_next.m_prev = controller.m_prev;
        }
        if (controller.m_prev)
        {
            controller.m_prev.m_next = controller.m_next;
        }
        if (controller == m_controllerList)
        {
            m_controllerList = controller.m_next;
        }
        --m_controllerCount;
    }
    
    /**
	* Enable/disable warm starting. For testing.
	*/
    public function SetWarmStarting(flag : Bool) : Void
    {
        m_warmStarting = flag;
    }
    
    /**
	* Enable/disable continuous physics. For testing.
	*/
    public function SetContinuousPhysics(flag : Bool) : Void
    {
        m_continuousPhysics = flag;
    }
    
    /**
	* Get the number of bodies.
	*/
    public function GetBodyCount() : Int
    {
        return m_bodyCount;
    }
    
    /**
	* Get the number of joints.
	*/
    public function GetJointCount() : Int
    {
        return m_jointCount;
    }
    
    /**
	* Get the number of contacts (each may have 0 or more contact points).
	*/
    public function GetContactCount() : Int
    {
        return m_contactCount;
    }
    
    /**
	* Change the global gravity vector.
	*/
    public function SetGravity(gravity : B2Vec2) : Void
    {
        m_gravity = gravity;
    }
    
    /**
	* Get the global gravity vector.
	*/
    public function GetGravity() : B2Vec2
    {
        return m_gravity;
    }
    
    /**
	* The world provides a single static ground body with no collision shapes.
	* You can use this to simplify the creation of joints and static shapes.
	*/
    public function GetGroundBody() : B2Body
    {
        return m_groundBody;
    }
    
    private static var s_timestep2 : B2TimeStep = new B2TimeStep();
    /**
	* Take a time step. This performs collision detection, integration,
	* and constraint solution.
	* @param timeStep the amount of time to simulate, this should not vary.
	* @param velocityIterations for the velocity constraint solver.
	* @param positionIterations for the position constraint solver.
	*/
    public function Step(dt : Float, velocityIterations : Int, positionIterations : Int) : Void
    {
        if ((m_flags & e_newFixture) != 0)
        {
            m_contactManager.FindNewContacts();
            m_flags = m_flags & as3hx.Compat.parseInt(~e_newFixture);
        }
        
        m_flags = m_flags | e_locked;
        
        var step : B2TimeStep = s_timestep2;
        step.dt = dt;
        step.velocityIterations = velocityIterations;
        step.positionIterations = positionIterations;
        if (dt > 0.0)
        {
            step.inv_dt = 1.0 / dt;
        }
        else
        {
            step.inv_dt = 0.0;
        }
        
        step.dtRatio = m_inv_dt0 * dt;
        
        step.warmStarting = m_warmStarting;
        
        // Update contacts.
        m_contactManager.Collide();
        
        // Integrate velocities, solve velocity constraints, and integrate positions.
        if (step.dt > 0.0)
        {
            cast((step), Solve);
        }
        
        // Handle TOI events.
        if (m_continuousPhysics && step.dt > 0.0)
        {
            cast((step), SolveTOI);
        }
        
        if (step.dt > 0.0)
        {
            m_inv_dt0 = step.inv_dt;
        }
        m_flags = m_flags & as3hx.Compat.parseInt(~e_locked);
    }
    
    /**
	 * Call this after you are done with time steps to clear the forces. You normally
	 * call this after each call to Step, unless you are performing sub-steps.
	 */
    public function ClearForces() : Void
    {
        var body : B2Body = m_bodyList;
        while (body)
        {
            body.m_force.SetZero();
            body.m_torque = 0.0;
            body = body.m_next;
        }
    }
    
    private static var s_xf : B2Transform = new B2Transform();
    /**
	 * Call this to draw shapes and other debug draw data.
	 */
    public function DrawDebugData() : Void
    {
        if (m_debugDraw == null)
        {
            return;
        }
        
        m_debugDraw.m_sprite.graphics.clear();
        
        var flags : Int = m_debugDraw.GetFlags();
        
        var i : Int;
        var b : B2Body;
        var f : B2Fixture;
        var s : B2Shape;
        var j : B2Joint;
        var bp : IBroadPhase;
        var invQ : B2Vec2 = new B2Vec2();
        var x1 : B2Vec2 = new B2Vec2();
        var x2 : B2Vec2 = new B2Vec2();
        var xf : B2Transform;
        var b1 : B2AABB = new B2AABB();
        var b2 : B2AABB = new B2AABB();
        var vs : Array<Dynamic> = [new B2Vec2(), new B2Vec2(), new B2Vec2(), new B2Vec2()];
        
        // Store color here and reuse, to reduce allocations
        var color : B2Color = new B2Color(0, 0, 0);
        
        if ((flags & b2DebugDraw.e_shapeBit) != 0)
        {
            b = m_bodyList;
            while (b)
            {
                xf = b.m_xf;
                f = b.GetFixtureList();
                while (f)
                {
                    s = f.GetShape();
                    if (b.IsActive() == false)
                    {
                        color.Set(0.5, 0.5, 0.3);
                        DrawShape(s, xf, color);
                    }
                    else if (b.GetType() == b2Body.b2_staticBody)
                    {
                        color.Set(0.5, 0.9, 0.5);
                        DrawShape(s, xf, color);
                    }
                    else if (b.GetType() == b2Body.b2_kinematicBody)
                    {
                        color.Set(0.5, 0.5, 0.9);
                        DrawShape(s, xf, color);
                    }
                    else if (b.IsAwake() == false)
                    {
                        color.Set(0.6, 0.6, 0.6);
                        DrawShape(s, xf, color);
                    }
                    else
                    {
                        color.Set(0.9, 0.7, 0.7);
                        DrawShape(s, xf, color);
                    }
                    f = f.m_next;
                }
                b = b.m_next;
            }
        }
        
        if ((flags & b2DebugDraw.e_jointBit) != 0)
        {
            j = m_jointList;
            while (j)
            {
                cast((j), DrawJoint);
                j = j.m_next;
            }
        }
        
        if ((flags & b2DebugDraw.e_controllerBit) != 0)
        {
            var c : B2Controller = m_controllerList;
            while (c)
            {
                c.Draw(m_debugDraw);
                c = c.m_next;
            }
        }
        
        if ((flags & b2DebugDraw.e_pairBit) != 0)
        {
            color.Set(0.3, 0.9, 0.9);
            var contact : B2Contact = m_contactManager.m_contactList;
            while (contact)
            {
                var fixtureA : B2Fixture = contact.GetFixtureA();
                var fixtureB : B2Fixture = contact.GetFixtureB();
                
                var cA : B2Vec2 = fixtureA.GetAABB().GetCenter();
                var cB : B2Vec2 = fixtureB.GetAABB().GetCenter();
                
                m_debugDraw.DrawSegment(cA, cB, color);
                contact = contact.GetNext();
            }
        }
        
        if ((flags & b2DebugDraw.e_aabbBit) != 0)
        {
            bp = m_contactManager.m_broadPhase;
            
            vs = [new B2Vec2(), new B2Vec2(), new B2Vec2(), new B2Vec2()];
            
            b = m_bodyList;
            while (b)
            {
                if (b.IsActive() == false)
                {
                    {b = b.GetNext();continue;
                    }
                }
                f = b.GetFixtureList();
                while (f)
                {
                    var aabb : B2AABB = bp.GetFatAABB(f.m_proxy);
                    vs[0].Set(aabb.lowerBound.x, aabb.lowerBound.y);
                    vs[1].Set(aabb.upperBound.x, aabb.lowerBound.y);
                    vs[2].Set(aabb.upperBound.x, aabb.upperBound.y);
                    vs[3].Set(aabb.lowerBound.x, aabb.upperBound.y);
                    
                    m_debugDraw.DrawPolygon(vs, 4, color);
                    f = f.GetNext();
                }
                b = b.GetNext();
            }
        }
        
        if ((flags & b2DebugDraw.e_centerOfMassBit) != 0)
        {
            b = m_bodyList;
            while (b)
            {
                xf = s_xf;
                xf.R = b.m_xf.R;
                xf.position = b.GetWorldCenter();
                m_debugDraw.DrawTransform(xf);
                b = b.m_next;
            }
        }
    }
    
    /**
	 * Query the world for all fixtures that potentially overlap the
	 * provided AABB.
	 * @param callback a user implemented callback class. It should match signature
	 * <code>function Callback(fixture:b2Fixture):Boolean</code>
	 * Return true to continue to the next fixture.
	 * @param aabb the query box.
	 */
    public function QueryAABB(callback : Function, aabb : B2AABB) : Void
    {
        var broadPhase : IBroadPhase = m_contactManager.m_broadPhase;
        var WorldQueryWrapper : Dynamic->Bool = function(proxy : Dynamic) : Bool
        {
            return callback(broadPhase.GetUserData(proxy));
        }
        broadPhase.Query(WorldQueryWrapper, aabb);
    }
    /**
	 * Query the world for all fixtures that precisely overlap the
	 * provided transformed shape.
	 * @param callback a user implemented callback class. It should match signature
	 * <code>function Callback(fixture:b2Fixture):Boolean</code>
	 * Return true to continue to the next fixture.
	 * @asonly
	 */
    public function QueryShape(callback : Function, shape : B2Shape, transform : B2Transform = null) : Void
    {
        if (transform == null)
        {
            transform = new B2Transform();
            transform.SetIdentity();
        }
        var broadPhase : IBroadPhase = m_contactManager.m_broadPhase;
        var WorldQueryWrapper : Dynamic->Bool = function(proxy : Dynamic) : Bool
        {
            var fixture : B2Fixture = try cast(broadPhase.GetUserData(proxy), b2Fixture) catch(e:Dynamic) null;
            if (b2Shape.TestOverlap(shape, transform, fixture.GetShape(), fixture.GetBody().GetTransform()))
            {
                return callback(fixture);
            }
            return true;
        }
        var aabb : B2AABB = new B2AABB();
        shape.ComputeAABB(aabb, transform);
        broadPhase.Query(WorldQueryWrapper, aabb);
    }
    
    /**
	 * Query the world for all fixtures that contain a point.
	 * @param callback a user implemented callback class. It should match signature
	 * <code>function Callback(fixture:b2Fixture):Boolean</code>
	 * Return true to continue to the next fixture.
	 * @asonly
	 */
    public function QueryPoint(callback : Function, p : B2Vec2) : Void
    {
        var broadPhase : IBroadPhase = m_contactManager.m_broadPhase;
        function WorldQueryWrapper(proxy : Dynamic) : Bool
        {
            var fixture : B2Fixture = try cast(broadPhase.GetUserData(proxy), b2Fixture) catch(e:Dynamic) null;
            if (fixture.TestPoint(p))
            {
                return callback(fixture);
            }
            return true;
        }  // Make a small box.  ;
        
        var aabb : B2AABB = new B2AABB();
        aabb.lowerBound.Set(p.x - b2Settings.b2_linearSlop, p.y - b2Settings.b2_linearSlop);
        aabb.upperBound.Set(p.x + b2Settings.b2_linearSlop, p.y + b2Settings.b2_linearSlop);
        broadPhase.Query(WorldQueryWrapper, aabb);
    }
    
    /**
	 * Ray-cast the world for all fixtures in the path of the ray. Your callback
	 * Controls whether you get the closest point, any point, or n-points
	 * The ray-cast ignores shapes that contain the starting point
	 * @param callback A callback function which must be of signature:
	 * <code>function Callback(fixture:b2Fixture,    // The fixture hit by the ray
	 * point:b2Vec2,         // The point of initial intersection
	 * normal:b2Vec2,        // The normal vector at the point of intersection
	 * fraction:Number       // The fractional length along the ray of the intersection
	 * ):Number
	 * </code>
	 * Callback should return the new length of the ray as a fraction of the original length.
	 * By returning 0, you immediately terminate.
	 * By returning 1, you continue wiht the original ray.
	 * By returning the current fraction, you proceed to find the closest point.
	 * @param point1 the ray starting point
	 * @param point2 the ray ending point
	 */
    public function RayCast(callback : Function, point1 : B2Vec2, point2 : B2Vec2) : Void
    {
        var broadPhase : IBroadPhase = m_contactManager.m_broadPhase;
        var output : B2RayCastOutput = new B2RayCastOutput();
        var RayCastWrapper : B2RayCastInput->Dynamic->Float = function(input : B2RayCastInput, proxy : Dynamic) : Float
        {
            var userData : Dynamic = broadPhase.GetUserData(proxy);
            var fixture : B2Fixture = try cast(userData, b2Fixture) catch(e:Dynamic) null;
            var hit : Bool = fixture.RayCast(output, input);
            if (hit)
            {
                var fraction : Float = output.fraction;
                var point : B2Vec2 = new B2Vec2(
                (1.0 - fraction) * point1.x + fraction * point2.x, 
                (1.0 - fraction) * point1.y + fraction * point2.y);
                return callback(fixture, point, output.normal, fraction);
            }
            return input.maxFraction;
        }
        var input : B2RayCastInput = new B2RayCastInput(point1, point2);
        broadPhase.RayCast(RayCastWrapper, input);
    }
    
    public function RayCastOne(point1 : B2Vec2, point2 : B2Vec2) : B2Fixture
    {
        var result : B2Fixture;
        var RayCastOneWrapper : B2Fixture->B2Vec2->B2Vec2->Float->Float = function(fixture : B2Fixture, point : B2Vec2, normal : B2Vec2, fraction : Float) : Float
        {
            result = fixture;
            return fraction;
        }
        RayCast(RayCastOneWrapper, point1, point2);
        return result;
    }
    
    public function RayCastAll(point1 : B2Vec2, point2 : B2Vec2) : Array<B2Fixture>
    {
        var result : Array<B2Fixture> = new Array<B2Fixture>();
        var RayCastAllWrapper : B2Fixture->B2Vec2->B2Vec2->Float->Float = function(fixture : B2Fixture, point : B2Vec2, normal : B2Vec2, fraction : Float) : Float
        {
            result[result.length] = fixture;
            return 1;
        }
        RayCast(RayCastAllWrapper, point1, point2);
        return result;
    }
    
    /**
	* Get the world body list. With the returned body, use b2Body::GetNext to get
	* the next body in the world list. A NULL body indicates the end of the list.
	* @return the head of the world body list.
	*/
    public function GetBodyList() : B2Body
    {
        return m_bodyList;
    }
    
    /**
	* Get the world joint list. With the returned joint, use b2Joint::GetNext to get
	* the next joint in the world list. A NULL joint indicates the end of the list.
	* @return the head of the world joint list.
	*/
    public function GetJointList() : B2Joint
    {
        return m_jointList;
    }
    
    /**
	 * Get the world contact list. With the returned contact, use b2Contact::GetNext to get
	 * the next contact in the world list. A NULL contact indicates the end of the list.
	 * @return the head of the world contact list.
	 * @warning contacts are 
	 */
    public function GetContactList() : B2Contact
    {
        return m_contactList;
    }
    
    /**
	 * Is the world locked (in the middle of a time step).
	 */
    public function IsLocked() : Bool
    {
        return (m_flags & e_locked) > 0;
    }
    
    //--------------- Internals Below -------------------
    // Internal yet public to make life easier.
    
    // Find islands, integrate and solve constraints, solve position constraints
    private var s_stack : Array<B2Body> = new Array<B2Body>();
    private function Solve(step : B2TimeStep) : Void
    {
        var b : B2Body;
        
        // Step all controllers
        var controller : B2Controller = m_controllerList;
        while (controller)
        {
            controller.Step(step);
            controller = controller.m_next;
        }
        
        // Size the island for the worst case.
        var island : B2Island = m_island;
        island.Initialize(m_bodyCount, m_contactCount, m_jointCount, null, m_contactManager.m_contactListener, m_contactSolver);
        
        // Clear all the island flags.
        b = m_bodyList;
        while (b)
        {
            b.m_flags = b.m_flags & as3hx.Compat.parseInt(~b2Body.e_islandFlag);
            b = b.m_next;
        }
        var c : B2Contact = m_contactList;
        while (c)
        {
            c.m_flags = c.m_flags & as3hx.Compat.parseInt(~b2Contact.e_islandFlag);
            c = c.m_next;
        }
        var j : B2Joint = m_jointList;
        while (j)
        {
            j.m_islandFlag = false;
            j = j.m_next;
        }
        
        // Build and simulate all awake islands.
        var stackSize : Int = m_bodyCount;
        //b2Body** stack = (b2Body**)m_stackAllocator.Allocate(stackSize * sizeof(b2Body*));
        var stack : Array<B2Body> = s_stack;
        var seed : B2Body = m_bodyList;
        while (seed)
        {
            if ((seed.m_flags & b2Body.e_islandFlag) != 0)
            {
                {seed = seed.m_next;continue;
                }
            }
            
            if (seed.IsAwake() == false || seed.IsActive() == false)
            {
                {seed = seed.m_next;continue;
                }
            }
            
            // The seed can be dynamic or kinematic.
            if (seed.GetType() == b2Body.b2_staticBody)
            {
                {seed = seed.m_next;continue;
                }
            }
            
            // Reset island and stack.
            island.Clear();
            var stackCount : Int = 0;
            stack[stackCount++] = seed;
            seed.m_flags = seed.m_flags | b2Body.e_islandFlag;
            
            // Perform a depth first search (DFS) on the constraint graph.
            while (stackCount > 0)
            
            // Grab the next body off the stack and add it to the island.{
                
                b = stack[--stackCount];
                //b2Assert(b.IsActive() == true);
                island.AddBody(b);
                
                // Make sure the body is awake.
                if (b.IsAwake() == false)
                {
                    b.SetAwake(true);
                }
                
                // To keep islands as small as possible, we don't
                // propagate islands across static bodies.
                if (b.GetType() == b2Body.b2_staticBody)
                {
                    {seed = seed.m_next;continue;
                    }
                }
                
                var other : B2Body;
                // Search all contacts connected to this body.
                var ce : B2ContactEdge = b.m_contactList;
                while (ce)
                
                // Has this contact already been added to an island?{
                    
                    if ((ce.contact.m_flags & b2Contact.e_islandFlag) != 0)
                    {
                        {ce = ce.next;continue;
                        }
                    }
                    
                    // Is this contact solid and touching?
                    if (ce.contact.IsSensor() == true ||
                        ce.contact.IsEnabled() == false ||
                        ce.contact.IsTouching() == false)
                    {
                        {ce = ce.next;continue;
                        }
                    }
                    
                    island.AddContact(ce.contact);
                    ce.contact.m_flags = ce.contact.m_flags | b2Contact.e_islandFlag;
                    
                    //var other:b2Body = ce.other;
                    other = ce.other;
                    
                    // Was the other body already added to this island?
                    if ((other.m_flags & b2Body.e_islandFlag) != 0)
                    {
                        {ce = ce.next;continue;
                        }
                    }
                    
                    //b2Settings.b2Assert(stackCount < stackSize);
                    stack[stackCount++] = other;
                    other.m_flags = other.m_flags | b2Body.e_islandFlag;
                    ce = ce.next;
                }
                
                // Search all joints connect to this body.
                var jn : B2JointEdge = b.m_jointList;
                while (jn)
                {
                    if (jn.joint.m_islandFlag == true)
                    {
                        {jn = jn.next;continue;
                        }
                    }
                    
                    other = jn.other;
                    
                    // Don't simulate joints connected to inactive bodies.
                    if (other.IsActive() == false)
                    {
                        {jn = jn.next;continue;
                        }
                    }
                    
                    island.AddJoint(jn.joint);
                    jn.joint.m_islandFlag = true;
                    
                    if ((other.m_flags & b2Body.e_islandFlag) != 0)
                    {
                        {jn = jn.next;continue;
                        }
                    }
                    
                    //b2Settings.b2Assert(stackCount < stackSize);
                    stack[stackCount++] = other;
                    other.m_flags = other.m_flags | b2Body.e_islandFlag;
                    jn = jn.next;
                }
            }
            island.Solve(step, m_gravity, m_allowSleep);
            
            // Post solve cleanup.
            for (i in 0...island.m_bodyCount)
            
            // Allow static bodies to participate in other islands.{
                
                b = island.m_bodies[i];
                if (b.GetType() == b2Body.b2_staticBody)
                {
                    b.m_flags = b.m_flags & as3hx.Compat.parseInt(~b2Body.e_islandFlag);
                }
            }
            seed = seed.m_next;
        }
        
        //m_stackAllocator.Free(stack);
        for (i in 0...stack.length)
        {
            if (stack[i] == null)
            {
                break;
            }
            stack[i] = null;
        }
        
        // Synchronize fixutres, check for out of range bodies.
        b = m_bodyList;
        while (b)
        {
            if (b.IsAwake() == false || b.IsActive() == false)
            {
                {b = b.m_next;continue;
                }
            }
            
            if (b.GetType() == b2Body.b2_staticBody)
            {
                {b = b.m_next;continue;
                }
            }
            
            // Update fixtures (for broad-phase).
            b.SynchronizeFixtures();
            b = b.m_next;
        }
        
        // Look for new contacts.
        m_contactManager.FindNewContacts();
    }
    
    private static var s_backupA : B2Sweep = new B2Sweep();
    private static var s_backupB : B2Sweep = new B2Sweep();
    private static var s_timestep : B2TimeStep = new B2TimeStep();
    private static var s_queue : Array<B2Body> = new Array<B2Body>();
    // Find TOI contacts and solve them.
    private function SolveTOI(step : B2TimeStep) : Void
    {
        var b : B2Body;
        var fA : B2Fixture;
        var fB : B2Fixture;
        var bA : B2Body;
        var bB : B2Body;
        var cEdge : B2ContactEdge;
        var j : B2Joint;
        
        // Reserve an island and a queue for TOI island solution.
        var island : B2Island = m_island;
        island.Initialize(m_bodyCount, b2Settings.b2_maxTOIContactsPerIsland, b2Settings.b2_maxTOIJointsPerIsland, null, m_contactManager.m_contactListener, m_contactSolver);
        
        //Simple one pass queue
        //Relies on the fact that we're only making one pass
        //through and each body can only be pushed/popped one.
        //To push:
        //  queue[queueStart+queueSize++] = newElement;
        //To pop:
        //  poppedElement = queue[queueStart++];
        //  --queueSize;
        
        var queue : Array<B2Body> = s_queue;
        
        b = m_bodyList;
        while (b)
        {
            b.m_flags = b.m_flags & as3hx.Compat.parseInt(~b2Body.e_islandFlag);
            b.m_sweep.t0 = 0.0;
            b = b.m_next;
        }
        
        var c : B2Contact;
        c = m_contactList;
        while (c)
        
        // Invalidate TOI{
            
            c.m_flags = c.m_flags & as3hx.Compat.parseInt(~(b2Contact.e_toiFlag | b2Contact.e_islandFlag));
            c = c.m_next;
        }
        
        j = m_jointList;
        while (j)
        {
            j.m_islandFlag = false;
            j = j.m_next;
        }
        
        // Find TOI events and solve them.
        while (true)
        
        // Find the first TOI.{
            
            var minContact : B2Contact = null;
            var minTOI : Float = 1.0;
            
            c = m_contactList;
            while (c)
            
            // Can this contact generate a solid TOI contact?{
                
                if (c.IsSensor() == true ||
                    c.IsEnabled() == false ||
                    c.IsContinuous() == false)
                {
                    {c = c.m_next;continue;
                    }
                }
                
                // TODO_ERIN keep a counter on the contact, only respond to M TOIs per contact.
                
                var toi : Float = 1.0;
                if ((c.m_flags & b2Contact.e_toiFlag) != 0)
                
                // This contact has a valid cached TOI.{
                    
                    toi = c.m_toi;
                }
                // Compute the TOI for this contact.
                else
                {
                    
                    fA = c.m_fixtureA;
                    fB = c.m_fixtureB;
                    bA = fA.m_body;
                    bB = fB.m_body;
                    
                    if ((bA.GetType() != b2Body.b2_dynamicBody || bA.IsAwake() == false) &&
                        (bB.GetType() != b2Body.b2_dynamicBody || bB.IsAwake() == false))
                    {
                        {c = c.m_next;continue;
                        }
                    }
                    
                    // Put the sweeps onto the same time interval.
                    var t0 : Float = bA.m_sweep.t0;
                    
                    if (bA.m_sweep.t0 < bB.m_sweep.t0)
                    {
                        t0 = bB.m_sweep.t0;
                        bA.m_sweep.Advance(t0);
                    }
                    else if (bB.m_sweep.t0 < bA.m_sweep.t0)
                    {
                        t0 = bA.m_sweep.t0;
                        bB.m_sweep.Advance(t0);
                    }
                    
                    //b2Settings.b2Assert(t0 < 1.0f);
                    
                    // Compute the time of impact.
                    toi = c.ComputeTOI(bA.m_sweep, bB.m_sweep);
                    b2Settings.b2Assert(0.0 <= toi && toi <= 1.0);
                    
                    // If the TOI is in range ...
                    if (toi > 0.0 && toi < 1.0)
                    
                    // Interpolate on the actual range.{
                        
                        //toi = Math.min((1.0 - toi) * t0 + toi, 1.0);
                        toi = (1.0 - toi) * t0 + toi;
                        if (toi > 1)
                        {
                            toi = 1;
                        }
                    }
                    
                    
                    c.m_toi = toi;
                    c.m_flags = c.m_flags | b2Contact.e_toiFlag;
                }
                
                if (as3hx.Compat.FLOAT_MIN < toi && toi < minTOI)
                
                // This is the minimum TOI found so far.{
                    
                    minContact = c;
                    minTOI = toi;
                }
                c = c.m_next;
            }
            
            if (minContact == null || 1.0 - 100.0 * as3hx.Compat.FLOAT_MIN < minTOI)
            
            // No more TOI events. Done!{
                
                break;
            }
            
            // Advance the bodies to the TOI.
            fA = minContact.m_fixtureA;
            fB = minContact.m_fixtureB;
            bA = fA.m_body;
            bB = fB.m_body;
            s_backupA.Set(bA.m_sweep);
            s_backupB.Set(bB.m_sweep);
            bA.Advance(minTOI);
            bB.Advance(minTOI);
            
            // The TOI contact likely has some new contact points.
            minContact.Update(m_contactManager.m_contactListener);
            minContact.m_flags = minContact.m_flags & as3hx.Compat.parseInt(~b2Contact.e_toiFlag);
            
            // Is the contact solid?
            if (minContact.IsSensor() == true ||
                minContact.IsEnabled() == false)
            
            // Restore the sweeps{
                
                bA.m_sweep.Set(s_backupA);
                bB.m_sweep.Set(s_backupB);
                bA.SynchronizeTransform();
                bB.SynchronizeTransform();
                continue;
            }
            
            // Did numerical issues prevent;,ontact pointjrom being generated
            if (minContact.IsTouching() == false)
            
            // Give up on this TOI{
                
                continue;
            }
            
            // Build the TOI island. We need a dynamic seed.
            var seed : B2Body = bA;
            if (seed.GetType() != b2Body.b2_dynamicBody)
            {
                seed = bB;
            }
            
            // Reset island and queue.
            island.Clear();
            var queueStart : Int = 0;  //start index for queue  
            var queueSize : Int = 0;  //elements in queue  
            queue[queueStart + queueSize++] = seed;
            seed.m_flags = seed.m_flags | b2Body.e_islandFlag;
            
            // Perform a breadth first search (BFS) on the contact graph.
            while (queueSize > 0)
            
            // Grab the next body off the stack and add it to the island.{
                
                b = queue[queueStart++];
                --queueSize;
                
                island.AddBody(b);
                
                // Make sure the body is awake.
                if (b.IsAwake() == false)
                {
                    b.SetAwake(true);
                }
                
                // To keep islands as small as possible, we don't
                // propagate islands across static or kinematic bodies.
                if (b.GetType() != b2Body.b2_dynamicBody)
                {
                    continue;
                }
                
                // Search all contacts connected to this body.
                cEdge = b.m_contactList;
                while (cEdge)
                
                // Does the TOI island still have space for contacts?{
                    
                    if (island.m_contactCount == island.m_contactCapacity)
                    {
                        break;
                    }
                    
                    // Has this contact already been added to an island?
                    if ((cEdge.contact.m_flags & b2Contact.e_islandFlag) != 0)
                    {
                        {cEdge = cEdge.next;continue;
                        }
                    }
                    
                    // Skip sperate, sensor, or disabled contacts.
                    if (cEdge.contact.IsSensor() == true ||
                        cEdge.contact.IsEnabled() == false ||
                        cEdge.contact.IsTouching() == false)
                    {
                        {cEdge = cEdge.next;continue;
                        }
                    }
                    
                    island.AddContact(cEdge.contact);
                    cEdge.contact.m_flags = cEdge.contact.m_flags | b2Contact.e_islandFlag;
                    
                    // Update other body.
                    var other : B2Body = cEdge.other;
                    
                    // Was the other body already added to this island?
                    if ((other.m_flags & b2Body.e_islandFlag) != 0)
                    {
                        {cEdge = cEdge.next;continue;
                        }
                    }
                    
                    // Synchronize the connected body.
                    if (other.GetType() != b2Body.b2_staticBody)
                    {
                        other.Advance(minTOI);
                        other.SetAwake(true);
                    }
                    
                    //b2Settings.b2Assert(queueStart + queueSize < queueCapacity);
                    queue[queueStart + queueSize] = other;
                    ++queueSize;
                    other.m_flags = other.m_flags | b2Body.e_islandFlag;
                    cEdge = cEdge.next;
                }
                
                var jEdge : B2JointEdge = b.m_jointList;
                while (jEdge)
                {
                    if (island.m_jointCount == island.m_jointCapacity)
                    {
                        {jEdge = jEdge.next;continue;
                        }
                    }
                    
                    if (jEdge.joint.m_islandFlag == true)
                    {
                        {jEdge = jEdge.next;continue;
                        }
                    }
                    
                    other = jEdge.other;
                    if (other.IsActive() == false)
                    {
                        {jEdge = jEdge.next;continue;
                        }
                    }
                    
                    island.AddJoint(jEdge.joint);
                    jEdge.joint.m_islandFlag = true;
                    
                    if ((other.m_flags & b2Body.e_islandFlag) != 0)
                    {
                        {jEdge = jEdge.next;continue;
                        }
                    }
                    
                    // Synchronize the connected body.
                    if (other.GetType() != b2Body.b2_staticBody)
                    {
                        other.Advance(minTOI);
                        other.SetAwake(true);
                    }
                    
                    //b2Settings.b2Assert(queueStart + queueSize < queueCapacity);
                    queue[queueStart + queueSize] = other;
                    ++queueSize;
                    other.m_flags = other.m_flags | b2Body.e_islandFlag;
                    jEdge = jEdge.next;
                }
            }
            
            var subStep : B2TimeStep = s_timestep;
            subStep.warmStarting = false;
            subStep.dt = (1.0 - minTOI) * step.dt;
            subStep.inv_dt = 1.0 / subStep.dt;
            subStep.dtRatio = 0.0;
            subStep.velocityIterations = step.velocityIterations;
            subStep.positionIterations = step.positionIterations;
            
            island.SolveTOI(subStep);
            
            var i : Int;
            // Post solve cleanup.
            for (i in 0...island.m_bodyCount)
            
            // Allow bodies to participate in future TOI islands.{
                
                b = island.m_bodies[i];
                b.m_flags = b.m_flags & as3hx.Compat.parseInt(~b2Body.e_islandFlag);
                
                if (b.IsAwake() == false)
                {
                    continue;
                }
                
                if (b.GetType() != b2Body.b2_dynamicBody)
                {
                    continue;
                }
                
                // Update fixtures (for broad-phase).
                b.SynchronizeFixtures();
                
                // Invalidate all contact TOIs associated with this body. Some of these
                // may not be in the island because they were not touching.
                cEdge = b.m_contactList;
                while (cEdge)
                {
                    cEdge.contact.m_flags = cEdge.contact.m_flags & as3hx.Compat.parseInt(~b2Contact.e_toiFlag);
                    cEdge = cEdge.next;
                }
            }
            
            for (i in 0...island.m_contactCount)
            
            // Allow contacts to participate in future TOI islands.{
                
                c = island.m_contacts[i];
                c.m_flags = c.m_flags & as3hx.Compat.parseInt(~(b2Contact.e_toiFlag | b2Contact.e_islandFlag));
            }
            
            for (i in 0...island.m_jointCount)
            
            // Allow joints to participate in future TOI islands{
                
                j = island.m_joints[i];
                j.m_islandFlag = false;
            }
            
            // Commit fixture proxy movements to the broad-phase so that new contacts are created.
            // Also, some contacts can be destroyed.
            m_contactManager.FindNewContacts();
        }
    }
    
    private static var s_jointColor : B2Color = new B2Color(0.5, 0.8, 0.8);
    //
    private function DrawJoint(joint : B2Joint) : Void
    {
        var b1 : B2Body = joint.GetBodyA();
        var b2 : B2Body = joint.GetBodyB();
        var xf1 : B2Transform = b1.m_xf;
        var xf2 : B2Transform = b2.m_xf;
        var x1 : B2Vec2 = xf1.position;
        var x2 : B2Vec2 = xf2.position;
        var p1 : B2Vec2 = joint.GetAnchorA();
        var p2 : B2Vec2 = joint.GetAnchorB();
        
        //b2Color color(0.5f, 0.8f, 0.8f);
        var color : B2Color = s_jointColor;
        
        var _sw0_ = (joint.m_type);        

        switch (_sw0_)
        {
            case b2Joint.e_distanceJoint:
                m_debugDraw.DrawSegment(p1, p2, color);
            
            case b2Joint.e_pulleyJoint:
            {
                var pulley : B2PulleyJoint = (try cast(joint, b2PulleyJoint) catch(e:Dynamic) null);
                var s1 : B2Vec2 = pulley.GetGroundAnchorA();
                var s2 : B2Vec2 = pulley.GetGroundAnchorB();
                m_debugDraw.DrawSegment(s1, p1, color);
                m_debugDraw.DrawSegment(s2, p2, color);
                m_debugDraw.DrawSegment(s1, s2, color);
            }
            
            case b2Joint.e_mouseJoint:
                m_debugDraw.DrawSegment(p1, p2, color);
            default:
                if (b1 != m_groundBody)
                {
                    m_debugDraw.DrawSegment(x1, p1, color);
                }
                m_debugDraw.DrawSegment(p1, p2, color);
                if (b2 != m_groundBody)
                {
                    m_debugDraw.DrawSegment(x2, p2, color);
                }
        }
    }
    
    private function DrawShape(shape : B2Shape, xf : B2Transform, color : B2Color) : Void
    {
        var _sw1_ = (shape.m_type);        

        switch (_sw1_)
        {
            case b2Shape.e_circleShape:
            {
                var circle : B2CircleShape = (try cast(shape, b2CircleShape) catch(e:Dynamic) null);
                
                var center : B2Vec2 = b2Math.MulX(xf, circle.m_p);
                var radius : Float = circle.m_radius;
                var axis : B2Vec2 = xf.R.col1;
                
                m_debugDraw.DrawSolidCircle(center, radius, axis, color);
            }
            
            case b2Shape.e_polygonShape:
            {
                var i : Int;
                var poly : B2PolygonShape = (try cast(shape, b2PolygonShape) catch(e:Dynamic) null);
                var vertexCount : Int = poly.GetVertexCount();
                var localVertices : Array<B2Vec2> = poly.GetVertices();
                
                var vertices : Array<B2Vec2> = new Array<B2Vec2>();
                
                for (i in 0...vertexCount)
                {
                    vertices[i] = b2Math.MulX(xf, localVertices[i]);
                }
                
                m_debugDraw.DrawSolidPolygon(vertices, vertexCount, color);
            }
            
            case b2Shape.e_edgeShape:
            {
                var edge : B2EdgeShape = try cast(shape, b2EdgeShape) catch(e:Dynamic) null;
                
                m_debugDraw.DrawSegment(b2Math.MulX(xf, edge.GetVertex1()), b2Math.MulX(xf, edge.GetVertex2()), color);
            }
        }
    }
    
    private var m_flags : Int;
    
    private var m_contactManager : B2ContactManager = new B2ContactManager();
    
    // These two are stored purely for efficiency purposes, they don't maintain
    // any data outside of a call to Step
    private var m_contactSolver : B2ContactSolver = new B2ContactSolver();
    private var m_island : B2Island = new B2Island();
    
    private var m_bodyList : B2Body;
    private var m_jointList : B2Joint;
    
    private var m_contactList : B2Contact;
    
    private var m_bodyCount : Int;
    private var m_contactCount : Int;
    private var m_jointCount : Int;
    private var m_controllerList : B2Controller;
    private var m_controllerCount : Int;
    
    private var m_gravity : B2Vec2;
    private var m_allowSleep : Bool;
    
    private var m_groundBody : B2Body;
    
    private var m_destructionListener : B2DestructionListener;
    private var m_debugDraw : B2DebugDraw;
    
    // This is used to compute the time step ratio to support a variable time step.
    private var m_inv_dt0 : Float;
    
    // This is for debugging the solver.
    private static var m_warmStarting : Bool;
    
    // This is for debugging the solver.
    private static var m_continuousPhysics : Bool;
    
    // m_flags
    public static inline var e_newFixture : Int = 0x0001;
    public static inline var e_locked : Int = 0x0002;
}




