package
{
	//-----------------------
	//Purpose:				Implemented by anything that can serve as the symbiotic host of a specific kind of microbes
	//
	//Implemented By:
	//	Fertilizer
	//	Plant
	//
	//-----------------------
	
	public interface IMicrobeHost
	{
		function GetUniqueHostCode():String;
	}
}