#ifndef HOOK_BOSSQUIETDAMAGE_H
#define HOOK_BOSSQUIETDAMAGE_H

struct BossQuietDamage {
    short entityIndex;
    unsigned short currentLife;
    unsigned short lifeDamage;
    unsigned short currentStamina;
    unsigned short staminaDamage;
};

#endif // HOOK_BOSSQUIETDAMAGE_H
