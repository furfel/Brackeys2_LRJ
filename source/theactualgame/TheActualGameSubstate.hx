package theactualgame;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.system.FlxAssets;
import flixel.system.debug.FlxDebugger;
import flixel.util.FlxColor;
import states.ComputerState;

class TheActualGameSubstate extends FlxSubState
{
	private var player:Player;

	private var dungeonMap:DungeonMap;

	override function create()
	{
		super.create();

		dungeonMap = new DungeonMap();
		add(dungeonMap.getFloorsMap());
		add(player = new Player(10, 10));
		add(dungeonMap.getWallsMap());
		FlxG.camera.follow(player);
		FlxG.camera.fade(ComputerState.FadeColor, 0.2, true);
	}
}
