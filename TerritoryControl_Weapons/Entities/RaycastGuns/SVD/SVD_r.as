#include "Hitters.as";
#include "HittersTC.as";
#include "CommonGun.as";

void onInit(CBlob@ this)
{
	GunInitRaycast
	(
		this,
		false,				//If true, gun will be fully automatic and players will be able to just hold the fire button
		2.75f,				//Weapon damage / projectile blob name
		700.0f,				//Weapon raycast range
		40,					//Weapon fire delay, in ticks
		10,					//Weapon clip size
		1.00f,				//Ammo usage factor, completely ignore for now
		60,					//Weapon reload time
		false,				//If true, gun will be reloaded like a shotgun
		0,					//For shotguns: Additional delay to reload end
		4,					// Bullet count - for shotguns
		0.0f,				// Bullet Jitter
		"mat_sniperammo",	//Ammo item blob name
		false,				//If true, firing sound will be looped until player stops firing
		SoundInfo("DragunovaFire", 1, 1.0f, 1.0f),	//Sound to play when firing
		SoundInfo("SniperReload", 1, 1.0f, 1.0f),//Sound to play when reloading
		SoundInfo(),							//Sound to play some time after firing
		0,					//Delay for the delayed sound, in ticks
		Vec2f(-7.0f, -1.0f)	//Visual offset for raycast bullets
	);
	
	this.set_u8("gun_hitter", HittersTC::bullet_high_cal);
	
	
	this.set_f32("scope_zoom", 0.005f);
	this.Tag("sniper");
	this.Tag("powerful");
	this.set_u8("CustomPenetration", 1);
	this.set_u8("CustomKnock", 10);
}

void onTick(CBlob@ this)
{
	GunTick(this);
}