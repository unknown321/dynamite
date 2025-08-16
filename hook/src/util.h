#ifndef HOOK_UTIL_H
#define HOOK_UTIL_H

#include "Tpp/PlayerDamage.h"
#include "Tpp/TppTypes.h"
#include <map>
#include <string>

float calculateDistance(Vector3 v1, Vector3 v2);

std::map<uint32_t, std::string> readMessageDictionary(const std::string& filename);

std::map<uint64_t, std::string> readPathCodeDictionary(const std::string &filename);

PlayerDamage NewNetworkDamage();

void DumpArgs(void *messageArgs, int len);

void DumpDamage(PlayerDamage *Damage, uint32_t playerIndex);

#endif // HOOK_UTIL_H
