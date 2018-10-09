package
{
	import flash.geom.Rectangle;
	
	//-----------------------
	//Purpose:				
	//Public Properties:
	//	
	//Public Methods:
	//	
	//-----------------------
	public class TutorialStep
	{
		// Constants //
		
		// index of this array is the stepNumber, valud of array is Id
		private static const StepIds:Array = [ 0, 1, 2, 3, 29, 4, 5, 31, 32, 33, 34, 6, 7, 8, 9, 10, 11, 13, 14, 15, 16, 18, 19, 20, 21, 30, 22, 23, 24, 26, 27, 39, 40,
											   35, 38, 28 ];
		
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
		public function TutorialStep()
		{
			
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		public static function GetIdForStepNumber(stepNumber:int):int
		{
			var iId:int = StepIds[stepNumber];
			
			return iId;
		}
		
		public static function GetBldgs(stepNumber:int):Array
		{
			var lBldgs:Array = new Array();
			
			var iId:int = TutorialStep.GetIdForStepNumber(stepNumber);
			
			switch (iId)
			{
				case 0:
				case 29:
				case 30:
					lBldgs.push(Bldg.TYPE_FARM_TOOLSHED);
					break;
				case 6:
					lBldgs.push(Bldg.TYPE_FARM_HOUSE);
					break;
				case 9:
					lBldgs.push(Bldg.TYPE_FARM_WELL);
					break;
				case 18:
					lBldgs.push(Bldg.TYPE_TOWN_ITEM_SHOP);
					break;
				case 27:
					lBldgs.push(Bldg.TYPE_FARM_SALE_CART);
					break;
				default:
					break;
			}
			
			return lBldgs;
		}
		
		public static function GetCanCloseMenu(stepNumber:int):Boolean
		{
			var bCanCloseMenu:Boolean = false;
			
			var iId:int = TutorialStep.GetIdForStepNumber(stepNumber);
			
			switch (iId)
			{
				case 2:
				case 21:
					bCanCloseMenu = true;
					break;
				default:
					break;
			}
			
			return bCanCloseMenu;
		}
		
		public static function GetChildMenuSlots(stepNumber:int):Array
		{
			var lSlots:Array = new Array();
			
			var iId:int = TutorialStep.GetIdForStepNumber(stepNumber);
			
			switch (iId)
			{
				case 19:
					lSlots.push(4);
					break;
				default:
					break;
			}
			
			return lSlots;
		}
		
		public static function GetFooterIndexes(stepNumber:int):Array
		{
			var lIndexes:Array = new Array();
			
			var iId:int = TutorialStep.GetIdForStepNumber(stepNumber);
			
			switch (iId)
			{
				case 8:
					lIndexes.push(0);
					break;
				case 35:
				case 38:
					lIndexes.push(3);
					break;
				default:
					break;
			}
			
			return lIndexes;
		}
		
		public static function GetGridHoverLocations(stepNumber:int):Array
		{
			var lGridHoverLocations:Array = new Array();
			
			var iId:int = TutorialStep.GetIdForStepNumber(stepNumber);
			
			switch (iId)
			{
				case 8:		// onion
				case 10:
				case 11:
				case 13:
				case 14:
				case 15:
				case 16:
				case 18:
				case 23:
				case 26:
					lGridHoverLocations.push(new GridLocation(11, 18));
					break;
				default:
					break;
			}
			
			return lGridHoverLocations;
		}
		
		public static function GetGridLocations(stepNumber:int):Array
		{
			var lGridLocations:Array = new Array();
			
			var iId:int = TutorialStep.GetIdForStepNumber(stepNumber);
			
			switch (iId)
			{
				case 3:   // onion
				case 5:
				case 10:
				case 14:
				case 15:
				case 23:
				case 26:
				case 31:
				case 32:
				case 33:
				case 34:
					lGridLocations.push(new GridLocation(11, 18));
					break;
				default:
					break;
			}
			
			return lGridLocations;
		}
		
		public static function GetKeys(stepNumber:int):Array
		{
			var lKeys:Array = new Array();
			
			var iId:int = TutorialStep.GetIdForStepNumber(stepNumber);
			
			switch (iId)
			{
				case 11:
				case 16:
				case 24:
				case 40:
					lKeys.push(32);  // spacebar
					break;
				case 13:
					lKeys.push(51);  // "3" key
					break;
				default:
					break;
			}
			
			return lKeys;
		}
		
		public static function GetMenuActionButtons(stepNumber:int):Array
		{
			var lMenuActionButtons:Array = new Array();
			
			var iId:int = TutorialStep.GetIdForStepNumber(stepNumber);
			
			switch (iId)
			{
				case 7:
					lMenuActionButtons.push(MenuActionButton.BTN_END_DAY);
					break;
				default:
					break;
			}
			
			return lMenuActionButtons;
		}
		
		public static function GetPrimaryMenuSlots(stepNumber:int):Array
		{
			var lSlots:Array = new Array();
			
			var iId:int = TutorialStep.GetIdForStepNumber(stepNumber);
			
			switch (iId)
			{
				case 1:
					lSlots.push(1);
					break;
				case 4:
					lSlots.push(3);
					break;
				case 20:
					lSlots.push(6);
					break;
				case 22:
					lSlots.push(2);
					break;
				case 39:
					lSlots.push(0);
				default:
					break;
			}
			
			return lSlots;
		}
		
		//- Public Methods -//
		
		
		// Protected Methods //
		
		//- Protected Methods -//
	}
}