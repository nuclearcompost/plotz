package
{
	//-----------------------
	//Purpose:				
	//Public Properties:
	//	
	//Public Methods:
	//	
	//-----------------------
	public class GridUtil
	{
		// Constants //
		
		//- Constants -//
		
		
		// Public Properties //
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		//- Private Properties -//
		
	
		// Initialization //
		
		//---------------
		//Purpose:		
		//Parameters:
		//	
		//Returns:		
		//---------------
		public function GridUtil()
		{
			
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		public static function GetGridSpotsAtRange(grid:Array, centerX:int, centerY:int, size:int):Array
		{
			var lGridSpots:Array = new Array();
			
			var iSide:int = 0;
			var lXMod:Array = [ 1, -1, -1, 1 ];
			var lYMod:Array = [ 1, 1, -1, -1 ];
			var bKeepGoing:Boolean = true;
			
			var iX:int = centerX;
			var iY:int = centerY - size;
			
			while (bKeepGoing == true)
			{
				// add valid spots to the list
				if (GridUtil.IsValidTile(grid, new GridLocation(iX, iY)) == true)
				{
					lGridSpots[lGridSpots.length] = new GridLocation(iX, iY);
				}
				
				// when we hit an edge of the side, go on to the next side
				if ((iX == centerX + size && iY == centerY) ||
					(iX == centerX && iY == centerY + size) ||
					(iX == centerX - size && iY == centerY))
				{
					iSide++;
				}
				
				// go to the next spot
				iX += lXMod[iSide];
				iY += lYMod[iSide];
				
				// if we've hit the start spot again, we're done
				if (iX == centerX && iY == (centerY - size))
				{
					bKeepGoing = false;
				}
			}
			
			return lGridSpots;
		}
		
		public static function GetGridSideSpotsAtRange(grid:Array, centerX:int, centerY:int, size:int, side:int):Array
		{
			var lGridSpots:Array = new Array();
			
			var lXMod:Array = [ 1, -1, -1, 1 ];
			var lYMod:Array = [ 1, 1, -1, -1 ];
			
			if (side == 1)
			{
				var oStart:GridLocation = new GridLocation(centerX, centerY - size);
				var oEnd:GridLocation = new GridLocation(centerX + size, centerY);
			}
			else if (side == 2)
			{
				oStart = new GridLocation(centerX + size, centerY);
				oEnd = new GridLocation(centerX, centerY + size);
			}
			else if (side == 3)
			{
				oStart = new GridLocation(centerX, centerY + size);
				oEnd = new GridLocation(centerX - size, centerY);
			}
			else if (side == 4)
			{
				oStart = new GridLocation(centerX - size, centerY);
				oEnd = new GridLocation(centerX, centerY - size);
			}			
			
			var iX:int = oStart.x;
			var iY:int = oStart.y;
			
			while (true)
			{
				// add valid spots to the list
				if (GridUtil.IsValidTile(grid, new GridLocation(iX, iY)) == true)
				{
					lGridSpots[lGridSpots.length] = new GridLocation(iX, iY);
				}
				
				// if we added the end location, we're done
				if (iX == oEnd.x && iY == oEnd.y)
				{
					break;
				}
				
				// go to the next spot
				iX += lXMod[side - 1];
				iY += lYMod[side - 1];
			}
			
			return lGridSpots;
		}
		
		public static function IsValidTile(grid:Array, location:GridLocation):Boolean
		{
			if (grid == null || location == null)
			{
				return false;
			}
			
			if (location.x < 0 || location.x >= grid.length || location.y < 0 || location.y >= grid[location.x].length)
			{
				return false;
			}
			
			var oTile:Tile = Tile(grid[location.x][location.y]);
			
			if (oTile == null)
			{
				return false;
			}
			
			return true;
		}
		
		//- Public Methods -//
		

		// Private Methods //
		
		//- Private Methods -//
		
		
		// Testing Methods //
		
		public static function RunTests():Array
		{
			var lResults:Array = new Array();
			
			lResults.push(GridUtil.TestGetGridSideSpotsAtRange());
			lResults.push(GridUtil.IsValidTileFalseIfGridNull());
			lResults.push(GridUtil.IsValidTileFalseIfLocationNull());
			lResults.push(GridUtil.IsValidTileFalseIfTileNull());
			lResults.push(GridUtil.IsValidTileTrueIfTileNotNull());
			
			return lResults;
		}
		
		private static function TestGetGridSideSpotsAtRange():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("GridUtil", "TestGetGridSideSpotsAtRange");
			var iCenterX:int = 5;
			var iCenterY:int = 6;
			var iSize:int = 2;
			var iSide:int = 1;
			
			var lGrid:Array = new Array(8);
			for (var i:int = 0; i < lGrid.length; i++)
			{
				lGrid[i] = new Array(8);
				
				for (var j:int = 0; j < lGrid[i].length; j++)
				{
					lGrid[i][j] = new Tile();
				}
			}
			
			var lExpectedList:Array = [ new GridLocation(5, 4), new GridLocation(6, 5), new GridLocation(7, 6) ];
			oResult.expected = GridLocation.PrettyPrintList(lExpectedList);
			
			var lActualData:Array = GridUtil.GetGridSideSpotsAtRange(lGrid, iCenterX, iCenterY, iSize, iSide);
			oResult.actual = GridLocation.PrettyPrintList(lActualData);
			
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function IsValidTileFalseIfGridNull():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("GridUtil", "IsValidTileFalseIfGridNull");
			var oGrid:Array = null;
			var oLocation:GridLocation = new GridLocation(0, 0);
			
			oResult.TestFalse(GridUtil.IsValidTile(oGrid, oLocation));
			
			return oResult;
		}
		
		private static function IsValidTileFalseIfLocationNull():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("GridUtil", "IsValidTileFalseIfLocationNull");
			var oGrid:Array = new Array();
			var oLocation:GridLocation = null;
			
			oResult.TestFalse(GridUtil.IsValidTile(oGrid, oLocation));
			
			return oResult;
		}
		
		private static function IsValidTileFalseIfTileNull():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("GridUtil", "IsValidTileFalseIfTileNull");
			var oGrid:Array = [ [ null, null ], [ null, null ] ];
			var oLocation:GridLocation = new GridLocation(0, 1);
			
			oResult.TestFalse(GridUtil.IsValidTile(oGrid, oLocation));
			
			return oResult;
		}
		
		private static function IsValidTileTrueIfTileNotNull():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("GridUtil", "IsValidTileTrueIfTileNotNull");
			var oGrid:Array = [ [ null, new Tile() ], [ null, null ] ];
			var oLocation:GridLocation = new GridLocation(0, 1);
			
			oResult.TestTrue(GridUtil.IsValidTile(oGrid, oLocation));
			
			return oResult;
		}
		
		/*
		private static function ():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("GridUtil", "");
			
			return oResult;
		}
		*/
		//- Testing Methods -//
	}
}