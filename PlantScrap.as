package
{
	import flash.display.MovieClip;
	
	//-----------------------
	//Purpose:				Scrap plant material that holds some of the plant's original nutrients
	//
	//Public Properties:
	//	
	//Public Methods:
	//	
	//-----------------------
	public class PlantScrap extends Item implements IConstantPrice, IDecomposes, IFertilizerSource
	{
		// Constants //
		
		//- Constants -//
		
		
		// Public Properties //
		
		public function get n1():Number
		{
			var n1:Number = 0.0;
			
			if (_nutrientSet != null)
			{
				n1 = _nutrientSet.n1;
			}
			
			return n1;
		}
		
		public function get n2():Number
		{
			var n2:Number = 0.0;
			
			if (_nutrientSet != null)
			{
				n2 = _nutrientSet.n2;
			}
			
			return n2;
		}
		
		public function get n3():Number
		{
			var n3:Number = 0.0;
			
			if (_nutrientSet != null)
			{
				n3 = _nutrientSet.n3;
			}
			
			return n3;
		}
		
		public override function get name():String
		{
			return "Plant Scrap";
		}
		
		public function get nutrientSet():NutrientSet
		{
			return _nutrientSet;
		}
		
		public function set nutrientSet(value:NutrientSet):void
		{
			_nutrientSet = value;
		}
		
		public override function get priceModifier():int
		{
			return -1;
		}
		
		public override function set priceModifier(value:int):void
		{
			return;
		}
		
		public override function get type():int
		{
			return -1;
		}
		
		public function get toxicity():Number
		{
			return _toxicity;
		}
		
		public function set toxicity(value:Number):void
		{
			_toxicity = value;
		}
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		private var _decomposeDaysLeft:int;
		private var _nutrientSet:NutrientSet;
		private var _toxicity:Number;
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function PlantScrap(nutrients:NutrientSet = null, toxicity:Number = 0, decomposeDaysLeft:int = 0)
		{
			_nutrientSet = nutrients;
			_toxicity = toxicity;
			_decomposeDaysLeft = decomposeDaysLeft;
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		public function CreateCompost():Compost
		{
			var oCompost:Compost = new Compost(new NutrientSet(_nutrientSet.n1, _nutrientSet.n2, _nutrientSet.n3), _toxicity);
			
			return oCompost;
		}
		
		public function CreateFertilizer():Fertilizer
		{
			var oFertilizer:Fertilizer = new Fertilizer(this, this.GetFertilizerNutrientSet(), this.GetFertilizerToxicity(), this.GetFertilizerName(), this.GetFertilizerDuration(),
														this.GetFertilizerDuration());
			
			return oFertilizer;
		}
		
		public function GetDecomposeDaysLeft():int
		{
			return _decomposeDaysLeft;
		}
		
		public function GetFertilizerDuration():int
		{
			return 5;
		}
		
		public function GetFertilizerGraphics():MovieClip
		{
			var mcScrap:PlantScrap_MC = new PlantScrap_MC();
			return mcScrap;
		}
		
		public function GetFertilizerName():String
		{
			return "Plant Scraps";
		}
		
		public function GetFertilizerNutrientSet():NutrientSet
		{
			// plant scraps give only 1/2 of original plant nutrients as fertilizer
			var oNutrientSet:NutrientSet = new NutrientSet(_nutrientSet.n1 / 2, _nutrientSet.n2 / 2, _nutrientSet.n3 / 2);
			
			return oNutrientSet;
		}
		
		public function GetFertilizerToxicity():Number
		{
			return _toxicity;
		}
		
		public function GetGraphics():MovieClip
		{
			var mcScrap:PlantScrap_MC = new PlantScrap_MC();
			return mcScrap;
		}
		
		public override function GetItemGraphics():MovieClip
		{
			var mcItem:MovieClip = this.GetGraphics();
			
			return mcItem;
		}
		
		public function GetGridGraphics():MovieClip
		{
			var mcScrap:PlantScrap_MC = new PlantScrap_MC();
			mcScrap.width /= 2;
			mcScrap.height /= 2;
			return mcScrap;
		}
		
		public function GetPrice():int
		{
			return -1;
		}
		
		public function GetPreviewGraphics():MovieClip
		{
			var mcPreview:MovieClip = new MovieClip();
			
			var mcBackground:PlantScrapPreview_MC = new PlantScrapPreview_MC();
			mcPreview.addChild(mcBackground);
			
			var mcScrap:PlantScrap_MC = new PlantScrap_MC();
			mcScrap.x = 5;
			mcScrap.y = 5;
			mcPreview.addChild(mcScrap);
			
			return mcPreview;
		}
		
		public function SetDecomposeDaysLeft(days:int):void
		{
			_decomposeDaysLeft = days;
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		//- Private Methods -//
		
		
		// Testing Methods //
		
		//- Testing Methods -//
	}
}