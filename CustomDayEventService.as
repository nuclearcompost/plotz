package
{
	//-----------------------
	//Purpose:				Service logic for CustomDayEvents
	//
	//Properties:
	//	
	//Methods:
	//	
	//-----------------------
	public class CustomDayEventService
	{
		// Constants //
		
		//- Constants -//
		
		
		// Public Properties //
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function CustomDayEventService()
		{
			
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		public static function UpdateEventValueFromPicker(event:CustomDayEvent, picker:CustomEventPropertyPicker):void
		{
			UpdateSingleEventValueFromPicker(event, picker);
			
			var lLinkedEvents:Array = event.GetLinkedEvents();
			
			for (var i:int = 0; i < lLinkedEvents.length; i++)
			{
				var oEvent:CustomDayEvent = CustomDayEvent(lLinkedEvents[i]);
				
				UpdateSingleEventValueFromPicker(oEvent, picker);
				UpdateLinkedEventDate(event, oEvent);
			}
		}
		
		public static function UpdateSingleEventValueFromPicker(event:CustomDayEvent, picker:CustomEventPropertyPicker):void
		{
			if (event == null || picker == null)
			{
				return;
			}
			
			switch (event.eventType)
			{
				case DayEvent.TYPE_CUSTOM_PLANT:
					UpdateCustomPlantEventValueFromPicker(CustomPlantEvent(event), picker);
					break;
				case DayEvent.TYPE_CUSTOM_HARVEST:
					UpdateCustomHarvestEventValueFromPicker(CustomHarvestEvent(event), picker);
					break;
				default:
					break;
			}
		}
		
		public static function UpdateCustomPlantEventValueFromPicker(event:CustomPlantEvent, picker:CustomEventPropertyPicker):void
		{
			if (event == null || picker == null)
			{
				return;
			}
			
			switch (picker.type)
			{
				case CustomEventPropertyPicker.TYPE_QUANTITY:
					var oNumberPicker:NumberPicker = NumberPicker(picker);
					event.occurrences = oNumberPicker.value;
					break;
				case CustomEventPropertyPicker.TYPE_PLANT:
					var oPlantTypePicker:PlantTypePicker = PlantTypePicker(picker);
					event.plantType = oPlantTypePicker.plantType;
					break;
				case CustomEventPropertyPicker.TYPE_FRUIT:  // should only happen via linkage
					var oFruitTypePicker:FruitTypePicker = FruitTypePicker(picker);
					event.plantType = oFruitTypePicker.fruitType;
					break;
				default:
					break;
			}
		}
		
		public static function UpdateCustomHarvestEventValueFromPicker(event:CustomHarvestEvent, picker:CustomEventPropertyPicker):void
		{
			if (event == null || picker == null)
			{
				return;
			}
			
			switch (picker.type)
			{
				case CustomEventPropertyPicker.TYPE_QUANTITY:
					var oNumberPicker:NumberPicker = NumberPicker(picker);
					event.occurrences = oNumberPicker.value;
					break;
				case CustomEventPropertyPicker.TYPE_FRUIT:
					var oFruitTypePicker:FruitTypePicker = FruitTypePicker(picker);
					event.fruitType = oFruitTypePicker.fruitType;
					break;
				case CustomEventPropertyPicker.TYPE_PLANT:  // should only happen via linkage
					var oPlantTypePicker:PlantTypePicker = PlantTypePicker(picker);
					event.fruitType = oPlantTypePicker.plantType;
					break;
				default:
					break;
			}
		}
		
		public static function UpdateLinkedEventDate(baseEvent:CustomDayEvent, linkedEvent:CustomDayEvent):void
		{
			if (baseEvent == null || linkedEvent == null)
			{
				return;
			}
			
			var iDirection:int = 0;
			
			if ((baseEvent is CustomPlantEvent) && (linkedEvent is CustomHarvestEvent))
			{
				var oPlantEvent:CustomPlantEvent = CustomPlantEvent(baseEvent);
				iDirection = 1;
			}
			else if ((baseEvent is CustomHarvestEvent) && (linkedEvent is CustomPlantEvent))
			{
				oPlantEvent = CustomPlantEvent(linkedEvent);
				iDirection = -1;
			}
			
			if (iDirection == 0)
			{
				return;
			}
			
			var iNumDays:int = iDirection * Plant.GetDaysToHarvest(oPlantEvent.plantType);
			
			var iBaseDayValue:int = baseEvent.time.GetNumericDateValue();
			var iNewLinkedEventDayValue:int = iBaseDayValue + iNumDays;
			var oNewLinkedTime:Time = Time.GetDateFromNumericValue(iNewLinkedEventDayValue, baseEvent.time.useMonth);
			
			linkedEvent.time = oNewLinkedTime;
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		//- Private Methods -//
		
		
		// Testing Methods //
		
		public static function RunTests():Array
		{
			var lResults:Array = new Array();
			
			lResults.push(CustomDayEventService.UpdateCustomPlantEventValueFromPickerOkIfEventNull());
			lResults.push(CustomDayEventService.UpdateCustomPlantEventValueFromPickerOkIfPickerNull());
			lResults.push(CustomDayEventService.UpdateCustomPlantEventValueFromPickerUpdatesValueFromQuantityPicker());
			lResults.push(CustomDayEventService.UpdateCustomPlantEventValueFromPickerUpdatesValueFromPlantPicker());
			lResults.push(CustomDayEventService.UpdateCustomPlantEventValueFromPickerUpdatesValueFromFruitPicker());
			
			lResults.push(CustomDayEventService.UpdateCustomHarvestEventValueFromPickerOkIfEventNull());
			lResults.push(CustomDayEventService.UpdateCustomHarvestEventValueFromPickerOkIfPickerNull());
			lResults.push(CustomDayEventService.UpdateCustomHarvestEventValueFromPickerUpdatesValueFromQuantityPicker());
			lResults.push(CustomDayEventService.UpdateCustomHarvestEventValueFromPickerUpdatesValueFromFruitPicker());
			lResults.push(CustomDayEventService.UpdateCustomHarvestEventValueFromPickerUpdatesValueFromPlantPicker());
			
			lResults.push(CustomDayEventService.UpdateLinkedEventDateOkIfBaseEventNull());
			lResults.push(CustomDayEventService.UpdateLinkedEventDateOkIfLinkedEventNull());
			lResults.push(CustomDayEventService.UpdateLinkedEventDateUpdatesLinkedHarvestEvent());
			lResults.push(CustomDayEventService.UpdateLinkedEventDateUpdatesLinkedPlantEvent());
			
			return lResults;
		}
		
		private static function UpdateCustomPlantEventValueFromPickerOkIfEventNull():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CustomDayEventService", "UpdateCustomPlantEventValueFromPickerOkIfEventNull");
			oResult.expected = "No exception";
			oResult.actual = "No exception";
			
			var oEvent:CustomPlantEvent = null;
			var oPicker:NumberPicker = new NumberPicker(null, null);
			
			try
			{
				CustomDayEventService.UpdateCustomPlantEventValueFromPicker(oEvent, oPicker);
			}
			catch (e:Error)
			{
				oResult.actual = String(e);
			}
			
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function UpdateCustomPlantEventValueFromPickerOkIfPickerNull():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CustomDayEventService", "UpdateCustomPlantEventValueFromPickerOkIfPickerNull");
			oResult.expected = "No exception";
			oResult.actual = "No exception";
			
			var oEvent:CustomPlantEvent = new CustomPlantEvent();
			var oPicker:NumberPicker = null;
			
			try
			{
				CustomDayEventService.UpdateCustomPlantEventValueFromPicker(oEvent, oPicker);
			}
			catch (e:Error)
			{
				oResult.actual = String(e);
			}
			
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function UpdateCustomPlantEventValueFromPickerUpdatesValueFromQuantityPicker():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CustomDayEventService", "UpdateCustomPlantEventValueFromPickerUpdatesValueFromQuantityPicker");
			var oEvent:CustomPlantEvent = new CustomPlantEvent(Plant.TYPE_CARROT, null, 3);
			var oPicker:NumberPicker = new NumberPicker(null, null, 7);
			var oExpected:CustomPlantEvent = new CustomPlantEvent(Plant.TYPE_CARROT, null, 7);
			
			CustomDayEventService.UpdateCustomPlantEventValueFromPicker(oEvent, oPicker);
			
			oResult.expected = oExpected.PrettyPrint();
			oResult.actual = oEvent.PrettyPrint();
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function UpdateCustomPlantEventValueFromPickerUpdatesValueFromPlantPicker():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CustomDayEventService", "UpdateCustomPlantEventValueFromPickerUpdatesValueFromPlantPicker");
			var oEvent:CustomPlantEvent = new CustomPlantEvent(Plant.TYPE_CARROT, null, 3);
			var oPicker:PlantTypePicker = new PlantTypePicker(null, null, Plant.TYPE_LETTUCE);
			var oExpected:CustomPlantEvent = new CustomPlantEvent(Plant.TYPE_LETTUCE, null, 3);
			
			CustomDayEventService.UpdateCustomPlantEventValueFromPicker(oEvent, oPicker);
			
			oResult.expected = oExpected.PrettyPrint();
			oResult.actual = oEvent.PrettyPrint();
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function UpdateCustomPlantEventValueFromPickerUpdatesValueFromFruitPicker():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CustomDayEventService", "UpdateCustomPlantEventValueFromPickerUpdatesValueFromFruitPicker");
			var oEvent:CustomPlantEvent = new CustomPlantEvent(Plant.TYPE_CARROT, null, 3);
			var oPicker:FruitTypePicker = new FruitTypePicker(null, null, Fruit.TYPE_LETTUCE, new Time(0, 0, 0, 0, 0, 0, false));
			var oExpected:CustomPlantEvent = new CustomPlantEvent(Plant.TYPE_LETTUCE, null, 3);
			
			CustomDayEventService.UpdateCustomPlantEventValueFromPicker(oEvent, oPicker);
			
			oResult.expected = oExpected.PrettyPrint();
			oResult.actual = oEvent.PrettyPrint();
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function UpdateCustomHarvestEventValueFromPickerOkIfEventNull():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CustomDayEventService", "UpdateCustomHarvestEventValueFromPickerOkIfEventNull");
			oResult.expected = "No exception";
			oResult.actual = "No exception";
			
			var oEvent:CustomHarvestEvent = null;
			var oPicker:NumberPicker = new NumberPicker(null, null);
			
			try
			{
				CustomDayEventService.UpdateCustomHarvestEventValueFromPicker(oEvent, oPicker);
			}
			catch (e:Error)
			{
				oResult.actual = String(e);
			}
			
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function UpdateCustomHarvestEventValueFromPickerOkIfPickerNull():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CustomDayEventService", "UpdateCustomHarvestEventValueFromPickerOkIfPickerNull");
			oResult.expected = "No exception";
			oResult.actual = "No exception";
			
			var oEvent:CustomHarvestEvent = new CustomHarvestEvent();
			var oPicker:NumberPicker = null;
			
			try
			{
				CustomDayEventService.UpdateCustomHarvestEventValueFromPicker(oEvent, oPicker);
			}
			catch (e:Error)
			{
				oResult.actual = String(e);
			}
			
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function UpdateCustomHarvestEventValueFromPickerUpdatesValueFromQuantityPicker():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CustomDayEventService", "UpdateCustomHarvestEventValueFromPickerUpdatesValueFromQuantityPicker");
			var oEvent:CustomHarvestEvent = new CustomHarvestEvent(Plant.TYPE_CARROT, null, 3);
			var oPicker:NumberPicker = new NumberPicker(null, null, 7);
			var oExpected:CustomHarvestEvent = new CustomHarvestEvent(Plant.TYPE_CARROT, null, 7);
			
			CustomDayEventService.UpdateCustomHarvestEventValueFromPicker(oEvent, oPicker);
			
			oResult.expected = oExpected.PrettyPrint();
			oResult.actual = oEvent.PrettyPrint();
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function UpdateCustomHarvestEventValueFromPickerUpdatesValueFromFruitPicker():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CustomDayEventService", "UpdateCustomHarvestEventValueFromPickerUpdatesValueFromFruitPicker");
			var oEvent:CustomHarvestEvent = new CustomHarvestEvent(Fruit.TYPE_CARROT, null, 3);
			var oPicker:FruitTypePicker = new FruitTypePicker(null, null, Fruit.TYPE_LETTUCE, new Time(0, 0, 0, 0, 0, 0, false));
			var oExpected:CustomHarvestEvent = new CustomHarvestEvent(Fruit.TYPE_LETTUCE, null, 3);
			
			CustomDayEventService.UpdateCustomHarvestEventValueFromPicker(oEvent, oPicker);
			
			oResult.expected = oExpected.PrettyPrint();
			oResult.actual = oEvent.PrettyPrint();
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function UpdateCustomHarvestEventValueFromPickerUpdatesValueFromPlantPicker():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CustomDayEventService", "UpdateCustomHarvestEventValueFromPickerUpdatesValueFromPlantPicker");
			var oEvent:CustomHarvestEvent = new CustomHarvestEvent(Fruit.TYPE_CARROT, null, 3);
			var oPicker:PlantTypePicker = new PlantTypePicker(null, null, Plant.TYPE_LETTUCE);
			var oExpected:CustomHarvestEvent = new CustomHarvestEvent(Fruit.TYPE_LETTUCE, null, 3);
			
			CustomDayEventService.UpdateCustomHarvestEventValueFromPicker(oEvent, oPicker);
			
			oResult.expected = oExpected.PrettyPrint();
			oResult.actual = oEvent.PrettyPrint();
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function UpdateLinkedEventDateOkIfBaseEventNull():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CustomDayEventService", "UpdateLinkedEventDateOkIfBaseEventNull");
			var oBaseEvent:CustomPlantEvent = null;
			var oLinkedEvent:CustomHarvestEvent = new CustomHarvestEvent();
			
			oResult.expected = "No exception";
			oResult.actual = "No exception";
			
			try
			{
				CustomDayEventService.UpdateLinkedEventDate(oBaseEvent, oLinkedEvent);
			}
			catch (e:Error)
			{
				oResult.actual = String(e);
			}
			
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function UpdateLinkedEventDateOkIfLinkedEventNull():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CustomDayEventService", "UpdateLinkedEventDateOkIfLinkedEventNull");
			var oBaseEvent:CustomPlantEvent = new CustomPlantEvent();
			var oLinkedEvent:CustomHarvestEvent = null;
			
			oResult.expected = "No exception";
			oResult.actual = "No exception";
			
			try
			{
				CustomDayEventService.UpdateLinkedEventDate(oBaseEvent, oLinkedEvent);
			}
			catch (e:Error)
			{
				oResult.actual = String(e);
			}
			
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function UpdateLinkedEventDateUpdatesLinkedHarvestEvent():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CustomDayEventService", "UpdateLinkedEventDateUpdatesLinkedHarvestEvent");
			var oBaseEvent:CustomPlantEvent = new CustomPlantEvent(Plant.TYPE_ASPARAGUS, new Time(0, 0, 0, 0, 0, 0, false));
			var lLinkedEvents:Array = oBaseEvent.GetLinkedEvents();
			
			if (lLinkedEvents.length == 0)
			{
				throw new Error("CustomDayEventService.UpdateLinkedEventDateUpdatesLinkedHarvestedEvent - expected a Linked event, but found none");
				return oResult;
			}
			
			var oLinkedEvent:CustomHarvestEvent = CustomHarvestEvent(lLinkedEvents[0]);
			
			oBaseEvent.plantType = Plant.TYPE_CARROT;
			oLinkedEvent.fruitType = Plant.TYPE_CARROT;
			
			CustomDayEventService.UpdateLinkedEventDate(oBaseEvent, oLinkedEvent);
			
			var oExpected:Time = new Time(0, 9, 0, 0, 2, 0, false);
			
			oResult.expected = oExpected.PrettyPrint();
			oResult.actual = oLinkedEvent.time.PrettyPrint();
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function UpdateLinkedEventDateUpdatesLinkedPlantEvent():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CustomDayEventService", "UpdateLinkedEventDateUpdatesLinkedPlantEvent");
			var oBaseEvent:CustomHarvestEvent = new CustomHarvestEvent(Plant.TYPE_ASPARAGUS, new Time(0, 10, 0, 0, 3, 0, false));
			var lLinkedEvents:Array = oBaseEvent.GetLinkedEvents();
			
			if (lLinkedEvents.length == 0)
			{
				throw new Error("CustomDayEventService.UpdateLinkedEventDateUpdatesLinkedHarvestedEvent - expected a Linked event, but found none");
				return oResult;
			}
			
			var oLinkedEvent:CustomPlantEvent = CustomPlantEvent(lLinkedEvents[0]);
			
			oBaseEvent.fruitType = Plant.TYPE_CARROT;
			oLinkedEvent.plantType = Plant.TYPE_CARROT;
			
			CustomDayEventService.UpdateLinkedEventDate(oBaseEvent, oLinkedEvent);
			
			var oExpected:Time = new Time(0, 1, 0, 0, 1, 0, false);
			
			oResult.expected = oExpected.PrettyPrint();
			oResult.actual = oLinkedEvent.time.PrettyPrint();
			oResult.TestEquals();
			
			return oResult;
		}
		
		/*
		
		private static function ():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CustomDayEventService", "");
			
			return oResult;
		}
		
		*/
		
		//- Testing Methods -//
	}
}