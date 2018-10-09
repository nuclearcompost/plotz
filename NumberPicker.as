package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	//-----------------------
	//Purpose:				Allow the player to select a number
	//
	//Properties:
	//	
	//Methods:
	//	
	//-----------------------
	public class NumberPicker extends CustomEventPropertyPicker
	{
		// Constants //
		
		//- Constants -//
		
		
		// Public Properties //
		
		public function get digits():Array
		{
			return _digits;
		}
		
		public override function get type():int
		{
			return CustomEventPropertyPicker.TYPE_QUANTITY;
		}
		
		public function get value():int
		{
			return _value;
		}
		
		public function set value(value:int):void
		{
			_value = value;
		}
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		private var _digits:Array;
		private var _numDigits:int;
		private var _value:int;
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function NumberPicker(parent:CalendarMenu, viewState:CustomDayEventViewState, value:int = 1, numDigits:int = 2, digits:Array = null)
		{
			super(parent, viewState);
			
			_value = value;
			
			_numDigits = numDigits;
			if (_numDigits < 1)
			{
				_numDigits = 1;
			}
			
			_digits = digits;
			if (_digits == null)
			{
				_digits = new Array(_numDigits);
				
				for (var i:int = 0; i < _numDigits - 1; i++)
				{
					_digits[i] = 0;
				}
				
				_digits[_numDigits - 1] = 1;
			}
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		public override function GetGraphics():MovieClip
		{
			var mcPicker:MovieClip = new MovieClip();
			
			var btnHeader:Calendar_NumberPicker_Btn = new Calendar_NumberPicker_Btn();
			
			UIManager.AssignButtonText(btnHeader, String(_viewState.event.occurrences));
			
			btnHeader.addEventListener(MouseEvent.CLICK, OnHeaderClick, false, 0, true);
			mcPicker.addChild(btnHeader);
			
			if (_isOpen == true)
			{
				var mcBackground:NumberPicker_Background_MC = new NumberPicker_Background_MC();
				
				var iPanelX:int = (mcBackground.width / -2) + (btnHeader.width / 2);
				var iPanelY:int = 25;
				
				mcBackground.x = iPanelX;
				mcBackground.y = iPanelY;
				mcPicker.addChild(mcBackground);
				
				for (var i:int = 0; i < _numDigits; i++)
				{
					var mcUpArrow:NumberPicker_ArrowUp_MC = new NumberPicker_ArrowUp_MC();
					var iX:int = 10 + (mcUpArrow.width / 2) + (mcUpArrow.width * i) + (15 * i);
					mcUpArrow.x = iPanelX + iX
					mcUpArrow.y = iPanelY + 18;
					mcUpArrow.digitIndex = i;
					mcUpArrow.buttonMode = true;
					mcUpArrow.addEventListener(MouseEvent.CLICK, OnUpArrowClick, false, 0, true);
					mcPicker.addChild(mcUpArrow);
					
					var mcDigit:NumberPicker_Digit_MC = new NumberPicker_Digit_MC();
					mcDigit.x = iPanelX + iX;
					mcDigit.y = iPanelY + 56;
					mcDigit.Digit.text = String(_digits[i]);
					mcPicker.addChild(mcDigit);
					
					var mcDownArrow:NumberPicker_ArrowDown_MC = new NumberPicker_ArrowDown_MC();
					mcDownArrow.x = iPanelX + iX;
					mcDownArrow.y = iPanelY + 94;
					mcDownArrow.digitIndex = i;
					mcDownArrow.buttonMode = true;
					mcDownArrow.addEventListener(MouseEvent.CLICK, OnDownArrowClick, false, 0, true);
					mcPicker.addChild(mcDownArrow);
				}
				
				var btnCancel:NumberPicker_Cancel_Btn = new NumberPicker_Cancel_Btn();
				btnCancel.x = iPanelX + 28;
				btnCancel.y = iPanelY + 134.5;
				btnCancel.addEventListener(MouseEvent.CLICK, OnCancelButtonClick, false, 0, true);
				mcPicker.addChild(btnCancel);
				
				var btnOk:NumberPicker_Ok_Btn = new NumberPicker_Ok_Btn();
				btnOk.x = iPanelX + 79;
				btnOk.y = iPanelY + 134.5;
				btnOk.addEventListener(MouseEvent.CLICK, OnOkButtonClick, false, 0, true);
				mcPicker.addChild(btnOk);
			}
			
			return mcPicker;
		}
		
		public override function GetHeaderWidth():int
		{
			var btnHeader:Calendar_NumberPicker_Btn = new Calendar_NumberPicker_Btn();
			var iWidth:int = btnHeader.width;
			
			return iWidth;
		}
		
		public static function IsValid(gameTime:Time, checkTime:Time):Boolean
		{
			return true;
		}
		
		public function SetDigitsFromValue():void
		{
			var iMultiplier:int = Math.pow(10, _digits.length - 1);
			var iRemainingValue:int = _value;
			
			for (var digit:int = 0; digit < _digits.length; digit++)
			{
				var iValue:int = iRemainingValue / iMultiplier;
				_digits[digit] = iValue;
				
				var iSubValue:int = iValue * iMultiplier;
				iRemainingValue -= iSubValue;
				
				iMultiplier /= 10;
			}
		}
		
		public function SetValueFromDigits():void
		{
			var iNewValue:int = 0;
			var iMultiplier:int = 1;
			
			for (var digit:int = _digits.length - 1; digit >= 0; digit--)
			{
				iNewValue += int(_digits[digit] * iMultiplier);
				iMultiplier *= 10;
			}
			
			_value = iNewValue;
		}
		
		//- Public Methods -//
		
		
		// Protected Methods //
		
		protected override function OnHeaderClick(event:MouseEvent):void
		{
			event.stopPropagation();
			
			_isOpen = !(_isOpen);
			
			if (_isOpen == false)
			{
				SetDigitsFromValue();
			}
			
			_parent.TogglePickersForViewState(this, _viewState);
		}
		
		//- Protected Methods -//
		
		
		// Private Methods //
		
		private function OnCancelButtonClick(event:MouseEvent):void
		{
			event.stopPropagation();
			
			SetDigitsFromValue();
			_isOpen = false;
			
			_parent.Repaint();
		}
		
		private function OnDownArrowClick(event:MouseEvent):void
		{
			event.stopPropagation();
			
			var iDigitIndex:int = event.target.digitIndex;
			var iDigit:int = int(_digits[iDigitIndex]);
			
			iDigit --;
			
			if (iDigit < 0)
			{
				iDigit = 9;
			}
			
			_digits[iDigitIndex] = iDigit;
			
			_parent.Repaint();
		}
		
		private function OnOkButtonClick(event:MouseEvent):void
		{
			event.stopPropagation();
			
			var iOldValue:int = _value;
			SetValueFromDigits();
			_isOpen = false;
			
			if (iOldValue != _value)
			{
				CustomDayEventService.UpdateEventValueFromPicker(_viewState.event, this);
			}
			
			_parent.Repaint();
		}
		
		private function OnUpArrowClick(event:MouseEvent):void
		{
			event.stopPropagation();
			
			var iDigitIndex:int = event.target.digitIndex;
			var iDigit:int = int(_digits[iDigitIndex]);
			
			iDigit++;
			
			if (iDigit > 9)
			{
				iDigit = 0;
			}
			
			_digits[iDigitIndex] = iDigit;
			
			_parent.Repaint();
		}
		
		//- Private Methods -//
		
		
		// Testing Methods //
		
		public static function RunTests():Array
		{
			var lResults:Array = new Array();
			
			lResults.push(NumberPicker.SetDigitsFromValue());
			lResults.push(NumberPicker.SetValueFromDigits());
			
			return lResults;
		}
		
		private static function SetDigitsFromValue():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("NumberPicker", "SetDigitsFromValue");
			var oPicker:NumberPicker = new NumberPicker(null, null, 157, 3, [ 9, 9, 0 ]);
			
			oPicker.SetDigitsFromValue();
			
			oResult.expected = "[ 1, 5, 7 ]";
			oResult.actual = "[ ";
			for (var i:int = 0; i < oPicker.digits.length - 1; i++)
			{
				oResult.actual += (String(oPicker.digits[i]) + ", ");
			}
			
			oResult.actual += (String(oPicker.digits[oPicker.digits.length - 1]));
			oResult.actual += " ]";
			
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function SetValueFromDigits():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("NumberPicker", "SetValueFromDigits");
			var oPicker:NumberPicker = new NumberPicker(null, null, 0, 2, [ 1, 5 ]);
			oPicker.SetValueFromDigits();
			
			oResult.expected = "15";
			oResult.actual = String(oPicker.value);
			oResult.TestEquals();
			
			return oResult;
		}
		
		//- Testing Methods -//
	}
}