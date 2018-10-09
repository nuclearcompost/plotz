package
{
	//-----------------------
	//Purpose:				Keep track of nutrient values
	//
	//Public Properties:
	//	
	//Public Methods:
	//	
	//-----------------------
	public class NutrientSet
	{
		// Constants //
		
		//- Constants -//
		
		
		// Public Properties //
		
		public function get n1():Number
		{
			return _n1;
		}
		
		public function set n1(value:Number):void
		{
			_n1 = value;
		}
		
		public function get n2():Number
		{
			return _n2;
		}
		
		public function set n2(value:Number):void
		{
			_n2 = value;
		}
		
		public function get n3():Number
		{
			return _n3;
		}
		
		public function set n3(value:Number):void
		{
			_n3 = value;
		}
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		private var _n1:Number;
		private var _n2:Number;
		private var _n3:Number;
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function NutrientSet(n1:Number = 0, n2:Number = 0, n3:Number = 0)
		{
			_n1 = n1;
			_n2 = n2;
			_n3 = n3;
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		public static function GetSum(nutrientSets:Array):NutrientSet
		{
			var oSum:NutrientSet = new NutrientSet(0, 0, 0);
			
			if (nutrientSets == null)
			{
				return oSum;
			}
			
			for (var i:int = 0; i < nutrientSets.length; i++)
			{
				if (!(nutrientSets[i] is NutrientSet))
				{
					continue;
				}
				
				var oSet:NutrientSet = NutrientSet(nutrientSets[i]);
				
				oSum.n1 += oSet.n1;
				oSum.n2 += oSet.n2;
				oSum.n3 += oSet.n3;
			}
			
			return oSum;
		}
		
		public function GetCopy():NutrientSet
		{
			var oNew:NutrientSet = new NutrientSet(_n1, _n2, _n3);
			
			return oNew;
		}
		
		public function GetMinimum(compareTo:NutrientSet):NutrientSet
		{
			var oNutrientSet:NutrientSet = new NutrientSet(_n1, _n2, _n3);
			
			if (compareTo.n1 < _n1)
			{
				oNutrientSet.n1 = compareTo.n1;
			}
			if (compareTo.n2 < _n2)
			{
				oNutrientSet.n2 = compareTo.n2;
			}
			if (compareTo.n3 < _n3)
			{
				oNutrientSet.n3 = compareTo.n3;
			}
			
			return oNutrientSet;
		}
		
		public function HasSameValues(compareTo:NutrientSet):Boolean
		{
			var nEpsilon:Number = 0.00001;
			
			if (Math.abs(_n1 - compareTo.n1) < nEpsilon && Math.abs(_n2 - compareTo.n2) < nEpsilon && Math.abs(_n3 - compareTo.n3) < nEpsilon)
			{
				return true;
			}
			
			return false;
		}
		
		public function PrettyPrint():String
		{
			return "(" + _n1 + ", " + _n2 + ", " + _n3 + ")";
		}
		
		//- Public Methods -//
		
		
		// Protected Methods //
		
		//- Protected Methods -//
		
		// Test Methods //
		
		public static function RunTests():Array
		{
			var lResults:Array = new Array();
			
			lResults.push(NutrientSet.TestGetMinimum());
			lResults.push(NutrientSet.HasSameValues());
			lResults.push(NutrientSet.DontHaveSameValues());
			lResults.push(NutrientSet.TestPrettyPrint());
			lResults.push(NutrientSet.GetSumAllZeroIfNullArray());
			lResults.push(NutrientSet.GetSumSkipsJunk());
			lResults.push(NutrientSet.TestGetSum());
			
			return lResults;
		}
		
		private static function TestGetMinimum():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("NutrientSet", "TestGetMinimum");
			var oNutrientSet:NutrientSet = new NutrientSet(0, 100, 50);
			var oCompareTo:NutrientSet = new NutrientSet(100, 0, 50);
			var oExpected:NutrientSet = new NutrientSet(0, 0, 50);
			var oActual:NutrientSet = oNutrientSet.GetMinimum(oCompareTo);
			
			oResult.expected = oExpected.PrettyPrint();
			oResult.actual = oActual.PrettyPrint();
			
			if (oExpected.HasSameValues(oActual))
			{
				oResult.status = UnitTestResult.STATUS_PASS;
			}
			else
			{
				oResult.status = UnitTestResult.STATUS_FAIL;
			}
			
			return oResult;
		}
		
		private static function HasSameValues():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("NutrientSet", "HasSameValues");
			var oNutrientSet:NutrientSet = new NutrientSet(0, 100, 50);
			var oCompareTo:NutrientSet = new NutrientSet(0, 100, 50);
			var oExpected:Boolean = true;
			var oActual:Boolean = oNutrientSet.HasSameValues(oCompareTo);
			
			oResult.expected = String(oExpected);
			oResult.actual = String(oActual);
			
			if (oExpected == oActual)
			{
				oResult.status = UnitTestResult.STATUS_PASS;
			}
			else
			{
				oResult.status = UnitTestResult.STATUS_FAIL;
				oResult.message = "Fail: expected values of " + oNutrientSet.PrettyPrint() + " and " + oCompareTo.PrettyPrint() + " to be considered the same";
			}
			
			return oResult;
		}
		
		private static function DontHaveSameValues():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("NutrientSet", "DontHaveSameValues");
			var oNutrientSet:NutrientSet = new NutrientSet(0, 100, 50);
			var oCompareTo:NutrientSet = new NutrientSet(0, 100.1, 50);
			var oExpected:Boolean = false;
			var oActual:Boolean = oNutrientSet.HasSameValues(oCompareTo);
			
			oResult.expected = String(oExpected);
			oResult.actual = String(oActual);
			
			if (oExpected == oActual)
			{
				oResult.status = UnitTestResult.STATUS_PASS;
			}
			else
			{
				oResult.status = UnitTestResult.STATUS_FAIL;
				oResult.message = "Fail: expected values of " + oNutrientSet.PrettyPrint() + " and " + oCompareTo.PrettyPrint() + " to be considered different";
			}
			
			return oResult;
		}
		
		private static function TestPrettyPrint():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("NutrientSet", "TestPrettyPrint");
			var oNutrientSet:NutrientSet = new NutrientSet(0, 100, 50.2);
			var oExpected:String = "(0, 100, 50.2)";
			var oActual:String = oNutrientSet.PrettyPrint();
			
			oResult.expected = oExpected;
			oResult.actual = oActual;
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GetSumAllZeroIfNullArray():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("NutrientSet", "GetSumAllZeroIfNullArray");
			
			oResult.expected = "(0, 0, 0)";
			oResult.actual = NutrientSet.GetSum(null).PrettyPrint();
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GetSumSkipsJunk():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("NutrientSet", "GetSumSkipsJunk");
			
			var oN1:NutrientSet = new NutrientSet(-1, 0, 1);
			var oN3:NutrientSet = new NutrientSet(1, 2, 3);
			var oSets:Array = [ oN1, null, oN3, new Plant(Plant.TYPE_ASPARAGUS) ];
			
			oResult.expected = "(0, 2, 4)";
			oResult.actual = NutrientSet.GetSum(oSets).PrettyPrint();
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function TestGetSum():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("NutrientSet", "TestGetSum");
			
			var oN1:NutrientSet = new NutrientSet(-1, 0, 1);
			var oN2:NutrientSet = new NutrientSet(10, 10, 10);
			var oN3:NutrientSet = new NutrientSet(1, 2, 3);
			var oSets:Array = [ oN1, oN2, oN3 ];
			
			oResult.expected = "(10, 12, 14)";
			oResult.actual = NutrientSet.GetSum(oSets).PrettyPrint();
			oResult.TestEquals();
			
			return oResult;
		}
		
		//- Test Methods -//
	}
}