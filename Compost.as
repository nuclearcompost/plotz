package
{
	import flash.display.MovieClip;
	
	//-----------------------
	//Purpose:				A fertilizer source made from breaking down organic matter over time
	//
	//Properties:
	//	
	//Methods:
	//	
	//-----------------------
	public class Compost extends Item implements IConstantPrice, IFertilizerSource
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
			return "Compost";
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
		
		private var _nutrientSet:NutrientSet;
		private var _toxicity:Number;
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function Compost(nutrients:NutrientSet = null, toxicity:Number = 0)
		{
			_nutrientSet = nutrients;
			_toxicity = toxicity;
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		public function CreateFertilizer():Fertilizer
		{
			var oFertilizer:Fertilizer = new Fertilizer(this, this.GetFertilizerNutrientSet(), this.GetFertilizerToxicity(), this.GetFertilizerName(), this.GetFertilizerDuration(),
														this.GetFertilizerDuration());
			
			return oFertilizer;
		}
		
		public function GetFertilizerDuration():int
		{
			return 5;
		}
		
		public function GetFertilizerGraphics():MovieClip
		{
			var mcCompost:Compost_MC = new Compost_MC();
			
			return mcCompost;
		}
		
		public function GetFertilizerName():String
		{
			return "Compost";
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
			var mcCompost:Compost_MC = new Compost_MC();
			
			return mcCompost;
		}
		
		public override function GetItemGraphics():MovieClip
		{
			var mcItem:MovieClip = this.GetGraphics();
			
			return mcItem;
		}
		
		public function GetPrice():int
		{
			return -1;
		}
		
		public function GetPreviewGraphics():MovieClip
		{
			var mcPreview:MovieClip = new MovieClip();
			
			var mcBackground:CompostPreview_MC = new CompostPreview_MC();
			mcPreview.addChild(mcBackground);
			
			var mcCompost:Compost_MC = new Compost_MC();
			mcPreview.addChild(mcCompost);
			
			return mcPreview;
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		//- Private Methods -//
		
		
		// Testing Methods //
		
		//- Testing Methods -//
	}
}