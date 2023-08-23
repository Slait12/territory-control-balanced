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
	this.SetEmitSound("ChickenAssembler_Loop.ogg");
	this.SetEmitSoundVolume(0.4f);
	this.SetEmitSoundSpeed(0.9f);
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
	//Weapons
	{
		AssemblerItem i("mat_pistolammo", 200, "Low Caliber Bullets (200)");
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 4);
		AddRequirement(i.reqs, "blob", "mat_sulphur", "Sulphur", 80);
		items.push_back(i);
	}
	{
		AssemblerItem i("mat_smallrocket", 8, "Small Rocket (8)");
		AddRequirement(i.reqs, "blob", "mat_wood", "Wood", 80);
		AddRequirement(i.reqs, "blob", "mat_sulphur", "Sulphur", 40);
		items.push_back(i);
	}
	{
		AssemblerItem i("mat_grenade", 4, "Grenade (4)");
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 1);
		AddRequirement(i.reqs, "blob", "mat_sulphur", "Sulphur", 10);
		items.push_back(i);
	}
	{
		AssemblerItem i("mat_stickygrenade", 4, "Sticky Grenade (4)");
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 2);
		AddRequirement(i.reqs, "blob", "mat_sulphur", "Sulphur", 10);
		items.push_back(i);
	}
	{
		AssemblerItem i("mat_flamegrenade", 4, "Flame Grenade (4)");
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 2);
		AddRequirement(i.reqs, "blob", "mat_sulphur", "Sulphur", 10);
		AddRequirement(i.reqs, "blob", "mat_oil", "Oil", 25);
		items.push_back(i);
	}
	{
		AssemblerItem i("mat_acidgrenade", 2, "Acid Grenade (2)");
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 2);
		AddRequirement(i.reqs, "blob", "mat_sulphur", "Sulphur", 10);
		AddRequirement(i.reqs, "blob", "mat_acid", "Acid", 50);
		items.push_back(i);
	}
	{
		AssemblerItem i("mat_rifleammo", 200, "High Caliber Bullets (200)");
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 12);
		AddRequirement(i.reqs, "blob", "mat_sulphur", "Sulphur", 140);
		items.push_back(i);
	}
	{
		AssemblerItem i("revolver", 4, "Revolver (4)");
		AddRequirement(i.reqs, "blob", "mat_wood", "Wood", 120);
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 4);
		items.push_back(i);
	}
	{
		AssemblerItem i("smg", 4, "Bobby Gun (4)");
		AddRequirement(i.reqs, "blob", "mat_wood", "Wood", 280);
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 8);
		items.push_back(i);
	}
	{
		AssemblerItem i("rifle", 4, "Bolt Action Rifle (4)");
		AddRequirement(i.reqs, "blob", "mat_wood", "Wood", 120);
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 12);
		items.push_back(i);
	}
	{
		AssemblerItem i("boomstick", 4, "Boomstick (4)");
		AddRequirement(i.reqs, "blob", "mat_wood", "Wood", 160);
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 16);
		items.push_back(i);
	}
	{
		AssemblerItem i("dp27", 1, "DP-27 (1)");
		AddRequirement(i.reqs, "blob", "mat_wood", "Wood", 200);
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 8);
		items.push_back(i);
	}
	{
		AssemblerItem i("mat_shotgunammo", 48, "Shotgun Shells (48)");
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 8);
		AddRequirement(i.reqs, "blob", "mat_sulphur", "Sulphur", 160);
		items.push_back(i);
	}
	{
		AssemblerItem i("truerevolver", 1, "Big iron (1)");
		AddRequirement(i.reqs, "blob", "revolver", "Revolver", 1);
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 3);
		items.push_back(i);
	}
	{
		AssemblerItem i("ppsh", 1, "Soviet PPSH (1)");
		AddRequirement(i.reqs, "blob", "smg", "Bobby Gun", 1);
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 2);
		items.push_back(i);
	}
	{
		AssemblerItem i("leverrifle", 4, "Lever Action Rifle (4)");
		AddRequirement(i.reqs, "blob", "mat_wood", "Wood", 400);
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 16);
		items.push_back(i);
	}
	{
		AssemblerItem i("shotgun", 4, "Shotgun (4)");
		AddRequirement(i.reqs, "blob", "mat_wood", "Wood", 440);
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 16);
		items.push_back(i);
	}
	{
		AssemblerItem i("rp46", 1, "RP-46 (1)");
		AddRequirement(i.reqs, "blob", "rifle", "Bolt Action Rifle", 1);
		AddRequirement(i.reqs, "blob", "dp27", "DP-27", 1);
		AddRequirement(i.reqs, "blob", "mat_steelingot", "Steel Ingot", 2);
		AddRequirement(i.reqs, "blob", "mat_copperingot", "Copper Ingot", 5);
		items.push_back(i);
	}
	{
		AssemblerItem i("mat_gatlingammo", 600, "Machine Gun Ammo (600)");
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 16);
		AddRequirement(i.reqs, "blob", "mat_sulphur", "Sulphur", 260);
		items.push_back(i);
	}
	{
		AssemblerItem i("grenadelauncher", 1, "Grenade Launcher M79 (1)");
		AddRequirement(i.reqs, "blob", "mat_wood", "Wood", 200);
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 4);
		AddRequirement(i.reqs, "blob", "mat_steelingot", "Steel Ingot", 5);
		items.push_back(i);
	}
	{
		AssemblerItem i("bnak", 1, "AKM (1)");
		AddRequirement(i.reqs, "blob", "smg", "Bobby Gun", 4);
		AddRequirement(i.reqs, "blob", "mat_steelingot", "Steel Ingot", 2);
		items.push_back(i);
	}
	{
		AssemblerItem i("svd", 1, "Sniper Rifle Dragunova (1)");
		AddRequirement(i.reqs, "blob", "rifle", "Bolt Action Rifle", 2);
		AddRequirement(i.reqs, "blob", "mat_steelingot", "Steel Ingot", 5);
		items.push_back(i);
	}
	{
		AssemblerItem i("nitro700", 1, "Nitro 700 (1)");
		AddRequirement(i.reqs, "blob", "rifle", "Bolt Action Rifle", 1);
		AddRequirement(i.reqs, "blob", "boomstick", "Boomstick", 1);
		AddRequirement(i.reqs, "blob", "mat_steelingot", "Steel Ingot", 3);
		items.push_back(i);
	}
	{
		AssemblerItem i("tkb521", 1, "TKB-521 (1)");
		AddRequirement(i.reqs, "blob", "dp27", "DP-27", 1);
		AddRequirement(i.reqs, "blob", "leverrifle", "Lever Action Rifle", 1);
		AddRequirement(i.reqs, "blob", "mat_steelingot", "Steel Ingot", 5);
		items.push_back(i);
	}
	{
		AssemblerItem i("mat_sniperammo", 80, "High Power Ammunition (80)");
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 20);
		AddRequirement(i.reqs, "blob", "mat_sulphur", "Sulphur", 300);
		items.push_back(i);
	}
	{
		AssemblerItem i("bazooka", 1, "Bazooka (1)");
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 5);
		AddRequirement(i.reqs, "blob", "mat_copperingot", "Copper Ingot", 2);
		items.push_back(i);
	}
	{
		AssemblerItem i("crossbow", 4, "Crossbow (4)");
		AddRequirement(i.reqs, "blob", "mat_wood", "Wood", 1000);
		items.push_back(i);
	}
	{
		AssemblerItem i("gaussrifle", 1, "Gauss Rifle (1)");
		AddRequirement(i.reqs, "blob", "mat_steelingot", "Steel Ingot", 4);
		AddRequirement(i.reqs, "blob", "mat_copperingot", "Copper Ingot", 8);
		AddRequirement(i.reqs, "blob", "mat_mithril", "Mithril", 40);
		items.push_back(i);
	}
	{
		AssemblerItem i("drill", 1, "Drill (2)");
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 4);
		items.push_back(i);
	}
	{
		AssemblerItem i("powerdrill", 1, "Giga Drill Breaker (1)");
		AddRequirement(i.reqs, "blob", "mat_mithrilingot", "Mithril Ingot", 4);
		AddRequirement(i.reqs, "blob", "mat_copperingot", "Copper Ingot", 4);
		items.push_back(i);
	}
	//Equipment
	{
		AssemblerItem i("lightarmor", 1, "Light Armor");
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 8);
		items.push_back(i);
	}
	{
		AssemblerItem i("parachutepack", 1, "Parachute Pack");
		AddRequirement(i.reqs, "blob", "mat_wood", "Wood", 200);
		items.push_back(i);
	}
	{
		AssemblerItem i("jumpshoes", 1, "Jump Shoes");
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 6);
		AddRequirement(i.reqs, "blob", "mat_copperwire", "Copper Wire", 10);
		items.push_back(i);
	}
	{
		AssemblerItem i("katana", 1, "Katana");
		AddRequirement(i.reqs, "blob", "mat_steelingot", "Steel Ingot", 8);
		items.push_back(i);
	}
	{
		AssemblerItem i("armor", 1, "Ballistic Armor");
		AddRequirement(i.reqs, "blob", "mat_steelingot", "Steel Ingot", 18);
		items.push_back(i);
	}
	{
		AssemblerItem i("jetpack", 1, "Rocket Pack");
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 5);
		AddRequirement(i.reqs, "blob", "mat_oil", "Oil", 50);
		items.push_back(i);
	}
	{
		AssemblerItem i("beartrap", 1, "Bear Trap");
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 6);
		items.push_back(i);
	}
	{
		AssemblerItem i("rendezook", 1, "Rendezook");
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 4);
		AddRequirement(i.reqs, "blob", "mat_copperingot", "Copper Ingot", 5);
		items.push_back(i);
	}
	{
		AssemblerItem i("compositearmor", 1, "Compostie Armor");
		AddRequirement(i.reqs, "blob", "mat_mithrilrilingot", "Mithril Ingot", 14);
		AddRequirement(i.reqs, "blob", "mat_copperingot", "Copper Ingot", 18);
		items.push_back(i);
	}
	{
		AssemblerItem i("jetpackv2", 1, "Rocket Pack Version 2");
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 6);
		AddRequirement(i.reqs, "blob", "mat_fuel", "Fuel", 25);
		items.push_back(i);
	}
	{
		AssemblerItem i("automat", 1, "Autonomous Activator");
		AddRequirement(i.reqs, "blob", "mat_steelingot", "Steel Ingot", 4);
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 8);
		items.push_back(i);
	}
	{
		AssemblerItem i("binoculars", 1, "Binoculars");
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 2);
		items.push_back(i);
	}
	{
		AssemblerItem i("wrench", 1, "Wrench");
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 4);
		items.push_back(i);
	}
	{
		AssemblerItem i("engineertools", 1, "Engineer's Tools");
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 6);
		items.push_back(i);
	}
	{
		AssemblerItem i("hazmatitem", 1, "Hazmat Suit");
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 4);
		AddRequirement(i.reqs, "blob", "mat_mithril", "Mithril", 50);
		items.push_back(i);
	}
	{
		AssemblerItem i("roaylarmor", 1, "Royal Guard Armor");
		AddRequirement(i.reqs, "blob", "mat_steelingot", "Steel Ingot", 8);
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 10);
		items.push_back(i);
	}
	{
		AssemblerItem i("ninjascroll", 1, "Ancient Weaboo Scroll");
		AddRequirement(i.reqs, "blob", "mat_ganja", "Ganja", 15);
		AddRequirement(i.reqs, "blob", "mat_steelingot", "Steel Ingot", 14);
		items.push_back(i);
	}
	{
		AssemblerItem i("mat_arrows", 30, "Arrows (30)");
		AddRequirement(i.reqs, "blob", "mat_wood", "wood", 50);
		items.push_back(i);
	}
	{
		AssemblerItem i("mat_waterarrows", 4, "Water Arrow (4)");
		AddRequirement(i.reqs, "blob", "mat_wood", "wood", 30);
		items.push_back(i);
	}
	{
		AssemblerItem i("mat_firearrows", 4, "Fire Arrow (4)");
		AddRequirement(i.reqs, "blob", "mat_wood", "wood", 25);
		items.push_back(i);
	}
	{
		AssemblerItem i("mat_bombarrows", 4, "Bomb Arrow (4)");
		AddRequirement(i.reqs, "blob", "mat_wood", "Wood", 80);
		AddRequirement(i.reqs, "blob", "mat_sulphur", "Sulphur", 20);
		items.push_back(i);
	}
	//Explosives
	{
		AssemblerItem i("mat_tankshell", 4, "Artillery Shell (4)");
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 1);
		AddRequirement(i.reqs, "blob", "mat_sulphur", "Sulphur", 10);
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
		AssemblerItem i("mat_shrapnelbomb", 8, "Anti-personel Shrapnel Bomb (8)");
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 2);
		AddRequirement(i.reqs, "blob", "mat_sulphur", "Sulphur", 15);
		items.push_back(i);
	}
	{
		AssemblerItem i("mat_grenade", 4, "Grenade (4)");
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 1);
		AddRequirement(i.reqs, "blob", "mat_sulphur", "Sulphur", 10);
		items.push_back(i);
	}
	{
		AssemblerItem i("mat_smallrocket", 4, "Small Rocket (4)");
		AddRequirement(i.reqs, "blob", "mat_wood", "Wood", 40);
		AddRequirement(i.reqs, "blob", "mat_sulphur", "Sulphur", 20);
		items.push_back(i);
	}
	{
		AssemblerItem i("firework", 2, "Firework (2)");
		AddRequirement(i.reqs, "blob", "mat_wood", "Wood", 40);
		AddRequirement(i.reqs, "blob", "mat_sulphur", "Sulphur", 20);
		items.push_back(i);
	}
	{
		AssemblerItem i("mat_tankshell", 8, "Artillery Shell (8)");
		AddRequirement(i.reqs, "blob", "mat_goldingot", "Gold Ingot", 1);
		items.push_back(i);
	}
	{
		AssemblerItem i("mat_howitzershell", 2, "Howitzer Shells (2)");
		AddRequirement(i.reqs, "blob", "mat_goldingot", "Gold Ingot", 1);
		items.push_back(i);
	}	
	{
		AssemblerItem i("mat_smallbomb", 4, "Small Bombs (4)");
		AddRequirement(i.reqs, "blob", "mat_goldingot", "Gold Ingot", 1);
		items.push_back(i);
	}
	{
		AssemblerItem i("mat_shrapnelbomb", 8, "Anti-personel Shrapnel Bomb (8)");
		AddRequirement(i.reqs, "blob", "mat_goldingot", "Gold Ingot", 1);
		items.push_back(i);
	}
	{
		AssemblerItem i("mat_grenade", 2, "Grenade (2)");
		AddRequirement(i.reqs, "blob", "mat_goldingot", "Gold Ingot", 1);
		items.push_back(i);
	}
	{
		AssemblerItem i("mat_smallrocket", 2, "Small Rocket (2)");
		AddRequirement(i.reqs, "blob", "mat_goldingot", "Gold Ingot", 1);
		items.push_back(i);
	}
	{
		AssemblerItem i("firework", 2, "Firework (2)");
		AddRequirement(i.reqs, "blob", "mat_goldingot", "Gold Ingot", 1);
		items.push_back(i);
	}
	{
		AssemblerItem i("mat_bigbomb", 1, "Big Bomb");
		AddRequirement(i.reqs, "blob", "mat_goldingot", "Gold Ingot", 15);
		AddRequirement(i.reqs, "blob", "mat_sulphur", "Sulphur", 500);
		AddRequirement(i.reqs, "blob", "mat_coal", "Coal", 100);
		items.push_back(i);
	}
	{
		AssemblerItem i("mat_incendiarybomb", 4, "Incendiary Bombs (4)");
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 2);
		AddRequirement(i.reqs, "blob", "mat_oil", "Oil", 20);
		items.push_back(i);
	}
	{
		AssemblerItem i("mat_bunkerbuster", 1, "Bunker Buster (1)");
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 2);
		AddRequirement(i.reqs, "blob", "mat_sulphur", "Sulphur", 125);
		items.push_back(i);
	}
	{
		AssemblerItem i("mat_stunbomb", 2, "Shockwave Bomb (2)");
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 4);
		AddRequirement(i.reqs, "blob", "mat_methane", "Methane", 20);
		items.push_back(i);
	}
	{
		AssemblerItem i("mat_clusterbomb", 1, "Cluster Bomb (1)");
		AddRequirement(i.reqs, "blob", "mat_steelingot", "Steel Ingot", 2);
		AddRequirement(i.reqs, "blob", "mat_methane", "Methane", 25);
		AddRequirement(i.reqs, "blob", "mat_sulphur", "Sulphur", 25);
		items.push_back(i);
	}
	{
		AssemblerItem i("mat_dirtybomb", 1, "Dirty Bomb (1)");
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 4);
		AddRequirement(i.reqs, "blob", "mat_mithril", "Mithril", 200);
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
		AssemblerItem i("guidedrocket", 1, "Guided Missile");
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 4);
		AddRequirement(i.reqs, "blob", "mat_oil", "Oil", 40);
		items.push_back(i);
	}
	{
		AssemblerItem i("firejob", 1, "Firejob");
		AddRequirement(i.reqs, "blob", "mat_fuel", "Fuel", 15);
		AddRequirement(i.reqs, "blob", "mat_sulphur", "Sulphur", 50);
		AddRequirement(i.reqs, "blob", "mat_coal", "Coal", 25);
		items.push_back(i);
	}
	{
		AssemblerItem i("mat_sawrocket", 1, "Rocket Propelled Chainsaw");
		AddRequirement(i.reqs, "blob", "mat_fuel", "Fuel", 20);
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 8);
		AddRequirement(i.reqs, "blob", "mat_steelingot", "Steel Ingot", 4);
		AddRequirement(i.reqs, "blob", "mat_sulphur", "Sulphur", 30);
		items.push_back(i);
	}
	{
		AssemblerItem i("mat_mininuke", 1, "L.O.L. Warhead (1)");
		AddRequirement(i.reqs, "blob", "mat_mithrilenriched", "Enriched Mithril", 30);
		AddRequirement(i.reqs, "blob", "mat_mithrilingot", "Mithril Ingot", 4);
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 8);
		AddRequirement(i.reqs, "blob", "mat_steelingot", "Steel Ingot", 4);
		items.push_back(i);
	}
	{
		AssemblerItem i("mat_explonuke", 1, "K.E.K Warhead (1)");
		AddRequirement(i.reqs, "blob", "mat_fuel", "Fuel", 120);
		AddRequirement(i.reqs, "blob", "mat_sulphur", "Sulphur", 150);
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 8);
		AddRequirement(i.reqs, "blob", "mat_steelingot", "Steel Ingot", 4);
		items.push_back(i);
	}
	{
		AssemblerItem i("mat_bombs", 1, "Bomb (1)");
		AddRequirement(i.reqs, "blob", "mat_stone", "Stone", 30);
		AddRequirement(i.reqs, "blob", "mat_sulphur", "Sulphur", 5);
		items.push_back(i);
	}
	{
		AssemblerItem i("mat_dynamite", 2, "Dynamite (2)");
		AddRequirement(i.reqs, "blob", "mat_wood", "Wood", 100);
		AddRequirement(i.reqs, "blob", "mat_sulphur", "Sulphur", 50);
		items.push_back(i);
	}
	{
		AssemblerItem i("mat_fraggrenade", 1, "Fragmentation Grenade (1)");
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 2);
		AddRequirement(i.reqs, "blob", "mat_sulphur", "Sulphur", 35);
		items.push_back(i);
	}
	{
		AssemblerItem i("mat_flashgrenade", 1, "Flash Grenade (1)");
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 2);
		AddRequirement(i.reqs, "blob", "mat_sulphur", "Sulphur", 10);
		items.push_back(i);
	}
	{
		AssemblerItem i("mat_gluegrenade", 1, "Glue Grenade (1)");
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 2);
		AddRequirement(i.reqs, "blob", "mat_coal", "Coal", 5);
		items.push_back(i);
	}
	{
		AssemblerItem i("mat_concretegrenade", 1, "Concrete Grenade (1)");
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 2);
		AddRequirement(i.reqs, "blob", "mat_concrete", "Concrete", 75);
		items.push_back(i);
	}
	{
		AssemblerItem i("mat_highcalshell", 4, "High Caliber Shell (4)");
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 8);
		AddRequirement(i.reqs, "blob", "mat_steelingot", "Steel Ingot", 4);
		AddRequirement(i.reqs, "blob", "mat_sulphur", "Sulphur", 30);
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
	this.addCommandID("SelectPage0");
	this.addCommandID("SelectPage1");
	this.addCommandID("SelectPage2");
	this.addCommandID("assembler_sync");
	
	this.set_bool("InfTask", true);

	this.set_u8("crafting", 0);
	
	this.set_u8("page", 0);
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
		server_Sync(this);
		string CountText = "Production Plan: " + this.get_u16("ProduceTask") + " Items";
		if (this.get_u8("page") == 0)
		{
			CGridMenu@ wmenu = CreateGridMenu(getDriver().getScreenCenterPos() + Vec2f(0.0f, 0.0f), this, Vec2f(12, 5), "Set Assembly");
			if (wmenu !is null)
			{
				AssemblerItem[] items = getItems(this);
				for(uint i = 0; i < 30; i += 1)
				{
					AssemblerItem item = items[i];

					CBitStream pack;
					pack.write_u8(i);

					int teamnum = this.getTeamNum();
					if (teamnum > 6) teamnum = 7;
					AddIconToken("$assembler_icon" + i + "$", "AssemblerIconsWeapons.png", Vec2f(32, 16), i, teamnum);
					string text = "Set to Assemble: " + item.title;
					if(this.get_u8("crafting") == i)
					{
						text = "Already Assembling: " + item.title;
					}
					
					
					CGridButton @butt = wmenu.AddButton("$assembler_icon" + i + "$", text, this.getCommandID("set"), pack);
					butt.hoverText = item.title + "\n" + getButtonRequirementsText(item.reqs, false);
					if(this.get_u8("crafting") == i)
					{
						butt.SetEnabled(false);
					}
				}
			}
		}
		if (this.get_u8("page") == 1)
		{
			CGridMenu@ menu = CreateGridMenu(getDriver().getScreenCenterPos() + Vec2f(0.0f, 0.0f), this, Vec2f(6, 5), "Set Assembly");
			if (menu !is null)
			{
				AssemblerItem[] items = getItems(this);
				this.set_u8("move", 0);
				for(uint i = 30; i < 51; i += 1)
				{
					AssemblerItem item = items[i];
 
					CBitStream pack;
					pack.write_u8(i);

					int teamnum = this.getTeamNum();
					if (teamnum > 6) teamnum = 7;
					
					if (i == 30 || i == 33 || i == 34 || i == 37 || i == 38) //shitcode
					{
						switch(i)
						{
							case 30:
							{
								AddIconToken("$assembler_icone" + (i - 30) + "$", "AssemblerIconsEquipment.png", Vec2f(32, 16), 30, teamnum);
								break;
							}
							case 33:
							{
								AddIconToken("$assembler_icone" + (i - 30) + "$", "AssemblerIconsEquipment.png", Vec2f(32, 16), 32, teamnum);
								break;	
							}
							case 34:
							{
								AddIconToken("$assembler_icone" + (i - 30) + "$", "AssemblerIconsEquipment.png", Vec2f(32, 16), 33, teamnum);
								break;	
							}
							case 37:
							{
								AddIconToken("$assembler_icone" + (i - 30) + "$", "AssemblerIconsEquipment.png", Vec2f(32, 16), 35, teamnum);
								break;	
							}
							case 38:
							{
								AddIconToken("$assembler_icone" + (i - 30) + "$", "AssemblerIconsEquipment.png", Vec2f(32, 16), 36, teamnum);
								break;	
							}
						}
						this.set_u8("move", this.get_u8("move") + 1);
					}
					else
					{
						AddIconToken("$assembler_icone" + (i - 30) + "$", "AssemblerIconsEquipment.png", Vec2f(16, 16), (i + this.get_u8("move")), teamnum);
					}
					
					string text = "Set to Assemble: " + item.title;
					if(this.get_u8("crafting") == i)
					{
						text = "Already Assembling: " + item.title;
					}
					
					CGridButton @butt = menu.AddButton("$assembler_icone" + (i - 30) + "$", text, this.getCommandID("set"), pack);
					butt.hoverText = item.title + "\n" + getButtonRequirementsText(item.reqs, false);
					if(this.get_u8("crafting") == i)
					{
						butt.SetEnabled(false);
					}
				}
			}
		}
		if (this.get_u8("page") == 2)
		{
			CGridMenu@ wmenu = CreateGridMenu(getDriver().getScreenCenterPos() + Vec2f(0.0f, 0.0f), this, Vec2f(7, 5), "Set Assembly");
			if (wmenu !is null)
			{
				AssemblerItem[] items = getItems(this);
				for(uint i = 51; i < items.length; i += 1)
				{
					AssemblerItem item = items[i];

					CBitStream pack;
					pack.write_u8(i);

					int teamnum = this.getTeamNum();
					if (teamnum > 6) teamnum = 7;
					AddIconToken("$assembler_iconex" + (i - 51) + "$", "AssemblerIconsExplosives.png", Vec2f(16, 16), i - 51, teamnum);
					string text = "Set to Assemble: " + item.title;
					if(this.get_u8("crafting") == i)
					{
						text = "Already Assembling: " + item.title;
					}
					
					
					CGridButton @butt = wmenu.AddButton("$assembler_iconex" + (i - 51) + "$", text, this.getCommandID("set"), pack);
					butt.hoverText = item.title + "\n" + getButtonRequirementsText(item.reqs, false);
					if(this.get_u8("crafting") == i)
					{
						butt.SetEnabled(false);
					}
				}
			}
		}
		CGridMenu@ qmenu = CreateGridMenu(getDriver().getScreenCenterPos() + Vec2f(0.0f, 210.0f), this, Vec2f(7, 2), CountText);
		if (qmenu !is null)
		{
			int teamnum = this.getTeamNum();
			for(uint i = 1; i < 15; i += 1)
			{
				if (teamnum > 6) teamnum = 7;
				AddIconToken("$assembler_qicon" + i + "$", "AssemblerIcons2.png", Vec2f(20, 16), i - 1, teamnum);

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
				CBitStream params;
				params.write_u16(caller.getNetworkID());
				CGridButton @butt = qmenu.AddButton("$assembler_qicon" + i + "$", (this.get_string("qtext")), this.getCommandID("IncreaseTask" + i), params);	
			}
		}
		CGridMenu@ pmenu = CreateGridMenu(getDriver().getScreenCenterPos() + Vec2f(0.0f, -180.0f), this, Vec2f(6, 1), "Select Page");
		if (pmenu !is null)
		{
			int teamnum = this.getTeamNum();
			for(uint i = 0; i < 3; i += 1)
			{
				switch(i)
				{
					case 0:
					{
						this.set_string("ptext", "Weapons");
						break;
					}
					case 1:
					{
						this.set_string("ptext", "Equipment");
						break;
					}
					case 2:
					{
						this.set_string("ptext", "Explosives");
						break;
					}
				}
					
				if (teamnum > 6) teamnum = 7;
				AddIconToken("$assembler_picon" + i + "$", "AssemblerPages.png", Vec2f(32, 16), i, teamnum);
				CBitStream params;
				params.write_u16(caller.getNetworkID());
				CGridButton @butt = pmenu.AddButton("$assembler_picon" + i + "$", (this.get_string("ptext")), this.getCommandID("SelectPage" + i), params);
				if(this.get_u8("page") == (i))
				{
					butt.SetEnabled(false);
				}
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
	else if (cmd == this.getCommandID("IncreaseTask1"))
	{
		IncreaseTask(this, 1);
		CBlob@ caller = getBlobByNetworkID(params.read_u16());
		if (caller is null) return;
		AssemblerMenu(this, caller);
	}
	else if (cmd == this.getCommandID("IncreaseTask2"))
	{
		IncreaseTask(this, 5);
		CBlob@ caller = getBlobByNetworkID(params.read_u16());
		if (caller is null) return;
		AssemblerMenu(this, caller);
	}
	else if (cmd == this.getCommandID("IncreaseTask3"))
	{
		IncreaseTask(this, 10);
		CBlob@ caller = getBlobByNetworkID(params.read_u16());
		if (caller is null) return;
		AssemblerMenu(this, caller);
	}
	else if (cmd == this.getCommandID("IncreaseTask4"))
	{
		IncreaseTask(this, 20);
		CBlob@ caller = getBlobByNetworkID(params.read_u16());
		if (caller is null) return;
		AssemblerMenu(this, caller);
	}
	else if (cmd == this.getCommandID("IncreaseTask5"))
	{
		IncreaseTask(this, 50);
		CBlob@ caller = getBlobByNetworkID(params.read_u16());
		if (caller is null) return;
		AssemblerMenu(this, caller);
	}
	else if (cmd == this.getCommandID("IncreaseTask6"))
	{
		IncreaseTask(this, 100);
		CBlob@ caller = getBlobByNetworkID(params.read_u16());
		if (caller is null) return;
		AssemblerMenu(this, caller);
	}
	else if (cmd == this.getCommandID("IncreaseTask7"))
	{
		TaskSetInf(this);
		CBlob@ caller = getBlobByNetworkID(params.read_u16());
		if (caller is null) return;
		AssemblerMenu(this, caller);
	}
	else if (cmd == this.getCommandID("IncreaseTask8"))
	{
		DecreaseTask(this, 1);
		CBlob@ caller = getBlobByNetworkID(params.read_u16());
		if (caller is null) return;
		AssemblerMenu(this, caller);
	}
	else if (cmd == this.getCommandID("IncreaseTask9"))
	{
		DecreaseTask(this, 5);
		CBlob@ caller = getBlobByNetworkID(params.read_u16());
		if (caller is null) return;
		AssemblerMenu(this, caller);
	}
	else if (cmd == this.getCommandID("IncreaseTask10"))
	{
		DecreaseTask(this, 10);
		CBlob@ caller = getBlobByNetworkID(params.read_u16());
		if (caller is null) return;
		AssemblerMenu(this, caller);
	}
	else if (cmd == this.getCommandID("IncreaseTask11"))
	{
		DecreaseTask(this, 20);
		CBlob@ caller = getBlobByNetworkID(params.read_u16());
		if (caller is null) return;
		AssemblerMenu(this, caller);
	}
	else if (cmd == this.getCommandID("IncreaseTask12"))
	{
		DecreaseTask(this, 50);
		CBlob@ caller = getBlobByNetworkID(params.read_u16());
		if (caller is null) return;
		AssemblerMenu(this, caller);
	}
	else if (cmd == this.getCommandID("IncreaseTask13"))
	{
		DecreaseTask(this, 100);
		CBlob@ caller = getBlobByNetworkID(params.read_u16());
		if (caller is null) return;
		AssemblerMenu(this, caller);
	}
	else if (cmd == this.getCommandID("IncreaseTask14"))
	{
		TaskReset(this);
		CBlob@ caller = getBlobByNetworkID(params.read_u16());
		if (caller is null) return;
		AssemblerMenu(this, caller);
	}
	else if (cmd == this.getCommandID("SelectPage0"))
	{
		CBlob@ caller = getBlobByNetworkID(params.read_u16());
		if (caller is null) return;
		this.set_u8("page", 0);
		caller.ClearMenus();
		AssemblerMenu(this, caller);
	}
	else if (cmd == this.getCommandID("SelectPage1"))
	{
		CBlob@ caller = getBlobByNetworkID(params.read_u16());
		if (caller is null) return;
		this.set_u8("page", 1);
		caller.ClearMenus();
		AssemblerMenu(this, caller);
	}
	else if (cmd == this.getCommandID("SelectPage2"))
	{
		CBlob@ caller = getBlobByNetworkID(params.read_u16());
		if (caller is null) return;
		this.set_u8("page", 2);
		caller.ClearMenus();
		AssemblerMenu(this, caller);
	}
	else if (cmd == this.getCommandID("assembler_sync"))
	{
		if (isClient())
		{
			u16 task = params.read_u16();
			string dtxt = params.read_string();
			bool inf = params.read_bool();
			string qtxt = params.read_string();
			
			this.set_string("DrawText", dtxt);
			this.set_string("qtext", qtxt);
			this.set_u16("ProduceTask", task);
			this.set_bool("InfTask", inf);		
		}
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
			if (item.resultname == "lightarmor")
			{
				CBlob @mat1 = server_CreateBlob("combatboots", this.getTeamNum(), this.getPosition());
				CBlob @mat2= server_CreateBlob("lightvest", this.getTeamNum(), this.getPosition());
				CBlob @mat3 = server_CreateBlob("lighthelmet", this.getTeamNum(), this.getPosition());
			}
			else if (item.resultname == "armor")
			{
				CBlob @mat1 = server_CreateBlob("combatboots", this.getTeamNum(), this.getPosition());
				CBlob @mat2 = server_CreateBlob("bulletproofvest", this.getTeamNum(), this.getPosition());
				CBlob @mat3 = server_CreateBlob("militaryhelmet", this.getTeamNum(), this.getPosition());
			}
			else if (item.resultname == "compositearmor")
			{
				CBlob @mat1 = server_CreateBlob("compositeboots", this.getTeamNum(), this.getPosition());
				CBlob @mat2 = server_CreateBlob("compositevest", this.getTeamNum(), this.getPosition());
				CBlob @mat3 = server_CreateBlob("compositehelmet", this.getTeamNum(), this.getPosition());
			}
			else
			{
				CBlob @mat = server_CreateBlob(item.resultname, this.getTeamNum(), this.getPosition());
				mat.server_SetQuantity(item.resultcount);
			}

			server_TakeRequirements(inv, item.reqs);
		}
		if (!this.get_bool("InfTask"))
		{
			DecreaseTask(this, item.resultcount);
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
	server_Sync(this);
	this.set_u16("ProduceTask", (this.get_u16("ProduceTask") + incr_quantity));
	this.set_bool("InfTask", false);
	this.set_string("drawText", "Production Plan: " + (this.get_u16("ProduceTask")) + " Items");
}

void DecreaseTask(CBlob@ this, u16 incr_quantity)
{
	server_Sync(this);
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
	server_Sync(this);
	this.set_u16("ProduceTask", 0);
	this.set_bool("InfTask", false);
	this.set_string("drawText", "Production Plan: " + (this.get_u16("ProduceTask")) + " Items");
	server_Sync(this);
}

void TaskSetInf(CBlob@ this)
{
	server_Sync(this);
	this.set_bool("InfTask", !this.get_bool("InfTask"));
	if (this.get_bool("InfTask"))
	{
		this.set_string("drawText", "Production Plan: Unlimited");
	}
	else
	{
		this.set_string("drawText", "Production Plan: " + (this.get_u16("ProduceTask")) + " Items");
	}
	server_Sync(this);
}

void SelectPage(CBlob@ this, u16 page_number)
{
	this.set_u8("page", (page_number));
}

void server_Sync(CBlob@ this)
{
	if (isServer())
	{
		CBitStream stream;
		stream.write_u16(this.get_u16("ProduceTask"));
		stream.write_string(this.get_string("DrawText"));
		stream.write_bool(this.get_bool("InfTask"));
		stream.write_string(this.get_string("qtext"));
		
		this.SendCommand(this.getCommandID("assembler_sync"), stream);
	}
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

	if (isMat && !blob.isAttached())
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