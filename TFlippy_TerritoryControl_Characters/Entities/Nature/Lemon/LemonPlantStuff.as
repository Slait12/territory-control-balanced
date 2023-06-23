#include "MakeSeed.as";
bool canBePickedUp(CBlob@ this, CBlob@ byBlob)
{
	return false;
}

void onDie(CBlob@ this)
{
	if (isServer())
	{
		if (this.hasTag("has lemon"))
		{			
			CBlob@ lemon = server_CreateBlob("lemon", this.getTeamNum(), this.getPosition());
			lemon.server_SetQuantity(1+XORRandom(2));
			if (lemon !is null)
			{
				server_MakeSeed(this.getPosition(), "lemon_plant", 300, 11, 4);
			}
		}
	}
}
