package
{
	import flash.display.MovieClip;
	
	//-----------------------
	//Purpose:				A building or item big enough that a Plant can't grow in the same spot, that can be bought, sold, and moved around on the Farm
	//
	//Public Properties:
	//	
	//Public Methods:
	//	
	//Extended By:
	//	Compost Bin
	//
	//-----------------------
	public class ItemBldg extends Bldg implements IItem, IConstantPrice
	{
		// Constants //
		
		//- Constants -//
		
		
		// Public Properties //
		
		public override function get bldgType():int
		{
			trace("ItemBldg bldgType getter accessed!");
			return 0;
		}
		
		public override function get gridDepth():int
		{
			trace("ItemBldg gridDepth getter accessed!");
			return 0;
		}
		
		public override function get gridHeight():int
		{
			trace("ItemBldg gridHeight getter accessed!");
			return 0;
		}
		
		public override function get gridWidth():int
		{
			trace("ItemBldg gridWidth getter accessed!");
			return 0;
		}
		
		public function get name():String
		{
			trace("ItemBldg name getter accessed!");
			return "";
		}
		
		public function get priceModifier():int
		{
			return _priceModifier;
		}
		
		public function set priceModifier(value:int):void
		{
			_priceModifier = value;
		}
		
		public function get type():int
		{
			trace("ItemBldg type getter accessed!");
			return 0;
		}
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		private var _priceModifier:int;
		private var _type:int;
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function ItemBldg(type:int = 0, origin:GridLocation = null, priceModifier:int = -1)
		{
			super(origin);
			
			_type = type;
			_priceModifier = priceModifier;
			
			if (_priceModifier == -1)
			{
				_priceModifier = ItemPricingService.PRICE_MOD_STANDARD;
			}
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		public override function GetChildMenu(gameController:GameController, startTab:int = 0):ChildMenuFrame
		{
			trace("ItemBldg GetChildMenu called");
			return null;
		}
		
		public override function GetGraphics():MovieClip
		{
			trace("ItemBldg GetGraphics called");
			return null;
		}
		
		public function GetItemGraphics():MovieClip
		{
			trace("ItemBldg GetItemGraphics called");
			return null;
		}
		
		public override function GetMenu(gameController:GameController):ParentMenuFrame
		{
			trace("ItemBldg GetMenu called");
			return null;
		}
		
		public override function GetPreviewGraphics():MovieClip
		{
			trace("ItemBldg GetPreviewGraphics called");
			return null;
		}
		
		public function GetPrice():int
		{
			trace("ItemBldg GetPrice called");
			return -1;
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		//- Private Methods -//
		
		
		// Testing Methods //
		
		//- Testing Methods -//
	}
}