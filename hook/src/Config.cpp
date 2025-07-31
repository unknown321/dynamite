#include "Config.h"
#include "spdlog/spdlog.h"
#include "mini/ini.h"
#include <ranges>

bool Config::ValidateKeys(const mINI::INIStructure &ini, ConfigValidateResult *result) {
    if (!ini.has("Coop")) {
        result->Message = "Missing [Coop] section.";
        return false;
    }

    if (!ini.get("Coop").has("Host")) {
        result->Message = "[Coop] section has no \"Host\" parameter.";
        return false;
    }

    if (!ini.get("Coop").has("HostSteamID")) {
        result->Message = "[Coop] section has no \"HostSteamID\" parameter.";
        return false;
    }

    if (!ini.get("Coop").has("Blacklist")) {
        result->Message = "[Coop] section has no \"Blacklist\" parameter.";
        return false;
    }

    if (!ini.get("Coop").has("Whitelist")) {
        result->Message = "[Coop] section has no \"Whitelist\" parameter.";
        return false;
    }

    if (!ini.has("MasterServer")) {
        result->Message = "Missing [MasterServer] section.";
        return false;
    }

    if (!ini.has("Dynamite")) {
        result->Message = "Missing [Dynamite] section.";
        return false;
    }

    if (!ini.get("Dynamite").has("UseLocalMasterServer")) {
        result->Message = "[Dynamite] section has no \"UseLocalMasterServer\" parameter.";
        return false;
    }

    if (!ini.get("MasterServer").has("URL")) {
        result->Message = "[MasterServer] section has no \"URL\" parameter.";
        return false;
    }

    return true;
}

bool Config::Read(ConfigValidateResult *r) {
    mINI::INIFile file("dynamite/dynamite.ini");
    mINI::INIStructure ini;

    if (!file.read(ini)) {
        r->Message = "Cannot read config file.";
        return false;
    }

    ConfigValidateResult result{};
    if (!Config::ValidateKeys(ini, &result)) {
        r->Message = result.Message;
        return false;
    }

    if (ini.get("Dynamite").get("UseLocalMasterServer") == "true") {
        this->MasterServerURL = "http://127.0.0.1:6667/tppstm/gate";
    } else {
        auto url = std::string(ini.get("MasterServer").get("URL"));
        if (!url.starts_with("http")) {
            r->Message = "MasterServer.URL parameter must start with protocol (http/https).";
            return false;
        }

        if (!url.ends_with("/tppstm/gate")) {
            r->Message = "MasterServer.URL parameter must end with \"/tppstm/gate\".";
            return false;
        }

        this->MasterServerURL = url;
    }

    auto host = ini.get("Coop").get("Host");
    this->Host = host == "true";

    auto steamid = ini.get("Coop").get("HostSteamID");
    std::istringstream(steamid) >> this->HostSteamID;

    if (!this->Host) {
        if (this->HostSteamID < 0x110000100000000 || this->HostSteamID > 0x01100001FFFFFFFF) {
            r->Message = "Invalid HostSteamID.";
            return false;
        }
    }

    auto bl = ini.get("Coop").get("Blacklist");
    for (const auto &entry : std::views::split(bl, ',')) {
        std::string_view e(entry.begin(), entry.end());
        size_t space_pos = e.find(' ');
        if (space_pos != std::string_view::npos) {
            e = e.substr(0, space_pos);
        }

        uint64_t steamID;
        auto [ptr, ec] = std::from_chars(e.begin(), e.end(), steamID);
        if (ec == std::errc()) {
            this->blacklist.push_back(steamID);
        }
    }

    auto wl = ini.get("Coop").get("Whitelist");
    for (const auto &entry : std::views::split(wl, ',')) {
        std::string_view e(entry.begin(), entry.end());
        size_t space_pos = e.find(' ');
        if (space_pos != std::string_view::npos) {
            e = e.substr(0, space_pos);
        }

        uint64_t steamID;
        auto [ptr, ec] = std::from_chars(e.begin(), e.end(), steamID);
        if (ec == std::errc()) {
            this->whitelist.push_back(steamID);
        }
    }

    return true;
}

void Config::Log() {
    spdlog::info("Host: {0:d}", this->Host);
    spdlog::info("HostID: {0:d}", this->HostSteamID);
    spdlog::info("Master server URL: {}", this->MasterServerURL);
    for (const auto &steamID: this->whitelist) {
        spdlog::info("Whitelist entry: {0:d}", steamID);
    }

    for (const auto &steamID: this->blacklist) {
        spdlog::info("Blacklist entry: {0:d}", steamID);
    }
}
