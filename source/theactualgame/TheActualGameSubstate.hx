package theactualgame;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxAssets;
import flixel.system.debug.FlxDebugger;
import flixel.tile.FlxTile;
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
	public var stones = new FlxTypedGroup<Stone>(10);

	override function create()
	{
		super.create();

		slime.add(new Slime(8 * 8, 9 * 8, this));
		slime.add(new Slime(18 * 8, 7 * 8, this));

		dungeonMap = new DungeonMap();
		add(floors = dungeonMap.getFloorsMap());
		add(slime);
		add(stones);
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

		FlxG.collide(stones, slime, (st, sl) ->
		{
			var sli:Slime = cast(sl);
			var sto:Stone = cast(st);
			if (sto.alive && sli.alive)
			{
				sli.hitBy(sto.getHitPower());
				sto.kill();
			}
		});

		FlxG.collide(stones, walls, (s, w) ->
		{
			var st:Stone = cast(s);
			if (st.alive)
				st.kill();
		});
	}
}
