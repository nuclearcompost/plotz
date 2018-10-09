package
{
	//-----------------------
	//Purpose:				Build Pickers
	//
	//Properties:
	//	
	//Methods:
	//	
	//-----------------------
	public class PickerFactory
	{
		// Constants //
		
		//- Constants -//
		
		
		// Public Properties //
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function PickerFactory()
		{
			
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		public static function BuildPicker(type:int, parent:CalendarMenu, viewState:CustomDayEventViewState, gameTime:Time):CustomEventPropertyPicker
		{
			var oPicker:CustomEventPropertyPicker = null;
			
			if (type == CustomEventPropertyPicker.TYPE_QUANTITY)
			{
				oPicker = new NumberPicker(parent, viewState, viewState.event.occurrences);
				
				var oNumberPicker:NumberPicker = NumberPicker(oPicker);
				oNumberPicker.SetDigitsFromValue();
			}
			else if (type == CustomEventPropertyPicker.TYPE_PLANT)
			{
				var oEvent:CustomDayEvent = viewState.event;
				
				if (oEvent is CustomPlantEvent)
				{
					var oCustomPlantEvent:CustomPlantEvent = CustomPlantEvent(oEvent);
					
					oPicker = new PlantTypePicker(parent, viewState, oCustomPlantEvent.plantType);
				}
			}
			else if (type == CustomEventPropertyPicker.TYPE_FRUIT)
			{
				oEvent = viewState.event;
				
				if (oEvent is CustomHarvestEvent)
				{
					var oCustomHarvestEvent:CustomHarvestEvent = CustomHarvestEvent(oEvent);
					
					oPicker = new FruitTypePicker(parent, viewState, oCustomHarvestEvent.fruitType, gameTime);
				}
			}
			
			return oPicker;
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		//- Private Methods -//
		
		
		// Testing Methods //
		
		//- Testing Methods -//
	}
}