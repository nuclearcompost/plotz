package
{
	import flash.display.MovieClip;
	
	public class SliderBar
	{
		// Constants //
		public static const SIZE_SMALL:int = 0;
		public static const SIZE_NORMAL:int = 1;
		
		private static const BAR_WIDTH:Array = [ 175.0, 240.0 ];  // width of the bar in pixels
		
		public static const SLIDER_FRAME_TOP_GRAY:int = 1;
		public static const SLIDER_FRAME_TOP_GREEN:int = 2;
		public static const SLIDER_FRAME_TOP_YELLOW:int = 3;
		public static const SLIDER_FRAME_TOP_RED:int = 4;
		public static const SLIDER_FRAME_BOTTOM_GRAY:int = 5;
		public static const SLIDER_FRAME_BOTTOM_GREEN:int = 6;
		public static const SLIDER_FRAME_BOTTOM_YELLOW:int = 7;
		public static const SLIDER_FRAME_BOTTOM_RED:int = 8;
		public static const SLIDER_FRAME_LEFT_GRAY:int = 9;
		public static const SLIDER_FRAME_LEFT_GREEN:int = 10;
		public static const SLIDER_FRAME_LEFT_YELLOW:int = 11;
		public static const SLIDER_FRAME_LEFT_RED:int = 12;
		public static const SLIDER_FRAME_RIGHT_GRAY:int = 13;
		public static const SLIDER_FRAME_RIGHT_GREEN:int = 14;
		public static const SLIDER_FRAME_RIGHT_YELLOW:int = 15;
		public static const SLIDER_FRAME_RIGHT_RED:int = 16;
		
		//* Constants *//
		
		
		// Public Properties:
		
		// Private Properties //
		private var _currentValue:Number;
		private var _highTol:Number;
		private var _lowTol:Number;
		private var _maxTol:Number;
		private var _maxValue:Number;
		private var _minTol:Number;
		private var _size:int;
		
		//* Private Properties *//
		
	
		// Initialization //
		public function SliderBar(size:int, currentValue:Number, maxValue:Number, minTol:Number = -1, lowTol:Number = -1, highTol:Number = -1, maxTol:Number = -1)
		{
			_size = size;
			_currentValue = currentValue;
			_maxValue = maxValue;
			_minTol = minTol;
			_lowTol = lowTol;
			_highTol = highTol;
			_maxTol = maxTol;
		}
		
		//* Initialization *//
		
	
		// Public Methods //
		
		public function Paint():MovieClip
		{
			var oReturn:MovieClip = new MovieClip();
			
			var oBarMC:SliderBar_MC = new SliderBar_MC();
			oBarMC.gotoAndStop(_size + 1);
			oReturn.addChild(oBarMC);
			
			var oSliderMC:Slider_MC = new Slider_MC();
			oSliderMC.x = (_currentValue / _maxValue) * SliderBar.BAR_WIDTH[_size];
			oReturn.addChild(oSliderMC);
			
			if (_minTol > -1.0 && _lowTol > -1.0 && _highTol > -1.0 && _maxTol > -1.0)
			{
				// set the current value slider to the proper color based on which range it's fallen into
				if (_currentValue >= _lowTol && _currentValue <= _highTol)
				{
					oSliderMC.gotoAndStop(SliderBar.SLIDER_FRAME_BOTTOM_GREEN);
				}
				else if ((_currentValue >= _minTol && _currentValue <= _lowTol) || (_currentValue >= _highTol && _currentValue <= _maxTol))
				{
					oSliderMC.gotoAndStop(SliderBar.SLIDER_FRAME_BOTTOM_YELLOW);
				}
				else if (_currentValue < _minTol || _currentValue > _maxTol)
				{
					oSliderMC.gotoAndStop(SliderBar.SLIDER_FRAME_BOTTOM_RED);
				}
				
				// draw sliders for the tolerances of the proper colors
				oSliderMC = new Slider_MC();
				oSliderMC.x = (_minTol / _maxValue) * SliderBar.BAR_WIDTH[_size];
				oSliderMC.gotoAndStop(SliderBar.SLIDER_FRAME_TOP_RED);
				oReturn.addChild(oSliderMC);
				
				oSliderMC = new Slider_MC();
				oSliderMC.x = (_lowTol / _maxValue) * SliderBar.BAR_WIDTH[_size];
				oSliderMC.gotoAndStop(SliderBar.SLIDER_FRAME_TOP_YELLOW);
				oReturn.addChild(oSliderMC);
				
				oSliderMC = new Slider_MC();
				oSliderMC.x = (_highTol / _maxValue) * SliderBar.BAR_WIDTH[_size];
				oSliderMC.gotoAndStop(SliderBar.SLIDER_FRAME_TOP_YELLOW);
				oReturn.addChild(oSliderMC);
				
				oSliderMC = new Slider_MC();
				oSliderMC.x = (_maxTol / _maxValue) * SliderBar.BAR_WIDTH[_size];
				oSliderMC.gotoAndStop(SliderBar.SLIDER_FRAME_TOP_RED);
				oReturn.addChild(oSliderMC);
			}
			
			return oReturn;
		}
		
		//* Public Methods *//
		
		
		// Protected Methods:
	}
}