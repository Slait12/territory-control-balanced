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
	settings.CLIP = 6; //Amount of ammunition in the gun at creation
	settings.TOTAL = 6; //Max amount of ammo that can be in a clip
	settings.FIRE_INTERVAL = 5; //Time in between shots
	settings.RELOAD_TIME = 9; //Time it takes to reload (in ticks)
	settings.AMMO_BLOB = "mat_pistolammo"; //Ammunition the gun takes

	//Bullet
	//settings.B_PER_SHOT = 1; //Shots per bullet | CHANGE B_SPREAD, otherwise both bullets will come out together
	settings.B_SPREAD = 3; //the higher the value, the more 'uncontrollable' bullets get
	//settings.B_GRAV = Vec2f(0, 0.001); //Bullet gravity drop
	settings.B_SPEED = 90; //Bullet speed, STRONGLY AFFECTED/EFFECTS B_GRAV
	settings.B_TTL = 12; //TTL = 'Time To Live' which determines the time the bullet lasts before despawning
	settings.B_DAMAGE = 1.25f; //1 is 1 heart
	settings.B_TYPE = HittersTC::bullet_low_cal; //Type of bullet the gun shoots | hitter

	//Recoil
	settings.G_RECOIL = -5; //0 is default, adds recoil aiming up
	settings.G_RANDOMX = true; //Should we randomly move x
	settings.G_RANDOMY = false; //Should we randomly move y, it ignores g_recoil
	settings.G_RECOILT = 4; //How long should recoil last, 10 is default, 30 = 1 second (like ticks)
	settings.G_BACK_T = 3; //Should we recoil the arm back time? (aim goes up, then back down with this, if > 0, how long should it last)

	//Sound
	settings.FIRE_SOUND = "RevolverFire.ogg"; //Sound when shooting
	settings.RELOAD_SOUND = "LeverRifle_load.ogg"; //Sound when reloading

	//Offset
	settings.MUZZLE_OFFSET = Vec2f(-13, -3); //Where the muzzle flash appears

	this.Tag("CustomSemiAuto");

	this.set("gun_settings", @settings);

	//Custom
	this.set_string("CustomReloadingEnding", "BigIron_LoadEnding");
	this.Tag("CustomShotgunReload");
	this.Tag("pistol");
	this.set_string("CustomSoundPickup", "Revolver_Pickup.ogg");
}
