package
{
	//-----------------------
	//Purpose:				Represents the *physical* world of soil, plants, buildings, etc... DON'T get carried away and turn this into GameSession 2.0.
	//
	//Public Properties:
	//	
	//Public Methods:
	//	
	//-----------------------
	public class World
	{
		// Constants //
				
		//- Constants -//
		
		
		// Public Properties //
		
		public function get farms():Array
		{
			return _farms;
		}
		
		public function set farms(value:Array):void
		{
			_farms = value;
		}
		
		public function get height():int
		{
			return _height;
		}
		
		public function set height(value:int):void
		{
			_height = value;
		}
		
		public function get horizon():Horizon
		{
			return _horizon;
		}
		
		public function set horizon(value:Horizon):void
		{
			_horizon = value;
		}
		
		public function get rectangleHeight():int
		{
			return _rectangleHeight;
		}
		
		public function set rectangleHeight(value:int):void
		{
			_rectangleHeight = value;
		}
		
		public function get rectangleWidth():int
		{
			return _rectangleWidth;
		}
		
		public function set rectangleWidth(value:int):void
		{
			_rectangleWidth = value;
		}
		
		public function get tiles():Array
		{
			return _tiles;
		}
		
		public function set tiles(value:Array):void
		{
			_tiles = value;
		}
		
		public function get towns():Array
		{
			return _towns;
		}
		
		public function set towns(value:Array):void
		{
			_towns = value;
		}
		
		public function get weather():Weather
		{
			return _weather;
		}
		
		public function set weather(value:Weather):void
		{
			_weather = value;
		}
		
		public function get width():int
		{
			return _width;
		}
		
		public function set width(value:int):void
		{
			_width = value;
		}
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		private var _farms:Array;
		private var _height:int;
		private var _horizon:Horizon;
		private var _rectangleHeight:int;
		private var _rectangleWidth:int;
		private var _tiles:Array;
		private var _towns:Array;
		private var _weather:Weather;
		private var _width:int;
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function World(rectangleWidth:int = 1, rectangleHeight:int = 1, tiles:Array = null, farms:Array = null, towns:Array = null, weather:Weather = null, horizon:Horizon = null)
		{
			_rectangleWidth = rectangleWidth;
			_rectangleHeight = rectangleHeight;
			_weather = weather;
			_horizon = horizon;
			
			var iMin:int = int(Math.min(_rectangleWidth, _rectangleHeight));
			var iMax:int = int(Math.max(_rectangleWidth, _rectangleHeight));
			var iDiff:int = iMax - iMin;
			_width = (iMin * 2) - 1;
			
			if (_width < 0)
			{
				_width = 0;
			}
			
			_width += iDiff;
			_height = _width;
			
			_tiles = new Array(_width);
			for (var i:int = 0; i < _tiles.length; i++)
			{
				_tiles[i] = new Array(_height);
				
				for (var j:int = 0; j < _tiles[i].length; j++)
				{
					_tiles[i][j] = null;
				}
			}
			
			World.InitializeTiles(_tiles, _rectangleWidth, _rectangleHeight);
			
			if (_farms == null)
			{
				_farms = new Array();
			}
			else
			{
				for (i = 0; i < _farms.length; i++)
				{
					var oFarm:Farm = Farm(_farms[i]);
					AddFarm(oFarm);
				}
			}
			
			if (_towns == null)
			{
				_towns = new Array();
			}
			else
			{
				for (i = 0; i < _towns.length; i++)
				{
					var oTown:Town = Town(_towns[i]);
					AddTown(oTown);
				}
			}
		}
		
		private static function InitializeTiles(tiles:Array, rectangleWidth:int, rectangleHeight:int):void
		{
			var iRectangleHeight:int = rectangleHeight - 1;
			var iRectangleWidth:int = rectangleWidth - 1;
			var iIsometricSize:int = tiles.length - 1;
			
			var iLineStart:GridLocation = new GridLocation(iRectangleHeight, 0);
			var iLineEnd:GridLocation = new GridLocation(iIsometricSize, iRectangleWidth);
			var iFinalStart:GridLocation = new GridLocation(0, iRectangleHeight);
			var iFinalEnd:GridLocation = new GridLocation(iRectangleWidth, iIsometricSize);
			
			while (true)
			{
				// run the current line
				InitializeTileLine(tiles, iLineStart, iLineEnd);
				
				// stop if we've run the final line
				if (iLineStart.IsSameAs(iFinalStart) && iLineEnd.IsSameAs(iFinalEnd))
				{
					break;
				}
				
				// run the "inner" line
				iLineStart.y++;
				iLineEnd.x--;
				
				InitializeTileLine(tiles, iLineStart, iLineEnd);
				
				// advance to the next line
				iLineStart.x--;
				iLineEnd.y++;
			}
		}
		
		private static function InitializeTileLine(tiles:Array, start:GridLocation, end:GridLocation):void
		{
			var oLocation:GridLocation = new GridLocation(start.x, start.y);
			
			while (true)
			{
				tiles[oLocation.x][oLocation.y] = new Tile(null, null, null, new Plant(Plant.TYPE_WILD_GRASS, Plant.STAGE_MATURE), null, new Soil(Substrate.TYPE_LOAM), null);
				
				if (oLocation.IsSameAs(end))
				{
					break;
				}
				
				oLocation.x++;
				oLocation.y++;
			}
		}
		
		//- Initialization -//
		
		
		// Public Methods //
		
		public function AddBldg(bldg:Bldg):void
		{
			if (bldg == null)
			{
				return;
			}
			
			// bldg base
			var iStartX:int = bldg.origin.x;
			var iEndX:int = bldg.origin.x + bldg.gridWidth - 1;
			var iStartY:int = bldg.origin.y - bldg.gridHeight + 1;
			var iEndY:int = bldg.origin.y;
			
			for (var x:int = iStartX; x <= iEndX; x++)
			{
				for (var y:int = iStartY; y <= iEndY; y++)
				{
					var oTile:Tile = Tile(_tiles[x][y]);
					
					if (oTile != null)
					{
						SetTileBldgValue(oTile, Tile.SECTION_LEFT_HALF, bldg);
						SetTileBldgValue(oTile, Tile.SECTION_RIGHT_HALF, bldg);
					}
				}
			}
			
			if (bldg.gridDepth == 0)
			{
				return;
			}
			
			// bldg depth
			var oRightHalf:GridLocation = new GridLocation(bldg.origin.x, bldg.origin.y - bldg.gridHeight);
			var oLeftHalf:GridLocation = new GridLocation(bldg.origin.x + bldg.gridWidth, bldg.origin.y);
			var lInteriorTiles:Array = new Array();
			
			var oInteriorLocation:GridLocation = new GridLocation(bldg.origin.x + 1, bldg.origin.y - bldg.gridHeight);
			
			for (var i:int = 0; i < bldg.gridWidth; i++)
			{
				lInteriorTiles.push(new GridLocation(oInteriorLocation.x, oInteriorLocation.y));
				
				oInteriorLocation.x++;
			}
			
			oInteriorLocation = new GridLocation(bldg.origin.x + bldg.gridWidth, bldg.origin.y - (bldg.gridHeight - 1));
			
			for (i = 0; i < (bldg.gridHeight - 1); i++)
			{
				lInteriorTiles.push(new GridLocation(oInteriorLocation.x, oInteriorLocation.y));
				
				oInteriorLocation.y++;
			}
			
			for (var z:int = 0; z < bldg.gridDepth; z++)
			{
				// right 1/2 tile
				oTile = Tile(_tiles[oRightHalf.x][oRightHalf.y]);
				SetTileBldgValue(oTile, Tile.SECTION_RIGHT_HALF, bldg);
				
				oRightHalf.x++;
				oRightHalf.y--;
				
				// left 1/2 tile
				oTile = Tile(_tiles[oLeftHalf.x][oLeftHalf.y]);
				SetTileBldgValue(oTile, Tile.SECTION_LEFT_HALF, bldg);
				
				oLeftHalf.x++;
				oLeftHalf.y--;
				
				// interior tiles
				for (i = 0; i < lInteriorTiles.length; i++)
				{
					oInteriorLocation = GridLocation(lInteriorTiles[i]);
					oTile = Tile(_tiles[oInteriorLocation.x][oInteriorLocation.y]);
					SetTileBldgValue(oTile, Tile.SECTION_LEFT_HALF, bldg);
					SetTileBldgValue(oTile, Tile.SECTION_RIGHT_HALF, bldg);
					
					oInteriorLocation.x++;
					oInteriorLocation.y--;
				}
			}
		}
		
		public function AddFarm(farm:Farm):void
		{
			_farms.push(farm);
		}
		
		public function AddTown(town:Town):void
		{
			_towns.push(town);
			
			for (var x:int = town.left; x <= town.right; x++)
			{
				for (var y:int = town.top; y <= town.bottom; y++)
				{
					var oTile:Tile = Tile(_tiles[x][y]);
					
					if (oTile != null)
					{
						oTile.terrain = new Terrain(Terrain.TYPE_PAVEMENT);
					}
				}
			}
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		private function IsBldgInFrontOfOtherBldg(bldg:Bldg, otherBldg:Bldg):Boolean
		{
			if (bldg == null || otherBldg == null)
			{
				return false;
			}
			
			if (bldg.origin.x > otherBldg.origin.x)
			{
				return false;
			}
			
			if (bldg.origin.y < otherBldg.origin.y)
			{
				return false;
			}
			
			return true;
		}
		
		private function SetTileBldgValue(tile:Tile, section:int, bldg:Bldg):void
		{
			if (section == Tile.SECTION_LEFT_HALF)
			{
				if (tile.leftBldgs.length == 0)
				{
					tile.leftBldgs.push(bldg);
				}
				else
				{
					var bInserted:Boolean = false;
					
					for (var i:int = 0; i < tile.leftBldgs.length; i++)
					{
						var oOtherBldg:Bldg = Bldg(tile.leftBldgs[i]);
						var bIsInFront:Boolean = IsBldgInFrontOfOtherBldg(bldg, oOtherBldg);
						
						if (bIsInFront == true)
						{
							bInserted = true;
							tile.leftBldgs.splice(i, 0, bldg);
							break;
						}
					}
					
					if (bInserted == false)
					{
						tile.leftBldgs.push(bldg);
					}
				}
			}
			else if (section == Tile.SECTION_RIGHT_HALF)
			{
				if (tile.rightBldgs.length == 0)
				{
					tile.rightBldgs.push(bldg);
				}
				else
				{
					bInserted = false;
					
					for (i = 0; i < tile.rightBldgs.length; i++)
					{
						oOtherBldg = Bldg(tile.rightBldgs[i]);
						bIsInFront = IsBldgInFrontOfOtherBldg(bldg, oOtherBldg);
						
						if (bIsInFront == true)
						{
							bInserted = true;
							tile.rightBldgs.splice(i, 0, bldg);
							break;
						}
					}
					
					if (bInserted == false)
					{
						tile.rightBldgs.push(bldg);
					}
				}
			}
		}
		
		//- Private Methods -//
		
		
		// Testing Methods //
		
		public static function RunTests():Array
		{
			var lResults:Array = new Array();
			
			lResults.push(World.TestAddFarm());
			lResults.push(World.TestAddTown());
			lResults = lResults.concat(AddTownAddsPavement());
			lResults = lResults.concat(World.InitializeTilesForSquareWorld());
			lResults = lResults.concat(World.InitializeTilesForHorizontalWorld());
			lResults = lResults.concat(World.InitializeTilesForVerticalWorld());
			
			return lResults;
		}
		
		private static function TestAddFarm():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("World", "TestAddFarm");
			var oWorld:World = new World(5, 6);
			var oFarm:Farm = new Farm("HappyFarm", null, oWorld, 5, 7, 2, 4);
			oWorld.AddFarm(oFarm);
			
			oResult.expected = "1";
			oResult.actual = String(oWorld.farms.length);
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function TestAddTown():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("World", "TestAddTown");
			var oWorld:World = new World(1, 1);
			var oTown:Town = new Town("HappyTown", oWorld, 0, 0, 0, 0);
			oWorld.AddTown(oTown);
			
			oResult.expected = "1";
			oResult.actual = String(oWorld.towns.length);
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function AddTownAddsPavement():Array
		{
			var oNotNullResult:UnitTestResult = new UnitTestResult("World", "AddTownAddsPavement - Pavement is not null");
			var oCorrectTypeResult:UnitTestResult = new UnitTestResult("World", "AddTownAddsPavement - Pavement is correct type");
			var lTests:Array = new Array();
			lTests[0] = oNotNullResult;
			lTests[1] = oCorrectTypeResult;
			
			var oWorld:World = new World(1, 1);
			var oTown:Town = new Town("HappyTown", oWorld, 0, 0, 0, 0);
			oWorld.AddTown(oTown);
			
			var oTile:Tile = Tile(oWorld.tiles[0][0]);
			var oTerrain:Terrain = oTile.terrain;
			oNotNullResult.TestNotNull(oTerrain);
			
			if (oNotNullResult.status == UnitTestResult.STATUS_PASS)
			{
				oCorrectTypeResult.expected = String(Terrain.TYPE_PAVEMENT);
				oCorrectTypeResult.actual = String(oTerrain.type);
				oCorrectTypeResult.TestEquals();
			}
			
			return lTests;
		}
		
		private static function InitializeTilesForSquareWorld():Array
		{
			var iSize:int = 5;
			var lTiles:Array = new Array(iSize);
			
			for (var x:int = 0; x < iSize; x++)
			{
				lTiles[x] = new Array(iSize);
			}
			
			World.InitializeTiles(lTiles, 3, 3);
			
			var lNotNull:Array = [ [ 0, 0, 1, 0, 0 ],
								   [ 0, 1, 1, 1, 0 ],
								   [ 1, 1, 1, 1, 1 ],
								   [ 0, 1, 1, 1, 0 ],
								   [ 0, 0, 1, 0, 0 ]
								 ];
			
			var lResults:Array = new Array();
			
			for (x = 0; x < lNotNull.length; x++)
			{
				for (var y:int = 0; y < lNotNull[x].length; y++)
				{
					var oResult:UnitTestResult = new UnitTestResult("World", "InitializeTilesForSquareWorld [" + x + "][" + y + "]");
					
					if (lNotNull[x][y] == 0)
					{
						oResult.TestNull(lTiles[x][y]);
					}
					else
					{
						oResult.TestNotNull(lTiles[x][y]);
					}
					
					lResults.push(oResult);
				}
			}
			
			return lResults;
		}
		
		private static function InitializeTilesForHorizontalWorld():Array
		{
			var iSize:int = 7;
			var lTiles:Array = new Array(iSize);
			
			for (var x:int = 0; x < iSize; x++)
			{
				lTiles[x] = new Array(iSize);
			}
			
			World.InitializeTiles(lTiles, 5, 3);
			
			var lNotNull:Array = [ [ 0, 0, 1, 0, 0, 0, 0 ],
								   [ 0, 1, 1, 1, 0, 0, 0 ],
								   [ 1, 1, 1, 1, 1, 0, 0 ],
								   [ 0, 1, 1, 1, 1, 1, 0 ],
								   [ 0, 0, 1, 1, 1, 1, 1 ],
								   [ 0, 0, 0, 1, 1, 1, 0 ],
								   [ 0, 0, 0, 0, 1, 0, 0 ]
								 ];
			
			var lResults:Array = new Array();
			
			for (x = 0; x < lNotNull.length; x++)
			{
				for (var y:int = 0; y < lNotNull[x].length; y++)
				{
					var oResult:UnitTestResult = new UnitTestResult("World", "InitializeTilesForHorizontalWorld [" + x + "][" + y + "]");
					
					if (lNotNull[x][y] == 0)
					{
						oResult.TestNull(lTiles[x][y]);
					}
					else
					{
						oResult.TestNotNull(lTiles[x][y]);
					}
					
					lResults.push(oResult);
				}
			}
			
			return lResults;
		}
		
		private static function InitializeTilesForVerticalWorld():Array
		{
			var iSize:int = 7;
			var lTiles:Array = new Array(iSize);
			
			for (var x:int = 0; x < iSize; x++)
			{
				lTiles[x] = new Array(iSize);
			}
			
			World.InitializeTiles(lTiles, 3, 5);
			
			var lNotNull:Array = [ [ 0, 0, 0, 0, 1, 0, 0 ],
								   [ 0, 0, 0, 1, 1, 1, 0 ],
								   [ 0, 0, 1, 1, 1, 1, 1 ],
								   [ 0, 1, 1, 1, 1, 1, 0 ],
								   [ 1, 1, 1, 1, 1, 0, 0 ],
								   [ 0, 1, 1, 1, 0, 0, 0 ],
								   [ 0, 0, 1, 0, 0, 0, 0 ]
								 ];
			
			var lResults:Array = new Array();
			
			for (x = 0; x < lNotNull.length; x++)
			{
				for (var y:int = 0; y < lNotNull[x].length; y++)
				{
					var oResult:UnitTestResult = new UnitTestResult("World", "InitializeTilesForVerticalWorld [" + x + "][" + y + "]");
					
					if (lNotNull[x][y] == 0)
					{
						oResult.TestNull(lTiles[x][y]);
					}
					else
					{
						oResult.TestNotNull(lTiles[x][y]);
					}
					
					lResults.push(oResult);
				}
			}
			
			return lResults;
		}
		
		//- Testing Methods -//
	}
}