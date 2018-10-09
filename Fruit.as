package
{
	import flash.display.MovieClip;
	
	//-----------------------
	//Purpose:				The end product a Plant creates.  Usually it's something edible, but things like Cotton or Feed are also possible.
	//
	//Public Properties:
	//	Price:int = the Price that the Fruit is sold at vendor for
	//	Type:int = the Fruit type
	//
	//Public Methods:
	//	GetGraphics():MovieClip = get a movieclip representation of this object
	//	GetPreviewGraphics():MovieClip = get a movieclip to display on the MainUI panel that represents the preview of this object
	//-----------------------
	public class Fruit extends Item implements IDecomposes, ISeasonalPrice, IVolatile
	{
		// Constants //
		public static const DESCRIPTION:Array = [ "Asparagus",
												  "Carrots",
												  "Corn",
												  "Eggplant",
												  "Garlic",
												  "Lettuce",
												  "Onion",
												  "Potato",
												  "Pumpkin",
												  "Wild Grass",
												  "Alfalfa",
												  "Broccoli",
												  "Clover",
												  "Sweet Potato"
												];
		
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
		
		/// Fruit condition constants ///
		public static const CONDITION_NAME:Array = [ "Growing", "Ripe", "Rotten" ];
		public static const CONDITION_GROWING:int = 0;
		public static const CONDITION_RIPE:int = 1;
		public static const CONDITION_ROTTEN:int = 2;
		
		private static const RIPE_DURATION:Array = [ [ 14 ],
													 [ 14 ],
													 [ 14 ],
													 [ 8 ],
													 [ 14 ],
													 [ 8 ],
													 [ 14 ],
													 [ 24 ],
													 [ 14 ],
													 [ 0 ],
													 [ 14 ],
													 [ 14 ],
													 [ 0 ],
													 [ 24 ]
												   ];
		///- Fruit condition constants -///
		
		public static const QUALITY_NAME:Array = [ "Poor", "Fair", "Good", "Excellent", "Legendary" ];
		public static const QUALITY_POOR:int = 0;
		public static const QUALITY_FAIR:int = 1;
		public static const QUALITY_GOOD:int = 2;
		public static const QUALITY_EXCELLENT:int = 3;
		public static const QUALITY_LEGENDARY:int = 4;
		
		private static const CHANCE_OF_LEGENDARY:int = 100;
		
		private static const DIFFICULTY_MARGIN:Array = [ 1.2, 1.05, 1.1, 1.3, 1.0, 1.05, 1.05, 1.1, 1.2, 0.0, 1.2, 1.05, 0.0, 1.05 ];
		
		private static const QUALITY_MARGIN:Array = [ 0.25, 0.5, 0.75, 1.25, 3.0 ];
		
		//- Constants -//
		
		
		// Public Properties //
		public function get age():int
		{
			return _age;
		}
		
		public function set age(value:int):void
		{
			_age = value;
		}
		
		public function get averageNutrients():Number
		{
			return _averageNutrients;
		}
		
		public function set averageNutrients(value:Number):void
		{
			_averageNutrients = value;
		}
		
		public function get condition():int
		{
			return _condition;
		}
		
		public function set condition(value:int):void
		{
			_condition = value;
		}
		
		public function get isOrganic():Boolean
		{
			return _isOrganic;
		}
		
		public function set isOrganic(value:Boolean):void
		{
			_isOrganic = value;
		}
		
		public override function get name():String
		{
			return Fruit.NAME[_type];
		}
		
		public function get nutrients():NutrientSet
		{
			return _nutrients;
		}
		
		public function set nutrients(value:NutrientSet):void
		{
			_nutrients = value;
		}
		
		public override function get priceModifier():int
		{
			return _priceModifier;
		}
		
		public override function set priceModifier(value:int):void
		{
			_priceModifier = value;
		}
		
		public function get quality():int
		{
			return _quality;
		}
		
		public function set quality(value:int):void
		{
			_quality = value;
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
		
		//- Public Properites -//
		
		
		// Private Properties //
		
		private var _age:int;
		private var _averageNutrients:Number;
		private var _condition:int;
		private var _decomposeDaysLeft:int;
		private var _isOrganic:Boolean;
		private var _nutrients:NutrientSet;
		private var _priceModifier:int;
		private var _quality:int;
		private var _toxicity:Number;
		private var _type:int;
		
		//- Private Properties -//
		
	
		// Initialization //
		
		//---------------
		//Purpose:		Construct a new Fruit object
		//
		//Parameters:
		//	type:int = the type of Fruit
		//
		//Returns:		reference to the new object
		//---------------
		public function Fruit(type:int = 0, age:int = 0, condition:int = 0, quality:int = 0, averageNutrients:Number = 0.0, priceModifier:int = -1, isOrganic:Boolean = true,
							  toxicity:Number = 0.0, decomposeDaysLeft:int = 4, nutrients:NutrientSet = null)
		{
			_type = type;
			_age = age;
			_condition = condition; 
			_quality = quality;
			_averageNutrients = averageNutrients;
			_priceModifier = priceModifier;
			_isOrganic = isOrganic;
			_toxicity = toxicity;
			_decomposeDaysLeft = decomposeDaysLeft;
			_nutrients = nutrients;
			
			if (_priceModifier == -1)
			{
				if (_condition == Fruit.CONDITION_RIPE)
				{
					_priceModifier = ItemPricingService.PRICE_MOD_STANDARD;
				}
				else
				{
					_priceModifier = ItemPricingService.PRICE_MOD_TRASH;
				}
			}
			
			if (_nutrients == null)
			{
				_nutrients = new NutrientSet();
			}
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		public function CreateCompost():Compost
		{
			var oCompost:Compost = new Compost(new NutrientSet(_nutrients.n1, _nutrients.n2, _nutrients.n3), _toxicity);
			
			return oCompost;
		}
		
		// from IVolatile, used when the Fruit is placed in a volatile container such as Garbage or Compost
		public function Disturb():void
		{
			_condition = Fruit.CONDITION_ROTTEN;
		}
		
		public static function GetAverageFruitCostForSeason(season:int):int
		{
			var iCost:int = 0;
			var iNumFruit:int = 0;
			
			for (var i:int = 0; i < Fruit.NAME.length; i++)
			{
				if (Plant.CLASSES[i] == Plant.CLASS_COVER)
				{
					continue;
				}
				
				if (Plant.GetPreferredSeason(i) != season)
				{
					continue;
				}
				
				iNumFruit++;
				
				var oFruit:Fruit = new Fruit(i, 0, Fruit.CONDITION_RIPE, Fruit.QUALITY_GOOD);
				iCost += oFruit.GetBasePrice();				
			}
			
			var iAverageCost:int = Math.ceil(iCost / iNumFruit);
			
			return iAverageCost;
		}
		
		public function GetDecomposeDaysLeft():int
		{
			return _decomposeDaysLeft;
		}
		
		//---------------
		//Purpose:		Get a movieclip that represents this object
		//
		//Returns:		a movieClip representation of this object
		//---------------
		public function GetGraphics():MovieClip
		{
			var oGraphics:MovieClip = new Fruit_MC();
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
		//Returns:		a movieClip representation of a preview of this object for display on the Main UI panel
		//---------------
		public function GetPreviewGraphics():MovieClip
		{
			var oGraphics:MovieClip = new MovieClip();
			
			var mcPreview:FruitPreview_MC = new FruitPreview_MC();
			mcPreview.Fruit.text = name;
			mcPreview.Condition.text = String(Fruit.CONDITION_NAME[_condition]);
			mcPreview.Quality.text = String(Fruit.QUALITY_NAME[_quality]);
			oGraphics.addChild(mcPreview);
			
			var mcFruit:Fruit_MC = new Fruit_MC();
			mcFruit.x = 5;
			mcFruit.y = 5;
			mcFruit.gotoAndStop(_type + 1);
			oGraphics.addChild(mcFruit);
			
			if (_isOrganic == true)
			{
				var mcOrganicLogo:Fruit_OrganicLogo_MC = new Fruit_OrganicLogo_MC();
				mcOrganicLogo.x = mcPreview.width - ((mcOrganicLogo.width / 2) + 12);
				mcOrganicLogo.y = mcPreview.height - ((mcOrganicLogo.height / 2) + 12);
				oGraphics.addChild(mcOrganicLogo);
			}
			
			return oGraphics;
		}
		
		public function GetBasePrice():int
		{
			var nPrice:int = 0;
			
			if (_condition == Fruit.CONDITION_ROTTEN)
			{
				return nPrice;
			}
			
			// 1. base price is the cost of the seed + cost to replace all nutrients with steady fertilizer - this is the exact cost to recover what it takes to grow the plant with 0 profit
			var nBasePrice:Number = Seed.PRICE[_type];
			
			var nNutrientReplacementCost:Number = Plant.GetTotalNutrientsNeeded(_type) * (BagFertilizer.PRICE[BagFertilizer.TYPE_STEADY_GREEN] / BagFertilizer.GetTotalNutrients(BagFertilizer.TYPE_STEADY_GREEN));
			
			nBasePrice += nNutrientReplacementCost;
			
			// 2. calculate the profit margin based on the inherent plant difficulty and the quality of the fruit
			var nMargin:Number = Fruit.DIFFICULTY_MARGIN[_type] * Fruit.QUALITY_MARGIN[_quality];
			
			var nFertilizerCost:Number = BagFertilizer.PRICE[BagFertilizer.TYPE_STEADY_GREEN];
			
			// 3. multiply profit margin by cost of 1 fertilizer, which is the yardstick for profit
			var nProfit:Number = nFertilizerCost * nMargin;
			
			nPrice = Math.ceil(nBasePrice + nProfit);
			
			return nPrice;
		}
		
		public function GetPrice(season:int):int
		{
			var nPrice:int = GetBasePrice();
			
			var iPlantSeason:int = Plant.GetPreferredSeason(_type);
			
			if (iPlantSeason != Time.SEASON_ANY && iPlantSeason != season)
			{
				nPrice = Math.floor(nPrice * 1.25);
			}
			
			return nPrice;
		}
		
		//---------------
		//Purpose:		Have the Fruit grow while it's on the plant, updating its quality based on soil conditions
		//
		//---------------
		public function Grow(soil:Soil):void
		{
			IncrementAge(1);
			
			if (_condition == Fruit.CONDITION_GROWING)
			{
				// update the quality of the fruit based on the current soil conditions
				var nNutrient1Percent:Number = (soil.nutrient1 / Soil.MAX_NUTRIENT1) * 100;
				var nNutrient2Percent:Number = (soil.nutrient2 / Soil.MAX_NUTRIENT2) * 100;
				var nNutrient3Percent:Number = (soil.nutrient3 / Soil.MAX_NUTRIENT3) * 100;
				
				var nCurrentAverageNutrients:Number = (nNutrient1Percent + nNutrient2Percent + nNutrient3Percent) / 3;
				
				_averageNutrients += nCurrentAverageNutrients;
							
				UpdateQuality();
			}
		}
		
		//---------------
		//Purpose:		Have the Fruit age by a day, updating its condition if enough time has passed
		//
		//---------------
		public function IncrementAge(amount:int = 1):void
		{
			if (_condition == Fruit.CONDITION_ROTTEN)
			{
				return;
			}
			
			_age += amount;
			
			if (_age >= Fruit.RIPE_DURATION[_type] && _condition == Fruit.CONDITION_RIPE)
			{
				_condition = Fruit.CONDITION_ROTTEN;
				_priceModifier = ItemPricingService.PRICE_MOD_TRASH;
			}
		}
		
		public function SetDecomposeDaysLeft(days:int):void
		{
			_decomposeDaysLeft = days;
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		private function UpdateQuality():void
		{
			var nRunningAverage:Number = _averageNutrients / _age;
			
			// once a legend, always a legend
			if (_quality == Fruit.QUALITY_LEGENDARY)
			{
				return;
			}
			
			if (nRunningAverage < 25)
			{
				_quality = Fruit.QUALITY_POOR;
			}
			
			if (nRunningAverage < 50 && nRunningAverage >= 25)
			{
				_quality = Fruit.QUALITY_FAIR;
			}
			
			if (nRunningAverage < 75 && nRunningAverage >= 50)
			{
				_quality = Fruit.QUALITY_GOOD;
			}
			
			if (nRunningAverage >= 75)
			{	
				_quality = Fruit.QUALITY_EXCELLENT;
				
				var nRoll:int = Math.floor(Math.random() * Fruit.CHANCE_OF_LEGENDARY);
				
				if (nRoll == 0)
				{
					_quality = Fruit.QUALITY_LEGENDARY;
				}
			}
		}
		
		//- Private Methods -//
	}	
}