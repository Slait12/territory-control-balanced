﻿#include "MakeMat.as";

void onInit(CSprite@ this)
{
	// Building
	this.SetZ(-50); //-60 instead of -50 so sprite layers are behind ladders
}

const string[] matNames = { 
	"mat_copper",
	"mat_iron",
	"mat_gold",
	"mat_wood"
};

const string[] matNamesResult = { 
	"mat_copperingot",
	"mat_ironingot",
	"mat_goldingot",
	"mat_coal"
};

const int[] matRatio = { 
	10,
	10,
	25,
	40,
	20
};

void onInit(CBlob@ this)
{
	this.set_TileType("background tile", CMap::tile_castle_back);
	this.getShape().getConsts().mapCollisions = false;
	this.getCurrentScript().tickFrequency = 45;

	this.Tag("ignore extractor");
	this.Tag("builder always hit");
}

void onTick(CBlob@ this)
{
	if (this.hasBlob("mat_ironingot", 4) && this.hasBlob("mat_coal", 4)) //steel ingots require coal to be created
	{
		if (isServer())
		{
			CBlob@ mat = server_CreateBlob("mat_steelingot", -1, this.getPosition());
			mat.server_SetQuantity(2);
			mat.Tag("justmade");
			this.TakeBlob("mat_ironingot", 4);
			this.TakeBlob("mat_coal", 4);
		}
		if (isClient())
		{
			this.getSprite().PlaySound("ProduceSound.ogg");
			this.getSprite().PlaySound("BombMake.ogg");
			//	ParticleAnimated("LargeSmoke", this.getPosition() + Vec2f(0,-20), Vec2f(0.3f + (XORRandom(4) * 0.1f), -0.75f + (XORRandom(3) * -0.1f)), 0, 1.00f + (XORRandom(10) * 0.1f), 10 + XORRandom(10), 0, false);
		}
	}
	for (int i = 0; i < matNames.length; i++)
	{
		if (this.hasBlob(matNames[i], matRatio[i]))
		{
			if (isServer())
			{
				CBlob@ mat = server_CreateBlob(matNamesResult[i], -1, this.getPosition());
				mat.server_SetQuantity(2);
				mat.Tag("justmade");
				mat.Tag("from_forge");
				this.TakeBlob(matNames[i], matRatio[i]);

				CMap@ map = this.getMap();
				if (map !is null)
				{
					CBlob@ blob = map.getBlobAtPosition(this.getPosition() + Vec2f(0, 28.0f));
					if (blob !is null && blob.getName() == "storage")
					{
						if (!blob.server_PutInInventory(mat))
						{
							mat.setPosition(blob.getPosition());
						}
					}
				}
			}
			if (isClient())
			{
				this.getSprite().PlaySound("ProduceSound.ogg");
				this.getSprite().PlaySound("BombMake.ogg");
			//	ParticleAnimated("LargeSmoke", this.getPosition() + Vec2f(0,-20), Vec2f(0.3f + (XORRandom(4) * 0.1f), -0.75f + (XORRandom(3) * -0.1f)), 0, 1.00f + (XORRandom(10) * 0.1f), 10 + XORRandom(10), 0, false);
			}
		}
	}
}

void onCollision(CBlob@ this, CBlob@ blob, bool solid)
{
	if (blob is null) return;

	if (blob.hasTag("justmade"))
	{
		blob.Untag("justmade");
		return;
	}
	
	if (!blob.isAttached() && blob.hasTag("material"))
	{
		string config = blob.getName();
		for (int i = 0; i < matNames.length; i++)
		{
			if (config == matNames[i] || config == "mat_ironingot" || config == "mat_coal")
			{
				if (isServer()) this.server_PutInInventory(blob);
				if (isClient()) this.getSprite().PlaySound("bridge_open.ogg");
			}
		}
	}
}

bool isInventoryAccessible(CBlob@ this, CBlob@ forBlob)
{
	// return (forBlob.getTeamNum() == this.getTeamNum() && forBlob.isOverlapping(this));
	return forBlob !is null && forBlob.isOverlapping(this);
}

void onAddToInventory( CBlob@ this, CBlob@ blob )
{
	if(blob.getName() != "gyromat") return;

	this.getCurrentScript().tickFrequency = 45 / (this.exists("gyromat_acceleration") ? this.get_f32("gyromat_acceleration") : 1);
}

void onRemoveFromInventory(CBlob@ this, CBlob@ blob)
{
	if(blob.getName() != "gyromat") return;
	
	this.getCurrentScript().tickFrequency = 45 / (this.exists("gyromat_acceleration") ? this.get_f32("gyromat_acceleration") : 1);
}