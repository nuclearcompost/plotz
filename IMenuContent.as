package
{
	import flash.display.MovieClip;
	
	//-----------------------
	//Purpose:				Interface for anything that can go inside of a full-size menu with header
	//
	//Implemented By:
	//	ActionButtonMenu
	//	CalendarMenu
	//	CsaSignupMenu
	//	CsaStatusMenu
	//	InventoryMenu
	//
	//-----------------------
	
	public interface IMenuContent
	{
		function get gridHeight():int;
		function set menuTab(value:MenuTab):void;
		function get menuTabDisplayName():String;
		function IsInParentMenu():Boolean;
		function Paint():MovieClip;
	}
}