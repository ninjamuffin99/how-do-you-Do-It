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
class B2TimeOfImpact
{
    
    private static var b2_toiCalls : Int = 0;
    private static var b2_toiIters : Int = 0;
    private static var b2_toiMaxIters : Int = 0;
    private static var b2_toiRootIters : Int = 0;
    private static var b2_toiMaxRootIters : Int = 0;
    
    private static var s_cache : B2SimplexCache = new B2SimplexCache();
    private static var s_distanceInput : B2DistanceInput = new B2DistanceInput();
    private static var s_xfA : B2Transform = new B2Transform();
    private static var s_xfB : B2Transform = new B2Transform();
    private static var s_fcn : B2SeparationFunction = new B2SeparationFunction();
    private static var s_distanceOutput : B2DistanceOutput = new B2DistanceOutput();
    public static function TimeOfImpact(input : B2TOIInput) : Float
    {
        ++b2_toiCalls;
        
        var proxyA : B2DistanceProxy = input.proxyA;
        var proxyB : B2DistanceProxy = input.proxyB;
        
        var sweepA : B2Sweep = input.sweepA;
        var sweepB : B2Sweep = input.sweepB;
        
        b2Settings.b2Assert(sweepA.t0 == sweepB.t0);
        b2Settings.b2Assert(1.0 - sweepA.t0 > as3hx.Compat.FLOAT_MIN);
        
        var radius : Float = proxyA.m_radius + proxyB.m_radius;
        var tolerance : Float = input.tolerance;
        
        var alpha : Float = 0.0;
        
        var k_maxIterations : Int = 1000;  //TODO_ERIN b2Settings  
        var iter : Int = 0;
        var target : Float = 0.0;
        
        // Prepare input for distance query.
        s_cache.count = 0;
        s_distanceInput.useRadii = false;
        
        while (true)
        {
            sweepA.GetTransform(s_xfA, alpha);
            sweepB.GetTransform(s_xfB, alpha);
            
            // Get the distance between shapes
            s_distanceInput.proxyA = proxyA;
            s_distanceInput.proxyB = proxyB;
            s_distanceInput.transformA = s_xfA;
            s_distanceInput.transformB = s_xfB;
            
            b2Distance.Distance(s_distanceOutput, s_cache, s_distanceInput);
            
            if (s_distanceOutput.distance <= 0.0)
            {
                alpha = 1.0;
                break;
            }
            
            s_fcn.Initialize(s_cache, proxyA, s_xfA, proxyB, s_xfB);
            
            var separation : Float = s_fcn.Evaluate(s_xfA, s_xfB);
            if (separation <= 0.0)
            {
                alpha = 1.0;
                break;
            }
            
            if (iter == 0)
            
            // Compute a reasonable target distance to give some breathing room{
                
                // for conservative advancement. We take advantage of the shape radii
                // to create additional clearance
                if (separation > radius)
                {
                    target = b2Math.Max(radius - tolerance, 0.75 * radius);
                }
                else
                {
                    target = b2Math.Max(separation - tolerance, 0.02 * radius);
                }
            }
            
            if (separation - target < 0.5 * tolerance)
            {
                if (iter == 0)
                {
                    alpha = 1.0;
                    break;
                }
                break;
            }
            
            //#if 0
            // Dump the curve seen by the root finder
            //{
            //const N:int = 100;
            //var dx:Number = 1.0 / N;
            //var xs:Vector.<Number> = new Array(N + 1);
            //var fs:Vector.<Number> = new Array(N + 1);
            //
            //var x:Number = 0.0;
            //for (var i:int = 0; i <= N; i++)
            //{
            //sweepA.GetTransform(xfA, x);
            //sweepB.GetTransform(xfB, x);
            //var f:Number = fcn.Evaluate(xfA, xfB) - target;
            //
            //trace(x, f);
            //xs[i] = x;
            //fx[i] = f'
            //
            //x += dx;
            //}
            //}
            //#endif
            // Compute 1D root of f(x) - target = 0
            var newAlpha : Float = alpha;
            {
                var x1 : Float = alpha;
                var x2 : Float = 1.0;
                
                var f1 : Float = separation;
                
                sweepA.GetTransform(s_xfA, x2);
                sweepB.GetTransform(s_xfB, x2);
                
                var f2 : Float = s_fcn.Evaluate(s_xfA, s_xfB);
                
                // If intervals don't overlap at t2, then we are done
                if (f2 >= target)
                {
                    alpha = 1.0;
                    break;
                }
                
                // Determine when intervals intersect
                var rootIterCount : Int = 0;
                while (true)
                
                // Use a mis of the secand rule and bisection{
                    
                    var x : Float;
                    if ((rootIterCount & 1) != 0)
                    
                    // Secant rule to improve convergence{
                        
                        x = x1 + (target - f1) * (x2 - x1) / (f2 - f1);
                    }
                    // Bisection to guarantee progress
                    else
                    {
                        
                        x = 0.5 * (x1 + x2);
                    }
                    
                    sweepA.GetTransform(s_xfA, x);
                    sweepB.GetTransform(s_xfB, x);
                    
                    var f : Float = s_fcn.Evaluate(s_xfA, s_xfB);
                    
                    if (b2Math.Abs(f - target) < 0.025 * tolerance)
                    {
                        newAlpha = x;
                        break;
                    }
                    
                    // Ensure we continue to bracket the root
                    if (f > target)
                    {
                        x1 = x;
                        f1 = f;
                    }
                    else
                    {
                        x2 = x;
                        f2 = f;
                    }
                    
                    ++rootIterCount;
                    ++b2_toiRootIters;
                    if (rootIterCount == 50)
                    {
                        break;
                    }
                }
                
                b2_toiMaxRootIters = b2Math.Max(b2_toiMaxRootIters, rootIterCount);
            }
            
            // Ensure significant advancement
            if (newAlpha < (1.0 + 100.0 * as3hx.Compat.FLOAT_MIN) * alpha)
            {
                break;
            }
            
            alpha = newAlpha;
            
            iter++;
            ++b2_toiIters;
            
            if (iter == k_maxIterations)
            {
                break;
            }
        }
        
        b2_toiMaxIters = b2Math.Max(b2_toiMaxIters, iter);
        
        return alpha;
    }

    public function new()
    {
    }
}


