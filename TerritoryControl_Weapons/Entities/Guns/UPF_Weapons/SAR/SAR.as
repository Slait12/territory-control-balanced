#include "GunCommon.as";
#include "MakeMat.as";

f32 onHit(CBlob@ this, Vec2f worldPoint, Vec2f velocity, f32 damage, CBlob@ hitterBlob, u8 customData)
{
	if (this.isAttached()) return 0;
	return damage;
}

void onInit(CBlob@ this)
{
	this.addCommandID("switch");
	GunSettings settings = GunSettings();

	//General
	//settings.CLIP = 0; //Amount of ammunition in the gun at creation
	settings.TOTAL = 20; //Max amount of ammo that can be in a clip
	settings.FIRE_INTERVAL = 3; //Time in between shots
	settings.RELOAD_TIME = 60; //Time it takes to reload (in ticks)
	settings.AMMO_BLOB = "mat_rifleammo"; //Ammunition the gun takes

	//Bullet
	//settings.B_PER_SHOT = 1; //Shots per bullet | CHANGE B_SPREAD, otherwise both bullets will come out together
	//settings.B_GRAV = Vec2f(0, 0.001); //Bullet gravity drop
	settings.B_SPEED = 90; //Bullet speed, STRONGLY AFFECTED/EFFECTS B_GRAV
	settings.B_TTL = 30; //TTL = 'Time To Live' which determines the time the bullet lasts before despawning
	settings.B_DAMAGE = 1.75f; //1 is 1 heart
	settings.B_TYPE = HittersTC::bullet_high_cal; //Type of bullet the gun shoots | hitter
	
	//Spread & Cursor
	settings.B_SPREAD = 1; //the higher the value, the more 'uncontrollable' bullets get
	settings.INCREASE_SPREAD = true; //Should the spread increase as you shoot. Default is false
	settings.SPREAD_FACTOR = 0.8; //How much spread will increase as you shoot. Formula of increasing is: B_SPREAD * Max:(SPREAD_FACTOR, (Number of shoots * SPREAD_FACTOR)). Does not affect cursor.
	settings.MAX_SPREAD = 7; //Maximum spread the weapon can reach. Also determines how big cursor can become
	settings.CURSOR_SIZE = 10; //Size of crosshair that appear when you hold a Gun
	settings.ENLARGE_CURSOR = true; //Should we enlarge cursor as you shoot. Default is true
	settings.ENLARGE_FACTOR = 1; //Multiplier of how much cursor will enlarge as you shoot.


	//Recoil
	settings.G_RECOIL = -10; //0 is default, adds recoil aiming up
	settings.G_RANDOMX = true; //Should we randomly move x
	settings.G_RANDOMY = false; //Should we randomly move y, it ignores g_recoil
	settings.G_RECOILT = 6; //How long should recoil last, 10 is default, 30 = 1 second (like ticks)
	settings.G_BACK_T = 1; //Should we recoil the arm back time? (aim goes up, then back down with this, if > 0, how long should it last)

	//Sound
	settings.FIRE_SOUND = "SAR_Shoot.ogg"; //Sound when shooting
	settings.RELOAD_SOUND = "SAR_Reloading.ogg"; //Sound when reloading

	//Offset
	settings.MUZZLE_OFFSET = Vec2f(-18, -1.5); //Where the muzzle flash appears

	this.set("gun_settings", @settings);

	//Custom
	this.Tag("CustomSemiAuto");
	this.set_u8("CustomKnock", 2);
	this.Tag("powerful");
	this.set_string("CustomSoundPickup", "SAR_Pickup.ogg");
	this.set_bool("mode", false);
}

void onTick(CBlob@ this)
{
	if (this.isAttached())
	{
		AttachmentPoint@ point = this.getAttachments().getAttachmentPointByName("PICKUP");
		CBlob@ holder = point.getOccupied();
		
		if (holder is null) return;

		if (point.isKeyJustPressed(key_action2))
		{
			CBitStream params;
			this.SendCommand(this.getCommandID("switch"), params);
		}
	}
}

void onCommand(CBlob@ this, u8 cmd, CBitStream @params)
{
	if (cmd == this.getCommandID("switch"))
	{
		if(this.get_u8("actionInterval") == 0)
		{
			AttachmentPoint@ point = this.getAttachments().getAttachmentPointByName("PICKUP");
			CBlob@ holder = point.getOccupied();
			if (holder is null) return;
			print("ayy");
			
			if (!this.get_bool("mode"))
			{
				GunSettings settings = GunSettings();
				
				//General
				//settings.CLIP = 0; //Amount of ammunition in the gun at creation
				settings.TOTAL = 5; //Max amount of ammo that can be in a clip
				settings.FIRE_INTERVAL = 0.9; //Time in between shots
				settings.RELOAD_TIME = 15; //Time it takes to reload (in ticks)
				settings.AMMO_BLOB = "mat_rifleammo"; //Ammunition the gun takes

				//Bullet
				//settings.B_PER_SHOT = 1; //Shots per bullet | CHANGE B_SPREAD, otherwise both bullets will come out together
				//settings.B_GRAV = Vec2f(0, 0.001); //Bullet gravity drop
				settings.B_SPEED = 90; //Bullet speed, STRONGLY AFFECTED/EFFECTS B_GRAV
				settings.B_TTL = 30; //TTL = 'Time To Live' which determines the time the bullet lasts before despawning
				settings.B_DAMAGE = 1.75f; //1 is 1 heart
				settings.B_TYPE = HittersTC::bullet_high_cal; //Type of bullet the gun shoots | hitter
				
				//Spread & Cursor
				settings.B_SPREAD = 1; //the higher the value, the more 'uncontrollable' bullets get
				//settings.INCREASE_SPREAD = false; //Should the spread increase as you shoot. Default is false
				settings.SPREAD_FACTOR = 0.0; //How much spread will increase as you shoot. Formula of increasing is: B_SPREAD * Max:(SPREAD_FACTOR, (Number of shoots * SPREAD_FACTOR)). Does not affect cursor.
				settings.MAX_SPREAD = 7; //Maximum spread the weapon can reach. Also determines how big cursor can become
				settings.CURSOR_SIZE = 10; //Size of crosshair that appear when you hold a Gun
				settings.ENLARGE_CURSOR = true; //Should we enlarge cursor as you shoot. Default is true
				settings.ENLARGE_FACTOR = 2; //Multiplier of how much cursor will enlarge as you shoot.
					
				//Recoil
				settings.G_RECOIL = -10; //0 is default, adds recoil aiming up
				settings.G_RANDOMX = false; //Should we randomly move x
				settings.G_RANDOMY = false; //Should we randomly move y, it ignores g_recoil
				settings.G_RECOILT = 6; //How long should recoil last, 10 is default, 30 = 1 second (like ticks)
				settings.G_BACK_T = 1; //Should we recoil the arm back time? (aim goes up, then back down with this, if > 0, how long should it last)

				//Sound
				settings.FIRE_SOUND = "SAR_Shoot.ogg"; //Sound when shooting
				settings.RELOAD_SOUND = ""; //Sound when reloading

				//Offset
				settings.MUZZLE_OFFSET = Vec2f(-18, -1.5); //Where the muzzle flash appears

				this.set("gun_settings", @settings);
				
				this.Untag("CustomSemiAuto");
				this.set_bool("mode", true);
				print("66ayy");
			}
			else
			{
				GunSettings settings = GunSettings();

				//General
				//settings.CLIP = 0; //Amount of ammunition in the gun at creation
				settings.TOTAL = 20; //Max amount of ammo that can be in a clip
				settings.FIRE_INTERVAL = 3; //Time in between shots
				settings.RELOAD_TIME = 60; //Time it takes to reload (in ticks)
				settings.AMMO_BLOB = "mat_rifleammo"; //Ammunition the gun takes

				//Bullet
				//settings.B_PER_SHOT = 1; //Shots per bullet | CHANGE B_SPREAD, otherwise both bullets will come out together
				//settings.B_GRAV = Vec2f(0, 0.001); //Bullet gravity drop
				settings.B_SPEED = 90; //Bullet speed, STRONGLY AFFECTED/EFFECTS B_GRAV
				settings.B_TTL = 30; //TTL = 'Time To Live' which determines the time the bullet lasts before despawning
				settings.B_DAMAGE = 1.75f; //1 is 1 heart
				settings.B_TYPE = HittersTC::bullet_high_cal; //Type of bullet the gun shoots | hitter
					
				//Spread & Cursor
				settings.B_SPREAD = 1; //the higher the value, the more 'uncontrollable' bullets get
				settings.INCREASE_SPREAD = true; //Should the spread increase as you shoot. Default is false
				settings.SPREAD_FACTOR = 0.8; //How much spread will increase as you shoot. Formula of increasing is: B_SPREAD * Max:(SPREAD_FACTOR, (Number of shoots * SPREAD_FACTOR)). Does not affect cursor.
				settings.MAX_SPREAD = 7; //Maximum spread the weapon can reach. Also determines how big cursor can become
				settings.CURSOR_SIZE = 10; //Size of crosshair that appear when you hold a Gun
				settings.ENLARGE_CURSOR = true; //Should we enlarge cursor as you shoot. Default is true
				settings.ENLARGE_FACTOR = 1; //Multiplier of how much cursor will enlarge as you shoot.


				//Recoil
				settings.G_RECOIL = -10; //0 is default, adds recoil aiming up
				settings.G_RANDOMX = true; //Should we randomly move x
				settings.G_RANDOMY = false; //Should we randomly move y, it ignores g_recoil
				settings.G_RECOILT = 6; //How long should recoil last, 10 is default, 30 = 1 second (like ticks)
				settings.G_BACK_T = 1; //Should we recoil the arm back time? (aim goes up, then back down with this, if > 0, how long should it last)

				//Sound
				settings.FIRE_SOUND = "SAR_Shoot.ogg"; //Sound when shooting
				settings.RELOAD_SOUND = "SAR_Reloading.ogg"; //Sound when reloading

				//Offset
				settings.MUZZLE_OFFSET = Vec2f(-18, -1.5); //Where the muzzle flash appears

				this.set("gun_settings", @settings);

				//Custom
				this.Tag("CustomSemiAuto");
				this.set_bool("mode", false);
				print("ayy22");
			}
			if (isServer())
			{
				CBlob@ mat = server_CreateBlob("mat_rifleammo", -1, holder.getPosition());//give back ammo
				mat.server_SetQuantity(this.get_u8("clip"));
			}
			this.set_u8("clip", 0); //unload gun
			this.set_u8("actionInterval", 3);
			if(isClient())
			{
				this.getSprite().PlaySound("AK47Cycle.ogg", 3.00f, 1.00f);
			}
		}
	}
}