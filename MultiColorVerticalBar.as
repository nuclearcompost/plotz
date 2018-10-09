package
{
	import flash.display.MovieClip;
	
	//-----------------------
	//Purpose:				
	//Public Properties:
	//	
	//Public Methods:
	//	
	//-----------------------
	public class MultiColorVerticalBar
	{
		// Constants //
		
		//- Constants -//
		
		
		// Public Properties //
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		private var _colors:Array;
		private var _levels:Array;
		private var _width:int;
		
		//- Private Properties -//
		
	
		// Initialization //
		
		// levels = dividing lines between colors, final level is the bottom of the bar
		// colors = colors for each block
		// blocks are drawn from the top down, so color[0] is the top color
		public function MultiColorVerticalBar(width:int, levels:Array, colors:Array)
		{
			_width = width;
			_levels = levels;
			_colors = colors;
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		public function Paint():MovieClip
		{
			var oReturn:MovieClip = new MovieClip();
			
			if (_levels == null || _colors == null)
			{
				return oReturn;
			}
			
			if (_colors.length != _levels.length)
			{
				return oReturn;
			}
			
			var iPreviousY:int = 0;
			
			for (var i:int = 0; i < _colors.length; i++)
			{
				oReturn.graphics.beginFill(_colors[i]);
				oReturn.graphics.moveTo(0, iPreviousY);
				oReturn.graphics.lineTo(_width, iPreviousY);
				oReturn.graphics.lineTo(_width, _levels[i]);
				oReturn.graphics.lineTo(0, _levels[i]);
				oReturn.graphics.lineTo(0, iPreviousY);
				oReturn.graphics.endFill();
				
				iPreviousY = _levels[i];
			}
			
			return oReturn;
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		//- Private Methods -//
		
		
		// Testing Methods //
		
		//- Testing Methods -//
	}
}