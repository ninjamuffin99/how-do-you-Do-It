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

package box2D.collision;

import box2D.common.math.*;
import box2D.common.*;
import box2D.collision.shapes.*;
import box2D.collision.*;
import box2D.common.B2internal;

/**
* @private
*/
class B2Distance
{
    
    // GJK using Voronoi regions (Christer Ericson) and Barycentric coordinates.
    
    private static var b2_gjkCalls : Int;
    private static var b2_gjkIters : Int;
    private static var b2_gjkMaxIters : Int;
    
    private static var s_simplex : B2Simplex = new B2Simplex();
    private static var s_saveA : Array<Int> = new Array<Int>();
    private static var s_saveB : Array<Int> = new Array<Int>();
    public static function Distance(output : B2DistanceOutput, cache : B2SimplexCache, input : B2DistanceInput) : Void
    {
        ++b2_gjkCalls;
        
        var proxyA : B2DistanceProxy = input.proxyA;
        var proxyB : B2DistanceProxy = input.proxyB;
        
        var transformA : B2Transform = input.transformA;
        var transformB : B2Transform = input.transformB;
        
        // Initialize the simplex
        var simplex : B2Simplex = s_simplex;
        simplex.ReadCache(cache, proxyA, transformA, proxyB, transformB);
        
        // Get simplex vertices as an vector.
        var vertices : Array<B2SimplexVertex> = simplex.m_vertices;
        var k_maxIters : Int = 20;
        
        // These store the vertices of the last simplex so that we
        // can check for duplicates and preven cycling
        var saveA : Array<Int> = s_saveA;
        var saveB : Array<Int> = s_saveB;
        var saveCount : Int = 0;
        
        var closestPoint : B2Vec2 = simplex.GetClosestPoint();
        var distanceSqr1 : Float = closestPoint.LengthSquared();
        var distanceSqr2 : Float = distanceSqr1;
        
        var i : Int;
        var p : B2Vec2;
        
        // Main iteration loop
        var iter : Int = 0;
        while (iter < k_maxIters)
        
        // Copy the simplex so that we can identify duplicates{
            
            saveCount = simplex.m_count;
            for (i in 0...saveCount)
            {
                saveA[i] = vertices[i].indexA;
                saveB[i] = vertices[i].indexB;
            }
            
            var _sw0_ = (simplex.m_count);            

            switch (_sw0_)
            {
                case 1:
                case 2:
                    simplex.Solve2();
                case 3:
                    simplex.Solve3();
                default:
                    b2Settings.b2Assert(false);
            }
            
            // If we have 3 points, then the origin is in the corresponding triangle.
            if (simplex.m_count == 3)
            {
                break;
            }
            
            // Compute the closest point.
            p = simplex.GetClosestPoint();
            distanceSqr2 = p.LengthSquared();
            
            // Ensure progress
            if (distanceSqr2 > distanceSqr1)
            {  //break;  
                
            }
            distanceSqr1 = distanceSqr2;
            
            // Get search direction.
            var d : B2Vec2 = simplex.GetSearchDirection();
            
            // Ensure the search direction is numerically fit.
            if (d.LengthSquared() < as3hx.Compat.FLOAT_MIN * as3hx.Compat.FLOAT_MIN)
            
            // THe origin is probably contained by a line segment or triangle.{
                
                // Thus the shapes are overlapped.
                
                // We can't return zero here even though there may be overlap.
                // In case the simplex is a point, segment or triangle it is very difficult
                // to determine if the origin is contained in the CSO or very close to it
                break;
            }
            
            // Compute a tentative new simplex vertex using support points
            var vertex : B2SimplexVertex = vertices[simplex.m_count];
            vertex.indexA = proxyA.GetSupport(b2Math.MulTMV(transformA.R, d.GetNegative()));
            vertex.wA = b2Math.MulX(transformA, proxyA.GetVertex(vertex.indexA));
            vertex.indexB = proxyB.GetSupport(b2Math.MulTMV(transformB.R, d));
            vertex.wB = b2Math.MulX(transformB, proxyB.GetVertex(vertex.indexB));
            vertex.w = b2Math.SubtractVV(vertex.wB, vertex.wA);
            
            // Iteration count is equated to the number of support point calls.
            ++iter;
            ++b2_gjkIters;
            
            // Check for duplicate support points. This is the main termination criteria.
            var duplicate : Bool = false;
            for (i in 0...saveCount)
            {
                if (vertex.indexA == saveA[i] && vertex.indexB == saveB[i])
                {
                    duplicate = true;
                    break;
                }
            }
            
            // If we found a duplicate support point we must exist to avoid cycling
            if (duplicate)
            {
                break;
            }
            
            // New vertex is ok and needed.
            ++simplex.m_count;
        }
        
        b2_gjkMaxIters = b2Math.Max(b2_gjkMaxIters, iter);
        
        // Prepare output
        simplex.GetWitnessPoints(output.pointA, output.pointB);
        output.distance = b2Math.SubtractVV(output.pointA, output.pointB).Length();
        output.iterations = iter;
        
        // Cache the simplex
        simplex.WriteCache(cache);
        
        // Apply radii if requested.
        if (input.useRadii)
        {
            var rA : Float = proxyA.m_radius;
            var rB : Float = proxyB.m_radius;
            
            if (output.distance > rA + rB && output.distance > as3hx.Compat.FLOAT_MIN)
            
            // Shapes are still not overlapped.{
                
                // Move the witness points to the outer surface.
                output.distance -= rA + rB;
                var normal : B2Vec2 = b2Math.SubtractVV(output.pointB, output.pointA);
                normal.Normalize();
                output.pointA.x += rA * normal.x;
                output.pointA.y += rA * normal.y;
                output.pointB.x -= rB * normal.x;
                output.pointB.y -= rB * normal.y;
            }
            // Shapes are overlapped when radii are considered.
            else
            {
                
                // Move the witness points to the middle.
                p = new B2Vec2();
                p.x = .5 * (output.pointA.x + output.pointB.x);
                p.y = .5 * (output.pointA.y + output.pointB.y);
                output.pointA.x = output.pointB.x = p.x;
                output.pointA.y = output.pointB.y = p.y;
                output.distance = 0.0;
            }
        }
    }

    public function new()
    {
    }
}


