package
{
	import flash.display.MovieClip;
	
	//-----------------------
	//Purpose:				A button for the composite menu with an icon on its face
	//
	//Public Properties:
	//	
	//Public Methods:
	//	
	//-----------------------
	public class CompositeIconButton extends CompositeClickComponent
	{
		// Constants //
		
		public static const TYPE_SHOW_NUTRIENTS:int = 0;
		public static const TYPE_SHOW_PLANTS:int = 1;
		
		//- Constants -//
		
		
		// Public Properties //
		
		public function get type():int
		{
			return _type;
		}
		
		public function set type(value:int):void
		{
			_type = value;
		}
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		private var _type:int;
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function CompositeIconButton(type:int = 0, x:int = 0, y:int = 0, hitAreas:Array = null)
		{
			super(x, y, hitAreas);
			
			_type = type;
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		public override function Paint():MovieClip
		{
			var mcIconButton:Composite_IconButton_MC = new Composite_IconButton_MC();
			
			mcIconButton.gotoAndStop(_type + 1);
			
			return mcIconButton;
		}
		
		public function PrettyPrint():String
		{
			var sText:String = "Type = " + _type + ", X = " + this.x + ", Y = " + this.y;
			return sText;
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		//- Private Methods -//
		
		
		// Testing Methods //
		
		//- Testing Methods -//
	}
}