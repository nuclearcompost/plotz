package
{
	//-----------------------
	//Purpose:				
	//Public Properties:
	//	
	//Public Methods:
	//	
	//-----------------------
	public class WellService
	{
		// Constants //
		
		private static const DAILY_AMOUNT:Array = [ 20 ];
		
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
		public function WellService()
		{
			
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		public static function AddDailyWellWater(well:Well):void
		{
			if (well != null)
			{
				well.AddWater(WellService.GetDailyAmount(well));
			}
		}
		
		public static function GetDailyAmount(well:Well):int
		{
			if (well == null)
			{
				return 0;
			}
			
			return WellService.DAILY_AMOUNT[well.upgradeLevel];
		}
		
		public static function RefillWateringCan(well:Well, wateringCan:Tool):void
		{
			if (well == null)
			{
				return;
			}
			
			if (wateringCan == null)
			{
				return;
			}
			
			if (wateringCan.type != Tool.TYPE_WATERING_CAN)
			{
				return;
			}
			
			var iNumCharges:int = wateringCan.maxCharges - wateringCan.charges;
			var iAmount:int = iNumCharges * Tool.WATER_PER_CHARGE;
			
			if (well.amount < iAmount)
			{
				iAmount = well.amount;
				
				// round amount down so it is a multiple of WATER_PER_CHARGE
				var iRemainder:int = iAmount % Tool.WATER_PER_CHARGE;
				iAmount -= iRemainder;
				
				// calculate final number of charges to take
				iNumCharges = iAmount / Tool.WATER_PER_CHARGE;								
			}
			
			well.amount -= iAmount;
			wateringCan.charges += iNumCharges;
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		//- Private Methods -//
		
		
		// Testing Methods //
		
		public static function RunTests():Array
		{
			var lResults:Array = new Array();
			
			lResults[lResults.length] = WellService.RefillWithNoWateringCanLeavesWellAmountSame();
			lResults = lResults.concat(WellService.RefillWateringCanToFull());
			lResults = lResults.concat(WellService.RefillWateringCanAsMuchAsPossible());
			lResults[lResults.length] = WellService.TestAddDailyWater();
			
			return lResults;
		}
		
		public static function RefillWithNoWateringCanLeavesWellAmountSame():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("WellService", "RefillWithNoWateringCanLeavesWellAmountSame");
			
			var oTool:Tool = new Tool(Tool.TYPE_HOE);
			var oWell:Well = new Well(new GridLocation(0, 0), null);
			
			var iExpected:int = oWell.amount;
			WellService.RefillWateringCan(oWell, oTool);
			var iActual:int = oWell.amount;
			
			oResult.expected = String(iExpected);
			oResult.actual = String(iActual);
			oResult.TestEquals();
			
			return oResult;
		}
		
		public static function RefillWateringCanToFull():Array
		{
			var oWellResult:UnitTestResult = new UnitTestResult("WellService", "RefillWateringCanToFull - Well");
			var oWateringCanResult:UnitTestResult = new UnitTestResult("WellService", "RefillWateringCanToFull - WateringCan");
			var lResults:Array = new Array();
			lResults[0] = oWellResult;
			lResults[1] = oWateringCanResult;
			
			var oTool:Tool = new Tool(Tool.TYPE_WATERING_CAN);
			var oWell:Well = new Well(new GridLocation(0, 0), null);
			
			oWellResult.expected = String(oWell.amount - ((oTool.maxCharges - oTool.charges) * Tool.WATER_PER_CHARGE));
			oWateringCanResult.expected = String(oTool.maxCharges);
			
			WellService.RefillWateringCan(oWell, oTool);
			
			oWellResult.actual = String(oWell.amount);
			oWateringCanResult.actual = String(oTool.charges);
			
			oWellResult.TestEquals();
			
			oWateringCanResult.TestEquals();
			
			return lResults;
		}
		
		public static function RefillWateringCanAsMuchAsPossible():Array
		{
			var oWellResult:UnitTestResult = new UnitTestResult("WellService", "RefillWateringCanAsMuchAsPossible - Well");
			var oWateringCanResult:UnitTestResult = new UnitTestResult("WellService", "RefillWateringCanAsMuchAsPossible - WateringCan");
			var lResults:Array = new Array();
			lResults[0] = oWellResult;
			lResults[1] = oWateringCanResult;
			
			var oTool:Tool = new Tool(Tool.TYPE_WATERING_CAN);
			var oWell:Well = new Well(new GridLocation(0, 0), null);
			oWell.amount = 10;
			oTool.charges = 0;
			
			oWellResult.expected = String(0);
			oWateringCanResult.expected = String(10 / Tool.WATER_PER_CHARGE);
			
			WellService.RefillWateringCan(oWell, oTool);
			
			oWellResult.actual = String(oWell.amount);
			oWateringCanResult.actual = String(oTool.charges);
			
			oWellResult.TestEquals();
			oWateringCanResult.TestEquals();
			
			return lResults;
		}
		
		public static function TestAddDailyWater():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("WellService", "TestAddDailyWater");
			
			var oLocation:GridLocation = null;
			var oFarm:Farm = null;
			var iUpgradeLevel:int = 0;
			var iStartAmount:int = 0;
			var oWell:Well = new Well(oLocation, oFarm, iUpgradeLevel, iStartAmount);
			
			WellService.AddDailyWellWater(oWell);
			
			oResult.expected = String(WellService.DAILY_AMOUNT[iUpgradeLevel]);
			oResult.actual = String(oWell.amount);
			oResult.TestEquals();
			
			return oResult;
		}
		
		//- Testing Methods -//
	}
}