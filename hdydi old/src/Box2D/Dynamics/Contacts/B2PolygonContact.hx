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

import box2D.collision.shapes.*;
import box2D.collision.*;
import box2D.dynamics.*;
import box2D.common.*;
import box2D.common.math.*;
import box2D.common.B2internal;

/**
* @private
*/
class B2PolygonContact extends B2Contact
{
    public static function Create(allocator : Dynamic) : B2Contact
    //void* mem = allocator->Allocate(sizeof(b2PolyContact));
    {
        
        return new B2PolygonContact();
    }
    public static function Destroy(contact : B2Contact, allocator : Dynamic) : Void
    {  //((b2PolyContact*)contact)->~b2PolyContact();  
        //allocator->Free(contact, sizeof(b2PolyContact));
        
    }
    
    public function Reset(fixtureA : B2Fixture, fixtureB : B2Fixture) : Void
    {
        super.Reset(fixtureA, fixtureB);
    }
    //~b2PolyContact() {}
    
    override private function Evaluate() : Void
    {
        var bA : B2Body = m_fixtureA.GetBody();
        var bB : B2Body = m_fixtureB.GetBody();
        
        b2Collision.CollidePolygons(m_manifold, 
                try cast(m_fixtureA.GetShape(), b2PolygonShape) catch(e:Dynamic) null, bA.m_xf, 
                try cast(m_fixtureB.GetShape(), b2PolygonShape) catch(e:Dynamic) null, bB.m_xf
        );
    }

    public function new()
    {
        super();
    }
}


