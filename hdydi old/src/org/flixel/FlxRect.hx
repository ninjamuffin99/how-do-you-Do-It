package org.flixel;

import flash.geom.Rectangle;

/**
	 * Stores a rectangle.
	 * 
	 * @author	Adam Atomic
	 */
class FlxRect
{
    public var left(get, never) : Float;
    public var right(get, never) : Float;
    public var top(get, never) : Float;
    public var bottom(get, never) : Float;

    /**
		 * @default 0
		 */
    public var x : Float;
    /**
		 * @default 0
		 */
    public var y : Float;
    /**
		 * @default 0
		 */
    public var width : Float;
    /**
		 * @default 0
		 */
    public var height : Float;
    
    /**
		 * Instantiate a new rectangle.
		 * 
		 * @param	X		The X-coordinate of the point in space.
		 * @param	Y		The Y-coordinate of the point in space.
		 * @param	Width	Desired width of the rectangle.
		 * @param	Height	Desired height of the rectangle.
		 */
    public function new(X : Float = 0, Y : Float = 0, Width : Float = 0, Height : Float = 0)
    {
        x = X;
        y = Y;
        width = Width;
        height = Height;
    }
    
    /**
		 * The X coordinate of the left side of the rectangle.  Read-only.
		 */
    private function get_left() : Float
    {
        return x;
    }
    
    /**
		 * The X coordinate of the right side of the rectangle.  Read-only.
		 */
    private function get_right() : Float
    {
        return x + width;
    }
    
    /**
		 * The Y coordinate of the top of the rectangle.  Read-only.
		 */
    private function get_top() : Float
    {
        return y;
    }
    
    /**
		 * The Y coordinate of the bottom of the rectangle.  Read-only.
		 */
    private function get_bottom() : Float
    {
        return y + height;
    }
    
    /**
		 * Instantiate a new rectangle.
		 * 
		 * @param	X		The X-coordinate of the point in space.
		 * @param	Y		The Y-coordinate of the point in space.
		 * @param	Width	Desired width of the rectangle.
		 * @param	Height	Desired height of the rectangle.
		 * 
		 * @return	A reference to itself.
		 */
    public function make(X : Float = 0, Y : Float = 0, Width : Float = 0, Height : Float = 0) : FlxRect
    {
        x = X;
        y = Y;
        width = Width;
        height = Height;
        return this;
    }
    
    /**
		 * Helper function, just copies the values from the specified rectangle.
		 * 
		 * @param	Rect	Any <code>FlxRect</code>.
		 * 
		 * @return	A reference to itself.
		 */
    public function copyFrom(Rect : FlxRect) : FlxRect
    {
        x = Rect.x;
        y = Rect.y;
        width = Rect.width;
        height = Rect.height;
        return this;
    }
    
    /**
		 * Helper function, just copies the values from this rectangle to the specified rectangle.
		 * 
		 * @param	Point	Any <code>FlxRect</code>.
		 * 
		 * @return	A reference to the altered rectangle parameter.
		 */
    public function copyTo(Rect : FlxRect) : FlxRect
    {
        Rect.x = x;
        Rect.y = y;
        Rect.width = width;
        Rect.height = height;
        return Rect;
    }
    
    /**
		 * Helper function, just copies the values from the specified Flash rectangle.
		 * 
		 * @param	FlashRect	Any <code>Rectangle</code>.
		 * 
		 * @return	A reference to itself.
		 */
    public function copyFromFlash(FlashRect : Rectangle) : FlxRect
    {
        x = FlashRect.x;
        y = FlashRect.y;
        width = FlashRect.width;
        height = FlashRect.height;
        return this;
    }
    
    /**
		 * Helper function, just copies the values from this rectangle to the specified Flash rectangle.
		 * 
		 * @param	Point	Any <code>Rectangle</code>.
		 * 
		 * @return	A reference to the altered rectangle parameter.
		 */
    public function copyToFlash(FlashRect : Rectangle) : Rectangle
    {
        FlashRect.x = x;
        FlashRect.y = y;
        FlashRect.width = width;
        FlashRect.height = height;
        return FlashRect;
    }
    
    /**
		 * Checks to see if some <code>FlxRect</code> object overlaps this <code>FlxRect</code> object.
		 * 
		 * @param	Rect	The rectangle being tested.
		 * 
		 * @return	Whether or not the two rectangles overlap.
		 */
    public function overlaps(Rect : FlxRect) : Bool
    {
        return (Rect.x + Rect.width > x) && (Rect.x < x + width) && (Rect.y + Rect.height > y) && (Rect.y < y + height);
    }
}

