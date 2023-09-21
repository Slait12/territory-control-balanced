
void onInit(CSprite@ this)
{
	CSpriteLayer@ flash = this.addSpriteLayer("flash", "Flare_Flash", 16, 16);
	if (flash !is null)
	{
		flash.ScaleBy(0.75f, 0.75f);
		flash.SetOffset(Vec2f(0, -5.0f));
		flash.SetRelativeZ(20.0f);
		flash.SetVisible(true);
	}
}

void onInit(CBlob@ this)
{
	this.getSprite().PlaySound("grenade_pinpull.ogg");
	this.server_SetTimeToDie(240); //4 minutes
	
	this.SetLight(true);
	this.SetLightRadius(128.0f);
	this.SetLightColor(SColor(255, 255, 0, 0));

}

bool doesCollideWithBlob(CBlob@ this, CBlob@ blob)
{
	return blob.getShape().isStatic() && blob.isCollidable();
}

void onCollision(CBlob@ this, CBlob@ blob, bool solid, Vec2f normal, Vec2f point1)
{
	if(!this.isAttached() && (blob is null || doesCollideWithBlob(this, blob))) // hit map
	{
		f32 radius = this.getRadius();

		Vec2f norm = this.getOldVelocity();
		norm.Normalize();
		norm *= (1.5f * radius);
		Vec2f lock = point1 - norm;
		this.set_Vec2f("lock", lock);

		this.Sync("lock", true);

		this.setVelocity(Vec2f(0, 0));
		this.setPosition(lock);
		this.Tag("collided");
	}
}

void onTick(CBlob@ this)
{
	if(this.hasTag("collided"))
	{
		CShape@ shape = this.getShape();

		//no collision
		shape.getConsts().collidable = false;

		if (!this.hasTag("_collisions"))
		{
			this.Tag("_collisions");

			// make everyone recheck their collisions with me
			const uint count = this.getTouchingCount();
			for (uint step = 0; step < count; ++step)
			{
				CBlob@ _blob = this.getTouchingByIndex(step);
				_blob.getShape().checkCollisionsAgain = true;
			}
		}

		this.setVelocity(Vec2f(0, 0));
		this.setPosition(this.get_Vec2f("lock"));
		shape.SetStatic(true);
	}
	if (isClient())
	{
		f32 angle = this.get_f32("angle") * (this.isFacingLeft() ? 1.0f : -1.0f);
		Vec2f offset = Vec2f(0, -5);
		offset.RotateBy(angle);
		
		CSprite@ sprite = this.getSprite();
		if (sprite is null) return;
		CSpriteLayer@ flash = sprite.getSpriteLayer("flash");
		if (flash !is null)
		flash.SetOffset(offset);
		
		if (XORRandom(2) == 0)
		{
			sparks(this.getPosition() + (offset * (this.isFacingLeft() ? 1.0f : -1.0f)), angle, (XORRandom(10) / 5.0f), SColor(255, 255, 0, 0));
		}
		
		if (getGameTime() % 4 == 0)
		{
			flash.RotateBy(float(XORRandom(360)), Vec2f());
		}
	}
}
					
void onThisAddToInventory(CBlob@ this, CBlob@ inventoryBlob)
{
	if (inventoryBlob is null) return;

	CInventory@ inv = inventoryBlob.getInventory();

	if (inv is null) return;

	this.doTickScripts = true;
	inv.doTickScripts = true;
}

void onAttach(CBlob@ this, CBlob@ attached, AttachmentPoint@ attachedPoint)
{
	this.Untag("collided");

	CShape@ shape = this.getShape();
	shape.getConsts().collidable = true;
	shape.SetStatic(false);
}

void sparks(Vec2f at, f32 angle, f32 speed, SColor color)
{
	Vec2f vel = getRandomVelocity(angle + 90.0f, speed, 25.0f);
	at.y -= 2.5f;
	ParticlePixel(at, vel, color, true, 119);
}