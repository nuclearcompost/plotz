package
{

	public class Weather
	{
		public static const TYPE_HOT:int = 0;
		public static const TYPE_SUN:int = 1;
		public static const TYPE_CLOUD:int = 2;
		public static const TYPE_RAIN:int = 3;
		public static const TYPE_STORM:int = 4;
		
		public static const TYPE_NAMES:Array = [ "Hot", "Sun", "Cloud", "Rain", "Storm" ];
		
		public static const DESCRIPTION:Array = [ "Hot", "Sunny", "Cloudy", "Rainy", "Stormy" ];
		
		public static const WATER_AMOUNT:Array = [ -3.0, -1.0, 0.0, 5, 10 ];
		
		public static const EVAPORATION_FACTOR:Number = 3.0;
		
		public function get current():int
		{
			return _current;
		}
		
		public function set current(value:int):void
		{
			_current = value;
		}
		
		public function get direction():int
		{
			return _direction;
		}
		
		public function set direction(value:int):void
		{
			_direction = value;
		}
		
		public function get maxDelta():Number
		{
			return _maxDelta;
		}
		
		public function set maxDelta(value:Number):void
		{
			_maxDelta = value;
		}
		
		public function get minDelta():Number
		{
			return _minDelta;
		}
		
		public function set minDelta(value:Number):void
		{
			_minDelta = value;
		}
		
		public function get thresholds():Array
		{
			return _thresholds;
		}
		
		public function set thresholds(value:Array):void
		{
			_thresholds = value;
			
			if (_thresholds == null)
			{
				_thresholds = new Array();
			}
		}
		
		public function get type():int
		{
			return _type;
		}
		
		public function set type(value:int):void
		{
			_type = value;
		}
		
		public function get value():Number
		{
			return _value;
		}
		
		public function set value(value:Number):void
		{
			_value = value;
		}

		private var _bottom:Number;
		private var _current:int;
		private var _direction:int;
		private var _maxDelta:Number;
		private var _minDelta:Number;
		private var _thresholds:Array;
		private var _top:Number;
		private var _type:int;
		private var _value:Number;
		
		// ---
		//	direction should be either +1 or -1
		// ---
		public function Weather(thresholds:Array = null, value:Number = 0.0, direction:int = 1, minDelta:Number = 1.0, maxDelta:Number = 2.0, bottom:Number = 0.0, top:Number = 0.0,
								current:int = 0, type:int = 0)
		{
			_thresholds = thresholds;
			_value = value;
			_direction = direction;
			_minDelta = minDelta;
			_maxDelta = maxDelta;
			
			if (_thresholds == null)
			{
				_thresholds = new Array();
				_type = -1;
				_current = -1;
				_top = 0;
				_bottom = 0;
			}
			else
			{
				_type = GetTypeForValue(_value);
				_current = GetTypeForValue(_value);
				SetTop();
				SetBottom();
			}
		}
		
		public static function GetName(type:int):String
		{
			return Weather.TYPE_NAMES[type];
		}
		
		public function SetNewWeather():void
		{
			var nDifference:Number = _maxDelta - _minDelta;
			var nDelta:Number = (Math.random() * nDifference) + _minDelta;
			
			nDelta *= _direction;

			_value += nDelta;
			_type = GetTypeForValue(_value);
			
			// see if we crossed the current boundary and should therefore reverse direction
			if (_direction == 1)
			{
				if (_value > _top)
				{
					SetTop();
					_direction = -1;
				}
			}
			else
			{
				if (_value < _bottom)
				{
					SetBottom();
					_direction = 1;
				}
			}

			_current = _type;
		}
		
		private function GetTypeForValue(value:Number):int
		{
			var iType:int = -1;
			
			if (_thresholds.length == 0)
			{
				return iType;
			}
			
			for (var i:int = 0; i < _thresholds.length - 1; i++)
			{
				if (value <= _thresholds[i] && value > _thresholds[i + 1])
				{
					iType = i;
					break;
				}
			}
			
			// handle extremes
			if (iType == -1)
			{
				if (value > _thresholds[0])
				{
					iType = 0;
				}
				else
				{
					iType = _thresholds.length - 2;
				}
			}
			
			return iType;
		}
		
		private function SetBottom()
		{
			if (_thresholds.length == 0)
			{
				_bottom = 0;
				return;
			}
			
			var nMin:Number = _thresholds[_thresholds.length - 1];
			var nMiddle:Number = (_thresholds[0] + nMin) / 2.0;
			var nDifference:Number = nMiddle - nMin;
			_bottom = (Math.random() * nDifference) + nMin;
		}
		
		private function SetTop()
		{
			if (_thresholds.length == 0)
			{
				_top = 0;
				return;
			}
			
			var nMiddle:Number = (_thresholds[0] + _thresholds[_thresholds.length - 1]) / 2.0;
			var nDifference:Number = _thresholds[0] - nMiddle;
			_top = (Math.random() * nDifference) + nMiddle;
		}
	}
}