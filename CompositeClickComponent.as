package
{
	import flash.display.MovieClip;
	
	//-----------------------
	//Purpose:				A component in a composite menu that has graphics and can be clicked on
	//
	//Public Properties:
	//	
	//Public Methods:
	//	
	//Extended By:
	//
	//-----------------------
	public class CompositeClickComponent
	{
		// Constants //
		
		//- Constants -//
		
		
		// Public Properties //
		
		public function get hitAreas():Array
		{
			return _hitAreas;
		}
		
		public function set hitAreas(value:Array):void
		{
			_hitAreas = value;
		}
		
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
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		private var _hitAreas:Array;
		private var _x:int;
		private var _y:int;
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function CompositeClickComponent(x:int = 0, y:int = 0, hitAreas:Array = null)
		{
			_x = x;
			_y = y;
			_hitAreas = hitAreas;
			
			if (_hitAreas == null)
			{
				_hitAreas = new Array();
			}
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		public function Paint():MovieClip
		{
			trace("error! CompositeClickComponent parent Paint method called");
			
			return null;
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		//- Private Methods -//
		
		
		// Testing Methods //
		
		//- Testing Methods -//
	}
}