package
{
	import flash.display.MovieClip;
	
	public class VerticalBar
	{
		// Constants //
		
		//- Constants -//
		
		
		// Public Properties //
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		private var _backColor:uint;
		private var _barColor:uint;
		private var _barStrokeColor:uint;
		private var _height:Number;
		private var _highTol:Number;
		private var _lowTol:Number;
		private var _maxValue:Number;
		private var _maxTol:Number;
		private var _minTol:Number;
		private var _value:Number;
		private var _width:Number;
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function VerticalBar(width:Number, height:Number, value:Number, maxValue:Number, barColor:uint, barStrokeColor:uint, backColor:uint, minTol:Number = -1, lowTol:Number = -1, highTol:Number = -1, maxTol:Number = -1)
		{
			_width = width;
			_height = height;
			_value = value;
			_maxValue = maxValue;
			_barColor = barColor;
			_barStrokeColor = barStrokeColor;
			_backColor = backColor;
			_minTol = minTol;
			_lowTol = lowTol;
			_highTol = highTol;
			_maxTol = maxTol;
			
			if (_value > _maxValue)
			{
				_value = _maxValue;
			}
		}
		
		//- Initialization -//
		
	
		// Public Methods //
		
		public function Paint():MovieClip
		{
			var oReturn:MovieClip = new MovieClip();
			
			oReturn.graphics.beginFill(_backColor);
			oReturn.graphics.moveTo(0, 0);
			oReturn.graphics.lineTo(0, _height);
			oReturn.graphics.lineTo(_width, _height);
			oReturn.graphics.lineTo(_width, 0);
			oReturn.graphics.lineTo(0, 0);
			oReturn.graphics.endFill();
			
			var nBarHeight:Number = (_value / _maxValue) * _height;
			
			oReturn.graphics.beginFill(_barColor);
			oReturn.graphics.moveTo(0, _height);
			oReturn.graphics.lineTo(_width, _height);
			oReturn.graphics.lineTo(_width, _height - nBarHeight);
			oReturn.graphics.lineTo(0, _height - nBarHeight);
			oReturn.graphics.lineTo(0, _height);
			oReturn.graphics.endFill();
			
			oReturn.graphics.lineStyle(1.0, _barStrokeColor);
			oReturn.graphics.moveTo(0, 0);
			oReturn.graphics.lineTo(0, _height);
			oReturn.graphics.lineTo(_width, _height);
			oReturn.graphics.lineTo(_width, 0);
			oReturn.graphics.lineTo(0, 0);
			
			var tolY:Number = 0;
			var mcSlider:Slider_MC = null;
			
			if (_lowTol > -1 && _lowTol < _maxValue)
			{
				tolY = _height - ((_lowTol / _maxValue) * _height);
				
				mcSlider = new Slider_MC();
				mcSlider.x = _width;
				mcSlider.y = tolY;
				mcSlider.gotoAndStop(SliderBar.SLIDER_FRAME_RIGHT_YELLOW);
				oReturn.addChild(mcSlider);
			}
			if (_highTol > -1 && _highTol < _maxValue)
			{
				tolY = _height - ((_highTol / _maxValue) * _height);
				
				mcSlider = new Slider_MC();
				mcSlider.x = _width;
				mcSlider.y = tolY;
				mcSlider.gotoAndStop(SliderBar.SLIDER_FRAME_RIGHT_YELLOW);
				oReturn.addChild(mcSlider);
			}
			if (_minTol > -1 && _minTol < _maxValue)
			{
				tolY = _height - ((_minTol / _maxValue) * _height);
				
				mcSlider = new Slider_MC();
				mcSlider.x = _width;
				mcSlider.y = tolY;
				mcSlider.gotoAndStop(SliderBar.SLIDER_FRAME_RIGHT_RED);
				oReturn.addChild(mcSlider);
			}
			if (_maxTol > -1 && _maxTol < _maxValue)
			{
				tolY = _height - ((_maxTol / _maxValue) * _height);
				
				mcSlider = new Slider_MC();
				mcSlider.x = _width;
				mcSlider.y = tolY;
				mcSlider.gotoAndStop(SliderBar.SLIDER_FRAME_RIGHT_RED);
				oReturn.addChild(mcSlider);
			}
			
			return oReturn;
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		//- Private Methods -//
	}
}