package objects.cassette;

import flixel.FlxSprite;

class Circle extends FlxSprite
{
	public function new(X:Float, Y:Float)
	{
		super(X, Y);
		loadGraphic("assets/images/cassette/circle.png", true, 14, 14);

		animation.add("0", [0], 5);
		animation.add("1", [1], 5);

		animation.play("0");
	}
}
