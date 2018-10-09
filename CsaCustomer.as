package
{
	//-----------------------
	//Purpose:				An entity that can sign up for a farm's CSA program
	//
	//Properties:
	//	
	//Methods:
	//	
	//-----------------------
	public class CsaCustomer
	{
		// Constants //
		
		//- Constants -//
		
		
		// Public Properties //
		
		public function get deliveryScore():int
		{
			return _deliveryScore;
		}
		
		public function set deliveryScore(value:int):void
		{
			_deliveryScore = value;
		}
		
		public function get gotDelivery():Boolean
		{
			return _gotDelivery;
		}
		
		public function set gotDelivery(value:Boolean):void
		{
			_gotDelivery = value;
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function set name(value:String):void
		{
			_name = value;
		}
		
		public function get signedUp():Boolean
		{
			return _signedUp;
		}
		
		public function set signedUp(value:Boolean):void
		{
			_signedUp = value;
		}
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		private var _deliveryScore:int;
		private var _gotDelivery:Boolean;
		private var _name:String;
		private var _signedUp:Boolean;
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function CsaCustomer(name:String = "", deliveryScore:int = 0, gotDelivery:Boolean = false, signedUp:Boolean = false)
		{
			_name = name;
			_deliveryScore = deliveryScore;
			_gotDelivery = gotDelivery;
			_signedUp = signedUp;
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		//- Private Methods -//
		
		
		// Testing Methods //
		
		//- Testing Methods -//
	}
}