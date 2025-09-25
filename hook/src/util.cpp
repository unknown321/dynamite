#include "util.h"
#include "Tpp/PlayerDamage.h"
#include "Tpp/TppTypes.h"
#include "spdlog/spdlog.h"
#include <cmath>
#include <filesystem>
#include <fstream>


float calculateDistance(Vector3 v1, Vector3 v2) {
    float dx = v2.x - v1.x;
    float dy = v2.y - v2.y;
    float dz = v2.z - v1.z;
    return std::sqrt(dx * dx + dy * dy + dz * dz);
}

// checks if vector is out of the map
bool positionValid(Vector3 v) {
    if ((v.x > MAP_MAX_X) || (v.x < -MAP_MAX_X)) {
        return false;
    }

    if ((v.y > MAP_MAX_Y) || (v.y < -MAP_MAX_Y)) {
        return false;
    }

    if ((v.z > MAP_MAX_Z) || (v.z < -MAP_MAX_Z)) {
        return false;
    }

    return true;
}

// file format is `string,strcode32`
std::map<uint32_t, std::string> readMessageDictionary(const std::string &filename) {
    std::map<uint32_t, std::string> result;
    if (!std::filesystem::exists(filename)) {
        spdlog::info("Message dictionary {} doesn't exist, message names/values will not be resolved", filename);
        return result;
    }

    std::ifstream inputFile(filename);

    if (!inputFile.is_open()) {
        spdlog::error("Error opening file!");
        return result;
    }

    spdlog::info("Reading message dict...");

    inputFile.unsetf(std::ios_base::skipws);

    std::string line;
    while (std::getline(inputFile, line)) {
        std::stringstream ss(line);
        std::string value;
        std::string hexStr;
        uint32_t key;

        if (std::getline(ss, value, ',') && std::getline(ss, hexStr)) {
            std::stringstream hexStream;
            hexStream << std::hex << hexStr;
            if (hexStream >> key) {
                if (key < 1000) {
                    continue;
                }
                result[key] = value;
            }
        } else {
            spdlog::error("Message dict, invalid line format: {}", line);
        }
    }

    inputFile.close();
    spdlog::info("Message dict size: {:d}", result.size());

    return result;
}

// file format is `string,pathcode64`
std::map<uint64_t, std::string> readPathCodeDictionary(const std::string &filename) {
    std::map<uint64_t, std::string> result;
    if (!std::filesystem::exists(filename)) {
        spdlog::info("Path dictionary {} doesn't exist, message names/values will not be resolved", filename);
        return result;
    }

    std::ifstream inputFile(filename);

    if (!inputFile.is_open()) {
        spdlog::error("Error opening file!");
        return result;
    }

    spdlog::info("Reading path dict...");

    inputFile.unsetf(std::ios_base::skipws);

    std::string line;
    while (std::getline(inputFile, line)) {
        std::stringstream ss(line);
        std::string value;
        std::string hexStr;
        uint64_t key;

        if (std::getline(ss, value, ',') && std::getline(ss, hexStr)) {
            std::stringstream hexStream;
            hexStream << std::hex << hexStr;
            if (hexStream >> key) {
                if (key < 1000) {
                    continue;
                }
                result[key] = value;
            }
        } else {
            spdlog::error("Path dict, invalid line format: {}", line);
        }
    }

    inputFile.close();
    spdlog::info("Path dict size: {:d}", result.size());

    return result;
}

void DumpArgs(void *messageArgs, int len) {
    const unsigned char *bytes = reinterpret_cast<unsigned char *>(messageArgs);
    std::ostringstream oss;
    oss << std::hex << std::setfill('0');
    for (int i = 0; i < len; ++i) {
        oss << std::setw(2) << static_cast<int>(bytes[i]);
    }
    spdlog::info("message args: {}", oss.str());
}

void DumpDamage(PlayerDamage *Damage, uint32_t playerIndex) {
    std::ostringstream oss;
    oss << std::endl;
    oss << "v1: " << Damage->v1.x << " " << Damage->v1.y << " " << Damage->v1.z << " " << Damage->v1.w << std::endl;
    oss << "v2: " << Damage->dontUse.x << " " << Damage->dontUse.y << " " << Damage->dontUse.z << " " << Damage->dontUse.w << std::endl;
    //            oss << std::hex << std::setfill('0');
    //            oss << std::setw(16);
    oss << "flags: " << Damage->damage_type_flags << ", damageCat: " << Damage->damage_category << std::endl;
    oss << "damageID: " << Damage->damageID << ", b1: " << int(Damage->b1) << ", b2: " << int(Damage->b2) << ", b3: " << int(Damage->b3) << std::endl;
    oss << "skip: " << Damage->skip << ", lethal: " << int(Damage->lethalFlag) << " " << Damage->skip2;
    oss << std::endl;
    spdlog::info("player {}, damage {}", playerIndex, oss.str());
    DumpArgs(Damage, 0x30);
}

std::string bytes_to_hex(const void *data, size_t n) {
    const uint8_t *bytes = static_cast<const uint8_t *>(data);
    std::stringstream ss;
    ss << std::hex << std::uppercase << std::setfill('0');

    for (size_t i = 0; i < n; ++i) {
        //            if (i > 0) ss << " ";
        ss << std::setw(2) << static_cast<int>(bytes[i]);
    }

    return ss.str();
}
