package theactualgame;

import flixel.FlxSprite;

class Stairs extends FlxSprite
{
	public function new(X:Float, Y:Float)
	{
		super(X, Y);
		loadGraphic("assets/images/mmo/sprites.png", true, 8, 8);
		frame = frames.frames[27];
		animation.frameIndex = 27;
	}
}
