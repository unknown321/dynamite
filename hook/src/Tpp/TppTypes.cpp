#include "TppTypes.h"


bool Vector3::Valid() {
    if (((this->x > -1) && (this->x < 1)) && ((this->y > -1) && (this->y < 1)) && ((this->z > -1) && (this->z < 1))) {
        return false;
    }
    return true;
}
