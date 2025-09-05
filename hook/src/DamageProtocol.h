#ifndef HOOK_DAMAGEPROTOCOL_H
#define HOOK_DAMAGEPROTOCOL_H

#define DamageID 1 // TppDamage.ATK_PushSlideInterp

enum DamageProtocolCommand {
    CMD_Invalid,
    CMD_AddFixedUserMarker,
    CMD_AddFollowUserMarker,
    CMD_RemoveUserMarker,
    CMD_SetSightMarker,
    CMD_CustomCommand1,
    CMD_CustomCommand2,
    CMD_CustomCommand3,
    CMD_CustomCommand4,

    CMD_IgnoreMe = 0xC8,
};

#endif // HOOK_DAMAGEPROTOCOL_H
