#include "Hitters.as";
#include "Explosion.as";

string[] particles =
{
	"SmallSmoke1.png",
	"SmallSmoke2.png",
	"SmallExplosion1.png",
	"SmallExplosion2.png",
	"SmallExplosion3.png",
	"SmallFire1.png",
	"SmallFire2.png"
};

void onInit(CBlob@ this)
{
	this.addCommandID("offblast");

	this.set_f32("map_damage_ratio", 0.3f);
	this.set_f32("map_damage_radius", 32.0f);
	this.set_string("custom_explosion_sound", "Keg.ogg");

	this.set_u16("grenade timer", 70);
	this.Tag("map_damage_dirt");
	this.Tag("projectile");

	this.getShape().SetRotationsAllowed(true);
}

void onTick(CBlob@ this)
{
	if(!this.hasTag("grenade collided"))
	{
		this.setAngleDegrees(-this.getVelocity().Angle());
	}

	u16 grenadeTimer = this.get_u16("grenade timer");

	if(grenadeTimer == 0)
	{
		this.server_Die();
	}

	if(grenadeTimer >= 0)
	{
		this.set_u16("grenade timer", grenadeTimer - 1);
	}
}

void onDie(CBlob@ this)
{
	DoExplosion(this);
}

bool doesCollideWithBlob(CBlob@ this, CBlob@ blob)
{
	return this.getTeamNum() != blob.getTeamNum() && blob.isCollidable() ;
}

void onCollision(CBlob@ this, CBlob@ blob, bool solid)
{
	if (solid)
	{
		this.Tag("grenade collided");
		if (isClient() && !this.hasTag("dead") && this.getOldVelocity().Length() > 2.0f) this.getSprite().PlaySound("launcher_boing" + XORRandom(2), 0.2f, 1.0f);

		if (blob !is null && doesCollideWithBlob(this, blob) && (blob.hasTag("flesh") || blob.hasTag("vehicle"))) this.server_Die();
	}
}

bool canBePickedUp(CBlob@ this, CBlob@ byBlob)
{
	return false;
}

void DoExplosion(CBlob@ this)
{
	CRules@ rules = getRules();
	if (!shouldExplode(this, rules))
	{
		addToNextTick(this, rules, DoExplosion);
		return;
	}
	f32 random = XORRandom(16);
	f32 modifier = 1 + Maths::Log(this.getQuantity());
	Vec2f pos = this.getPosition();
	CMap@ map = getMap();
	f32 angle = this.getAngleDegrees() - this.get_f32("bomb angle");
	this.set_f32("map_damage_radius", (24.0f + random) * modifier);
	this.set_f32("map_damage_ratio", 0.25f);
	Explode(this, 24.0f + random, 3.0f);
	if (isServer())
	{
		CBlob@[] blobs;

		if (map.getBlobsInRadius(pos, 32.0f, @blobs))
		{
			for (int i = 0; i < blobs.length; i++)
			{
				CBlob@ blob = blobs[i];
				if (blob !is null && (blob.hasTag("flesh") || blob.hasTag("plant"))) 
				{
					map.server_setFireWorldspace(blob.getPosition(), true);
					blob.server_Hit(blob, blob.getPosition(), Vec2f(0, 0), 0.5f, Hitters::fire);
				}
			}
		}

		for (int i = 0; i < (3) * modifier; i++)
		{
			CBlob@ blob = server_CreateBlob("flame", -1, this.getPosition());
			blob.setVelocity(Vec2f(XORRandom(10) - 5, -XORRandom(10)));
			blob.server_SetTimeToDie(20 + XORRandom(10));
		}
		for(int a = 0; a < 30; a++)
		{
			map.server_setFireWorldspace(pos + Vec2f(4 - XORRandom(8), 4 - XORRandom(8)) * 4, true);
		}
	}

	if (isClient() && this.isOnScreen())
	{
		for (int i = 0; i < 30; i++)
		{

			MakeParticle(this, Vec2f( XORRandom(64) - 32, XORRandom(80) - 60), getRandomVelocity(angle, XORRandom(400) * 0.01f, 70), particles[XORRandom(particles.length)]);
			// ParticleAnimated("Entities/Effects/Sprites/FireFlash.png", this.getPosition() + Vec2f(0, -4), Vec2f(0, 0.5f), 0.0f, 1.0f, 2, 0.0f, true);
		}
		this.getSprite().Gib();
	}
}

void MakeParticle(CBlob@ this, const Vec2f pos, const Vec2f vel, const string filename = "SmallSteam")
{
	ParticleAnimated(filename, this.getPosition() + pos, vel, float(XORRandom(360)), 1.0f, 2 + XORRandom(3), XORRandom(100) * -0.00005f, true);
}