package
{
	//-----------------------
	//Purpose:				
	//Public Properties:
	//	
	//Public Methods:
	//	
	//-----------------------
	public class BlobInfo
	{
		// Constants //
		
		//- Constants -//
		
		
		// Public Properties //
		
		public function get x():int
		{
			return _x;
		}
		
		public function set x(value:int):void
		{
			_x = value;
		}
		
		public function get y():int
		{
			return _y;
		}
		
		public function set y(value:int):void
		{
			_y = value;
		}
		
		public function get fromSide():int
		{
			return _fromSide;
		}
		
		public function set fromSide(value:int):void
		{
			_fromSide = value;
		}
		
		public function get fromType():int
		{
			return _fromType;
		}
		
		public function set fromType(value:int):void
		{
			_fromType = value;
		}
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		private var _x:int;
		private var _y:int;
		private var _fromSide:int;
		private var _fromType:int;
		
		//- Private Properties -//
		
	
		// Initialization //
		
		//---------------
		//Purpose:		
		//Parameters:
		//	
		//Returns:		
		//---------------
		public function BlobInfo(x:int = 0, y:int = 0, fromSide:int = 0, fromType:int = 0)
		{
			_x = x;
			_y = y;
			_fromSide = fromSide;
			_fromType = fromType;
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		//- Private Methods -//
	}
}