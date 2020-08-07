package theactualgame;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxAngle;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;

class Follower extends FlxSprite
{
	private var player:Player;
	private var walls:FlxTilemap;
	private var parent:TheActualGameSubstate;

	private var wowow:FlxSound;

	public function new(X:Float, Y:Float, player:Player, walls:FlxTilemap, parent:TheActualGameSubstate)
	{
		super(X, Y);
		loadGraphic("assets/images/mmo/sprites.png", true, 8, 8, true);

		wowow = new FlxSound().loadEmbedded("assets/sounds/wowow.ogg");

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
		this.parent = parent;

		health = 100.0;
	}

	var currentPoint:FlxPoint = null;

	private var healthbar:Healthbar;

	public function setHealthbar(_healthbar:Healthbar):Follower
	{
		healthbar = _healthbar;
		healthbar.x = this.x;
		healthbar.y = this.y;
		healthbar.followObject(this);
		healthbar.updateHealth(health, 100.0);
		return this;
	}

	private var paralyzed = 0.0;

	private var damnPlayed = false;

	public function hitAndParalyze(slime:FlxSprite)
	{
		if (paralyzed > 0)
			return;

		var hit = FlxG.random.float(1.0, 5.0);
		health -= hit;
		if (healthbar != null)
			healthbar.updateHealth(health, 100.0);

		if (health < 20 && !damnPlayed)
		{
			damnPlayed = true;
			FlxG.sound.play("assets/sounds/damn.ogg");
		}
		else if (hit >= 2.5 && !wowow.playing)
			wowow.play();

		if (health < 0)
		{
			if (parent != null)
				parent.gameOver();
			return;
		}
		paralyzed = 0.4;
		var _angle = FlxAngle.angleBetween(this, slime, true);
		velocity.set(-25.0, 0);
		velocity.rotate(FlxPoint.weak(0, 0), _angle);
	}

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
				if (ydist > xdist)
				{
					if (velocity.y > 0)
						facing = FlxObject.DOWN;
					else if (velocity.y < 0)
						facing = FlxObject.UP;
				}
				else if (velocity.x > 0)
					facing = FlxObject.RIGHT;
				else if (velocity.x < 0)
					facing = FlxObject.LEFT;
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

		if (paralyzed > 0)
		{
			paralyzed -= elapsed;
			alpha = 0.7 + 0.1 * FlxMath.fastCos(paralyzed * 8.0);
			color = FlxColor.fromRGBFloat(0.8 + 0.2 * FlxMath.fastSin(paralyzed * 12.0), 0.25, 0.25);
			if (paralyzed <= 0)
			{
				alpha = 1;
				velocity.set(0, 0);
				color = FlxColor.WHITE;
			}
			return;
		}

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
