package
{
	import flash.net.SharedObject;
	
	//-----------------------
	//Purpose:				Service methods for saving and loading the game state
	//
	//Public Properties:
	//	
	//Public Methods:
	//	
	//-----------------------
	public class SaveGameService
	{
		// Constants //
		
		//- Constants -//
		
		
		// Public Properties //
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function SaveGameService()
		{
			
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		public static function HasSaveGameData():Boolean
		{
			var bHasData:Boolean = false;
			var saveFile:SharedObject = null;
			
			try
			{
				saveFile = SharedObject.getLocal(GameSession.SAVE_GAME_NAME);
				
				if (saveFile.data._time != undefined)
				{
					bHasData = true;
				}
				
				saveFile.close();
			}
			catch (errObject:Error)
			{
				trace(errObject);
				trace("Uh oh, HasGameSaveData exploded.  This might be from adding a reference to another class' constants.  For example, Plant cannot define a constant like PREFERRED_SEASON:Array = [ GameSession.SEASON_WINTER ] b/c GameSession may not be around yet");
				bHasData = false;
			}
			
			return bHasData;
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		//- Private Methods -//
		
		
		// Testing Methods //
		
		//- Testing Methods -//
	}
}