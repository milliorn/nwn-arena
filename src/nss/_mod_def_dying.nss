//:://////////////////////////////////////////////
//:: Created By: Scott Milliorn
//:: Created On: 01-26-2019
//:://////////////////////////////////////////////
#include "x3_inc_string"

void main()
{
    object oPC = GetLastPlayerDying();
    effect eDeath = EffectDeath(FALSE, FALSE);
    string sSave = StringToRGBString("Character Saved", STRING_COLOR_GREEN);
    FloatingTextStringOnCreature(sSave, oPC, FALSE);
    ExportSingleCharacter(oPC);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oPC);
}
