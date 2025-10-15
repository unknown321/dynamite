#ifndef HOOK_SCRIPTVARRESULT_H
#define HOOK_SCRIPTVARRESULT_H

#include "Tpp/TppTypes.h"

#include <vector>

struct ScriptVarResult {
    TppVarType type;

    std::vector<bool> bools;
    std::vector<int32_t> int32s;
    std::vector<uint32_t> uint32s;
    std::vector<float> floats;
    std::vector<int8_t> int8s;
    std::vector<uint8_t> uint8s;
    std::vector<int16_t> int16s;
    std::vector<uint16_t> uint16s;
};

#endif // HOOK_SCRIPTVARRESULT_H
