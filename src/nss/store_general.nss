//:://////////////////////////////////////////////
//:: Created By: Scott Milliorn
//:: Created On: 02-06-2019
//:://////////////////////////////////////////////

#include "nw_i0_plot"
void main()
{
    object oStore = GetNearestObjectByTag("BattleRoyaleStore");
    if (GetObjectType(oStore) == OBJECT_TYPE_STORE)
    {
        gplotAppraiseOpenStore(oStore, GetPCSpeaker());
    }
    else
    {
        ActionSpeakStringByStrRef(53090, TALKVOLUME_TALK);
    }
}
