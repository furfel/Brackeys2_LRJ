package theactualgame;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxTimer;

class BigStone extends FlxSprite
{
	private var startX = 0.0;
	private var startY = 0.0;
	private var endX = 0.0;
	private var endY = 0.0;

	public function new(X:Float, Y:Float, endX:Float, endY:Float)
	{
		super(X, Y);

		if (endX > X || endY > Y)
			angularVelocity = 360;
		else
			angularVelocity = -360;

		if (endX > X)
			facing = FlxObject.RIGHT;
		else if (endX < X)
			facing = FlxObject.LEFT;
		else if (endY > Y)
			facing = FlxObject.DOWN;
		else if (endY < Y)
			facing = FlxObject.UP;

		setVelocity();

		this.startX = X;
		this.startY = Y;
		this.endX = endX;
		this.endY = endY;
	}

	override function reset(X:Float, Y:Float)
	{
		super.reset(startX, startY);
		velocity.set(0, 0);
		new FlxTimer().start(FlxG.random.float(1.0, 2.5), (t) ->
		{
			setVelocity();
		});
	}

	private function setVelocity()
	{
		switch (facing)
		{
			case FlxObject.UP:
				velocity.set(0, -120);
			case FlxObject.DOWN:
				velocity.set(0, 120);
			case FlxObject.RIGHT:
				velocity.set(120, 0);
			case FlxObject.LEFT:
				velocity.set(-120, 0);
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		switch (facing)
		{
			case FlxObject.UP:
				if (y <= endY)
					reset(0, 0);
			case FlxObject.DOWN:
				if (y >= endY)
					reset(0, 0);
			case FlxObject.RIGHT:
				if (x >= endX)
					reset(0, 0);
			case FlxObject.LEFT:
				if (x <= endX)
					reset(0, 0);
		}
	}
}
