package
{
	import flash.display.MovieClip;
	
	//Implemented By:
	//	Item
	//	ItemBldg
	
	public interface IItem
	{
		function get name():String;
		function get priceModifier():int;
		function set priceModifier(value:int):void;
		function get type():int;
		function GetItemGraphics():MovieClip;
	}
}