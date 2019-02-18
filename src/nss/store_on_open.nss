//:://////////////////////////////////////////////
//:: Created By: Scott Milliorn
//:: Created On: 02-06-2019
//:://////////////////////////////////////////////

void main()
{
    object oItem = GetFirstItemInInventory(OBJECT_SELF);
    while (GetIsObjectValid(oItem))
    {
        //  Set all Items in Store to Infinite inventory and identify them all (because doing it in toolset sucks).
        SetInfiniteFlag(oItem, TRUE);
        SetIdentified(oItem, TRUE);
        oItem = GetNextItemInInventory(OBJECT_SELF);
    }
}
