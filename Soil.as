package
{
	import flash.display.MovieClip;
	
	//-----------------------
	//Purpose:				Data and methods for a single block of soil in the world
	//
	//Public Properties:
	//	Nutrient1:Number { get; } = the amount of nutrient 1 in the soil
	//	Nutrient2:Number { get; } = the amount of nutrient 2 in the soil
	//	Nutrient3:Number { get; } = the amount of nutrient 3 in the soil
	//	Saturation:Number { get; } = the amount of water in the soil
	//	Toxicity:Number { get; } = the amount of toxins in the soil
	//
	//Public Methods:
	//	Paint():Soil_MC = gets a graphical representation of this object
	//-----------------------
	public class Soil
	{		
		// Constants //
		public static const NUTRIENT1_NAME:String = "Nitrogen";
		public static const NUTRIENT2_NAME:String = "Phosphorus";
		public static const NUTRIENT3_NAME:String = "Potassium";
		
		public static const MAX_MICROBE_POP:Number = 60;
		
		public static const MAX_NUTRIENT1:int = 400;
		public static const MAX_NUTRIENT2:int = 400;
		public static const MAX_NUTRIENT3:int = 400;
		public static const MAX_TOXICITY:int = 100;
		//* Constants *//
		
		
		// Public Properties //
		
		public function get aeratedToday():Boolean
		{
			return _aeratedToday;
		}
		
		public function set aeratedToday(value:Boolean):void
		{
			_aeratedToday = value;
		}
		
		public function get isPlayerOwned():Boolean
		{
			return _isPlayerOwned;
		}
		
		public function set isPlayerOwned(value:Boolean):void
		{
			_isPlayerOwned = value;
		}
		
		public function get microbes():Array
		{
			return _microbes;
		}
		
		public function set microbes(value:Array):void
		{
			_microbes = value;
			
			if (value == null)
			{
				_microbes = new Array();
			}
		}
		
		public function get nutrient1():Number
		{
			return _nutrient1;
		}
		
		public function set nutrient1(value:Number):void
		{
			_nutrient1 = value;
		}
		
		public function get nutrient2():Number
		{
			return _nutrient2;
		}
		
		public function set nutrient2(value:Number):void
		{
			_nutrient2 = value;
		}
		
		public function get nutrient3():Number
		{
			return _nutrient3;
		}
		
		public function set nutrient3(value:Number):void
		{
			_nutrient3 = value;
		}
		
		public function get saturation():Number
		{
			return _saturation;
		}
		
		public function set saturation(value:Number):void
		{
			_saturation = value;
		}
		
		public function get substrate():int
		{
			return _substrate;
		}
		
		public function set substrate(value:int):void
		{
			_substrate = value;
		}
		
		public function get toxicity():Number
		{
			return _toxicity;
		}
		
		public function set toxicity(value:Number):void
		{
			_toxicity = value;
		}
		
		//* Public Properties *//
		
		
		// Private Properties //
		private var _aeratedToday:Boolean;
		private var _graphics:Soil_MC;
		private var _isPlayerOwned:Boolean;
		private var _microbes:Array;
		private var _nutrient1:Number;
		private var _nutrient2:Number;
		private var _nutrient3:Number;
		private var _saturation:Number;
		private var _substrate:int;
		private var _toxicity:Number;
		
		//* Private Properties *//
		
	
		// Initialization //
		
		//---------------
		//Purpose:		Construct a new Soil object
		//
		//Parameters:
		//	nutrient1:Number = the amount of nutrient 1 in the soil
		//	nutrient2:Number = the amount of nutrient 2 in the soil
		//	nutrient3:Number = the amount of nutrient 3 in the soil
		//	saturation:Number = the amount of water in the soil
		//	toxicity:Number = the amount of toxins in the soil
		//
		//Returns:		reference to the new object
		//---------------
		public function Soil(substrate:int = 3, isPlayerOwned:Boolean = false,
							 nutrient1:Number = Soil.MAX_NUTRIENT1 / 2, nutrient2:Number = Soil.MAX_NUTRIENT2 / 2, nutrient3:Number = Soil.MAX_NUTRIENT3 / 2,
							 saturation:Number = 50, toxicity:Number = 0, microbes:Array = null)
		{
			_isPlayerOwned = isPlayerOwned;
			_nutrient1 = nutrient1;
			_nutrient2 = nutrient2;
			_nutrient3 = nutrient3;
			_saturation = saturation;
			_substrate = substrate;
			_toxicity = toxicity;
			_microbes = microbes;
			
			if (_microbes == null)
			{
				_microbes = new Array();
			}
		}
	
		//* Initialization *//
		
		
		// Public Methods //
		
		//---------------
		//Purpose:		Add some amount of nutrient 1 to the soil
		//
		//Parameters:
		//	amount:Number = the amount of nutrient 1 to add to the soil
		//
		//Returns:		void
		//---------------
		public function AddNutrient1(amount:Number):void
		{
			_nutrient1 += amount;
			
			if (_nutrient1 > Soil.MAX_NUTRIENT1)
			{
				_nutrient1 = Soil.MAX_NUTRIENT1;
			}
		}
		
		//---------------
		//Purpose:		Add some amount of nutrient 2 to the soil
		//
		//Parameters:
		//	amount:Number = the amount of nutrient 2 to add to the soil
		//
		//Returns:		void
		//---------------
		public function AddNutrient2(amount:Number):void
		{
			_nutrient2 += amount;
			
			if (_nutrient2 > Soil.MAX_NUTRIENT2)
			{
				_nutrient2 = Soil.MAX_NUTRIENT2;
			}
		}
		
		//---------------
		//Purpose:		Add some amount of nutrient 3 to the soil
		//
		//Parameters:
		//	amount:Number = the amount of nutrient 3 to add to the soil
		//
		//Returns:		void
		//---------------
		public function AddNutrient3(amount:Number):void
		{
			_nutrient3 += amount;
			
			if (_nutrient3 > Soil.MAX_NUTRIENT3)
			{
				_nutrient3 = Soil.MAX_NUTRIENT3;
			}
		}
		
		//---------------
		//Purpose:		Add some amount of toxicity to the soil
		//
		//Parameters:
		//	amount:Number = the amount of toxicity to add to the soil
		//
		//Returns:		void
		//---------------
		public function AddToxicity(amount:Number):void
		{
			_toxicity += amount;
			
			if (_toxicity > Soil.MAX_TOXICITY)
			{
				_toxicity = Soil.MAX_TOXICITY;
			}
		}
		
		//---------------
		//Purpose:		Add some amount of water to the soil
		//
		//Parameters:
		//	amount:Number = the base amount of water to add to the soil
		//
		//Returns:		void
		//---------------
		public function AddWater(amount:Number):void
		{
			_saturation += (amount * Substrate.ABSORB_FACTOR[_substrate]);
			
			if (_saturation > GetMaxSaturation())
			{
				_saturation = GetMaxSaturation();
			}
		}
		
		public function Disturb(amount:Number):void
		{
			for (var i:int = 0; i < _microbes.length; i++)
			{
				var oMicrobe:Microbe = Microbe(_microbes[i]);
				
				oMicrobe.RemovePopulation(amount);
			}
		}		
		
		public function DisturbPercent(percent:Number):void
		{
			for (var i:int = 0; i < _microbes.length; i++)
			{
				var oMicrobe:Microbe = Microbe(_microbes[i]);
				
				oMicrobe.RemovePopulationPercentage(percent);
			}
		}
		
		public function Drain():void
		{
			var nDrainAmount:Number = Substrate.GetDrainAmount(_substrate, _saturation);
			
			RemoveWater(nDrainAmount);
		}
		
		//---------------
		//Purpose:		Return graphics that represent a data preview of this object for the main UI panel
		//
		//Parameters:
		//	minSat:Number = the minimum Saturation for the Plant on this Soil object
		//	lowSat:Number = the lowest healthy Saturation value for the Plant on this Soil object
		//	highSat:Number = the highest healthy Saturation value for the Plant on this Soil object
		//	maxSat:Number = the maximum Saturation for the Plant on this Soil object
		//
		//Returns:		a movieclip representation of a preview of this object
		//---------------
		public function GetDataPreviewGraphics(minSat:int = -1, lowSat:int = -1, highSat:int = -1, maxSat:int = -1, highTox:Number = -1, maxTox:Number = -1, fertilizer:Fertilizer = null):MovieClip
		{
			var oGraphics:SoilDataPreview_MC = new SoilDataPreview_MC();
			
			oGraphics.Description.text = Substrate.GetName(_substrate) + " Soil";
			
			// collect information about the microbe populations so we can draw their bars correctly
			var n1BoostActive:Boolean = false;
			var n2BoostActive:Boolean = false;
			var n3BoostActive:Boolean = false;
			var n1BoostPop:Number = 0;
			var n2BoostPop:Number = 0;
			var n3BoostPop:Number = 0;
			var n1GenPop:Number = 0;
			var n2GenPop:Number = 0;
			var n3GenPop:Number = 0;
			var detoxPop:Number = 0;
			
			for (var m:int = 0; m < _microbes.length; m++)
			{
				var oMicrobe:Microbe = Microbe(_microbes[m]);
				
				// for boosters, 0.5 means 50% boost, etc...
				if (oMicrobe.nutrientBoost.n1 > 0)
				{
					n1BoostPop += oMicrobe.population;
					
					if (fertilizer != null && fertilizer.GetDailyToxicityDischarge() == 0 && NutrientSet(fertilizer.GetDailyNutrientDischarge()).n1 > 0)
					{
						n1BoostActive = true;
					}
				}
				if (oMicrobe.nutrientBoost.n2 > 0)
				{
					n2BoostPop += oMicrobe.population;
					
					if (fertilizer != null && fertilizer.GetDailyToxicityDischarge() == 0 && NutrientSet(fertilizer.GetDailyNutrientDischarge()).n2 > 0)
					{
						n2BoostActive = true;
					}
				}
				if (oMicrobe.nutrientBoost.n3 > 0)
				{
					n3BoostPop += oMicrobe.population;
					
					if (fertilizer != null && fertilizer.GetDailyToxicityDischarge() == 0 && NutrientSet(fertilizer.GetDailyNutrientDischarge()).n3 > 0)
					{
						n3BoostActive = true;
					}
				}
				
				// for generators, amount is generated amount
				if (oMicrobe.nutrientGeneration.n1 > 0)
				{
					n1GenPop += oMicrobe.population;
				}
				if (oMicrobe.nutrientGeneration.n2 > 0)
				{
					n2GenPop += oMicrobe.population;
				}
				if (oMicrobe.nutrientGeneration.n3 > 0)
				{
					n3GenPop += oMicrobe.population;
				}
				
				if (oMicrobe.detoxAmount > 0)
				{
					detoxPop += oMicrobe.population;
				}
			}
			
			var n1BoostPopPercent:Number = n1BoostPop / Soil.MAX_MICROBE_POP;
			var n2BoostPopPercent:Number = n2BoostPop / Soil.MAX_MICROBE_POP;
			var n3BoostPopPercent:Number = n3BoostPop / Soil.MAX_MICROBE_POP;
			var n1GenPopPercent:Number = n1GenPop / Soil.MAX_MICROBE_POP;
			var n2GenPopPercent:Number = n2GenPop / Soil.MAX_MICROBE_POP;
			var n3GenPopPercent:Number = n3GenPop / Soil.MAX_MICROBE_POP;
			var detoxPopPercent:Number = detoxPop / Soil.MAX_MICROBE_POP;
			
			var uMicrobeColor:uint = 0x5EAA2B;
			var iN1X:int = 32;
			var iN2X:int = 62;
			var iN3X:int = 92;
			var iBoostY:int = 153;
			var iGenY:int = 178;
			var iRadius:int = 10;
			
			var mcMicrobe:MovieClip = new MovieClip();
			mcMicrobe.graphics.lineStyle(1.0, uMicrobeColor);
			oGraphics.addChild(mcMicrobe);
						
			if (n1GenPopPercent > 0)
			{
				var nSweep:Number = n1GenPopPercent * -360;
				trace(n1GenPopPercent + " * -360 " + " = " + nSweep);
				mcMicrobe.graphics.beginFill(uMicrobeColor);
				DrawingShapes.drawWedge(mcMicrobe.graphics, iN1X, iGenY, iRadius, nSweep);
				mcMicrobe.graphics.endFill();
			}
			
			if (n1BoostPopPercent > 0)
			{
				nSweep = n1BoostPopPercent * -360;
				
				if (n1BoostActive == true)
				{
					mcMicrobe.graphics.beginFill(uMicrobeColor);
					DrawingShapes.drawWedge(mcMicrobe.graphics, iN1X, iBoostY, iRadius, nSweep);
					mcMicrobe.graphics.endFill();
				}
				else
				{
					DrawingShapes.drawWedge(mcMicrobe.graphics, iN1X, iBoostY, iRadius, nSweep);
				}
			}
			
			if (n2GenPopPercent > 0)
			{
				nSweep = n2GenPopPercent * -360;
				mcMicrobe.graphics.beginFill(uMicrobeColor);
				DrawingShapes.drawWedge(mcMicrobe.graphics, iN2X, iGenY, iRadius, nSweep);
				mcMicrobe.graphics.endFill();
			}
			
			if (n2BoostPopPercent > 0)
			{
				nSweep = n2BoostPopPercent * -360;
				
				if (n2BoostActive == true)
				{
					mcMicrobe.graphics.beginFill(uMicrobeColor);
					DrawingShapes.drawWedge(mcMicrobe.graphics, iN2X, iBoostY, iRadius, nSweep);
					mcMicrobe.graphics.endFill();
				}
				else
				{
					DrawingShapes.drawWedge(mcMicrobe.graphics, iN2X, iBoostY, iRadius, nSweep);
				}
			}
			
			if (n3GenPopPercent > 0)
			{
				nSweep = n3GenPopPercent * -360;
				mcMicrobe.graphics.beginFill(uMicrobeColor);
				DrawingShapes.drawWedge(mcMicrobe.graphics, iN3X, iGenY, iRadius, nSweep);
				mcMicrobe.graphics.endFill();
			}
			
			if (n3BoostPopPercent > 0)
			{
				nSweep = n3BoostPopPercent * -360;
				
				if (n3BoostActive == true)
				{
					mcMicrobe.graphics.beginFill(uMicrobeColor);
					DrawingShapes.drawWedge(mcMicrobe.graphics, iN3X, iBoostY, iRadius, nSweep);
					mcMicrobe.graphics.endFill();
				}
				else
				{
					DrawingShapes.drawWedge(mcMicrobe.graphics, iN3X, iBoostY, iRadius, nSweep);
				}
			}
			
			if (detoxPopPercent > 0)
			{
				nSweep = detoxPopPercent * -360;
				mcMicrobe.graphics.beginFill(uMicrobeColor);
				DrawingShapes.drawWedge(mcMicrobe.graphics, 182, 178, iRadius, nSweep);
				mcMicrobe.graphics.endFill();
			}
			
			var oVerticalBar:VerticalBar = new VerticalBar(14, 80, _nutrient1, Soil.MAX_NUTRIENT1, 0x016701, 0x016701, 0xFFFF99);
			var mcVerticalBar:MovieClip = oVerticalBar.Paint();
			mcVerticalBar.x = 25;
			mcVerticalBar.y = 58;
			oGraphics.addChild(mcVerticalBar);
			
			var mcFade:SliderFade_MC = new SliderFade_MC();
			mcFade.x = 29;
			mcFade.y = 58;
			oGraphics.addChild(mcFade);
			
			oVerticalBar = new VerticalBar(14, 80, _nutrient2, Soil.MAX_NUTRIENT2, 0xFF9A33, 0xFF9A33, 0xFFFF99);
			mcVerticalBar = oVerticalBar.Paint();
			mcVerticalBar.x = 55;
			mcVerticalBar.y = 58;
			oGraphics.addChild(mcVerticalBar);
			
			mcFade = new SliderFade_MC();
			mcFade.x = 59;
			mcFade.y = 58;
			oGraphics.addChild(mcFade);
			
			oVerticalBar = new VerticalBar(14, 80, _nutrient3, Soil.MAX_NUTRIENT3, 0x6767FF, 0x6767FF, 0xFFFF99);
			mcVerticalBar = oVerticalBar.Paint();
			mcVerticalBar.x = 85;
			mcVerticalBar.y = 58;
			oGraphics.addChild(mcVerticalBar);
			
			mcFade = new SliderFade_MC();
			mcFade.x = 89;
			mcFade.y = 58;
			oGraphics.addChild(mcFade);
			
			// Saturation Bar //
			// default to green
			var uBarColor:uint = 0x00FF00;
			
			// yellow zone - base level for out-of-season
			if (_saturation > highSat || _saturation < lowSat || (highSat == -1 && lowSat == -1))
			{
				uBarColor = 0xFFFF00;
			}
			
			// orange zone - for seeds & seedlings in live zone
			// uBarColor = 0xFF9900;
			
			// red zone
			if (_saturation > maxSat || _saturation < minSat)
			{
				uBarColor = 0xFF0000;
			}
			
			// no plant - show bar as blue
			if (maxSat == -1 && highSat == -1 && lowSat == -1 && minSat == -1)
			{
				uBarColor = 0x0000CC;
			}
			
			oVerticalBar = new VerticalBar(14, 135, _saturation, GetMaxSaturation(), uBarColor, 0x0000CC, 0xFFFF99, minSat, lowSat, highSat, maxSat);
			mcVerticalBar = oVerticalBar.Paint();
			mcVerticalBar.x = 235;
			mcVerticalBar.y = 58;
			oGraphics.addChild(mcVerticalBar);
			
			mcFade = new SliderFade_MC();
			mcFade.gotoAndStop(2);
			mcFade.x = 239;
			mcFade.y = 58;
			oGraphics.addChild(mcFade);
			
			// Toxicity Bar //
			
			uBarColor = 0x00FF00;  // green
			
			if (_toxicity > highTox && _toxicity <= maxTox)
			{
				uBarColor = 0xFFFF00;  // yellow
			}
			else if (_toxicity > maxTox)
			{
				uBarColor = 0xFF0000;  // red
			}
			
			oVerticalBar = new VerticalBar(14, 105, _toxicity, Soil.MAX_TOXICITY, uBarColor, 0x9900CC, 0xFFFF99, -1, -1, highTox, maxTox);
			mcVerticalBar = oVerticalBar.Paint();
			mcVerticalBar.x = 175;
			mcVerticalBar.y = 58;
			oGraphics.addChild(mcVerticalBar);
						
			mcFade = new SliderFade_MC();
			mcFade.gotoAndStop(3);
			mcFade.x = 179;
			mcFade.y = 58;
			oGraphics.addChild(mcFade);
			
			return oGraphics;
		}
		
		public function GetMaxSaturation():Number
		{
			return Substrate.MAX_SATURATION[_substrate];
		}
		
		public function GetNutrientOverlayGraphics():MovieClip
		{
			var mcNutrientOverlay:MovieClip = new MovieClip();
			
			var uBackColor:uint = 0xFFFF99;
			
			mcNutrientOverlay.graphics.lineStyle(1, 0x000000);
			//mcNutrientOverlay.graphics.beginFill(uBackColor);
			/*
			mcNutrientOverlay.graphics.moveTo(0, 0);
			mcNutrientOverlay.graphics.lineTo(UIManager.GRID_PIXEL_WIDTH, 0);
			mcNutrientOverlay.graphics.lineTo(UIManager.GRID_PIXEL_WIDTH, UIManager.GRID_PIXEL_HEIGHT);
			mcNutrientOverlay.graphics.lineTo(0, UIManager.GRID_PIXEL_HEIGHT);
			mcNutrientOverlay.graphics.lineTo(0, 0);
			*/
			//mcNutrientOverlay.graphics.endFill();
			
			var oVerticalBar:VerticalBar = new VerticalBar(8, 35, _nutrient1, Soil.MAX_NUTRIENT1, 0x016701, 0x016701, uBackColor);
			var mcVerticalBar:MovieClip = oVerticalBar.Paint();
			mcVerticalBar.x = 9.5;
			mcVerticalBar.y = 5;
			mcNutrientOverlay.addChild(mcVerticalBar);
			
			oVerticalBar = new VerticalBar(8, 35, _nutrient2, Soil.MAX_NUTRIENT2, 0xFF9A33, 0xFF9A33, uBackColor);
			mcVerticalBar = oVerticalBar.Paint();
			mcVerticalBar.x = 18.5;
			mcVerticalBar.y = 5;
			mcNutrientOverlay.addChild(mcVerticalBar);
			
			oVerticalBar = new VerticalBar(8, 35, _nutrient3, Soil.MAX_NUTRIENT3, 0x6767FF, 0x6767FF, uBackColor);
			mcVerticalBar = oVerticalBar.Paint();
			mcVerticalBar.x = 27.5;
			mcVerticalBar.y = 5;
			mcNutrientOverlay.addChild(mcVerticalBar);
			
			return mcNutrientOverlay;
		}
		
		public function GetNutrientSet():NutrientSet
		{
			var oNutrientSet:NutrientSet = new NutrientSet(_nutrient1, _nutrient2, _nutrient3);
			return oNutrientSet;
		}
		
		public function GetTotalMicrobePopulation():int
		{
			var iTotalPop:int = 0;
			
			for (var i:int = 0; i < _microbes.length; i++)
			{
				var oMicrobe:Microbe = Microbe(_microbes[i]);
				
				iTotalPop += oMicrobe.population;
			}
			
			return iTotalPop;
		}
		
		//---------------
		//Purpose:		Return graphics that represent this object
		//
		//Parameters:
		//	none
		//
		//Returns:		a movieclip representation of this object
		//---------------
		public function Paint(plant:Plant):MovieClip
		{
			var mcSoil:Soil_MC = new Soil_MC();
			var iFrame:int = _substrate + 1;
			
			if (plant != null)
			{
				if (plant.growthStage == Plant.STAGE_SEED && Plant.GetClass(plant.type) != Plant.CLASS_COVER)
				{
					iFrame += Substrate.MAX_TYPE;
				}
			}
			
			mcSoil.gotoAndStop(iFrame);
			
			return mcSoil;
		}
		
		//---------------
		//Purpose:		Remove some amount of nutrient 1 from the soil
		//
		//Parameters:
		//	amount:Number = the amount of nutrient 1 to remove from the soil
		//
		//Returns:		void
		//---------------
		public function RemoveNutrient1(amount:Number):void
		{
			_nutrient1 -= amount;
			
			if (_nutrient1 < 0)
			{
				_nutrient1 = 0;
			}
		}
		
		//---------------
		//Purpose:		Remove some amount of nutrient 2 from the soil
		//
		//Parameters:
		//	amount:Number = the amount of nutrient 2 to remove from the soil
		//
		//Returns:		void
		//---------------
		public function RemoveNutrient2(amount:Number):void
		{
			_nutrient2 -= amount;
			
			if (_nutrient2 < 0)
			{
				_nutrient2 = 0;
			}
		}
		
		//---------------
		//Purpose:		Remove some amount of nutrient 3 from the soil
		//
		//Parameters:
		//	amount:Number = the amount of nutrient 3 to remove from the soil
		//
		//Returns:		void
		//---------------
		public function RemoveNutrient3(amount:Number):void
		{
			_nutrient3 -= amount;
			
			if (_nutrient3 < 0)
			{
				_nutrient3 = 0;
			}
		}
		
		public function RemoveNutrients(amounts:NutrientSet):void
		{
			RemoveNutrient1(amounts.n1);
			RemoveNutrient2(amounts.n2);
			RemoveNutrient3(amounts.n3);
		}
		
		//---------------
		//Purpose:		Removes some amount of toxicity from the soil
		//
		//Parameters:
		//	amount:Number = the amount of toxicity to remove from the soil
		//
		//Returns:		void
		//---------------
		public function RemoveToxicity(amount:Number):void
		{
			_toxicity -= amount;
			
			if (_toxicity < 0)
			{
				_toxicity = 0;
			}
		}
		
		//---------------
		//Purpose:		Removes some amount of water from the soil
		//
		//Parameters:
		//	amount:Number = the amount of water to remove from the soil
		//
		//Returns:		void
		//---------------
		public function RemoveWater(amount:Number):void
		{
			_saturation -= amount;
			
			if (_saturation < 0)
			{
				_saturation = 0;
			}
		}
		
		//* Public Methods *//
		
		
		// Protected Methods:
	}
}