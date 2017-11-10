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

package box2D.common;

import box2D.common.*;
import box2D.common.math.*;

/**
* Color for debug drawing. Each value has the range [0,1].
*/
class B2Color
{
    public var r(never, set) : Float;
    public var g(never, set) : Float;
    public var b(never, set) : Float;
    public var color(get, never) : Int;

    
    public function new(rr : Float, gg : Float, bb : Float)
    {
        _r = as3hx.Compat.parseInt(255 * b2Math.Clamp(rr, 0.0, 1.0));
        _g = as3hx.Compat.parseInt(255 * b2Math.Clamp(gg, 0.0, 1.0));
        _b = as3hx.Compat.parseInt(255 * b2Math.Clamp(bb, 0.0, 1.0));
    }
    
    public function Set(rr : Float, gg : Float, bb : Float) : Void
    {
        _r = as3hx.Compat.parseInt(255 * b2Math.Clamp(rr, 0.0, 1.0));
        _g = as3hx.Compat.parseInt(255 * b2Math.Clamp(gg, 0.0, 1.0));
        _b = as3hx.Compat.parseInt(255 * b2Math.Clamp(bb, 0.0, 1.0));
    }
    
    // R
    private function set_r(rr : Float) : Float
    {
        _r = as3hx.Compat.parseInt(255 * b2Math.Clamp(rr, 0.0, 1.0));
        return rr;
    }
    // G
    private function set_g(gg : Float) : Float
    {
        _g = as3hx.Compat.parseInt(255 * b2Math.Clamp(gg, 0.0, 1.0));
        return gg;
    }
    // B
    private function set_b(bb : Float) : Float
    {
        _b = as3hx.Compat.parseInt(255 * b2Math.Clamp(bb, 0.0, 1.0));
        return bb;
    }
    
    // Color
    private function get_color() : Int
    {
        return as3hx.Compat.parseInt((_r << 16) | (_g << 8) | (_b));
    }
    
    private var _r : Int = 0;
    private var _g : Int = 0;
    private var _b : Int = 0;
}

