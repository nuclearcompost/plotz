package
{
	//-----------------------
	//Purpose:				A Bldg located in a Town
	//
	//Public Properties:
	//	
	//Public Methods:
	//	
	//Extended By:
	//	ItemShop
	//	Home
	//-----------------------
	public class TownBldg extends Bldg
	{
		// Constants //
		
		
		//- Constants -//
		
		
		// Public Properties //
		
		public function get town():Town
		{
			return _town;
		}
		
		public function set town(value:Town):void
		{
			_town = value;
		}
		
		//- Public Properties -//
		
		
		// Protected Properties //
		
		protected var _town:Town;
		
		//- Protected Properties -//
		
	
		// Initialization //
		
		public function TownBldg(origin:GridLocation = null, town:Town = null)
		{
			super(origin);
			
			_town = town;
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		//- Public Methods -//
		
		
		// Protected Methods //
		
		//- Protected Methods -//
		
		
		// Testing Methods //
		
		//- Testing Methods -//
	}
}