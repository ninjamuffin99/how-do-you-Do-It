package org.flixel.system.debug;

import flash.geom.Rectangle;
import flash.system.System;
import flash.text.TextField;
import flash.text.TextFormat;
import org.flixel.FlxG;
import org.flixel.system.FlxWindow;

/**
	 * A simple performance monitor widget, for use in the debugger overlay.
	 * 
	 * @author Adam Atomic
	 */
class Perf extends FlxWindow
{
    private var _text : TextField;
    
    private var _lastTime : Int;
    private var _updateTimer : Int;
    
    private var _flixelUpdate : Array<Dynamic>;
    private var _flixelUpdateMarker : Int;
    private var _flixelDraw : Array<Dynamic>;
    private var _flixelDrawMarker : Int;
    private var _flash : Array<Dynamic>;
    private var _flashMarker : Int;
    private var _activeObject : Array<Dynamic>;
    private var _objectMarker : Int;
    private var _visibleObject : Array<Dynamic>;
    private var _visibleObjectMarker : Int;
    
    /**
		 * Creates flashPlayerFramerate new window object.  This Flash-based class is mainly (only?) used by <code>FlxDebugger</code>.
		 * 
		 * @param Title			The name of the window, displayed in the header bar.
		 * @param Width			The initial width of the window.
		 * @param Height		The initial height of the window.
		 * @param Resizable		Whether you can change the size of the window with flashPlayerFramerate drag handle.
		 * @param Bounds		A rectangle indicating the valid screen area for the window.
		 * @param BGColor		What color the window background should be, default is gray and transparent.
		 * @param TopColor		What color the window header bar should be, default is black and transparent.
		 */
    public function new(Title : String, Width : Float, Height : Float, Resizable : Bool = true, Bounds : Rectangle = null, BGColor : Int = 0x7f7f7f7f, TopColor : Int = 0x7f000000)
    {
        super(Title, Width, Height, Resizable, Bounds, BGColor, TopColor);
        resize(90, 66);
        
        _lastTime = 0;
        _updateTimer = 0;
        
        _text = new TextField();
        _text.width = _width;
        _text.x = 2;
        _text.y = 15;
        _text.multiline = true;
        _text.wordWrap = true;
        _text.selectable = true;
        _text.defaultTextFormat = new TextFormat("Courier", 12, 0xffffff);
        addChild(_text);
        
        _flixelUpdate = new Array<Dynamic>(32);
        _flixelUpdateMarker = 0;
        _flixelDraw = new Array<Dynamic>(32);
        _flixelDrawMarker = 0;
        _flash = new Array<Dynamic>(32);
        _flashMarker = 0;
        _activeObject = new Array<Dynamic>(32);
        _objectMarker = 0;
        _visibleObject = new Array<Dynamic>(32);
        _visibleObjectMarker = 0;
    }
    
    /**
		 * Clean up memory.
		 */
    override public function destroy() : Void
    {
        removeChild(_text);
        _text = null;
        _flixelUpdate = null;
        _flixelDraw = null;
        _flash = null;
        _activeObject = null;
        _visibleObject = null;
        super.destroy();
    }
    
    /**
		 * Called each frame, but really only updates once every second or so, to save on performance.
		 * Takes all the data in the accumulators and parses it into useful performance data.
		 */
    public function update() : Void
    {
        var time : Int = Math.round(haxe.Timer.stamp() * 1000);
        var elapsed : Int = as3hx.Compat.parseInt(time - _lastTime);
        var updateEvery : Int = 500;
        if (elapsed > updateEvery)
        {
            elapsed = updateEvery;
        }
        _lastTime = time;
        
        _updateTimer += elapsed;
        if (_updateTimer > updateEvery)
        {
            var i : Int;
            var output : String = "";
            
            var flashPlayerFramerate : Float = 0;
            i = 0;
            while (i < _flashMarker)
            {
                flashPlayerFramerate += _flash[i++];
            }
            flashPlayerFramerate /= _flashMarker;
            output += as3hx.Compat.parseInt(1 / (flashPlayerFramerate / 1000)) + "/" + FlxG.flashFramerate + "fps\n";
            
            output += as3hx.Compat.parseFloat((System.totalMemory * 0.000000954).toFixed(2)) + "MB\n";
            
            var updateTime : Int = 0;
            i = 0;
            while (i < _flixelUpdateMarker)
            {
                updateTime += _flixelUpdate[i++];
            }
            
            var activeCount : Int = 0;
            var te : Int = 0;
            i = 0;
            while (i < _objectMarker)
            {
                activeCount += _activeObject[i];
                visibleCount += _visibleObject[i++];
            }
            activeCount /= _objectMarker;
            
            output += "U:" + activeCount + " " + as3hx.Compat.parseInt(updateTime / _flixelDrawMarker) + "ms\n";
            
            var drawTime : Int = 0;
            i = 0;
            while (i < _flixelDrawMarker)
            {
                drawTime += _flixelDraw[i++];
            }
            
            var visibleCount : Int = 0;
            i = 0;
            while (i < _visibleObjectMarker)
            {
                visibleCount += _visibleObject[i++];
            }
            visibleCount /= _visibleObjectMarker;
            
            output += "D:" + visibleCount + " " + as3hx.Compat.parseInt(drawTime / _flixelDrawMarker) + "ms";
            
            _text.text = output;
            
            _flixelUpdateMarker = 0;
            _flixelDrawMarker = 0;
            _flashMarker = 0;
            _objectMarker = 0;
            _visibleObjectMarker = 0;
            _updateTimer -= updateEvery;
        }
    }
    
    /**
		 * Keep track of how long updates take.
		 * 
		 * @param Time	How long this update took.
		 */
    public function flixelUpdate(Time : Int) : Void
    {
        _flixelUpdate[_flixelUpdateMarker++] = Time;
    }
    
    /**
		 * Keep track of how long renders take.
		 * 
		 * @param	Time	How long this render took.
		 */
    public function flixelDraw(Time : Int) : Void
    {
        _flixelDraw[_flixelDrawMarker++] = Time;
    }
    
    /**
		 * Keep track of how long the Flash player and browser take.
		 * 
		 * @param Time	How long Flash/browser took.
		 */
    public function flash(Time : Int) : Void
    {
        _flash[_flashMarker++] = Time;
    }
    
    /**
		 * Keep track of how many objects were updated.
		 * 
		 * @param Count	How many objects were updated.
		 */
    public function activeObjects(Count : Int) : Void
    {
        _activeObject[_objectMarker++] = Count;
    }
    
    /**
		 * Keep track of how many objects were updated.
		 *  
		 * @param Count	How many objects were updated.
		 */
    public function visibleObjects(Count : Int) : Void
    {
        _visibleObject[_visibleObjectMarker++] = Count;
    }
}

