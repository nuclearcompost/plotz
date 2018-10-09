package
{
	//-----------------------
	//Purpose:				A pixel location on the screen
	//
	//Public Properties:
	//	
	//Public Methods:
	//	
	//-----------------------
	public class PixelLocation
	{
		// Constants //
		
		//- Constants -//
		
		
		// Public Properties //
		
		public function get x():Number
		{
			return _x;
		}
		
		public function set x(value:Number):void
		{
			_x = value;
		}
		
		public function get y():Number
		{
			return _y;
		}
		
		public function set y(value:Number):void
		{
			_y = value;
		}
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		private var _x:Number;
		private var _y:Number;
		
		//- Private Properties -//
		
	
		// Initialization //
		
		//---------------
		//Purpose:		
		//Parameters:
		//	
		//Returns:		
		//---------------
		public function PixelLocation(x:Number = 0, y:Number = 0)
		{
			_x = x;
			_y = y;
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		public static function GetPointAtDistanceInDirection(location:PixelLocation, distance:Number, direction:Number):PixelLocation
		{
			var oNewPoint:PixelLocation = new PixelLocation(0, 0);
			var nFacingRadians:Number = (direction) * (Math.PI / 180.0);
			
			oNewPoint.x = location.x + (Math.cos(nFacingRadians) * distance);
			oNewPoint.y = location.y + (Math.sin(nFacingRadians) * distance);
			
			return oNewPoint;
		}
		
		public function GetFooterLocation():FooterLocation
		{
			var oFooter:FooterLocation = new FooterLocation(-1, -1);
			
			var iX:int = Math.floor((_x - UIManager.FOOTER_X_PIXEL_OFFSET) / UIManager.FOOTER_PIXEL_WIDTH);
			var iY:int = Math.floor((_y - UIManager.FOOTER_Y_PIXEL_OFFSET) / UIManager.FOOTER_PIXEL_HEIGHT);
			
			if (iX >= 0 && iX <= Footer.MAX_X && iY >= 0 && iY <= Footer.MAX_Y)
			{
				oFooter = new FooterLocation(iX, iY);
			}
			
			return oFooter;
		}
		
		public function GetGridLocation():GridLocation
		{
			var oCenterPoint:PixelLocation = PixelLocation.GetCentralTileCoordsForDrawPoint(new PixelLocation(_x, _y));
			var oGridLocation:GridLocation = PixelLocation.GetTileForDrawPoint(new PixelLocation(_x, _y), new PixelLocation(oCenterPoint.x, oCenterPoint.y));
			
			return oGridLocation;
		}
		
		public function PrettyPrint():String
		{
			var sPrint:String = "(" + _x + ", " + _y + ")";
			
			return sPrint;
		}
		
		public static function PrettyPrintList(pointList:Array):String
		{
			if (pointList == null)
			{
				return "";
			}
			
			var sPrint:String = "";
			
			for (var i:int = 0; i < pointList.length; i++)
			{
				if (!(pointList[i] is PixelLocation))
				{
					continue;
				}
				
				var sNewPointString:String = pointList[i].PrettyPrint();
				
				if (sPrint == "")
				{
					sPrint = sNewPointString;
				}
				else
				{
					sPrint += (", " + sNewPointString);
				}
			}
			
			return sPrint;
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		// given a point from the drawing coordinate system, return the center drawing coordinates for the tile most centered around the given
		//  draw coordinates. The given drawing coordinate will either be on the tile who's center is returned or one of its four neighbors.
		private static function GetCentralTileCoordsForDrawPoint(drawPoint:PixelLocation):PixelLocation
		{
			var oCenterPoint:PixelLocation = null;
			
			// round the given drawing coord so it falls onto the grid of lines spaced HalfTileWidth x HalfTileHeight from the origin,
			//  rounding towards the origin.
			var oRoundPoint:PixelLocation = PixelLocation.GetRoundedDrawPoint(new PixelLocation(drawPoint.x, drawPoint.y));
			
			// if the rounded drawing coordinate is at a tile center, use that tile center
			if (PixelLocation.IsDrawPointAtTileCenter(new PixelLocation(oRoundPoint.x, oRoundPoint.y)) == true)
			{
				oCenterPoint = new PixelLocation(oRoundPoint.x, oRoundPoint.y);
			}
			// if the rounded drawing coordinate is at the intersection point of 4 tiles, get the tile center to the right
			else
			{
				oCenterPoint = new PixelLocation(oRoundPoint.x + UIManager.TILE_PIXEL_HALF_WIDTH, oRoundPoint.y);
			}
			
			return oCenterPoint;
		}
		
		/*
		private static function GetDrawCenterForTile(tileCoords:GridLocation):PixelLocation
		{
			var nX:Number = (tileCoords.y + tileCoords.x) * IsoTile.PIXEL_HALF_WIDTH;
			var nY:Number = (tileCoords.y - tileCoords.x) * IsoTile.PIXEL_HALF_HEIGHT;
			var oDrawCenter:Point2D = new Point2D(nX, nY);
			
			return oDrawCenter;
		}
		*/
		
		private static function GetTileCoordsForDrawCenter(drawCenter:PixelLocation):GridLocation
		{
			var nWidthSteps:Number = drawCenter.x / UIManager.TILE_PIXEL_HALF_WIDTH;
			var nHeightSteps:Number = drawCenter.y / UIManager.TILE_PIXEL_HALF_HEIGHT;
			
			var nX:Number = nWidthSteps - ((nWidthSteps + nHeightSteps) / 2);
			var nY:Number = (nWidthSteps + nHeightSteps) / 2;
			var oTileCoords:GridLocation = new GridLocation(nX, nY);
			
			return oTileCoords;
		}
		
		// round the given drawing coord so it falls onto the grid of lines spaced HalfTileWidth x HalfTileHeight from the origin,
		//  rounding towards the origin.
		private static function GetRoundedDrawPoint(drawPoint:PixelLocation):PixelLocation
		{
			var rX:Number = Math.floor(drawPoint.x / UIManager.TILE_PIXEL_HALF_WIDTH) * UIManager.TILE_PIXEL_HALF_WIDTH;
			var rY:Number = Math.floor(drawPoint.y / UIManager.TILE_PIXEL_HALF_HEIGHT) * UIManager.TILE_PIXEL_HALF_HEIGHT;
			var oRoundedPoint:PixelLocation = new PixelLocation(rX, rY);
			
			return oRoundedPoint;
		}
		
		// return true if the given drawing coord is at the center of an isometric tile
		private static function IsDrawPointAtTileCenter(drawPoint:PixelLocation):Boolean
		{
			var oTileCoord:GridLocation = PixelLocation.GetTileCoordsForDrawCenter(new PixelLocation(drawPoint.x, drawPoint.y));
			
			var bXIsCloseEnough:Boolean = false;
			
			if (Math.abs(oTileCoord.x - Math.floor(oTileCoord.x)) < 0.0001)
			{
				bXIsCloseEnough = true;
			}
			
			var bYIsCloseEnough:Boolean = false;
			
			if (Math.abs(oTileCoord.y - Math.floor(oTileCoord.y)) < 0.0001)
			{
				bYIsCloseEnough = true;
			}
			
			if (bXIsCloseEnough == true && bYIsCloseEnough == true)
			{
				return true;
			}
			
			return false;
		}
		
		// get the isometric tile coordinates for the given drawing coordinate. CenterPoint is the drawing coordinate of the center of the nearest tile.
		private static function GetTileForDrawPoint(drawPoint:PixelLocation, centerPoint:PixelLocation):GridLocation
		{
			var oTileCoords:GridLocation = PixelLocation.GetTileCoordsForDrawCenter(new PixelLocation(centerPoint.x, centerPoint.y));
			
			// left half
			if (drawPoint.x <= centerPoint.x)
			{
				// find the distance between the middle line of the tile and its top and bottom edges, for the given X
				var nVerticalDistance:Number = PixelLocation.GetVerticalDistanceFromPointToLineSegment(new PixelLocation(drawPoint.x, centerPoint.y),
																									   new PixelLocation(centerPoint.x - UIManager.TILE_PIXEL_HALF_WIDTH, centerPoint.y),
																								 	   new PixelLocation(centerPoint.x, centerPoint.y - UIManager.TILE_PIXEL_HALF_HEIGHT));
				
				// the y value of the top edge at the given x
				var nTopEdge:Number = centerPoint.y - nVerticalDistance;
				
				// the y value of the bottom edge at the given x
				var nBottomEdge:Number = centerPoint.y + nVerticalDistance;
				
				// now compare our given Y to the edges:
				if (drawPoint.y < nTopEdge)
				{
					oTileCoords.y--;
				}
				else if (drawPoint.y > nBottomEdge)
				{
					oTileCoords.x--;
				}
			}
			// right half
			else
			{
				// find the distance between the middle line of the tile and its top and bottom edges, for the given X
				nVerticalDistance = PixelLocation.GetVerticalDistanceFromPointToLineSegment(new PixelLocation(drawPoint.x, centerPoint.y),
																					  		new PixelLocation(centerPoint.x + UIManager.TILE_PIXEL_HALF_WIDTH, centerPoint.y),
																					  		new PixelLocation(centerPoint.x, centerPoint.y - UIManager.TILE_PIXEL_HALF_HEIGHT));
				
				// the y value of the top edge at the given x
				nTopEdge = centerPoint.y - nVerticalDistance;
				
				// the y value of the bottom edge at the given x
				nBottomEdge = centerPoint.y + nVerticalDistance;
				
				// now compare our given Y to the edges:
				if (drawPoint.y < nTopEdge)
				{
					oTileCoords.x++;
				}
				else if (drawPoint.y > nBottomEdge)
				{
					oTileCoords.y++;
				}
			}
			
			return oTileCoords;
		}
		
		// return the distance along the y-axis between the given point and a line containing 2 other given points
		private static function GetVerticalDistanceFromPointToLineSegment(point:PixelLocation, lineStart:PixelLocation, lineEnd:PixelLocation):Number
		{
			var nSlope:Number = (lineEnd.y - lineStart.y) / (lineEnd.x - lineStart.x);
			
			var nLineY:Number = (point.x * nSlope) - (lineStart.x * nSlope) + lineStart.y;
			
			var nVerticalDistance:Number = Math.abs(point.y - nLineY);
			
			return nVerticalDistance;
		}
		
		//- Private Methods -//
		
		
		// Testing Methods //
		
		public static function RunTests():Array
		{
			var lResults:Array = new Array();
			
			lResults.push(PixelLocation.TestPrettyPrint());
			//lResults = lResults.concat(PixelLocation.TestGetDrawCenterForTile());
			lResults = lResults.concat(PixelLocation.TestGetTileCoordsForDrawCenter());
			lResults.push(PixelLocation.PrettyPrintListEmptyForNull());
			lResults.push(PixelLocation.PrettyPrintListEmptyForEmptyList());
			lResults.push(PixelLocation.TestPrettyPrintList());
			lResults = lResults.concat(PixelLocation.TestGetCentralTileCoordsForDrawPoint());
			lResults.push(PixelLocation.GetRoundedDrawPointOffset());
			lResults.push(PixelLocation.GetRoundedDrawPointIncident());
			lResults.push(PixelLocation.IsDrawPointAtTileCenterTrue());
			lResults.push(PixelLocation.IsDrawPointAtTileCenterFalse());
			lResults.push(PixelLocation.GetTileForDrawPointULOut());
			lResults.push(PixelLocation.GetTileForDrawPointULIn());
			lResults.push(PixelLocation.GetTileForDrawPointUROut());
			lResults.push(PixelLocation.GetTileForDrawPointURIn());
			lResults.push(PixelLocation.GetTileForDrawPointLLOut());
			lResults.push(PixelLocation.GetTileForDrawPointLLIn());
			lResults.push(PixelLocation.GetTileForDrawPointLROut());
			lResults.push(PixelLocation.GetTileForDrawPointLRIn());
			lResults.push(PixelLocation.TestGetVerticalDistanceFromPointToLineSegment());
			
			return lResults;
		}
		
		private static function TestPrettyPrint():UnitTestResult
		{
			var lResult:UnitTestResult = new UnitTestResult("PixelLocation", "TestPrettyPrint");
			
			var oPoint:PixelLocation = new PixelLocation(1, 2);
			
			lResult.expected = "(1, 2)";
			lResult.actual = oPoint.PrettyPrint();
			lResult.TestEquals();
			
			return lResult;
		}
		
		/*
		private static function TestGetDrawCenterForTile():Array
		{
			var oResultZeroZero:UnitTestResult = new UnitTestResult("PixelLocation", "TestGetDrawCenterForTile (0, 0)");
			var oResultOneZero:UnitTestResult = new UnitTestResult("PixelLocation", "TestGetDrawCenterForTile (1, 0)");
			var oResultZeroOne:UnitTestResult = new UnitTestResult("PixelLocation", "TestGetDrawCenterForTile (0, 1)");
			var oResultThreeEight:UnitTestResult = new UnitTestResult("PixelLocation", "TestGetDrawCenterForTile (3, 8)");
			
			var lResults:Array = [oResultZeroZero, oResultOneZero, oResultZeroOne, oResultThreeEight ];
			
			oResultZeroZero.expected = "(0, 0)";
			oResultZeroZero.actual = Point2D.GetDrawCenterForTile(new Point2D(0, 0)).PrettyPrint();
			oResultZeroZero.TestEquals();
			
			oResultOneZero.expected = "(30, -15)";
			oResultOneZero.actual = Point2D.GetDrawCenterForTile(new Point2D(1, 0)).PrettyPrint();
			oResultOneZero.TestEquals();
			
			oResultZeroOne.expected = "(30, 15)";
			oResultZeroOne.actual = Point2D.GetDrawCenterForTile(new Point2D(0, 1)).PrettyPrint();
			oResultZeroOne.TestEquals();
			
			oResultThreeEight.expected = "(330, 75)";
			oResultThreeEight.actual = Point2D.GetDrawCenterForTile(new Point2D(3, 8)).PrettyPrint();
			oResultThreeEight.TestEquals();
			
			return lResults;
		}
		*/
		
		private static function TestGetTileCoordsForDrawCenter():Array
		{
			var oResultZeroZero:UnitTestResult = new UnitTestResult("PixelLocation", "TestGetTileCoordsForDrawCenter (0, 0)");
			var oResultOneZero:UnitTestResult = new UnitTestResult("PixelLocation", "TestGetTileCoordsForDrawCenter (1, 0)");
			var oResultZeroOne:UnitTestResult = new UnitTestResult("PixelLocation", "TestGetTileCoordsForDrawCenter (0, 1)");
			var oResultThreeEight:UnitTestResult = new UnitTestResult("PixelLocation", "TestGetTileCoordsForDrawCenter (3, 8)");
			
			var lResults:Array = [oResultZeroZero, oResultOneZero, oResultZeroOne, oResultThreeEight ];
			
			oResultZeroZero.expected = "(0, 0)";
			oResultZeroZero.actual = PixelLocation.GetTileCoordsForDrawCenter(new PixelLocation(0, 0)).PrettyPrint();
			oResultZeroZero.TestEquals();
			
			oResultOneZero.expected = "(1, 0)";
			oResultOneZero.actual = PixelLocation.GetTileCoordsForDrawCenter(new PixelLocation(30, -15)).PrettyPrint();
			oResultOneZero.TestEquals();
			
			oResultZeroOne.expected = "(0, 1)";
			oResultZeroOne.actual = PixelLocation.GetTileCoordsForDrawCenter(new PixelLocation(30, 15)).PrettyPrint();
			oResultZeroOne.TestEquals();
			
			oResultThreeEight.expected = "(3, 8)";
			oResultThreeEight.actual = PixelLocation.GetTileCoordsForDrawCenter(new PixelLocation(330, 75)).PrettyPrint();
			oResultThreeEight.TestEquals();
			
			return lResults;
		}
		
		private static function PrettyPrintListEmptyForNull():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("PixelLocation", "PrettyPrintListEmptyForNull");
			var lPoints:Array = null;
			
			oResult.expected = "";
			oResult.actual = PixelLocation.PrettyPrintList(lPoints);
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function PrettyPrintListEmptyForEmptyList():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("PixelLocation", "PrettyPrintListEmptyForEmptyList");
			var lPoints:Array = new Array();
			
			oResult.expected = "";
			oResult.actual = PixelLocation.PrettyPrintList(lPoints);
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function TestPrettyPrintList():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("PixelLocation", "TestPrettyPrintList");
			var lPoints:Array = [ "HI", new PixelLocation(2, 5), 5, new PixelLocation(1, 6) ];
			
			oResult.expected = "(2, 5), (1, 6)";
			oResult.actual = PixelLocation.PrettyPrintList(lPoints);
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function TestGetCentralTileCoordsForDrawPoint():Array
		{
			var oLeftResult:UnitTestResult = new UnitTestResult("PixelLocation", "GetCentralTileCoordsForDrawPoint - Left Test");
			var oRightResult:UnitTestResult = new UnitTestResult("PixelLocation", "GetCentralTileCoordsForDrawPoint - Right Test");
			var oIncidentResult:UnitTestResult = new UnitTestResult("PixelLocation", "GetCentralTileCoordsForDrawPoint - Incident Test");
			var lResults:Array = [ oLeftResult, oRightResult, oIncidentResult ];
			
			oLeftResult.expected = "(60, 0)";
			oLeftResult.actual = PixelLocation.GetCentralTileCoordsForDrawPoint(new PixelLocation(35, 10)).PrettyPrint();
			oLeftResult.TestEquals();
			
			oRightResult.expected = "(60, 0)";
			oRightResult.actual = PixelLocation.GetCentralTileCoordsForDrawPoint(new PixelLocation(65, 5)).PrettyPrint();
			oRightResult.TestEquals();
			
			oIncidentResult.expected = "(60, 0)";
			oIncidentResult.actual = PixelLocation.GetCentralTileCoordsForDrawPoint(new PixelLocation(60, 0)).PrettyPrint();
			oIncidentResult.TestEquals();
			
			return lResults;
		}
		
		private static function GetRoundedDrawPointOffset():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("PixelLocation", "GetRoundedDrawPointOffset");
			
			oResult.expected = "(30, 15)";
			oResult.actual = PixelLocation.GetRoundedDrawPoint(new PixelLocation(47, 18)).PrettyPrint();
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GetRoundedDrawPointIncident():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("PixelLocation", "GetRoundedDrawPointIncident");
			
			oResult.expected = "(30, 15)";
			oResult.actual = PixelLocation.GetRoundedDrawPoint(new PixelLocation(30, 15)).PrettyPrint();
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function IsDrawPointAtTileCenterTrue():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("PixelLocation", "IsDrawPointAtTileCenterTrue");
			
			oResult.TestTrue(PixelLocation.IsDrawPointAtTileCenter(new PixelLocation(30, 15)));
			
			return oResult;
		}
		
		private static function IsDrawPointAtTileCenterFalse():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("PixelLocation", "IsDrawPointAtTileCenterFalse");
			
			oResult.TestFalse(PixelLocation.IsDrawPointAtTileCenter(new PixelLocation(35, 17)));
			
			return oResult;
		}
		
		private static function GetTileForDrawPointULOut():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("PixelLocation", "GetTileForDrawPointULOut");
			
			oResult.expected = "(1, 1)";
			oResult.actual = PixelLocation.GetTileForDrawPoint(new PixelLocation(63, 3), new PixelLocation(90, 15)).PrettyPrint();
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GetTileForDrawPointULIn():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("PixelLocation", "GetTileForDrawPointULIn");
			
			oResult.expected = "(1, 2)";
			oResult.actual = PixelLocation.GetTileForDrawPoint(new PixelLocation(87, 12), new PixelLocation(90, 15)).PrettyPrint();
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GetTileForDrawPointUROut():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("PixelLocation", "GetTileForDrawPointUROut");
			
			oResult.expected = "(2, 2)";
			oResult.actual = PixelLocation.GetTileForDrawPoint(new PixelLocation(117, 3), new PixelLocation(90, 15)).PrettyPrint();
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GetTileForDrawPointURIn():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("PixelLocation", "GetTileForDrawPointURIn");
			
			oResult.expected = "(1, 2)";
			oResult.actual = PixelLocation.GetTileForDrawPoint(new PixelLocation(93, 12), new PixelLocation(90, 15)).PrettyPrint();
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GetTileForDrawPointLLOut():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("PixelLocation", "GetTileForDrawPointLLOut");
			
			oResult.expected = "(0, 2)";
			oResult.actual = PixelLocation.GetTileForDrawPoint(new PixelLocation(63, 27), new PixelLocation(90, 15)).PrettyPrint();
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GetTileForDrawPointLLIn():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("PixelLocation", "GetTileForDrawPointLLIn");
			
			oResult.expected = "(1, 2)";
			oResult.actual = PixelLocation.GetTileForDrawPoint(new PixelLocation(87, 18), new PixelLocation(90, 15)).PrettyPrint();
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GetTileForDrawPointLROut():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("PixelLocation", "GetTileForDrawPointLROut");
			
			oResult.expected = "(1, 3)";
			oResult.actual = PixelLocation.GetTileForDrawPoint(new PixelLocation(117, 27), new PixelLocation(90, 15)).PrettyPrint();
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GetTileForDrawPointLRIn():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("PixelLocation", "GetTileForDrawPointLRIn");
			
			oResult.expected = "(1, 2)";
			oResult.actual = PixelLocation.GetTileForDrawPoint(new PixelLocation(93, 18), new PixelLocation(90, 15)).PrettyPrint();
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function TestGetVerticalDistanceFromPointToLineSegment():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("PixelLocation", "TestGetVerticalDistanceFromPointToLineSegment");
			
			oResult.expected = "5";
			oResult.actual = String(PixelLocation.GetVerticalDistanceFromPointToLineSegment(new PixelLocation(90, 5), new PixelLocation(60, 15), new PixelLocation(90, 0)));
			oResult.TestEquals();
			
			return oResult;
		}
		
		//- Testing Methods -//
	}
}