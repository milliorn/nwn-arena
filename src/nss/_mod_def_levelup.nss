//:://////////////////////////////////////////////
//:: Created By: Scott Milliorn
//:: Date: January 26th, 2019
//:://////////////////////////////////////////////
#include "x3_inc_string"

void main()
{
    object oPC = GetPCLevellingUp();

    //  Save .bic file
    string sSave = StringToRGBString("Character Saved", STRING_COLOR_GREEN);
    FloatingTextStringOnCreature(sSave, oPC, FALSE);
    ExportSingleCharacter(oPC);
    ExecuteScript("ws_saveall_sub", oPC);

    //  VFX effects at level up based on alignment
    int nAlign = GetAlignmentGoodEvil(oPC);
    switch (nAlign)
    {
        case ALIGNMENT_EVIL:
        DelayCommand(0.3, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_LOS_EVIL_10), oPC));
        DelayCommand(0.6, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_LOS_EVIL_20), oPC));
        DelayCommand(0.9, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_LOS_EVIL_30), oPC));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_LIGHTNING_M), oPC);
        break;

        case ALIGNMENT_GOOD:
        DelayCommand(0.3, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_LOS_HOLY_10), oPC));
        DelayCommand(0.6, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_LOS_HOLY_20), oPC));
        DelayCommand(0.9, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_LOS_HOLY_30), oPC));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_LIGHTNING_M), oPC);
        break;

        default:
        DelayCommand(0.3, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_LOS_NORMAL_10), oPC));
        DelayCommand(0.6, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_LOS_NORMAL_20), oPC));
        DelayCommand(0.9, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_LOS_NORMAL_30), oPC));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_LIGHTNING_M), oPC);
        break;
    }
}
