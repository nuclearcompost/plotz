package
{
	//-----------------------
	//Purpose:				
	//Public Properties:
	//	
	//Public Methods:
	//	
	//-----------------------
	public class StatTracker
	{
		// Constants //
		
		//- Constants -//
		
		
		// Public Properties //
		
		public function get fertilizersUsed():int
		{
			return _fertilizersUsed;
		}
		
		public function set fertilizersUsed(value:int):void
		{
			_fertilizersUsed = value;
		}
		
		public function get fruitHarvested():int
		{
			return _fruitHarvested;
		}
		
		public function set fruitHarvested(value:int):void
		{
			_fruitHarvested = value;
		}
		
		public function get moneyEarned():int
		{
			return _moneyEarned;
		}
		
		public function set moneyEarned(value:int):void
		{
			_moneyEarned = value;
		}
		
		public function get moneySpent():int
		{
			return _moneySpent;
		}
		
		public function set moneySpent(value:int):void
		{
			_moneySpent = value;
		}
		
		public function get nutrientEnd():int
		{
			return _nutrientEnd;
		}
		
		public function set nutrientEnd(value:int):void
		{
			_nutrientEnd = value;
		}
		
		public function get nutrientStart():int
		{
			return _nutrientStart;
		}
		
		public function set nutrientStart(value:int):void
		{
			_nutrientStart = value;
		}
		
		public function get plantsKilled():int
		{
			return _plantsKilled;
		}
		
		public function set plantsKilled(value:int):void
		{
			_plantsKilled = value;
		}
		
		public function get plantsPlanted():int
		{
			return _plantsPlanted;
		}
		
		public function set plantsPlanted(value:int):void
		{
			_plantsPlanted = value;
		}
		
		public function get waterUsed():int
		{
			return _waterUsed;
		}
		
		public function set waterUsed(value:int):void
		{
			_waterUsed = value;
		}
		//- Public Properties -//
		
		
		// Private Properties //
		
		private var _fertilizersUsed:int;
		private var _fruitHarvested:int;
		private var _moneyEarned:int;
		private var _moneySpent:int;
		private var _nutrientEnd:int;
		private var _nutrientStart:int;
		private var _plantsKilled:int;
		private var _plantsPlanted:int;
		private var _waterUsed:int;
		
		//- Private Properties -//
		
	
		// Initialization //
		
		//---------------
		//Purpose:		Default constructor
		//
		//Parameters:
		//	
		//---------------
		public function StatTracker(fert:int = 0, fruit:int = 0, moneyEarned:int = 0, moneySpent:int = 0, nutrientEnd:int = 0, nutrientStart:int = 0, plantKills:int = 0, plantPlants:int = 0, water:int = 0)
		{
			_fertilizersUsed = fert;
			_fruitHarvested = fruit;
			_moneyEarned = moneyEarned;
			_moneySpent = moneySpent;
			_nutrientEnd = nutrientEnd;
			_nutrientStart = nutrientStart;
			_plantsKilled = plantKills;
			_plantsPlanted = plantPlants;
			_waterUsed = water;
		}
		
		//- Initializiation -//
		
		
		// Public Methods //
		
		//- Public Methods -//
		
		
		// Protected Methods //
		
		//- Protected Methods -//
	}
}