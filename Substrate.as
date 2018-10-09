package
{
	//-----------------------
	//Purpose:				
	//Public Properties:
	//	
	//Public Methods:
	//	
	//-----------------------
	public class Substrate
	{
		// Constants //
		
		public static const NAME:Array = [ "Sand", "Loam", "Clay", "" ];
		
		public static const MAX_TYPE:int = 3;
		public static const TYPE_SAND:int = 0;
		public static const TYPE_LOAM:int = 1;
		public static const TYPE_CLAY:int = 2;
		public static const TYPE_NONE:int = 3;
		
		public static const MAX_SATURATION:Array = [ 70, 85, 100, 100 ];
		
		public static const DRAIN_AMOUNT:Array = [ 2.0, 1.5, 1.0, 0 ];
		public static const DRAIN_THRESHOLD:Array = [ 35, 50, 65, 0 ];
		
		public static const ABSORB_FACTOR:Array = [ 0.7, 0.85, 1.0, 0 ];
		
		//- Constants -//
		
		
		// Public Properties //
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function Substrate()
		{
			
		}
		
		public static function GetDrainAmount(type:int, saturation:Number):Number
		{
			var nDrainAmount:Number = 0.0;
			
			if (saturation > Substrate.DRAIN_THRESHOLD[type])
			{
				nDrainAmount = Substrate.DRAIN_AMOUNT[type];
			}
			
			return nDrainAmount;
		}
		
		public static function GetName(type:int):String
		{
			return Substrate.NAME[type];
		}
	}
}