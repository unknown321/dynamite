#include "DynamiteSyncImpl.h"
#include "mgsvtpp_func_typedefs.h"
#include "spdlog/spdlog.h"
#include "util.h"

DynamiteSyncImpl::DynamiteSyncImpl() = default;

void DynamiteSyncImpl::Init() {
    spdlog::info("{}", __PRETTY_FUNCTION__);
    if (gameSocket != nullptr) {
        return;
    }

    auto qt = GetQuarkSystemTable();
    auto networkSystemImpl = *(void **)((char *)qt + 0x78);
    auto desc = fox::nt::GameSocketDesc{
        .number = 90,
        .value = 2,
    };
    gameSocket = FoxNtImplNetworkSystemImplCreateGameSocket(networkSystemImpl, &desc);
};

void DynamiteSyncImpl::Update() {
    if (gameSocket == nullptr) {
        return;
    }

    auto packetCount = FoxNtImplGameSocketImplGetPacketCount(this->gameSocket, 0);
    if (packetCount < 1) {
        return;
    }

    for (int i = 0; i < packetCount; i++) {
        auto packet = FoxNtImplGameSocketImplGetPacket(this->gameSocket, 0, i);
        spdlog::info("{}, {}: {}", __PRETTY_FUNCTION__, i, packet);
        auto packetSize = FoxNtImplGameSocketImplGetPacketSize(this->gameSocket, 0, i);
        spdlog::info("{}, {}: size {}", __PRETTY_FUNCTION__, i, packetSize);
        spdlog::info("{}, contents {}", __PRETTY_FUNCTION__, bytes_to_hex(packet, packetSize));
    }
}

void DynamiteSyncImpl::Write() {
    spdlog::info("{}", __PRETTY_FUNCTION__);
    if (gameSocket == nullptr) {
        spdlog::info("{}, socket is null", __PRETTY_FUNCTION__);
        return;
    }

    auto b = malloc(20);
    memset(b, 7, 20);
    FoxNtImplGameSocketImplRequestToSendToMember(gameSocket, 1, 0, b, 20);
    free(b);
}
