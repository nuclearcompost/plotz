package
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	
	//-----------------------
	//Purpose:				A simple button in the footer
	//
	//Public Properties:
	//	
	//Public Methods:
	//	
	//-----------------------
	public class FooterButton
	{
		// Constants //
		
		public static const TYPE_WATERING_CAN:int = 1;
		public static const TYPE_SICKLE:int = 2;
		public static const TYPE_HOE:int = 3;
		public static const TYPE_MAGNIFYING_GLASS:int = 4;
		public static const TYPE_CALENDAR:int = 5;
		
		//- Constants -//
		
		
		// Public Properties //
		
		public function get type():int
		{
			return _type;
		}
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		private var _type:int;
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function FooterButton(type:int)
		{
			_type = type;
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		public function GetPreviewGraphics():MovieClip
		{
			var mcPreview:Footer_Preview_MC = new Footer_Preview_MC();
			
			mcPreview.gotoAndStop(_type);
			
			return mcPreview;
		}
		
		public function Paint():SimpleButton
		{
			var mcFooterButton:SimpleButton = null;
			
			switch (_type)
			{
				case FooterButton.TYPE_WATERING_CAN:
					mcFooterButton = new Footer_WateringCan_Btn();
					break;
				case FooterButton.TYPE_SICKLE:
					mcFooterButton = new Footer_Sickle_Btn();
					break;
				case FooterButton.TYPE_HOE:
					mcFooterButton = new Footer_Hoe_Btn();
					break;
				case FooterButton.TYPE_MAGNIFYING_GLASS:
					mcFooterButton = new Footer_MagnifyingGlass_Btn();
					break;
				case FooterButton.TYPE_CALENDAR:
					mcFooterButton = new Footer_Calendar_Btn();
					break;
				default:
					break;
			}
			
			return mcFooterButton;
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		//- Private Methods -//
		
		
		// Testing Methods //
		
		//- Testing Methods -//
	}
}