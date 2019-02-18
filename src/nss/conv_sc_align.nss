//:://////////////////////////////////////////////
//::
//:: Created By: Scott Milliorn
//:: Created On: 02-07-2019
//::
//:://////////////////////////////////////////////

//  Check if speaker is level 40, if so disable the alignment shift.
int StartingConditional()
{
    object oPC = GetPCSpeaker();
    if (GetHitDice(oPC) == 40)
    {
        return TRUE;
    }

    else return FALSE;
}
