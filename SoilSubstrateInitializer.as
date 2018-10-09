package
{
	//-----------------------
	//Purpose:				Initialize soil substrate types
	//
	//Public Properties:
	//	
	//Public Methods:
	//	
	//-----------------------
	public class SoilSubstrateInitializer
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
		public function SoilSubstrateInitializer()
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
					oSoil.substrate = Substrate.TYPE_NONE;
				}
			}
			
			InitializeSubstrate(tiles);
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
	
		private static function InitializeSubstrate(tiles:Array):void
		{
			// create the "seed" blob
			var lBlobInfo:Array = AddBlob(tiles.length / 2, tiles[0].length / 2, 0, Substrate.TYPE_NONE, tiles);
			
			// loop through all check spots and add on another blob if needed to cover it
			while (lBlobInfo.length > 0)
			{
				var oBlob:BlobInfo = BlobInfo(lBlobInfo.shift());

				var lMoreBlobInfo:Array = AddBlob(oBlob.x, oBlob.y, oBlob.fromSide, oBlob.fromType, tiles);
				
				while (lMoreBlobInfo.length > 0)
				{
					var oNewBlob:BlobInfo = BlobInfo(lMoreBlobInfo.shift());
					
					lBlobInfo.push(oNewBlob);
				}
			}
		}
		
		// Side:  0 = center, 1 = upper-right, 2 = lower-right, 3 = lower-left, 4 = upper-left
		// returns an array of info about how to make adjacent blobs
		private static function AddBlob(startX:int, startY:int, startSide:int, substrateTypeNotAllowed:int, tiles:Array):Array
		{
			var lBlobInfo:Array = new Array();
			
			var iSubstrate:int = GetRandomSubstrateTypeExceptOne(substrateTypeNotAllowed);
			
			// size
			var iSize:int = Math.floor(Math.random() * 3) + 1;   // 1, 2, or 3
			
			// blob started at the center is the "seed" blob
			if (startSide == 0)
			{
				SetBlob(startX, startY, iSize, iSubstrate, tiles);
				lBlobInfo = GetBlobInfo(startX, startY, iSize, iSubstrate, tiles);
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
					SetBlob(oCenterLocation.x, oCenterLocation.y, iSize, iSubstrate, tiles);
					lBlobInfo = GetBlobInfo(oCenterLocation.x, oCenterLocation.y, iSize, iSubstrate, tiles);
				}
			}
			
			return lBlobInfo;
		}
		
		private static function SetBlob(x:int, y:int, size:int, substrate:int, tiles:Array):void
		{
			// set center
			SetBlobSpot(x, y, substrate, tiles);
			
			// rings
			for (var s:int = 1; s <= size; s++)
			{
				var lBlobSpots:Array = GridUtil.GetGridSpotsAtRange(tiles, x, y, s);
				
				for (var i:int = 0; i < lBlobSpots.length; i++)
				{
					var oGridLocation:GridLocation = GridLocation(lBlobSpots[i]);
					SetBlobSpot(oGridLocation.x, oGridLocation.y, substrate, tiles);
				}
			}
		}
		
		private static function SetBlobSpot(x:int, y:int, substrate:int, tiles:Array):void
		{
			// fetch
			var oTile:Tile = Tile(tiles[x][y]);
			var oSoil:Soil = oTile.soil;
			
			// check
			if (oSoil.substrate != Substrate.TYPE_NONE)
			{
				return;
			}
			
			// set
			oSoil.substrate = substrate;
		}
		
		private static function GetBlobInfo(centerX:int, centerY:int, size:int, substrate:int, tiles:Array):Array
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
					
					if (oSoil.substrate == Substrate.TYPE_NONE)
					{
						lBlobInfo[lBlobInfo.length] = new BlobInfo(oSideSpot.x, oSideSpot.y, side, substrate);
					}					
				}
			}
			
			return lBlobInfo;
		}
		
		private static function GetRandomSubstrateTypeExceptOne(substrateTypeNotAllowed:int):int
		{
			var iSubstrate:int = Math.floor(Math.random() * 3);
			
			while (iSubstrate == substrateTypeNotAllowed)
			{
				iSubstrate = Math.floor(Math.random() * 3);
			}
			
			return iSubstrate;
		}
		
		//- Private Methods -//
	}
}