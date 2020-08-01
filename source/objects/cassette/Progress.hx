package objects.cassette;

import flixel.FlxSprite;

class Progress extends FlxSprite
{
	public function new(X:Float, Y:Float)
	{
		super(X, Y);
		loadGraphic("assets/images/cassette/cassette_progress.png", true, 15, 12);

		for (i in 0...10)
			animation.add(Std.string(i), [i], 5);

		animation.play("0");
	}

	/**
		Progress = 0 to 1
	**/
	public function setProgress(progress:Float)
	{
		for (i in 0...10)
		{
			if (progress >= (9 - i) / 10.0)
			{
				animation.play(Std.string((9 - i)));
				break;
			}
		}
	}
}
