//:://////////////////////////////////////////////
//:: Created By: Scott Milliorn
//:: Created On: 02-06-2019
//:://////////////////////////////////////////////

void main()
{
    object oItem;
    // Search area to find is any players are still in area
    object oObject = GetFirstObjectInArea(OBJECT_SELF);
    while (GetIsObjectValid(oObject))
    {
        if (GetIsPC(oObject))
        {
            // Found a player exit script
            return;
        }
        oObject = GetNextObjectInArea(OBJECT_SELF);
    }
    // No players found in area
    oObject = GetFirstObjectInArea(OBJECT_SELF);
    while (GetIsObjectValid(oObject))
    {
        if (GetObjectType(oObject) == OBJECT_TYPE_PLACEABLE && GetTag(oObject) == "BodyBag")
        {
            // Destroy all items in BodyBags to free up memory
            oItem = GetFirstItemInInventory(oObject);
            while (GetIsObjectValid(oItem))
            {
                AssignCommand(oItem, SetIsDestroyable(TRUE));
                DestroyObject(oItem);
                oItem = GetNextItemInInventory(oObject);
            }
        }
        // Clear placeable inventories
        else if(GetObjectType(oObject) == OBJECT_TYPE_PLACEABLE && GetHasInventory(oObject))
        {
            oItem = GetFirstItemInInventory(oObject);
            while(GetIsObjectValid(oItem))
            {
                DestroyObject(oItem);
                oItem = GetNextItemInInventory(oObject);
            }
        }
        // Clear encounters
        else if (GetIsEncounterCreature(oObject))
        {
            AssignCommand(oObject, SetIsDestroyable(TRUE));
            DestroyObject(oObject);
        }
        //  Destroy items on the ground
        else if (GetObjectType(oObject) == OBJECT_TYPE_ITEM)
        {
            AssignCommand(oObject, SetIsDestroyable(TRUE));
            DestroyObject(oObject);
        }

        // Clear NPC's
        else if (GetObjectType(oObject) == OBJECT_TYPE_CREATURE &&
                !GetAssociateType(oObject))
        {
            AssignCommand(oObject, SetIsDestroyable(TRUE));
            DestroyObject(oObject);
        }
        // Check Next object to clean
        oObject = GetNextObjectInArea(OBJECT_SELF);
    }
}

