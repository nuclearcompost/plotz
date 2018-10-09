package
{
	//-----------------------
	//Purpose:				Service logic for the CSA program
	//
	//Properties:
	//	
	//Methods:
	//	
	//-----------------------
	public class CsaService
	{
		// Constants //
		
		//- Constants -//
		
		
		// Public Properties //
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		//- Private Properties -//
		
	
		// Initialization //
		
		public function CsaService()
		{
			
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		public static function CreateNewCustomers(csaState:CsaState, towns:Array):void
		{
			if (csaState == null)
			{
				return;
			}
			
			if (towns == null)
			{
				return;
			}
			
			// clear existing customers
			csaState.customers = new Array();
			
			// create cards for each possible customer in the world
			var lHomes:Array = new Array();
			
			for (var town:int = 0; town < towns.length; town++)
			{
				var oObject:Object = towns[town];
				
				if (oObject == null)
				{
					continue;
				}
				
				if (!(oObject is Town))
				{
					continue;
				}
				
				var oTown:Town = Town(oObject);
				
				if (oTown.bldgs == null)
				{
					continue;
				}
				
				for (var bldg:int = 0; bldg < oTown.bldgs.length; bldg++)
				{
					oObject = oTown.bldgs[bldg];
					
					if (oObject == null)
					{
						continue;
					}
					
					if (!(oObject is Home))
					{
						continue;
					}
					
					var oHome:Home = Home(oObject);
					
					lHomes.push(oHome);
				}
			}
			
			// pull a random card for each new customer we need
			for (var i:int = 0; i < csaState.maxCustomers; i++)
			{
				if (lHomes.length == 0)
				{
					break;
				}
				
				var iIndex:int = Math.floor(Math.random() * lHomes.length);
				
				var lReturn:Array = lHomes.splice(iIndex, 1);
				
				if (lReturn == null)
				{
					break;
				}
				
				oHome = Home(lReturn[0]);
				
				var oCustomer:CsaCustomer = new CsaCustomer(oHome.address.streetNumber + " " + oHome.address.streetName, 0, false, false);
				
				csaState.customers.push(oCustomer);
			}
		}
		
		public static function DeliverItems(csaState:CsaState, csaCustomer:CsaCustomer):void
		{
			if (csaState == null)
			{
				return;
			}
			
			if (csaCustomer == null)
			{
				return;
			}
			
			var iScore:int = CsaService.ScoreItemDelivery(csaState.deliveryInventory);
			
			csaCustomer.deliveryScore = iScore;
			csaCustomer.gotDelivery = true;
			
			csaState.deliveryInventory.ClearAllItems();
		}
		
		public static function DoFinalDelivery(csaState:CsaState):void
		{
			if (csaState == null)
			{
				return;
			}
			
			if (csaState.deliveryInventory == null)
			{
				return;
			}
			
			var iRemainingItems:int = csaState.deliveryInventory.GetNumItems();
			
			if (iRemainingItems == 0)
			{
				return;
			}
			
			var oCustomer:CsaCustomer = CsaService.GetFirstCustomerNeedingDelivery(csaState);
			
			if (oCustomer == null)
			{
				throw new Error("There are still " + iRemainingItems + " in the delivery inventory, but there are no customers to deliver to");
				return;
			}
			
			CsaService.DeliverItems(csaState, oCustomer);
		}
		
		public static function GetCsaDayType(time:Time):int
		{
			var iDayType:int = CsaState.DAY_TYPE_STATUS;
			
			switch (time.date)
			{
				case 0:
				case 14:
					iDayType = CsaState.DAY_TYPE_SIGNUP;
					break;
				case 13:
				case 27:
					iDayType = CsaState.DAY_TYPE_DELIVERY;
					break;
				default:
					break;
			}
			
			return iDayType;
		}
		
		public static function GetFirstCustomerNeedingDelivery(csaState:CsaState):CsaCustomer
		{
			if (csaState == null)
			{
				return null;
			}
			
			if (csaState.customers == null)
			{
				return null;
			}
			
			var oDeliveryCustomer:CsaCustomer = null;
			
			for (var i:int = 0; i < csaState.customers.length; i++)
			{
				var oObject:Object = csaState.customers[i];
				
				if (oObject == null)
				{
					continue;
				}
				
				if (!(oObject is CsaCustomer))
				{
					continue;
				}
				
				var oCustomer:CsaCustomer = CsaCustomer(oObject);
				
				if (oCustomer.gotDelivery == false && oCustomer.signedUp == true)
				{
					oDeliveryCustomer = oCustomer;
					break;
				}
			}
			
			return oDeliveryCustomer;
		}
		
		public static function GetHalfPaymentAmount(season:int):int
		{
			var iAverageFruitCost:int = Fruit.GetAverageFruitCostForSeason(season);
			
			var iHalfPaymentAmount:int = (iAverageFruitCost * CsaState.PRODUCTS_PER_CUSTOMER) / 2;
			
			return iHalfPaymentAmount;
		}
		
		public static function GetNextDeliveryDate(time:Time):Time
		{
			if (time == null)
			{
				return null;
			}
			
			var oDeliveryDate:Time = new Time(time.time, 0, time.month, time.year, Time.DAY_SUNDAY, time.season, time.useMonth);
			
			if (time.date < 14)
			{
				oDeliveryDate.date = 13;
			}
			else
			{
				oDeliveryDate.date = 27;
			}
			
			return oDeliveryDate;
		}
		
		public static function GetNextSignupDate(time:Time):Time
		{
			if (time == null)
			{
				return null;
			}
			
			var oSignupDate:Time = new Time(time.time, 0, time.month, time.year, Time.DAY_MONDAY, time.season, time.useMonth);
			
			if (time.date > 0 && time.date < 15)
			{
				oSignupDate.date = 14;
			}
			
			if (time.date > 14 && time.date < 28)
			{
				oSignupDate.month = TimeService.GetNextMonth(time);
				oSignupDate.season = TimeService.GetSeasonForMonth(oSignupDate);
			}
			
			return oSignupDate;
		}
		
		public static function GetNumCustomersNeedingDelivery(csaState:CsaState):int
		{
			if (csaState == null)
			{
				return 0;
			}
			
			if (csaState.customers == null)
			{
				return 0;
			}
			
			var iCustomersNeedingDelivery:int = 0;
			
			for (var i:int = 0; i < csaState.customers.length; i++)
			{
				var oObject:Object = csaState.customers[i];
				
				if (oObject == null)
				{
					continue;
				}
				
				if (!(oObject is CsaCustomer))
				{
					continue;
				}
				
				var oCustomer:CsaCustomer = CsaCustomer(oObject);
				
				if (oCustomer.gotDelivery == false && oCustomer.signedUp == true)
				{
					iCustomersNeedingDelivery++;
				}
			}
			
			return iCustomersNeedingDelivery;
		}
		
		public static function GetNumCustomersSignedUp(csaState:CsaState):int
		{
			if (csaState == null)
			{
				return 0;
			}
			
			if (csaState.customers == null)
			{
				return 0;
			}
			
			var iNumCustomersSignedUp:int = 0;
			
			for (var i:int = 0; i < csaState.customers.length; i++)
			{
				var oObject:Object = csaState.customers[i];
				
				if (oObject == null)
				{
					continue;
				}
				
				if (!(oObject is CsaCustomer))
				{
					continue;
				}
				
				var oCustomer:CsaCustomer = CsaCustomer(oObject);
				
				if (oCustomer.signedUp == true)
				{
					iNumCustomersSignedUp++;
				}
			}
			
			return iNumCustomersSignedUp;
		}
		
		public static function PrepareNextRound(csaState:CsaState):void
		{
			if (csaState == null)
			{
				return;
			}
			
			if (csaState.customers == null)
			{
				return;
			}
			
			var iPassingScore:int = CsaService.GetMinimumPassingDeliveryScore();
			
			var iPassingCustomers:int = 0;
			var iFailedCustomers:int = 0;
			
			// get counts of how many customers got a good enough delivery to be happy with it
			for (var i:int = 0; i < csaState.customers.length; i++)
			{
				var oObject:Object = csaState.customers[i];
				
				if (oObject == null)
				{
					continue;
				}
				
				if (!(oObject is CsaCustomer))
				{
					continue;
				}
				
				var oCustomer:CsaCustomer = CsaCustomer(oObject);
				
				if (oCustomer.signedUp == false)
				{
					continue;
				}
				
				if (oCustomer.gotDelivery == true && oCustomer.deliveryScore >= iPassingScore)
				{
					iPassingCustomers++;
				}
				else
				{
					iFailedCustomers++;
				}
			}
			
			// adjust how many people want to be in the CSA program based on the percentage of happy customers
			var nHappyRatio:Number = iPassingCustomers / iFailedCustomers;
			
			if (nHappyRatio >= .75)
			{
				csaState.maxCustomers++;
				
				if (csaState.maxCustomers > CsaState.MAX_CUSTOMERS)
				{
					csaState.maxCustomers = CsaState.MAX_CUSTOMERS;
				}
			}
			else if (nHappyRatio < .5)
			{
				csaState.maxCustomers--;
				
				if (csaState.maxCustomers < 1)
				{
					csaState.maxCustomers = 1;
				}
			}
		}
		
		public static function ShouldGetDeliveryPayment(customer:CsaCustomer):Boolean
		{
			if (customer == null)
			{
				return false;
			}
			
			var iMinimumScore:int = CsaService.GetMinimumPassingDeliveryScore();
			
			if (customer.signedUp == false || customer.gotDelivery == false || customer.deliveryScore < iMinimumScore)
			{
				return false;
			}
			
			return true;
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		private static function GetMinimumPassingDeliveryScore():int
		{
			var oInventory:Inventory = new Inventory(CsaState.PRODUCTS_PER_CUSTOMER, "Stuff", [ "Fruit" ]);
			
			for (var i:int = 0; i < (CsaState.PRODUCTS_PER_CUSTOMER - 1); i++)
			{
				var oFruit:Fruit = new Fruit(i, 0, Fruit.CONDITION_RIPE, Fruit.QUALITY_FAIR);
				
				oInventory.AddItem(oFruit);
			}
			
			oFruit = new Fruit(0, 0, Fruit.CONDITION_RIPE, Fruit.QUALITY_FAIR);
			oInventory.AddItem(oFruit);
			
			var iPassScore:int = CsaService.ScoreItemDelivery(oInventory);
			
			return iPassScore;
		}
		
		// return a quality score for a set of items to be delivered to a CsaCustomer
		private static function ScoreItemDelivery(deliveryInventory:Inventory):int
		{
			var iQuantity:int = 2 * deliveryInventory.GetNumItems();
			
			var iQuality:int = 0;
			var iVariety:int = 0;
			var lFruitTypes:Array = new Array();
			
			for (var i:int = 0; i < deliveryInventory.maxSize; i++)
			{
				var oObject:Object = deliveryInventory.GetItemAt(i);
				
				if (oObject == null)
				{
					continue;
				}
				
				if (!(oObject is Fruit))
				{
					continue;
				}
				
				var oFruit:Fruit = Fruit(oObject);
				
				if (oFruit.condition == Fruit.CONDITION_RIPE)
				{
					iQuality += oFruit.quality;
				}
				else
				{
					iQuality = 0;
					iQuantity -= 2;
					continue;
				}
				
				var iType:int = oFruit.type;
				var bTypeAlreadyFound:Boolean = false;
				
				for (var f:int = 0; f < lFruitTypes.length; f++)
				{
					if (iType == lFruitTypes[f])
					{
						bTypeAlreadyFound = true;
						break;
					}
				}
				
				if (bTypeAlreadyFound == false)
				{
					iVariety += 2;
					lFruitTypes.push(iType);
				}
			}
			
			var iScore:int = iQuantity + iQuality + iVariety;
			
			return iScore;
		}
		
		//- Private Methods -//
		
		
		// Testing Methods //
		
		public static function RunTests():Array
		{
			var lResults:Array = new Array();
			
			lResults.push(CsaService.DeliverItemsSetsCustomerDeliveryScore());
			lResults.push(CsaService.DeliverItemsSetsCustomerGotDelivery());
			lResults.push(CsaService.DeliverItemsClearsInventory());
			lResults = lResults.concat(CsaService.TestGetCsaDayType());
			lResults = lResults.concat(CsaService.TestScoreItemDelivery());
			lResults.push(CsaService.GetFirstCustomerNeedingDeliveryNullIfNullCsaState());
			lResults.push(CsaService.GetFirstCustomerNeedingDeliveryNullIfNullCustomerList());
			lResults.push(CsaService.GetFirstCustomerNeedingDeliveryNullIf0Customers());
			lResults.push(CsaService.GetFirstCustomerNeedingDeliveryNullIfAllSignedUpCustomersGotDelivery());
			lResults.push(CsaService.GetFirstCustomerNeedingDeliveryNotNullIfSignedUpCustomerNeedsDelivery());
			
			lResults.push(CsaService.GetNextDeliveryDateOkForNullTime());
			lResults = lResults.concat(CsaService.GetNextDeliveryDateReturnsCorrectTime());
			
			lResults.push(CsaService.GetNextSignupDateOkForNullTime());
			lResults = lResults.concat(CsaService.GetNextSignupDateReturnsCorrectTime());
			
			lResults.push(CsaService.GetNumCustomersNeedingDelivery0IfNullCsaState());
			lResults.push(CsaService.GetNumCustomersNeedingDelivery0IfNullCustomerList());
			lResults.push(CsaService.GetNumCustomersNeedingDelivery0If0Customers());
			lResults.push(CsaService.GetNumCustomersNeedingDelivery0IfAllSignedUpCustomersGotDelivery());
			lResults.push(CsaService.GetNumCustomersNeedingDeliveryGivesCorrectCount());
				
			lResults.push(CsaService.ShouldGetDeliveryPaymentFalseIfNullCustomer());
			lResults.push(CsaService.ShouldGetDeliveryPaymentFalseIfCustomerNotSignedUp());
			lResults.push(CsaService.ShouldGetDeliveryPaymentFalseIfCustomerNotDeliveredTo());
			lResults.push(CsaService.ShouldGetDeliveryPaymentFalseIfTooLowDeliveryScore());
			lResults.push(CsaService.ShouldGetDeliveryPaymentTrue());
			
			lResults.push(CsaService.GetNumCustomersSignedUp0IfNullCsaState());
			lResults.push(CsaService.GetNumCustomersSignedUp0IfNullCustomers());
			lResults.push(CsaService.GetNumCustomersSignedUpReturnsCount());
			
			return lResults;
		}
		
		private static function DeliverItemsSetsCustomerDeliveryScore():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CsaService", "DeliverItemsSetsCustomerDeliveryScore");
			
			var oFruit1:Fruit = new Fruit(Fruit.TYPE_ALFALFA, 0, Fruit.CONDITION_RIPE, Fruit.QUALITY_GOOD);
			var oFruit2:Fruit = new Fruit(Fruit.TYPE_ASPARAGUS, 0, Fruit.CONDITION_RIPE, Fruit.QUALITY_GOOD);
			var oFruit3:Fruit = new Fruit(Fruit.TYPE_BROCCOLI, 0, Fruit.CONDITION_RIPE, Fruit.QUALITY_GOOD);
			var oFruit4:Fruit = new Fruit(Fruit.TYPE_CARROT, 0, Fruit.CONDITION_RIPE, Fruit.QUALITY_GOOD);
			var oInventory:Inventory = new Inventory(4, "Csa Delivery", [ "Fruit" ], [ oFruit1, oFruit2, oFruit3, oFruit4 ]);
			var oCsaState:CsaState = new CsaState(oInventory);
			var oCsaCustomer:CsaCustomer = new CsaCustomer();
			
			CsaService.DeliverItems(oCsaState, oCsaCustomer);
			
			oResult.expected = "24";
			oResult.actual = String(oCsaCustomer.deliveryScore);
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function DeliverItemsSetsCustomerGotDelivery():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CsaService", "DeliverItemsSetsCustomerGotDelivery");
			
			var oFruit1:Fruit = new Fruit(Fruit.TYPE_ALFALFA, 0, Fruit.CONDITION_RIPE, Fruit.QUALITY_GOOD);
			var oFruit2:Fruit = new Fruit(Fruit.TYPE_ASPARAGUS, 0, Fruit.CONDITION_RIPE, Fruit.QUALITY_GOOD);
			var oFruit3:Fruit = new Fruit(Fruit.TYPE_BROCCOLI, 0, Fruit.CONDITION_RIPE, Fruit.QUALITY_GOOD);
			var oFruit4:Fruit = new Fruit(Fruit.TYPE_CARROT, 0, Fruit.CONDITION_RIPE, Fruit.QUALITY_GOOD);
			var oInventory:Inventory = new Inventory(4, "Csa Delivery", [ "Fruit" ], [ oFruit1, oFruit2, oFruit3, oFruit4 ]);
			var oCsaState:CsaState = new CsaState(oInventory);
			var oCsaCustomer:CsaCustomer = new CsaCustomer();
			
			CsaService.DeliverItems(oCsaState, oCsaCustomer);
			
			oResult.TestTrue(oCsaCustomer.gotDelivery);
			
			return oResult;
		}
		
		private static function DeliverItemsClearsInventory():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CsaService", "DeliverItemsClearsInventory");
			var oInventory:Inventory = new Inventory(2, "Stuff", [ "Fruit" ], [ new Fruit(Fruit.TYPE_CARROT), new Fruit(Fruit.TYPE_CARROT) ]);
			var oCsaState:CsaState = new CsaState(oInventory);
			
			CsaService.DeliverItems(oCsaState, new CsaCustomer());
			
			oResult.expected = "0";
			oResult.actual = String(oInventory.GetNumItems());
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function TestGetCsaDayType():Array
		{
			var oSignup1Result:UnitTestResult = new UnitTestResult("CsaService", "TestGetCsaDayType - signup day 1");
			var oSignup2Result:UnitTestResult = new UnitTestResult("CsaService", "TestGetCsaDayType - signup day 2");
			var oDelivery1Result:UnitTestResult = new UnitTestResult("CsaService", "TestGetCsaDayType - delivery day 1");
			var oDelivery2Result:UnitTestResult = new UnitTestResult("CsaService", "TestGetCsaDayType - delivery day 2");
			var oStatusResult:UnitTestResult = new UnitTestResult("CsaService", "TestGetCsaDayType - status days");
			
			var lResults:Array = [ oSignup1Result, oSignup2Result, oDelivery1Result, oDelivery2Result, oStatusResult ];
			
			var oTime:Time = new Time(0, 0);
			oSignup1Result.expected = String(CsaState.DAY_TYPE_SIGNUP);
			oSignup1Result.actual = String(CsaService.GetCsaDayType(oTime));
			oSignup1Result.TestEquals();
			
			oTime = new Time(0, 14);
			oSignup2Result.expected = String(CsaState.DAY_TYPE_SIGNUP);
			oSignup2Result.actual = String(CsaService.GetCsaDayType(oTime));
			oSignup2Result.TestEquals();
			
			oTime = new Time(0, 13);
			oDelivery1Result.expected = String(CsaState.DAY_TYPE_DELIVERY);
			oDelivery1Result.actual = String(CsaService.GetCsaDayType(oTime));
			oDelivery1Result.TestEquals();
			
			oTime = new Time(0, 27);
			oDelivery2Result.expected = String(CsaState.DAY_TYPE_DELIVERY);
			oDelivery2Result.actual = String(CsaService.GetCsaDayType(oTime));
			oDelivery2Result.TestEquals();
			
			var lOtherDays:Array = [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 ];
			
			oStatusResult.expected = String(lOtherDays.length * CsaState.DAY_TYPE_STATUS);
			
			var iActual:int = 0;
			
			for (var i:int = 0; i < lOtherDays.length; i++)
			{
				oTime = new Time(0, lOtherDays[i]);
				iActual += CsaService.GetCsaDayType(oTime);
			}
			
			oStatusResult.actual = String(iActual);
			oStatusResult.TestEquals();
			
			return lResults;
		}
		
		private static function TestScoreItemDelivery():Array
		{
			var o4GoodResult:UnitTestResult = new UnitTestResult("CsaService", "TestScoreItemDelivery - 4 unique good");
			var o2GoodResult:UnitTestResult = new UnitTestResult("CsaService", "TestScoreItemDelivery - 2 unique good");
			var o4SameGoodResult:UnitTestResult = new UnitTestResult("CsaService", "TestScoreItemDelivery - 4 same good");
			var o4FairResult:UnitTestResult = new UnitTestResult("CsaService", "TestScoreItemDelivery - 4 unique fair");
			var oRottenResult:UnitTestResult = new UnitTestResult("CsaService", "TestScoreItemDelivery - rotten count 0");
			var o0Result:UnitTestResult = new UnitTestResult("CsaService", "TestScoreItemDelivery - 0 result");
			
			var lResults:Array = [ o4GoodResult, o2GoodResult, o4SameGoodResult, o4FairResult, oRottenResult, o0Result ];
			
			//-- o4GoodResult
			
			var oFruit1:Fruit = new Fruit(Fruit.TYPE_ALFALFA, 0, Fruit.CONDITION_RIPE, Fruit.QUALITY_GOOD);
			var oFruit2:Fruit = new Fruit(Fruit.TYPE_ASPARAGUS, 0, Fruit.CONDITION_RIPE, Fruit.QUALITY_GOOD);
			var oFruit3:Fruit = new Fruit(Fruit.TYPE_BROCCOLI, 0, Fruit.CONDITION_RIPE, Fruit.QUALITY_GOOD);
			var oFruit4:Fruit = new Fruit(Fruit.TYPE_CARROT, 0, Fruit.CONDITION_RIPE, Fruit.QUALITY_GOOD);
			var oInventory:Inventory = new Inventory(4, "Csa Delivery", [ "Fruit" ], [ oFruit1, oFruit2, oFruit3, oFruit4 ]);
			
			o4GoodResult.expected = "24";
			o4GoodResult.actual = String(CsaService.ScoreItemDelivery(oInventory));
			o4GoodResult.TestEquals();
			
			//-- o2GoodResult
			
			oFruit1 = new Fruit(Fruit.TYPE_ALFALFA, 0, Fruit.CONDITION_RIPE, Fruit.QUALITY_GOOD);
			oFruit2 = new Fruit(Fruit.TYPE_ASPARAGUS, 0, Fruit.CONDITION_RIPE, Fruit.QUALITY_GOOD);
			oFruit3 = null;
			oFruit4 = null;
			oInventory = new Inventory(4, "Csa Delivery", [ "Fruit" ], [ oFruit1, oFruit2, oFruit3, oFruit4 ]);
			
			o2GoodResult.expected = "12";
			o2GoodResult.actual = String(CsaService.ScoreItemDelivery(oInventory));
			o2GoodResult.TestEquals();
			
			//--o4SameGoodResult
			
			oFruit1 = new Fruit(Fruit.TYPE_ALFALFA, 0, Fruit.CONDITION_RIPE, Fruit.QUALITY_GOOD);
			oFruit2 = new Fruit(Fruit.TYPE_ALFALFA, 0, Fruit.CONDITION_RIPE, Fruit.QUALITY_GOOD);
			oFruit3 = new Fruit(Fruit.TYPE_ALFALFA, 0, Fruit.CONDITION_RIPE, Fruit.QUALITY_GOOD);
			oFruit4 = new Fruit(Fruit.TYPE_ALFALFA, 0, Fruit.CONDITION_RIPE, Fruit.QUALITY_GOOD);
			oInventory = new Inventory(4, "Csa Delivery", [ "Fruit" ], [ oFruit1, oFruit2, oFruit3, oFruit4 ]);
			
			o4SameGoodResult.expected = "18";
			o4SameGoodResult.actual = String(CsaService.ScoreItemDelivery(oInventory));
			o4SameGoodResult.TestEquals();
			
			//-- o4FairResult
			
			oFruit1 = new Fruit(Fruit.TYPE_ALFALFA, 0, Fruit.CONDITION_RIPE, Fruit.QUALITY_FAIR);
			oFruit2 = new Fruit(Fruit.TYPE_ASPARAGUS, 0, Fruit.CONDITION_RIPE, Fruit.QUALITY_FAIR);
			oFruit3 = new Fruit(Fruit.TYPE_BROCCOLI, 0, Fruit.CONDITION_RIPE, Fruit.QUALITY_FAIR);
			oFruit4 = new Fruit(Fruit.TYPE_CARROT, 0, Fruit.CONDITION_RIPE, Fruit.QUALITY_FAIR);
			oInventory = new Inventory(4, "Csa Delivery", [ "Fruit" ], [ oFruit1, oFruit2, oFruit3, oFruit4 ]);
			
			o4FairResult.expected = "20";
			o4FairResult.actual = String(CsaService.ScoreItemDelivery(oInventory));
			o4FairResult.TestEquals();
			
			//-- oRottenResult
			
			oFruit1 = new Fruit(Fruit.TYPE_ALFALFA, 0, Fruit.CONDITION_ROTTEN, Fruit.QUALITY_GOOD);
			oFruit2 = new Fruit(Fruit.TYPE_ASPARAGUS, 0, Fruit.CONDITION_RIPE, Fruit.QUALITY_GOOD);
			oFruit3 = new Fruit(Fruit.TYPE_BROCCOLI, 0, Fruit.CONDITION_RIPE, Fruit.QUALITY_GOOD);
			oFruit4 = new Fruit(Fruit.TYPE_CARROT, 0, Fruit.CONDITION_RIPE, Fruit.QUALITY_GOOD);
			oInventory = new Inventory(4, "Csa Delivery", [ "Fruit" ], [ oFruit1, oFruit2, oFruit3, oFruit4 ]);
			
			oRottenResult.expected = "18";
			oRottenResult.actual = String(CsaService.ScoreItemDelivery(oInventory));
			oRottenResult.TestEquals();
			
			//-- o0Result
			
			oFruit1 = null;
			oFruit2 = null;
			oFruit3 = null;
			oFruit4 = null;
			oInventory = new Inventory(4, "Csa Delivery", [ "Fruit" ], [ oFruit1, oFruit2, oFruit3, oFruit4 ]);
			
			o0Result.expected = "0";
			o0Result.actual = String(CsaService.ScoreItemDelivery(oInventory));
			o0Result.TestEquals();
			
			return lResults;
		}
		
		private static function GetFirstCustomerNeedingDeliveryNullIfNullCsaState():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CsaService", "GetFirstCustomerNeedingDeliveryNullIfNullCsaState");
			
			var oCsaState:CsaState = null;
			
			oResult.TestNull(CsaService.GetFirstCustomerNeedingDelivery(oCsaState));
			
			return oResult;
		}
		
		private static function GetFirstCustomerNeedingDeliveryNullIfNullCustomerList():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CsaService", "GetFirstCustomerNeedingDeliveryNullIfNullCustomerList");
			
			var oCsaState:CsaState = new CsaState();
			oCsaState.customers = null;
			
			oResult.TestNull(CsaService.GetFirstCustomerNeedingDelivery(oCsaState));
			
			return oResult;
		}
		
		private static function GetFirstCustomerNeedingDeliveryNullIf0Customers():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CsaService", "GetFirstCustomerNeedingDeliveryNullIf0Customers");
			
			var oCsaState:CsaState = new CsaState();
			oCsaState.customers = new Array();
			
			oResult.TestNull(CsaService.GetFirstCustomerNeedingDelivery(oCsaState));
			
			return oResult;
		}
		
		private static function GetFirstCustomerNeedingDeliveryNullIfAllSignedUpCustomersGotDelivery():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CsaService", "GetFirstCustomerNeedingDeliveryNullIfAllSignedUpCustomersGotDelivery");
			
			var oCsaState:CsaState = new CsaState();
			oCsaState.customers = [ new CsaCustomer("Aerith", 0, true, true), new CsaCustomer("Barret", 0, true, true), new CsaCustomer("Cloud", 0, false, false) ];
			
			oResult.TestNull(CsaService.GetFirstCustomerNeedingDelivery(oCsaState));
			
			return oResult;
		}
		
		private static function GetFirstCustomerNeedingDeliveryNotNullIfSignedUpCustomerNeedsDelivery():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CsaService", "GetFirstCustomerNeedingDeliveryNotNullIfSignedUpCustomerNeedsDelivery");
			
			var oCsaState:CsaState = new CsaState();
			oCsaState.customers = [ new CsaCustomer("Aerith", 0, false, false), new CsaCustomer("Barret", 0, true, true), new CsaCustomer("Cloud", 0, false, true) ];
			
			var oReturn:CsaCustomer = CsaService.GetFirstCustomerNeedingDelivery(oCsaState);
			
			oResult.expected = "Cloud";
			oResult.actual = oReturn.name;
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GetNextDeliveryDateOkForNullTime():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CsaService", "GetNextDeliveryDateOkForNullTime");
			
			oResult.TestNull(CsaService.GetNextDeliveryDate(null));
			
			return oResult;
		}
		
		private static function GetNextDeliveryDateReturnsCorrectTime():Array
		{
			var lResults:Array = new Array();
			
			var bAllOk:Boolean = true;
			
			for (var date:int = 0; date < 28; date++)
			{
				var iDay:int = TimeService.GetDayForDate(date);
				var oTime:Time = new Time(0, date, 3, 2, iDay, 0, true);
				
				var oActual:Time = CsaService.GetNextDeliveryDate(oTime);
				
				if (date < 14)
				{
					var oExpected:Time = new Time(0, 13, 3, 2, 6, 0, true);
				}
				else
				{
					oExpected = new Time(0, 27, 3, 2, 6, 0, true);
				}
				
				var oResult:UnitTestResult = new UnitTestResult("CsaService", "GetNextDeliveryDateReturnsCorrectTime - Date " + date);
				oResult.expected = oExpected.PrettyPrint();
				
				if (oActual == null)
				{
					oResult.actual = "";
				}
				else
				{
					oResult.actual = oActual.PrettyPrint();
				}
				
				oResult.TestEquals();
				
				lResults.push(oResult);
			}
			
			return lResults;
		}
		
		private static function GetNextSignupDateOkForNullTime():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CsaService", "GetNextSignupDateOkForNullTime");
			
			oResult.TestNull(CsaService.GetNextSignupDate(null));
			
			return oResult;
		}
		
		private static function GetNextSignupDateReturnsCorrectTime():Array
		{
			var lResults:Array = new Array();
			
			for (var i:int = 0; i < 28; i++)
			{
				var iDay:int = TimeService.GetDayForDate(i);
				var oTime:Time = new Time(0, i, 3, 2, iDay, 1, true);
				
				var oResult:UnitTestResult = new UnitTestResult("CsaService", "GetNextSignupDateReturnsCorrectTime - Date " + i);
				
				if (i == 0)
				{
					var oExpected:Time = new Time(0, 0, 3, 2, 0, 1, true);
				}
				else if (i > 0 && i < 15)
				{
					oExpected = new Time(0, 14, 3, 2, 0, 1, true);
				}
				else if (i > 14 && i < 28)
				{
					oExpected = new Time(0, 0, 4, 2, 0, 1, true);
				}
				
				var oActual:Time = CsaService.GetNextSignupDate(oTime);
				
				oResult.expected = oExpected.PrettyPrint();
				
				if (oActual == null)
				{
					oResult.actual = "";
				}
				else
				{
					oResult.actual = oActual.PrettyPrint();
				}
				
				oResult.TestEquals();
				
				lResults.push(oResult);
			}
			
			return lResults;
		}
		
		private static function GetNumCustomersNeedingDelivery0IfNullCsaState():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CsaService", "GetNumCustomersNeedingDelivery0IfNullCsaState");
			
			var oCsaState:CsaState = null
			
			oResult.expected = "0";
			oResult.actual = String(CsaService.GetNumCustomersNeedingDelivery(oCsaState));
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GetNumCustomersNeedingDelivery0IfNullCustomerList():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CsaService", "GetNumCustomersNeedingDelivery0IfNullCustomerList");
			
			var oCsaState:CsaState = new CsaState();
			oCsaState.customers = null;
			
			oResult.expected = "0";
			oResult.actual = String(CsaService.GetNumCustomersNeedingDelivery(oCsaState));
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GetNumCustomersNeedingDelivery0If0Customers():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CsaService", "GetNumCustomersNeedingDelivery0If0Customers");
			
			var oCsaState:CsaState = new CsaState();
			oCsaState.customers = new Array();
			
			oResult.expected = "0";
			oResult.actual = String(CsaService.GetNumCustomersNeedingDelivery(oCsaState));
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GetNumCustomersNeedingDelivery0IfAllSignedUpCustomersGotDelivery():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CsaService", "GetNumCustomersNeedingDelivery0IfAllSignedUpCustomersGotDelivery");
			
			var oCsaState:CsaState = new CsaState();
			oCsaState.customers = [ new CsaCustomer("Aerith", 0, true, true), new CsaCustomer("Barret", 0, true, true), new CsaCustomer("Cloud", 0, false, false) ];
			
			oResult.expected = "0";
			oResult.actual = String(CsaService.GetNumCustomersNeedingDelivery(oCsaState));
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GetNumCustomersNeedingDeliveryGivesCorrectCount():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CsaService", "GetNumCustomersNeedingDeliveryGivesCorrectCount");
			
			var oCsaState:CsaState = new CsaState();
			oCsaState.customers = [ new CsaCustomer("Aerith", 0, false, true), new CsaCustomer("Barret", 0, true, true), new CsaCustomer("Cloud", 0, false, false) ];
			
			oResult.expected = "1";
			oResult.actual = String(CsaService.GetNumCustomersNeedingDelivery(oCsaState));
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function ShouldGetDeliveryPaymentFalseIfNullCustomer():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CsaService", "ShouldGetDeliveryPaymentFalseIfNullCustomer");
			var oCustomer:CsaCustomer = null;
			
			oResult.TestFalse(CsaService.ShouldGetDeliveryPayment(oCustomer));
			
			return oResult;
		}
		
		private static function ShouldGetDeliveryPaymentFalseIfCustomerNotSignedUp():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CsaService", "ShouldGetDeliveryPaymentFalseIfCustomerNotSignedUp");
			var iPassingScore:int = CsaService.GetMinimumPassingDeliveryScore();
			var oCustomer:CsaCustomer = new CsaCustomer("someone", iPassingScore + 1, true, false);
			
			oResult.TestFalse(CsaService.ShouldGetDeliveryPayment(oCustomer));
			
			return oResult;
		}
		
		private static function ShouldGetDeliveryPaymentFalseIfCustomerNotDeliveredTo():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CsaService", "ShouldGetDeliveryPaymentFalseIfCustomerNotDeliveredTo");
			var iPassingScore:int = CsaService.GetMinimumPassingDeliveryScore();
			var oCustomer:CsaCustomer = new CsaCustomer("someone", iPassingScore + 1, false, true);
			
			oResult.TestFalse(CsaService.ShouldGetDeliveryPayment(oCustomer));
			
			return oResult;
		}
		
		private static function ShouldGetDeliveryPaymentFalseIfTooLowDeliveryScore():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CsaService", "ShouldGetDeliveryPaymentFalseIfTooLowDeliveryScore");
			var iPassingScore:int = CsaService.GetMinimumPassingDeliveryScore();
			var oCustomer:CsaCustomer = new CsaCustomer("someone", iPassingScore - 1, true, true);
			
			oResult.TestFalse(CsaService.ShouldGetDeliveryPayment(oCustomer));
			
			return oResult;
		}
		
		private static function ShouldGetDeliveryPaymentTrue():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CsaService", "ShouldGetDeliveryPaymentTrue");
			var iPassingScore:int = CsaService.GetMinimumPassingDeliveryScore();
			var oCustomer:CsaCustomer = new CsaCustomer("someone", iPassingScore + 1, true, true);
			
			oResult.TestTrue(CsaService.ShouldGetDeliveryPayment(oCustomer));
			
			return oResult;
		}
		
		private static function GetNumCustomersSignedUp0IfNullCsaState():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CsaService", "GetNumCustomersSignedUp0IfNullCsaState");
			var oCsaState:CsaState = null;
			
			oResult.expected = "0";
			oResult.actual = String(CsaService.GetNumCustomersSignedUp(oCsaState));
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GetNumCustomersSignedUp0IfNullCustomers():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CsaService", "GetNumCustomersSignedUp0IfNullCustomers");
			var lCustomers:Array = null;
			var oCsaState:CsaState = new CsaState(null, lCustomers);
			
			oResult.expected = "0";
			oResult.actual = String(CsaService.GetNumCustomersSignedUp(oCsaState));
			oResult.TestEquals();
			
			return oResult;
		}
		
		private static function GetNumCustomersSignedUpReturnsCount():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("CsaService", "GetNumCustomersSignedUpReturnsCount");
			var lCustomers:Array = [ new CsaCustomer("a", 0, false, false), new CsaCustomer("b", 0, false, true), new Plant() ];
			var oCsaState:CsaState = new CsaState(null, lCustomers);
			
			oResult.expected = "1";
			oResult.actual = String(CsaService.GetNumCustomersSignedUp(oCsaState));
			oResult.TestEquals();
			
			return oResult;
		}
		
		//- Testing Methods -//
	}
}