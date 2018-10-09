package
{
	//-----------------------
	//Purpose:				For objects which can decay into Compost
	//
	//Implemented By:
	//	--Fruit
	//	PlantScrap
	//
	//-----------------------
	
	public interface IDecomposes
	{
		function CreateCompost():Compost;
		function GetDecomposeDaysLeft():int;
		function SetDecomposeDaysLeft(days:int):void;
	}
}