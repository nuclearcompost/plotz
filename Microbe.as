package
{
	//-----------------------
	//Purpose:				A micro-organism that lives in soil, spawned by a hosting entity that implements IMicrobeHost
	//
	//Properties:
	//	detoxAmount:int = the amount of toxicity a max population will remove from soil in one day
	//	growthRate:Number = the amount of new population to add each day under ideal conditions
	//	hostCode:String = the host code that spawned this Microbe
	//	highToxicity:int = the amount of soil toxicity at which the Microbe will start to grow more slowly in population each day
	//	maxPopulation:Number = the maximum population of the Microbe
	//	maxSaturation:int = the amount of soil saturation above which the Microbe population will die
	//	maxToxicity:int = the amount of soil toxicity above which the Microbe population will die
	//	minSaturation:int = the amount of soil saturation below which the Microbe population will die
	//	noHostDieoffAmount:Number = the population amount that will die if the Microbe's host is no longer present
	//	nutrientBoost:NutrientSet = the amount of extra nutrients a max population will add to the soil each day
	//	nutrientGeneration:NutrientSet = the amount of nutrients a max population will generate in the soil each day
	//	population:Number = the current population amount
	//	
	//Methods:
	//	AddPopulation(quantity:Number):void = increases the population of the Microbe by the given amount
	//	RemovePopulation(quantity:Number):void = decreases the population of the Microbe by the given amount
	//	RemovePopulationPercentage(percent:Number):void = decreases the population of the Microbe by the given percentage
	//
	//-----------------------
	public class Microbe
	{
		// Constants //
		
		//- Constants -//
		
		
		// Public Properties //
		
		public function get hostCode():String
		{
			return  _hostCode;
		}
		
		public function set hostCode(value:String):void
		{
			_hostCode = value;
		}
		
		/// abilities ///
		
		public function get detoxAmount():int
		{
			return _detoxAmount;
		}
		
		public function set detoxAmount(value:int):void
		{
			_detoxAmount = value;
		}
		
		public function get nutrientBoost():NutrientSet
		{
			return _nutrientBoost;
		}
		
		public function set nutrientBoost(value:NutrientSet):void
		{
			_nutrientBoost = value;
		}
		
		public function get nutrientGeneration():NutrientSet
		{
			return _nutrientGeneration;
		}
		
		public function set nutrientGeneration(value:NutrientSet):void
		{
			_nutrientGeneration = value;
		}
		
		///- abilities -///
		
		
		/// population control ///
		
		public function get growthRate():Number
		{
			return _growthRate;
		}
		
		public function set growthRate(value:Number):void
		{
			_growthRate = value;
		}
		
		public function get maxPopulation():Number
		{
			return _maxPopulation;
		}
		
		public function set maxPopulation(value:Number):void
		{
			_maxPopulation = value;
		}
		
		public function get noHostDieOffAmount():Number
		{
			return _noHostDieOffAmount;
		}
		
		public function set noHostDieOffAmount(value:Number):void
		{
			_noHostDieOffAmount = value;
		}
		
		public function get population():Number
		{
			return _population;
		}
		
		public function set population(value:Number):void
		{
			_population = value;
		}
		
		///- population control -///
		
		
		/// thresholds ///
		
		public function get highToxicity():int
		{
			return _highToxicity;
		}
		
		public function set highToxicity(value:int):void
		{
			_highToxicity = value;
		}
		
		public function get maxSaturation():int
		{
			return _maxSaturation;
		}
		
		public function set maxSaturation(value:int):void
		{
			_maxSaturation = value;
		}
		
		public function get maxToxicity():int
		{
			return _maxToxicity;
		}
		
		public function set maxToxicity(value:int):void
		{
			_maxToxicity = value;
		}
		
		public function get minSaturation():int
		{
			return _minSaturation;
		}
		
		public function set minSaturation(value:int):void
		{
			_minSaturation = value;
		}
		
		///- thresholds -///
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		private var _hostCode:String;
		
		/// abilities ///
		
		private var _detoxAmount:int;
		private var _nutrientBoost:NutrientSet;
		private var _nutrientGeneration:NutrientSet;
		
		///- abilities -///
		
		
		/// population control ///
		
		private var _growthRate:Number;
		private var _maxPopulation:Number;
		private var _noHostDieOffAmount:Number;
		private var _population:Number;
		
		///- population control -///
		
		
		/// thresholds ///
		
		private var _highToxicity:int;
		private var _maxSaturation:int;
		private var _maxToxicity:int;
		private var _minSaturation:int;
		
		///- thresholds -///
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function Microbe(hostCode:String = "", detoxAmount:int = 0, nutrientBoost:NutrientSet = null, nutrientGeneration:NutrientSet = null,
								population:Number = 0, maxPopulation:Number = 0, growthRate:Number = 0, noHostDieOffAmount:Number = 0,
								minSaturation:int = 0, maxSaturation:int = 0, highToxicity:int = 0, maxToxicity:int = 0)
		{
			_hostCode = hostCode;
			_detoxAmount = detoxAmount;
			_nutrientBoost = nutrientBoost;
			_nutrientGeneration = nutrientGeneration;
			_population = population;
			_maxPopulation = maxPopulation;
			_growthRate = growthRate;
			_noHostDieOffAmount = noHostDieOffAmount;
			_minSaturation = minSaturation;
			_maxSaturation = maxSaturation;
			_highToxicity = highToxicity;
			_maxToxicity = maxToxicity;
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		// increases the population of the Microbe by the given amount
		public function AddPopulation(quantity:Number):void
		{
			_population += quantity;
			
			if (_population > _maxPopulation)
			{
				_population = _maxPopulation;
			}
			
			// need this because you could pass in a negative quantity
			if (_population < 0)
			{
				_population = 0;
			}
		}
		
		// decreases the population of the Microbe by the given amount
		public function RemovePopulation(quantity:Number):void
		{
			_population -= quantity;
			
			if (_population < 0)
			{
				_population = 0;
			}
			
			// need this because you could pass in a negative quantity
			if (_population > _maxPopulation)
			{
				_population = _maxPopulation;
			}
		}
		
		// decreases the population of the Microbe by the given pecentage
		public function RemovePopulationPercentage(percent:Number):void
		{
			_population -= Math.floor((percent / 100) * _population);
			
			if (_population < 0)
			{
				_population = 0;
			}
			
			// need this because you could pass in a negative quantity
			if (_population > _maxPopulation)
			{
				_population = _maxPopulation;
			}
		}		
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		//- Private Methods -//
	}
}