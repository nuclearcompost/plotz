package
{
	//-----------------------
	//Purpose:				A Bldg located on a Farm
	//
	//Public Properties:
	//	
	//Public Methods:
	//	
	//Extended By:
	//	Fence
	//	House
	//	Mailbox
	//	RootCellar
	//	SaleCart
	//	ToolShed
	//	Well
	//-----------------------
	public class FarmBldg extends Bldg
	{
		// Constants //
		
		//- Constants -//
		
		
		// Public Properties //
		
		public function get farm():Farm
		{
			return _farm;
		}
		
		public function set farm(value:Farm):void
		{
			_farm = value;
		}
		
		//- Public Properties -//
		
		
		// Protected Properties //
		
		protected var _farm:Farm;
		
		//- Protected Properties -//
		
	
		// Initialization //
		
		public function FarmBldg(origin:GridLocation = null, farm:Farm = null)
		{
			super(origin);
			
			_farm = farm;
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