package;

import flixel.FlxState;

/**
 * ...
 * @author ninjaMuffin
 */
class MomLeavingState extends FlxState 
{
	
	public var nextState:FlxState;

	public function new(next:FlxState) 
	{
		super();
		
		this.nextState = next;
		
	}
	
	override public function create():Void 
	{
		
		
		
		super.create();
	}
	
}