package theactualgame;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxAngle;
import flixel.math.FlxPoint;

class Slime extends FlxSprite
{
	public static final SPEED = 15;

	private var parent:TheActualGameSubstate;

	public function new(X:Float, Y:Float, state:TheActualGameSubstate)
	{
		super(X, Y);

		loadGraphic("assets/images/mmo/sprites.png", true, 8, 8);
		animation.add("slime", [17, 18, 20, 19], 3);
		animation.play("slime");

		setSize(6, 5);
		offset.set(1, 3);

		parent = state;
	}

	private var rollTimeout = 0.8;

	private function move()
	{
		if (parent.player.getMidpoint().distanceTo(this.getMidpoint()) < 20.0)
		{
			var _angle = FlxAngle.angleBetween(parent.player, this, true);
			velocity.set(-SPEED, 0);
			velocity.rotate(FlxPoint.weak(0, 0), _angle);
		}
		else
			switch (FlxG.random.int(0, 4))
			{
				case 0:
					velocity.set(-SPEED, 0);
				case 1:
					velocity.set(SPEED, 0);
				case 2:
					velocity.set(0, SPEED);
				case 3:
					velocity.set(0, -SPEED);
				case 4:
					velocity.set(0, 0);
			}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (rollTimeout > 0)
		{
			rollTimeout -= elapsed;
			if (rollTimeout <= 0)
			{
				rollTimeout = FlxG.random.float(0.7, 0.9);
				move();
			}
		}
	}
}
