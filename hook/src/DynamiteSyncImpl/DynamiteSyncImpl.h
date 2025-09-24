
#ifndef HOOK_DYNAMITESYNCIMPL_H
#define HOOK_DYNAMITESYNCIMPL_H

class DynamiteSyncImpl {
  public:
    DynamiteSyncImpl();
    void Init();
    void Update();
    void Write();

    void* gameSocket = nullptr;
};

#endif // HOOK_DYNAMITESYNCIMPL_H
