package
{
	//-----------------------
	//Purpose:				Service logic for Microbes
	//
	//Public Properties:
	//	
	//Public Methods:
	//	RunActions(soil:Soil, fertilizer:Fertilizer):void = have microbes in given soil perform their daily actions
	//	UpdatePopulation(soil:Soil, plant:Plant, fertilizer:Fertilizer):void = update microbe populations in the given soil based on environmental conditions
	//
	//-----------------------
	public class MicrobeService
	{
		// Constants //
		
		//- Constants -//
		
		
		// Public Properties //
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function MicrobeService()
		{
			
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		// have microbes in given soil perform their daily actions
		public static function RunActions(soil:Soil, fertilizer:Fertilizer):void
		{
			if (soil == null)
			{
				return;
			}
			
			if (soil.microbes == null)
			{
				return;
			}
			
			for (var m:int = 0; m < soil.microbes.length; m++)
			{
				var oMicrobe:Microbe = Microbe(soil.microbes[m]);
				
				if (oMicrobe == null)
				{
					continue;
				}
				
				var nPopPercent:Number = oMicrobe.population / oMicrobe.maxPopulation;
				
				// toxicity
				var nToxicityDelta:Number = nPopPercent * oMicrobe.detoxAmount;
				soil.toxicity -= nToxicityDelta;
				
				// nutrient generation
				if (oMicrobe.nutrientGeneration != null)
				{
					soil.AddNutrient1(nPopPercent * oMicrobe.nutrientGeneration.n1);
					soil.AddNutrient2(nPopPercent * oMicrobe.nutrientGeneration.n2);
					soil.AddNutrient3(nPopPercent * oMicrobe.nutrientGeneration.n3);
				}
				
				// fertilizer boosting
				if (fertilizer == null)
				{
					continue;
				}
				
				if (oMicrobe.nutrientBoost == null)
				{
					continue;
				}
				
				var iToxicity:int = fertilizer.GetDailyToxicityDischarge();
				
				// microbes only boost organic fertilizers
				if (iToxicity > 0)
				{
					continue;
				}
				
				// apply fertilizer boost
				var oNutrients:NutrientSet = fertilizer.GetDailyNutrientDischarge();
				soil.AddNutrient1(nPopPercent * oMicrobe.nutrientBoost.n1 * oNutrients.n1);
				soil.AddNutrient2(nPopPercent * oMicrobe.nutrientBoost.n2 * oNutrients.n2);
				soil.AddNutrient3(nPopPercent * oMicrobe.nutrientBoost.n3 * oNutrients.n3);
			}
		}
		
		// update microbe populations in the given soil based on environmental conditions
		public static function UpdatePopulation(soil:Soil, plant:Plant, fertilizer:Fertilizer):void
		{
			if (soil == null)
			{
				return;
			}
			
			// create new microbe instance for any host that doesn't already have a microbe in the soil
			if (plant != null)
			{
				CreateMicrobesIfNotPresent(plant, soil);
			}
			
			if (fertilizer != null)
			{
				CreateMicrobesIfNotPresent(fertilizer, soil);
			}
			
			if (soil.microbes == null)
			{
				soil.microbes = new Array();
			}
			
			// go through the list of all microbes in the soil and adjust populations accordingly
			for (var i:int = 0; i < soil.microbes.length; i++)
			{
				var oMicrobe:Microbe = Microbe(soil.microbes[i]);
				
				// wipe out population if outside of livable conditions
				if (soil.toxicity > oMicrobe.maxToxicity || soil.saturation < oMicrobe.minSaturation || soil.saturation > oMicrobe.maxSaturation)
				{
					oMicrobe.population = 0;
					continue;
				}
				
				var bHostPresent:Boolean = IsHostPresentForMicrobe(oMicrobe, plant, fertilizer);
				var nPopulationDelta:Number = 0;
				
				// base growth amount, based on whether or not the host is still present
				if (bHostPresent == true)
				{
					nPopulationDelta = oMicrobe.growthRate;
				}
				else
				{
					nPopulationDelta = -1 * oMicrobe.noHostDieOffAmount;
				}
				
				// reduce population if beyond highToxicity
				if (soil.toxicity > oMicrobe.highToxicity)
				{
					if (nPopulationDelta > 0)
					{
						nPopulationDelta /= 2;
					}
					else
					{
						nPopulationDelta *= 2;
					}
				}
				
				// don't allow population to grow beyond bounds of either microbe or soil max population sizes
				var nMaxPopulationDelta = GetMaxMicrobePopulationDelta(oMicrobe, soil);
				
				if (nPopulationDelta > nMaxPopulationDelta)
				{
					nPopulationDelta = nMaxPopulationDelta;
				}
				
				// update population amount
				oMicrobe.population += nPopulationDelta;
			}
			
			// remove any dead microbe populations
			for (i = soil.microbes.length - 1; i >= 0; i--)
			{
				oMicrobe = Microbe(soil.microbes[i]);
				
				if (oMicrobe.population <= 0)
				{
					soil.microbes.splice(i, 1);
				}
			}
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		private static function CreateMicrobesIfNotPresent(host:IMicrobeHost, soil:Soil):void
		{
			if (host == null)
			{
				return;
			}
			
			if (soil == null)
			{
				return;
			}
			
			if (soil.microbes == null)
			{
				soil.microbes = new Array();
			}
			
			var sHostCode:String = host.GetUniqueHostCode();
			
			var bDoesMicrobeExist:Boolean = DoesMicrobeExistForHostCode(sHostCode);
			
			if (bDoesMicrobeExist == true)
			{
				var bPresent:Boolean = false;
				
				for (var i:int = 0; i < soil.microbes.length; i++)
				{
					var oMicrobe:Microbe = Microbe(soil.microbes[i]);
					
					if (oMicrobe.hostCode == sHostCode)
					{
						bPresent = true;
						break;
					}
				}
				
				if (bPresent == false)
				{
					CreateNewMicrobe(sHostCode, soil);
				}
			}
		}
		
		private static function CreateNewMicrobe(hostCode:String, soil:Soil):void
		{
			if (soil == null)
			{
				return;
			}
			
			if (soil.microbes == null)
			{
				soil.microbes = new Array();
			}
			
			switch (hostCode)
			{
				case "Plant-Eggplant-Rooted":
					// n3 boost
					soil.microbes.push(new Microbe(hostCode, 0, new NutrientSet(0, 0, 0.5), new NutrientSet(0, 0, 0), 0, 30, 3, 2, 7, 93, 30, 60));
					break;
				case "Plant-Pumpkin-Rooted":
					// n2 boost
					soil.microbes.push(new Microbe(hostCode, 0, new NutrientSet(0, 0.5, 0), new NutrientSet(0, 0, 0), 0, 30, 3, 2, 7, 93, 30, 60));
					break;
				case "Plant-Alfalfa-Rooted":
					// n1 gen
					soil.microbes.push(new Microbe(hostCode, 0, new NutrientSet(0, 0, 0), new NutrientSet(6, 0, 0), 0, 30, 3, 2, 7, 93, 30, 60));
					break;
				case "Plant-Broccoli-Rooted":
					// n1 boost
					soil.microbes.push(new Microbe(hostCode, 0, new NutrientSet(0.5, 0, 0), new NutrientSet(0, 0, 0), 0, 30, 3, 2, 7, 93, 30, 60));
					break;
				case "Plant-Clover-Rooted":
					// detox
					soil.microbes.push(new Microbe(hostCode, 7, new NutrientSet(0, 0, 0), new NutrientSet(0, 0, 0), 0, 30, 3, 2, 7, 93, 75, 95));
					break;
				case "Compost":
					// small boost for all nutrients
					soil.microbes.push(new Microbe(hostCode, 0, new NutrientSet(0.25, 0.25, 0.25), new NutrientSet(0, 0, 0), 0, 30, 3, 2, 7, 93, 30, 60));
					break;
				default:
					break;
			}
		}
		
		private static function DoesMicrobeExistForHostCode(hostCode:String):Boolean
		{
			var bDoesMicrobeExist:Boolean = false;
			
			switch (hostCode)
			{
				case "Plant-Alfalfa-Rooted":
				case "Plant-Broccoli-Rooted":
				case "Plant-Clover-Rooted":
				case "Plant-Eggplant-Rooted":
				case "Plant-Pumpkin-Rooted":
				case "Compost":
					bDoesMicrobeExist = true;
					break;
				default:
					break;
			}
			
			return bDoesMicrobeExist;
		}
		
		private static function GetMaxMicrobePopulationDelta(microbe:Microbe, soil:Soil):Number
		{
			if (microbe == null)
			{
				return 0;
			}
			
			if (soil == null)
			{
				return 0;
			}
			
			var nMaxDelta:Number = microbe.maxPopulation - microbe.population;
			
			var nCurrentSoilMicrobePopulation:Number = 0;
			
			if (soil.microbes == null)
			{
				soil.microbes = new Array();
			}
			
			for (var i:int = 0; i < soil.microbes.length; i++)
			{
				var oMicrobe:Microbe = Microbe(soil.microbes[i]);
				
				nCurrentSoilMicrobePopulation += oMicrobe.population;
			}
			
			var nMaxSoilDelta = Soil.MAX_MICROBE_POP - nCurrentSoilMicrobePopulation;
			
			if (nMaxSoilDelta < nMaxDelta)
			{
				nMaxDelta = nMaxSoilDelta;
			}
			
			return nMaxDelta;
		}
		
		private static function IsHostPresentForMicrobe(microbe:Microbe, plant:Plant, fertilizer:Fertilizer):Boolean
		{
			var bIsHostPresent:Boolean = false;
			
			if (plant != null && plant.GetUniqueHostCode() == microbe.hostCode)
			{
				bIsHostPresent = true;
			}
			
			if (fertilizer != null && fertilizer.GetUniqueHostCode() == microbe.hostCode)
			{
				bIsHostPresent = true;
			}
			
			return bIsHostPresent;
		}
		
		//- Private Methods -//
		
		
		// Testing Methods //
		
		public static function RunTests():Array
		{
			var lResults:Array = new Array();
			
			lResults.push(MicrobeService.RunActionsDetoxSoil());
			lResults.push(MicrobeService.RunActionsGenerateNutrients());
			lResults.push(MicrobeService.RunActionsNoBoostForToxicFertilizer());
			lResults.push(MicrobeService.RunActionsBoostCleanFertilizer());
			
			lResults.push(MicrobeService.UpdatePopulationCreateNewPopFromPlant());
			lResults.push(MicrobeService.UpdatePopulationCreateNewPopFromFertilizer());
			lResults.push(MicrobeService.UpdatePopulationHighToxWipeout());
			lResults.push(MicrobeService.UpdatePopulationHighSatWipeout());
			lResults.push(MicrobeService.UpdatePopulationLowSatWipeout());
			lResults.push(MicrobeService.UpdatePopulationStandardGrowth());
			lResults.push(MicrobeService.UpdatePopulationNoHostDieOff());
			lResults.push(MicrobeService.UpdatePopulationHalfStandardGrowthFromTox());
			lResults.push(MicrobeService.UpdatePopulationDoubleNoHostDieOffFromTox());
			lResults.push(MicrobeService.UpdatePopulationGrowthCappedByMicrobeMax());
			lResults.push(MicrobeService.UpdatePopulationGrowthCappedBySoilMax());
			
			lResults.push(MicrobeService.CreateMicrobesIfNotPresentCreatesNewIfNoneExist());
			lResults.push(MicrobeService.CreateMicrobesIfNotPresentCreatesNewIfOthersExist());
			lResults.push(MicrobeService.CreateMicrobesIfNotPresentDoesNothingIfAlreadyExists());
			
			lResults.push(MicrobeService.CreateNewMicrobeAddsMicrobeForValidHostCode());
			lResults.push(MicrobeService.CreateNewMicrobeDoesNothingForInvalidHostCode());
			
			lResults.push(MicrobeService.DoesMicrobeExistForHostCodeTrue());
			lResults.push(MicrobeService.DoesMicrobeExistForHostCodeFalse());
			
			lResults.push(MicrobeService.GetMaxMicrobePopulationDeltaZeroIfNoMicrobe());
			lResults.push(MicrobeService.GetMaxMicrobePopulationDeltaZeroIfNoSoil());
			lResults.push(MicrobeService.GetMaxMicrobePopulationDeltaLimitedByMicrobeMax());
			lResults.push(MicrobeService.GetMaxMicrobePopulationDeltaLimitedBySoilMax());
			
			lResults.push(MicrobeService.IsHostPresentForMicrobeTrueForPlant());
			lResults.push(MicrobeService.IsHostPresentForMicrobeTrueForFertilizer());
			lResults.push(MicrobeService.IsHostPresentForMicrobeFalse());
			
			return lResults;
		}
		
		private static function RunActionsDetoxSoil():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("MicrobeService", "RunActionsDetoxSoil");
			
			var oMicrobe:Microbe = new Microbe();
			oMicrobe.population = 50;
			oMicrobe.maxPopulation = 100;
			oMicrobe.detoxAmount = 6;
			
			var oSoil:Soil = new Soil();
			oSoil.toxicity = 10;
			oSoil.microbes.push(oMicrobe);
			
			MicrobeService.RunActions(oSoil, null);
			
			oResult.expected = "7";
			oResult.actual = String(oSoil.toxicity);
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function RunActionsGenerateNutrients():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("MicrobeService", "RunActionsGenerateNutrients");
			
			var oMicrobe:Microbe = new Microbe();
			oMicrobe.population = 50;
			oMicrobe.maxPopulation = 100;
			oMicrobe.nutrientGeneration = new NutrientSet(10, 6, 0);
			
			var oSoil:Soil = new Soil();
			oSoil.nutrient1 = 50;
			oSoil.nutrient2 = 40;
			oSoil.nutrient3 = 30;
			oSoil.microbes.push(oMicrobe);
			
			MicrobeService.RunActions(oSoil, null);
			
			var oExpected:NutrientSet = new NutrientSet(55, 43, 30);
			oResult.expected = oExpected.PrettyPrint();
			oResult.actual = oSoil.GetNutrientSet().PrettyPrint();
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function RunActionsNoBoostForToxicFertilizer():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("MicrobeService", "RunActionsNoBoostForToxicFertilizer");
			
			var oMicrobe:Microbe = new Microbe();
			oMicrobe.population = 50;
			oMicrobe.maxPopulation = 100;
			oMicrobe.nutrientBoost = new NutrientSet(1.0, 2.0, 1.0);
			
			var oFertilizer:Fertilizer = new Fertilizer(null, new NutrientSet(100, 100, 100), 100, "", 10, 10);
			
			var oSoil:Soil = new Soil();
			oSoil.nutrient1 = 50;
			oSoil.nutrient2 = 40;
			oSoil.nutrient3 = 30;
			oSoil.microbes.push(oMicrobe);
			
			MicrobeService.RunActions(oSoil, oFertilizer);
			
			var oExpected:NutrientSet = new NutrientSet(50, 40, 30);
			oResult.expected = oExpected.PrettyPrint();
			oResult.actual = oSoil.GetNutrientSet().PrettyPrint();
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function RunActionsBoostCleanFertilizer():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("MicrobeService", "RunActionsBoostCleanFertilizer");
			
			var oMicrobe:Microbe = new Microbe();
			oMicrobe.population = 50;
			oMicrobe.maxPopulation = 100;
			oMicrobe.nutrientBoost = new NutrientSet(0, 1.0, 0);
			
			var oFertilizer:Fertilizer = new Fertilizer(null, new NutrientSet(100, 100, 100), 0, "", 10, 10);
			
			var oSoil:Soil = new Soil();
			oSoil.nutrient1 = 50;
			oSoil.nutrient2 = 40;
			oSoil.nutrient3 = 30;
			oSoil.microbes.push(oMicrobe);
			
			MicrobeService.RunActions(oSoil, oFertilizer);
			
			var oExpected:NutrientSet = new NutrientSet(50, 45, 30);
			oResult.expected = oExpected.PrettyPrint();
			oResult.actual = oSoil.GetNutrientSet().PrettyPrint();
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function UpdatePopulationCreateNewPopFromPlant():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("MicrobeService", "UpdatePopulationCreateNewPopFromPlant");
			
			var oSoil:Soil = new Soil();
			oSoil.toxicity = 0;
			oSoil.saturation = 50;
			
			var oPlant:Plant = new Plant(Plant.TYPE_ALFALFA, Plant.STAGE_GROWING);
			
			MicrobeService.UpdatePopulation(oSoil, oPlant, null);
			
			oResult.expected = "3";
			
			if (oSoil.microbes == null)
			{
				oResult.actual = "No microbes created";
			}
			else
			{
				if (oSoil.microbes.length == 0)
				{
					oResult.actual = "No microbes created";
				}
				else if (oSoil.microbes.length == 1)
				{
					var oMicrobe:Microbe = Microbe(oSoil.microbes[0]);
					
					if (oMicrobe == null)
					{
						oResult.actual = "Null inserted into soil microbes instead of a real Microbe";
					}
					else
					{
						oResult.actual = String(oMicrobe.population);  // expected case
					}
				}
				else if (oSoil.microbes.length > 1)
				{
					oResult.actual = "Too many microbes created - expecting only 1 but ended up with " + oSoil.microbes.length;
				}
			}
			
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function UpdatePopulationCreateNewPopFromFertilizer():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("MicrobeService", "UpdatePopulationCreateNewPopFromFertilizer");
			
			var oSoil:Soil = new Soil();
			oSoil.toxicity = 0;
			oSoil.saturation = 50;
			
			var oFertilizer:Fertilizer = new Fertilizer(null, null, 0, "Compost");
			
			MicrobeService.UpdatePopulation(oSoil, null, oFertilizer);
			
			oResult.expected = "3";
			
			if (oSoil.microbes == null)
			{
				oResult.actual = "No microbes created";
			}
			else
			{
				if (oSoil.microbes.length == 0)
				{
					oResult.actual = "No microbes created";
				}
				else if (oSoil.microbes.length == 1)
				{
					var oMicrobe:Microbe = Microbe(oSoil.microbes[0]);
					
					if (oMicrobe == null)
					{
						oResult.actual = "Null inserted into soil microbes instead of a real Microbe";
					}
					else
					{
						oResult.actual = String(oMicrobe.population);  // expected case
					}
				}
				else if (oSoil.microbes.length > 1)
				{
					oResult.actual = "Too many microbes created - expecting only 1 but ended up with " + oSoil.microbes.length;
				}
			}
			
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function UpdatePopulationHighToxWipeout():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("MicrobeService", "UpdatePopulationHighToxWipeout");
			
			var oMicrobe:Microbe = new Microbe("Plant-Alfalfa-Rooted", 0, new NutrientSet(0, 0, 0), new NutrientSet(6, 0, 0), 0, 30, 3, 2, 7, 93, 30, 60);
			
			var oSoil:Soil = new Soil();
			oSoil.saturation = 50;
			oSoil.toxicity = 100;
			oSoil.microbes.push(oMicrobe);
			
			var oPlant:Plant = new Plant(Plant.TYPE_ALFALFA, Plant.STAGE_GROWING);
			
			MicrobeService.UpdatePopulation(oSoil, oPlant, null);
			
			oResult.expected = "0";
			
			if (oSoil.microbes == null)
			{
				oResult.actual = "Microbes array should just be empty, but it's actually null";
			}
			else
			{
				oResult.actual = String(oSoil.microbes.length);
			}
			
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function UpdatePopulationHighSatWipeout():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("MicrobeService", "UpdatePopulationHighSatWipeout");
			var oMicrobe:Microbe = new Microbe("Plant-Alfalfa-Rooted", 0, new NutrientSet(0, 0, 0), new NutrientSet(6, 0, 0), 0, 30, 3, 2, 7, 93, 30, 60);
			
			var oSoil:Soil = new Soil();
			oSoil.saturation = 100;
			oSoil.toxicity = 0;
			oSoil.microbes.push(oMicrobe);
			
			var oPlant:Plant = new Plant(Plant.TYPE_ALFALFA, Plant.STAGE_GROWING);
			
			MicrobeService.UpdatePopulation(oSoil, oPlant, null);
			
			oResult.expected = "0";
			
			if (oSoil.microbes == null)
			{
				oResult.actual = "Microbes array should just be empty, but it's actually null";
			}
			else
			{
				oResult.actual = String(oSoil.microbes.length);
			}
			
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function UpdatePopulationLowSatWipeout():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("MicrobeService", "UpdatePopulationLowSatWipeout");
			var oMicrobe:Microbe = new Microbe("Plant-Alfalfa-Rooted", 0, new NutrientSet(0, 0, 0), new NutrientSet(6, 0, 0), 0, 30, 3, 2, 7, 93, 30, 60);
			
			var oSoil:Soil = new Soil();
			oSoil.saturation = 0;
			oSoil.toxicity = 0;
			oSoil.microbes.push(oMicrobe);
			
			var oPlant:Plant = new Plant(Plant.TYPE_ALFALFA, Plant.STAGE_GROWING);
			
			MicrobeService.UpdatePopulation(oSoil, oPlant, null);
			
			oResult.expected = "0";
			
			if (oSoil.microbes == null)
			{
				oResult.actual = "Microbes array should just be empty, but it's actually null";
			}
			else
			{
				oResult.actual = String(oSoil.microbes.length);
			}
			
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function UpdatePopulationStandardGrowth():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("MicrobeService", "UpdatePopulationStandardGrowth");
			
			var oMicrobe:Microbe = new Microbe("Plant-Alfalfa-Rooted", 0, new NutrientSet(0, 0, 0), new NutrientSet(6, 0, 0), 3, 30, 3, 2, 7, 93, 30, 60);
			
			var oSoil:Soil = new Soil();
			oSoil.saturation = 50;
			oSoil.toxicity = 0;
			oSoil.microbes.push(oMicrobe);
			
			var oPlant:Plant = new Plant(Plant.TYPE_ALFALFA, Plant.STAGE_GROWING);
			
			MicrobeService.UpdatePopulation(oSoil, oPlant, null);
			
			oResult.expected = "6";
			
			if (oMicrobe == null)
			{
				oResult.actual = "Microbe got wiped out";
			}
			else
			{
				oResult.actual = String(oMicrobe.population);
			}
			
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function UpdatePopulationNoHostDieOff():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("MicrobeService", "UpdatePopulationNoHostDieOff");
			
			var oMicrobe:Microbe = new Microbe("Plant-Alfalfa-Rooted", 0, new NutrientSet(0, 0, 0), new NutrientSet(6, 0, 0), 3, 30, 3, 2, 7, 93, 30, 60);
			
			var oSoil:Soil = new Soil();
			oSoil.saturation = 50;
			oSoil.toxicity = 0;
			oSoil.microbes.push(oMicrobe);
			
			MicrobeService.UpdatePopulation(oSoil, null, null);
			
			oResult.expected = "1";
			
			if (oMicrobe == null)
			{
				oResult.actual = "Microbe got wiped out";
			}
			else
			{
				oResult.actual = String(oMicrobe.population);
			}
			
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function UpdatePopulationHalfStandardGrowthFromTox():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("MicrobeService", "UpdatePopulationHalfStandardGrowthFromTox");
			
			var iPopulation:int = 3;
			var iGrowthAmount:int = 4;
			var oMicrobe:Microbe = new Microbe("Plant-Alfalfa-Rooted", 0, new NutrientSet(0, 0, 0), new NutrientSet(6, 0, 0), iPopulation, 30, iGrowthAmount, 2, 7, 93, 30, 60);
			
			var oSoil:Soil = new Soil();
			oSoil.saturation = 50;
			oSoil.toxicity = 40;
			oSoil.microbes.push(oMicrobe);
			
			var oPlant:Plant = new Plant(Plant.TYPE_ALFALFA, Plant.STAGE_GROWING);
			
			MicrobeService.UpdatePopulation(oSoil, oPlant, null);
			
			oResult.expected = "5";
			
			if (oMicrobe == null)
			{
				oResult.actual = "Microbe got wiped out";
			}
			else
			{
				oResult.actual = String(oMicrobe.population);
			}
			
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function UpdatePopulationDoubleNoHostDieOffFromTox():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("MicrobeService", "UpdatePopulationDoubleNoHostDieOffFromTox");
			
			var iPopulation:int = 10;
			var oMicrobe:Microbe = new Microbe("Plant-Alfalfa-Rooted", 0, new NutrientSet(0, 0, 0), new NutrientSet(6, 0, 0), iPopulation, 30, 3, 2, 7, 93, 30, 60);
			
			var oSoil:Soil = new Soil();
			oSoil.saturation = 50;
			oSoil.toxicity = 40;
			oSoil.microbes.push(oMicrobe);
			
			MicrobeService.UpdatePopulation(oSoil, null, null);
			
			oResult.expected = "6";
			
			if (oMicrobe == null)
			{
				oResult.actual = "Microbe got wiped out";
			}
			else
			{
				oResult.actual = String(oMicrobe.population);
			}
			
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function UpdatePopulationGrowthCappedByMicrobeMax():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("MicrobeService", "UpdatePopulationGrowthCappedByMicrobeMax");
			
			var iPopulation:int = 25;
			var iMaxPopulation:int = 30;
			var iGrowthAmount:int = 10;
			var oMicrobe:Microbe = new Microbe("Plant-Alfalfa-Rooted", 0, new NutrientSet(0, 0, 0), new NutrientSet(6, 0, 0), iPopulation, iMaxPopulation, iGrowthAmount, 2, 7, 93, 30, 60);
			
			var oSoil:Soil = new Soil();
			oSoil.saturation = 50;
			oSoil.toxicity = 0;
			oSoil.microbes.push(oMicrobe);
			
			var oPlant:Plant = new Plant(Plant.TYPE_ALFALFA, Plant.STAGE_GROWING);
			
			MicrobeService.UpdatePopulation(oSoil, oPlant, null);
			
			oResult.expected = "30";
			
			if (oMicrobe == null)
			{
				oResult.actual = "Microbe got wiped out";
			}
			else
			{
				oResult.actual = String(oMicrobe.population);
			}
			
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function UpdatePopulationGrowthCappedBySoilMax():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("MicrobeService", "UpdatePopulationGrowthCappedBySoilMax");
			
			var iPopulation:int = Soil.MAX_MICROBE_POP - 5;
			var iMaxPopulation:int = 999999;
			var iGrowthAmount:int = 10;
			var oMicrobe:Microbe = new Microbe("Plant-Alfalfa-Rooted", 0, new NutrientSet(0, 0, 0), new NutrientSet(6, 0, 0), iPopulation, iMaxPopulation, iGrowthAmount, 2, 7, 93, 30, 60);
			
			var oSoil:Soil = new Soil();
			oSoil.saturation = 50;
			oSoil.toxicity = 0;
			oSoil.microbes.push(oMicrobe);
			
			var oPlant:Plant = new Plant(Plant.TYPE_ALFALFA, Plant.STAGE_GROWING);
			
			MicrobeService.UpdatePopulation(oSoil, oPlant, null);
			
			oResult.expected = String(Soil.MAX_MICROBE_POP);
			
			if (oMicrobe == null)
			{
				oResult.actual = "Microbe got wiped out";
			}
			else
			{
				oResult.actual = String(oMicrobe.population);
			}
			
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function CreateMicrobesIfNotPresentCreatesNewIfNoneExist():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("MicrobeService", "CreateMicrobesIfNotPresentCreatesNewIfNoneExist");
			
			var oHost:Plant = new Plant(Plant.TYPE_ALFALFA, Plant.STAGE_GROWING);
			var oSoil:Soil = new Soil();
			
			MicrobeService.CreateMicrobesIfNotPresent(oHost, oSoil);
			
			oResult.expected = "1";
			
			if (oSoil.microbes == null)
			{
				oResult.actual = "microbes array is null";
			}
			else
			{
				oResult.actual = String(oSoil.microbes.length);
			}
			
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function CreateMicrobesIfNotPresentCreatesNewIfOthersExist():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("MicrobeService", "CreateMicrobesIfNotPresentCreatesNewIfOthersExist");
			
			var oHost:Plant = new Plant(Plant.TYPE_ALFALFA, Plant.STAGE_GROWING);
			var oMicrobe:Microbe = new Microbe("Other-Microbe");
			var oSoil:Soil = new Soil();
			oSoil.microbes.push(oMicrobe);
			
			MicrobeService.CreateMicrobesIfNotPresent(oHost, oSoil);
			
			oResult.expected = "2";
			
			if (oSoil.microbes == null)
			{
				oResult.actual = "microbes array is null";
			}
			else
			{
				oResult.actual = String(oSoil.microbes.length);
			}
			
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function CreateMicrobesIfNotPresentDoesNothingIfAlreadyExists():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("MicrobeService", "CreateMicrobesIfNotPresentDoesNothingIfAlreadyExists");
			
			var oHost:Plant = new Plant(Plant.TYPE_ALFALFA, Plant.STAGE_GROWING);
			var oMicrobe:Microbe = new Microbe("Plant-Alfalfa-Rooted");
			var oSoil:Soil = new Soil();
			oSoil.microbes.push(oMicrobe);
			
			MicrobeService.CreateMicrobesIfNotPresent(oHost, oSoil);
			
			oResult.expected = "1";
			
			if (oSoil.microbes == null)
			{
				oResult.actual = "microbes array is null";
			}
			else
			{
				oResult.actual = String(oSoil.microbes.length);
			}
			
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function CreateNewMicrobeAddsMicrobeForValidHostCode():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("MicrobeService", "CreateNewMicrobeAddsMicrobeForValidHostCode");
			
			var oSoil:Soil = new Soil();
			
			MicrobeService.CreateNewMicrobe("Plant-Alfalfa-Rooted", oSoil);
			
			oResult.expected = "1";
			
			if (oSoil.microbes == null)
			{
				oResult.actual = "No micrboes added";
			}
			else
			{
				oResult.actual = String(oSoil.microbes.length);
			}
			
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function CreateNewMicrobeDoesNothingForInvalidHostCode():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("MicrobeService", "CreateNewMicrobeDoesNothingForInvalidHostCode");
			
			var oSoil:Soil = new Soil();
			
			MicrobeService.CreateNewMicrobe("Not-a-real-host-code", oSoil);
			
			oResult.expected = "0";
			
			if (oSoil.microbes == null)
			{
				oResult.actual = "Microbe array is null";
			}
			else
			{
				oResult.actual = String(oSoil.microbes.length);
			}
			
			oResult.TestEquals();
			
			return oResult;
		}
		
		
		private static function DoesMicrobeExistForHostCodeTrue():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("MicrobeService", "DoesMicrobeExistForHostCodeTrue");
			
			oResult.TestTrue(MicrobeService.DoesMicrobeExistForHostCode("Plant-Alfalfa-Rooted"));
			
			return oResult;
		}
		
		private static function DoesMicrobeExistForHostCodeFalse():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("MicrobeService", "DoesMicrobeExistForHostCodeFalse");
			
			oResult.TestFalse(MicrobeService.DoesMicrobeExistForHostCode("Totally-Fake-Host-Code"));
			
			return oResult;
		}
		
		private static function GetMaxMicrobePopulationDeltaZeroIfNoMicrobe():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("MicrobeService", "GetMaxMicrobePopulationDeltaZeroIfNoMicrobe");
			
			var oMicrobe:Microbe = null;
			var oSoil:Soil = new Soil();
			
			oResult.expected = "0";
			oResult.actual = String(MicrobeService.GetMaxMicrobePopulationDelta(oMicrobe, oSoil));
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GetMaxMicrobePopulationDeltaZeroIfNoSoil():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("MicrobeService", "GetMaxMicrobePopulationDeltaZeroIfNoSoil");
			
			var oMicrobe:Microbe = new Microbe("Some-Microbe");
			var oSoil:Soil = null;
			
			oResult.expected = "0";
			oResult.actual = String(MicrobeService.GetMaxMicrobePopulationDelta(oMicrobe, oSoil));
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GetMaxMicrobePopulationDeltaLimitedByMicrobeMax():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("MicrobeService", "GetMaxMicrobePopulationDeltaLimitedByMicrobeMax");
			
			var iMaxPop:int = 30;
			var iPop:int = 28;
			var oMicrobe:Microbe = new Microbe("Plant-Eggplant-Rooted", 0, new NutrientSet(0, 0, 0.5), new NutrientSet(0, 0, 0), iPop, iMaxPop, 3, 2, 7, 93, 30, 60);
			var oSoil:Soil = new Soil();
			oSoil.microbes.push(oMicrobe);
			
			oResult.expected = "2";
			oResult.actual = String(MicrobeService.GetMaxMicrobePopulationDelta(oMicrobe, oSoil));
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GetMaxMicrobePopulationDeltaLimitedBySoilMax():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("MicrobeService", "GetMaxMicrobePopulationDeltaLimitedBySoilMax");
			
			var iMaxPop:int = 30;
			var iPop:int = 0;
			var oMicrobe:Microbe = new Microbe("Plant-Eggplant-Rooted", 0, new NutrientSet(0, 0, 0.5), new NutrientSet(0, 0, 0), iPop, iMaxPop, 3, 2, 7, 93, 30, 60);
			var oSoil:Soil = new Soil();
			oSoil.microbes.push(oMicrobe);
			
			var iMaxPop2:int = Soil.MAX_MICROBE_POP;
			var iPop2:int = Soil.MAX_MICROBE_POP - 1;
			var oMicrobe2:Microbe = new Microbe("Plant-Alfalfa-Rooted", 0, new NutrientSet(0, 0, 0.5), new NutrientSet(0, 0, 0), iPop2, iMaxPop2, 3, 2, 7, 93, 30, 60);
			oSoil.microbes.push(oMicrobe2);
			
			oResult.expected = "1";
			oResult.actual = String(MicrobeService.GetMaxMicrobePopulationDelta(oMicrobe, oSoil));
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function IsHostPresentForMicrobeTrueForPlant():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("MicrobeService", "IsHostPresentForMicrobeTrueForPlant");
			
			var oMicrobe:Microbe = new Microbe("Plant-Alfalfa-Rooted");
			var oPlant:Plant = new Plant(Plant.TYPE_ALFALFA, Plant.STAGE_GROWING);
			
			oResult.TestTrue(MicrobeService.IsHostPresentForMicrobe(oMicrobe, oPlant, null));
			
			return oResult;
		}
		
		private static function IsHostPresentForMicrobeTrueForFertilizer():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("MicrobeService", "IsHostPresentForMicrobeTrueForFertilizer");
			
			var oMicrobe:Microbe = new Microbe("TestFertilizer");
			var oFertilizer:Fertilizer = new Fertilizer(null, null, 0, "TestFertilizer");
			
			oResult.TestTrue(MicrobeService.IsHostPresentForMicrobe(oMicrobe, null, oFertilizer));
			
			return oResult;
		}
		
		private static function IsHostPresentForMicrobeFalse():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("MicrobeService", "IsHostPresentForMicrobeFalse");
			
			var oMicrobe:Microbe = new Microbe("TestFertilizer");
			
			oResult.TestFalse(MicrobeService.IsHostPresentForMicrobe(oMicrobe, null, null));
			
			return oResult;
		}
		
		//- Testing Methods -//
	}
}