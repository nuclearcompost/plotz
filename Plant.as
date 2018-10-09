package
{
	import flash.display.MovieClip
	import flash.utils.getDefinitionByName;
	
	public class Plant extends Item implements IMicrobeHost
	{
		// Constants //
		public static const NAME:Array = [ "Asparagus", "Carrot", "Corn", "Eggplant", "Garlic", "Lettuce", "Onion", "Potato", "Pumpkin", "Wild Grass",
										   "Alfalfa", "Broccoli", "Clover", "Sweet Potato" ];
		
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

		public static const STAGES:Array = [ "Seed", "Seedling", "Growing", "Flowering", "Producing", "Ready for Harvest", "Mature" ];
		public static const STAGE_SEED:int= 0;
		public static const STAGE_SEEDLING:int = 1;
		public static const STAGE_GROWING:int = 2;
		public static const STAGE_FLOWERING:int = 3;
		public static const STAGE_PRODUCING:int = 4;
		public static const STAGE_READY_FOR_HARVEST:int = 5;
		public static const STAGE_MATURE:int = 6;
		
		public static const CLASSES:Array = [ Plant.CLASS_GARDEN, Plant.CLASS_GARDEN, Plant.CLASS_FIELD, Plant.CLASS_GARDEN, Plant.CLASS_GARDEN, Plant.CLASS_GARDEN, Plant.CLASS_GARDEN, 
											  Plant.CLASS_GARDEN, Plant.CLASS_GARDEN, Plant.CLASS_COVER, Plant.CLASS_GARDEN, Plant.CLASS_GARDEN, Plant.CLASS_COVER, Plant.CLASS_GARDEN ];
		public static const CLASS_COVER:int = 0;
		public static const CLASS_GARDEN:int = 1;
		public static const CLASS_FIELD:int = 2;
		public static const CLASS_CASH:int = 3;
		
		public static const GROWSTYLE_SIMPLE:int = 0;
		public static const GROWSTYLE_NOFLOWER_ONCE:int = 1;
		public static const GROWSTYLE_FLOWER_ONCE:int = 2;
		public static const GROWSTYLE_NOFLOWER_REPEAT:int = 3;
		public static const GROWSTYLE_FLOWER_REPEAT:int = 4;
		public static const GROWSTYLE_NOFLOWER_WHOLE_REPEAT:int = 5;
		public static const GROWSTYLE_NOFLOWER_WHOLE_ONCE:int = 6;
		public static const GROWSTYLE_FLOWER_WHOLE_ONCE:int = 7;
		public static const GROWSTYLE_FLOWER_WHOLE_REPEAT:int = 8;
		
		private static const GROWSTYLE_STAGES:Array = [ [ Plant.STAGE_SEED, Plant.STAGE_SEEDLING, Plant.STAGE_GROWING, Plant.STAGE_MATURE ],
													    [ Plant.STAGE_SEED, Plant.STAGE_SEEDLING, Plant.STAGE_GROWING, Plant.STAGE_PRODUCING, Plant.STAGE_READY_FOR_HARVEST, Plant.STAGE_MATURE ],
													    [ Plant.STAGE_SEED, Plant.STAGE_SEEDLING, Plant.STAGE_GROWING, Plant.STAGE_FLOWERING, Plant.STAGE_PRODUCING, Plant.STAGE_READY_FOR_HARVEST, Plant.STAGE_MATURE ],
													    [ Plant.STAGE_SEED, Plant.STAGE_SEEDLING, Plant.STAGE_GROWING, Plant.STAGE_PRODUCING, Plant.STAGE_READY_FOR_HARVEST ],
													    [ Plant.STAGE_SEED, Plant.STAGE_SEEDLING, Plant.STAGE_GROWING, Plant.STAGE_FLOWERING, Plant.STAGE_PRODUCING, Plant.STAGE_READY_FOR_HARVEST ],
													    [ Plant.STAGE_SEED, Plant.STAGE_SEEDLING, Plant.STAGE_GROWING, Plant.STAGE_PRODUCING, Plant.STAGE_READY_FOR_HARVEST ],
														[ Plant.STAGE_SEED, Plant.STAGE_SEEDLING, Plant.STAGE_GROWING, Plant.STAGE_PRODUCING, Plant.STAGE_READY_FOR_HARVEST ],
														[ Plant.STAGE_SEED, Plant.STAGE_SEEDLING, Plant.STAGE_GROWING, Plant.STAGE_FLOWERING, Plant.STAGE_PRODUCING, Plant.STAGE_READY_FOR_HARVEST ],
														[ Plant.STAGE_SEED, Plant.STAGE_SEEDLING, Plant.STAGE_GROWING, Plant.STAGE_FLOWERING, Plant.STAGE_PRODUCING, Plant.STAGE_READY_FOR_HARVEST ]
													  ];
		
		private static const GROWSTYLE_REPEATER_STAGE:Array = [ -1,
															    -1,
															    -1,
															    Plant.STAGE_PRODUCING,
															    Plant.STAGE_FLOWERING,
															    Plant.STAGE_GROWING,
																-1,
																-1,
																Plant.STAGE_GROWING
															  ];
		
		private static const GRFX_NAME:Array = [ "Asparagus", "Carrot", "Corn", "Eggplant", "Garlic", "Lettuce", "Onion", "Potato", "Pumpkin", "WildGrass",
												 "Alfalfa", "Broccoli", "Clover", "SweetPotato" ];
				
		private static const GROWSTYLE:Array = [ Plant.GROWSTYLE_NOFLOWER_WHOLE_REPEAT,
												 Plant.GROWSTYLE_NOFLOWER_WHOLE_ONCE,
												 Plant.GROWSTYLE_FLOWER_REPEAT,
												 Plant.GROWSTYLE_FLOWER_REPEAT,
												 Plant.GROWSTYLE_NOFLOWER_WHOLE_ONCE,
												 Plant.GROWSTYLE_NOFLOWER_WHOLE_ONCE,
												 Plant.GROWSTYLE_NOFLOWER_WHOLE_ONCE,
												 Plant.GROWSTYLE_FLOWER_WHOLE_ONCE,
												 Plant.GROWSTYLE_FLOWER_REPEAT,
												 Plant.GROWSTYLE_SIMPLE,
												 Plant.GROWSTYLE_NOFLOWER_WHOLE_REPEAT,
												 Plant.GROWSTYLE_NOFLOWER_WHOLE_ONCE,
												 Plant.GROWSTYLE_SIMPLE,
												 Plant.GROWSTYLE_FLOWER_WHOLE_ONCE
											   ];
		
		private static const IN_MAX_SATURATION:Array = [ 57,
													     86,
													     79,
													     64,
													     93,
													     86,
													     86,
													     79,
													     86,
													     93,
													     64,
													     86,
													     93,
													     50
													   ];
		
		private static const OUT_MAX_SATURATION:Array = [ 43,
														  71,
														  64,
														  57,
														  86,
														  71,
														  64,
														  57,
														  79,
														  86,
														  50,
														  71,
														  86,
														  43
														];
		
		private static const IN_HIGH_SATURATION:Array = [ 43,
													      71,
													      64,
													      57,
													      86,
													      71,
													      64,
													      57,
													      79,
													      86,
													      50,
													      71,
													      86,
													      43
													    ];
		
		private static const IN_LOW_SATURATION:Array = [ 29,
													     36,
													     43,
													     50,
													     21,
													     36,
													     43,
													     36,
													     64,
													     14,
													     29,
													     36,
													     21,
													     29
													   ];
		
		private static const OUT_MIN_SATURATION:Array = [ 29,
														  36,
														  43,
														  50,
														  21,
														  36,
														  43,
														  36,
														  64,
														  14,
														  29,
														  36,
														  21,
														  29
														];		
		
		private static const IN_MIN_SATURATION:Array = [ 14,
													     21,
													     29,
													     43,
													     14,
													     21,
													     21,
													     29,
													     50,
													     7,
													     14,
													     21,
													     14,
													     7
													   ];
		
		private static const WATER_ABSORBED:Array = [ [ 0, 0, 1.5, 0, 1.5, 0.5, 0 ],
													  [ 0, 0, 1, 0, 1, 0.5, 0 ],
													  [ 0, 0, 1.5, 1, 2, 0.5, 0 ],
													  [ 0, 0, 1, 1, 1.5, 0.5, 0 ],
													  [ 0, 0, 1, 0, 0.5, 0.5, 0 ],
													  [ 0, 0, 0.5, 0, 1, 0.5, 0 ],
													  [ 0, 0, 1, 0, 1, 0.5, 0 ],
													  [ 0, 0, 1, 1, 1, 0.5, 0 ],
													  [ 0, 0, 1, 0.5, 2, 0.5, 0 ],
													  [ 0, 0, 0.5, 0, 0, 0, 0 ],
													  [ 0, 0, 1, 0, 0.5, 0.5, 0 ],
													  [ 0, 0, 1, 0, 1, 0.5, 0 ],
													  [ 0, 0, 0.5, 0, 0, 0, 0 ],
													  [ 0, 0, 1, 0.5, 1, 0.5, 0 ]
													];
				
		private static const NUT1_IDEAL:Array = [ [ 1, 1, 8, 0, 8, 0, 0 ],
												  [ 1, 1, 6, 0, 6, 0, 0 ],
												  [ 1, 1, 8, 8, 8, 0, 0 ],
												  [ 1, 1, 6, 6, 6, 0, 0 ],
												  [ 1, 1, 6, 0, 6, 0, 0 ],
												  [ 1, 1, 8, 0, 8, 0, 0 ],
												  [ 1, 1, 6, 0, 6, 0, 0 ],
												  [ 1, 1, 8, 8, 8, 0, 0 ],
												  [ 1, 1, 8, 8, 6, 0, 0 ],
												  [ 1, 1, 4, 0, 0, 0, 0 ],
												  [ 1, 1, 2, 0, 2, 2, 0 ],
												  [ 1, 1, 6, 0, 6, 6, 0 ],
												  [ 1, 1, 4, 0, 0, 0, 0 ],
												  [ 1, 1, 6, 6, 6, 6, 0 ]
												];
		
		private static const NUT1_LIVE:Array = [ [ 0, 0, 6, 0, 6, 0, 0 ],
												 [ 0, 0, 4.5, 0, 4.5, 0, 0 ],
												 [ 0, 0, 6, 6, 6, 0, 0 ],
												 [ 0, 0, 4.5, 4.5, 4.5, 0, 0 ],
												 [ 0, 0, 4.5, 0, 4.5, 0, 0 ],
												 [ 0, 0, 6, 0, 6, 0, 0 ],
												 [ 0, 0, 4.5, 0, 4.5, 0, 0 ],
												 [ 0, 0, 6, 6, 6, 0, 0 ],
												 [ 0, 0, 6, 6, 4.5, 0, 0 ],
												 [ 1, 1, 3, 0, 0, 0, 0 ],
												 [ 0, 0, 1.5, 0, 1.5, 0, 0 ],
												 [ 0, 0, 4.5, 0, 4.5, 0, 0 ],
												 [ 1, 1, 3, 0, 0, 0, 0 ],
												 [ 0, 0, 4.5, 4.5, 4.5, 0, 0 ]
											   ];
		
		private static const NUT1_NEED:Array = [ [ 1, 3, 32, 0, 16, 0, 0 ],
												 [ 1, 2, 24, 0, 12, 0, 0 ],
												 [ 1, 3, 24, 24, 32, 0, 0 ],
												 [ 1, 2, 18, 12, 18, 0, 0 ],
												 [ 1, 2, 24, 0, 6, 0, 0 ],
												 [ 1, 2, 32, 0, 16, 0, 0 ],
												 [ 1, 2, 18, 0, 6, 0, 0 ],
												 [ 1, 3, 32, 16, 16, 0, 0 ],
												 [ 1, 3, 32, 24, 36, 0, 0 ],
												 [ 1, 1, 8, 0, 0, 0, 0 ],
												 [ 1, 4, 8, 0, 6, 0, 0 ],
												 [ 1, 2, 30, 0, 18, 0, 0 ],
												 [ 1, 1, 12, 0, 0, 0, 0 ],
												 [ 1, 2, 24, 12, 18, 0, 0 ]
											   ];
		
		private static const NUT2_IDEAL:Array = [ [ 1, 1, 6, 0, 6, 0, 0 ],
												  [ 1, 1, 4, 0, 4, 0, 0 ],
												  [ 1, 1, 8, 8, 8, 0, 0 ],
												  [ 1, 1, 8, 8, 8, 0, 0 ],
												  [ 1, 1, 6, 0, 6, 0, 0 ],
												  [ 1, 1, 8, 0, 8, 0, 0 ],
												  [ 1, 1, 6, 0, 6, 0, 0 ],
												  [ 1, 1, 8, 8, 8, 0, 0 ],
												  [ 1, 1, 6, 6, 6, 0, 0 ],
												  [ 1, 1, 4, 0, 0, 0, 0 ],
												  [ 1, 1, 6, 0, 6, 0, 0 ],
												  [ 1, 1, 8, 0, 8, 0, 0 ],
												  [ 1, 1, 4, 0, 0, 0, 0 ],
												  [ 1, 1, 4, 4, 4, 0, 0 ]
												];
		
		private static const NUT2_LIVE:Array = [ [ 0, 0, 4.5, 0, 4.5, 0, 0 ],
												 [ 0, 0, 3, 0, 3, 0, 0 ],
												 [ 0, 0, 6, 6, 6, 0, 0 ],
												 [ 0, 0, 6, 6, 6, 0, 0 ],
												 [ 0, 0, 4.5, 0, 4.5, 0, 0 ],
												 [ 0, 0, 6, 0, 6, 0, 0 ],
												 [ 0, 0, 4.5, 0, 4.5, 0, 0 ],
												 [ 0, 0, 6, 6, 6, 0, 0 ],
												 [ 0, 0, 4.5, 4.5, 4.5, 0, 0 ],
												 [ 1, 1, 3, 0, 0, 0, 0 ],
												 [ 0, 0, 4.5, 0, 4.5, 0, 0 ],
												 [ 0, 0, 6, 0, 6, 0, 0 ],
												 [ 1, 1, 3, 0, 0, 0, 0 ],
												 [ 0, 0, 3, 3, 3, 0, 0 ]
											   ];
		
		private static const NUT2_NEED:Array = [ [ 1, 3, 24, 0, 12, 0, 0 ],
												 [ 1, 2, 16, 0, 8, 0, 0 ],
												 [ 1, 3, 24, 24, 32, 0, 0 ],
												 [ 1, 2, 24, 16, 24, 0, 0 ],
												 [ 1, 2, 24, 0, 6, 0, 0 ],
												 [ 1, 2, 32, 0, 16, 0, 0 ],
												 [ 1, 2, 18, 0, 6, 0, 0 ],
												 [ 1, 3, 32, 16, 16, 0, 0 ],
												 [ 1, 3, 24, 18, 36, 0, 0 ],
												 [ 1, 1, 8, 0, 0, 0, 0 ],
												 [ 1, 4, 24, 0, 18, 0, 0 ],
												 [ 1, 2, 40, 0, 24, 0, 0 ],
												 [ 1, 1, 12, 0, 0, 0, 0 ],
												 [ 1, 2, 16, 8, 12, 0, 0 ]
											   ];
		
		private static const NUT3_IDEAL:Array = [ [ 1, 1, 6, 0, 6, 0, 0 ],
												  [ 1, 1, 4, 0, 4, 0, 0 ],
												  [ 1, 1, 8, 8, 8, 0, 0 ],
												  [ 1, 1, 8, 8, 8, 0, 0 ],
												  [ 1, 1, 6, 0, 6, 0, 0 ],
												  [ 1, 1, 8, 0, 8, 0, 0 ],
												  [ 1, 1, 6, 0, 6, 0, 0 ],
												  [ 1, 1, 8, 8, 8, 0, 0 ],
												  [ 1, 1, 6, 6, 6, 0, 0 ],
												  [ 1, 1, 4, 0, 0, 0, 0 ],
												  [ 1, 1, 6, 0, 6, 0, 0 ],
												  [ 1, 1, 6, 0, 6, 0, 0 ],
												  [ 1, 1, 4, 0, 0, 0, 0 ],
												  [ 1, 1, 8, 8, 8, 0, 0 ]
												];
		
		private static const NUT3_LIVE:Array = [ [ 0, 0, 4.5, 0, 4.5, 0, 0 ],
												 [ 0, 0, 3, 0, 3, 0, 0 ],
												 [ 0, 0, 6, 6, 6, 0, 0 ],
												 [ 0, 0, 6, 6, 6, 0, 0 ],
												 [ 0, 0, 4.5, 0, 4.5, 0, 0 ],
												 [ 0, 0, 6, 0, 6, 0, 0 ],
												 [ 0, 0, 4.5, 0, 4.5, 0, 0 ],
												 [ 0, 0, 6, 6, 6, 0, 0 ],
												 [ 0, 0, 4.5, 4.5, 4.5, 0, 0 ],
												 [ 1, 1, 3, 0, 0, 0, 0 ],
												 [ 0, 0, 4.5, 0, 4.5, 0, 0 ],
												 [ 0, 0, 4.5, 0, 4.5, 0, 0 ],
												 [ 1, 1, 3, 0, 0, 0, 0 ],
												 [ 0, 0, 6, 6, 6, 0, 0 ]
											   ];
		
		private static const NUT3_NEED:Array = [ [ 1, 3, 24, 0, 12, 0, 0 ],
												 [ 1, 2, 16, 0, 8, 0, 0 ],
												 [ 1, 3, 24, 24, 32, 0, 0 ],
												 [ 1, 2, 24, 16, 24, 0, 0 ],
												 [ 1, 2, 24, 0, 6, 0, 0 ],
												 [ 1, 2, 32, 0, 16, 0, 0 ],
												 [ 1, 2, 18, 0, 6, 0, 0 ],
												 [ 1, 3, 32, 16, 16, 0, 0 ],
												 [ 1, 3, 24, 18, 36, 0, 0 ],
												 [ 1, 1, 8, 0, 0, 0, 0 ],
												 [ 1, 4, 24, 0, 18, 0, 0 ],
												 [ 1, 2, 30, 0, 18, 0, 0 ],
												 [ 1, 1, 12, 0, 0, 0, 0 ],
												 [ 1, 2, 32, 16, 24, 0, 0 ]
											   ];
													
		private static const HIGH_TOXICITY:Array = [ 15,
													 30,
													 45,
													 15,
													 30,
													 30,
													 30,
													 45,
													 45,
													 60,
												     45,
												     45,
												     75,
												 	 30
												   ];
		
		private static const MAX_TOXICITY:Array = [ 45,
													45,
													60,
													30,
													45,
													45,
													45,
													60,
													60,
													75,
												    60,
												    60,
												    95,
												 	60
												  ];
		
		//- Constants -//
		
		
		// Public Properties

		public function get fruit():Fruit
		{
			return _fruit;
		}
		
		public function set fruit(value:Fruit):void
		{
			if (value == null)
			{
				_fruit = null;
			}
			else
			{
				_fruit = new Fruit(value.type, value.age, value.condition, value.quality);
			}
		}
		
		public function get growthStage():int
		{
			return _growthStage;
		}
		
		public function set growthStage(value:int):void
		{
			_growthStage = value;
		}
		
		public function get growthStyle():int
		{
			return Plant.GROWSTYLE[_type];
		}
		
		public function get highToxicity():int
		{
			return Plant.HIGH_TOXICITY[_type];
		}
		
		public function get inSeasonHighSaturation():int
		{
			return Plant.IN_HIGH_SATURATION[_type];
		}
		
		public function get inSeasonLowSaturation():int
		{
			return Plant.IN_LOW_SATURATION[_type];
		}
		
		public function get inSeasonMaxSaturation():int
		{
			return Plant.IN_MAX_SATURATION[_type];
		}
		
		public function get inSeasonMinSaturation():int
		{
			return Plant.IN_MIN_SATURATION[_type];
		}
		
		public function get isOrganic():Boolean
		{
			return _isOrganic;
		}
		
		public function set isOrganic(value:Boolean):void
		{
			_isOrganic = value;
		}		
		
		public function get maxToxicity():int
		{
			return Plant.MAX_TOXICITY[_type];
		}
		
		public override function get name():String
		{
			return Plant.NAME[_type];
		}
		
		public function get nutrient1():int
		{
			return _nutrient1;
		}
		
		public function set nutrient1(value:int):void
		{
			_nutrient1 = value;
		}
		
		public function get nutrient2():int
		{
			return _nutrient2;
		}
		
		public function set nutrient2(value:int):void
		{
			_nutrient2 = value;
		}
		
		public function get nutrient3():int
		{
			return _nutrient3;
		}
		
		public function set nutrient3(value:int):void
		{
			_nutrient3 = value;
		}
		
		public function get outSeasonMaxSaturation():int
		{
			return Plant.OUT_MAX_SATURATION[_type];
		}
		
		public function get outSeasonMinSaturation():int
		{
			return Plant.OUT_MIN_SATURATION[_type];
		}
		
		public override function get priceModifier():int
		{
			return _priceModifier;
		}
		
		public override function set priceModifier(value:int):void
		{
			_priceModifier = value;
		}
		
		public function get toxicity():Number
		{
			return _toxicity;
		}
		
		public function set toxicity(value:Number):void
		{
			_toxicity = value;
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
		private var _fruit:Fruit;
		private var _growthStage:int;
		private var _isOrganic:Boolean;
		private var _nutrient1:int;
		private var _nutrient2:int;
		private var _nutrient3:int;
		private var _priceModifier:int;
		private var _toxicity:Number;
		private var _type:int;
		
		//- Private Properties -//
		
	
		// Initialization //
		public function Plant(type:int = 0, growthStage:int = Plant.STAGE_SEED, fruit:Fruit = null, priceModifier:int = -1, isOrganic:Boolean = true, toxicity:Number = 0.0)
		{
			_type = type;
			_growthStage = growthStage;
			_fruit = fruit;
			_priceModifier = priceModifier;
			_isOrganic = isOrganic;
			_toxicity = toxicity;
			
			if (_priceModifier == -1)
			{
				_priceModifier == ItemPricingService.PRICE_MOD_STANDARD;
			}
			
			_nutrient1 = 0;
			_nutrient2 = 0;
			_nutrient3 = 0;
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		/// Static Methods ///
		
		public static function GetClass(type:int):int
		{
			return Plant.CLASSES[type];
		}		
		
		public static function GetDaysToHarvest(type:int):int
		{
			var iDays:int = 0;
			
			for (var i:int = 0; i < Plant.STAGE_READY_FOR_HARVEST; i++)
			{
				if (Plant.NUT1_NEED[type][i] == 0)
				{
					continue;
				}
				
				iDays += Plant.NUT1_NEED[type][i] / Plant.NUT1_IDEAL[type][i];
			}
			
			return iDays;
		}
		
		public static function GetDaysToRepeatHarvest(type:int):int
		{
			var iDays:int = 0;
			
			var iGrowStyle:int = Plant.GROWSTYLE[type];
			var iRepeaterStage:int = Plant.GROWSTYLE_REPEATER_STAGE[iGrowStyle];
			
			if (iRepeaterStage == -1)
			{
				return -1;
			}
			
			for (var i:int = iRepeaterStage; i < Plant.STAGE_READY_FOR_HARVEST; i++)
			{
				if (Plant.NUT1_NEED[type][i] == 0)
				{
					continue;
				}
				
				iDays += Plant.NUT1_NEED[type][i] / Plant.NUT1_IDEAL[type][i];
			}
			
			return iDays;
		}
		
		public static function GetHighToxicity(type:int):int
		{
			return Plant.HIGH_TOXICITY[type];
		}
		
		public static function GetInSeasonHighSaturation(type:int):int
		{
			return Plant.IN_HIGH_SATURATION[type];
		}
		
		public static function GetInSeasonLowSaturation(type:int):int
		{
			return Plant.IN_LOW_SATURATION[type];
		}
		
		public static function GetInSeasonMaxSaturation(type:int):int
		{
			return Plant.IN_MAX_SATURATION[type];
		}
		
		public static function GetInSeasonMinSaturation(type:int):int
		{
			return Plant.IN_MIN_SATURATION[type];
		}
		
		public static function GetMaxToxicity(type:int):int
		{
			return Plant.MAX_TOXICITY[type];
		}
		
		public function GetNutrientsAbsorbedSoFar():NutrientSet
		{
			var oNutrientSet:NutrientSet = new NutrientSet();
			
			for (var stage:int = 0; stage < _growthStage; stage++)
			{
				oNutrientSet.n1 += Plant.NUT1_NEED[_type][stage];
				oNutrientSet.n2 += Plant.NUT2_NEED[_type][stage];
				oNutrientSet.n3 += Plant.NUT3_NEED[_type][stage];
			}
			
			oNutrientSet.n1 += _nutrient1;
			oNutrientSet.n2 += _nutrient2;
			oNutrientSet.n3 += _nutrient3;
			
			return oNutrientSet;
		}
		
		public static function GetOutSeasonMaxSaturation(type:int):int
		{
			return Plant.OUT_MAX_SATURATION[type];
		}
		
		public static function GetOutSeasonMinSaturation(type:int):int
		{
			return Plant.OUT_MIN_SATURATION[type];
		}
		
		public function GetPredictedDaysToHarvest():int
		{
			if (Plant.GetClass(_type) == Plant.CLASS_COVER)
			{
				return -1;
			}
			
			if (_growthStage >= STAGE_READY_FOR_HARVEST)
			{
				return -1;
			}
			
			var iNutrient1:int = _nutrient1;
			
			if (_growthStage == Plant.STAGE_PRODUCING)
			{
				iNutrient1 += _fruit.nutrients.n1;
			}
			
			var iDays:int = Math.ceil((Plant.NUT1_NEED[_type][_growthStage] - iNutrient1) / Plant.NUT1_IDEAL[_type][_growthStage]);
			
			for (var i:int = _growthStage + 1; i < Plant.STAGE_READY_FOR_HARVEST; i++)
			{
				if (Plant.NUT1_NEED[type][i] == 0)
				{
					continue;
				}
				
				iDays += Plant.NUT1_NEED[_type][i] / Plant.NUT1_IDEAL[_type][i];
			}
			
			return iDays;
		}
		
		public static function GetPreferredSeason(type:int):int
		{
			var iPreferredSeason:int = Time.SEASON_ANY;
			
			switch (type)
			{
				case Plant.TYPE_ALFALFA:
				case Plant.TYPE_ASPARAGUS:
				case Plant.TYPE_LETTUCE:
				case Plant.TYPE_ONION:
					iPreferredSeason = Time.SEASON_SPRING;
					break;
				case Plant.TYPE_CARROT:
				case Plant.TYPE_CORN:
				case Plant.TYPE_EGGPLANT:
				case Plant.TYPE_SWEET_POTATO:
					iPreferredSeason = Time.SEASON_SUMMER;
					break;
				case Plant.TYPE_GARLIC:
				case Plant.TYPE_POTATO:
				case Plant.TYPE_PUMPKIN:
				case Plant.TYPE_BROCCOLI:
					iPreferredSeason = Time.SEASON_FALL;
					break;
				default:
					break;
			}
			
			return iPreferredSeason;
		}
		
		public static function GetTotalNutrientSet(type:int):NutrientSet
		{
			var oNutrientSet:NutrientSet = new NutrientSet();
			
			for (var i:int = 0; i < Plant.NUT1_NEED[type].length; i++)
			{
				oNutrientSet.n1 += Plant.NUT1_NEED[type][i];
				oNutrientSet.n2 += Plant.NUT2_NEED[type][i];
				oNutrientSet.n3 += Plant.NUT3_NEED[type][i];
			}
			
			return oNutrientSet;
		}
		
		public static function GetTotalNutrientsNeeded(type:int):Number
		{
			var nTotalNutrientsNeeded:Number = 0;
			
			for (var i:int = 0; i < Plant.NUT1_NEED[type].length; i++)
			{
				nTotalNutrientsNeeded += Plant.NUT1_NEED[type][i];
				nTotalNutrientsNeeded += Plant.NUT2_NEED[type][i];
				nTotalNutrientsNeeded += Plant.NUT3_NEED[type][i];
			}
			
			return nTotalNutrientsNeeded;
		}		
		
		///- Static Methods -///
		
		
		/// Instance Methods ///
		
		public function AdvanceStage(soil:Soil):void
		{
			// hopefully this will never get hit, it's just a sanity check
			if (_growthStage == Plant.STAGE_MATURE)
			{
				trace("error.... we're trying to advance the stage for a mature plant.  See Plant.AdvanceStage():void");
				return;
			}
			
			// get the grow style stage list
			var lStages:Array = Plant.GROWSTYLE_STAGES[growthStyle];
			
			// find which index the current stage is for this grow style
			var iGrowStyleStageIndex:int = -1;
			
			for (var s:int = 0; s < lStages.length; s++)
			{
				if (lStages[s] == growthStage)
				{
					iGrowStyleStageIndex = s;
					break;
				}
			}
			
			// another sanity check...
			if (iGrowStyleStageIndex == -1)
			{
				trace("error... couldn't find the current growth stage in the list of stages for this grow style.  See Plant.AdvanceStage()");
				return;
			}
			
			// advance the grow style stage
			var iNewGrowStyleStageIndex:int = iGrowStyleStageIndex + 1;
			
			// for repeating types, when they bump past the end of the array of stages, jump back to the start of the repeating sequence
			if (iNewGrowStyleStageIndex >= lStages.length)
			{
				var iRepeaterStage:int = Plant.GROWSTYLE_REPEATER_STAGE[growthStyle];
				
				if (iRepeaterStage == -1)
				{
					trace("error! A plant is trying to advance to a stage past what is defined, and it is not a repeater type!");
					return;
				}
				
				// update the growth stage to wrap around to where the repeater starts again after being harvested
				_growthStage = iRepeaterStage;
			}
			else
			{
				// update the growth stage to the next one in the sequence
				_growthStage = lStages[iNewGrowStyleStageIndex];
			}
			
			// if we hit the Producing stage, create a Fruit
			if (_growthStage == Plant.STAGE_PRODUCING)
			{
				_fruit = new Fruit(_type, 0, Fruit.CONDITION_GROWING, 0, 0, -1, _isOrganic);
			}
			
			// if we hit the ReadyToHarvest stage, update the fruit to be ripe and reset Age to start counting # of days it's been ripe
			if (_growthStage == Plant.STAGE_READY_FOR_HARVEST)
			{
				_fruit.condition = Fruit.CONDITION_RIPE;
				_fruit.age = 0;
				_fruit.priceModifier = ItemPricingService.PRICE_MOD_STANDARD;
			}
			
			// we've advanced the growth stage, so reset the amount of nutrients absorbed for the current stage to 0
			_nutrient1 = 0;
			_nutrient2 = 0;
			_nutrient3 = 0;
		}
		
		//---------------
		//Purpose:		Get a movieclip to display on the MainUI panel that represents the data preview of this object
		//
		//Parameters:
		//	none
		//
		//Returns:		a movieClip representation of a data preview of this object for display on the Main UI panel
		//---------------
		public function GetDataPreviewGraphics():MovieClip
		{
			var oGraphics:MovieClip = new MovieClip();
			oGraphics.x = 0;
			oGraphics.y = 0;
			
			var oBackground:PlantDataPreview_MC = new PlantDataPreview_MC();
			oBackground.Plant.text = String(name);
			oBackground.Stage.text = String(Plant.STAGES[_growthStage]);
			oGraphics.addChild(oBackground);
			
			var oPlantGraphics:MovieClip = GetGraphics();
			oPlantGraphics.x = 50;
			oPlantGraphics.y = 75;
			oGraphics.addChild(oPlantGraphics);
			
			return oGraphics;
		}
		
		//---------------
		//Purpose:		Get a movieclip that represents this object
		//
		//Parameters:
		//	none
		//
		//Returns:		a movieClip representation of this object
		//---------------
		public function GetGraphics():MovieClip
		{
			var mcPlant:MovieClip = new MovieClip();
			
			if (_growthStage == Plant.STAGE_SEED)
			{
				return mcPlant;
			}
			
			var sMCName:String = "Plant_" + Plant.GRFX_NAME[_type] + "_MC";
			var oClass:Class = Class(getDefinitionByName(sMCName));
			mcPlant = new oClass();
			
			if (mcPlant != null)
			{
				mcPlant.gotoAndStop(_growthStage);
			}
			
			return mcPlant;
		}
		
		public override function GetItemGraphics():MovieClip
		{
			var mcItem:MovieClip = this.GetGraphics();
			
			return mcItem;
		}
		
		public function GetIdealNutrientSet():NutrientSet
		{
			var oNutrientSet:NutrientSet = new NutrientSet();
			
			oNutrientSet.n1 = Plant.NUT1_IDEAL[_type][_growthStage];
			oNutrientSet.n2 = Plant.NUT2_IDEAL[_type][_growthStage];
			oNutrientSet.n3 = Plant.NUT3_IDEAL[_type][_growthStage];
			
			return oNutrientSet;
		}
		
		public function GetLiveNutrientSet():NutrientSet
		{
			var oNutrientSet:NutrientSet = new NutrientSet();
			
			oNutrientSet.n1 = Plant.NUT1_LIVE[_type][_growthStage];
			oNutrientSet.n2 = Plant.NUT2_LIVE[_type][_growthStage];
			oNutrientSet.n3 = Plant.NUT3_LIVE[_type][_growthStage];
			
			return oNutrientSet;
		}
		
		public function GetNeedNutrientSet():NutrientSet
		{
			var oNutrientSet:NutrientSet = new NutrientSet();
			
			oNutrientSet.n1 = Plant.NUT1_NEED[_type][_growthStage];
			oNutrientSet.n2 = Plant.NUT2_NEED[_type][_growthStage];
			oNutrientSet.n3 = Plant.NUT3_NEED[_type][_growthStage];
			
			return oNutrientSet;
		}
		
		public function GetNutrientSet():NutrientSet
		{
			var oNutrientSet:NutrientSet = new NutrientSet(_nutrient1, _nutrient2, _nutrient3);
			return oNutrientSet;
		}
		
		public function GetPreviewGraphics():MovieClip
		{
			var mcPlant:MovieClip = new MovieClip();
			
			if (_growthStage == Plant.STAGE_SEED)
			{
				return mcPlant;
			}
			
			var sMCName:String = "Plant_" + Plant.GRFX_NAME[_type] + "_MC";
			var oClass:Class = Class(getDefinitionByName(sMCName));
			mcPlant = new oClass();
			
			if (mcPlant != null)
			{
				mcPlant.gotoAndStop(_growthStage);
			}
			
			return mcPlant;
		}
		
		public function GetUniqueHostCode():String
		{
			var sCode:String = "Plant-" + Plant.NAME[_type];
			
			if (_growthStage >= Plant.STAGE_GROWING && _growthStage != Plant.STAGE_MATURE)
			{
				sCode += "-Rooted";
			}
			else if (_growthStage == Plant.STAGE_MATURE)
			{
				sCode += "-Mature";
			}
			
			return sCode;
		}
		
		//---------------
		//Purpose:		Have the Plant attempt to grow, based on the current conditions
		//
		//Parameters:
		//	soil:Soil = the Soil object that this Plants is growing from
		//
		//Side Effects:
		//	soil = may remove nutrients and saturation from soil
		//
		//Returns:		1 if the Plant is able to grow, -1 if Plant died from high water, -2 if from low water, -3 if from toxicity
		//---------------
		public function Grow(soil:Soil, season:int):int
		{
			// 1. See how vigorously the plant can grow based on current conditions
			var iGrowthStrength:int = PlantService.GetPlantGrowthStrength(this, soil, season);
			
			if (iGrowthStrength < 0)
			{
				return iGrowthStrength;
			}
			
			// 2. Based on how vigorously the plant can grow, get its desired nutrient levels to absorb
			var oAmountToAbsorb:NutrientSet = PlantService.GetAmountOfNutrientsToAbsorb(this, iGrowthStrength);
			
			// 3. Take the minimum between what the plant wants to absorb and how much is really in the soil to be absorbed
			oAmountToAbsorb = oAmountToAbsorb.GetMinimum(soil.GetNutrientSet());
													  
			// 4. Absorb the nutrients out of the Soil
			soil.RemoveNutrients(oAmountToAbsorb);
			
			// 5. Add the nutrients to the Plant
			if (_growthStage == Plant.STAGE_PRODUCING)
			{
				// during producing stage, 1 nutrient goes to the Plant each turn, all the rest goes to the Fruit
				if (oAmountToAbsorb.n1 > 0)
				{
					_nutrient1 += 1;
					_fruit.nutrients.n1 += (oAmountToAbsorb.n1 - 1);
				}
				
				if (oAmountToAbsorb.n2 > 0)
				{
					_nutrient2 += 1;
					_fruit.nutrients.n2 += (oAmountToAbsorb.n2 - 1);
				}
				
				if (oAmountToAbsorb.n3 > 0)
				{
					_nutrient3 += 1;
					_fruit.nutrients.n3 += (oAmountToAbsorb.n3 - 1);
				}
			}
			else
			{
				_nutrient1 += oAmountToAbsorb.n1;
				_nutrient2 += oAmountToAbsorb.n2;
				_nutrient3 += oAmountToAbsorb.n3;
			}
			
			// 6. See if the Plant has gotten enough nutrients to go on to the next stage
			var oNutrientsNeeded:NutrientSet = this.GetNeedNutrientSet();
			var oCurrentNutrients:NutrientSet = this.GetNutrientSet();
			
			// for producing stage, we need sum of Plant nutrients and Fruit nutrients to equal the Plant's needs
			if (_growthStage == Plant.STAGE_PRODUCING)
			{
				oCurrentNutrients = NutrientSet.GetSum([ oCurrentNutrients, _fruit.nutrients ]);
			}
			
			if (oCurrentNutrients.HasSameValues(oNutrientsNeeded) && _growthStage < Plant.STAGE_READY_FOR_HARVEST)
			{
				this.AdvanceStage(soil);
			}
			
			// 7. Have the Plant absorb some water from the soil
			soil.RemoveWater(Plant.WATER_ABSORBED[_type][_growthStage]);
			
			// 8. Add toxicity
			if (soil.toxicity > 0)
			{
				// add to plant every day
				if (_toxicity < soil.toxicity)
				{
					_toxicity += (soil.toxicity * .1);
					
					if (_toxicity > soil.toxicity)
					{
						_toxicity = soil.toxicity;
					}
				}
				
				// add to fruit during producing stage only
				if (_growthStage == Plant.STAGE_PRODUCING)
				{
					if (_fruit.toxicity < soil.toxicity)
					{
						_fruit.toxicity += (soil.toxicity * .1);
						
						if (_fruit.toxicity > soil.toxicity)
						{
							_fruit.toxicity = soil.toxicity;
						}
					}
				}
			}
			
			// 8. See if the Plant can remain as organic or not
			if (_toxicity > 0)
			{
				_isOrganic = false;
				
				if (_fruit != null && _fruit.toxicity > 0)
				{
					_fruit.isOrganic = false;
				}
			}
			
			return 1;
		}
		
		///- Instance Methods -///
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		//- Private Methods -//
		
		
		// Testing Methods //
		
		public static function RunTests():Array
		{
			var lResults:Array = new Array();
			
			lResults.push(Plant.GetPredictedDaysToHarvestNegOneForCoverCrop());
			lResults.push(Plant.GetPredictedDaysToHarvestNegOneIfReadyForHarvest());
			lResults.push(Plant.GetPredictedDaysToHarvestReturnsDays());
			
			lResults.push(Plant.GrowDuringProducingGivesFirstNutrientToPlant());
			lResults.push(Plant.GrowDuringProducingGivesOtherNutrientsToFruit());
			lResults.push(Plant.GrowDuringProducingAdvancesFromSumOfPlantAndFruit());
			lResults.push(Plant.GrowGivesToxicityToPlant());
			lResults.push(Plant.GrowDuringProducingGivesToxicityToFruit());
			
			return lResults;
		}
		
		private static function GetPredictedDaysToHarvestNegOneForCoverCrop():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Plant", "GetPredictedDaysToHarvestNegOneForCoverCrop");
			var oPlant:Plant = new Plant(Plant.TYPE_WILD_GRASS);
			
			oResult.expected = "-1";
			oResult.actual = String(oPlant.GetPredictedDaysToHarvest());
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GetPredictedDaysToHarvestNegOneIfReadyForHarvest():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Plant", "GetPredictedDaysToHarvestNegOneIfReadyForHarvest");
			var oPlant:Plant = new Plant(Plant.TYPE_ASPARAGUS, Plant.STAGE_READY_FOR_HARVEST);
			
			oResult.expected = "-1";
			oResult.actual = String(oPlant.GetPredictedDaysToHarvest());
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GetPredictedDaysToHarvestReturnsDays():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Plant", "GetPredictedDaysToHarvestReturnsDays");
			var oPlant:Plant = new Plant(Plant.TYPE_ASPARAGUS, Plant.STAGE_GROWING);
			oPlant.nutrient1 = 8;
			oPlant.nutrient2 = 6;
			oPlant.nutrient3 = 6;
			
			oResult.expected = "5";
			oResult.actual = String(oPlant.GetPredictedDaysToHarvest());
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GrowDuringProducingGivesFirstNutrientToPlant():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Plant", "GrowDuringProducingGivesFirstNutrientToPlant");
			
			var oFruit:Fruit = new Fruit(Fruit.TYPE_ASPARAGUS, 0, Fruit.CONDITION_GROWING, 0, 0, -1, true);
			var oPlant:Plant = new Plant(Plant.TYPE_ASPARAGUS, Plant.STAGE_PRODUCING, oFruit);
			var oSoil:Soil = new Soil(Substrate.TYPE_LOAM, true, 1, 100, 100, 35);
			
			oPlant.Grow(oSoil, Time.SEASON_SPRING);
			
			oResult.expected = "1";
			oResult.actual = String(oPlant.nutrient1);
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GrowDuringProducingGivesOtherNutrientsToFruit():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Plant", "GrowDuringProducingGivesOtherNutrientsToFruit");
			
			var oFruit:Fruit = new Fruit(Fruit.TYPE_ASPARAGUS, 0, Fruit.CONDITION_GROWING, 0, 0, -1, true);
			var oPlant:Plant = new Plant(Plant.TYPE_ASPARAGUS, Plant.STAGE_PRODUCING, oFruit);
			var oSoil:Soil = new Soil(Substrate.TYPE_LOAM, true, 100, 100, 100, 35);
			
			oPlant.Grow(oSoil, Time.SEASON_SPRING);
			
			oResult.expected = "7";
			oResult.actual = String(oFruit.nutrients.n1);
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GrowDuringProducingAdvancesFromSumOfPlantAndFruit():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Plant", "GrowDuringProducingAdvancesFromSumOfPlantAndFruit");
			
			var oFruit:Fruit = new Fruit(Fruit.TYPE_ASPARAGUS, 0, Fruit.CONDITION_GROWING, 0, 0, -1, true);
			oFruit.nutrients.n1 = 8;
			oFruit.nutrients.n2 = 11;
			oFruit.nutrients.n3 = 12;
			
			var oPlant:Plant = new Plant(Plant.TYPE_ASPARAGUS, Plant.STAGE_PRODUCING, oFruit);
			oPlant.nutrient1 = 8;
			oPlant.nutrient2 = 1;
			oPlant.nutrient3 = 0;
			
			var oSoil:Soil = new Soil(Substrate.TYPE_LOAM, true, 100, 100, 100, 35);
			
			oPlant.Grow(oSoil, Time.SEASON_SPRING);
			
			oResult.expected = String(Plant.STAGE_READY_FOR_HARVEST);
			oResult.actual = String(oPlant.growthStage);
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GrowGivesToxicityToPlant():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Plant", "GrowGivesToxicityToPlant");
			var oPlant:Plant = new Plant(Plant.TYPE_ALFALFA);
			var oSoil:Soil = new Soil(Substrate.TYPE_LOAM, true, 100, 100, 100, 35, 50);
			
			oPlant.Grow(oSoil, Time.SEASON_SPRING);
			
			oResult.expected = "5";
			oResult.actual = String(oPlant.toxicity);
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GrowDuringProducingGivesToxicityToFruit():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Plant", "GrowDuringProducingGivesToxicityToFruit");
			var oFruit:Fruit = new Fruit(Fruit.TYPE_ASPARAGUS, 0, Fruit.CONDITION_GROWING, 0, 0, -1, true);
			var oPlant:Plant = new Plant(Plant.TYPE_ASPARAGUS, Plant.STAGE_PRODUCING, oFruit);
			var oSoil:Soil = new Soil(Substrate.TYPE_LOAM, true, 100, 100, 100, 35, 20);
			
			oPlant.Grow(oSoil, Time.SEASON_SPRING);
			
			oResult.expected = "2";
			oResult.actual = String(oPlant.fruit.toxicity);
			oResult.TestEquals();
			
			return oResult;
		}
		
		//- Testing Methods -//
	}	
}