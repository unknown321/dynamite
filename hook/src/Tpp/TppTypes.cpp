#include "TppTypes.h"


// usually there are no objects at 0,0,0
// this function belongs somewhere else?
bool Vector3::Valid() {
    if (((this->x > -1) && (this->x < 1)) && ((this->y > -1) && (this->y < 1)) && ((this->z > -1) && (this->z < 1))) {
        return false;
    }

    return true;
}
