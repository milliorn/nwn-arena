//:://////////////////////////////////////////////
//:: Created By: Scott Milliorn
//:: Created On: 02-02-2019
//:://////////////////////////////////////////////

#include "x3_inc_string"

void main()
{
    object oPC = GetLastUsedBy();
    int iLevel = GetHitDice(oPC);

    //  Prevent PC from entering the lobby if they are not levelled up
    if (iLevel != 40)
    {
        FloatingTextStringOnCreature(StringToRGBString("You must be Level 40" +
        "to enter the Lobby", STRING_COLOR_ROSE), oPC, FALSE);
        return;
    }

    string sTagNum = GetStringRight(GetTag(OBJECT_SELF), 1);

    if (sTagNum == "1") sTagNum = "2";
    else sTagNum = "1";

    object oTarget = GetObjectByTag("NW_LOBBY_" + sTagNum);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_IMPLOSION), oPC);
    DelayCommand(2.0, AssignCommand(oPC, ClearAllActions()));
    DelayCommand(2.1, AssignCommand(oPC, JumpToLocation(GetLocation(oTarget))));
}
