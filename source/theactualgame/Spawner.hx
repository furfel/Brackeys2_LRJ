package theactualgame;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxObject;

class Spawner extends FlxObject
{
	private var parent:TheActualGameSubstate;
	private var radius = 0.0;
	private var slimes = 0;
	private var maxSlimes = 3;

	public function new(X:Float, Y:Float, R:Float, state:TheActualGameSubstate, maxSlimes = 3)
	{
		super(X, Y);
		radius = R;
		this.parent = state;
		this.maxSlimes = maxSlimes;
	}

	/**
		Spawn a slime within a chosen radius away from colliding walls
	**/
	private function spawn():Slime
	{
		var temporarySlime:Slime = null;
		do
		{
			var randomX = FlxG.random.float(x - radius, x + radius);
			var randomY = FlxG.random.float(y - radius, y + radius);
			temporarySlime = new Slime(randomX, randomY, parent, this);
		}
		while (parent.walls.overlaps(temporarySlime)
				|| parent.floors.getTile(Std.int(temporarySlime.x / 8), Std.int(temporarySlime.y / 8)) < 20);

		slimes++;
		return temporarySlime;
	}

	public function killSlime()
	{
		slimes--;
	}

	private var countdown = FlxG.random.float(1.0, 5.0);

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (countdown > 0)
		{
			countdown -= elapsed;
			if (countdown <= 0)
			{
				countdown = FlxG.random.float(12.0, 14.0);
				if (slimes < maxSlimes)
					parent.slime.add(spawn().setHealthbar(new Healthbar().addTo(parent.uiGroup)));
			}
		}
	}
}
