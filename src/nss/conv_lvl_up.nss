//:://////////////////////////////////////////////
//:: Created By: Scott Milliorn
//:: Created On: 02-06-2019
//:://////////////////////////////////////////////

void main()
{
    if (GetXP(GetPCSpeaker()) < 780000) SetXP(GetPCSpeaker(), 780000);
    else SpeakString("Already selected this option");
}
