package objects.desk;

import flixel.FlxSprite;

class Pointer extends FlxSprite
{
	public function new(X:Float, Y:Float)
	{
		super(X, Y);
		loadGraphic("assets/images/pointer.png");
	}
}
