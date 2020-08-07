package theactualgame;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxAngle;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;

class Follower extends FlxSprite
{
	private var player:Player;
	private var walls:FlxTilemap;

	public function new(X:Float, Y:Float, player:Player, walls:FlxTilemap)
	{
		super(X, Y);
		loadGraphic("assets/images/mmo/sprites.png", true, 8, 8);

		animation.add(Std.string(FlxObject.RIGHT), [10], 3);
		animation.add(Std.string(FlxObject.RIGHT) + "walk", [9, 10], 3);
		animation.add(Std.string(FlxObject.LEFT), [10], 3, true, true);
		animation.add(Std.string(FlxObject.LEFT) + "walk", [9, 10], 3, true, true);
		animation.add(Std.string(FlxObject.DOWN), [13], 3);
		animation.add(Std.string(FlxObject.DOWN) + "walk", [12, 11], 3);
		animation.add(Std.string(FlxObject.UP), [16], 3);
		animation.add(Std.string(FlxObject.UP) + "walk", [15, 14], 3);

		facing = FlxObject.RIGHT;
		updateAnim();

		this.player = player;
		this.walls = walls;
	}

	var currentPoint:FlxPoint = null;

	var currentAnimation = "";

	private function updateAnim()
	{
		var nextAnim = Std.string(facing);

		if (velocity.x != 0 || velocity.y != 0)
			nextAnim += "walk";

		if (currentAnimation != nextAnim)
		{
			currentAnimation = nextAnim;
			animation.play(currentAnimation);
		}
	}

	private function follow()
	{
		if (walls != null && player != null)
		{
			var points = walls.findPath(getMidpoint(), player.getMidpoint());
			if (points != null && points.length > 1)
			{
				currentPoint = points[1];
				var mp = getMidpoint();
				var ydist = Math.abs(mp.y - currentPoint.y);
				var xdist = Math.abs(mp.x - currentPoint.x);
				var sum = ydist + xdist;
				if (sum > 0)
					velocity.set(FlxMath.signOf(currentPoint.x - mp.x) * xdist / sum * 25.0, FlxMath.signOf(currentPoint.y - mp.y) * ydist / sum * 25.0);
				if (velocity.y > 0)
					facing = FlxObject.DOWN;
				else if (velocity.y < 0)
					facing = FlxObject.UP;
				else if (velocity.x > 0)
					facing = FlxObject.RIGHT;
				else if (velocity.x < 0)
					facing = FlxObject.LEFT;
				// velocity.rotate(FlxPoint.weak(0, 0), FlxAngle.asDegrees(Math.atan2(currentPoint.y - getMidpoint().y, currentPoint.x - getMidpoint().x)));
			}
			else
			{
				velocity.set(0, 0);
			}
		}
		followTimeout = 0.5;
	}

	private var followTimeout = 0.5;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (player != null && player.overlaps(this))
		{
			velocity.set(0, 0);
			currentPoint = null;
			updateAnim();
		}
		else if ((currentPoint != null && this.overlapsPoint(currentPoint)) || followTimeout <= 0)
		{
			follow();
			updateAnim();
		}
		else
			followTimeout -= elapsed;
	}
}
