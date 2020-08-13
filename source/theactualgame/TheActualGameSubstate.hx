package theactualgame;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxAssets;
import flixel.system.debug.FlxDebugger;
import flixel.tile.FlxTile;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
import states.ComputerState;
import states.RoomState2;

class TheActualGameSubstate extends FlxSubState
{
	public var player:Player;

	private var dungeonMap:DungeonMap;

	public var walls:FlxTilemap;
	public var floors:FlxTilemap;
	public var slime = new FlxTypedGroup<Slime>();
	public var stones = new FlxTypedGroup<Stone>(10);
	public var spawner = new FlxTypedGroup<Spawner>();

	public var uiGroup = new FlxTypedGroup<FlxSprite>();
	public var follower:Follower;

	private var parent:FlxState;

	public function new(_parent:FlxState)
	{
		super();
		this.parent = _parent;
	}

	override function create()
	{
		super.create();
		restart();
	}

	public function restart()
	{
		FlxG.camera.follow(null);
		forEach((b) -> (b != null) ? b.destroy() : null);
		clear();
		slime = new FlxTypedGroup<Slime>();
		stones = new FlxTypedGroup<Stone>(10);
		uiGroup = new FlxTypedGroup<FlxSprite>();

		spawner.add(new Spawner(8 * 8, 9 * 8, 3 * 8, this, 4));
		spawner.add(new Spawner(23 * 8, 24 * 8, 5 * 8, this));
		spawner.add(new Spawner(22 * 8, 13 * 8, 5 * 8, this, 5));

		dungeonMap = new DungeonMap();
		add(floors = dungeonMap.getFloorsMap());
		add(slime);
		add(spawner);
		add(stones);
		add(player = new Player(6 * 8, 15 * 8, this).setHealthbar(new Healthbar().addTo(uiGroup)));
		add(walls = dungeonMap.getWallsMap());
		add(follower = new Follower(player.x - 16, player.y + 8, player, walls, this).setHealthbar(new Healthbar().addTo(uiGroup)));
		dungeonMap.updateWorldBounds();

		add(uiGroup);

		FlxG.camera.follow(player);
		FlxG.camera.fade(ComputerState.FadeColor, 0.2, true);

		FlxG.sound.play("assets/sounds/slimes.ogg");
	}

	public function gameOver()
	{
		close();
		FlxG.switchState(new RoomState2());
	}

	override function update(elapsed:Float)
	{
		FlxG.collide(follower, walls);
		super.update(elapsed);
		FlxG.collide(player, walls);

		FlxG.collide(player, slime, (p, s) ->
		{
			var sl:Slime = cast(s);
			if (sl.alive)
				player.hitAndParalyze(sl);
		});

		FlxG.collide(follower, slime, (f, s) ->
		{
			var sl:Slime = cast(s);
			if (sl.alive)
				follower.hitAndParalyze(sl);
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
