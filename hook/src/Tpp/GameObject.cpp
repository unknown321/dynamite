#include "TppGameObject.h"

std::pair<unsigned short int, unsigned short int> GetTypeRange(GameObjectType t) {
    unsigned short start = t << 9;
    unsigned short end;
    if (t == GAME_OBJECT_TYPE_END) {
        end = start;
    } else {
        end = (t + 1) << 9;
    }

    return std::make_pair(start, end);
}
