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

package box2D.dynamics.joints;

import box2D.common.math.*;
import box2D.common.*;
import box2D.dynamics.*;
import box2D.common.B2internal;

/**
* The base joint class. Joints are used to constraint two bodies together in
* various fashions. Some joints also feature limits and motors.
* @see b2JointDef
*/
class B2Joint
{
    /**
	* Get the type of the concrete joint.
	*/
    public function GetType() : Int
    {
        return m_type;
    }
    
    /**
	* Get the anchor point on bodyA in world coordinates.
	*/
    public function GetAnchorA() : B2Vec2
    {
        return null;
    }
    /**
	* Get the anchor point on bodyB in world coordinates.
	*/
    public function GetAnchorB() : B2Vec2
    {
        return null;
    }
    
    /**
	* Get the reaction force on body2 at the joint anchor in Newtons.
	*/
    public function GetReactionForce(inv_dt : Float) : B2Vec2
    {
        return null;
    }
    /**
	* Get the reaction torque on body2 in N*m.
	*/
    public function GetReactionTorque(inv_dt : Float) : Float
    {
        return 0.0;
    }
    
    /**
	* Get the first body attached to this joint.
	*/
    public function GetBodyA() : B2Body
    {
        return m_bodyA;
    }
    
    /**
	* Get the second body attached to this joint.
	*/
    public function GetBodyB() : B2Body
    {
        return m_bodyB;
    }
    
    /**
	* Get the next joint the world joint list.
	*/
    public function GetNext() : B2Joint
    {
        return m_next;
    }
    
    /**
	* Get the user data pointer.
	*/
    public function GetUserData() : Dynamic
    {
        return m_userData;
    }
    
    /**
	* Set the user data pointer.
	*/
    public function SetUserData(data : Dynamic) : Void
    {
        m_userData = data;
    }
    
    /**
	 * Short-cut function to determine if either body is inactive.
	 * @return
	 */
    public function IsActive() : Bool
    {
        return m_bodyA.IsActive() && m_bodyB.IsActive();
    }
    
    //--------------- Internals Below -------------------
    
    private static function Create(def : B2JointDef, allocator : Dynamic) : B2Joint
    {
        var joint : B2Joint = null;
        
        var _sw0_ = (def.type);        

        switch (_sw0_)
        {
            case e_distanceJoint:
            {
                //void* mem = allocator->Allocate(sizeof(b2DistanceJoint));
                joint = new B2DistanceJoint(try cast(def, b2DistanceJointDef) catch(e:Dynamic) null);
            }
            
            case e_mouseJoint:
            {
                //void* mem = allocator->Allocate(sizeof(b2MouseJoint));
                joint = new B2MouseJoint(try cast(def, b2MouseJointDef) catch(e:Dynamic) null);
            }
            
            case e_prismaticJoint:
            {
                //void* mem = allocator->Allocate(sizeof(b2PrismaticJoint));
                joint = new B2PrismaticJoint(try cast(def, b2PrismaticJointDef) catch(e:Dynamic) null);
            }
            
            case e_revoluteJoint:
            {
                //void* mem = allocator->Allocate(sizeof(b2RevoluteJoint));
                joint = new B2RevoluteJoint(try cast(def, b2RevoluteJointDef) catch(e:Dynamic) null);
            }
            
            case e_pulleyJoint:
            {
                //void* mem = allocator->Allocate(sizeof(b2PulleyJoint));
                joint = new B2PulleyJoint(try cast(def, b2PulleyJointDef) catch(e:Dynamic) null);
            }
            
            case e_gearJoint:
            {
                //void* mem = allocator->Allocate(sizeof(b2GearJoint));
                joint = new B2GearJoint(try cast(def, b2GearJointDef) catch(e:Dynamic) null);
            }
            
            case e_lineJoint:
            {
                //void* mem = allocator->Allocate(sizeof(b2LineJoint));
                joint = new B2LineJoint(try cast(def, b2LineJointDef) catch(e:Dynamic) null);
            }
            
            case e_weldJoint:
            {
                //void* mem = allocator->Allocate(sizeof(b2WeldJoint));
                joint = new B2WeldJoint(try cast(def, b2WeldJointDef) catch(e:Dynamic) null);
            }
            
            case e_frictionJoint:
            {
                //void* mem = allocator->Allocate(sizeof(b2FrictionJoint));
                joint = new B2FrictionJoint(try cast(def, b2FrictionJointDef) catch(e:Dynamic) null);
            }
            default:
                //b2Settings.b2Assert(false);
                break;
        }
        
        return joint;
    }
    
    private static function Destroy(joint : B2Joint, allocator : Dynamic) : Void
    {  /*joint->~b2Joint();
		switch (joint.m_type)
		{
		case e_distanceJoint:
			allocator->Free(joint, sizeof(b2DistanceJoint));
			break;
		
		case e_mouseJoint:
			allocator->Free(joint, sizeof(b2MouseJoint));
			break;
		
		case e_prismaticJoint:
			allocator->Free(joint, sizeof(b2PrismaticJoint));
			break;
		
		case e_revoluteJoint:
			allocator->Free(joint, sizeof(b2RevoluteJoint));
			break;
		
		case e_pulleyJoint:
			allocator->Free(joint, sizeof(b2PulleyJoint));
			break;
		
		case e_gearJoint:
			allocator->Free(joint, sizeof(b2GearJoint));
			break;
		
		case e_lineJoint:
			allocator->Free(joint, sizeof(b2LineJoint));
			break;
			
		case e_weldJoint:
			allocator->Free(joint, sizeof(b2WeldJoint));
			break;
			
		case e_frictionJoint:
			allocator->Free(joint, sizeof(b2FrictionJoint));
			break;
		
		default:
			b2Assert(false);
			break;
		}*/  
        
    }
    
    /** @private */
    public function new(def : B2JointDef)
    {
        b2Settings.b2Assert(def.bodyA != def.bodyB);
        m_type = def.type;
        m_prev = null;
        m_next = null;
        m_bodyA = def.bodyA;
        m_bodyB = def.bodyB;
        m_collideConnected = def.collideConnected;
        m_islandFlag = false;
        m_userData = def.userData;
    }
    //virtual ~b2Joint() {}
    
    private function InitVelocityConstraints(step : B2TimeStep) : Void
    {
    }
    private function SolveVelocityConstraints(step : B2TimeStep) : Void
    {
    }
    private function FinalizeVelocityConstraints() : Void
    {
    }
    
    // This returns true if the position errors are within tolerance.
    private function SolvePositionConstraints(baumgarte : Float) : Bool
    {
        return false;
    }
    
    private var m_type : Int;
    private var m_prev : B2Joint;
    private var m_next : B2Joint;
    private var m_edgeA : B2JointEdge = new B2JointEdge();
    private var m_edgeB : B2JointEdge = new B2JointEdge();
    private var m_bodyA : B2Body;
    private var m_bodyB : B2Body;
    
    private var m_islandFlag : Bool;
    private var m_collideConnected : Bool;
    
    private var m_userData : Dynamic;
    
    // Cache here per time step to reduce cache misses.
    private var m_localCenterA : B2Vec2 = new B2Vec2();
    private var m_localCenterB : B2Vec2 = new B2Vec2();
    private var m_invMassA : Float;
    private var m_invMassB : Float;
    private var m_invIA : Float;
    private var m_invIB : Float;
    
    // ENUMS
    
    // enum b2JointType
    private static inline var e_unknownJoint : Int = 0;
    private static inline var e_revoluteJoint : Int = 1;
    private static inline var e_prismaticJoint : Int = 2;
    private static inline var e_distanceJoint : Int = 3;
    private static inline var e_pulleyJoint : Int = 4;
    private static inline var e_mouseJoint : Int = 5;
    private static inline var e_gearJoint : Int = 6;
    private static inline var e_lineJoint : Int = 7;
    private static inline var e_weldJoint : Int = 8;
    private static inline var e_frictionJoint : Int = 9;
    
    // enum b2LimitState
    private static inline var e_inactiveLimit : Int = 0;
    private static inline var e_atLowerLimit : Int = 1;
    private static inline var e_atUpperLimit : Int = 2;
    private static inline var e_equalLimits : Int = 3;
}




