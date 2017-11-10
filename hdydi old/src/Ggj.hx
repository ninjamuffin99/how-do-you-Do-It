import org.flixel.*;

@:meta(SWF(width="640",height="480",backgroundColor="#000000"))

@:meta(Frame(factoryClass="Preloader"))

class Ggj extends FlxGame
{
    public static inline var VOLUME : Float = .4;
    
    public function new()
    {
        super(320, 240, MenuState, 2);
    }
}

