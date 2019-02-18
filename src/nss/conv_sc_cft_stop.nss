//:://////////////////////////////////////////////
//:: Created By: Milliorn
//:: Date: 02-07-2019
//:://////////////////////////////////////////////

//  Cannot allow a character to use this menu while in combat zone
int StartingConditional()
{
    object oPC = GetPCSpeaker();
    object oArea = GetArea(oPC);

    if (GetLocalInt(oArea, "CRAFT_MENU_ALLOWED") == 1)
    {
        return FALSE;
    }

    else return TRUE;
}
