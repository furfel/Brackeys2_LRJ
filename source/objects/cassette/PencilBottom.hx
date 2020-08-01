package objects.cassette;

import flixel.FlxSprite;

class PencilBottom extends FlxSprite
{
	public function new(X:Float, Y:Float)
	{
		super(X, Y);
		loadGraphic("assets/images/cassette/pencil_bottom.png", true, 10, 38);

		animation.add("0", [0], 5);
		animation.add("1", [1], 5);

		animation.play("0");
	}
}
