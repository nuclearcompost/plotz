package
{
	//-----------------------
	//Purpose:				A building's location in a town
	//
	//Properties:
	//	
	//Methods:
	//	
	//-----------------------
	public class Address
	{
		// Constants //
		
		//- Constants -//
		
		
		// Public Properties //
		
		public function get streetName():String
		{
			return _streetName;
		}
		
		public function set streetName(value:String):void
		{
			_streetName = value;
		}
		
		public function get streetNumber():String
		{
			return _streetNumber;
		}
		
		public function set streetNumber(value:String):void
		{
			_streetNumber = value;
		}
		
		public function get town():Town
		{
			return _town;
		}
		
		public function set town(value:Town):void
		{
			_town = value;
		}
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		private var _streetName:String;
		private var _streetNumber:String;
		private var _town:Town;
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function Address(streetNumber:String = "", streetName:String = "", town:Town = null)
		{
			_streetNumber = streetNumber;
			_streetName = streetName;
			_town = town;
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