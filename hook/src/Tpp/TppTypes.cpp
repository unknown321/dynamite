#include "TppTypes.h"

#include <format>
#include <string>

// usually there are no objects at 0,0,0
// this function belongs somewhere else?
bool Vector3::Valid() {
    if (((this->x > -1) && (this->x < 1)) && ((this->y > -1) && (this->y < 1)) && ((this->z > -1) && (this->z < 1))) {
        return false;
    }

    return true;
}

std::string Vector3::ToString() {
    return std::format("x: {:f}, y: {:f}, z: {:f}", this->x, this->y, this->z);
}