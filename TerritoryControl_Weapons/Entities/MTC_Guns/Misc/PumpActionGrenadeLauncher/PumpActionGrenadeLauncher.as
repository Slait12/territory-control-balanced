#include "GunCommon.as";

f32 onHit(CBlob@ this, Vec2f worldPoint, Vec2f velocity, f32 damage, CBlob@ hitterBlob, u8 customData)
{
	if (this.isAttached()) return 0;
	return damage;
}

void onInit(CBlob@ this)
{
	GunSettings settings = GunSettings();
	this.addCommandID("set_grenade");

	//General
	//settings.CLIP = 0; //Amount of ammunition in the gun at creation
	settings.TOTAL = 1; //Max amount of ammo that can be in a clip
	settings.FIRE_INTERVAL = 20; //Time in between shots
	settings.RELOAD_TIME = 45; //Time it takes to reload (in ticks)
	settings.AMMO_BLOB = "mat_grenade"; //Ammunition the gun takes

	//Bullet
	settings.B_PER_SHOT = 1; //Shots per bullet | CHANGE B_SPREAD, otherwise both bullets will come out together
	settings.B_SPREAD = 0; //the higher the value, the more 'uncontrollable' bullets get
	//settings.B_GRAV = Vec2f(0, 0.001); //Bullet gravity drop
	settings.B_SPEED = 12; //Bullet speed, STRONGLY AFFECTED/EFFECTS B_GRAV
	//settings.B_TTL = 100; //TTL = 'Time To Live' which determines the time the bullet lasts before despawning
	//settings.B_DAMAGE = 7f; //1 is 1 heart
	//settings.B_TYPE = HittersTC::bullet_high_cal; //Type of bullet the gun shoots | hitter

	//Recoil
	settings.G_RECOIL = -7; //0 is default, adds recoil aiming up
	//settings.G_RANDOMX = true; //Should we randomly move x
	//settings.G_RANDOMY = false; //Should we randomly move y, it ignores g_recoil
	settings.G_RECOILT = 7; //How long should recoil last, 10 is default, 30 = 1 second (like ticks)
	settings.G_BACK_T = 6; //Should we recoil the arm back time? (aim goes up, then back down with this, if > 0, how long should it last)

	//Sound
	settings.FIRE_SOUND = "GrenadeLauncherFire.ogg"; //Sound when shooting
	settings.RELOAD_SOUND = "GrenadeLauncherCycle.ogg"; //Sound when reloading

	//Offset
	settings.MUZZLE_OFFSET = Vec2f(-11.5, 1); //Where the muzzle flash appears

	this.set("gun_settings", @settings);

	//Custom
	this.set_string("CustomCase", "");
	this.set_string("CustomFlash", "");
	this.set_string("ProjBlob", "grenade");
	this.set_u8("clickReload", 0); //'Click' moment after shooting
	this.set_string("CustomSoundPickup", "Boomstick_Pickup.ogg");
}

void GetButtonsFor(CBlob@ this, CBlob@ caller)
{
	if (this.getDistanceTo(caller) > 96.0f) return;
	CBlob@ carried = caller.getCarriedBlob();
	if (this.isAttached()) return;
	if (this.get_u8("clip") > 0) return;
	CBitStream params;

	params.write_u16(caller.getNetworkID());
	CButton@ button = caller.CreateGenericButton(17, Vec2f(0, 0), this, this.getCommandID("set_grenade"), "Change grenade type", params);
	if (button !is null) button.SetEnabled(carried !is null && (carried.getName() == "mat_grenade" || carried.getName() == "mat_stickygrenade" || carried.getName() == "mat_acidgrenade" || carried.getName() == "mat_flamegrenade"));
}



void onCommand(CBlob@ this, u8 cmd, CBitStream @params)
{
	if (cmd == this.getCommandID("set_grenade"))
	{
		u16 netid = params.read_u16();
		CBlob@ caller = getBlobByNetworkID(netid);
		GunSettings@ settings;
		if (!this.get("gun_settings", @settings)) return;

		if (caller !is null && settings !is null)
		{
			CBlob@ carried = caller.getCarriedBlob();
			if (carried !is null)
			{
				if (carried.getName() == "mat_stickygrenade")
				{
					this.setInventoryName("Grenade Launcher (Sticky Grenade)");
					settings.AMMO_BLOB = "mat_stickygrenade";
					this.set_string("ProjBlob", "stickygrenade");
				}
				else if (carried.getName() == "mat_grenade")
				{
					this.setInventoryName("Grenade Launcher (Grenade)");
					settings.AMMO_BLOB = "mat_grenade";
					this.set_string("ProjBlob", "grenade");
				}
				else if (carried.getName() == "mat_acidgrenade")
				{
					this.setInventoryName("Grenade Launcher (Acid Grenade)");
					settings.AMMO_BLOB = "mat_acidgrenade";
					this.set_string("ProjBlob", "acidgrenade");
				}
				else if (carried.getName() == "mat_flamegrenade")
				{
					this.setInventoryName("Grenade Launcher (Flame Grenade)");
					settings.AMMO_BLOB = "mat_flamegrenade";
					this.set_string("ProjBlob", "flamegrenade");
				}
			}
			this.set_u8("clip", 0);
			this.set("gun_settings", @settings);
		}
	}
}
