#include "MakeCrate.as";
#include "Requirements.as";
#include "ShopCommon.as";
#include "Descriptions.as";
#include "CheckSpam.as";
#include "CTFShopCommon.as";
#include "MakeMat.as";
#include "MakeSeed.as";
#include "CargoAttachmentCommon.as"

void onInit(CBlob@ this)
{
	this.Tag("ignore fall");
	this.Tag("grapplable");
	this.Tag("heavy weight");
}

void onTick(CBlob@ this)
{
	CInventory@ inv = this.getInventory();
}

void onCollision(CBlob@ this, CBlob@ blob, bool solid)
{
	if (blob is null) return;
	TryToAttachCargo(this, blob);
}

bool isInventoryAccessible(CBlob@ this, CBlob@ forBlob)
{
	return (this.getTeamNum() >= 100 ? true : (forBlob.getTeamNum() == this.getTeamNum()));
}


bool doesCollideWithBlob(CBlob@ this, CBlob@ blob)
{
	return true;
}

