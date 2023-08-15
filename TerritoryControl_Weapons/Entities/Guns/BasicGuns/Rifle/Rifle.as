#include "GunCommon.as";

f32 onHit(CBlob@ this, Vec2f worldPoint, Vec2f velocity, f32 damage, CBlob@ hitterBlob, u8 customData)
{
	if (this.isAttached()) return 0;
	return damage;
}

void onInit(CBlob@ this)
{
	GunSettings settings = GunSettings();

	//General
	settings.CLIP = 5; //Amount of ammunition in the gun at creation
	settings.TOTAL = 5; //Max amount of ammo that can be in a clip
	settings.FIRE_INTERVAL = 40; //Time in between shots
	settings.RELOAD_TIME = 55; //Time it takes to reload (in ticks)
	settings.AMMO_BLOB = "mat_rifleammo"; //Ammunition the gun takes

	//Bullet
	settings.B_PER_SHOT = 1; //Shots per bullet | CHANGE B_SPREAD, otherwise both bullets will come out together
	//settings.B_SPREAD = 0; //the higher the value, the more 'uncontrollable' bullets get
	settings.B_GRAV = Vec2f(0, 0.001); //Bullet gravity drop
	settings.B_SPEED = 90; //Bullet speed, STRONGLY AFFECTED/EFFECTS B_GRAV
	settings.B_TTL = 100; //TTL = 'Time To Live' which determines the time the bullet lasts before despawning
	settings.B_DAMAGE = 3.5f; //1 is 1 heart
	settings.B_TYPE = HittersTC::bullet_high_cal; //Type of bullet the gun shoots | hitter

	//Recoil
	settings.G_RECOIL = -10; //0 is default, adds recoil aiming up
	//settings.G_RANDOMX = true; //Should we randomly move x
	//settings.G_RANDOMY = false; //Should we randomly move y, it ignores g_recoil
	settings.G_RECOILT = 7; //How long should recoil last, 10 is default, 30 = 1 second (like ticks)
	settings.G_BACK_T = 6; //Should we recoil the arm back time? (aim goes up, then back down with this, if > 0, how long should it last)

	//Sound
	settings.FIRE_SOUND = "RifleFire.ogg"; //Sound when shooting
	settings.RELOAD_SOUND = "RifleReload.ogg"; //Sound when reloading

	//Offset
	settings.MUZZLE_OFFSET = Vec2f(-19, -2); //Where the muzzle flash appears

	this.set("gun_settings", @settings);

	//Custom
	this.set_f32("scope_zoom", 0.050f);
	this.set_string("CustomCycle", "RifleCycle");
	this.set_u8("CustomKnock", 10);
	this.set_u8("CustomPenetration", 2);
	this.Tag("sniper");
	this.set_string("CustomSoundPickup", "Rifle_Pickup.ogg");
	this.set_u8("AmmoTypeNumber", 0);
	
	
	this.set_u32("showTime", 0);
}

void onTick(CBlob@ this)
{
	if (this.isAttached())
	{
		AttachmentPoint@ point = this.getAttachments().getAttachmentPointByName("PICKUP");
		CBlob@ holder = point.getOccupied();
		
		GunSettings@ settings;
		if (!this.get("gun_settings", @settings)) return;
		
		if (holder is null) return;
		
		if (point.isKeyJustPressed(key_action2) && !this.get_bool("doReload"))
		{
			CInventory@ inv = holder.getInventory();
			
			if (inv !is null)
			{ 	
				u16 items = inv.getItemsCount();
				u8 mode = this.get_u8("AmmoTypeNumber");
				bool end = false;
				for (u16 q = 0; q < 4; q++)
				{
					if (mode == 0)
					{
						for (u16 i = 0; i < items; i++)
						{
							CBlob@ item = inv.getItem(i);
							if (item is null) continue;
							if (item.getName() == "mat_stickygrenade") 
							{
								settings.AMMO_BLOB = "mat_stickygrenade";
								this.set_u8("AmmoTypeNumber", 1);
								bool end = true;
								this.set_string("DrawText", "Sticky Grenade");
								this.set_u32("ShowTime", getGameTime() + 60);
								if(isClient())
								{
									this.getSprite().PlaySound("AK47Cycle.ogg", 3.00f, 1.00f);
								}
								return;
							}
						}
					}
					if (mode == 1)
					{	
						for (u16 i = 0; i < items; i++)
						{
							CBlob@ item = inv.getItem(i);
							if (item is null) continue;
							if (item.getName() == "mat_flamegrenade") 
							{
								settings.AMMO_BLOB = "mat_flamegrenade";
								this.set_u8("AmmoTypeNumber", 2);
								bool end = true;
								this.set_string("DrawText", "Flame Grenade");
								this.set_u32("ShowTime", getGameTime() + 60);
								if(isClient())
								{
									this.getSprite().PlaySound("AK47Cycle.ogg", 3.00f, 1.00f);
								}
								return;
							}
						}
					}
					if (mode == 2)
					{
						for (u16 i = 0; i < items; i++)
						{
							CBlob@ item = inv.getItem(i);
							if (item is null) continue;
							if (item.getName() == "mat_acidgrenade") 
							{
								settings.AMMO_BLOB = "mat_acidgrenade";
								this.set_u8("AmmoTypeNumber", 3);
								bool end = true;
								this.set_string("DrawText", "Acid Grenade");
								this.set_u32("ShowTime", getGameTime() + 60);
								if(isClient())
								{
									this.getSprite().PlaySound("AK47Cycle.ogg", 3.00f, 1.00f);
								}
								return;
							}
						}
					}
					if (mode == 3)
					{
						for (u16 i = 0; i < items; i++)
						{
							CBlob@ item = inv.getItem(i);
							if (item is null) continue;	
							if (item.getName() == "mat_grenade") 
							{
								settings.AMMO_BLOB = "mat_grenade";
								this.set_u8("AmmoTypeNumber", 0);
								bool end = true;
								this.set_string("DrawText", "Grenade");
								this.set_u32("ShowTime", getGameTime() + 60);
								if(isClient())
								{
									this.getSprite().PlaySound("AK47Cycle.ogg", 3.00f, 1.00f);
								}
								return;
							}
						}
					}
					mode++;
					if (end)
					{
						this.Sync("ProjBlob", true);
						this.Sync("settings.AMMO_BLOB", true);
						this.Sync("AmmoTypeNumber", true);
						return;
					}
				}
			}
		}
	}
}

void onAttach(CBlob@ this, CBlob@ attached, AttachmentPoint @attachedPoint)
{
	CPlayer@ player = attached.getPlayer();
	if (player !is null)
	this.set_u16("showHeatTo", player.getNetworkID());
}

void onRender(CSprite@ this)
{
	CBlob@ blob = this.getBlob();
	
	u16 holderID = blob.get_u16("showHeatTo");
	
	CPlayer@ holder = holderID == 0 ? null : getPlayerByNetworkId(holderID);
	if (holder is null){return;}
	
	CBlob@ holderBlob = holder.getBlob();
	
	string drawtext = blob.get_string("DrawText");
	u32 showtime = blob.get_u32("ShowTime");
	if (showtime > getGameTime())
	{
		Vec2f pos = holderBlob.getInterpolatedScreenPos() + (blob.getScreenPos() - holderBlob.getScreenPos()) + Vec2f(0, -40);
		GUI::DrawTextCentered("Ammo: " + drawtext, pos, SColor(255, 255, 255, 255));
		return;
	}
}