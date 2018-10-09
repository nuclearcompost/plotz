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
	public class TutorialService
	{
		// Constants //
		
		//- Constants -//
		
		
		// Public Properties //
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function TutorialService()
		{
			
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		public static function IsTutorialActive(tutorialStep:int):Boolean
		{
			if (tutorialStep >= 0)
			{
				return true;
			}
			
			return false;
		}
		
		public static function IsValidBldgClick(tutorialStep:int, bldgType:int):Boolean
		{
			var lBldgs:Array = TutorialStep.GetBldgs(tutorialStep);
			
			var bTestResult:Boolean = false;
			
			for (var i:int = 0; i < lBldgs.length; i++)
			{
				var iBldgType:int = int(lBldgs[i]);
				
				if (iBldgType == bldgType)
				{
					bTestResult = true;
					break;
				}
			}
			
			return bTestResult;
		}
		
		public static function IsValidCloseMenuHeaderButtonClick(tutorialStep:int):Boolean
		{
			if (TutorialService.IsTutorialActive(tutorialStep) == true)
			{
				var bCanCloseMenu:Boolean = TutorialStep.GetCanCloseMenu(tutorialStep);
				
				if (bCanCloseMenu == false)
				{
					return false;
				}
			}
			
			return true;
		}
		
		public static function IsValidFooterIndexForTutorial(tutorialStep:int, footerIndex:int):Boolean
		{
			var lIndexes:Array = TutorialStep.GetFooterIndexes(tutorialStep);
			
			var bTestResult:Boolean = false;
			
			for (var i:int = 0; i < lIndexes.length; i++)
			{
				if (lIndexes[i] == footerIndex)
				{
					bTestResult = true;
					break;
				}
			}
			
			return bTestResult;
		}
		
		public static function IsValidGridClickForTutorial(tutorialStep:int, gridLocation:GridLocation):Boolean
		{
			var lGridLocations:Array = TutorialStep.GetGridLocations(tutorialStep);
			
			var bTestResult:Boolean = false;
			
			for (var i:int = 0; i < lGridLocations.length; i++)
			{
				var oGridLocation:GridLocation = GridLocation(lGridLocations[i]);
				
				if (gridLocation.IsSameAs(oGridLocation) == true)
				{
					bTestResult = true;
					break;
				}
			}
			
			return bTestResult;
		}
		
		public static function IsValidGridHoverForTutorial(tutorialStep:int, gridLocation:GridLocation):Boolean
		{
			var lGridLocations:Array = TutorialStep.GetGridHoverLocations(tutorialStep);
			
			var bTestResult:Boolean = false;
			
			for (var i:int = 0; i < lGridLocations.length; i++)
			{
				var oGridLocation:GridLocation = GridLocation(lGridLocations[i]);
				
				if (gridLocation.IsSameAs(oGridLocation) == true)
				{
					bTestResult = true;
					break;
				}
			}
			
			return bTestResult;
		}
		
		public static function IsValidKeyDownForTutorial(tutorialStep:int, charCode:uint):Boolean
		{
			var bIsValidKeyDown:Boolean = false;
			
			var lKeys:Array = TutorialStep.GetKeys(tutorialStep);
			
			for (var i:int = 0; i < lKeys.length; i++)
			{
				if (charCode == lKeys[i])
				{
					bIsValidKeyDown = true;
					break;
				}
			}
			
			return bIsValidKeyDown;
		}
		
		public static function IsValidMenuActionButtonClickForTutorial(tutorialStep:int, actionButtonType:int):Boolean
		{
			if (TutorialService.IsTutorialActive(tutorialStep) == true)
			{
				var bCanClickMenuActionButton:Boolean = false;
				var lMenuActionButtons = TutorialStep.GetMenuActionButtons(tutorialStep);
				
				for (var i:int = 0; i < lMenuActionButtons.length; i++)
				{
					if (lMenuActionButtons[i] == actionButtonType)
					{
						bCanClickMenuActionButton = true;
						break;
					}
				}
				
				if (bCanClickMenuActionButton == false)
				{
					return false;
				}
			}
			
			return true;
		}
		
		// returns true if a menu slot click is valid for the current tutorial step
		public static function IsValidMenuSlotClickForTutorial(tutorialStep:int, menuContent:IMenuContent, slot:int):Boolean
		{
			var lClickableSlots:Array = null;
			
			if (menuContent.IsInParentMenu() == true)
			{
				lClickableSlots = TutorialStep.GetPrimaryMenuSlots(tutorialStep);
			}
			else
			{
				lClickableSlots = TutorialStep.GetChildMenuSlots(tutorialStep);
			}
			
			var bIsValidSlot:Boolean = false;
			
			for (var i:int = 0; i < lClickableSlots.length; i++)
			{
				if (lClickableSlots[i] == slot)
				{
					bIsValidSlot = true;
					break;
				}
			}
			
			return bIsValidSlot;
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		//- Private Methods -//
		
		
		// Testing Methods //
		
		//- Testing Methods -//
	}
}