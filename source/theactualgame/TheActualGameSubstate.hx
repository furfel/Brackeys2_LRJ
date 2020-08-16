package theactualgame;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.system.FlxAssets;
import flixel.system.debug.FlxDebugger;
import flixel.tile.FlxTile;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import states.ComputerState;
import states.RoomState2;

class TheActualGameSubstate extends FlxSubState
{
	public var player:Player;

	private var dungeonMap:DungeonMap;

	public var walls:FlxTilemap;
	public var floors:FlxTilemap;
	public var slime = new FlxTypedGroup<Slime>();
	public var bigStone = new FlxTypedGroup<BigStone>();
	public var bigStoneDecor = new FlxTypedGroup<FlxSprite>();
	public var stones = new FlxTypedGroup<Stone>(10);
	public var spawner = new FlxTypedGroup<Spawner>();
	public var stairs:Stairs;

	public var movables = new FlxGroup();

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

		spawner.add(new Spawner(11 * 8, 9 * 8, 3 * 8, this));
		spawner.add(new Spawner(23 * 8, 24 * 8, 5 * 8, this));
		spawner.add(new Spawner(14 * 8, 21 * 8, 5 * 8, this, 2));
		spawner.add(new Spawner(22 * 8, 13 * 8, 5 * 8, this, 5));
		spawner.add(new Spawner(11 * 8, 32 * 8, 4 * 8, this, 6));
		spawner.add(new Spawner(22 * 8, 33 * 8, 4 * 8, this, 5));
		spawner.add(new Spawner(4 * 8, 35 * 8, 4 * 8, this, 6));
		bigStone.add(new BigStone(14 * 8, 18 * 8, 19 * 8, 18 * 8, this));
		bigStone.add(new BigStone(18 * 8, 5 * 8, 18 * 8, 9 * 8, this));
		bigStone.add(new BigStone(14 * 8, 38 * 8, 14 * 8, 44 * 8, this));
		bigStone.add(new BigStone(8, 33 * 8, 6 * 8, 33 * 8, this));

		dungeonMap = new DungeonMap();
		add(floors = dungeonMap.getFloorsMap());
		add(stairs = new Stairs(4 * 8, 24 * 8));
		add(slime);
		add(bigStone);
		add(spawner);
		add(stones);
		add(player = new Player(6 * 8, 15 * 8, this).setHealthbar(new Healthbar().addTo(uiGroup)));
		add(walls = dungeonMap.getWallsMap());
		add(follower = new Follower(player.x - 16, player.y + 8, player, walls, this).setHealthbar(new Healthbar().addTo(uiGroup)));
		dungeonMap.updateWorldBounds();

		add(bigStoneDecor);
		add(uiGroup);

		FlxG.camera.follow(player);
		FlxG.camera.fade(ComputerState.FadeColor, 0.15, true);

		movables.add(player);
		movables.add(follower);
		movables.add(slime);
		movables.add(stones);

		new FlxTimer().start(1.5, (t) ->
		{
			FlxG.sound.play("assets/sounds/helpme.ogg");
		});
	}

	public function gameOver()
	{
		close();
		FlxG.switchState(new RoomState2());
	}

	public function winGame()
	{
		FlxG.camera.fade(ComputerState.FadeColor, () ->
		{
			close();
			new FlxTimer().start(1.0, (t) ->
			{
				FlxG.switchState(new TheActualGameSubstate2());
			});
		});
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		FlxG.collide(follower, walls);
		FlxG.collide(player, walls);

		FlxG.overlap(player, stairs, (p, s) ->
		{
			if (player.getMidpoint().distanceTo(follower.getMidpoint()) <= 30)
				winGame();
		});

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

		FlxG.collide(bigStone, movables, (b, m) ->
		{
			if ((m is Stone))
				cast(m, Stone).kill();
			else if ((m is Player))
				cast(m, Player).kill();
			else if ((m is Follower))
				cast(m, Follower).kill();
			else if ((m is Slime))
				cast(m, Slime).kill();
		});

		FlxG.collide(stones, walls, (s, w) ->
		{
			var st:Stone = cast(s);
			if (st.alive)
				st.kill();
		});
	}
}
