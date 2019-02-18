//:://////////////////////////////////////////////
//:: Created By: Scott Milliorn
//:: Created On: 02-07-2019
//:://////////////////////////////////////////////
#include "nwnx_admin"
void main()
{
    // Vars
    object oPC = GetPCSpeaker();
    DelayCommand(3.0, NWNX_Administration_DeletePlayerCharacter(oPC, FALSE));
    PlayVoiceChat(VOICE_CHAT_GOODBYE, oPC);
    PlayAnimation(ANIMATION_FIREFORGET_SPASM, 1.0, 3.0);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_CHUNK_RED_SMALL), GetLocation(oPC));
    DelayCommand(0.5, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_CHUNK_RED_MEDIUM), GetLocation(oPC)));
    DelayCommand(1.5, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_CHUNK_RED_LARGE), GetLocation(oPC)));
    DelayCommand(2.5, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_CHUNK_RED_BALLISTA), GetLocation(oPC)));
}
