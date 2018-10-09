package
{
	import flash.display.MovieClip;
	
	//-----------------------
	//Purpose:				A set of nutrients and possibly toxicity that discharges to the soil for a certain number of days
	//
	//Properties:
	//	daysLeft:int = the remaining number of days for the Fertilizer to discharge nutrients
	//	name:String = a user-visible name of the Fertilizer
	//	nutrients:NutrientSet = the total remaining nutrients the Fertilizer can discharge
	//	source:IFertilizerSource = the object that spawned this Fertilizer
	//	totalDays:int = the total number of days for the Fertilizer to discharge nutrients
	//	toxicity:int = the total remaining toxicity for the Fertilizer to discharge
	//
	//Methods:
	//	Discharge():void = decrement all values of fertilizer for one daily usage
	//	GetDataPreviewGraphics():MovieClip = get a movieclip to display on the MainUI panel that represents the data preview of this object
	//	GetDailyNutrientDischarge():NutrientSet = get the set of nutrients the Fertilizer discharges each day
	//	GetDailyToxicityDischarge():int = get the amount of toxicity the Fertilizer discharges each day
	//
	//-----------------------
	public class Fertilizer implements IMicrobeHost
	{
		// Constants //
		
		//- Constants -//
		
		
		// Public Properties //
	
		public function get daysLeft():int
		{
			return _daysLeft;
		}
		
		public function set daysLeft(val:int):void
		{
			_daysLeft = val;
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function set name(value:String):void
		{
			_name = value;
		}
		
		public function get nutrients():NutrientSet
		{
			return _nutrients;
		}
		
		public function set nutrients(value:NutrientSet):void
		{
			_nutrients = value;
		}
		
		public function get source():IFertilizerSource
		{
			return _source;
		}
		
		public function set source(value:IFertilizerSource):void
		{
			_source = value;
		}
		
		public function get totalDays():int
		{
			return _totalDays;
		}
		
		public function set totalDays(value:int):void
		{
			_totalDays = value;
		}
		
		public function get toxicity():int
		{
			return _toxicity;
		}
		
		public function set toxicity(value:int):void
		{
			_toxicity = value;
		}
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		private var _daysLeft:int;
		private var _name:String;
		private var _nutrients:NutrientSet;
		private var _source:IFertilizerSource;
		private var _totalDays:int;
		private var _toxicity:int;
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function Fertilizer(source:IFertilizerSource = null, nutrients:NutrientSet = null, toxicity:int = 0, name:String = "", daysLeft:int = 0, totalDays:int = 0)
		{
			_source = source;
			_nutrients = nutrients;
			_toxicity = toxicity;
			_name = name;
			_daysLeft = daysLeft;
			_totalDays = totalDays;
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		// decrement all values of fertilizer for one daily usage
		public function Discharge():void
		{
			_nutrients.n1 -= (_nutrients.n1 / _daysLeft);
			_nutrients.n2 -= (_nutrients.n2 / _daysLeft);
			_nutrients.n3 -= (_nutrients.n3 / _daysLeft);
			_toxicity -= (_toxicity / _daysLeft);
			_daysLeft--;
		}
		
		// get a movieclip to display on the MainUI panel that represents the data preview of this object
		public function GetDataPreviewGraphics():MovieClip
		{
			var oGraphics:MovieClip = new MovieClip;
			
			var oBackground:FertilizerDataPreview_MC = new FertilizerDataPreview_MC();
			oBackground.Fertilizer.text = _name;
			oBackground.DaysLeft.text = String(_daysLeft);
			oGraphics.addChild(oBackground);
			
			var oPreview:MovieClip = _source.GetFertilizerGraphics();
			oPreview.x = 5;
			oPreview.y = 5;
			oGraphics.addChild(oPreview);
			
			return oGraphics;
		}
		
		// get the set of nutrients the Fertilizer discharges each day
		public function GetDailyNutrientDischarge():NutrientSet
		{
			var oNutrientSet:NutrientSet = new NutrientSet();
			
			oNutrientSet.n1 = _nutrients.n1 / _daysLeft;
			oNutrientSet.n2 = _nutrients.n2 / _daysLeft;
			oNutrientSet.n3 = _nutrients.n3 / _daysLeft;
			
			return oNutrientSet;
		}
		
		// get the amount of toxicity the Fertilizer discharges each day
		public function GetDailyToxicityDischarge():int
		{
			var iToxicity:int = _toxicity / _daysLeft;
			
			return iToxicity;
		}
		
		public function GetUniqueHostCode():String
		{
			var sHostName:String = _name;
			
			return sHostName;
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		//- Private Methods -//
		
		
		// Testing Methods //
		
		public static function RunTests():Array
		{
			var lResults:Array = new Array();
			
			lResults.push(Fertilizer.DischargeReducesNutrients());
			lResults.push(Fertilizer.DischargeReducesToxicity());
			lResults.push(Fertilizer.DischargeReducesDaysLeft());
			
			return lResults;
		}
		
		private static function DischargeReducesNutrients():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Fertilizer", "DischargeReducesNutrients");
			var oFertilizer:Fertilizer = new Fertilizer(null, new NutrientSet(30, 20, 10), 40, "TestFertilizer", 10, 10);
			var oExpected:NutrientSet = new NutrientSet(27, 18, 9);
			
			oResult.expected = oExpected.PrettyPrint();
			oFertilizer.Discharge();
			oResult.actual = oFertilizer.nutrients.PrettyPrint();
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function DischargeReducesToxicity():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Fertilizer", "DischargeReducesToxicity");
			var oFertilizer:Fertilizer = new Fertilizer(null, new NutrientSet(30, 20, 10), 40, "TestFertilizer", 10, 10);
			
			oResult.expected = "36";
			oFertilizer.Discharge();
			oResult.actual = String(oFertilizer.toxicity);
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function DischargeReducesDaysLeft():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Fertilizer", "DischargeReducesDaysLeft");
			var oFertilizer:Fertilizer = new Fertilizer(null, new NutrientSet(30, 20, 10), 40, "TestFertilizer", 10, 10);
			
			oResult.expected = "9";
			oFertilizer.Discharge();
			oResult.actual = String(oFertilizer.daysLeft);
			oResult.TestEquals();
			
			return oResult;
		}
		
		//- Testing Methods -//
	}
}