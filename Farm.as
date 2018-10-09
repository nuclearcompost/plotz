package
{
	//-----------------------
	//Purpose:				A single farm in the world with a specific player owner
	//
	//Public Properties:
	//	
	//Public Methods:
	//	
	//-----------------------
	public class Farm extends GridArea
	{
		// Constants //
		
		//- Constants -//
		
		
		// Public Properties //
		
		public function get fence():Array
		{
			return _fence;
		}
		
		public function set fence(value:Array):void
		{
			_fence = value;
		}
		
		public function get house():House
		{
			return _house;
		}
		
		public function set house(value:House):void
		{
			_house = value;
		}
		
		public function get itemBldgs():Array
		{
			return _itemBldgs;
		}
		
		public function set itemBldgs(value:Array):void
		{
			_itemBldgs;
		}
		
		public function get mailbox():Mailbox
		{
			return _mailbox;
		}
		
		public function set mailbox(value:Mailbox):void
		{
			_mailbox = value;
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function set name(value:String):void
		{
			_name = value;
		}
		
		public function get owner():Player
		{
			return _owner;
		}
		
		public function set owner(value:Player):void
		{
			_owner = value;
		}
		
		public function get rootCellar():RootCellar
		{
			return _rootCellar;
		}
		
		public function set rootCellar(value:RootCellar):void
		{
			_rootCellar = value;
		}
		
		public function get saleCart():SaleCart
		{
			return _saleCart;
		}
		
		public function set saleCart(value:SaleCart):void
		{
			_saleCart = value;
		}
		
		public function get toolShed():ToolShed
		{
			return _toolShed;
		}
		
		public function set toolShed(value:ToolShed):void
		{
			_toolShed = value;
		}
		
		public function get well():Well
		{
			return _well;
		}
		
		public function set well(value:Well):void
		{
			_well = value;
		}
		
		public function get world():World
		{
			return _world;
		}
		
		public function set world(value:World):void
		{
			_world = value;
		}
		
		//- Public Properties -//
		
		
		// Private Properties //
		
		private var _fence:Array;
		private var _house:House;
		private var _itemBldgs:Array;
		private var _mailbox:Mailbox;
		private var _name:String;
		private var _owner:Player;
		private var _rootCellar:RootCellar;
		private var _saleCart:SaleCart;
		private var _toolShed:ToolShed;
		private var _well:Well;
		private var _world:World;
		
		//- Private Properties -//
		
	
		// Initialization //
		
		//---------------
		//Purpose:		
		//Parameters:
		//	
		//Returns:		
		//---------------
		public function Farm(name:String = "", owner:Player = null, world:World = null, top:int = 0, bottom:int = 0, left:int = 0, right:int = 0, house:House = null,
							 mailbox:Mailbox = null, toolShed:ToolShed = null, well:Well = null, saleCart:SaleCart = null, rootCellar:RootCellar = null, itemBldgs:Array = null)
		{
			super(top, bottom, left, right);
			
			_name = name;
			_owner = owner;
			_world = world;
			_owner = owner;
			_house = house;
			_mailbox = mailbox;
			_toolShed = toolShed;
			_well = well;			
			_saleCart = saleCart;
			_rootCellar = rootCellar;
			_itemBldgs = itemBldgs;
			
			if (_itemBldgs == null)
			{
				_itemBldgs = new Array();
			}
			
			_fence = new Array();
			
			AddFenceToFarm();
		}
	
		private function AddFenceToFarm():void
		{
			var oFence:Fence = new Fence(new GridLocation(this.left, this.top), this, true, false, true);
			_fence.push(oFence);
			
			oFence = new Fence(new GridLocation(this.right, this.top), this, true, false, false, true);
			_fence.push(oFence);
			
			oFence = new Fence(new GridLocation(this.left, this.bottom), this, false, true, true);
			_fence.push(oFence);
			
			oFence = new Fence(new GridLocation(this.right, this.bottom), this, false, true, false, true);
			_fence.push(oFence);
			
			for (var i:int = this.left + 1; i < this.right; i++)
			{
				oFence = new Fence(new GridLocation(i, this.top), this, true);
				_fence.push(oFence);
				
				if (i < (this.right - 3))
				{
					oFence = new Fence(new GridLocation(i, this.bottom), this, false, true);
					_fence.push(oFence);
				}
			}
			
			for (i = this.top + 1; i < this.bottom; i++)
			{
				oFence = new Fence(new GridLocation(this.left, i), this, false, false, true);
				_fence.push(oFence);
				
				oFence = new Fence(new GridLocation(this.right, i), this, false, false, false, true);
				_fence.push(oFence);
			}
			
			for (i = 0; i < _fence.length; i++)
			{
				oFence = Fence(_fence[i]);
				AddBldgToWorld(oFence);
			}
		}
	
		//- Initialization -//
		
		
		// Public Methods //
		
		public function AddBldg(bldg:Bldg):void
		{
			if (bldg is CompostBin)
			{
				_itemBldgs.push(CompostBin(bldg));
				AddBldgToWorld(CompostBin(bldg));
				return;
			}
			
			if (bldg is House)
			{
				_house = House(bldg);
				AddBldgToWorld(_house);
				return;
			}
			
			if (bldg is Mailbox)
			{
				_mailbox = Mailbox(bldg);
				AddBldgToWorld(_mailbox);
				return;
			}
			
			if (bldg is RootCellar)
			{
				_rootCellar = RootCellar(bldg);
				AddBldgToWorld(_rootCellar);
				return;
			}
			
			if (bldg is SaleCart)
			{
				_saleCart = SaleCart(bldg);
				AddBldgToWorld(_saleCart);
				return;
			}
			
			if (bldg is ToolShed)
			{
				_toolShed = ToolShed(bldg);
				AddBldgToWorld(_toolShed);
				return;
			}
			
			if (bldg is Well)
			{
				_well = Well(bldg);
				AddBldgToWorld(_well);
				return;
			}
		}
		
		public function GetBldg(type:int):Bldg
		{
			var oBldg:Bldg = null;
			
			if (type == Bldg.TYPE_FARM_HOUSE)
			{
				return _house;
			}
			
			if (type == Bldg.TYPE_FARM_MAILBOX)
			{
				return _mailbox;
			}
			
			if (type == Bldg.TYPE_FARM_ROOT_CELLAR)
			{
				return _rootCellar;
			}
			
			if (type == Bldg.TYPE_FARM_SALE_CART)
			{
				return _saleCart;
			}
			
			if (type == Bldg.TYPE_FARM_TOOLSHED)
			{
				return _toolShed;
			}
			
			if (type == Bldg.TYPE_FARM_WELL)
			{
				return _well;
			}
			
			return null;
		}
		
		//- Public Methods -//
		
		
		// Private Methods //
		
		private function AddBldgToWorld(bldg:Bldg):void
		{
			if (_world != null)
			{
				_world.AddBldg(bldg);
			}
		}
		
		//- Private Methods -//
		
		
		// Testing Methods //
		
		public static function RunTests():Array
		{
			var lResults:Array = new Array();
			
			lResults = lResults.concat(Farm.NewFarmAddsFenceToWorld());
			lResults.push(Farm.NewFarmAddsFenceToFarm());
			lResults.push(Farm.AddCompostBin());
			lResults.push(Farm.AddHouse());
			lResults.push(Farm.AddMailbox());
			lResults.push(Farm.AddRootCellar());
			lResults.push(Farm.AddSaleCart());
			lResults.push(Farm.AddToolShed());
			lResults.push(Farm.AddWell());
			lResults.push(Farm.GetHouse());
			lResults.push(Farm.GetMailbox());
			lResults.push(Farm.GetRootCellar());
			lResults.push(Farm.GetSaleCart());
			lResults.push(Farm.GetToolShed());
			lResults.push(Farm.GetWell());
			
			return lResults;
		}
		
		public static function NewFarmAddsFenceToWorld():Array
		{
			var oFence1:UnitTestResult = new UnitTestResult("Farm", "NewFarmAddsFenceToWorld - Fence 1");
			var oFence2:UnitTestResult = new UnitTestResult("Farm", "NewFarmAddsFenceToWorld - Fence 2");
			var oFence3:UnitTestResult = new UnitTestResult("Farm", "NewFarmAddsFenceToWorld - Fence 3");
			var oFence4:UnitTestResult = new UnitTestResult("Farm", "NewFarmAddsFenceToWorld - Fence 4");
			var oNoFence1:UnitTestResult = new UnitTestResult("Farm", "NewFarmAddsFenceToWorld - No Fence 1");
			var oFence5:UnitTestResult = new UnitTestResult("Farm", "NewFarmAddsFenceToWorld - Fence 5");
			var oFence6:UnitTestResult = new UnitTestResult("Farm", "NewFarmAddsFenceToWorld - Fence 6");
			var oNoFence2:UnitTestResult = new UnitTestResult("Farm", "NewFarmAddsFenceToWorld - No Fence 2");
			var oFence7:UnitTestResult = new UnitTestResult("Farm", "NewFarmAddsFenceToWorld - Fence 7");
			var lResults:Array = [ oFence1, oFence2, oFence3, oFence4, oNoFence1, oFence5, oFence6, oNoFence2, oFence7 ];
			
			return lResults;
			
			/*
			var oWorld:World = new World(7, 7);
			var iTop:int = 8;
			var iBottom:int = 10;
			var iLeft:int = 6;
			var iRight:int = 8;
			
			var oFarm:Farm = new Farm("HappyFarm", null, oWorld, iTop, iBottom, iLeft, iRight);
			
			var oTile:Tile = Tile(oWorld.tiles[iLeft][iTop]);
			oFence1.TestNotNull(oTile.bldg);
			oTile = Tile(oWorld.tiles[iLeft + 1][iTop]);
			oFence2.TestNotNull(oTile.bldg);
			oTile = Tile(oWorld.tiles[iRight][iTop]);
			oFence3.TestNotNull(oTile.bldg);
			oTile = Tile(oWorld.tiles[iLeft][iTop + 1]);
			oFence4.TestNotNull(oTile.bldg);
			oTile = Tile(oWorld.tiles[iLeft + 1][iTop + 1]);
			oNoFence1.TestNull(oTile.bldg);
			oTile = Tile(oWorld.tiles[iRight][iTop + 1]);
			oFence5.TestNotNull(oTile.bldg);
			oTile = Tile(oWorld.tiles[iLeft][iBottom]);
			oFence6.TestNotNull(oTile.bldg);
			oTile = Tile(oWorld.tiles[iLeft + 1][iBottom]);
			oNoFence2.TestNull(oTile.bldg);
			oTile = Tile(oWorld.tiles[iRight][iBottom]);
			oFence7.TestNotNull(oTile.bldg);
			
			return lResults;
			*/
		}
		
		public static function NewFarmAddsFenceToFarm():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Farm", "NewFarmAddsFenceToFarm");
			
			var oFarm:Farm = new Farm("HappyFarm", null, null, 0, 2, 0, 2);
			
			oResult.expected = "7";
			oResult.actual = String(oFarm.fence.length);
			oResult.TestEquals();
			
			return oResult;
		}
		
		public static function AddCompostBin():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Farm", "AddCompostBin");
			
			var oFarm:Farm = new Farm("HappyFarm", null, null, 0, 5, 0, 5);
			var oCompostBin:CompostBin = new CompostBin();
			oFarm.AddBldg(oCompostBin);
			
			oResult.expected = "1";
			oResult.actual = String(oFarm.itemBldgs.length);
			oResult.TestEquals();
			
			return oResult;
		}
		
		public static function AddHouse():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Farm", "AddHouse");
			
			var oFarm:Farm = new Farm("HappyFarm", null, null, 0, 5, 0, 5);
			var oHouse:House = new House(new GridLocation(5, 5), oFarm);
			oFarm.AddBldg(oHouse);
			
			oResult.TestNotNull(oFarm.house);
			
			return oResult;
		}
		
		public static function AddMailbox():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Farm", "AddMailbox");
			
			var oFarm:Farm = new Farm("HappyFarm", null, null, 0, 5, 0, 5);
			var oMailbox:Mailbox = new Mailbox(new GridLocation(5, 5), oFarm);
			oFarm.AddBldg(oMailbox);
			
			oResult.TestNotNull(oFarm.mailbox);
			
			return oResult;
		}
		
		public static function AddRootCellar():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Farm", "AddRootCellar");
			
			var oFarm:Farm = new Farm("HappyFarm", null, null, 0, 5, 0, 5);
			var oRootCellar:RootCellar = new RootCellar(null, oFarm);
			oFarm.AddBldg(oRootCellar);
			
			oResult.TestNotNull(oFarm.rootCellar);
			
			return oResult;
		}
		
		public static function AddSaleCart():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Farm", "AddSaleCart");
			
			var oFarm:Farm = new Farm("HappyFarm", null, null, 0, 5, 0, 5);
			var oSaleCart:SaleCart = new SaleCart(new GridLocation(5, 5), oFarm);
			oFarm.AddBldg(oSaleCart);
			
			oResult.TestNotNull(oFarm.saleCart);
			
			return oResult;
		}
		
		public static function AddToolShed():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Farm", "AddToolShed");
			
			var oFarm:Farm = new Farm("HappyFarm", null, null, 0, 5, 0, 5);
			var oToolShed:ToolShed = new ToolShed(new GridLocation(5, 5), oFarm);
			oFarm.AddBldg(oToolShed);
			
			oResult.TestNotNull(oFarm.toolShed);
			
			return oResult;
		}
		
		public static function AddWell():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Farm", "AddWell");
			
			var oFarm:Farm = new Farm("HappyFarm", null, null, 0, 5, 0, 5);
			var oWell:Well = new Well(new GridLocation(5, 5), oFarm);
			oFarm.AddBldg(oWell);
			
			oResult.TestNotNull(oFarm.well);
			
			return oResult;
		}
		
		public static function GetHouse():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Farm", "GetHouse");
			
			var oFarm:Farm = new Farm("HappyFarm", null, null, 0, 5, 0, 5);
			var oHouse:House = new House(new GridLocation(5, 5), oFarm);
			oFarm.AddBldg(oHouse);
			
			oResult.TestNotNull(oFarm.GetBldg(Bldg.TYPE_FARM_HOUSE));
			
			return oResult;
		}
		
		public static function GetMailbox():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Farm", "GetMailbox");
			
			var oFarm:Farm = new Farm("HappyFarm", null, null, 0, 5, 0, 5);
			var oMailbox:Mailbox = new Mailbox(new GridLocation(5, 5), oFarm);
			oFarm.AddBldg(oMailbox);
			
			oResult.TestNotNull(oFarm.GetBldg(Bldg.TYPE_FARM_MAILBOX));
			
			return oResult;
		}
		
		public static function GetRootCellar():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Farm", "GetRootCellar");
			
			var oFarm:Farm = new Farm("HappyFarm", null, null, 0, 5, 0, 5);
			var oRootCellar:RootCellar = new RootCellar(null, oFarm);
			oFarm.AddBldg(oRootCellar);
			
			oResult.TestNotNull(oFarm.GetBldg(Bldg.TYPE_FARM_ROOT_CELLAR));
			
			return oResult;
		}
		
		public static function GetSaleCart():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Farm", "GetSaleCart");
			
			var oFarm:Farm = new Farm("HappyFarm", null, null, 0, 5, 0, 5);
			var oSaleCart:SaleCart = new SaleCart(new GridLocation(5, 5), oFarm);
			oFarm.AddBldg(oSaleCart);
			
			oResult.TestNotNull(oFarm.GetBldg(Bldg.TYPE_FARM_SALE_CART));
			
			return oResult;
		}
		
		public static function GetToolShed():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Farm", "GetToolShed");
			
			var oFarm:Farm = new Farm("HappyFarm", null, null, 0, 5, 0, 5);
			var oToolShed:ToolShed = new ToolShed(new GridLocation(5, 5), oFarm);
			oFarm.AddBldg(oToolShed);
			
			oResult.TestNotNull(oFarm.GetBldg(Bldg.TYPE_FARM_TOOLSHED));
			
			return oResult;
		}
		
		public static function GetWell():UnitTestResult
		{
			var oResult:UnitTestResult = new UnitTestResult("Farm", "GetWell");
			
			var oFarm:Farm = new Farm("HappyFarm", null, null, 0, 5, 0, 5);
			var oWell:Well = new Well(new GridLocation(5, 5), oFarm);
			oFarm.AddBldg(oWell);
			
			oResult.TestNotNull(oFarm.GetBldg(Bldg.TYPE_FARM_WELL));
			
			return oResult;
		}
		
		//- Testing Methods -//
	}
}