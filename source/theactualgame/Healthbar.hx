package theactualgame;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;

class Healthbar extends FlxSprite
{
	private var follow:FlxObject;

	public function new()
	{
		super(0, 0);
		makeGraphic(8, 1, FlxColor.WHITE);
		origin.set(0, 0);
	}

	public function followObject(_follow:FlxObject):Healthbar
	{
		follow = _follow;
		return this;
	}

	public function addTo(group:FlxTypedGroup<FlxSprite>):Healthbar
	{
		group.add(this);
		return this;
	}

	override function kill()
	{
		super.kill();
		follow = null;
	}

	public function updateHealth(_health:Float, maxHealth:Float)
	{
		scale.set(Math.max(_health / maxHealth, 0), 1);
		color = FlxColor.fromRGBFloat(1.0 - (_health / maxHealth), _health / maxHealth, 0.0);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (follow != null)
		{
			this.x = follow.x;
			this.y = follow.y;
		}
	}
}
