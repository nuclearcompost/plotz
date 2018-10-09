package
{
	import flash.utils.getQualifiedClassName;
	
	//-----------------------
	//Purpose:				An inventory system that holds and allows access to an array of items
	//
	//Properties:
	//	_contents:Array = 1d array of the Inventory's contents
	//	_displayName:String = user-friendly name of the Inventory
	//	_maxSize:int = the maximum number of items allowed in the Inventory
	//	_typesAllowed:Array = 1d array of strings which are the names of classes allowed to be placed in the Inventory
	//	_volatile:Boolean = true if placing items in this Inventory causes them to degrade
	//
	//Methods:
	//	AddItem(item:Object):Boolean = adds the given item to the first open spot if possible; returns true if the item could be added
	//	AddItemAt(item:Object, slot:int):Boolean = adds the given item to the given slot if possible without overwriting existing items; returns true if the item could be added
	//	CanAddItem(item:Object, tab:int = 0):Boolean = returns true if the item can be added to the Inventory on the given tab
	//	CanAddItemAt(item:Object, slot:int, tab:int = 0):Boolean = returns true if the item can be added to the Inventory on the given tab and slot
	//	ClearAllItems():void = set all items in the Inventory to null
	//	ClearAllTabItems(tab:int):void = set all items in the given tab to null
	//	DumpItem(item:Object):Boolean = adds the given item to the first available slot in the first possible tab without overwriting existing items
	//	GetItemAt(slot:int, tab:int = 0):Object = returns the item at the specified slot and tab, leaving the item in the Inventory
	//	GetNumTabs():int = return the number of tabs in this inventory
	//	GetTabContentType(tab:int):int = returns the content type of the given tab
	//	GetTabMaxSize(tab:int):int = returns the max size of the given tab if it exists; otherwise 0
	//	GetTabName(tab:int):String = returns the given tab name if it exists; otherwise ""
	//	GetTabNumItems(tab:int):int = returns the number of non-null items in the given tab
	//	IsObjectCorrectTypeForTab(object:Object, tab:int):Boolean = returns true if the given object could be put in the given tab
	//	IsValidSlot(slot:int, tab:int):Boolean = returns true if the slot number exists for the given tab number in this Inventory
	//	IsValidTab(tab:int):Boolean = returns true if the tab number given exists in this Inventory
	//	PopItemAt(slot:int, tab:int = 0):Object = returns the item at the given slot and tab, removing it from the Inventory
	//
	//-----------------------
	
	public class Inventory
	{
		// Constants //
		
		//- Constants -//
		
		
		// Public Properties //
		
		public function get contents():Array
		{
			return _contents;
		}
		
		public function set contents(value:Array):void
		{
			_contents = value;
		}
		
		public function get displayName():String
		{
			return _displayName;
		}
		
		public function set displayName(value:String):void
		{
			_displayName = value;
		}
		
		public function get maxSize():int
		{
			return _maxSize;
		}
		
		public function set maxSize(value:int):void
		{
			_maxSize = value;
		}
		
		public function get typesAllowed():Array
		{
			return _typesAllowed;
		}
		
		public function set typesAllowed(value:Array):void
		{
			_typesAllowed = value;
		}
		
		public function get volatile():Boolean
		{
			return _volatile;
		}
		
		public function set volatile(value:Boolean):void
		{
			_volatile = value;
		}
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		private var _contents:Array;
		private var _displayName:String;
		private var _maxSize:int;
		private var _typesAllowed:Array;
		private var _volatile:Boolean;
		
		//- Private Properties -//
		
		
		// Initialization //
		
		public function Inventory(maxSize:int = 0, displayName:String = "", typesAllowed:Array = null, contents:Array = null, volatile:Boolean = false)
		{
			_maxSize = maxSize;
			_displayName = displayName;
			
			_typesAllowed = typesAllowed;
			if (_typesAllowed == null)
			{
				_typesAllowed = new Array();
			}
			
			_contents = contents;
			if (_contents == null)
			{
				_contents = new Array();
			}
			
			_volatile = volatile;
		}
		
		//- Initialization -//
		
	
		// Public Methods //
		
		// adds the given item to the first open spot if possible; returns true if the item could be added
		public function AddItem(item:Object):Boolean
		{
			if (item == null)
			{
				return true;
			}
			
			var bItemAdded:Boolean = false;
			
			for (var slot:int = 0; slot < _maxSize; slot++)
			{
				bItemAdded = AddItemAt(item, slot);
				
				if (bItemAdded == true)
				{
					break;
				}
			}
			
			return bItemAdded;
		}
		
		// adds the given item to the given slot if possible without overwriting existing items; returns true if the item could be added
		public function AddItemAt(item:Object, slot:int):Boolean
		{
			if (IsValidSlot(slot) == false)
			{
				return false;
			}
			
			if (item == null)
			{
				return true;
			}
			
			if (IsObjectCorrectType(item) == false)
			{
				return false;
			}
			
			if (_contents[slot] != null)
			{
				return false;
			}
			
			_contents[slot] = item;
			
			if (_volatile == true && item is IVolatile)
			{
				var oVolatile:IVolatile = IVolatile(item);
				oVolatile.Disturb();
			}
			
			return true;
		}
		
		// returns true if the item can be added to the Inventory
		public function CanAddItem(item:Object):Boolean
		{
			if (item == null)
			{
				return true;
			}
			
			var bCanAddItem:Boolean = false;
			
			for (var slot:int = 0; slot < _maxSize; slot++)
			{
				bCanAddItem = CanAddItemAt(item, slot);
				
				if (bCanAddItem == true)
				{
					break;
				}
			}
			
			return bCanAddItem;
		}
		
		// returns true if the item can be added to the Inventory at the given slot
		public function CanAddItemAt(item:Object, slot:int):Boolean
		{
			if (IsValidSlot(slot) == false)
			{
				return false;
			}
			
			if (item == null)
			{
				return true;
			}
			
			if (IsObjectCorrectType(item) == false)
			{
				return false;
			}
			
			if (_contents[slot] != null)
			{
				return false;
			}
			
			return true;
		}
		
		// set all items in the Inventory to null
		public function ClearAllItems():void
		{
			for (var slot:int = 0; slot < _maxSize; slot++)
			{
				_contents[slot] = null;
			}
		}
		
		// TODO: Do we use this?  Do we need this?  How does it really need to work if so?
		/*
		// returns the InventoryLocation of the <instanceNumber> instance of the Item object specified by the itemCategory and itemType, if it exists; otherwise returns null
		// example:  FindItem(Item.SUBCAT_SEED, Seed.TYPE_POTATO, 3) will return the 4th potato seed object found across all tabs of the Inventory, if it exists.
		public function FindItem(itemCategory:int, itemType:int, instanceNumber:int = 0):InventoryLocation
		{
			if (Item.IsConcreteItemCategory(itemCategory) == false)
			{
				return null;
			}
			
			var oLocation:InventoryLocation = null;
			var iInstanceNumberFound:int = -1;
			
			for (var tab:int = 0; tab < _tabs.length; tab++)
			{
				var oTab:InventoryTab = InventoryTab(_tabs[tab]);
				
				// if this tab doesn't hold items, skip it
				if (oTab.contentType != Inventory.CONTENT_TYPE_ITEM)
				{
					continue;
				}
				
				// if this tab can't hold our itemCategory, skip it
				if (oTab.CanContainItemCategory(itemCategory) == false)
				{
					continue;
				}
				
				// search this tab for instances of our item type
				for (var slot:int = 0; slot < oTab.maxSize; slot++)
				{
					var oObject:Object = _tabs[tab].contents[slot];
					
					if (!(oObject is IItem))
					{
						continue;
					}
					
					var oItem:IItem = IItem(oObject);
					
					if (oItem == null)
					{
						continue;
					}
					
					switch (itemCategory)
					{
						case Item.SUBCAT_FRUIT:
							if (oItem is Fruit && oItem.type == itemType)
							{
								iInstanceNumberFound++;
							}
							break;
						case Item.SUBCAT_SEED:
							if (oItem is Seed && oItem.type == itemType)
							{
								iInstanceNumberFound++;
							}
							break;
						case Item.SUBCAT_TOOL:
							if (oItem is Tool && oItem.type == itemType)
							{
								iInstanceNumberFound++;
							}
							break;
						case Item.SUBCAT_BAG_FERTILIZER:
							if (oItem is BagFertilizer && oItem.type == itemType)
							{
								iInstanceNumberFound++;
							}
							break;
						case Item.SUBCAT_PLANT:
							if (oItem is Plant && oItem.type == itemType)
							{
								iInstanceNumberFound++;
							}
							break;
						case Item.SUBCAT_ITEMBLDG:
							if (oItem is ItemBldg && oItem.type == itemType)
							{
								iInstanceNumberFound++;
							}
							break;
						case Item.SUBCAT_PLANT_SCRAP:
							if (oItem is PlantScrap)
							{
								iInstanceNumberFound++;
							}
							break;
						case Item.SUBCAT_COMPOST:
							if (oItem is Compost)
							{
								iInstanceNumberFound++;
							}
							break;
						default:
							break;
					}
					
					if (iInstanceNumberFound == instanceNumber)
					{
						oLocation = new InventoryLocation(slot, tab);
						break;
					}
				}
				
				if (oLocation != null)
				{
					break;
				}
			}
			
			return oLocation;
		}
		*/
		
		// returns the item at the specified slot, leaving the item in the Inventory
		public function GetItemAt(slot:int):Object
		{
			if (IsValidSlot(slot) == false)
			{
				return null;
			}
			
			return _contents[slot];
		}
		
		// returns the number of non-null items in the Inventory
		public function GetNumItems():int
		{
			var iNumItems:int = 0;
			
			for (var slot:int = 0; slot < _maxSize; slot++)
			{
				if (_contents[slot] != null)
				{
					iNumItems++;
				}
			}
			
			return iNumItems;
		}
		
		// returns true if the given object could be put in the Inventory
		public function IsObjectCorrectType(object:Object):Boolean
		{
			// null can go into anything
			if (object == null)
			{
				return true;
			}
			
			// if no types are allowed, nothing can go in
			if (_typesAllowed == null)
			{
				return false;
			}
			
			// make sure the object is of a type allowed in this Inventory
			var bTypeAllowed:Boolean = false;
			var sClassName:String = getQualifiedClassName(object);
			
			for (var i:int = 0; i < _typesAllowed.length; i++)
			{
				if (!(_typesAllowed[i] is String))
				{
					continue;
				}
				
				var sAllowedClass:String = String(_typesAllowed[i]);
				
				if (sAllowedClass == sClassName)
				{
					bTypeAllowed = true;
					break;
				}
			}
			
			return bTypeAllowed;
		}
		
		// returns true if the slot number exists in this Inventory
		public function IsValidSlot(slot:int):Boolean
		{
			if (slot < 0 || slot >= _maxSize)
			{
				return false;
			}
			
			return true;
		}
		
		// returns the item at the given slot, removing it from the Inventory
		public function PopItemAt(slot:int):Object
		{
			if (IsValidSlot(slot) == false)
			{
				return null;
			}
			
			var oReturn:Object = _contents[slot];
			_contents[slot] = null;
			
			return oReturn;
		}
		
		//- Public Methods -//
		
		
		// Testing Methods //
		
		public static function RunTests():Array
		{
			var lResults:Array = new Array();
			
			lResults.push(Inventory.IsValidSlotFalseForNegativeSlotNumber());
			lResults.push(Inventory.IsValidSlotFalseForTooLargeSlotNumber());
			lResults.push(Inventory.IsValidSlotTrueForValidSlotNumber());
			
			lResults.push(Inventory.IsObjectCorrectTypeTrueForNull());
			lResults.push(Inventory.IsObjectCorrectTypeFalseIfNoTypesAllowed());
			lResults.push(Inventory.IsObjectCorrectTypeFalse());
			lResults.push(Inventory.IsObjectCorrectTypeTrue());
			
			lResults.push(Inventory.AddItemAtFalseForBadSlotNumber());
			lResults.push(Inventory.AddItemAtTrueForNull());
			lResults.push(Inventory.AddItemAtFalseForIncorrectItemType());
			lResults.push(Inventory.AddItemAtFalseIfSlotOccupied());
			lResults.push(Inventory.AddItemAtTrueIfSlotOpen());
			lResults.push(Inventory.AddItemAtAddsItemIfSlotOpen());
			
			lResults.push(Inventory.AddItemTrueForNull());
			lResults.push(Inventory.AddItemFalseIfWrongItemCategory());
			lResults.push(Inventory.AddItemFalseIfAllSlotsOccupied());
			lResults.push(Inventory.AddItemTrueIfSlotOpen());
			lResults.push(Inventory.AddItemAddsItemIfSlotOpen());
			
			lResults.push(Inventory.GetItemAtNullForBadSlotNumber());
			lResults.push(Inventory.GetItemAtReturnsObject());
			lResults.push(Inventory.GetItemAtKeepsItemInInventory());
			
			lResults.push(Inventory.PopItemAtNullForBadSlotNumber());
			lResults.push(Inventory.PopItemAtReturnsObject());
			lResults.push(Inventory.PopItemAtRemovesItemFromInventory());
			
			/*
			lResults.push(Inventory.FindItemReturnsNullForBadItemCategory());
			lResults.push(Inventory.FindItemReturnsNullForAllNonItemTabs());
			lResults.push(Inventory.FindItemReturnsNullForNoTabsOfSameCategory());
			lResults.push(Inventory.FindItemReturnsNullIfItemNotFound());
			lResults.push(Inventory.FindItemReturnsNullIfNotEnoughItemInstancesFound());
			lResults.push(Inventory.FindItemReturnsItemLocationIfEnoughInstancesFound());
			*/
			
			lResults.push(Inventory.CanAddItemAtFalseForBadSlotNumber());
			lResults.push(Inventory.CanAddItemAtTrueForNull());
			lResults.push(Inventory.CanAddItemAtFalseForIncorrectItemType());
			lResults.push(Inventory.CanAddItemAtFalseIfSlotOccupied());
			lResults.push(Inventory.CanAddItemAtTrueIfSlotOpen());
			
			lResults.push(Inventory.CanAddItemTrueForNull());
			lResults.push(Inventory.CanAddItemFalseIfWrongItemCategory());
			lResults.push(Inventory.CanAddItemFalseIfAllSlotsOccupied());
			lResults.push(Inventory.CanAddItemTrueIfSlotOpen());
			
			lResults = lResults.concat(Inventory.TestClearAllItems());
			
			lResults.push(Inventory.TestGetNumItems());
			
			return lResults;
		}
		
		public static function IsValidSlotFalseForNegativeSlotNumber():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Inventory", "IsValidSlotFalseForNegativeSlotNumber");
			
			var oInventory:Inventory = new Inventory(3);
			
			oResult.expected = "false";
			oResult.actual = String(oInventory.IsValidSlot(-1));
			oResult.TestEquals();
			
			return oResult;
		}
		
		public static function IsValidSlotFalseForTooLargeSlotNumber():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Inventory", "IsValidSlotFalseForTooLargeSlotNumber");
			
			var oInventory:Inventory = new Inventory(3);
			
			oResult.expected = "false";
			oResult.actual = String(oInventory.IsValidSlot(3));
			oResult.TestEquals();
			
			return oResult;
		}
		
		public static function IsValidSlotTrueForValidSlotNumber():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Inventory", "IsValidSlotTrueForValidSlotNumber");
			
			var oInventory:Inventory = new Inventory(3);
			
			oResult.expected = "true";
			oResult.actual = String(oInventory.IsValidSlot(2));
			oResult.TestEquals();
			
			return oResult;
		}
		
		public static function IsObjectCorrectTypeTrueForNull():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Inventory", "IsObjectCorrectTypeTrueForNull");
			
			var oInventory:Inventory = new Inventory(3);
			
			oResult.expected = "true";
			oResult.actual = String(oInventory.IsObjectCorrectType(null));
			oResult.TestEquals();
			
			return oResult;
		}
		
		public static function IsObjectCorrectTypeFalseIfNoTypesAllowed():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Inventory", "IsObjectCorrectTypeFalseIfNoTypesAllowed");
			
			var oInventory:Inventory = new Inventory(3);
			
			oResult.expected = "false";
			oResult.actual = String(oInventory.IsObjectCorrectType(new Seed(Seed.TYPE_ASPARAGUS)));
			oResult.TestEquals();
			
			return oResult;
		}
		
		public static function IsObjectCorrectTypeFalse():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Inventory", "IsObjectCorrectTypeFalse");
			
			var oInventory:Inventory = new Inventory(3, "Stuff", [ "Fertilizer" ]);
			
			oResult.expected = "false";
			oResult.actual = String(oInventory.IsObjectCorrectType(new Seed(Seed.TYPE_ASPARAGUS)));
			oResult.TestEquals();
			
			return oResult;
		}
		
		public static function IsObjectCorrectTypeTrue():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Inventory", "IsObjectCorrectTypeTrue");
			
			var oInventory:Inventory = new Inventory(3, "Stuff", [ "Seed" ]);
			
			oResult.expected = "true";
			oResult.actual = String(oInventory.IsObjectCorrectType(new Seed(Seed.TYPE_ASPARAGUS)));
			oResult.TestEquals();
			
			return oResult;
		}
		
		public static function AddItemAtFalseForBadSlotNumber():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Inventory", "AddItemAtFalseForBadSlotNumber");
			
			var oInventory:Inventory = new Inventory(3);
			
			oResult.expected = "false";
			oResult.actual = String(oInventory.AddItemAt(null, 3));
			oResult.TestEquals();
			
			return oResult;
		}
		
		public static function AddItemAtTrueForNull():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Inventory", "AddItemAtTrueForNull");

			var oInventory:Inventory = new Inventory(3);
			
			oResult.expected = "true";
			oResult.actual = String(oInventory.AddItemAt(null, 0));
			oResult.TestEquals();
			
			return oResult;
		}
		
		public static function AddItemAtFalseForIncorrectItemType():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Inventory", "AddItemAtFalseForIncorrectItemType");
			
			var oInventory:Inventory = new Inventory(3, "Stuff", [ "Fertilizer" ]);
			var oItem:Seed = new Seed(Seed.TYPE_POTATO);
			
			oResult.expected = "false";
			oResult.actual = String(oInventory.AddItemAt(oItem, 0));
			oResult.TestEquals();
			
			return oResult;
		}
		
		public static function AddItemAtFalseIfSlotOccupied():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Inventory", "AddItemAtFalseIfSlotOccupied");

			var oInventory:Inventory = new Inventory(3, "Stuff", [ "Seed" ], [ null, new Seed(Seed.TYPE_CLOVER), null ]);
			var oItem:Seed = new Seed(Seed.TYPE_POTATO);
			
			oResult.expected = "false";
			oResult.actual = String(oInventory.AddItemAt(oItem, 1));
			oResult.TestEquals();
			
			return oResult;
		}
		
		public static function AddItemAtTrueIfSlotOpen():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Inventory", "AddItemAtTrueIfSlotOpen");

			var oInventory:Inventory = new Inventory(3, "Stuff", [ "Seed" ], [ null, new Seed(Seed.TYPE_CLOVER), null ]);
			var oItem:Seed = new Seed(Seed.TYPE_POTATO);
			
			oResult.expected = "true";
			oResult.actual = String(oInventory.AddItemAt(oItem, 2));
			oResult.TestEquals();
			
			return oResult;
		}
		
		public static function AddItemAtAddsItemIfSlotOpen():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Inventory", "AddItemAtAddsItemIfSlotOpen");
			
			var oInventory:Inventory = new Inventory(3, "Stuff", [ "Seed" ], [ null, new Seed(Seed.TYPE_CLOVER), null ]);
			var oItem:Seed = new Seed(Seed.TYPE_POTATO);
			
			var iSlot:int = 2;
			oInventory.AddItemAt(oItem, iSlot);
			oResult.TestNotNull(oInventory.contents[iSlot]);
			
			return oResult;
		}
		
		public static function AddItemTrueForNull():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Inventory", "AddItemTrueForNull");
			
			var oInventory:Inventory = new Inventory(3);
			
			oResult.expected = "true";
			oResult.actual = String(oInventory.AddItem(null));
			oResult.TestEquals();
			
			return oResult;
		}
		
		public static function AddItemFalseIfWrongItemCategory():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Inventory", "AddItemFalseIfWrongItemCategory");
			
			var oInventory:Inventory = new Inventory(3, "Stuff", [ "Seed" ]);
			var oItem:Tool = new Tool(Tool.TYPE_HOE);
			
			oResult.expected = "false";
			oResult.actual = String(oInventory.AddItem(oItem));
			oResult.TestEquals();
			
			return oResult;
		}
		
		public static function AddItemFalseIfAllSlotsOccupied():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Inventory", "AddItemFalseIfAllSlotsOccupied");

			var oInventory:Inventory = new Inventory(3, "Stuff", [ "Seed" ], [ new Seed(Seed.TYPE_CLOVER), new Seed(Seed.TYPE_CLOVER), new Seed(Seed.TYPE_CLOVER) ]);
			var oItem:Seed = new Seed(Seed.TYPE_POTATO);
			
			oResult.expected = "false";
			oResult.actual = String(oInventory.AddItem(oItem));
			oResult.TestEquals();
			
			return oResult;
		}
		
		public static function AddItemTrueIfSlotOpen():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Inventory", "AddItemTrueIfSlotOpen");
			
			var oInventory:Inventory = new Inventory(3, "Stuff", [ "Seed" ], [ new Seed(Seed.TYPE_CLOVER), new Seed(Seed.TYPE_CLOVER), null ]);
			var oItem:Seed = new Seed(Seed.TYPE_POTATO);
			
			oResult.expected = "true";
			oResult.actual = String(oInventory.AddItem(oItem));
			oResult.TestEquals();
			
			return oResult;
		}
		
		public static function AddItemAddsItemIfSlotOpen():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Inventory", "AddItemAddsItemIfSlotOpen");
			
			var oInventory:Inventory = new Inventory(3, "Stuff", [ "Seed" ], [ new Seed(Seed.TYPE_CLOVER), new Seed(Seed.TYPE_CLOVER), null ]);
			var oItem:Seed = new Seed(Seed.TYPE_POTATO);
			
			oInventory.AddItem(oItem);
			oResult.TestNotNull(oInventory.contents[2]);
			
			return oResult;
		}
		
		public static function GetItemAtNullForBadSlotNumber():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Inventory", "GetItemAtNullForBadSlotNumber");

			var oInventory:Inventory = new Inventory(3);
			
			var oReturn:Object = oInventory.GetItemAt(3);
			oResult.TestNull(oReturn);
			
			return oResult;
		}
		
		public static function GetItemAtReturnsObject():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Inventory", "GetItemAtReturnsObject");

			var oInventory:Inventory = new Inventory(3, "Stuff" , [ "Seed" ], [ null, new Seed(Seed.TYPE_CLOVER), null ]);
			
			var oReturn:Object = oInventory.GetItemAt(1);
			oResult.TestNotNull(oReturn);
			
			return oResult;
		}
		
		public static function GetItemAtKeepsItemInInventory():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Inventory", "GetItemAtKeepsItemInInventory");
			
			var oInventory:Inventory = new Inventory(3, "Stuff" , [ "Seed" ], [ null, new Seed(Seed.TYPE_CLOVER), null ]);
			
			var oReturn:Object = oInventory.GetItemAt(1);
			oResult.TestNotNull(oInventory.contents[1]);
			
			return oResult;
		}
		
		public static function PopItemAtNullForBadSlotNumber():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Inventory", "PopItemAtNullForBadSlotNumber");
			
			var oInventory:Inventory = new Inventory(3);
			
			var oReturn:Object = oInventory.PopItemAt(3);
			oResult.TestNull(oReturn);
			
			return oResult;
		}
		
		public static function PopItemAtReturnsObject():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Inventory", "PopItemAtReturnsObject");
			
			var oInventory:Inventory = new Inventory(3, "Stuff", [ "Seed" ], [ null, new Seed(Seed.TYPE_CLOVER), null ]);
			
			var oReturn:Object = oInventory.PopItemAt(1);
			oResult.TestNotNull(oReturn);
			
			return oResult;
		}
		
		public static function PopItemAtRemovesItemFromInventory():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Inventory", "PopItemAtRemovesItemFromInventory");
			
			var oInventory:Inventory = new Inventory(3, "Stuff", [ "Seed" ], [ null, new Seed(Seed.TYPE_CLOVER), null ]);
			
			var oReturn:Object = oInventory.PopItemAt(1);
			oResult.TestNull(oInventory.contents[1]);
			
			return oResult;
		}
		
		/*
		public static function FindItemReturnsNullForBadItemCategory():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Inventory", "FindItemReturnsNullForBadItemCategory");
			var oTab:InventoryTab = new InventoryTab("Tab0", 3, Inventory.CONTENT_TYPE_ITEM, [ Item.SUBCAT_SEED ],
													 [ new Seed(Seed.TYPE_CLOVER), new Seed(Seed.TYPE_CLOVER), null ]);
			var oInventory:Inventory = new Inventory([ oTab ]);
			
			var oReturn:Object = oInventory.FindItem(Item.SUBCAT_ALL, Seed.TYPE_POTATO, 0);
			oResult.TestNull(oReturn);
			
			return oResult;
		}
		
		public static function FindItemReturnsNullForAllNonItemTabs():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Inventory", "FindItemReturnsNullForAllNonItemTabs");
			var oTab0:InventoryTab = new InventoryTab("Tab0", 3, Inventory.CONTENT_TYPE_ACTIONBTN, new Array(), new Array());
			var oTab1:InventoryTab = new InventoryTab("Tab1", 3, Inventory.CONTENT_TYPE_ACTIONBTN, new Array(), new Array());
			var oInventory:Inventory = new Inventory([ oTab0, oTab1 ]);
			
			var oReturn:Object = oInventory.FindItem(Item.SUBCAT_ALL, Seed.TYPE_POTATO, 0);
			oResult.TestNull(oReturn);
			
			return oResult;
		}
		
		public static function FindItemReturnsNullForNoTabsOfSameCategory():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Inventory", "FindItemReturnsNullForNoTabsOfSameCategory");
			var oTab0:InventoryTab = new InventoryTab("Tab0", 3, Inventory.CONTENT_TYPE_ITEM, [ Item.SUBCAT_TOOL ],
													 [ new Tool(Tool.TYPE_HOE), new Tool(Tool.TYPE_SICKLE), null ]);
			var oTab1:InventoryTab = new InventoryTab("Tab1", 3, Inventory.CONTENT_TYPE_ITEM, [ Item.SUBCAT_SEED ],
													 [ new Seed(Seed.TYPE_CLOVER), new Seed(Seed.TYPE_CLOVER), null ]);
			var oInventory:Inventory = new Inventory([ oTab0, oTab1 ]);
			
			var oReturn:Object = oInventory.FindItem(Item.SUBCAT_BAG_FERTILIZER, BagFertilizer.TYPE_STEADY_GREEN, 0);
			oResult.TestNull(oReturn);
			
			return oResult;
		}
		
		public static function FindItemReturnsNullIfItemNotFound():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Inventory", "FindItemReturnsNullIfItemNotFound");
			var oTab0:InventoryTab = new InventoryTab("Tab0", 3, Inventory.CONTENT_TYPE_ITEM, [ Item.SUBCAT_TOOL ],
													 [ new Tool(Tool.TYPE_HOE), new Tool(Tool.TYPE_SICKLE), null ]);
			var oTab1:InventoryTab = new InventoryTab("Tab1", 3, Inventory.CONTENT_TYPE_ITEM, [ Item.SUBCAT_SEED ],
													 [ new Seed(Seed.TYPE_CLOVER), new Seed(Seed.TYPE_CLOVER), null ]);
			var oInventory:Inventory = new Inventory([ oTab0, oTab1 ]);
			
			var oReturn:Object = oInventory.FindItem(Item.SUBCAT_SEED, Seed.TYPE_POTATO, 0);
			oResult.TestNull(oReturn);
			
			return oResult;
		}
		
		public static function FindItemReturnsNullIfNotEnoughItemInstancesFound():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Inventory", "FindItemReturnsNullIfNotEnoughItemInstancesFound");
			var oTab0:InventoryTab = new InventoryTab("Tab0", 3, Inventory.CONTENT_TYPE_ITEM, [ Item.SUBCAT_TOOL ],
													 [ new Tool(Tool.TYPE_HOE), new Tool(Tool.TYPE_SICKLE), null ]);
			var oTab1:InventoryTab = new InventoryTab("Tab1", 3, Inventory.CONTENT_TYPE_ITEM, [ Item.SUBCAT_SEED ],
													 [ new Seed(Seed.TYPE_CLOVER), new Seed(Seed.TYPE_CLOVER), null ]);
			var oInventory:Inventory = new Inventory([ oTab0, oTab1 ]);
			
			var oReturn:Object = oInventory.FindItem(Item.SUBCAT_SEED, Seed.TYPE_CLOVER, 2);
			oResult.TestNull(oReturn);
			
			return oResult;
		}
		
		public static function FindItemReturnsItemLocationIfEnoughInstancesFound():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Inventory", "FindItemReturnsItemLocationIfEnoughInstancesFound");
			var oTab0:InventoryTab = new InventoryTab("Tab0", 3, Inventory.CONTENT_TYPE_ITEM, [ Item.SUBCAT_TOOL ],
													 [ new Tool(Tool.TYPE_HOE), new Tool(Tool.TYPE_SICKLE), null ]);
			var oTab1:InventoryTab = new InventoryTab("Tab1", 3, Inventory.CONTENT_TYPE_ITEM, [ Item.SUBCAT_SEED ],
													 [ new Seed(Seed.TYPE_CLOVER), new Seed(Seed.TYPE_CLOVER), null ]);
			var oInventory:Inventory = new Inventory([ oTab0, oTab1 ]);
			
			var oExpectedLocation:InventoryLocation = new InventoryLocation(1, 1);
			var oReturn:InventoryLocation = oInventory.FindItem(Item.SUBCAT_SEED, Seed.TYPE_CLOVER, 1);
			
			oResult.expected = oExpectedLocation.PrettyPrint();
			oResult.actual = oReturn.PrettyPrint();
			oResult.TestEquals();
			
			return oResult;
		}
		*/
		
		public static function CanAddItemAtFalseForBadSlotNumber():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Inventory", "CanAddItemAtFalseForBadSlotNumber");
			
			var oInventory:Inventory = new Inventory(3);
			
			oResult.expected = "false";
			oResult.actual = String(oInventory.CanAddItemAt(null, 3));
			oResult.TestEquals();
			
			return oResult;
		}
		
		public static function CanAddItemAtTrueForNull():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Inventory", "CanAddItemAtTrueForNull");
			
			var oInventory:Inventory = new Inventory(3);
			
			oResult.expected = "true";
			oResult.actual = String(oInventory.CanAddItemAt(null, 0));
			oResult.TestEquals();
			
			return oResult;
		}
		
		public static function CanAddItemAtFalseForIncorrectItemType():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Inventory", "CanAddItemAtFalseForIncorrectItemType");
			
			var oInventory:Inventory = new Inventory(3, "Stuff", [ "Seed" ]);
			var oItem:Tool = new Tool(Tool.TYPE_HOE);
			
			oResult.expected = "false";
			oResult.actual = String(oInventory.CanAddItemAt(oItem, 2));
			oResult.TestEquals();
			
			return oResult;
		}
		
		public static function CanAddItemAtFalseIfSlotOccupied():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Inventory", "CanAddItemAtFalseIfSlotOccupied");
			
			var oInventory:Inventory = new Inventory(3, "Stuff", [ "Seed" ], [ null, new Seed(Seed.TYPE_CLOVER), null ]);
			var oItem:Seed = new Seed(Seed.TYPE_POTATO);
			
			oResult.expected = "false";
			oResult.actual = String(oInventory.CanAddItemAt(oItem, 1));
			oResult.TestEquals();
			
			return oResult;
		}
		
		public static function CanAddItemAtTrueIfSlotOpen():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Inventory", "CanAddItemAtTrueIfSlotOpen");
			
			var oInventory:Inventory = new Inventory(3, "Stuff", [ "Seed" ], [ null, new Seed(Seed.TYPE_CLOVER), null ]);
			var oItem:Seed = new Seed(Seed.TYPE_POTATO);
			
			oResult.expected = "true";
			oResult.actual = String(oInventory.CanAddItemAt(oItem, 2));
			oResult.TestEquals();
			
			return oResult;
		}
		
		public static function CanAddItemTrueForNull():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Inventory", "CanAddItemTrueForNull");
			
			var oInventory:Inventory = new Inventory(3);
			
			oResult.expected = "true";
			oResult.actual = String(oInventory.CanAddItem(null));
			oResult.TestEquals();
			
			return oResult;
		}
		
		public static function CanAddItemFalseIfWrongItemCategory():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Inventory", "CanAddItemFalseIfWrongItemCategory");

			var oInventory:Inventory = new Inventory(3, "Stuff", [ "Seed" ]);
			var oItem:Tool = new Tool(Tool.TYPE_HOE);
			
			oResult.expected = "false";
			oResult.actual = String(oInventory.CanAddItem(oItem));
			oResult.TestEquals();
			
			return oResult;
		}
		
		public static function CanAddItemFalseIfAllSlotsOccupied():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Inventory", "CanAddItemFalseIfAllSlotsOccupied");
			
			var oInventory:Inventory = new Inventory(3, "Stuff", [ "Seed" ], [ new Seed(Seed.TYPE_CLOVER), new Seed(Seed.TYPE_CLOVER), new Seed(Seed.TYPE_CLOVER) ]);
			var oItem:Seed = new Seed(Seed.TYPE_POTATO);
			
			oResult.expected = "false";
			oResult.actual = String(oInventory.CanAddItem(oItem));
			oResult.TestEquals();
			
			return oResult;
		}
		
		public static function CanAddItemTrueIfSlotOpen():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Inventory", "CanAddItemTrueIfSlotOpen");
			
			var oInventory:Inventory = new Inventory(3, "Stuff", [ "Seed" ], [ new Seed(Seed.TYPE_CLOVER), new Seed(Seed.TYPE_CLOVER), null ]);
			var oItem:Seed = new Seed(Seed.TYPE_POTATO);
			
			oResult.expected = "true";
			oResult.actual = String(oInventory.CanAddItem(oItem));
			oResult.TestEquals();
			
			return oResult;
		}
		
		public static function TestClearAllItems():Array
		{
			var oResult0:UnitTestResult = new UnitTestResult("Inventory", "TestClearAllItemsSlot0");
			var oResult1:UnitTestResult = new UnitTestResult("Inventory", "TestClearAllItemsSlot1");
			var oResult2:UnitTestResult = new UnitTestResult("Inventory", "TestClearAllItemsSlot2");
			
			var lResults:Array = [ oResult0, oResult1, oResult2 ];
			
			var oInventory:Inventory = new Inventory(3, "Stuff", [ "Seed" ], [ new Seed(Seed.TYPE_CLOVER), new Seed(Seed.TYPE_CLOVER), new Seed(Seed.TYPE_CLOVER) ]);
			
			oInventory.ClearAllItems();
			
			oResult0.TestNull(oInventory.contents[0]);
			oResult1.TestNull(oInventory.contents[1]);
			oResult2.TestNull(oInventory.contents[2]);
			
			return lResults;
		}
		
		public static function TestGetNumItems():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Inventory", "TestGetNumItems");
			
			var oInventory:Inventory = new Inventory(3, "Stuff", [ "Seed" ], [ null, new Seed(Seed.TYPE_CLOVER), null ]);
			
			oResult.expected = "1";
			oResult.actual = String(oInventory.GetNumItems());
			oResult.TestEquals();
			
			return oResult;
		}
		
		/* Test Template
		public static function ():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Inventory", "");
			
			return oResult;
		}
		*/
		
		//- Testing Methods -//
	}
}