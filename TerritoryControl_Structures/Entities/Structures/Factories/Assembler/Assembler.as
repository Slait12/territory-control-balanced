#include "MakeCrate.as";
#include "Requirements.as";
#include "ShopCommon.as";
#include "Descriptions.as";
#include "CheckSpam.as";
#include "CTFShopCommon.as";
#include "MakeMat.as";
#include "MakeSeed.as";

void onInit(CSprite@ this)
{	
	CBlob@ blob = this.getBlob();
	if (blob is null) return;
	// Building
	this.SetZ(-50);
	this.SetEmitSound("assembler_loop.ogg");
	this.SetEmitSoundVolume(0.4f);
	this.SetEmitSoundSpeed(0.5f);
	this.SetEmitSoundPaused(false);
	bool state = blob.get_bool("state");
	bool InfTask = blob.get_bool("InfTask");
	
	if (!state && blob.hasTag("togglesupport"))
	{
		this.SetEmitSoundPaused(true);
	}
	{
		this.RemoveSpriteLayer("gear1");
		CSpriteLayer@ gear = this.addSpriteLayer("gear1", "Cogs.png" , 16, 16, this.getBlob().getTeamNum(), this.getBlob().getSkinNum());
		if (gear !is null)
		{
			Animation@ anim = gear.addAnimation("default", 0, false);
			anim.AddFrame(3);
			gear.SetOffset(Vec2f(-10.0f, -4.0f));
			gear.SetAnimation("default");
			gear.SetRelativeZ(-60);
		}
	}
	{
		this.RemoveSpriteLayer("gear2");
		CSpriteLayer@ gear = this.addSpriteLayer("gear2", "Cogs.png" , 16, 16, this.getBlob().getTeamNum(), this.getBlob().getSkinNum());
		if (gear !is null)
		{
			Animation@ anim = gear.addAnimation("default", 0, false);
			anim.AddFrame(3);
			gear.SetOffset(Vec2f(17.0f, -10.0f));
			gear.SetAnimation("default");
			gear.SetRelativeZ(-60);
		}
	}
	{
		this.RemoveSpriteLayer("gear3");
		CSpriteLayer@ gear = this.addSpriteLayer("gear3", "Cogs.png" , 16, 16, this.getBlob().getTeamNum(), this.getBlob().getSkinNum());
		if (gear !is null)
		{
			Animation@ anim = gear.addAnimation("default", 0, false);
			anim.AddFrame(3);
			gear.SetOffset(Vec2f(6.0f, -4.0f));
			gear.SetAnimation("default");
			gear.SetRelativeZ(-60);
			gear.RotateBy(-22, Vec2f(0.0f,0.0f));
		}
	}
}

void onTick(CSprite@ this)
{
	CBlob@ blob = this.getBlob();
	bool state = blob.get_bool("state");
	
	if (state || !blob.hasTag("togglesupport"))
	{
		if(this.getSpriteLayer("gear1") !is null){
			this.getSpriteLayer("gear1").RotateBy(5.0f*(this.getBlob().exists("gyromat_acceleration") ? this.getBlob().get_f32("gyromat_acceleration") : 1), Vec2f(0.0f,0.0f));
	}
		if(this.getSpriteLayer("gear2") !is null){
			this.getSpriteLayer("gear2").RotateBy(-5.0f*(this.getBlob().exists("gyromat_acceleration") ? this.getBlob().get_f32("gyromat_acceleration") : 1), Vec2f(0.0f,0.0f));
	}
		if(this.getSpriteLayer("gear3") !is null){
			this.getSpriteLayer("gear3").RotateBy(5.0f*(this.getBlob().exists("gyromat_acceleration") ? this.getBlob().get_f32("gyromat_acceleration") : 1), Vec2f(0.0f,0.0f));
	}
	
	
	
	}
}
class AssemblerItem
{
	string resultname;
	u32 resultcount;
	string title;
	CBitStream reqs;

	AssemblerItem(string resultname, u32 resultcount, string title)
	{
		this.resultname = resultname;
		this.resultcount = resultcount;
		this.title = title;
	}
}

void onInit(CBlob@ this)
{
	AssemblerItem[] items;
	{
		AssemblerItem i("mat_pistolammo", 50, "Low Caliber Bullets (50)");
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 1);
		AddRequirement(i.reqs, "blob", "mat_sulphur", "Sulphur", 20);
		items.push_back(i);
	}
	{
		AssemblerItem i("mat_rifleammo", 50, "High Caliber Bullets (50)");
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 3);
		AddRequirement(i.reqs, "blob", "mat_sulphur", "Sulphur", 35);
		items.push_back(i);
	}
	{
		AssemblerItem i("mat_shotgunammo", 12, "Shotgun Shells (12)");
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 2);
		AddRequirement(i.reqs, "blob", "mat_sulphur", "Sulphur", 40);
		items.push_back(i);
	}
	{
		AssemblerItem i("mat_gatlingammo", 150, "Machine Gun Ammo (150)");
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 4);
		AddRequirement(i.reqs, "blob", "mat_sulphur", "Sulphur", 65);
		items.push_back(i);
	}
	{
		AssemblerItem i("mat_sniperammo", 20, "High Power Ammunition (20)");
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 5);
		AddRequirement(i.reqs, "blob", "mat_sulphur", "Sulphur", 125);
		items.push_back(i);
	}

	{
		AssemblerItem i("mat_howitzershell", 4, "Howitzer Shells (4)");
		AddRequirement(i.reqs, "blob", "mat_copperingot", "Copper Ingot", 2);
		AddRequirement(i.reqs, "blob", "mat_sulphur", "Sulphur", 15);
		items.push_back(i);
	}
	{
		AssemblerItem i("mat_smallbomb", 4, "Small Bombs (4)");
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 2);
		AddRequirement(i.reqs, "blob", "mat_sulphur", "Sulphur", 20);
		items.push_back(i);
	}
	{
		AssemblerItem i("mat_incendiarybomb", 4, "Incendiary Bombs (4)");
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 2);
		AddRequirement(i.reqs, "blob", "mat_oil", "Oil", 20);
		items.push_back(i);
	}
	{
		AssemblerItem i("foodcan", 2, "Scrub's Chow (2)");
		AddRequirement(i.reqs, "blob", "mat_meat", "Mystery Meat", 15);
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 1);
		items.push_back(i);
	}	
	{
		AssemblerItem i("bigfoodcan", 1, "Scrub's Chow XL (1)");
		AddRequirement(i.reqs, "blob", "mat_meat", "Mystery Meat", 80);
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 12);
		items.push_back(i);
	}
	{
		AssemblerItem i("mat_smallrocket", 4, "Small Rocket (4)");
		AddRequirement(i.reqs, "blob", "mat_wood", "Wood", 40);
		AddRequirement(i.reqs, "blob", "mat_sulphur", "Sulphur", 20);
		items.push_back(i);
	}
	{
		AssemblerItem i("mine", 2, "Mine (2)");
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 1);
		AddRequirement(i.reqs, "blob", "mat_sulphur", "Sulphur", 20);
		items.push_back(i);
	}
	{
		AssemblerItem i("fragmine", 1, "Fragmentation Mine (1)");
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 2);
		AddRequirement(i.reqs, "blob", "mat_sulphur", "Sulphur", 20);
		items.push_back(i);
	}
	{
		AssemblerItem i("mat_sammissile", 1, "SAM Missile (1)");
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 2);
		AddRequirement(i.reqs, "blob", "mat_methane", "Methane", 15);
		items.push_back(i);
	}
	{
		AssemblerItem i("mat_grenade", 4, "Grenade (4)");
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 1);
		AddRequirement(i.reqs, "blob", "mat_sulphur", "Sulphur", 10);
		items.push_back(i);
	}
	{
		AssemblerItem i("revolver", 1, "Revolver (1)");
		AddRequirement(i.reqs, "blob", "mat_wood", "Wood", 30);
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 1);
		items.push_back(i);
	}
	{
		AssemblerItem i("smg", 1, "Bobby Gun (1)");
		AddRequirement(i.reqs, "blob", "mat_wood", "Wood", 70);
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 2);
		items.push_back(i);
	}
	{
		AssemblerItem i("rifle", 1, "Bolt Action Rifle (1)");
		AddRequirement(i.reqs, "blob", "mat_wood", "Wood", 30);
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 4);
		items.push_back(i);
	}
	{
		AssemblerItem i("leverrifle", 1, "Lever Action Rifle (1)");
		AddRequirement(i.reqs, "blob", "mat_wood", "Wood", 100);
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 4);
		items.push_back(i);
	}
	{
		AssemblerItem i("shotgun", 1, "Shotgun (1)");
		AddRequirement(i.reqs, "blob", "mat_wood", "Wood", 110);
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 4);
		AddRequirement(i.reqs, "blob", "mat_steelingot", "Steel Ingot", 2);
		items.push_back(i);
	}
	{
		AssemblerItem i("mat_copperwire", 30, "Copper wires (30)");
		AddRequirement(i.reqs, "blob", "mat_copperingot", "Copper ingot", 10);
		items.push_back(i);
	}
	{
		AssemblerItem i("mat_dynamite", 2, "Dynamite (2)");
		AddRequirement(i.reqs, "blob", "mat_wood", "Wood", 100);
		AddRequirement(i.reqs, "blob", "mat_sulphur", "Sulphur", 50);
		items.push_back(i);
	}
	{
		AssemblerItem i("mat_battery", 10, "Battery (10)");
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 2);
		AddRequirement(i.reqs, "blob", "mat_copperingot", "Copper Ingot", 2);
		AddRequirement(i.reqs, "blob", "mat_mithril", "Mithril", 10);
		AddRequirement(i.reqs, "blob", "mat_sulphur", "Sulphur", 25);
		items.push_back(i);
	}
	this.set("items", items);

	this.set_TileType("background tile", CMap::tile_castle_back);
	this.getShape().getConsts().mapCollisions = false;
	this.getCurrentScript().tickFrequency = 60;

	this.Tag("builder always hit");
	this.Tag("change team on fort capture");
	this.Tag("hassound");
	
	this.addCommandID("set");
	this.addCommandID("IncreaseTask1");
	this.addCommandID("IncreaseTask2");
	this.addCommandID("IncreaseTask3");
	this.addCommandID("IncreaseTask4");
	this.addCommandID("IncreaseTask5");
	this.addCommandID("IncreaseTask6");
	this.addCommandID("IncreaseTask7");
	this.addCommandID("IncreaseTask8");
	this.addCommandID("IncreaseTask9");
	this.addCommandID("IncreaseTask10");
	this.addCommandID("IncreaseTask11");
	this.addCommandID("IncreaseTask12");
	this.addCommandID("IncreaseTask13");
	this.addCommandID("IncreaseTask14");
	
	this.set_bool("InfTask", true);

	this.set_u8("crafting", 0);
	
	this.set_u16("ProduceTask", 0);
	
	this.set_string("drawText", "Production Plan: Unlimited");
	
	this.Tag("ignore extractor");
}

void GetButtonsFor(CBlob@ this, CBlob@ caller)
{
	if (this.getDistanceTo(caller) > 96.0f) return;
	if (!caller.isOverlapping(this)) return;
	{
		CBitStream params;
		params.write_u16(caller.getNetworkID());
	
		CButton@ button = caller.CreateGenericButton(21, Vec2f(0, -16), this, AssemblerMenu, "Set Item");
	}
}

void AssemblerMenu(CBlob@ this, CBlob@ caller)
{
	if (caller.isMyPlayer())
	{
		string CountText = "Production Plan: " + this.get_u16("ProduceTask") + " Items";	
		CGridMenu@ menu = CreateGridMenu(getDriver().getScreenCenterPos() + Vec2f(0.0f, 0.0f), this, Vec2f(4, 6), "Set Assembly");
		if (menu !is null)
		{
			AssemblerItem[] items = getItems(this);
			for(uint i = 0; i < items.length; i += 1)
			{
				AssemblerItem item = items[i];

				CBitStream pack;
				pack.write_u8(i);

				int teamnum = this.getTeamNum();
				if (teamnum > 6) teamnum = 7;
				AddIconToken("$assembler_icon" + i + "$", "AssemblerIcons.png", Vec2f(16, 16), i, teamnum);

				string text = "Set to Assemble: " + item.title;
				if(this.get_u8("crafting") == i)
				{
					text = "Already Assembling: " + item.title;
				}
				CGridButton @butt = menu.AddButton("$assembler_icon" + i + "$", text, this.getCommandID("set"), pack);
				butt.hoverText = item.title + "\n" + getButtonRequirementsText(item.reqs, false);
				if(this.get_u8("crafting") == i)
				{
					butt.SetEnabled(false);
				}
			}
		}
		CGridMenu@ qmenu = CreateGridMenu(getDriver().getScreenCenterPos() + Vec2f(0.0f, -240.0f), this, Vec2f(7, 2), CountText);
		if (qmenu !is null)
		{
			for(uint i = 1; i < 15; i += 1)
			{

				int teamnum = this.getTeamNum();
				if (teamnum > 6) teamnum = 7;
				AddIconToken("$assembler_qicon" + i + "$", "AssemblerIcons2.png", Vec2f(16, 16), i - 1, teamnum);

				switch(i)
				{
					case 1:
					{
						this.set_string("qtext", "Add 1 Item");
						break;
					}
					case 2:
					{
						this.set_string("qtext", "Add 5 Items");
						break;
					}
					case 3:
					{
						this.set_string("qtext", "Add 10 Items");
						break;
					}
					case 4:
					{
						this.set_string("qtext", "Add 20 Items");
						break;
					}
					case 5:
					{
						this.set_string("qtext", "Add 50 Items");
						break;
					}
					case 6:
					{
						this.set_string("qtext", "Add 100 Items");
						break;
					}
					case 7:
					{
						this.set_string("qtext", "Unlimited Production");
						break;
					}
					case 8:
					{
						this.set_string("qtext", "Remove 1 Item");
						break;
					}
					case 9:
					{
						this.set_string("qtext", "Remove 5 Items");
						break;
					}
					case 10:
					{
						this.set_string("qtext", "Remove 10 Items");
						break;
					}
					case 11:
					{
						this.set_string("qtext", "Remove 20 Items");
						break;
					}
					case 12:
					{
						this.set_string("qtext", "Remove 50 Items");
						break;
					}
					case 13:
					{
						this.set_string("qtext", "Remove 100 Items");
						break;
					}
					case 14:
					{
						this.set_string("qtext", "Reset Plan");
						break;
					}
				}
				CGridButton @butt = qmenu.AddButton("$assembler_qicon" + i + "$", (this.get_string("qtext")), this.getCommandID("IncreaseTask" + i));	
			}
		}	
	}
}

void onCommand(CBlob@ this, u8 cmd, CBitStream @params)
{
	if (cmd == this.getCommandID("set"))
	{
		u8 setting = params.read_u8();
		this.set_u8("crafting", setting);
	}
	if (cmd == this.getCommandID("IncreaseTask1"))
	{
		IncreaseTask(this, 1);
	}
	if (cmd == this.getCommandID("IncreaseTask2"))
	{
		IncreaseTask(this, 5);
	}
	if (cmd == this.getCommandID("IncreaseTask3"))
	{
		IncreaseTask(this, 10);
	}
	if (cmd == this.getCommandID("IncreaseTask4"))
	{
		IncreaseTask(this, 20);
	}
	if (cmd == this.getCommandID("IncreaseTask5"))
	{
		IncreaseTask(this, 50);
	}
		if (cmd == this.getCommandID("IncreaseTask6"))
	{
		IncreaseTask(this, 100);
	}
		if (cmd == this.getCommandID("IncreaseTask7"))
	{
		this.set_bool("InfTask", !this.get_bool("InfTask"));
		this.set_string("drawText", "Production Plan: Unlimited");
	}
		if (cmd == this.getCommandID("IncreaseTask8"))
	{
		DecreaseTask(this, 1);
	}
	if (cmd == this.getCommandID("IncreaseTask9"))
	{
		DecreaseTask(this, 5);
	}
	if (cmd == this.getCommandID("IncreaseTask10"))
	{
		DecreaseTask(this, 10);
	}
	if (cmd == this.getCommandID("IncreaseTask11"))
	{
		DecreaseTask(this, 20);
	}
	if (cmd == this.getCommandID("IncreaseTask12"))
	{
		DecreaseTask(this, 50);
	}
		if (cmd == this.getCommandID("IncreaseTask13"))
	{
		DecreaseTask(this, 100);
	}
		if (cmd == this.getCommandID("IncreaseTask14"))
	{
		TaskReset(this);
	}
}

void onTick(CBlob@ this)
{
	if (!this.get_bool("state") && this.hasTag("togglesupport")) return; // set this to stop structure
	int crafting = this.get_u8("crafting");

	AssemblerItem[]@ items = getItems(this);
	if (items.length == 0) return;

	AssemblerItem item = items[crafting];
	CInventory@ inv = this.getInventory();

	CBitStream missing;
	if (hasRequirements(inv, item.reqs, missing) && (this.get_u16("ProduceTask") > 0 || this.get_bool("InfTask")))
	{
		if (isServer())
		{
			CBlob @mat = server_CreateBlob(item.resultname, this.getTeamNum(), this.getPosition());
			mat.server_SetQuantity(item.resultcount);

			server_TakeRequirements(inv, item.reqs);
			
			if (!this.get_bool("InfTask"))
			{
				DecreaseTask(this, item.resultcount);
			}
		}

		if(isClient())
		{
			this.getSprite().PlaySound("ProduceSound.ogg");
			this.getSprite().PlaySound("BombMake.ogg");
		}
	}
}

void IncreaseTask(CBlob@ this, u16 incr_quantity)
{
	this.set_u16("ProduceTask", (this.get_u16("ProduceTask") + incr_quantity));
	this.set_bool("InfTask", false);
	this.set_string("drawText", "Production Plan: " + (this.get_u16("ProduceTask")) + " Items");
}

void DecreaseTask(CBlob@ this, u16 incr_quantity)
{
	if (incr_quantity < (this.get_u16("ProduceTask")))
	{
		this.set_u16("ProduceTask", (this.get_u16("ProduceTask") - incr_quantity));
	}
	else
	{
		this.set_u16("ProduceTask", 0);
	}
	this.set_bool("InfTask", false);
	this.set_string("drawText", "Production Plan: " + (this.get_u16("ProduceTask")) + " Items");
}

void TaskReset(CBlob@ this)
{
	this.set_u16("ProduceTask", 0);
	this.set_bool("InfTask", false);
	this.set_string("drawText", "Production Plan: " + (this.get_u16("ProduceTask")) + " Items");
}

void onRender(CSprite@ this)
{
	CBlob@ local = getLocalPlayerBlob();
	CBlob@ b = this.getBlob();
	if(local !is null && local.isMyPlayer() && getMap().getBlobAtPosition(getControls().getMouseWorldPos()) is b)
	{
		GUI::SetFont("MENU");
		GUI::DrawText(b.get_string("drawText"), b.getInterpolatedScreenPos() + Vec2f(-40 ,-40), SColor(255,255,255,255).getInterpolated(SColor(255,255,255,255), b.get_f32("percentageToMax")));
	}
}

void onCollision(CBlob@ this, CBlob@ blob, bool solid)
{
	if (blob is null) return;

	int crafting = this.get_u8("crafting");

	bool isMat = false;

	AssemblerItem[]@ items = getItems(this);
	if (items.length == 0) return;

	AssemblerItem item = items[crafting];
	CBitStream bs = item.reqs;
	bs.ResetBitIndex();
	string text, requiredType, name, friendlyName;
	u16 quantity = 0;

	while (!bs.isBufferEnd())
	{
		ReadRequirement(bs, requiredType, name, friendlyName, quantity);

		if(blob.getName() == name)
		{
			isMat = true;
			break;
		}
	}

	if (isMat && !blob.isAttached() && blob.hasTag("material"))
	{
		if (isServer()) this.server_PutInInventory(blob);
		if (isClient()) this.getSprite().PlaySound("bridge_open.ogg");
	}
}

bool isInventoryAccessible(CBlob@ this, CBlob@ forBlob)
{
	return (this.getTeamNum() >= 100 ? true : (forBlob.getTeamNum() == this.getTeamNum())) && forBlob.isOverlapping(this);
}

AssemblerItem[] getItems(CBlob@ this)
{
	AssemblerItem[] items;
	this.get("items", items);
	return items;
}


void onAddToInventory( CBlob@ this, CBlob@ blob )
{
	if(blob.getName() != "gyromat") return;

	this.getCurrentScript().tickFrequency = 60 / (this.exists("gyromat_acceleration") ? this.get_f32("gyromat_acceleration") : 1);
}

void onRemoveFromInventory(CBlob@ this, CBlob@ blob)
{
	if(blob.getName() != "gyromat") return;
	
	this.getCurrentScript().tickFrequency = 60 / (this.exists("gyromat_acceleration") ? this.get_f32("gyromat_acceleration") : 1);
}