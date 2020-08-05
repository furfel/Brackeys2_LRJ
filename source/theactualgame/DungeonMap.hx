package theactualgame;

import flixel.tile.FlxBaseTilemap;
import flixel.tile.FlxTile;
import flixel.tile.FlxTilemap;

class DungeonMap
{
	private var floors:FlxTilemap;
	private var walls:FlxTilemap;

	public function new()
	{
		walls = new FlxTilemap();
		floors = new FlxTilemap();
		floors.loadMapFromCSV("assets/data/dungeon.csv", "assets/images/mmo/sprites.png", 8, 8);
		generateWalls();
	}

	private function generateWalls()
	{
		var wallArray = new Array<Int>();
		for (_y in 0...floors.heightInTiles)
		{
			for (_x in 0...floors.widthInTiles)
			{
				wallArray.push(0);
				if (_x > 0 && _y > 0 && _x < floors.widthInTiles - 1 && _y < floors.heightInTiles - 1 && floors.getTile(_x, _y) <= 0)
				{
					if (floors.getTile(_x - 1, _y) >= 24 && floors.getTile(_x + 1, _y) >= 24)
						wallArray[_y * floors.widthInTiles + _x] = 37; // LR
					else if (floors.getTile(_x, _y - 1) >= 24 && floors.getTile(_x, _y + 1) >= 24)
						wallArray[_y * floors.widthInTiles + _x] = 38; // TB
					else if (floors.getTile(_x - 1, _y) >= 24 && floors.getTile(_x, _y - 1) >= 24)
						wallArray[_y * floors.widthInTiles + _x] = 42; // LT
					else if (floors.getTile(_x - 1, _y) >= 24 && floors.getTile(_x, _y + 1) >= 24)
						wallArray[_y * floors.widthInTiles + _x] = 43; // LB
					else if (floors.getTile(_x + 1, _y) >= 24 && floors.getTile(_x, _y + 1) >= 24)
						wallArray[_y * floors.widthInTiles + _x] = 41; // RB
					else if (floors.getTile(_x + 1, _y) >= 24 && floors.getTile(_x, _y - 1) >= 24)
						wallArray[_y * floors.widthInTiles + _x] = 40; // RT
					else if (floors.getTile(_x, _y - 1) >= 24)
						wallArray[_y * floors.widthInTiles + _x] = 32; // T
					else if (floors.getTile(_x, _y + 1) >= 24)
						wallArray[_y * floors.widthInTiles + _x] = 33; // B
					else if (floors.getTile(_x + 1, _y) >= 24)
						wallArray[_y * floors.widthInTiles + _x] = 34; // R
					else if (floors.getTile(_x - 1, _y) >= 24)
						wallArray[_y * floors.widthInTiles + _x] = 35; // L
					else if (floors.getTile(_x - 1, _y - 1) >= 24
						|| floors.getTile(_x - 1, _y + 1) >= 24
						|| floors.getTile(_x + 1, _y - 1) >= 24
						|| floors.getTile(_x + 1, _y + 1) >= 24)
						wallArray[_y * floors.widthInTiles + _x] = 36;
				}
			}
		}

		walls.loadMapFromArray(wallArray, floors.widthInTiles, floors.heightInTiles, "assets/images/mmo/sprites.png", 8, 8);

		// Generate floors under the walls
		for (_y in 0...floors.heightInTiles)
		{
			for (_x in 0...floors.widthInTiles)
			{
				if (_x > 0 && _y > 0 && _x < floors.widthInTiles - 1 && _y < floors.heightInTiles - 1 && floors.getTile(_x, _y) <= 0)
				{
					switch (walls.getTile(_x, _y))
					{
						case 37:
							floors.setTile(_x, _y, Math.floor((floors.getTile(_x - 1, _y) + floors.getTile(_x + 1, _y)) / 2));
						case 38:
							floors.setTile(_x, _y, Math.floor((floors.getTile(_x, _y - 1) + floors.getTile(_x, _y + 1)) / 2));
						case 42:
							floors.setTile(_x, _y, Math.floor((floors.getTile(_x - 1, _y) + floors.getTile(_x, _y - 1)) / 2));
						case 43:
							floors.setTile(_x, _y, Math.floor((floors.getTile(_x - 1, _y) + floors.getTile(_x, _y + 1)) / 2));
						case 41:
							floors.setTile(_x, _y, Math.floor((floors.getTile(_x, _y + 1) + floors.getTile(_x + 1, _y)) / 2));
						case 40:
							floors.setTile(_x, _y, Math.floor((floors.getTile(_x, _y - 1) + floors.getTile(_x + 1, _y)) / 2));
						case 32:
							floors.setTile(_x, _y, floors.getTile(_x, _y - 1));
						case 33:
							floors.setTile(_x, _y, floors.getTile(_x, _y + 1));
						case 34:
							floors.setTile(_x, _y, floors.getTile(_x + 1, _y));
						case 35:
							floors.setTile(_x, _y, floors.getTile(_x - 1, _y));
					}
				}
			}
		}
	}

	public function getFloorsMap():FlxTilemap
	{
		return floors;
	}

	public function getWallsMap():FlxTilemap
	{
		return walls;
	}
}
