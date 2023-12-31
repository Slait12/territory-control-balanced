#include "Hitters.as";
#include "HittersTC.as";
#include "Knocked.as";
#include "ShieldCommon.as";
#include "Explosion.as";

string[] particles = 
{
	"LargeSmoke",
	"Explosion.png"
};

const f32 radius = 128.0f;

void onInit(CBlob@ this)
{
	this.getShape().SetGravityScale(0.0f);
	
	this.server_SetTimeToDie(1);

	this.getShape().getConsts().mapCollisions = false;
	this.getShape().getConsts().bullet = true;
	this.getShape().getConsts().net_threshold_multiplier = 4.0f;

	this.set_u32("wait_time", getGameTime() + 5); // Awful fix, I'm quite ashamed.

	this.Tag("projectile");
	this.Tag("explosive");

	this.getSprite().getConsts().accurateLighting = false;
	this.getSprite().SetFacingLeft(!this.getSprite().isFacingLeft());

	this.SetMapEdgeFlags(CBlob::map_collide_left | CBlob::map_collide_right);
	this.sendonlyvisible = false;

	this.SetMinimapOutsideBehaviour(CBlob::minimap_arrow);
	this.SetMinimapVars("GUI/Minimap/MinimapIcons.png", 1, Vec2f(16, 16));
	this.SetMinimapRenderAlways(true);

	CSprite@ sprite = this.getSprite();
	sprite.SetEmitSound("Shell_Whistle.ogg");
	sprite.SetEmitSoundPaused(false);
	sprite.SetEmitSoundVolume(0.0f);
	sprite.SetEmitSoundSpeed(0.9f);
}

void onTick(CBlob@ this)
{
	f32 angle = 0;

	Vec2f velocity = this.getVelocity();
	angle = velocity.Angle();
	Pierce(this, velocity, angle);

	this.setAngleDegrees(-angle + 180.0f);

	f32 modifier = Maths::Max(0, this.getVelocity().y * 0.02f);
	this.getSprite().SetEmitSoundVolume(Maths::Max(0, modifier));
	
	if(isClient())
	{
		if (this.hasTag("charged"))
		{
			MakeLightningParticle(this);
		}
		else
		{
			MakeSmokeParticle(this);
		}
	}
}

void Pierce(CBlob@ this, Vec2f velocity, const f32 angle)
{
	CMap@ map = this.getMap();

	const f32 speed = velocity.getLength();

	Vec2f direction = velocity;
	direction.Normalize();

	Vec2f position = this.getPosition();
	Vec2f tip_position = position + direction * 11.0f;
	Vec2f tip_position2 = position + direction * 12.25f;
	Vec2f tip_position3 = position + direction * 12.5f;
	Vec2f tail_position = position + direction * -4.0f;
	Vec2f tail_position2 = position + direction * -11.0f;

	Vec2f[] positions =
	{
		position,
		tip_position2,
		tip_position3,
		tail_position,
		tail_position2
	};

	for (uint i = 0; i < positions.length; i ++)
	{
		Vec2f temp_position = positions[i];
		TileType type = map.getTile(temp_position).type;
		const u32 offset = map.getTileOffset(temp_position);

		if (map.hasTileFlag(offset, Tile::SOLID))
		{
			onCollision(this, null, true);
		}

		// if (map.isTileSolid(type))
		// {
			// const u32 offset = map.getTileOffset(temp_position);
			// onCollision(this, null, true);
		// }
	}

	HitInfo@[] infos;

	if (map.getHitInfosFromArc(tail_position2, -angle, 10, (tip_position3 - tail_position2).getLength(), this, false, @infos))
	{
		for (uint i = 0; i < infos.length; i ++)
		{
			CBlob@ blob = infos[i].blob;
			Vec2f hit_position = infos[i].hitpos;

			if (blob !is null)
			{
				onCollision(this, blob, false);
			}
		}
	}
}

bool doesCollideWithBlob(CBlob@ this, CBlob@ blob)
{
	if (blob !is null) return (this.getTickSinceCreated() > 5 && this.getTeamNum() != blob.getTeamNum() && blob.isCollidable());
	else return false;
}

void onCollision(CBlob@ this, CBlob@ blob, bool solid)
{
	if (isServer())
	{
		if (blob !is null && doesCollideWithBlob(this, blob)) this.server_Die();
		else if (solid) this.server_Die();
	}
}

void onDie(CBlob@ this)
{
	DoExplosion(this);
	
	if (this.hasTag("charged"))
	{
		CMap@ map = getMap();
		CBlob@[] blobsInRadius;
		if (this.getMap().getBlobsInRadius(this.getPosition(), radius, @blobsInRadius))
		{
			int index = -1;
			f32 s_dist = 1337;

			for (uint i = 0; i < blobsInRadius.length; i++)
			{
				CBlob@ b = blobsInRadius[i];

				if (b.hasTag("flesh") && !b.hasTag("dead") && !b.hasTag("admin") && !map.rayCastSolid(this.getPosition(), b.getPosition()))
				{
					f32 dist = (b.getPosition() - this.getPosition()).Length();
					if (dist < s_dist)
					{
						s_dist = dist;
						index = i;
						CBlob@ target = blobsInRadius[index];
						SetKnocked(target, 45);
					}
				}
			}
		}
		if (isClient())
		{
			this.getSprite().PlaySound("Zapper_Zap" + XORRandom(3), 1.00f, 1.00f);
		}
	}
}

void DoExplosion(CBlob@ this)
{
	CRules@ rules = getRules();
	if (!shouldExplode(this, rules))
	{
		addToNextTick(this, rules, DoExplosion);
		return;
	}

	f32 modifier = 1;
	f32 angle = this.getOldVelocity().Angle();
	// print("Modifier: " + modifier + "; Quantity: " + this.getQuantity());

	this.set_f32("map_damage_radius", 32.0f);
	this.set_f32("map_damage_ratio", 0.15f);

	Explode(this, 48.0f, 6.0f);

	for (int i = 0; i < 15; i++) 
	{
		Vec2f dir = getRandomVelocity(angle, 1, 160);
		dir.x *= 2;
		dir.Normalize();

		LinearExplosion(this, dir, 32.0f + XORRandom(16) + (modifier * 8), 24 + XORRandom(24), 4, 2.50f, Hitters::explosion);
	}

	if (isClient())
	{
		Vec2f pos = this.getPosition();
		CMap@ map = getMap();

		for (int i = 0; i < 35; i++)
		{
			MakeParticle(this, Vec2f( XORRandom(64) - 32, XORRandom(80) - 60), getRandomVelocity(-angle, XORRandom(300) * 0.01f, 90), particles[XORRandom(particles.length)]);
		}

		this.getSprite().Gib();
	}
}

void MakeParticle(CBlob@ this, const Vec2f pos, const Vec2f vel, const string filename = "SmallSteam")
{
	if (!isClient()) return;
	ParticleAnimated(filename, this.getPosition() + pos, vel, float(XORRandom(360)), 0.5f + XORRandom(100) * 0.01f, 1 + XORRandom(4), XORRandom(100) * -0.00005f, true);
}

void MakeLightningParticle(CBlob@ this)
{
	CParticle@ particle = ParticleAnimated("ElectricTail.png", this.getPosition() + Vec2f(16 - XORRandom(32), 8 - XORRandom(32)), Vec2f(), float(XORRandom(360)), 1.0f + (XORRandom(50) / 100.0f), 3, 0.00f, false);
	if (particle !is null) 
	{
		particle.collides = false;
		particle.deadeffect = 1;
		particle.bounce = 0.0f;
		particle.fastcollision = true;
		particle.lighting = false;
		particle.setRenderStyle(RenderStyle::additive);
	}
}

void MakeSmokeParticle(CBlob@ this)
{
	CParticle@ particle = ParticleAnimated("SmallSmoke1.png", this.getPosition() + Vec2f(8 - XORRandom(16), 8 - XORRandom(16)), Vec2f(), float(XORRandom(360)), 1.0f + (XORRandom(50) / 100.0f), 3, 0.00f, false);
	if (particle !is null) 
	{
		particle.collides = false;
		particle.deadeffect = 1;
		particle.bounce = 0.0f;
		particle.fastcollision = true;
		particle.lighting = false;
	}
}