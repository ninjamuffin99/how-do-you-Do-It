package org.flixel.plugin;

import org.flixel.*;

/**
	 * A simple manager for tracking and drawing FlxPath debug data to the screen.
	 * 
	 * @author	Adam Atomic
	 */
class DebugPathDisplay extends FlxBasic
{
    private var _paths : Array<Dynamic>;
    
    /**
		 * Instantiates a new debug path display manager.
		 */
    public function new()
    {
        super();
        _paths = new Array<Dynamic>();
        active = false;
    }
    
    /**
		 * Clean up memory.
		 */
    override public function destroy() : Void
    {
        super.destroy();
        clear();
        _paths = null;
    }
    
    /**
		 * Called by <code>FlxG.drawPlugins()</code> after the game state has been drawn.
		 * Cycles through cameras and calls <code>drawDebug()</code> on each one.
		 */
    override public function draw() : Void
    {
        if (!FlxG.visualDebug || ignoreDrawDebug)
        {
            return;
        }
        
        if (cameras == null)
        {
            cameras = FlxG.cameras;
        }
        var i : Int = 0;
        var l : Int = cameras.length;
        while (i < l)
        {
            drawDebug(cameras[i++]);
        }
    }
    
    /**
		 * Similar to <code>FlxObject</code>'s <code>drawDebug()</code> functionality,
		 * this function calls <code>drawDebug()</code> on each <code>FlxPath</code> for the specified camera.
		 * Very helpful for debugging!
		 * 
		 * @param	Camera	Which <code>FlxCamera</code> object to draw the debug data to.
		 */
    override public function drawDebug(Camera : FlxCamera = null) : Void
    {
        if (Camera == null)
        {
            Camera = FlxG.camera;
        }
        
        var i : Int = as3hx.Compat.parseInt(_paths.length - 1);
        var path : FlxPath;
        while (i >= 0)
        {
            path = try cast(_paths[i--], FlxPath) catch(e:Dynamic) null;
            if ((path != null) && !path.ignoreDrawDebug)
            {
                path.drawDebug(Camera);
            }
        }
    }
    
    /**
		 * Add a path to the path debug display manager.
		 * Usually called automatically by <code>FlxPath</code>'s constructor.
		 * 
		 * @param	Path	The <code>FlxPath</code> you want to add to the manager.
		 */
    public function add(Path : FlxPath) : Void
    {
        _paths.push(Path);
    }
    
    /**
		 * Remove a path from the path debug display manager.
		 * Usually called automatically by <code>FlxPath</code>'s <code>destroy()</code> function.
		 * 
		 * @param	Path	The <code>FlxPath</code> you want to remove from the manager.
		 */
    public function remove(Path : FlxPath) : Void
    {
        var index : Int = Lambda.indexOf(_paths, Path);
        if (index >= 0)
        {
            _paths.splice(index, 1);
        }
    }
    
    /**
		 * Removes all the paths from the path debug display manager.
		 */
    public function clear() : Void
    {
        var i : Int = as3hx.Compat.parseInt(_paths.length - 1);
        var path : FlxPath;
        while (i >= 0)
        {
            path = try cast(_paths[i--], FlxPath) catch(e:Dynamic) null;
            if (path != null)
            {
                path.destroy();
            }
        }
        as3hx.Compat.setArrayLength(_paths, 0);
    }
}
