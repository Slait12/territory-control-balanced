﻿// ArcherShop.as

#include "Requirements.as";
#include "ShopCommon.as";
#include "Descriptions.as";
#include "CheckSpam.as";
#include "CTFShopCommon.as";
#include "MakeMat.as";

void onInit(CBlob@ this)
{
	this.getSprite().SetZ(-50); //background
	this.getShape().getConsts().mapCollisions = false;

	this.Tag("change team on fort capture");
	this.Tag("extractable");
	this.addCommandID("write");
	//this.set_Vec2f("nobuild extend",Vec2f(0.0f, 8.0f));

	//this.inventoryButtonPos = Vec2f(-16, 8);
	this.getCurrentScript().tickFrequency=30*2;	//30 oil per minute

	this.Tag("upkeep building");
	this.set_u8("upkeep cap increase", 1);
	this.set_u8("upkeep cost", 0);

	this.SetMinimapOutsideBehaviour(CBlob::minimap_snap);
	this.SetMinimapVars("MinimapIcons.png",48,Vec2f(8,8));
	this.SetMinimapRenderAlways(true);

	AddIconToken("$icon_oil$","Material_Oil.png",Vec2f(16,16),0);
}

void onInit(CSprite@ this)
{
	CSpriteLayer@ head = this.addSpriteLayer("head", this.getFilename(), 80, 48);
	if (head !is null)
	{
		head.addAnimation("default", 0, true);
		head.SetRelativeZ(-1.0f);
		head.SetOffset(Vec2f(-12, -18));
	}

	CSpriteLayer@ rod = this.addSpriteLayer("rod", "PumpJack_Rod", 4, 64);
	if (rod !is null)
	{
		rod.addAnimation("default", 0, true);
		rod.SetRelativeZ(-5.0f);
		rod.SetOffset(Vec2f(-36, 0));
	}

	this.SetEmitSound("Pumpjack_Ambient.ogg");
	this.SetEmitSoundVolume(0.6f);
	this.SetEmitSoundPaused(false);
}

void onTick(CSprite@ this)
{
	CBlob@ blob = this.getBlob();

	CSpriteLayer@ head = this.getSpriteLayer("head");

	head.ResetTransform();
	head.RotateBy(Maths::Sin((getGameTime() * 0.075f) % 180) * 20.0f, Vec2f_zero);

	CSpriteLayer@ rod = this.getSpriteLayer("rod");
	if (rod !is null)
	{
		rod.addAnimation("default", 0, true);
		rod.SetRelativeZ(-5.0f);
		rod.SetOffset(Vec2f(-36, Maths::Sin((getGameTime() * 0.075f) % 180) * 9.0f));
	}
}

void onTick(CBlob@ this)
{
	if (isServer()) 
	{
		// if (!this.getInventory().isFull()) MakeMat(this, this.getPosition(), "mat_oil", XORRandom(3));

		CBlob@ storage = FindStorage(this.getTeamNum());

		if (storage !is null)
		{
			MakeMat(storage, this.getPosition(), "mat_oil", XORRandom(3));
		}	
		else if (this.getInventory().getCount("mat_oil") < 450)
		{
			MakeMat(this, this.getPosition(), "mat_oil", XORRandom(3));
		}
	}
}

CBlob@ FindStorage(u8 team)
{
	if (team >= 100) return null;

	CBlob@[] blobs;
	getBlobsByName("oiltank", @blobs);

	CBlob@[] validBlobs;

	for (u32 i = 0; i < blobs.length; i++)
	{
		if (blobs[i].getTeamNum() == team && blobs[i].getInventory().getCount("mat_oil") < 300)
		{
			validBlobs.push_back(blobs[i]);
		}
	}

	if (validBlobs.length == 0) return null;

	return validBlobs[XORRandom(validBlobs.length)];
}

void GetButtonsFor(CBlob@ this, CBlob@ caller)
{
	if (this.getDistanceTo(caller) > 96.0f) return;
	this.set_bool("shop available", false);

	if (caller is null) return;
	if (!this.isOverlapping(caller)) return;

	//rename the oilrig
	CBlob@ carried = caller.getCarriedBlob();
	if(carried !is null && carried.getName() == "paper" && caller.getTeamNum() == this.getTeamNum())
	{
		CBitStream params;
		params.write_u16(caller.getNetworkID());
		params.write_u16(carried.getNetworkID());

		CButton@ buttonWrite = caller.CreateGenericButton("$icon_paper$", Vec2f(0, -8), this, this.getCommandID("write"), "Rename the rig.", params);
	}
}

void onAddToInventory(CBlob@ this,CBlob@ blob) //i'll keep it just to be sure
{
	if(blob.getName()!="mat_oil")
	{
		this.server_PutOutInventory(blob);
	}
}
bool isInventoryAccessible(CBlob@ this,CBlob@ forBlob)
{
	return forBlob.isOverlapping(this) && (forBlob.getCarriedBlob() is null || forBlob.getCarriedBlob().getName()=="mat_oil");
	//return (forBlob.isOverlapping(this));
}

