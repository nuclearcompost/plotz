package
{
	//-----------------------
	//Purpose:				Initialize soil nutrient values
	//
	//Public Properties:
	//	
	//Public Methods:
	//	
	//-----------------------
	public class SoilNutrientInitializer
	{
		// Constants //
		
		//- Constants -//
		
		
		// Public Properties //
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		//- Private Properties -//
		
	
		// Initialization //
		
		//---------------
		//Purpose:		
		//Parameters:
		//	
		//Returns:		
		//---------------
		public function SoilNutrientInitializer()
		{
			
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		public static function InitializeSoil(tiles:Array):void
		{
			// initialize all of the soil to base conditions
			for (var x:int = 0; x < tiles.length; x++)
			{
				for (var y:int = 0; y < tiles[x].length; y++)
				{
					var oTile:Tile = Tile(tiles[x][y]);
					
					if (oTile == null)
					{
						continue;
					}
					
					var oSoil:Soil = oTile.soil;
					oSoil.nutrient1 = 0;
					oSoil.nutrient2 = 0;
					oSoil.nutrient3 = 0;
				}
			}
			
			InitializeNutrient(tiles, "n1");
			InitializeNutrient(tiles, "n2");
			InitializeNutrient(tiles, "n3");
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
	
		private static function InitializeNutrient(tiles:Array, stat:String):void
		{
			// create the "seed" blob
			var lBlobInfo:Array = AddBlob(tiles.length / 2, tiles[0].length / 2, 0, tiles, stat);
			
			// loop through all check spots and add on another blob if needed to cover it
			while (lBlobInfo.length > 0)
			{
				var oBlob:BlobInfo = BlobInfo(lBlobInfo.shift());

				var lMoreBlobInfo:Array = AddBlob(oBlob.x, oBlob.y, oBlob.fromSide, tiles, stat);
				
				while (lMoreBlobInfo.length > 0)
				{
					var oNewBlob:BlobInfo = BlobInfo(lMoreBlobInfo.shift());
					
					lBlobInfo.push(oNewBlob);
				}
			}
		}
		
		// Side:  0 = center, 1 = upper-right, 2 = lower-right, 3 = lower-left, 4 = upper-left
		// returns an array of info about how to make adjacent blobs
		private static function AddBlob(startX:int, startY:int, startSide:int, tiles:Array, stat:String):Array
		{
			var lBlobInfo:Array = new Array();
			
			var nStartValue:Number = 0.0;
			
			switch (stat)
			{
				case "n1":
					nStartValue = (Math.random() * (Soil.MAX_NUTRIENT1 / 4)) + (Soil.MAX_NUTRIENT1 / 2);
					break;
				case "n2":
					nStartValue = (Math.random() * (Soil.MAX_NUTRIENT2 / 4)) + (Soil.MAX_NUTRIENT2 / 2);
					break;
				case "n3":
					nStartValue = (Math.random() * (Soil.MAX_NUTRIENT3 / 4)) + (Soil.MAX_NUTRIENT3 / 2);
					break;
				default:
					break;
			}
			
			// size
			var iSize:int = Math.floor(Math.random() * 3) + 1;   // 1, 2, or 3
			
			// blob started at the center is the "seed" blob
			if (startSide == 0)
			{
				SetBlob(startX, startY, iSize, tiles, stat, nStartValue);
				lBlobInfo = GetBlobInfo(startX, startY, iSize, tiles, stat);
			}
			// otherwise, we do something "complicated"... the incoming parameter startSide is the side of the originating blob that we need a new blob on.
			//  the startX and startY are just outside the originating blob and will be part of the new blob.
			//  we want the specified startX and startY to be a random point - on the opposite side as startSide - for the new blob
			//  to get the center of the new blob, we act like startX, startY is a center and get all spots on its startSide - all of the points on this "side" are actually all
			//   possible spots where the new blob's center could be and still get startX, startY to be on the blob in a random spot on the appropriate side.
			else
			{
				var lPossibleCenters:Array = GridUtil.GetGridSideSpotsAtRange(tiles, startX, startY, iSize, startSide);
				
				if (lPossibleCenters.length > 0)
				{
					var iCenterIndex:int = Math.floor(Math.random() * lPossibleCenters.length);
					var oCenterLocation:GridLocation = GridLocation(lPossibleCenters[iCenterIndex]);
					SetBlob(oCenterLocation.x, oCenterLocation.y, iSize, tiles, stat, nStartValue);
					lBlobInfo = GetBlobInfo(oCenterLocation.x, oCenterLocation.y, iSize, tiles, stat);
				}
			}
			
			return lBlobInfo;
		}
		
		private static function SetBlob(x:int, y:int, size:int, tiles:Array, stat:String, startValue:Number):void
		{
			// set center
			SetBlobSpot(x, y, tiles, stat, startValue);
			
			// rings
			for (var s:int = 1; s <= size; s++)
			{
				var lBlobSpots:Array = GridUtil.GetGridSpotsAtRange(tiles, x, y, s);
				
				for (var i:int = 0; i < lBlobSpots.length; i++)
				{
					var oGridLocation:GridLocation = GridLocation(lBlobSpots[i]);
					
					var nNewValue:Number = 0.0;
					
					switch (stat)
					{
						case "n1":
							nNewValue = startValue - (size * (Soil.MAX_NUTRIENT1 / 12)) + (Math.random() * (Soil.MAX_NUTRIENT1 / 6));
							break;
						case "n2":
							nNewValue = startValue - (size * (Soil.MAX_NUTRIENT2 / 12)) + (Math.random() * (Soil.MAX_NUTRIENT2 / 6));
							break;
						case "n3":
							nNewValue = startValue - (size * (Soil.MAX_NUTRIENT3 / 12)) + (Math.random() * (Soil.MAX_NUTRIENT3 / 6));
							break;
						default:
							break;
					}
					
					SetBlobSpot(oGridLocation.x, oGridLocation.y, tiles, stat, nNewValue);
				}
			}
		}
		
		private static function SetBlobSpot(x:int, y:int, tiles:Array, stat:String, value:Number):void
		{
			// fetch
			var oTile:Tile = Tile(tiles[x][y]);
			
			if (oTile == null)
			{
				return;
			}
			
			var oSoil:Soil = oTile.soil;
			
			// check
			if (ValueAlreadySet(oSoil, stat) == true)
			{
				return;
			}
			
			// set
			switch (stat)
			{
				case "n1":
					oSoil.nutrient1 = value;
					break;
				case "n2":
					oSoil.nutrient2 = value;
					break;
				case "n3":
					oSoil.nutrient3 = value;
					break;
				default:
					break;
			}
			
		}
		
		private static function GetBlobInfo(centerX:int, centerY:int, size:int, tiles:Array, stat:String):Array
		{
			var lBlobInfo:Array = new Array();
			
			for (var side:int = 1; side <= 4; side++)
			{
				var lSideSpots:Array = GridUtil.GetGridSideSpotsAtRange(tiles, centerX, centerY, size + 1, side);
				
				for (var spot:int = 0; spot < lSideSpots.length - 1; spot++)
				{
					var oSideSpot:GridLocation = GridLocation(lSideSpots[spot]);
					var oTile:Tile = Tile(tiles[oSideSpot.x][oSideSpot.y]);
					var oSoil:Soil = oTile.soil;
					
					if (ValueAlreadySet(oSoil, stat) == false)
					{
						lBlobInfo[lBlobInfo.length] = new BlobInfo(oSideSpot.x, oSideSpot.y, side, 0);
					}
				}
			}
			
			return lBlobInfo;
		}
		
		private static function ValueAlreadySet(soil:Soil, stat:String):Boolean
		{
			var bValueAlreadySet:Boolean = false;
			
			switch (stat)
			{
				case "n1":
					if (soil.nutrient1 != 0.0)
					{
						bValueAlreadySet = true;
					}
					break;
				case "n2":
					if (soil.nutrient2 != 0.0)
					{
						bValueAlreadySet = true;
					}
					break;
				case "n3":
					if (soil.nutrient3 != 0.0)
					{
						bValueAlreadySet = true;
					}
					break;
				default:
					break;
			}
			
			return bValueAlreadySet;
		}
		
		//- Private Methods -//
	}
}