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

import haxe.Constraints.Function;
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
 * This class manages creation and destruction of b2Contact objects.
 * @private
 */
class B2ContactFactory
{
    private function new(allocator : Dynamic)
    {
        m_allocator = allocator;
        InitializeRegisters();
    }
    
    private function AddType(createFcn : Function, destroyFcn : Function, type1 : Int, type2 : Int) : Void
    //b2Settings.b2Assert(b2Shape.e_unknownShape < type1 && type1 < b2Shape.e_shapeTypeCount);
    {
        
        //b2Settings.b2Assert(b2Shape.e_unknownShape < type2 && type2 < b2Shape.e_shapeTypeCount);
        
        m_registers[type1][type2].createFcn = createFcn;
        m_registers[type1][type2].destroyFcn = destroyFcn;
        m_registers[type1][type2].primary = true;
        
        if (type1 != type2)
        {
            m_registers[type2][type1].createFcn = createFcn;
            m_registers[type2][type1].destroyFcn = destroyFcn;
            m_registers[type2][type1].primary = false;
        }
    }
    private function InitializeRegisters() : Void
    {
        m_registers = new Array<Array<B2ContactRegister>>();
        for (i in 0...b2Shape.e_shapeTypeCount)
        {
            m_registers[i] = new Array<B2ContactRegister>();
            for (j in 0...b2Shape.e_shapeTypeCount)
            {
                m_registers[i][j] = new B2ContactRegister();
            }
        }
        
        AddType(b2CircleContact.Create, b2CircleContact.Destroy, b2Shape.e_circleShape, b2Shape.e_circleShape);
        AddType(b2PolyAndCircleContact.Create, b2PolyAndCircleContact.Destroy, b2Shape.e_polygonShape, b2Shape.e_circleShape);
        AddType(b2PolygonContact.Create, b2PolygonContact.Destroy, b2Shape.e_polygonShape, b2Shape.e_polygonShape);
        
        AddType(b2EdgeAndCircleContact.Create, b2EdgeAndCircleContact.Destroy, b2Shape.e_edgeShape, b2Shape.e_circleShape);
        AddType(b2PolyAndEdgeContact.Create, b2PolyAndEdgeContact.Destroy, b2Shape.e_polygonShape, b2Shape.e_edgeShape);
    }
    public function Create(fixtureA : B2Fixture, fixtureB : B2Fixture) : B2Contact
    {
        var type1 : Int = fixtureA.GetType();
        var type2 : Int = fixtureB.GetType();
        
        //b2Settings.b2Assert(b2Shape.e_unknownShape < type1 && type1 < b2Shape.e_shapeTypeCount);
        //b2Settings.b2Assert(b2Shape.e_unknownShape < type2 && type2 < b2Shape.e_shapeTypeCount);
        
        var reg : B2ContactRegister = m_registers[type1][type2];
        
        var c : B2Contact;
        
        if (reg.pool)
        
        // Pop a contact off the pool{
            
            c = reg.pool;
            reg.pool = c.m_next;
            reg.poolCount--;
            c.Reset(fixtureA, fixtureB);
            return c;
        }
        
        var createFcn : Function = reg.createFcn;
        if (createFcn != null)
        {
            if (reg.primary)
            {
                c = createFcn(m_allocator);
                c.Reset(fixtureA, fixtureB);
                return c;
            }
            else
            {
                c = createFcn(m_allocator);
                c.Reset(fixtureB, fixtureA);
                return c;
            }
        }
        else
        {
            return null;
        }
    }
    public function Destroy(contact : B2Contact) : Void
    {
        if (contact.m_manifold.m_pointCount > 0)
        {
            contact.m_fixtureA.m_body.SetAwake(true);
            contact.m_fixtureB.m_body.SetAwake(true);
        }
        
        var type1 : Int = contact.m_fixtureA.GetType();
        var type2 : Int = contact.m_fixtureB.GetType();
        
        //b2Settings.b2Assert(b2Shape.e_unknownShape < type1 && type1 < b2Shape.e_shapeTypeCount);
        //b2Settings.b2Assert(b2Shape.e_unknownShape < type2 && type2 < b2Shape.e_shapeTypeCount);
        
        var reg : B2ContactRegister = m_registers[type1][type2];
        
        if (true)
        {
            reg.poolCount++;
            contact.m_next = reg.pool;
            reg.pool = contact;
        }
        
        var destroyFcn : Function = reg.destroyFcn;
        destroyFcn(contact, m_allocator);
    }
    
    
    private var m_registers : Array<Array<B2ContactRegister>>;
    private var m_allocator : Dynamic;
}



