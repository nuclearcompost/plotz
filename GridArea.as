package
{
	//-----------------------
	//Purpose:				A rectangular area of grid squares
	//
	//Properties:
	//	
	//Methods:
	//	
	//Extended By:
	//	Farm
	//	Town
	//-----------------------
	public class GridArea
	{
		// Constants //
		
		//- Constants -//
		
		
		// Public Properties //
		
		public function get bottom():int
		{
			return _bottom;
		}
		
		public function set bottom(value:int):void
		{
			_bottom = value;
		}
		
		public function get left():int
		{
			return _left;
		}
		
		public function set left(value:int):void
		{
			_left = value;
		}
		
		public function get right():int
		{
			return _right;
		}
		
		public function set right(value:int):void
		{
			_right = value;
		}
		
		public function get top():int
		{
			return _top;
		}
		
		public function set top(value:int):void
		{
			_top = value;
		}
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		private var _bottom:int;
		private var _left:int;
		private var _right:int;
		private var _top:int;
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function GridArea(top:int = 0, bottom:int = 0, left:int = 0, right:int = 0)
		{
			_top = top;
			_bottom = bottom;
			_left = left;
			_right = right;
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		public static function IsLocationInGridArea(location:GridLocation, area:GridArea):Boolean
		{
			if (location == null)
			{
				return false;
			}
			
			if (area == null)
			{
				return false;
			}
			
			if (location.x >= area.left && location.x <= area.right && location.y >= area.top && location.y <= area.bottom)
			{
				return true;
			}
			
			return false;
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		//- Private Methods -//
		
		
		// Testing Methods //
		
		public static function RunTests():Array
		{
			var lResults:Array = new Array();
			
			lResults.push(GridArea.IsLocationInGridAreaFalseForNoLocation());
			lResults.push(GridArea.IsLocationInGridAreaFalseForNoArea());
			lResults.push(GridArea.IsLocationInGridAreaTrue());
			lResults.push(GridArea.IsLocationInGridAreaFalse());
			
			return lResults;
		}
		
		private static function IsLocationInGridAreaFalseForNoLocation():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("GridArea", "IsLocationInGridAreaFalseForNoLocation");
			
			var oLocation:GridLocation = null;
			var oGridArea:GridArea = new GridArea();
			
			oResult.TestFalse(GridArea.IsLocationInGridArea(oLocation, oGridArea));
			
			return oResult;
		}
		
		private static function IsLocationInGridAreaFalseForNoArea():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("GridArea", "IsLocationInGridAreaFalseForNoArea");
			
			var oLocation:GridLocation = new GridLocation();
			var oGridArea:GridArea = null;
			
			oResult.TestFalse(GridArea.IsLocationInGridArea(oLocation, oGridArea));
			
			return oResult;
		}
		
		private static function IsLocationInGridAreaTrue():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("GridArea", "IsLocationInGridAreaTrue");
			
			var oLocation:GridLocation = new GridLocation(2, 3);
			var oGridArea:GridArea = new GridArea(1, 4, 1, 6);
			
			oResult.TestTrue(GridArea.IsLocationInGridArea(oLocation, oGridArea));
			
			return oResult;
		}
		
		private static function IsLocationInGridAreaFalse():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("GridArea", "IsLocationInGridAreaFalse");
			
			var oLocation:GridLocation = new GridLocation(0, 0);
			var oGridArea:GridArea = new GridArea(1, 4, 1, 6);
			
			oResult.TestFalse(GridArea.IsLocationInGridArea(oLocation, oGridArea));
			
			return oResult;
		}
		
		//- Testing Methods -//
	}
}