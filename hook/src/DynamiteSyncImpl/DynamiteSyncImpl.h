
#ifndef HOOK_DYNAMITESYNCIMPL_H
#define HOOK_DYNAMITESYNCIMPL_H
#include "DynamiteSyncSchema_generated.h"
#include "Tpp/TppTypes.h"

class DynamiteSyncImpl {
  public:
    DynamiteSyncImpl();
    ~DynamiteSyncImpl();

    void Init();
    void Update();
    void Write();
    bool Send(flatbuffers::FlatBufferBuilder *builder) const;

    void AddFixedUserMarker(const Vector3 *pos) const;
    static void HandleAddFixedUserMarker(const DynamiteMessage::MessageWrapper *w);

    void AddFollowUserMarker(const Vector3 *pos, uint32_t objectID) const;
    static void HandleAddFollowUserMarker(const DynamiteMessage::MessageWrapper *w);

    void RemoveUserMarker(uint32_t markerID) const;
    static void HandleRemoveUserMarker(const DynamiteMessage::MessageWrapper *w);

    void SetSightMarker(uint32_t objectID, uint32_t duration) const;
    static void HandleSetSightMarker(const DynamiteMessage::MessageWrapper *w);

    void HandleSyncVar(const DynamiteMessage::MessageWrapper *w);

    void *gameSocket = nullptr;
};

#endif // HOOK_DYNAMITESYNCIMPL_H
