#ifndef HOOK_CONFIG_H
#define HOOK_CONFIG_H

#include "mini/ini.h"
#include <cstdint>
#include <string>

struct ConfigValidateResult {
    std::string Message;
};

class Config {
  public:
    bool Host = false;
    uint64_t HostSteamID = 0;
    std::string MasterServerURL = "http://127.0.0.1:6667/tppstm/gate";
    std::vector<uint64_t> blacklist = {};
    std::vector<uint64_t> whitelist = {};


    bool Read(ConfigValidateResult*);
    static bool ValidateKeys(const mINI::INIStructure&, ConfigValidateResult *);
    void Log();
};

#endif // HOOK_CONFIG_H
