package org.flixel;

import flash.errors.Error;
import haxe.Constraints.Function;
import flash.display.BitmapData;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.display.Stage;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import org.flixel.plugin.DebugPathDisplay;
import org.flixel.plugin.TimerManager;
import org.flixel.system.FlxDebugger;
import org.flixel.system.FlxQuadTree;
import org.flixel.system.input.*;

/**
	 * This is a global helper class full of useful functions for audio,
	 * input, basic info, and the camera system among other things.
	 * Utilities for maths and color and things can be found in <code>FlxU</code>.
	 * <code>FlxG</code> is specifically for Flixel-specific properties.
	 * 
	 * @author	Adam Atomic
	 */
class FlxG
{
    public static var framerate(get, set) : Float;
    public static var flashFramerate(get, set) : Float;
    public static var volume(get, set) : Float;
    public static var stage(get, never) : Stage;
    public static var state(get, never) : FlxState;
    public static var bgColor(get, set) : Int;

    /**
		 * If you build and maintain your own version of flixel,
		 * you can give it your own name here.
		 */
    public static var LIBRARY_NAME : String = "flixel";
    /**
		 * Assign a major version to your library.
		 * Appears before the decimal in the console.
		 */
    public static var LIBRARY_MAJOR_VERSION : Int = 2;
    /**
		 * Assign a minor version to your library.
		 * Appears after the decimal in the console.
		 */
    public static var LIBRARY_MINOR_VERSION : Int = 55;
    
    /**
		 * Debugger overlay layout preset: Wide but low windows at the bottom of the screen.
		 */
    public static inline var DEBUGGER_STANDARD : Int = 0;
    /**
		 * Debugger overlay layout preset: Tiny windows in the screen corners.
		 */
    public static inline var DEBUGGER_MICRO : Int = 1;
    /**
		 * Debugger overlay layout preset: Large windows taking up bottom half of screen.
		 */
    public static inline var DEBUGGER_BIG : Int = 2;
    /**
		 * Debugger overlay layout preset: Wide but low windows at the top of the screen.
		 */
    public static inline var DEBUGGER_TOP : Int = 3;
    /**
		 * Debugger overlay layout preset: Large windows taking up left third of screen.
		 */
    public static inline var DEBUGGER_LEFT : Int = 4;
    /**
		 * Debugger overlay layout preset: Large windows taking up right third of screen.
		 */
    public static inline var DEBUGGER_RIGHT : Int = 5;
    
    /**
		 * Some handy color presets.  Less glaring than pure RGB full values.
		 * Primarily used in the visual debugger mode for bounding box displays.
		 * Red is used to indicate an active, movable, solid object.
		 */
    public static inline var RED : Int = 0xffff0012;
    /**
		 * Green is used to indicate solid but immovable objects.
		 */
    public static inline var GREEN : Int = 0xff00f225;
    /**
		 * Blue is used to indicate non-solid objects.
		 */
    public static inline var BLUE : Int = 0xff0090e9;
    /**
		 * Pink is used to indicate objects that are only partially solid, like one-way platforms.
		 */
    public static inline var PINK : Int = 0xfff01eff;
    /**
		 * White... for white stuff.
		 */
    public static inline var WHITE : Int = 0xffffffff;
    /**
		 * And black too.
		 */
    public static inline var BLACK : Int = 0xff000000;
    
    /**
		 * Internal tracker for game object.
		 */
    @:allow(org.flixel)
    private static var _game : FlxGame;
    /**
		 * Handy shared variable for implementing your own pause behavior.
		 */
    public static var paused : Bool;
    /**
		 * Whether you are running in Debug or Release mode.
		 * Set automatically by <code>FlxPreloader</code> during startup.
		 */
    public static var debug : Bool;
    
    /**
		 * Represents the amount of time in seconds that passed since last frame.
		 */
    public static var elapsed : Float;
    /**
		 * How fast or slow time should pass in the game; default is 1.0.
		 */
    public static var timeScale : Float;
    /**
		 * The width of the screen in game pixels.
		 */
    public static var width : Int;
    /**
		 * The height of the screen in game pixels.
		 */
    public static var height : Int;
    /**
		 * The dimensions of the game world, used by the quad tree for collisions and overlap checks.
		 */
    public static var worldBounds : FlxRect;
    /**
		 * How many times the quad tree should divide the world on each axis.
		 * Generally, sparse collisions can have fewer divisons,
		 * while denser collision activity usually profits from more.
		 * Default value is 6.
		 */
    public static var worldDivisions : Int;
    /**
		 * Whether to show visual debug displays or not.
		 * Default = false.
		 */
    public static var visualDebug : Bool;
    /**
		 * Setting this to true will disable/skip stuff that isn't necessary for mobile platforms like Android. [BETA]
		 */
    public static var mobile : Bool;
    /**
		 * The global random number generator seed (for deterministic behavior in recordings and saves).
		 */
    public static var globalSeed : Float;
    /**
		 * <code>FlxG.levels</code> and <code>FlxG.scores</code> are generic
		 * global variables that can be used for various cross-state stuff.
		 */
    public static var levels : Array<Dynamic>;
    public static var level : Int;
    public static var scores : Array<Dynamic>;
    public static var score : Int;
    /**
		 * <code>FlxG.saves</code> is a generic bucket for storing
		 * FlxSaves so you can access them whenever you want.
		 */
    public static var saves : Array<Dynamic>;
    public static var save : Int;
    
    /**
		 * A reference to a <code>FlxMouse</code> object.  Important for input!
		 */
    public static var mouse : Mouse;
    /**
		 * A reference to a <code>FlxKeyboard</code> object.  Important for input!
		 */
    public static var keys : Keyboard;
    
    /**
		 * A handy container for a background music object.
		 */
    public static var music : FlxSound;
    /**
		 * A list of all the sounds being played in the game.
		 */
    public static var sounds : FlxGroup;
    /**
		 * Whether or not the game sounds are muted.
		 */
    public static var mute : Bool;
    /**
		 * Internal volume level, used for global sound control.
		 */
    private static var _volume : Float;
    
    /**
		 * An array of <code>FlxCamera</code> objects that are used to draw stuff.
		 * By default flixel creates one camera the size of the screen.
		 */
    public static var cameras : Array<Dynamic>;
    /**
		 * By default this just refers to the first entry in the cameras array
		 * declared above, but you can do what you like with it.
		 */
    public static var camera : FlxCamera;
    /**
		 * Allows you to possibly slightly optimize the rendering process IF
		 * you are not doing any pre-processing in your game state's <code>draw()</code> call.
		 * @default false
		 */
    public static var useBufferLocking : Bool;
    /**
		 * Internal helper variable for clearing the cameras each frame.
		 */
    private static var _cameraRect : Rectangle;
    
    /**
		 * An array container for plugins.
		 * By default flixel uses a couple of plugins:
		 * DebugPathDisplay, and TimerManager.
		 */
    public static var plugins : Array<Dynamic>;
    
    /**
		 * Set this hook to get a callback whenever the volume changes.
		 * Function should take the form <code>myVolumeHandler(Volume:Number)</code>.
		 */
    public static var volumeHandler : Function;
    
    /**
		 * Useful helper objects for doing Flash-specific rendering.
		 * Primarily used for "debug visuals" like drawing bounding boxes directly to the screen buffer.
		 */
    public static var flashGfxSprite : Sprite;
    public static var flashGfx : Graphics;
    
    /**
		 * Internal storage system to prevent graphics from being used repeatedly in memory.
		 */
    private static var _cache : Dynamic;
    
    public static function getLibraryName() : String
    {
        return FlxG.LIBRARY_NAME + " v" + FlxG.LIBRARY_MAJOR_VERSION + "." + FlxG.LIBRARY_MINOR_VERSION;
    }
    
    /**
		 * Log data to the debugger.
		 * 
		 * @param	Data		Anything you want to log to the console.
		 */
    public static function log(Data : Dynamic) : Void
    {
        if ((_game != null) && (_game._debugger != null))
        {
            _game._debugger.log.add(((Data == null)) ? "ERROR: null object" : Std.string(Data));
        }
    }
    
    /**
		 * Add a variable to the watch list in the debugger.
		 * This lets you see the value of the variable all the time.
		 * 
		 * @param	AnyObject		A reference to any object in your game, e.g. Player or Robot or this.
		 * @param	VariableName	The name of the variable you want to watch, in quotes, as a string: e.g. "speed" or "health".
		 * @param	DisplayName		Optional, display your own string instead of the class name + variable name: e.g. "enemy count".
		 */
    public static function watch(AnyObject : Dynamic, VariableName : String, DisplayName : String = null) : Void
    {
        if ((_game != null) && (_game._debugger != null))
        {
            _game._debugger.watch.add(AnyObject, VariableName, DisplayName);
        }
    }
    
    /**
		 * Remove a variable from the watch list in the debugger.
		 * Don't pass a Variable Name to remove all watched variables for the specified object.
		 * 
		 * @param	AnyObject		A reference to any object in your game, e.g. Player or Robot or this.
		 * @param	VariableName	The name of the variable you want to watch, in quotes, as a string: e.g. "speed" or "health".
		 */
    public static function unwatch(AnyObject : Dynamic, VariableName : String = null) : Void
    {
        if ((_game != null) && (_game._debugger != null))
        {
            _game._debugger.watch.remove(AnyObject, VariableName);
        }
    }
    
    /**
		 * How many times you want your game to update each second.
		 * More updates usually means better collisions and smoother motion.
		 * NOTE: This is NOT the same thing as the Flash Player framerate!
		 */
    private static function get_framerate() : Float
    {
        return 1000 / _game._step;
    }
    
    /**
		 * @private
		 */
    private static function set_framerate(Framerate : Float) : Float
    {
        _game._step = 1000 / Framerate;
        if (_game._maxAccumulation < _game._step)
        {
            _game._maxAccumulation = _game._step;
        }
        return Framerate;
    }
    
    /**
		 * How many times you want your game to update each second.
		 * More updates usually means better collisions and smoother motion.
		 * NOTE: This is NOT the same thing as the Flash Player framerate!
		 */
    private static function get_flashFramerate() : Float
    {
        if (_game.root != null)
        {
            return _game.stage.frameRate;
        }
        else
        {
            return 0;
        }
    }
    
    /**
		 * @private
		 */
    private static function set_flashFramerate(Framerate : Float) : Float
    {
        _game._flashFramerate = Framerate;
        if (_game.root != null)
        {
            _game.stage.frameRate = _game._flashFramerate;
        }
        _game._maxAccumulation = 2000 / _game._flashFramerate - 1;
        if (_game._maxAccumulation < _game._step)
        {
            _game._maxAccumulation = _game._step;
        }
        return Framerate;
    }
    
    /**
		 * Generates a random number.  Deterministic, meaning safe
		 * to use if you want to record replays in random environments.
		 * 
		 * @return	A <code>Number</code> between 0 and 1.
		 */
    public static function random() : Float
    {
        return globalSeed = FlxU.srand(globalSeed);
    }
    
    /**
		 * Shuffles the entries in an array into a new random order.
		 * <code>FlxG.shuffle()</code> is deterministic and safe for use with replays/recordings.
		 * HOWEVER, <code>FlxU.shuffle()</code> is NOT deterministic and unsafe for use with replays/recordings.
		 * 
		 * @param	A				A Flash <code>Array</code> object containing...stuff.
		 * @param	HowManyTimes	How many swaps to perform during the shuffle operation.  Good rule of thumb is 2-4 times as many objects are in the list.
		 * 
		 * @return	The same Flash <code>Array</code> object that you passed in in the first place.
		 */
    public static function shuffle(Objects : Array<Dynamic>, HowManyTimes : Int) : Array<Dynamic>
    {
        var i : Int = 0;
        var index1 : Int;
        var index2 : Int;
        var object : Dynamic;
        while (i < HowManyTimes)
        {
            index1 = as3hx.Compat.parseInt(FlxG.random() * Objects.length);
            index2 = as3hx.Compat.parseInt(FlxG.random() * Objects.length);
            object = Objects[index2];
            Objects[index2] = Objects[index1];
            Objects[index1] = object;
            i++;
        }
        return Objects;
    }
    
    /**
		 * Fetch a random entry from the given array.
		 * Will return null if random selection is missing, or array has no entries.
		 * <code>FlxG.getRandom()</code> is deterministic and safe for use with replays/recordings.
		 * HOWEVER, <code>FlxU.getRandom()</code> is NOT deterministic and unsafe for use with replays/recordings.
		 * 
		 * @param	Objects		A Flash array of objects.
		 * @param	StartIndex	Optional offset off the front of the array. Default value is 0, or the beginning of the array.
		 * @param	Length		Optional restriction on the number of values you want to randomly select from.
		 * 
		 * @return	The random object that was selected.
		 */
    public static function getRandom(Objects : Array<Dynamic>, StartIndex : Int = 0, Length : Int = 0) : Dynamic
    {
        if (Objects != null)
        {
            var l : Int = Length;
            if ((l == 0) || (l > Objects.length - StartIndex))
            {
                l = as3hx.Compat.parseInt(Objects.length - StartIndex);
            }
            if (l > 0)
            {
                return Objects[StartIndex + as3hx.Compat.parseInt(FlxG.random() * l)];
            }
        }
        return null;
    }
    
    /**
		 * Load replay data from a string and play it back.
		 * 
		 * @param	Data		The replay that you want to load.
		 * @param	State		Optional parameter: if you recorded a state-specific demo or cutscene, pass a new instance of that state here.
		 * @param	CancelKeys	Optional parameter: an array of string names of keys (see FlxKeyboard) that can be pressed to cancel the playback, e.g. ["ESCAPE","ENTER"].  Also accepts 2 custom key names: "ANY" and "MOUSE" (fairly self-explanatory I hope!).
		 * @param	Timeout		Optional parameter: set a time limit for the replay.  CancelKeys will override this if pressed.
		 * @param	Callback	Optional parameter: if set, called when the replay finishes.  Running to the end, CancelKeys, and Timeout will all trigger Callback(), but only once, and CancelKeys and Timeout will NOT call FlxG.stopReplay() if Callback is set!
		 */
    public static function loadReplay(Data : String, State : FlxState = null, CancelKeys : Array<Dynamic> = null, Timeout : Float = 0, Callback : Function = null) : Void
    {
        _game._replay.load(Data);
        if (State == null)
        {
            FlxG.resetGame();
        }
        else
        {
            FlxG.switchState(State);
        }
        _game._replayCancelKeys = CancelKeys;
        _game._replayTimer = Timeout * 1000;
        _game._replayCallback = Callback;
        _game._replayRequested = true;
    }
    
    /**
		 * Resets the game or state and replay requested flag.
		 * 
		 * @param	StandardMode	If true, reload entire game, else just reload current game state.
		 */
    public static function reloadReplay(StandardMode : Bool = true) : Void
    {
        if (StandardMode)
        {
            FlxG.resetGame();
        }
        else
        {
            FlxG.resetState();
        }
        if (_game._replay.frameCount > 0)
        {
            _game._replayRequested = true;
        }
    }
    
    /**
		 * Stops the current replay.
		 */
    public static function stopReplay() : Void
    {
        _game._replaying = false;
        if (_game._debugger != null)
        {
            _game._debugger.vcr.stopped();
        }
        resetInput();
    }
    
    /**
		 * Resets the game or state and requests a new recording.
		 * 
		 * @param	StandardMode	If true, reset the entire game, else just reset the current state.
		 */
    public static function recordReplay(StandardMode : Bool = true) : Void
    {
        if (StandardMode)
        {
            FlxG.resetGame();
        }
        else
        {
            FlxG.resetState();
        }
        _game._recordingRequested = true;
    }
    
    /**
		 * Stop recording the current replay and return the replay data.
		 * 
		 * @return	The replay data in simple ASCII format (see <code>FlxReplay.save()</code>).
		 */
    public static function stopRecording() : String
    {
        _game._recording = false;
        if (_game._debugger != null)
        {
            _game._debugger.vcr.stopped();
        }
        return _game._replay.save();
    }
    
    /**
		 * Request a reset of the current game state.
		 */
    public static function resetState() : Void
    {
        _game._requestedState = new FlxU.getClass(FlxU.getClassName(_game._state, false))()();
    }
    
    /**
		 * Like hitting the reset button on a game console, this will re-launch the game as if it just started.
		 */
    public static function resetGame() : Void
    {
        _game._requestedReset = true;
    }
    
    /**
		 * Reset the input helper objects (useful when changing screens or states)
		 */
    public static function resetInput() : Void
    {
        keys.reset();
        mouse.reset();
    }
    
    /**
		 * Set up and play a looping background soundtrack.
		 * 
		 * @param	Music		The sound file you want to loop in the background.
		 * @param	Volume		How loud the sound should be, from 0 to 1.
		 */
    public static function playMusic(Music : Class<Dynamic>, Volume : Float = 1.0) : Void
    {
        if (music == null)
        {
            music = new FlxSound();
        }
        else if (music.active)
        {
            music.stop();
        }
        music.loadEmbedded(Music, true);
        music.volume = Volume;
        music.survive = true;
        music.play();
    }
    
    /**
		 * Creates a new sound object.
		 * 
		 * @param	EmbeddedSound	The embedded sound resource you want to play.  To stream, use the optional URL parameter instead.
		 * @param	Volume			How loud to play it (0 to 1).
		 * @param	Looped			Whether to loop this sound.
		 * @param	AutoDestroy		Whether to destroy this sound when it finishes playing.  Leave this value set to "false" if you want to re-use this <code>FlxSound</code> instance.
		 * @param	AutoPlay		Whether to play the sound.
		 * @param	URL				Load a sound from an external web resource instead.  Only used if EmbeddedSound = null.
		 * 
		 * @return	A <code>FlxSound</code> object.
		 */
    public static function loadSound(EmbeddedSound : Class<Dynamic> = null, Volume : Float = 1.0, Looped : Bool = false, AutoDestroy : Bool = false, AutoPlay : Bool = false, URL : String = null) : FlxSound
    {
        if ((EmbeddedSound == null) && (URL == null))
        {
            FlxG.log("WARNING: FlxG.loadSound() requires either\nan embedded sound or a URL to work.");
            return null;
        }
        var sound : FlxSound = try cast(sounds.recycle(FlxSound), FlxSound) catch(e:Dynamic) null;
        if (EmbeddedSound != null)
        {
            sound.loadEmbedded(EmbeddedSound, Looped, AutoDestroy);
        }
        else
        {
            sound.loadStream(URL, Looped, AutoDestroy);
        }
        sound.volume = Volume;
        if (AutoPlay)
        {
            sound.play();
        }
        return sound;
    }
    
    /**
		 * Creates a new sound object from an embedded <code>Class</code> object.
		 * NOTE: Just calls FlxG.loadSound() with AutoPlay == true.
		 * 
		 * @param	EmbeddedSound	The sound you want to play.
		 * @param	Volume			How loud to play it (0 to 1).
		 * @param	Looped			Whether to loop this sound.
		 * @param	AutoDestroy		Whether to destroy this sound when it finishes playing.  Leave this value set to "false" if you want to re-use this <code>FlxSound</code> instance.
		 * 
		 * @return	A <code>FlxSound</code> object.
		 */
    public static function play(EmbeddedSound : Class<Dynamic>, Volume : Float = 1.0, Looped : Bool = false, AutoDestroy : Bool = true) : FlxSound
    {
        return FlxG.loadSound(EmbeddedSound, Volume, Looped, AutoDestroy, true);
    }
    
    /**
		 * Creates a new sound object from a URL.
		 * NOTE: Just calls FlxG.loadSound() with AutoPlay == true.
		 * 
		 * @param	URL		The URL of the sound you want to play.
		 * @param	Volume	How loud to play it (0 to 1).
		 * @param	Looped	Whether or not to loop this sound.
		 * @param	AutoDestroy		Whether to destroy this sound when it finishes playing.  Leave this value set to "false" if you want to re-use this <code>FlxSound</code> instance.
		 * 
		 * @return	A FlxSound object.
		 */
    public static function stream(URL : String, Volume : Float = 1.0, Looped : Bool = false, AutoDestroy : Bool = true) : FlxSound
    {
        return FlxG.loadSound(null, Volume, Looped, AutoDestroy, true, URL);
    }
    
    /**
		 * Set <code>volume</code> to a number between 0 and 1 to change the global volume.
		 * 
		 * @default 0.5
		 */
    private static function get_volume() : Float
    {
        return _volume;
    }
    
    /**
		 * @private
		 */
    private static function set_volume(Volume : Float) : Float
    {
        _volume = Volume;
        if (_volume < 0)
        {
            _volume = 0;
        }
        else if (_volume > 1)
        {
            _volume = 1;
        }
        if (volumeHandler != null)
        {
            volumeHandler((FlxG.mute) ? 0 : _volume);
        }
        return Volume;
    }
    
    /**
		 * Called by FlxGame on state changes to stop and destroy sounds.
		 * 
		 * @param	ForceDestroy		Kill sounds even if they're flagged <code>survive</code>.
		 */
    @:allow(org.flixel)
    private static function destroySounds(ForceDestroy : Bool = false) : Void
    {
        if ((music != null) && (ForceDestroy || !music.survive))
        {
            music.destroy();
            music = null;
        }
        var i : Int = 0;
        var sound : FlxSound;
        var l : Int = sounds.members.length;
        while (i < l)
        {
            sound = try cast(sounds.members[i++], FlxSound) catch(e:Dynamic) null;
            if ((sound != null) && (ForceDestroy || !sound.survive))
            {
                sound.destroy();
            }
        }
    }
    
    /**
		 * Called by the game loop to make sure the sounds get updated each frame.
		 */
    @:allow(org.flixel)
    private static function updateSounds() : Void
    {
        if ((music != null) && music.active)
        {
            music.update();
        }
        if ((sounds != null) && sounds.active)
        {
            sounds.update();
        }
    }
    
    /**
		 * Pause all sounds currently playing.
		 */
    public static function pauseSounds() : Void
    {
        if ((music != null) && music.exists && music.active)
        {
            music.pause();
        }
        var i : Int = 0;
        var sound : FlxSound;
        var l : Int = sounds.length;
        while (i < l)
        {
            sound = try cast(sounds.members[i++], FlxSound) catch(e:Dynamic) null;
            if ((sound != null) && sound.exists && sound.active)
            {
                sound.pause();
            }
        }
    }
    
    /**
		 * Resume playing existing sounds.
		 */
    public static function resumeSounds() : Void
    {
        if ((music != null) && music.exists)
        {
            music.play();
        }
        var i : Int = 0;
        var sound : FlxSound;
        var l : Int = sounds.length;
        while (i < l)
        {
            sound = try cast(sounds.members[i++], FlxSound) catch(e:Dynamic) null;
            if ((sound != null) && sound.exists)
            {
                sound.resume();
            }
        }
    }
    
    /**
		 * Check the local bitmap cache to see if a bitmap with this key has been loaded already.
		 *
		 * @param	Key		The string key identifying the bitmap.
		 * 
		 * @return	Whether or not this file can be found in the cache.
		 */
    public static function checkBitmapCache(Key : String) : Bool
    {
        return (Reflect.field(_cache, Key) != null) && (Reflect.field(_cache, Key) != null);
    }
    
    /**
		 * Generates a new <code>BitmapData</code> object (a colored square) and caches it.
		 * 
		 * @param	Width	How wide the square should be.
		 * @param	Height	How high the square should be.
		 * @param	Color	What color the square should be (0xAARRGGBB)
		 * @param	Unique	Ensures that the bitmap data uses a new slot in the cache.
		 * @param	Key		Force the cache to use a specific Key to index the bitmap.
		 * 
		 * @return	The <code>BitmapData</code> we just created.
		 */
    public static function createBitmap(Width : Int, Height : Int, Color : Int, Unique : Bool = false, Key : String = null) : BitmapData
    {
        if (Key == null)
        {
            Key = Width + "x" + Height + ":" + Color;
            if (Unique && checkBitmapCache(Key))
            {
                var inc : Int = 0;
                var ukey : String;
                do
                {
                    ukey = Key + inc++;
                }
                while ((checkBitmapCache(ukey)));
                Key = ukey;
            }
        }
        if (!checkBitmapCache(Key))
        {
            Reflect.setField(_cache, Key, new BitmapData(Width, Height, true, Color));
        }
        return Reflect.field(_cache, Key);
    }
    
    /**
		 * Loads a bitmap from a file, caches it, and generates a horizontally flipped version if necessary.
		 * 
		 * @param	Graphic		The image file that you want to load.
		 * @param	Reverse		Whether to generate a flipped version.
		 * @param	Unique		Ensures that the bitmap data uses a new slot in the cache.
		 * @param	Key			Force the cache to use a specific Key to index the bitmap.
		 * 
		 * @return	The <code>BitmapData</code> we just created.
		 */
    public static function addBitmap(Graphic : Class<Dynamic>, Reverse : Bool = false, Unique : Bool = false, Key : String = null) : BitmapData
    {
        var needReverse : Bool = false;
        if (Key == null)
        {
            Key = Std.string(Graphic) + ((Reverse) ? "_REVERSE_" : "");
            if (Unique && checkBitmapCache(Key))
            {
                var inc : Int = 0;
                var ukey : String;
                do
                {
                    ukey = Key + inc++;
                }
                while ((checkBitmapCache(ukey)));
                Key = ukey;
            }
        }
        
        //If there is no data for this key, generate the requested graphic
        if (!checkBitmapCache(Key))
        {
            Reflect.setField(_cache, Key, (Type.createInstance(Graphic, [])).bitmapData);
            if (Reverse)
            {
                needReverse = true;
            }
        }
        var pixels : BitmapData = Reflect.field(_cache, Key);
        if (!needReverse && Reverse && (pixels.width == (Type.createInstance(Graphic, [])).bitmapData.width))
        {
            needReverse = true;
        }
        if (needReverse)
        {
            var newPixels : BitmapData = new BitmapData(pixels.width << 1, pixels.height, true, 0x00000000);
            newPixels.draw(pixels);
            var mtx : Matrix = new Matrix();
            mtx.scale(-1, 1);
            mtx.translate(newPixels.width, 0);
            newPixels.draw(pixels, mtx);
            pixels = newPixels;
            Reflect.setField(_cache, Key, pixels);
        }
        return pixels;
    }
    
    /**
		 * Dumps the cache's image references.
		 */
    public static function clearBitmapCache() : Void
    {
        _cache = {};
    }
    
    /**
		 * Read-only: retrieves the Flash stage object (required for event listeners)
		 * Will be null if it's not safe/useful yet.
		 */
    private static function get_stage() : Stage
    {
        if (_game.root != null)
        {
            return _game.stage;
        }
        return null;
    }
    
    /**
		 * Read-only: access the current game state from anywhere.
		 */
    private static function get_state() : FlxState
    {
        return _game._state;
    }
    
    /**
		 * Switch from the current game state to the one specified here.
		 */
    public static function switchState(State : FlxState) : Void
    {
        _game._requestedState = State;
    }
    
    /**
		 * Change the way the debugger's windows are laid out.
		 * 
		 * @param	Layout		See the presets above (e.g. <code>DEBUGGER_MICRO</code>, etc).
		 */
    public static function setDebuggerLayout(Layout : Int) : Void
    {
        if (_game._debugger != null)
        {
            _game._debugger.setLayout(Layout);
        }
    }
    
    /**
		 * Just resets the debugger windows to whatever the last selected layout was (<code>DEBUGGER_STANDARD</code> by default).
		 */
    public static function resetDebuggerLayout() : Void
    {
        if (_game._debugger != null)
        {
            _game._debugger.resetLayout();
        }
    }
    
    /**
		 * Add a new camera object to the game.
		 * Handy for PiP, split-screen, etc.
		 * 
		 * @param	NewCamera	The camera you want to add.
		 * 
		 * @return	This <code>FlxCamera</code> instance.
		 */
    public static function addCamera(NewCamera : FlxCamera) : FlxCamera
    {
        FlxG._game.addChildAt(NewCamera._flashSprite, FlxG._game.getChildIndex(FlxG._game._mouse));
        FlxG.cameras.push(NewCamera);
        return NewCamera;
    }
    
    /**
		 * Remove a camera from the game.
		 * 
		 * @param	Camera	The camera you want to remove.
		 * @param	Destroy	Whether to call destroy() on the camera, default value is true.
		 */
    public static function removeCamera(Camera : FlxCamera, Destroy : Bool = true) : Void
    {
        try
        {
            FlxG._game.removeChild(Camera._flashSprite);
        }
        catch (E : Error)
        {
            FlxG.log("Error removing camera, not part of game.");
        }
        if (Destroy)
        {
            Camera.destroy();
        }
    }
    
    /**
		 * Dumps all the current cameras and resets to just one camera.
		 * Handy for doing split-screen especially.
		 * 
		 * @param	NewCamera	Optional; specify a specific camera object to be the new main camera.
		 */
    public static function resetCameras(NewCamera : FlxCamera = null) : Void
    {
        var cam : FlxCamera;
        var i : Int = 0;
        var l : Int = cameras.length;
        while (i < l)
        {
            cam = try cast(FlxG.cameras[i++], FlxCamera) catch(e:Dynamic) null;
            FlxG._game.removeChild(cam._flashSprite);
            cam.destroy();
        }
        FlxG.cameras.length = 0;
        
        if (NewCamera == null)
        {
            NewCamera = new FlxCamera(0, 0, FlxG.width, FlxG.height);
        }
        FlxG.camera = FlxG.addCamera(NewCamera);
    }
    
    /**
		 * All screens are filled with this color and gradually return to normal.
		 * 
		 * @param	Color		The color you want to use.
		 * @param	Duration	How long it takes for the flash to fade.
		 * @param	OnComplete	A function you want to run when the flash finishes.
		 * @param	Force		Force the effect to reset.
		 */
    public static function flash(Color : Int = 0xffffffff, Duration : Float = 1, OnComplete : Function = null, Force : Bool = false) : Void
    {
        var i : Int = 0;
        var l : Int = FlxG.cameras.length;
        while (i < l)
        {
            (try cast(FlxG.cameras[i++], FlxCamera) catch(e:Dynamic) null).flash(Color, Duration, OnComplete, Force);
        }
    }
    
    /**
		 * The screen is gradually filled with this color.
		 * 
		 * @param	Color		The color you want to use.
		 * @param	Duration	How long it takes for the fade to finish.
		 * @param	OnComplete	A function you want to run when the fade finishes.
		 * @param	Force		Force the effect to reset.
		 */
    public static function fade(Color : Int = 0xff000000, Duration : Float = 1, OnComplete : Function = null, Force : Bool = false) : Void
    {
        var i : Int = 0;
        var l : Int = FlxG.cameras.length;
        while (i < l)
        {
            (try cast(FlxG.cameras[i++], FlxCamera) catch(e:Dynamic) null).fade(Color, Duration, OnComplete, Force);
        }
    }
    
    /**
		 * A simple screen-shake effect.
		 * 
		 * @param	Intensity	Percentage of screen size representing the maximum distance that the screen can move while shaking.
		 * @param	Duration	The length in seconds that the shaking effect should last.
		 * @param	OnComplete	A function you want to run when the shake effect finishes.
		 * @param	Force		Force the effect to reset (default = true, unlike flash() and fade()!).
		 * @param	Direction	Whether to shake on both axes, just up and down, or just side to side (use class constants SHAKE_BOTH_AXES, SHAKE_VERTICAL_ONLY, or SHAKE_HORIZONTAL_ONLY).  Default value is SHAKE_BOTH_AXES (0).
		 */
    public static function shake(Intensity : Float = 0.05, Duration : Float = 0.5, OnComplete : Function = null, Force : Bool = true, Direction : Int = 0) : Void
    {
        var i : Int = 0;
        var l : Int = FlxG.cameras.length;
        while (i < l)
        {
            (try cast(FlxG.cameras[i++], FlxCamera) catch(e:Dynamic) null).shake(Intensity, Duration, OnComplete, Force, Direction);
        }
    }
    
    /**
		 * Get and set the background color of the game.
		 * Get functionality is equivalent to FlxG.camera.bgColor.
		 * Set functionality sets the background color of all the current cameras.
		 */
    private static function get_bgColor() : Int
    {
        if (FlxG.camera == null)
        {
            return 0xff000000;
        }
        else
        {
            return FlxG.camera.bgColor;
        }
    }
    
    private static function set_bgColor(Color : Int) : Int
    {
        var i : Int = 0;
        var l : Int = FlxG.cameras.length;
        while (i < l)
        {
            (try cast(FlxG.cameras[i++], FlxCamera) catch(e:Dynamic) null).bgColor = Color;
        }
        return Color;
    }
    
    /**
		 * Call this function to see if one <code>FlxObject</code> overlaps another.
		 * Can be called with one object and one group, or two groups, or two objects,
		 * whatever floats your boat! For maximum performance try bundling a lot of objects
		 * together using a <code>FlxGroup</code> (or even bundling groups together!).
		 * 
		 * <p>NOTE: does NOT take objects' scrollfactor into account, all overlaps are checked in world space.</p>
		 * 
		 * @param	ObjectOrGroup1	The first object or group you want to check.
		 * @param	ObjectOrGroup2	The second object or group you want to check.  If it is the same as the first, flixel knows to just do a comparison within that group.
		 * @param	NotifyCallback	A function with two <code>FlxObject</code> parameters - e.g. <code>myOverlapFunction(Object1:FlxObject,Object2:FlxObject)</code> - that is called if those two objects overlap.
		 * @param	ProcessCallback	A function with two <code>FlxObject</code> parameters - e.g. <code>myOverlapFunction(Object1:FlxObject,Object2:FlxObject)</code> - that is called if those two objects overlap.  If a ProcessCallback is provided, then NotifyCallback will only be called if ProcessCallback returns true for those objects!
		 * 
		 * @return	Whether any oevrlaps were detected.
		 */
    public static function overlap(ObjectOrGroup1 : FlxBasic = null, ObjectOrGroup2 : FlxBasic = null, NotifyCallback : Function = null, ProcessCallback : Function = null) : Bool
    {
        if (ObjectOrGroup1 == null)
        {
            ObjectOrGroup1 = FlxG.state;
        }
        if (ObjectOrGroup2 == ObjectOrGroup1)
        {
            ObjectOrGroup2 = null;
        }
        FlxQuadTree.divisions = FlxG.worldDivisions;
        var quadTree : FlxQuadTree = new FlxQuadTree(FlxG.worldBounds.x, FlxG.worldBounds.y, FlxG.worldBounds.width, FlxG.worldBounds.height);
        quadTree.load(ObjectOrGroup1, ObjectOrGroup2, NotifyCallback, ProcessCallback);
        var result : Bool = quadTree.execute();
        quadTree.destroy();
        return result;
    }
    
    /**
		 * Call this function to see if one <code>FlxObject</code> collides with another.
		 * Can be called with one object and one group, or two groups, or two objects,
		 * whatever floats your boat! For maximum performance try bundling a lot of objects
		 * together using a <code>FlxGroup</code> (or even bundling groups together!).
		 * 
		 * <p>This function just calls FlxG.overlap and presets the ProcessCallback parameter to FlxObject.separate.
		 * To create your own collision logic, write your own ProcessCallback and use FlxG.overlap to set it up.</p>
		 * 
		 * <p>NOTE: does NOT take objects' scrollfactor into account, all overlaps are checked in world space.</p>
		 * 
		 * @param	ObjectOrGroup1	The first object or group you want to check.
		 * @param	ObjectOrGroup2	The second object or group you want to check.  If it is the same as the first, flixel knows to just do a comparison within that group.
		 * @param	NotifyCallback	A function with two <code>FlxObject</code> parameters - e.g. <code>myOverlapFunction(Object1:FlxObject,Object2:FlxObject)</code> - that is called if those two objects overlap.
		 * 
		 * @return	Whether any objects were successfully collided/separated.
		 */
    public static function collide(ObjectOrGroup1 : FlxBasic = null, ObjectOrGroup2 : FlxBasic = null, NotifyCallback : Function = null) : Bool
    {
        return overlap(ObjectOrGroup1, ObjectOrGroup2, NotifyCallback, FlxObject.separate);
    }
    
    /**
		 * Adds a new plugin to the global plugin array.
		 * 
		 * @param	Plugin	Any object that extends FlxBasic. Useful for managers and other things.  See org.flixel.plugin for some examples!
		 * 
		 * @return	The same <code>FlxBasic</code>-based plugin you passed in.
		 */
    public static function addPlugin(Plugin : FlxBasic) : FlxBasic
    //Don't add repeats
    {
        
        var pluginList : Array<Dynamic> = FlxG.plugins;
        var i : Int = 0;
        var l : Int = pluginList.length;
        while (i < l)
        {
            if (Std.string(pluginList[i++]) == Std.string(Plugin))
            {
                return Plugin;
            }
        }
        
        //no repeats! safe to add a new instance of this plugin
        pluginList.push(Plugin);
        return Plugin;
    }
    
    /**
		 * Retrieves a plugin based on its class name from the global plugin array.
		 * 
		 * @param	ClassType	The class name of the plugin you want to retrieve. See the <code>FlxPath</code> or <code>FlxTimer</code> constructors for example usage.
		 * 
		 * @return	The plugin object, or null if no matching plugin was found.
		 */
    public static function getPlugin(ClassType : Class<Dynamic>) : FlxBasic
    {
        var pluginList : Array<Dynamic> = FlxG.plugins;
        var i : Int = 0;
        var l : Int = pluginList.length;
        while (i < l)
        {
            if (Std.is(pluginList[i], ClassType))
            {
                return plugins[i];
            }
            i++;
        }
        return null;
    }
    
    /**
		 * Removes an instance of a plugin from the global plugin array.
		 * 
		 * @param	Plugin	The plugin instance you want to remove.
		 * 
		 * @return	The same <code>FlxBasic</code>-based plugin you passed in.
		 */
    public static function removePlugin(Plugin : FlxBasic) : FlxBasic
    //Don't add repeats
    {
        
        var pluginList : Array<Dynamic> = FlxG.plugins;
        var i : Int = as3hx.Compat.parseInt(pluginList.length - 1);
        while (i >= 0)
        {
            if (pluginList[i] == Plugin)
            {
                pluginList.splice(i, 1);
            }
            i--;
        }
        return Plugin;
    }
    
    /**
		 * Removes an instance of a plugin from the global plugin array.
		 * 
		 * @param	ClassType	The class name of the plugin type you want removed from the array.
		 * 
		 * @return	Whether or not at least one instance of this plugin type was removed.
		 */
    public static function removePluginType(ClassType : Class<Dynamic>) : Bool
    //Don't add repeats
    {
        
        var results : Bool = false;
        var pluginList : Array<Dynamic> = FlxG.plugins;
        var i : Int = as3hx.Compat.parseInt(pluginList.length - 1);
        while (i >= 0)
        {
            if (Std.is(pluginList[i], ClassType))
            {
                pluginList.splice(i, 1);
                results = true;
            }
            i--;
        }
        return results;
    }
    
    /**
		 * Called by <code>FlxGame</code> to set up <code>FlxG</code> during <code>FlxGame</code>'s constructor.
		 */
    @:allow(org.flixel)
    private static function init(Game : FlxGame, Width : Int, Height : Int, Zoom : Float) : Void
    {
        FlxG._game = Game;
        FlxG.width = Width;
        FlxG.height = Height;
        
        FlxG.mute = false;
        FlxG._volume = 0.5;
        FlxG.sounds = new FlxGroup();
        FlxG.volumeHandler = null;
        
        FlxG.clearBitmapCache();
        
        if (flashGfxSprite == null)
        {
            flashGfxSprite = new Sprite();
            flashGfx = flashGfxSprite.graphics;
        }
        
        FlxCamera.defaultZoom = Zoom;
        FlxG._cameraRect = new Rectangle();
        FlxG.cameras = new Array<Dynamic>();
        useBufferLocking = false;
        
        plugins = new Array<Dynamic>();
        addPlugin(new DebugPathDisplay());
        addPlugin(new TimerManager());
        
        FlxG.mouse = new Mouse(FlxG._game._mouse);
        FlxG.keys = new Keyboard();
        FlxG.mobile = false;
        
        FlxG.levels = new Array<Dynamic>();
        FlxG.scores = new Array<Dynamic>();
        FlxG.visualDebug = false;
    }
    
    /**
		 * Called whenever the game is reset, doesn't have to do quite as much work as the basic initialization stuff.
		 */
    @:allow(org.flixel)
    private static function reset() : Void
    {
        FlxG.clearBitmapCache();
        FlxG.resetInput();
        FlxG.destroySounds(true);
        FlxG.levels.length = 0;
        FlxG.scores.length = 0;
        FlxG.level = 0;
        FlxG.score = 0;
        FlxG.paused = false;
        FlxG.timeScale = 1.0;
        FlxG.elapsed = 0;
        FlxG.globalSeed = Math.random();
        FlxG.worldBounds = new FlxRect(-10, -10, FlxG.width + 20, FlxG.height + 20);
        FlxG.worldDivisions = 6;
        var debugPathDisplay : DebugPathDisplay = try cast(FlxG.getPlugin(DebugPathDisplay), DebugPathDisplay) catch(e:Dynamic) null;
        if (debugPathDisplay != null)
        {
            debugPathDisplay.clear();
        }
    }
    
    /**
		 * Called by the game object to update the keyboard and mouse input tracking objects.
		 */
    @:allow(org.flixel)
    private static function updateInput() : Void
    {
        FlxG.keys.update();
        if (!_game._debuggerUp || !_game._debugger.hasMouse)
        {
            FlxG.mouse.update(FlxG._game.mouseX, FlxG._game.mouseY);
        }
    }
    
    /**
		 * Called by the game object to lock all the camera buffers and clear them for the next draw pass.
		 */
    @:allow(org.flixel)
    private static function lockCameras() : Void
    {
        var cam : FlxCamera;
        var cams : Array<Dynamic> = FlxG.cameras;
        var i : Int = 0;
        var l : Int = cams.length;
        while (i < l)
        {
            cam = try cast(cams[i++], FlxCamera) catch(e:Dynamic) null;
            if ((cam == null) || !cam.exists || !cam.visible)
            {
                continue;
            }
            if (useBufferLocking)
            {
                cam.buffer.lock();
            }
            cam.fill(cam.bgColor);
            cam.screen.dirty = true;
        }
    }
    
    /**
		 * Called by the game object to draw the special FX and unlock all the camera buffers.
		 */
    @:allow(org.flixel)
    private static function unlockCameras() : Void
    {
        var cam : FlxCamera;
        var cams : Array<Dynamic> = FlxG.cameras;
        var i : Int = 0;
        var l : Int = cams.length;
        while (i < l)
        {
            cam = try cast(cams[i++], FlxCamera) catch(e:Dynamic) null;
            if ((cam == null) || !cam.exists || !cam.visible)
            {
                continue;
            }
            cam.drawFX();
            if (useBufferLocking)
            {
                cam.buffer.unlock();
            }
        }
    }
    
    /**
		 * Called by the game object to update the cameras and their tracking/special effects logic.
		 */
    @:allow(org.flixel)
    private static function updateCameras() : Void
    {
        var cam : FlxCamera;
        var cams : Array<Dynamic> = FlxG.cameras;
        var i : Int = 0;
        var l : Int = cams.length;
        while (i < l)
        {
            cam = try cast(cams[i++], FlxCamera) catch(e:Dynamic) null;
            if ((cam != null) && cam.exists)
            {
                if (cam.active)
                {
                    cam.update();
                }
                cam._flashSprite.x = cam.x + cam._flashOffsetX;
                cam._flashSprite.y = cam.y + cam._flashOffsetY;
                cam._flashSprite.visible = cam.visible;
            }
        }
    }
    
    /**
		 * Used by the game object to call <code>update()</code> on all the plugins.
		 */
    @:allow(org.flixel)
    private static function updatePlugins() : Void
    {
        var plugin : FlxBasic;
        var pluginList : Array<Dynamic> = FlxG.plugins;
        var i : Int = 0;
        var l : Int = pluginList.length;
        while (i < l)
        {
            plugin = try cast(pluginList[i++], FlxBasic) catch(e:Dynamic) null;
            if (plugin.exists && plugin.active)
            {
                plugin.update();
            }
        }
    }
    
    /**
		 * Used by the game object to call <code>draw()</code> on all the plugins.
		 */
    @:allow(org.flixel)
    private static function drawPlugins() : Void
    {
        var plugin : FlxBasic;
        var pluginList : Array<Dynamic> = FlxG.plugins;
        var i : Int = 0;
        var l : Int = pluginList.length;
        while (i < l)
        {
            plugin = try cast(pluginList[i++], FlxBasic) catch(e:Dynamic) null;
            if (plugin.exists && plugin.visible)
            {
                plugin.draw();
            }
        }
    }

    public function new()
    {
    }
}

