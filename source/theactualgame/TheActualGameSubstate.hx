package theactualgame;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxAssets;
import flixel.system.debug.FlxDebugger;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
import states.ComputerState;

class TheActualGameSubstate extends FlxSubState
{
	public var player:Player;

	private var dungeonMap:DungeonMap;
	private var walls:FlxTilemap;

	public var floors:FlxTilemap;
	public var slime = new FlxTypedGroup<Slime>();

	override function create()
	{
		super.create();

		slime.add(new Slime(8 * 8, 9 * 8, this));
		slime.add(new Slime(18 * 8, 7 * 8, this));

		dungeonMap = new DungeonMap();
		add(floors = dungeonMap.getFloorsMap());
		add(slime);
		add(player = new Player(6 * 8, 15 * 8, this));
		add(walls = dungeonMap.getWallsMap());
		dungeonMap.updateWorldBounds();

		FlxG.camera.follow(player);
		FlxG.camera.fade(ComputerState.FadeColor, 0.2, true);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		FlxG.collide(player, walls);

		FlxG.collide(player, slime, (p, s) ->
		{
			var sl:Slime = cast(s);
			if (sl.alive)
				player.hitAndParalyze(sl);
		});

		FlxG.collide(slime, walls);
	}
}
