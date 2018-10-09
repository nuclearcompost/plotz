package
{
	import flash.display.MovieClip;
	
	//-----------------------
	//Purpose:				A bag of Fertilizer that can be bought and sold. Becomes a Fertilizer when used.
	//
	//Properties:
	//	name:int { get } = the BagFertilizer display name
	//	priceModifier:int = priceModifier for the BagFertilizer
	//	type:int = the type of BagFertilizer
	//
	//Methods:
	//	GetFertilizerDuration():int = return the BagFertilizer's duration
	//	GetFertilizerGraphics():MovieClip = get a movieclip to display in the fertilizer preview
	//	GetFertilizerName():String = return the BagFertilizer's name
	//	GetFertilizerNutrientSet():NutrientSet = return the amount of nutrients in the BagFertilizer
	//	GetFertilizerToxicity():Number = return the BagFertilizer's total toxicity amount
	//	GetGraphics():MovieClip = get a movieclip to display on the MainUI panel that represents this object
	//	GetPreviewGraphics():MovieClip = get a movieclip to display on the MainUI panel that represents the preview of this object
	//	GetPrice():int = get the price for this BagFertilizer
	//
	//Static Methods:
	//	GetTotalNutrients(type:int):Number = get the sum of all nutrients for the given type of BagFertilizer
	//
	//-----------------------
	public class BagFertilizer extends Item implements IConstantPrice, IFertilizerSource
	{
		// Constants //
		
		public static const TYPE_STEADY_GREEN:int = 0;
		public static const TYPE_RAPID_GREEN:int = 1;
		public static const TYPE_STEADY_ORANGE:int = 2;
		public static const TYPE_RAPID_ORANGE:int = 3;
		public static const TYPE_STEADY_BLUE:int = 4;
		public static const TYPE_RAPID_BLUE:int = 5;
		
		// indexed by fertilizer type, nutrient type
		public static const AMOUNT:Array = [ [ 100, 30, 10 ],
											 [ 120, 36, 12 ],
											 [ 10, 100, 30 ],
											 [ 12, 120, 36 ],
											 [ 30, 10, 100 ],
											 [ 36, 12, 120 ]
										   ];
		
		public static const TOXICITY:Array = [ 0, 15, 0, 15, 0, 15 ];
		
		public static const DURATION:Array = [ 10, 3, 10, 3, 10, 3 ];
		
		public static const NAME:Array = [ "Steady Green Fertilizer",
										   "Rapid Green Fertilizer",
										   "Steady Orange Fertilizer",
										   "Rapid Orange Fertilizer",
										   "Steady Blue Fertilizer",
										   "Rapid Blue Fertilizer"
										 ];
		
		public static const PRICE:Array = [ 25, 20, 25, 20, 25, 20 ];
		
		
		//- Constants -//
		
		
		// Public Properties //
	
		public override function get name():String
		{
			return BagFertilizer.NAME[_type];
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
		
		public function set type(val:int):void
		{
			_type = val;
		}
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		private var _priceModifier:int;
		private var _type:int;
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function BagFertilizer(type:int = -1, priceModifier:int = -1)
		{
			_type = type;
			_priceModifier = priceModifier;
			
			if (_priceModifier == -1)
			{
				_priceModifier = ItemPricingService.PRICE_MOD_STANDARD;
			}
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		/// Static Methods ///
		
		
		///- Static Methods -///
		
		
		/// Instance Methots ///
		
		// create the Fertilizer instance spawned by this BagFertilizer
		public function CreateFertilizer():Fertilizer
		{
			var oFertilizer:Fertilizer = new Fertilizer(this, this.GetFertilizerNutrientSet(), this.GetFertilizerToxicity(), this.GetFertilizerName(), this.GetFertilizerDuration(),
														this.GetFertilizerDuration());
			
			return oFertilizer;
		}
		
		// return the BagFertilizer's duration
		public function GetFertilizerDuration():int
		{
			var iDuration:int = BagFertilizer.DURATION[_type];
			
			return iDuration;
		}
		
		// get a movieclip to display in the fertilizer preview
		public function GetFertilizerGraphics():MovieClip
		{
			var oGraphics:BagFertilizer_MC = new BagFertilizer_MC();
			oGraphics.gotoAndStop(_type + 1);
			return oGraphics;
		}
		
		// return the BagFertilizer's name
		public function GetFertilizerName():String
		{
			var sName:String = BagFertilizer.NAME[_type];
			
			return sName;
		}
		
		// return the amount of nutrients in the BagFertilizer
		public function GetFertilizerNutrientSet():NutrientSet
		{
			var oNutrients:NutrientSet = new NutrientSet(BagFertilizer.AMOUNT[_type][0], BagFertilizer.AMOUNT[_type][1], BagFertilizer.AMOUNT[_type][2]);
			
			return oNutrients;
		}
		
		// return the BagFertilizer's total toxicity amount
		public function GetFertilizerToxicity():Number
		{
			var iToxicity:int = BagFertilizer.TOXICITY[_type];
			
			return iToxicity;
		}
		
		// get a movieclip to display on the MainUI panel that represents this object
		public function GetGraphics():MovieClip
		{
			var oGraphics:BagFertilizer_MC = new BagFertilizer_MC();
			oGraphics.gotoAndStop(_type + 1);
			return oGraphics;
		}
		
		public override function GetItemGraphics():MovieClip
		{
			var mcItem:MovieClip = this.GetGraphics();
			
			return mcItem;
		}
		
		// get a movieclip to display on the MainUI panel that represents the preview of this object
		public function GetPreviewGraphics():MovieClip
		{
			var oGraphics:MovieClip = new MovieClip();
			
			var oBackground:BagFertilizerPreview_MC = new BagFertilizerPreview_MC();
			oBackground.Fertilizer.text = String(BagFertilizer.NAME[_type]);
			oBackground.Description.text = this.GetDescription();
			oGraphics.addChild(oBackground);
			
			var oFertilizerGraphics:BagFertilizer_MC = new BagFertilizer_MC();
			oFertilizerGraphics.gotoAndStop(_type + 1);
			oFertilizerGraphics.x = 5;
			oFertilizerGraphics.y = 5;
			oGraphics.addChild(oFertilizerGraphics);
			
			return oGraphics;
		}
		
		// get the price for this BagFertilizer
		public function GetPrice():int
		{
			var iPrice:int = BagFertilizer.PRICE[_type];
			
			return iPrice;
		}
		
		///- Instance Methods -///
		
		// get the sum of all nutrients for the given type of BagFertilizer
		public static function GetTotalNutrients(type:int):Number
		{
			var nTotalNutrients:Number = (BagFertilizer.AMOUNT[type][0] + BagFertilizer.AMOUNT[type][1] + BagFertilizer.AMOUNT[type][2]);
						
			return nTotalNutrients;
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		private function GetDescription():String
		{
			var lDescriptions:Array = [ "All natural fertilizer with lots of " + Soil.NUTRIENT1_NAME,
										"Powerful chemical fertilizer with lots of " + Soil.NUTRIENT1_NAME,
										"All natural fertilizer with lots of " + Soil.NUTRIENT2_NAME,
										"Powerful chemical fertilizer with lots of " + Soil.NUTRIENT2_NAME,
										"All natural fertilizer with lots of " + Soil.NUTRIENT3_NAME,
										"Powerful chemical fertilizer with lots of " + Soil.NUTRIENT3_NAME,
									  ];
			
			var sDescription = lDescriptions[_type];
			
			return sDescription;
		}
		
		//- Private Methods -//
	}
}