package
{
	//-----------------------
	//Purpose:				Collection of all objects in a single grid location in the world
	//
	//Properties:
	//	
	//Methods:
	//	
	//-----------------------
	public class Tile
	{
		// Constants //
		
		public static const SECTION_LEFT_HALF:int = 0;
		public static const SECTION_RIGHT_HALF:int = 1;
		
		//- Constants -//
		
		
		// Public Properties //
		
		public function get fertilizer():Fertilizer
		{
			return _fertilizer;
		}
		
		public function set fertilizer(value:Fertilizer):void
		{
			_fertilizer = value;
		}
		
		public function get leftBldgs():Array
		{
			return _leftBldgs;
		}
		
		public function set leftBldgs(value:Array):void
		{
			_leftBldgs = value;
		}
		
		public function get plant():Plant
		{
			return _plant;
		}
		
		public function set plant(value:Plant):void
		{
			_plant = value;
		}
		
		public function get plantScrap():PlantScrap
		{
			return _plantScrap;
		}
		
		public function set plantScrap(value:PlantScrap):void
		{
			_plantScrap = value;
		}
		
		public function get rightBldgs():Array
		{
			return _rightBldgs;
		}
		
		public function set rightBldgs(value:Array):void
		{
			_rightBldgs = value;
		}
		
		public function get soil():Soil
		{
			return _soil;
		}
		
		public function set soil(value:Soil):void
		{
			_soil = value;
		}
		
		public function get terrain():Terrain
		{
			return _terrain;
		}
		
		public function set terrain(value:Terrain):void
		{
			_terrain = value;
		}
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		private var _fertilizer:Fertilizer;
		private var _leftBldgs:Array;
		private var _plant:Plant;
		private var _plantScrap:PlantScrap;
		private var _rightBldgs:Array;
		private var _soil:Soil;
		private var _terrain:Terrain;
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function Tile(leftBldgs:Array = null, rightBldgs:Array = null, fertilizer:Fertilizer = null, plant:Plant = null, plantScrap:PlantScrap = null, soil:Soil = null,
							 terrain:Terrain = null)
		{
			_leftBldgs = leftBldgs;
			_rightBldgs = rightBldgs;
			_fertilizer = fertilizer;
			_plant = plant;
			_plantScrap = plantScrap;
			_soil = soil;
			_terrain = terrain;
			
			if (_leftBldgs == null)
			{
				_leftBldgs = new Array();
			}
			if (_rightBldgs == null)
			{
				_rightBldgs = new Array();
			}
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		//- Private Methods -//
		
		
		// Testing Methods //
		
		//- Testing Methods -//
	}
}