//:://////////////////////////////////////////////
//:: Created By: Scott Milliorn
//:: Date: January 26th, 2019
//:://////////////////////////////////////////////

#include "inc_mod_def"
#include "x3_inc_string"

void main()
{
    object oRespawner = GetLastRespawnButtonPresser();

    string sDestTag =  "NW_LOBBY";
    string sArea = GetTag(GetArea(oRespawner));
    string sSave = StringToRGBString("Character Saved", STRING_COLOR_GREEN);

    object oSpawnPoint = GetObjectByTag(sDestTag);

    ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectResurrection(),oRespawner);
    ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectHeal(GetMaxHitPoints(oRespawner)), oRespawner);

    Raise(oRespawner);

    AssignCommand(oRespawner,JumpToLocation(GetLocation(oSpawnPoint)));

    FloatingTextStringOnCreature(sSave, oRespawner, FALSE);
    ExportSingleCharacter(oRespawner);
}
