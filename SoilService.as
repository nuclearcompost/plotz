package
{
	//-----------------------
	//Purpose:				
	//Public Properties:
	//	
	//Public Methods:
	//	
	//-----------------------
	public class SoilService
	{
		// Constants //
		
		//- Constants -//
		
		
		// Public Properties //
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function SoilService()
		{
			
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		public static function DischargeFertilizer(soil:Soil, fertilizer:Fertilizer, calendarStatTracker:CalendarStatTracker):void
		{
			if (soil == null)
			{
				return;
			}
			
			if (fertilizer == null)
			{
				return;
			}
			
			if (fertilizer.daysLeft < 1)
			{
				return;
			}
			
			var oNutrientSet:NutrientSet = fertilizer.GetDailyNutrientDischarge();
			var iToxicity:int = fertilizer.GetDailyToxicityDischarge();
			
			// add nutrients to soil
			soil.nutrient1 += oNutrientSet.n1;
			soil.nutrient2 += oNutrientSet.n2;
			soil.nutrient3 += oNutrientSet.n3;
			
			// handle toxicity
			if (iToxicity > 0)
			{
				soil.toxicity += iToxicity;
			}
			
			// decrement all fertilizer values
			fertilizer.Discharge();
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		//- Private Methods -//
		
		
		// Testing Methods //
		
		public static function RunTests():Array
		{
			var lResults:Array = new Array();
			
			lResults.push(SoilService.DischargeFertilizerWithNullSoilDoesNothing());
			lResults.push(SoilService.DischargeFertilizerWithNullFertilizerDoesNothing());
			lResults.push(SoilService.DischargeFertilizerWithExhaustedFertilizerDoesNothing());
			lResults.push(SoilService.DischargeFertilizerAddsNutrients());
			lResults.push(SoilService.DischargeFertilizerAddsToxicity());
			lResults.push(SoilService.DischargeFertilizerReducesDaysLeft());
			
			return lResults;
		}
		
		private static function DischargeFertilizerWithNullSoilDoesNothing():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Soil Service", "DischargeFertilizerWithNullSoilDoesNothing");
			
			var oSoil:Soil = null;
			var oBag:BagFertilizer = new BagFertilizer(BagFertilizer.TYPE_STEADY_GREEN);
			var oFertilizer:Fertilizer = oBag.CreateFertilizer();
			
			oResult.expected = String(oFertilizer.daysLeft);
			
			SoilService.DischargeFertilizer(oSoil, oFertilizer, null);
			
			oResult.actual = String(oFertilizer.daysLeft);
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function DischargeFertilizerWithNullFertilizerDoesNothing():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Soil Service", "DischargeFertilizerWithNullFertilizerDoesNothing");
			
			var oSoil:Soil = new Soil(Substrate.TYPE_LOAM, true, 30, 40, 50, 50, 0);
			var oFertilizer:Fertilizer = null;
			
			oResult.expected = "(30, 40, 50)";
			
			SoilService.DischargeFertilizer(oSoil, oFertilizer, null);
			
			oResult.actual = oSoil.GetNutrientSet().PrettyPrint();
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function DischargeFertilizerWithExhaustedFertilizerDoesNothing():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Soil Service", "DischargeFertilizerWithExhaustedFertilizerDoesNothing");
			
			var oSoil:Soil = new Soil(Substrate.TYPE_LOAM, true, 30, 40, 50, 50, 0);
			var oBag:BagFertilizer = new BagFertilizer(BagFertilizer.TYPE_STEADY_GREEN);
			var oFertilizer:Fertilizer = oBag.CreateFertilizer();
			oFertilizer.daysLeft = 0;
			
			oResult.expected = "(30, 40, 50)";
			
			SoilService.DischargeFertilizer(oSoil, oFertilizer, null);
			
			oResult.actual = oSoil.GetNutrientSet().PrettyPrint();
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function DischargeFertilizerAddsNutrients():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Soil Service", "DischargeFertilizerAddsNutrients");
			
			var oSoil:Soil = new Soil(Substrate.TYPE_LOAM, true, 30, 40, 50, 50, 0);
			var oBag:BagFertilizer = new BagFertilizer(BagFertilizer.TYPE_STEADY_GREEN);
			var oFertilizer:Fertilizer = oBag.CreateFertilizer();
			
			oResult.expected = "(40, 43, 51)";
			
			SoilService.DischargeFertilizer(oSoil, oFertilizer, null);
			
			oResult.actual = oSoil.GetNutrientSet().PrettyPrint();
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function DischargeFertilizerAddsToxicity():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Soil Service", "DischargeFertilizerAddsToxicity");
			
			var oSoil:Soil = new Soil(Substrate.TYPE_LOAM, true, 30, 40, 50, 50, 0);
			var oBag:BagFertilizer = new BagFertilizer(BagFertilizer.TYPE_RAPID_GREEN);
			var oFertilizer:Fertilizer = oBag.CreateFertilizer();
			
			oResult.expected = "5";
			
			SoilService.DischargeFertilizer(oSoil, oFertilizer, null);
			
			oResult.actual = String(oSoil.toxicity);
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function DischargeFertilizerReducesDaysLeft():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Soil Service", "DischargeFertilizerReducesDaysLeft");
			
			var oSoil:Soil = new Soil(Substrate.TYPE_LOAM, true, 30, 40, 50, 50, 0);
			var oBag:BagFertilizer = new BagFertilizer(BagFertilizer.TYPE_RAPID_GREEN);
			var oFertilizer:Fertilizer = oBag.CreateFertilizer();
			
			oResult.expected = "2";
			
			SoilService.DischargeFertilizer(oSoil, oFertilizer, null);
			
			oResult.actual = String(oFertilizer.daysLeft);
			oResult.TestEquals();
			
			return oResult;
		}
		
		//- Testing Methods -//
	}
}