package
{
	//-----------------------
	//Purpose:				
	//Public Properties:
	//	
	//Public Methods:
	//	
	//-----------------------
	public class UnitTestResult
	{
		// Constants //
		
		public static const STATUS_COLORS:Array = [ "999999", "00FF00", "FF0000" ];
		public static const STATUS_NAMES:Array = [ "Not Run", "Pass", "Fail" ];
		public static const STATUS_NOT_RUN:int = 0;
		public static const STATUS_PASS:int = 1;
		public static const STATUS_FAIL:int = 2;
		
		//- Constants -//
		
		
		// Public Properties //
		
		public function get actual():String
		{
			return _actual;
		}
		
		public function set actual(value:String):void
		{
			_actual = value;
		}
		
		public function get className():String
		{
			return _className;
		}
		
		public function set className(value:String):void
		{
			_className = value;
		}
		
		public function get expected():String
		{
			return _expected;
		}
		
		public function set expected(value:String):void
		{
			_expected = value;
		}
		
		public function get message():String
		{
			return _message;
		}
		
		public function set message(value:String):void
		{
			_message = value;
		}
		
		public function get status():int
		{
			return _status;
		}
		
		public function set status(value:int):void
		{
			_status = value;
		}
		
		public function get testName():String
		{
			return _testName;
		}
		
		public function set testName(value:String):void
		{
			_testName = value;
		}
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		private var _actual:String;
		private var _className:String;
		private var _expected:String;
		private var _message:String;
		private var _testName:String;
		private var _status:int;
		
		
		//- Private Properties -//
		
	
		// Initialization //
		
		//---------------
		//Purpose:		
		//Parameters:
		//	
		//Returns:		
		//---------------
		public function UnitTestResult(className:String, testName:String)
		{
			_className = className;
			_testName = testName;
			
			_actual = "";
			_expected = "";
			_message = "";
			_status = UnitTestResult.STATUS_NOT_RUN;
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		/*	TestOK
		
		oResult.expected = "No exception";
		oResult.actual = "No exception";
		
		try
		{
			<function call>
		}
		catch (e:Error)
		{
			oResult.actual = String(e);
		}
		
		oResult.TestEquals();
		*/
		
		public static function PrettyPrintIntList(list:Array):String
		{
			var sOutput:String = "[ ";
			
			if (list != null)
			{
				for (var i:int = 0; i < list.length; i++)
				{
					var oObject:Object = list[i];
					
					if (oObject == null)
					{
						continue;
					}
					
					if (!(oObject is int))
					{
						continue;
					}
					
					var iValue:int = int(oObject);
					
					sOutput += String(iValue);
					
					if (i < (list.length - 1))
					{
						sOutput += ",";
					}
					
					sOutput += " ";
				}
			}
			
			sOutput += "]";
			
			return sOutput;
		}
		
		public function TestEquals():void
		{
			if (_expected == _actual)
			{
				_status = UnitTestResult.STATUS_PASS;
			}
			else
			{
				_status = UnitTestResult.STATUS_FAIL;
			}
		}
		
		public function TestFalse(testValue:Boolean):void
		{
			_expected = "false";
			
			if (testValue == false)
			{
				_actual = "false";
				_status = UnitTestResult.STATUS_PASS;
			}
			else
			{
				_actual = "true";
				_status = UnitTestResult.STATUS_FAIL;
			}
		}
		
		public function TestNotNull(target:Object):void
		{
			_expected = "not null";
			
			if (target == null)
			{
				_actual = "null";
				_status = UnitTestResult.STATUS_FAIL;
			}
			else
			{
				_actual = "not null";
				_status = UnitTestResult.STATUS_PASS;
			}
		}
		
		public function TestNull(target:Object):void
		{
			_expected = "null";
			
			if (target == null)
			{
				_actual = "null";
				_status = UnitTestResult.STATUS_PASS;
			}
			else
			{
				_actual = "not null";
				_status = UnitTestResult.STATUS_FAIL;
			}
		}
		
		public function TestTrue(testValue:Boolean):void
		{
			_expected = "true";
			
			if (testValue == true)
			{
				_actual = "true";
				_status = UnitTestResult.STATUS_PASS;
			}
			else
			{
				_actual = "false";
				_status = UnitTestResult.STATUS_FAIL;
			}
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		//- Private Methods -//
		
		
		// Testing Methods //
		
		public static function RunTests():Array
		{
			var lResults:Array = new Array();
			
			lResults.push(UnitTestResult.PrettyPrintIntListEmptyIfListNull());
			lResults.push(UnitTestResult.PrettyPrintIntListEmptyForNonInts());
			lResults.push(UnitTestResult.PrettyPrintIntListCorrectForOneInt());
			lResults.push(UnitTestResult.PrettyPrintIntListCorrectForMultipleInts());
			
			return lResults;
		}
		
		private static function PrettyPrintIntListEmptyIfListNull():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("UnitTestResult", "PrettyPrintIntListEmptyIfListNull");
			var oList:Array = null;
			
			oResult.expected = "[ ]";
			oResult.actual = UnitTestResult.PrettyPrintIntList(oList);
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function PrettyPrintIntListEmptyForNonInts():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("UnitTestResult", "PrettyPrintIntListEmptyForNonInts");
			var oList:Array = [ new UnitTestResult("", ""), new UnitTestResult("", "") ];
			
			oResult.expected = "[ ]";
			oResult.actual = UnitTestResult.PrettyPrintIntList(oList);
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function PrettyPrintIntListCorrectForOneInt():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("UnitTestResult", "PrettyPrintIntListCorrectForOneInt");
			var oList:Array = [ 5 ];
			
			oResult.expected = "[ 5 ]";
			oResult.actual = UnitTestResult.PrettyPrintIntList(oList);
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function PrettyPrintIntListCorrectForMultipleInts():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("UnitTestResult", "PrettyPrintIntListCorrectForMultipleInts");
			var oList:Array = [ 15, 12, 3 ];
			
			oResult.expected = "[ 15, 12, 3 ]";
			oResult.actual = UnitTestResult.PrettyPrintIntList(oList);
			oResult.TestEquals();
			
			return oResult;
		}
		
		/*
		
		private static function ():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("UnitTestResult", "");
			
			return oResult;
		}
		
		*/
		
		//- Testing Methods -//
	}
}