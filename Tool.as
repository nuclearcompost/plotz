package
{
	import flash.display.MovieClip;
	
	//-----------------------
	//Purpose:				Data and methods for a Tool
	//
	//Public Properties:
	//	Charges:int { get; set; } = the number of charges for the Tool
	//	Price:int { get; } = the price of this Tool, in dollars
	//	Type:int { get; } = the Type code of this Tool
	//
	//Public Methods:
	//	GetGraphics():MovieClip = gets a movieclip representation of this Tool
	//	GetPreviewGraphics():MovieClip = gets a movieclip representation of a preview of this Tool for display on the Main UI panel
	//	Refill():void = refills this Tool to the maximum number of charges
	//-----------------------
	public class Tool extends Item
	{
		// Constants //
		public static const DESCRIPTION:Array = [ "Water the soil to increase saturation levels.\nRefill at the Well.",
												  "Cut down plants you don't want anymore.",
												  "Removes a little bit of water from the soil.\nOnly has effect once per tile each day."
												];
		
		public static const NAME:Array = [ "Watering Can", "Sickle", "Hoe" ];
		
		public static const TYPE_WATERING_CAN:int = 0;
		public static const TYPE_SICKLE:int = 1;
		public static const TYPE_HOE:int = 2;
		
		public static const WATER_PER_CHARGE:int = 2;
		
		// indexed by Weather type
		public static const HOE_WATER_REMOVAL_AMOUNT:Array = [ 4, 3, 2, 2, 2 ];
		
		
		//* Constants *//
		
		
		// Public Properties //
		public function get charges():int
		{
			return _charges;
		}
		
		public function set charges(value:int):void
		{
			_charges = value;
		}
		
		public function get graphics():MovieClip
		{
			return _graphics;
		}
		
		public function get maxCharges():int
		{
			return _maxCharges;
		}
		
		public override function get name():String
		{
			return Tool.NAME[_type];
		}
		
		public override function get priceModifier():int
		{
			return _priceModifier;
		}
		
		public override function set priceModifier(value:int):void
		{
			_priceModifier = value;
		}
		
		public override function get type():int
		{
			return _type;
		}
		
		public function set type(value:int):void
		{
			_type = value;
		}
		
		//* Public Properties *//
		
		
		// Private Properties //
		private var _charges:int;
		private var _graphics:MovieClip;
		private var _maxCharges:int;
		private var _priceModifier:int;
		private var _type:int;
		
		//* Private Properties *//
		
	
		// Initialization //
		
		//---------------
		//Purpose:		Construct a new Tool object
		//
		//Parameters:
		//	type:int = the type of Tool
		//
		//Returns:		reference to the new object
		//---------------
		public function Tool(type:int = 0, charges:int = 0, priceModifier:int = -1)
		{
			_type = type;
			
			if (_type == Tool.TYPE_WATERING_CAN)
			{
				_charges = charges;
				_maxCharges = 20;
			}
			
			_priceModifier = priceModifier;
			
			if (_priceModifier == -1)
			{
				_priceModifier = ItemPricingService.PRICE_MOD_STANDARD;
			}
			
			_graphics = null;
		}
	
		//* Initialization *//
		
		
		// Public Methods //
		
		//---------------
		//Purpose:		Get a movieclip that represents this object
		//
		//Parameters:
		//	none
		//
		//Returns:		a movieClip representation of this object
		//---------------
		public function GetGraphics():MovieClip
		{
			if (_graphics != null)
			{
				if (_type == Tool.TYPE_WATERING_CAN)
				{
					_graphics.Charges.text = String(_charges);
					_graphics.charges = _charges;
				}
				
				return _graphics;
			}
			
			if (_type == Tool.TYPE_WATERING_CAN)
			{
				_graphics = new Tool_WateringCan_MC();
				_graphics.Charges.text = String(_charges);
				_graphics.charges = _charges;
			}
			else if (_type == Tool.TYPE_HOE)
			{
				_graphics = new Tool_Hoe_MC();
			}
			else if (_type == Tool.TYPE_SICKLE)
			{
				_graphics = new Tool_Sickle_MC();
			}
			
			return _graphics;
		}
		
		public override function GetItemGraphics():MovieClip
		{
			var mcItem:MovieClip = this.GetGraphics();
			
			return mcItem;
		}
		
		//---------------
		//Purpose:		Get a movieclip to display on the MainUI panel that represents the preview of this object
		//
		//Parameters:
		//	none
		//
		//Returns:		a movieClip representation of a preview of this object for display on the Main UI panel
		//---------------
		public function GetPreviewGraphics():MovieClip
		{
			var oGraphics:MovieClip = new MovieClip();
			
			var oBackground:ToolPreview_MC = new ToolPreview_MC();
			oBackground.Tool.text = String(name);
			oBackground.Description.text = String(Tool.DESCRIPTION[_type]);
			oGraphics.addChild(oBackground);
			
			var oToolGraphics:Tool_Full_MC = new Tool_Full_MC();
			oToolGraphics.x = 5;
			oToolGraphics.y = 5;
			oToolGraphics.gotoAndStop(_type + 1);
			oGraphics.addChild(oToolGraphics);
			
			return oGraphics;
		}
		
		//---------------
		//Purpose:		Refill the charges of this tool to the maximum amount
		//
		//Parameters:
		//	none
		//
		//Returns:		void
		//---------------
		public function Refill():void
		{
			_charges = _maxCharges;
		}
		
		//* Public Methods *//
		
		
		// Protected Methods:
	}
	
}