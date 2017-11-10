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

package box2D.common.math;

import box2D.common.*;

/**
* A 2D column vector.
*/
class B2Vec2
{
    public function new(x_ : Float = 0, y_ : Float = 0)
    {
        x = x_;y = y_;
    }
    
    public function SetZero() : Void
    {
        x = 0.0;y = 0.0;
    }
    public function Set(x_ : Float = 0, y_ : Float = 0) : Void
    {
        x = x_;y = y_;
    }
    public function SetV(v : B2Vec2) : Void
    {
        x = v.x;y = v.y;
    }
    
    public function GetNegative() : B2Vec2
    {
        return new B2Vec2(-x, -y);
    }
    public function NegativeSelf() : Void
    {
        x = -x;y = -y;
    }
    
    public static function Make(x_ : Float, y_ : Float) : B2Vec2
    {
        return new B2Vec2(x_, y_);
    }
    
    public function Copy() : B2Vec2
    {
        return new B2Vec2(x, y);
    }
    
    public function Add(v : B2Vec2) : Void
    {
        x += v.x;y += v.y;
    }
    
    public function Subtract(v : B2Vec2) : Void
    {
        x -= v.x;y -= v.y;
    }
    
    public function Multiply(a : Float) : Void
    {
        x *= a;y *= a;
    }
    
    public function MulM(A : B2Mat22) : Void
    {
        var tX : Float = x;
        x = A.col1.x * tX + A.col2.x * y;
        y = A.col1.y * tX + A.col2.y * y;
    }
    
    public function MulTM(A : B2Mat22) : Void
    {
        var tX : Float = b2Math.Dot(this, A.col1);
        y = b2Math.Dot(this, A.col2);
        x = tX;
    }
    
    public function CrossVF(s : Float) : Void
    {
        var tX : Float = x;
        x = s * y;
        y = -s * tX;
    }
    
    public function CrossFV(s : Float) : Void
    {
        var tX : Float = x;
        x = -s * y;
        y = s * tX;
    }
    
    public function MinV(b : B2Vec2) : Void
    {
        x = (x < b.x) ? x : b.x;
        y = (y < b.y) ? y : b.y;
    }
    
    public function MaxV(b : B2Vec2) : Void
    {
        x = (x > b.x) ? x : b.x;
        y = (y > b.y) ? y : b.y;
    }
    
    public function Abs() : Void
    {
        if (x < 0)
        {
            x = -x;
        }
        if (y < 0)
        {
            y = -y;
        }
    }
    
    public function Length() : Float
    {
        return Math.sqrt(x * x + y * y);
    }
    
    public function LengthSquared() : Float
    {
        return (x * x + y * y);
    }
    
    public function Normalize() : Float
    {
        var length : Float = Math.sqrt(x * x + y * y);
        if (length < as3hx.Compat.FLOAT_MIN)
        {
            return 0.0;
        }
        var invLength : Float = 1.0 / length;
        x *= invLength;
        y *= invLength;
        
        return length;
    }
    
    public function IsValid() : Bool
    {
        return b2Math.IsValid(x) && b2Math.IsValid(y);
    }
    
    public var x : Float;
    public var y : Float;
}

