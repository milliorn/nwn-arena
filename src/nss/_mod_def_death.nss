//:://////////////////////////////////////////////
//::
//:: Created By: Scott Milliorn
//:: Created On: January 25th, 2019
//::
//:://////////////////////////////////////////////

#include "inc_mod_def"
#include "x3_inc_string"

void main()
{
    object  oDied = GetLastPlayerDied(),
            oKiller = GetLastHostileActor(oDied),
            oArea  = GetArea(oDied);

    string sSave = StringToRGBString("Character Saved", STRING_COLOR_GREEN);

    FloatingTextStringOnCreature(sSave, oDied, FALSE);
    ExportSingleCharacter(oDied);

    FloatingTextStringOnCreature(sSave, oKiller, FALSE);
    ExportSingleCharacter(oKiller);

    //  Auto Raise PC if they die in these areas
    if (GetLocalInt(oArea, "PC_AUTO_RAISE"))
    {
        AssignCommand(oKiller, ClearAllActions(TRUE));
        Raise(oDied);
        return;
    }

    DelayCommand(0.1, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_CHUNK_RED_LARGE), OBJECT_SELF));
    DelayCommand(0.3, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_BLOOD_SPARK_LARGE), OBJECT_SELF));
    DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DEATH_L), OBJECT_SELF));
    DelayCommand(2.0, PopUpDeathGUIPanel(oDied, TRUE, TRUE, 0, "You Lose!"));
}
