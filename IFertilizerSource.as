package
{
	import flash.display.MovieClip;
	
	//-----------------------
	//Purpose:				Anything that can be used to produce a Fertilizer
	//
	//Implemented By:
	//	BagFertilizer
	//	Compost
	//	PlantScrap
	//-----------------------

	public interface IFertilizerSource
	{
		function CreateFertilizer():Fertilizer;
		function GetFertilizerDuration():int;
		function GetFertilizerGraphics():MovieClip;
		function GetFertilizerName():String;
		function GetFertilizerNutrientSet():NutrientSet;
		function GetFertilizerToxicity():Number;
	}
}