package
{
	//-----------------------
	//Purpose:				Footer UI
	//
	//Public Properties:
	//	
	//Public Methods:
	//	
	//-----------------------
	public class Footer
	{
		// Constants //
		
		public static const MAX_X:int = 7;
		public static const MAX_Y:int = 0;
		
		//- Constants -//
		
		
		// Public Properties //
		
		public function get contents():Array
		{
			return _contents;
		}
		
		public function set contents(value:Array):void
		{
			_contents = value;
		}
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		private var _contents:Array;
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function Footer(contents:Array = null)
		{
			_contents = contents;
			
			if (_contents == null)
			{
				_contents = new Array();
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