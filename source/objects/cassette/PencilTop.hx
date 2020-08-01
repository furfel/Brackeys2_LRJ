package objects.cassette;

import flixel.FlxSprite;

class PencilTop extends FlxSprite
{
	public function new(X:Float, Y:Float)
	{
		super(X, Y);
		loadGraphic("assets/images/cassette/pencil_top.png", true, 10, 27);

		animation.add("0", [0], 5);
		animation.add("1", [1], 5);

		animation.play("0");
	}
}
