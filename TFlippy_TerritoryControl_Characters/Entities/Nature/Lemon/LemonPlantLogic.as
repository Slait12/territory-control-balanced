// Lemon Plant logic.

#include "PlantGrowthCommon.as";

void onInit(CBlob@ this)
{
	this.Tag("nature");
	this.Tag("plant");
	
	this.SetFacingLeft(XORRandom(2) == 0);

	this.getCurrentScript().tickFrequency = 150;
	this.getSprite().SetZ(10.0f);

	this.Tag("builder always hit");

	// this script gets removed so onTick won't be run on client on server join, just onInit
	if (this.hasTag("instant_grow"))
	{
		GrowLemon(this);
	}
}


void onTick(CBlob@ this)
{
	if (this.hasTag(grown_tag))
	{
		GrowLemon(this);
	}
}

void GrowLemon(CBlob @this)
{
	for (int i = 0; i < 3; i++)
	{
		Vec2f offset;
		int v = this.isFacingLeft() ? 0 : 1;
		switch (i)
		{
			case 0: offset = Vec2f(-1 + v, -16); break;
			case 1: offset = Vec2f(2 + v, -10); break;
			case 2: offset = Vec2f(-4 + v, -5); break;
		}

		CSpriteLayer@ lemon = this.getSprite().addSpriteLayer("lemon", "Lemon.png" , 8, 8);

		if (lemon !is null)
		{
			Animation@ anim = lemon.addAnimation("default", 0, false);
			anim.AddFrame(0);
			lemon.SetAnimation("default");
			lemon.SetOffset(offset);
			lemon.SetRelativeZ(0.01f * (XORRandom(3) == 0 ? -1 : 1));
		}
	}

	this.Tag("has lemon");
	this.Tag("has fruit");
	this.getCurrentScript().runFlags |= Script::remove_after_this;
}
