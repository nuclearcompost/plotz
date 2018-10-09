package
{
	import flash.display.MovieClip;
	
	public class Seed extends Item implements IConstantPrice
	{
		// Constants //
		
		public static const DESCRIPTION:Array = [ "Fairly tricky to grow, prefers drier conditions.  10 days to harvest, repeats every 6 days.",
												  "Tolerant and easy to grow.  9 days to harvest.",
												  "Tolerant and fairly easy to grow.  Requires lots of nutrients.  14 days to harvest, repeats every 7 days.",
												  "Very tricky to grow, prefers fairly wet conditions.  11 days to harvest, repeats every 5 days.",
												  "Very easy to grow, doesn't require many nutrients.  8 days to harvest.",
												  "Tolerant, easy to grow.  Requires a fair amount of nutrients.  9 days to harvest.",
												  "Tolerant, fairly easy to grow.  Low nutrient requirements, and grows quickly.  7 days to harvest.",
												  "Tolerant of wetter conditions, fairly easy to grow.  12 days to harvest.",
												  "Fairly tricky to grow.  Requires very wet conditions, lots of water and nutrients.  17 days to harvest, repeats every 9 days.",
												  "Basic cover crop, prevents soil erosion.",
												  "Excellent for low Nitrogen soil, and accommodates drier conditions.  12 days to harvest, repeats every 7 days.",
												  "Easy to grow, but has high Phosphorus needs.  11 days to harvest.",
												  "Cover crop which helps remove toxic chemicals from the soil.",
												  "Fairly tricky to grow, but thrives in dry conditions.  12 days to harvest."
												];
		
		public static const NAME:Array = [ "Asparagus Seed", "Carrot Seed", "Corn Seed", "Eggplant Seed", "Garlic Seed", "Lettuce Seed", "Onion Seed", "Potato Seed", "Pumpkin Seed", "Wild Grass Seed",
										   "Alfalfa Seed", "Broccoli Seed", "Clover Seed", "Sweet Potato Seed" ];
		
		public static const PRICE:Array = [ 25, 10, 15, 20, 5, 10, 10, 15, 20, 1, 10, 15, 5, 20 ];
		
		public static const TYPE_ASPARAGUS:int = 0;
		public static const TYPE_CARROT:int = 1;
		public static const TYPE_CORN:int = 2;
		public static const TYPE_EGGPLANT:int = 3;
		public static const TYPE_GARLIC:int = 4;
		public static const TYPE_LETTUCE:int = 5;
		public static const TYPE_ONION:int = 6;
		public static const TYPE_POTATO:int = 7;
		public static const TYPE_PUMPKIN:int = 8;
		public static const TYPE_WILD_GRASS:int = 9;
		public static const TYPE_ALFALFA:int = 10;
		public static const TYPE_BROCCOLI:int = 11;
		public static const TYPE_CLOVER:int = 12;
		public static const TYPE_SWEET_POTATO:int = 13;
		
		private static const DIFFICULTY:Array = [ "Doable", "Easy", "Average", "Challenging", "Very Easy", "Easy", "Easy", "Average",
												  "Doable", "Very Easy", "Doable", "Easy", "Very Easy", "Easy" ];
		
		//- Constants -//
		
		
		// Public Properties //
		
		public override function get name():String
		{
			return Seed.NAME[_type];
		}
		
		public override function get priceModifier():int
		{
			return _priceModifier;
		}
		
		public override function set priceModifier(value:int):void
		{
			_priceModifier = value;
		}
		
		public override function get type():int
		{
			return _type;
		}
		
		public function set type(value:int):void
		{
			_type = value;
		}
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		private var _priceModifier:int;
		private var _type:int;
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function Seed(type:int = 0, priceModifier:int = -1)
		{
			_type = type;
			
			_priceModifier = priceModifier;
			
			if (_priceModifier == -1)
			{
				_priceModifier = ItemPricingService.PRICE_MOD_STANDARD;
			}
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		public function GetGraphics():MovieClip
		{
			var oGraphics:MovieClip = new Seed_MC();
			oGraphics.gotoAndStop(_type + 1);
			return oGraphics;
		}
		
		public override function GetItemGraphics():MovieClip
		{
			var mcItem:MovieClip = this.GetGraphics();
			
			return mcItem;
		}
		
		//---------------
		//Purpose:		Get a movieclip to display on the MainUI panel that represents the preview of this object
		//
		//Parameters:
		//	season:int = the current season
		//
		//Returns:		a movieClip representation of a preview of this object for display on the Main UI panel
		//---------------
		public function GetPreviewGraphics(season:int):MovieClip
		{
			var oGraphics:MovieClip = new MovieClip();
			
			// background
			var oBackground:SeedPreview_MC = new SeedPreview_MC();
			oBackground.Seed.text = name;
			
			var iDaysToHarvest:int = Plant.GetDaysToHarvest(_type);
			var iDaysToRepeatHarvest:int = Plant.GetDaysToRepeatHarvest(_type);
			var sDaysToHarvest:String = String(iDaysToHarvest);
			
			if (iDaysToRepeatHarvest > 0)
			{
				sDaysToHarvest += ", then every ";
				sDaysToHarvest += String(iDaysToRepeatHarvest);
			}
			
			oBackground.DaysToHarvest.text = sDaysToHarvest;
			oBackground.Difficulty.text = String(Seed.DIFFICULTY[_type]);
			oGraphics.addChild(oBackground);
			
			// seed picture
			var oSeedGraphics:Seed_MC = new Seed_MC();
			oSeedGraphics.gotoAndStop(_type + 1);
			oGraphics.addChild(oSeedGraphics);
			
			// nutrient needs bars
			var oNutrientSet:NutrientSet = Plant.GetTotalNutrientSet(_type);
			
			var oVerticalBar:VerticalBar = new VerticalBar(15, 90, oNutrientSet.n1, 100, 0x016701, 0x016701, 0xFFFF99);
			var mcVerticalBar:MovieClip = oVerticalBar.Paint();
			mcVerticalBar.x = 15;
			mcVerticalBar.y = 165;
			oGraphics.addChild(mcVerticalBar);
			
			oVerticalBar = new VerticalBar(15, 90, oNutrientSet.n2, 100, 0xFF9A33, 0xFF9A33, 0xFFFF99);
			mcVerticalBar = oVerticalBar.Paint();
			mcVerticalBar.x = 30;
			mcVerticalBar.y = 165;
			oGraphics.addChild(mcVerticalBar);
			
			oVerticalBar = new VerticalBar(15, 90, oNutrientSet.n3, 100, 0x6767FF, 0x6767FF, 0xFFFF99);
			mcVerticalBar = oVerticalBar.Paint();
			mcVerticalBar.x = 45;
			mcVerticalBar.y = 165;
			oGraphics.addChild(mcVerticalBar);
			
			
			// water needs bar
			var lWaterLevels:Array = new Array();
			var lColors:Array = new Array();
			var iNormalize:int = Substrate.MAX_SATURATION[Substrate.TYPE_CLAY];
			var iBarHeight:int = 90;
			
			if (PlantService.IsPlantInSeason(new Plant(_type), season) == true)
			{
				lWaterLevels[0] = (iNormalize - Plant.GetInSeasonMaxSaturation(_type)) / iNormalize * iBarHeight;
				lWaterLevels[1] = (iNormalize - Plant.GetInSeasonHighSaturation(_type)) / iNormalize * iBarHeight;
				lWaterLevels[2] = (iNormalize - Plant.GetInSeasonLowSaturation(_type)) / iNormalize * iBarHeight;
				lWaterLevels[3] = (iNormalize - Plant.GetInSeasonMinSaturation(_type)) / iNormalize * iBarHeight;
				lWaterLevels[4] = iBarHeight;
				
				lColors[0] = 0xFF0000;
				lColors[1] = 0xFFFF00;
				lColors[2] = 0x00FF00;
				lColors[3] = 0xFFFF00;
				lColors[4] = 0xFF0000;
			}
			else
			{
				lWaterLevels[0] = (iNormalize - Plant.GetOutSeasonMaxSaturation(_type)) / iNormalize * iBarHeight;
				lWaterLevels[1] = (iNormalize - Plant.GetOutSeasonMinSaturation(_type)) / iNormalize * iBarHeight;
				lWaterLevels[2] = iBarHeight;
				
				lColors[0] = 0xFF0000;
				lColors[1] = 0xFFFF00;
				lColors[2] = 0xFF0000;
			}
			
			var oMultiColorBar:MultiColorVerticalBar = new MultiColorVerticalBar(15, lWaterLevels, lColors);
			var mcSaturationBar:MovieClip = oMultiColorBar.Paint();
			mcSaturationBar.x = 80;
			mcSaturationBar.y = 165;
			oGraphics.addChild(mcSaturationBar);
			
			var lToxicityLevels:Array = new Array();
			lColors = new Array();
			
			lToxicityLevels[0] = (iNormalize - Plant.GetMaxToxicity(_type)) / iNormalize * iBarHeight;
			lToxicityLevels[1] = (iNormalize - Plant.GetHighToxicity(_type)) / iNormalize * iBarHeight;
			lToxicityLevels[2] = iBarHeight;
			
			lColors[0] = 0xFF0000;
			lColors[1] = 0xFFFF00;
			lColors[2] = 0x00FF00;
			
			oMultiColorBar = new MultiColorVerticalBar(15, lToxicityLevels, lColors);
			var mcToxicityBar:MovieClip = oMultiColorBar.Paint();
			mcToxicityBar.x = 130;
			mcToxicityBar.y = 165;
			oGraphics.addChild(mcToxicityBar);
			
			return oGraphics;
		}
		
		public function GetPrice():int
		{
			return Seed.PRICE[_type];
		}
		
		//* Public Methods *//
		
		
		// Protected Methods:
	}
}