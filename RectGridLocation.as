package
{
	//-----------------------
	//Purpose:				A location on the main grid from the rectangular perspective
	//
	//Public Properties:
	//	
	//Public Methods:
	//	
	//-----------------------
	public class RectGridLocation
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
		public function RectGridLocation(x:Number = 0, y:Number = 0)
		{
			_x = x;
			_y = y;
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		public function IsSameAs(other:RectGridLocation):Boolean
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
				if (!(list[i] is RectGridLocation))
				{
					continue;
				}
				
				var oRectGridLocation:RectGridLocation = RectGridLocation(list[i]);
				
				if (sText != "[ ")
				{
					sText += ", ";
				}
				
				sText += oRectGridLocation.PrettyPrint();
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
			lResults[lResults.length] = RectGridLocation.TestPrettyPrint();
			lResults[lResults.length] = RectGridLocation.TestPrettyPrintList();
			
			return lResults;
		}
		
		public static function TestPrettyPrint():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("RectGridLocation", "TestPrettyPrint");
			
			var oRectGridLocation:RectGridLocation = new RectGridLocation(5, 10);
			var sExpected:String = "(5, 10)";
			var sActual:String = oRectGridLocation.PrettyPrint();
			
			oResult.expected = sExpected;
			oResult.actual = sActual;
			oResult.TestEquals();
			
			return oResult;
		}
		
		public static function TestPrettyPrintList():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("RectGridLocation", "TestPrettyPrintList");
			
			var lData:Array = [ new RectGridLocation(1, 2), new RectGridLocation(5, 10) ];
			var sExpected:String = "[ (1, 2), (5, 10) ]";
			var sActual:String = RectGridLocation.PrettyPrintList(lData);
			
			oResult.expected = sExpected;
			oResult.actual = sActual;
			oResult.TestEquals();
			
			return oResult;
		}
		
		//- Test Methods -//
	}
}