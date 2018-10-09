package
{
	//-----------------------
	//Purpose:				Service logic for Plants
	//
	//Methods:
	//	GetAmountOfNutrientsToAbsorb(plant:Plant, growthStrength:int):NutrientSet
	//	GetPlantGrowthStrength(plant:Plant, soil:Soil, season:int):int
	//	IsPlantInSeason(plant:Plant, season:int):Boolean
	//-----------------------
	public class PlantService
	{
		// Constants //
		
		//- Constants -//
		
		
		// Public Properties //
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function PlantService()
		{
			
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		public static function GetAmountOfNutrientsToAbsorb(plant:Plant, growthStrength:int):NutrientSet
		{
			var oAbsorb:NutrientSet = new NutrientSet();
			
			var oIdeal:NutrientSet = plant.GetIdealNutrientSet();
			var oLive:NutrientSet = plant.GetLiveNutrientSet();
			var oNeed:NutrientSet = plant.GetNeedNutrientSet();
			
			// 1. Get starting amount based on growthStrength
			if (growthStrength == 1)
			{
				// plant is in livable but less-than-ideal conditions, absorb some nutrients if possible
				if (plant.nutrient1 < oNeed.n1)
				{
					oAbsorb.n1 = oLive.n1;
				}
				if (plant.nutrient2 < oNeed.n2)
				{
					oAbsorb.n2 = oLive.n2;
				}
				if (plant.nutrient3 < oNeed.n3)
				{
					oAbsorb.n3 = oLive.n3;
				}
			}
			else if (growthStrength == 2)
			{
				// plant is in ideal conditions, absorb a lot of nutrients if possible
				if (plant.nutrient1 < oNeed.n1)
				{
					oAbsorb.n1 = oIdeal.n1;
				}
				if (plant.nutrient2 < oNeed.n2)
				{
					oAbsorb.n2 = oIdeal.n2;
				}
				if (plant.nutrient3 < oNeed.n3)
				{
					oAbsorb.n3 = oIdeal.n3;
				}
			}
			
			// 2. However, the plant will only absorb nutrients up to the current stage's cap, so reduce attempted absorption amount if needed because we're close to the cap
			var oCurrentNutrients:NutrientSet = new NutrientSet(plant.nutrient1, plant.nutrient2, plant.nutrient3)
			
			if (plant.growthStage == Plant.STAGE_PRODUCING)
			{
				oCurrentNutrients = NutrientSet.GetSum([ oCurrentNutrients, plant.fruit.nutrients ]);
			}
			
			if ((oNeed.n1 - oCurrentNutrients.n1) < oAbsorb.n1)
			{
				oAbsorb.n1 = oNeed.n1 - oCurrentNutrients.n1;
			}
			if ((oNeed.n2 - oCurrentNutrients.n2) < oAbsorb.n2)
			{
				oAbsorb.n2 = oNeed.n2 - oCurrentNutrients.n2;
			}
			if ((oNeed.n3 - oCurrentNutrients.n3) < oAbsorb.n3)
			{
				oAbsorb.n3 = oNeed.n3 - oCurrentNutrients.n3;
			}			
			
			return oAbsorb;
		}
		
		public static function GetNonCoverPlantTypesGrowableInTime(numDays:int):Array
		{
			if (numDays <= 0)
			{
				return new Array();
			}
			
			var lTypes:Array = new Array();
			
			for (var i:int = 0; i < Plant.NAME.length; i++)
			{
				var iClass:int = Plant.GetClass(i);
				
				if (iClass == Plant.CLASS_COVER)
				{
					continue;
				}
				
				var iDaysToHarvest:int = Plant.GetDaysToHarvest(i);
				
				if (iDaysToHarvest <= numDays)
				{
					lTypes.push(i);
				}
			}
			
			return lTypes;
		}
		
		// returns:  2 = ideal, 1 = live, -1 = dead from too much water, -2 = dead from too little water, -3 = dead from too much toxicity
		public static function GetPlantGrowthStrength(plant:Plant, soil:Soil, season:int):int
		{
			// saturation
			var iSaturationStatus:int = 0;
			var bIsInSeason:Boolean = PlantService.IsPlantInSeason(plant, season);
			
			if (bIsInSeason)
			{
				// ideal
				if (soil.saturation >= plant.inSeasonLowSaturation && soil.saturation <= plant.inSeasonHighSaturation)
				{
					iSaturationStatus = 2;
				}
				
				// live
				if ((soil.saturation >= plant.inSeasonMinSaturation && soil.saturation <= plant.inSeasonLowSaturation) ||
					(soil.saturation >= plant.inSeasonHighSaturation && soil.saturation <= plant.inSeasonMaxSaturation))
				{
					iSaturationStatus = 1;
				}
				
				// too much water
				if (soil.saturation > plant.inSeasonMaxSaturation)
				{
					return -1;
				}
				
				// too little water
				if (soil.saturation < plant.inSeasonMinSaturation)
				{
					return -2;
				}
			}
			else
			{
				// live
				if (soil.saturation >= plant.outSeasonMinSaturation && soil.saturation <= plant.outSeasonMaxSaturation)
				{
					iSaturationStatus = 1;
				}
				
				// too much water
				if (soil.saturation > plant.outSeasonMaxSaturation)
				{
					return -1;
				}
				
				// too little water
				if (soil.saturation < plant.outSeasonMinSaturation)
				{
					return -2;
				}
			}
			
			// toxicity conditions
			var iToxicityStatus:int = 0;
			
			// ideal
			if (soil.toxicity <= plant.highToxicity)
			{
				iToxicityStatus = 2;
			}
			// live
			else if (soil.toxicity > plant.highToxicity && soil.toxicity <= plant.maxToxicity)
			{
				iToxicityStatus = 1;
			}
			else if (soil.toxicity > plant.maxToxicity)
			{
				return -3;
			}			
			
			// at this point the plant is definitely at least alive, see whether it's ideal or just alive based on the combination of saturation and toxicity
			if (iSaturationStatus == 2 && iToxicityStatus == 2)
			{
				return 2;
			}
			
			return 1;
		}
		
		public static function IsPlantInSeason(plant:Plant, season:int):Boolean
		{
			var bInSeason:Boolean = false;
			
			var iPreferredSeason = Plant.GetPreferredSeason(plant.type);
			
			if (iPreferredSeason == Time.SEASON_ANY || iPreferredSeason == season)
			{
				bInSeason = true;
			}
			
			return bInSeason;
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		//- Private Methods -//
		
		
		// Test Methods //
		
		public static function RunTests():Array
		{
			var lResults:Array = new Array();
			
			lResults.push(PlantService.ShouldAbsorbIdealAmount());
			lResults.push(PlantService.ShouldAbsorbLiveAmount());
			lResults.push(PlantService.ShouldOnlyAbsorbUpToCap());
			lResults.push(PlantService.AbsorbCapIncludesFruitInProducingStage());
			lResults.push(PlantService.InSeasonDeadHighSaturation());
			lResults.push(PlantService.InSeasonLiveHighSaturation());
			lResults.push(PlantService.InSeasonIdeal());
			lResults.push(PlantService.InSeasonLiveLowSaturation());
			lResults.push(PlantService.InSeasonDeadLowSaturation());
			lResults.push(PlantService.DeadToxicity());
			lResults.push(PlantService.LiveToxicity());
			lResults.push(PlantService.OutOfSeasonDeadHighSaturation());
			lResults.push(PlantService.OutOfSeasonLive());
			lResults.push(PlantService.OutOfSeasonDeadLowSaturation());
			lResults.push(PlantService.AnySeasonIsInSeasonInSpring());
			lResults.push(PlantService.AnySeasonIsInSeasonInSummer());
			lResults.push(PlantService.AnySeasonIsInSeasonInFall());
			lResults.push(PlantService.InSeason());
			lResults.push(PlantService.OutOfSeason());
			
			lResults.push(PlantService.GetNonCoverPlantTypesGrowableInTimeReturnsEmptyForBadNumDays());
			lResults.push(PlantService.GetNonCoverPlantTypesGrowableInTimeReturnsPlantTypes());
			
			return lResults;
		}
		
		public static function ShouldAbsorbIdealAmount():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("PlantService", "ShouldAbsorbIdealAmount");
			var iPlantType:int = Plant.TYPE_CORN;
			var oPlant:Plant = new Plant(iPlantType);
			
			var oExpected:NutrientSet = oPlant.GetIdealNutrientSet();
			var oActual:NutrientSet = PlantService.GetAmountOfNutrientsToAbsorb(oPlant, 2);
			
			oResult.expected = oExpected.PrettyPrint();
			oResult.actual = oActual.PrettyPrint();
			
			if (oExpected.HasSameValues(oActual))
			{
				oResult.status = UnitTestResult.STATUS_PASS;
			}
			else
			{
				oResult.status = UnitTestResult.STATUS_FAIL;
			}
			
			return oResult;
		}
		
		public static function ShouldAbsorbLiveAmount():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("PlantService", "ShouldAbsorbLiveAmount");
			var iPlantType:int = Plant.TYPE_CORN;
			var oPlant:Plant = new Plant(iPlantType);
			
			var oExpected:NutrientSet = oPlant.GetLiveNutrientSet();
			var oActual:NutrientSet = PlantService.GetAmountOfNutrientsToAbsorb(oPlant, 1);
			
			oResult.expected = oExpected.PrettyPrint();
			oResult.actual = oActual.PrettyPrint();
			
			if (oExpected.HasSameValues(oActual))
			{
				oResult.status = UnitTestResult.STATUS_PASS;
			}
			else
			{
				oResult.status = UnitTestResult.STATUS_FAIL;
			}
			
			return oResult;
		}
		
		public static function ShouldOnlyAbsorbUpToCap():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("PlantService", "ShouldOnlyAbsorbUpToCap");
			var iPlantType:int = Plant.TYPE_CORN;
			var oPlant:Plant = new Plant(iPlantType);
			var oIdeal:NutrientSet = oPlant.GetIdealNutrientSet();
			var oNeed:NutrientSet = oPlant.GetNeedNutrientSet();
			oPlant.nutrient1 = oNeed.n1;
			oPlant.nutrient2 = oNeed.n2;
			
			var nExpectedn3:Number = oIdeal.n3;
			if (nExpectedn3 > oNeed.n3)
			{
				nExpectedn3 = oNeed.n3;
			}
			
			var oExpected:NutrientSet = new NutrientSet(0, 0, nExpectedn3);
			var oActual:NutrientSet = PlantService.GetAmountOfNutrientsToAbsorb(oPlant, 2);
			
			oResult.expected = oExpected.PrettyPrint();
			oResult.actual = oActual.PrettyPrint();
			
			if (oExpected.HasSameValues(oActual))
			{
				oResult.status = UnitTestResult.STATUS_PASS;
			}
			else
			{
				oResult.status = UnitTestResult.STATUS_FAIL;
			}
			
			return oResult;
		}
		
		private static function AbsorbCapIncludesFruitInProducingStage():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("PlantService", "AbsorbCapIncludesFruitInProducingStage");
			
			var oFruit:Fruit = new Fruit(Fruit.TYPE_ASPARAGUS, 0, Fruit.CONDITION_GROWING, 0, 0, -1, true);
			oFruit.nutrients.n1 = 8;
			oFruit.nutrients.n2 = 11;
			oFruit.nutrients.n3 = 12;
			
			var oPlant:Plant = new Plant(Plant.TYPE_ASPARAGUS, Plant.STAGE_PRODUCING, oFruit);
			oPlant.nutrient1 = 8;
			oPlant.nutrient2 = 1;
			oPlant.nutrient3 = 0;
			
			var oExpected:NutrientSet = new NutrientSet(0, 0, 0);
			oResult.expected = oExpected.PrettyPrint();
			
			var oActual:NutrientSet = PlantService.GetAmountOfNutrientsToAbsorb(oPlant, 2);
			oResult.actual = oActual.PrettyPrint();
			
			oResult.TestEquals();
			
			return oResult;
		}
		
		public static function InSeasonDeadHighSaturation():UnitTestResult
		{
			// plant data can change, so get the existing values and then craft a specific soil object to give the results desired
			var oResult:UnitTestResult = new UnitTestResult("PlantService", "InSeasonDeadHighSaturation");
			var iPlantType:int = Plant.TYPE_CORN;
			var oPlant:Plant = new Plant(iPlantType);
			var iPreferredSeason:int = Plant.GetPreferredSeason(iPlantType);
			var iMaxSaturation:int = oPlant.inSeasonMaxSaturation;
			var iHighToxicity:int = oPlant.highToxicity;
			
			var oSoil:Soil = new Soil(Substrate.TYPE_LOAM);
			var iDeadHighSaturation = iMaxSaturation + 1;  // <- excess saturation
			var iIdealToxicity = iHighToxicity - 1;
			oSoil.saturation = iDeadHighSaturation;
			oSoil.toxicity = iIdealToxicity;
			
			var iExpected:int = -1;
			var iActual:int = PlantService.GetPlantGrowthStrength(oPlant, oSoil, iPreferredSeason);
			
			oResult.expected = String(iExpected);
			oResult.actual = String(iActual);
			oResult.TestEquals();
			
			return oResult;
		}
		
		public static function InSeasonLiveHighSaturation():UnitTestResult
		{
			// plant data can change, so get the existing values and then craft a specific soil object to give the results desired
			var oResult:UnitTestResult = new UnitTestResult("PlantService", "InSeasonLiveHighSaturation");
			var iPlantType:int = Plant.TYPE_CORN;
			var oPlant:Plant = new Plant(iPlantType);
			var iPreferredSeason:int = Plant.GetPreferredSeason(iPlantType);
			var iHighSaturation:int = oPlant.inSeasonHighSaturation;
			var iMaxSaturation:int = oPlant.inSeasonMaxSaturation;
			var iHighToxicity:int = oPlant.highToxicity;
			
			var oSoil:Soil = new Soil(Substrate.TYPE_LOAM);
			var iHighLiveSaturation = (iMaxSaturation + iHighSaturation) / 2;  // <- high side of live saturation
			var iIdealToxicity = iHighToxicity - 1;
			oSoil.saturation = iHighLiveSaturation;
			oSoil.toxicity = iIdealToxicity;
			
			var iExpected:int = 1;
			var iActual:int = PlantService.GetPlantGrowthStrength(oPlant, oSoil, iPreferredSeason);
			
			oResult.expected = String(iExpected);
			oResult.actual = String(iActual);
			oResult.TestEquals();
			
			return oResult;
		}
		
		public static function InSeasonIdeal():UnitTestResult
		{
			// plant data can change, so get the existing values and then craft a specific soil object to give the results desired
			var oResult:UnitTestResult = new UnitTestResult("PlantService", "InSeasonIdeal");
			var iPlantType:int = Plant.TYPE_CORN;
			var oPlant:Plant = new Plant(iPlantType);
			var iPreferredSeason:int = Plant.GetPreferredSeason(iPlantType);
			var iLowSaturation:int = oPlant.inSeasonLowSaturation;
			var iHighSaturation:int = oPlant.inSeasonHighSaturation;
			var iHighToxicity:int = oPlant.highToxicity;
			
			var oSoil:Soil = new Soil(Substrate.TYPE_LOAM);
			var iIdealSaturation = (iHighSaturation + iLowSaturation) / 2;
			var iIdealToxicity = iHighToxicity - 1;
			oSoil.saturation = iIdealSaturation;
			oSoil.toxicity = iIdealToxicity;
			
			var iExpected:int = 2;
			var iActual:int = PlantService.GetPlantGrowthStrength(oPlant, oSoil, iPreferredSeason);
			
			oResult.expected = String(iExpected);
			oResult.actual = String(iActual);
			oResult.TestEquals();
			
			return oResult;
		}
		
		public static function InSeasonLiveLowSaturation():UnitTestResult
		{
			// plant data can change, so get the existing values and then craft a specific soil object to give the results desired
			var oResult:UnitTestResult = new UnitTestResult("PlantService", "InSeasonLiveLowSaturation");
			var iPlantType:int = Plant.TYPE_CORN;
			var oPlant:Plant = new Plant(iPlantType);
			var iPreferredSeason:int = Plant.GetPreferredSeason(iPlantType);
			var iMinSaturation:int = oPlant.inSeasonMinSaturation;
			var iLowSaturation:int = oPlant.inSeasonLowSaturation;
			var iHighToxicity:int = oPlant.highToxicity;
			
			var oSoil:Soil = new Soil(Substrate.TYPE_LOAM);
			var iLowLiveSaturation = (iMinSaturation + iLowSaturation) / 2;  // <- low side of live saturation
			var iIdealToxicity = iHighToxicity - 1;
			oSoil.saturation = iLowLiveSaturation;
			oSoil.toxicity = iIdealToxicity;
			
			var iExpected:int = 1;
			var iActual:int = PlantService.GetPlantGrowthStrength(oPlant, oSoil, iPreferredSeason);
			
			oResult.expected = String(iExpected);
			oResult.actual = String(iActual);
			oResult.TestEquals();
			
			return oResult;
		}
		
		public static function InSeasonDeadLowSaturation():UnitTestResult
		{
			// plant data can change, so get the existing values and then craft a specific soil object to give the results desired
			var oResult:UnitTestResult = new UnitTestResult("PlantService", "InSeasonDeadLowSaturation");
			var iPlantType:int = Plant.TYPE_CORN;
			var oPlant:Plant = new Plant(iPlantType);
			var iPreferredSeason:int = Plant.GetPreferredSeason(iPlantType);
			var iMinSaturation:int = oPlant.inSeasonMinSaturation;
			var iHighToxicity:int = oPlant.highToxicity;
			
			var oSoil:Soil = new Soil(Substrate.TYPE_LOAM);
			var iDeadLowSaturation = iMinSaturation - 1;  // <- not enough saturation
			var iIdealToxicity = iHighToxicity - 1;
			oSoil.saturation = iDeadLowSaturation;
			oSoil.toxicity = iIdealToxicity;
			
			var iExpected:int = -2;
			var iActual:int = PlantService.GetPlantGrowthStrength(oPlant, oSoil, iPreferredSeason);
			
			oResult.expected = String(iExpected);
			oResult.actual = String(iActual);
			oResult.TestEquals();
			
			return oResult;
		}
		
		public static function DeadToxicity():UnitTestResult
		{
			// plant data can change, so get the existing values and then craft a specific soil object to give the results desired
			var oResult:UnitTestResult = new UnitTestResult("PlantService", "DeadToxicity");
			var iPlantType:int = Plant.TYPE_CORN;
			var oPlant:Plant = new Plant(iPlantType);
			var iPreferredSeason:int = Plant.GetPreferredSeason(iPlantType);
			var iLowSaturation:int = oPlant.inSeasonLowSaturation;
			var iHighSaturation:int = oPlant.inSeasonHighSaturation;
			var iMaxToxicity:int = oPlant.maxToxicity;
			
			var oSoil:Soil = new Soil(Substrate.TYPE_LOAM);
			var iIdealSaturation = (iHighSaturation + iLowSaturation) / 2;
			var iDeadToxicity = iMaxToxicity + 1;
			oSoil.saturation = iIdealSaturation;
			oSoil.toxicity = iDeadToxicity;
			
			var iExpected:int = -3;
			var iActual:int = PlantService.GetPlantGrowthStrength(oPlant, oSoil, iPreferredSeason);
			
			oResult.expected = String(iExpected);
			oResult.actual = String(iActual);
			oResult.TestEquals();
			
			return oResult;
		}
		
		public static function LiveToxicity():UnitTestResult
		{
			// plant data can change, so get the existing values and then craft a specific soil object to give the results desired
			var oResult:UnitTestResult = new UnitTestResult("PlantService", "LiveToxicity");
			var iPlantType:int = Plant.TYPE_CORN;
			var oPlant:Plant = new Plant(iPlantType);
			var iPreferredSeason:int = Plant.GetPreferredSeason(iPlantType);
			var iLowSaturation:int = oPlant.inSeasonLowSaturation;
			var iHighSaturation:int = oPlant.inSeasonHighSaturation;
			var iHighToxicity:int = oPlant.highToxicity;
			var iMaxToxicity:int = oPlant.maxToxicity;
			
			var oSoil:Soil = new Soil(Substrate.TYPE_LOAM);
			var iIdealSaturation = (iHighSaturation + iLowSaturation) / 2;
			var iLiveToxicity = (iHighToxicity + iMaxToxicity) / 2;
			oSoil.saturation = iIdealSaturation;
			oSoil.toxicity = iLiveToxicity;
			
			var iExpected:int = 1;
			var iActual:int = PlantService.GetPlantGrowthStrength(oPlant, oSoil, iPreferredSeason);
			
			oResult.expected = String(iExpected);
			oResult.actual = String(iActual);
			oResult.TestEquals();
			
			return oResult;
		}
		
		public static function OutOfSeasonDeadHighSaturation():UnitTestResult
		{
			// plant data can change, so get the existing values and then craft a specific soil object to give the results desired
			var oResult:UnitTestResult = new UnitTestResult("PlantService", "OutOfSeasonDeadHighSaturation");
			var iPlantType:int = Plant.TYPE_CORN;
			var oPlant:Plant = new Plant(iPlantType);
			var iPreferredSeason:int = Plant.GetPreferredSeason(iPlantType);
			var iDifferentSeason:int = iPreferredSeason + 1;
			
			var iMaxSaturation:int = oPlant.outSeasonMaxSaturation;
			var iHighToxicity:int = oPlant.highToxicity;
			
			var oSoil:Soil = new Soil(Substrate.TYPE_LOAM);
			var iDeadHighSaturation = iMaxSaturation + 1;  // <- excess saturation
			var iIdealToxicity = iHighToxicity - 1;
			oSoil.saturation = iDeadHighSaturation;
			oSoil.toxicity = iIdealToxicity;
			
			var iExpected:int = -1;
			var iActual:int = PlantService.GetPlantGrowthStrength(oPlant, oSoil, iDifferentSeason);
			
			oResult.expected = String(iExpected);
			oResult.actual = String(iActual);
			oResult.TestEquals();
			
			return oResult;
		}
		
		public static function OutOfSeasonLive():UnitTestResult
		{
			// plant data can change, so get the existing values and then craft a specific soil object to give the results desired
			var oResult:UnitTestResult = new UnitTestResult("PlantService", "OutOfSeasonLive");
			var iPlantType:int = Plant.TYPE_CORN;
			var oPlant:Plant = new Plant(iPlantType);
			var iPreferredSeason:int = Plant.GetPreferredSeason(iPlantType);
			var iDifferentSeason:int = iPreferredSeason + 1;
			
			var iMinSaturation:int = oPlant.outSeasonMinSaturation;
			var iMaxSaturation:int = oPlant.outSeasonMaxSaturation;
			var iHighToxicity:int = oPlant.highToxicity;
			
			var oSoil:Soil = new Soil(Substrate.TYPE_LOAM);
			var iLiveSaturation = (iMaxSaturation + iMinSaturation) / 2;
			var iIdealToxicity = iHighToxicity - 1;
			oSoil.saturation = iLiveSaturation;
			oSoil.toxicity = iIdealToxicity;
			
			var iExpected:int = 1;
			var iActual:int = PlantService.GetPlantGrowthStrength(oPlant, oSoil, iDifferentSeason);
			
			oResult.expected = String(iExpected);
			oResult.actual = String(iActual);
			oResult.TestEquals();
			
			return oResult;
		}
		
		public static function OutOfSeasonDeadLowSaturation():UnitTestResult
		{
			// plant data can change, so get the existing values and then craft a specific soil object to give the results desired
			var oResult:UnitTestResult = new UnitTestResult("PlantService", "OutOfSeasonDeadLowSaturation");
			var iPlantType:int = Plant.TYPE_CORN;
			var oPlant:Plant = new Plant(iPlantType);
			var iPreferredSeason:int = Plant.GetPreferredSeason(iPlantType);
			var iDifferentSeason:int = iPreferredSeason + 1;
			
			var iMinSaturation:int = oPlant.outSeasonMinSaturation;
			var iHighToxicity:int = oPlant.highToxicity;
			
			var oSoil:Soil = new Soil(Substrate.TYPE_LOAM);
			var iDeadLowSaturation = iMinSaturation - 1;  // <- not enough saturation
			var iIdealToxicity = iHighToxicity - 1;
			oSoil.saturation = iDeadLowSaturation;
			oSoil.toxicity = iIdealToxicity;
			
			var iExpected:int = -2;
			var iActual:int = PlantService.GetPlantGrowthStrength(oPlant, oSoil, iDifferentSeason);
			
			oResult.expected = String(iExpected);
			oResult.actual = String(iActual);
			oResult.TestEquals();
			
			return oResult;
		}
		
		public static function AnySeasonIsInSeasonInSpring():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("PlantService", "AnySeasonIsInSeasonInSpring");
			var iPlantType:int = Plant.TYPE_WILD_GRASS;
			var oPlant:Plant = new Plant(iPlantType);
			
			oResult.expected = "true";
			oResult.actual = String(IsPlantInSeason(oPlant, Time.SEASON_SPRING));
			oResult.TestEquals();
			
			return oResult;
		}
		
		public static function AnySeasonIsInSeasonInSummer():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("PlantService", "AnySeasonIsInSeasonInSummer");
			var iPlantType:int = Plant.TYPE_WILD_GRASS;
			var oPlant:Plant = new Plant(iPlantType);
			
			oResult.expected = "true";
			oResult.actual = String(IsPlantInSeason(oPlant, Time.SEASON_SUMMER));
			oResult.TestEquals();
			
			return oResult;
		}
		
		public static function AnySeasonIsInSeasonInFall():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("PlantService", "AnySeasonIsInSeasonInFall");
			var iPlantType:int = Plant.TYPE_WILD_GRASS;
			var oPlant:Plant = new Plant(iPlantType);
			
			oResult.expected = "true";
			oResult.actual = String(IsPlantInSeason(oPlant, Time.SEASON_FALL));
			oResult.TestEquals();
			
			return oResult;
		}
		
		public static function InSeason():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("PlantService", "InSeason");
			var iPlantType:int = Plant.TYPE_CORN;
			var oPlant:Plant = new Plant(iPlantType);
			
			oResult.expected = "true";
			oResult.actual = String(IsPlantInSeason(oPlant, Time.SEASON_SUMMER));
			oResult.TestEquals();
			
			return oResult;
		}
		
		public static function OutOfSeason():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("PlantService", "OutOfSeason");
			var iPlantType:int = Plant.TYPE_CORN;
			var oPlant:Plant = new Plant(iPlantType);
			
			oResult.expected = "false";
			oResult.actual = String(IsPlantInSeason(oPlant, Time.SEASON_FALL));
			oResult.TestEquals();
			
			return oResult;
		}
		
		public static function GetNonCoverPlantTypesGrowableInTimeReturnsEmptyForBadNumDays():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("PlantService", "GetNonCoverPlantTypesGrowableInTimeReturnsEmptyForBadNumDays");
			var lExpected:Array = new Array();
			var iNumDays:int = -2;
			
			var lActual:Array = PlantService.GetNonCoverPlantTypesGrowableInTime(iNumDays);
			
			oResult.expected = UnitTestResult.PrettyPrintIntList(lExpected);
			oResult.actual = UnitTestResult.PrettyPrintIntList(lActual);
			oResult.TestEquals();
			
			return oResult;
		}
		
		public static function GetNonCoverPlantTypesGrowableInTimeReturnsPlantTypes():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("PlantService", "GetNonCoverPlantTypesGrowableInTimeReturnsPlantTypes");
			var lExpected:Array = [ 0, 1, 3, 4, 5, 6, 11 ];
			var iNumDays:int = 11;
			
			var lActual:Array = PlantService.GetNonCoverPlantTypesGrowableInTime(iNumDays);
			
			oResult.expected = UnitTestResult.PrettyPrintIntList(lExpected);
			oResult.actual = UnitTestResult.PrettyPrintIntList(lActual);
			oResult.TestEquals();
			
			return oResult;
		}
		
		//- Test Methods -//
	}
}