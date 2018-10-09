package
{
	//-----------------------
	//Purpose:				State object for a Player's CSA information
	//
	//Properties:
	//	
	//Methods:
	//	
	//-----------------------
	public class CsaState
	{
		// Constants //
		
		public static const DAY_TYPE_SIGNUP:int = 0;
		public static const DAY_TYPE_STATUS:int = 1;
		public static const DAY_TYPE_DELIVERY:int = 2;
		
		public static const MIN_CUSTOMER:int = 1;
		public static const MAX_CUSTOMERS:int = 9;
		
		public static const PRODUCTS_PER_CUSTOMER:int = 4;
		
		//- Constants -//
		
		
		// Public Properties //
		
		public function get customers():Array
		{
			return _customers;
		}
		
		public function set customers(value:Array):void
		{
			_customers = value;
		}
		
		public function get deliveryInventory():Inventory
		{
			return _deliveryInventory;
		}
		
		public function set deliveryInventory(value:Inventory):void
		{
			_deliveryInventory = value;
		}
		
		public function get maxCustomers():int
		{
			return _maxCustomers;
		}
		
		public function set maxCustomers(value:int):void
		{
			_maxCustomers = value;
		}
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		private var _customers:Array;
		private var _deliveryInventory:Inventory;
		private var _maxCustomers:int;
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function CsaState(deliveryInventory:Inventory = null, customers:Array = null, maxCustomers:int = 3)
		{
			_deliveryInventory = deliveryInventory;
			if (_deliveryInventory == null)
			{
				_deliveryInventory = new Inventory(4, "CSA Delivery", [ "Fruit" ]);
			}
			
			_customers = customers;
			if (_customers == null)
			{
				_customers = new Array();
			}
			
			_maxCustomers = maxCustomers;
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