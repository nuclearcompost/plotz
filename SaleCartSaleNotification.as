package
{
	import flash.display.MovieClip;
	
	//-----------------------
	//Purpose:				Notify the player that the sale cart had some sales
	//
	//Properties:
	//	
	//Methods:
	//	
	//-----------------------
	public class SaleCartSaleNotification extends Notification
	{
		// Constants //
		
		//- Constants -//
		
		
		// Public Properties //
		
		public override function get type():int
		{
			return Notification.TYPE_WALLET;
		}
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		private var _amount:int;
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function SaleCartSaleNotification(uiManager:UIManager, displaySeconds:int, amount:int = 0)
		{
			super(uiManager, displaySeconds);
			
			_amount = amount;
			
			Paint();
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		public override function Paint():MovieClip
		{
			var mcNotification:Notification_SaleCartSale_MC = new Notification_SaleCartSale_MC();
			mcNotification.Amount.text = String(_amount);
			
			_graphics = mcNotification;
			return mcNotification;
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		//- Private Methods -//
		
		
		// Testing Methods //
		
		//- Testing Methods -//
	}
}