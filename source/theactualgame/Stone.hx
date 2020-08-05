package theactualgame;

import flixel.FlxSprite;
import flixel.math.FlxPoint;

class Stone extends FlxSprite
{
	private static final THROW_SPEED = 100;
	private static final MAX_LIFE = 0.6;

	public function new(X:Float, Y:Float, _angle:Float)
	{
		super(X, Y);

		loadGraphic("assets/images/mmo/sprites.png", true, 8, 8);
		animation.add("", [21], 3);
		animation.play("");

		angularVelocity = 781;
		angle = _angle;
		velocity.set(THROW_SPEED, 0);
		velocity.rotate(FlxPoint.weak(0, 0), _angle);
		lifetime = MAX_LIFE;
		setSize(4, 4);
		offset.set(2, 2);
	}

	private var lifetime = 0.0;

	public function throwStone(x:Float, y:Float, _angle:Float)
	{
		reset(x, y);
		alive = true;
		exists = true;
		angle = _angle;
		velocity.set(THROW_SPEED, 0);
		velocity.rotate(FlxPoint.weak(0, 0), _angle);
		lifetime = MAX_LIFE;
	}

	public function getHitPower():Float
	{
		return 3.0 + lifetime / MAX_LIFE * 4.0;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (lifetime > 0)
		{
			lifetime -= elapsed;
			if (lifetime <= 0)
			{
				kill();
			}
		}
	}
}
