package
{
	//-----------------------
	//Purpose:				A location on the main grid from the isometric perspective
	//
	//Public Properties:
	//	
	//Public Methods:
	//	
	//-----------------------
	public class GridLocation
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
		public function GridLocation(x:Number = 0, y:Number = 0)
		{
			_x = x;
			_y = y;
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		public function GetPixelLocation():PixelLocation
		{
			var nX:Number = (_y + _x) * UIManager.TILE_PIXEL_HALF_WIDTH;
			var nY:Number = (_y - _x) * UIManager.TILE_PIXEL_HALF_HEIGHT;
			var oDrawCenter:PixelLocation = new PixelLocation(nX, nY);
			
			return oDrawCenter;
		}

		public function IsSameAs(other:GridLocation):Boolean
		{
			if (other == null)
			{
				return false;
			}
			
			if (_x == other.x && _y == other.y)
			{
				return true;
			}
			
			return false;
		}

		public function PrettyPrint():String
		{
			var sText:String = "(" + _x + ", " + _y + ")";
			return sText;
		}
		
		public static function PrettyPrintList(list:Array):String
		{
			var sText:String = "[ ";
			
			for (var i:int = 0; i < list.length; i++)
			{
				if (!(list[i] is GridLocation))
				{
					continue;
				}
				
				var oGridLocation:GridLocation = GridLocation(list[i]);
				
				if (sText != "[ ")
				{
					sText += ", ";
				}
				
				sText += oGridLocation.PrettyPrint();
			}
			
			sText += " ]";
			
			return sText;
		}
		
		//- Public Methods -//
		
		
		// Protected Methods //
		
		//- Protected Methods -//
		
		
		// Test Methods //
		
		public static function RunTests():Array
		{
			var lResults:Array = new Array();
			lResults[lResults.length] = GridLocation.TestPrettyPrint();
			lResults[lResults.length] = GridLocation.TestPrettyPrintList();
			
			return lResults;
		}
		
		public static function TestPrettyPrint():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("GridLocation", "TestPrettyPrint");
			
			var oGridLocation:GridLocation = new GridLocation(5, 10);
			var sExpected:String = "(5, 10)";
			var sActual:String = oGridLocation.PrettyPrint();
			
			oResult.expected = sExpected;
			oResult.actual = sActual;
			oResult.TestEquals();
			
			return oResult;
		}
		
		public static function TestPrettyPrintList():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("GridLocation", "TestPrettyPrintList");
			
			var lData:Array = [ new GridLocation(1, 2), new GridLocation(5, 10) ];
			var sExpected:String = "[ (1, 2), (5, 10) ]";
			var sActual:String = GridLocation.PrettyPrintList(lData);
			
			oResult.expected = sExpected;
			oResult.actual = sActual;
			oResult.TestEquals();
			
			return oResult;
		}
		
		//- Test Methods -//
	}
}