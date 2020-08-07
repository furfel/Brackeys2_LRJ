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

class TheActualGameSubstate extends FlxSubState
{
	public var player:Player;

	private var dungeonMap:DungeonMap;
	private var walls:FlxTilemap;

	public var floors:FlxTilemap;
	public var slime = new FlxTypedGroup<Slime>();
	public var stones = new FlxTypedGroup<Stone>(10);

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

		slime.add(new Slime(8 * 8, 9 * 8, this).setHealthbar(new Healthbar().addTo(uiGroup)));
		slime.add(new Slime(18 * 8, 7 * 8, this).setHealthbar(new Healthbar().addTo(uiGroup)));
		slime.add(new Slime(10 * 8, 25 * 8, this).setHealthbar(new Healthbar().addTo(uiGroup)));
		slime.add(new Slime(15 * 8, 22 * 8, this).setHealthbar(new Healthbar().addTo(uiGroup)));
		slime.add(new Slime(17 * 8, 20 * 8, this).setHealthbar(new Healthbar().addTo(uiGroup)));
		slime.add(new Slime(23 * 8, 24 * 8, this).setHealthbar(new Healthbar().addTo(uiGroup)));
		slime.add(new Slime(22 * 8, 13 * 8, this).setHealthbar(new Healthbar().addTo(uiGroup)));

		dungeonMap = new DungeonMap();
		add(floors = dungeonMap.getFloorsMap());
		add(slime);
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
		openSubState(new RewindState(this));
	}

	override function update(elapsed:Float)
	{
		if (slime.countLiving() <= 0)
		{
			super.update(elapsed);
			gameOver();
			return;
		}

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
