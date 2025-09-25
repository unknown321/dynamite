#include "DynamiteSyncImpl.h"

#include "DynamiteHook.h"
#include "DynamiteSyncSchema_generated.h"
#include "flatbuffers/flatbuffers.h"
#include "mgsvtpp_func_typedefs.h"
#include "spdlog/spdlog.h"
#include "util.h"

DynamiteSyncImpl::DynamiteSyncImpl() = default;

DynamiteSyncImpl::~DynamiteSyncImpl() { FoxNtImplGameSocketImplGameSocketImplDtor(this->gameSocket); }

void DynamiteSyncImpl::Init() {
    spdlog::info("{}", __PRETTY_FUNCTION__);
    if (this->gameSocket != nullptr) {
        FoxNtImplGameSocketImplGameSocketImplDtor(this->gameSocket);
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
        // spdlog::info("{}, {}: {}", __PRETTY_FUNCTION__, i, packet);
        // auto packetSize = FoxNtImplGameSocketImplGetPacketSize(this->gameSocket, 0, i);
        // spdlog::info("{}, {}: size {}", __PRETTY_FUNCTION__, i, packetSize);
        // spdlog::info("{}, contents {}", __PRETTY_FUNCTION__, bytes_to_hex(packet, packetSize));

        auto wrapper = DynamiteMessage::GetMessageWrapper(packet);
        switch (wrapper->msg_type()) {
        case DynamiteMessage::Message_AddFixedUserMarker:
            HandleAddFixedUserMarker(wrapper);
            break;
        case DynamiteMessage::Message_AddFollowUserMarker:
            HandleAddFollowUserMarker(wrapper);
            break;
        case DynamiteMessage::Message_RemoveUserMarker:
            HandleRemoveUserMarker(wrapper);
            break;
        case DynamiteMessage::Message_SetSightMarker:
            HandleSetSightMarker(wrapper);
            break;
        case DynamiteMessage::Message_SyncVar:
            HandleSyncVar(wrapper);
            break;
        default:
            spdlog::error("{}, unknown message type", __PRETTY_FUNCTION__);
            break;
        }
    }
}

void DynamiteSyncImpl::HandleAddFixedUserMarker(const DynamiteMessage::MessageWrapper *w) {
    if (Dynamite::MarkerSystemImpl == nullptr) {
        spdlog::error("{}, marker system is null!", __PRETTY_FUNCTION__);
        return;
    }

    const auto m = w->msg_as_AddFixedUserMarker();
    spdlog::info("{}: x: {}, y: {}, z: {}", __PRETTY_FUNCTION__, m->pos()->x(), m->pos()->y(), m->pos()->z());
    auto vv = Vector3{
        .x = m->pos()->x(),
        .y = m->pos()->y(),
        .z = m->pos()->z(),
    };

    Marker2SystemImplPlacedUserMarkerFixed(Dynamite::MarkerSystemImpl, &vv);
}

void DynamiteSyncImpl::AddFollowUserMarker(const Vector3 *pos, uint32_t objectID) const {
    flatbuffers::FlatBufferBuilder builder(128);
    const auto p = DynamiteMessage::Vec3(pos->x, pos->y, pos->z);
    const auto sv = DynamiteMessage::CreateAddFollowUserMarker(builder, &p, objectID);
    const auto message = DynamiteMessage::CreateMessageWrapper(builder, DynamiteMessage::Message_AddFollowUserMarker, sv.Union());
    builder.Finish(message);
    auto res = Send(&builder);
    spdlog::info("{}: {}", __PRETTY_FUNCTION__, res);
}

void DynamiteSyncImpl::HandleAddFollowUserMarker(const DynamiteMessage::MessageWrapper *w) {
    if (Dynamite::MarkerSystemImpl == nullptr) {
        spdlog::error("{}, marker system is null!", __PRETTY_FUNCTION__);
        return;
    }

    const auto m = w->msg_as_AddFollowUserMarker();
    auto vv = Vector3{
        .x = m->pos()->x(),
        .y = m->pos()->y(),
        .z = m->pos()->z(),
    };

    spdlog::info("{}: x: {}, y: {}, z: {}, objectID: {}", __PRETTY_FUNCTION__, m->pos()->x(), m->pos()->y(), m->pos()->z(), m->object_id());
    auto ok = Marker2SystemImplPlacedUserMarkerFollow(Dynamite::MarkerSystemImpl, &vv, m->object_id());
    spdlog::info("{}: {}", __PRETTY_FUNCTION__, ok);
}

void DynamiteSyncImpl::RemoveUserMarker(const uint32_t markerID) const {
    flatbuffers::FlatBufferBuilder builder(128);
    auto sv = DynamiteMessage::CreateRemoveUserMarker(builder, markerID);
    auto message = DynamiteMessage::CreateMessageWrapper(builder, DynamiteMessage::Message_RemoveUserMarker, sv.Union());
    builder.Finish(message);
    auto res = Send(&builder);
    spdlog::info("{}: {}", __PRETTY_FUNCTION__, res);
}

void DynamiteSyncImpl::HandleRemoveUserMarker(const DynamiteMessage::MessageWrapper *w) {
    if (Dynamite::MarkerSystemImpl == nullptr) {
        spdlog::error("{}, marker system is null!", __PRETTY_FUNCTION__);
        return;
    }

    const auto m = w->msg_as_RemoveUserMarker();
    spdlog::info("{}, id {}", __PRETTY_FUNCTION__, m->marker_id());
    Marker2SystemImplRemovedUserMarker(Dynamite::MarkerSystemImpl, m->marker_id());
}

void DynamiteSyncImpl::SetSightMarker(const uint32_t objectID, const uint32_t duration) const {
    flatbuffers::FlatBufferBuilder builder(128);
    const auto sv = DynamiteMessage::CreateSetSightMarker(builder, objectID, duration);
    const auto message = DynamiteMessage::CreateMessageWrapper(builder, DynamiteMessage::Message_SetSightMarker, sv.Union());
    builder.Finish(message);
    auto res = Send(&builder);
    spdlog::info("{}: {}", __PRETTY_FUNCTION__, res);
}

void DynamiteSyncImpl::HandleSetSightMarker(const DynamiteMessage::MessageWrapper *w) {
    if (Dynamite::SightManagerImpl == nullptr) {
        spdlog::error("{}, sight manager is null!", __PRETTY_FUNCTION__);
        return;
    }

    const auto m = w->msg_as_SetSightMarker();
    spdlog::info("{}, objectID {}, duration {}", __PRETTY_FUNCTION__, m->object_id(), m->duration());
    auto ok = SightManagerImplSetMarker(Dynamite::SightManagerImpl, m->object_id(), m->duration());
    spdlog::info("{}: {}", __PRETTY_FUNCTION__, ok);
}

void DynamiteSyncImpl::SyncVar(const std::string &catName, const std::string &varName) {
    const auto hash = (uint32_t)(FoxStrHash32(varName.c_str(), varName.length()) & 0xffffffff);
    const auto catHash = (uint32_t)(FoxStrHash32(catName.c_str(), catName.length()) & 0xffffffff);

    auto qt = GetQuarkSystemTable();
    auto v1 = *(uint64_t *)((char *)qt + 0x98);
    const auto scriptSystemImpl = *(void **)(v1 + 0x18);

    auto r = malloc(8);
    auto handle = TppGmImplScriptSystemImplGetScriptDeclVarHandle(scriptSystemImpl, r, catHash, hash);
    free(r);
    if (handle == nullptr) {
        spdlog::error("{}, no handle for var {}.{}", __PRETTY_FUNCTION__, catName, varName);
        return;
    }

    auto varType = *(byte *)((char *)handle + 0xC) & 7;
    if (varType > TppVarType::TYPE_MAX) {
        spdlog::error("{}, invalid var type {}.{} {}", __PRETTY_FUNCTION__, catName, varName, varType);
        return;
    }

    auto varSize = *(unsigned short *)((char *)handle + 0x8);
    if (varSize == 0) {
        spdlog::error("{}, invalid var size {}.{}: {}", __PRETTY_FUNCTION__, catName, varName, varSize);
        return;
    }

    spdlog::info("{}: {}, type {}, size {}", __PRETTY_FUNCTION__, varName, varType, varSize);

    auto s = 1;
    switch (varType) {
    case TppVarType::TYPE_INT32:
    case TppVarType::TYPE_UINT32:
    case TppVarType::TYPE_FLOAT:
        s = 4;
        break;
    case TppVarType::TYPE_INT8:
    case TppVarType::TYPE_UINT8:
        s = 1;
        break;
    case TppVarType::TYPE_INT16:
    case TppVarType::TYPE_UINT16:
        s = 2;
        break;
    case TppVarType::TYPE_BOOL:
    default:
        break;
    }

    for (int i = 0; i < varSize; i++) {
        if (varType == TppVarType::TYPE_BOOL) {
            const auto dataStart = *(unsigned short*)((char*)handle + 0xA);
            const auto offset = *(uint64_t*)handle;
            auto res = (*(byte *)(((i + dataStart) >> 3) + offset) & 1 << ((byte)(i + dataStart) & 7)) != 0;

            spdlog::info("{}, {}, {}: {}", __PRETTY_FUNCTION__, varName, i,  res);
        }

        const auto value = *(uint64_t *)handle + (*(unsigned short *)((uint64_t)handle + 0xA) + i) * s;
        switch (varType) {
        case TppVarType::TYPE_INT32:
            spdlog::info("{}, {}, {}: {}", __PRETTY_FUNCTION__, varName, i, *(int32_t *)value);
            break;
        case TppVarType::TYPE_UINT32:
            spdlog::info("{}, {} {}: {}", __PRETTY_FUNCTION__, varName, i, *(uint32_t *)value);
            break;
        case TppVarType::TYPE_FLOAT:
            spdlog::info("{}, {} {}: {}", __PRETTY_FUNCTION__, varName, i, *(float *)value);
            break;
        case TppVarType::TYPE_INT8:
            spdlog::info("{}, {} {}: {:d}", __PRETTY_FUNCTION__, varName, i, *(signed char *)value);
            break;
        case TppVarType::TYPE_UINT8:
            spdlog::info("{}, {} {}: {}", __PRETTY_FUNCTION__, varName, i, *(unsigned char *)value);
            break;
        case TppVarType::TYPE_INT16:
            spdlog::info("{}, {} {}: {}", __PRETTY_FUNCTION__, varName, i, *(short *)value);
            break;
        case TppVarType::TYPE_UINT16:
            spdlog::info("{}, {} {}: {}", __PRETTY_FUNCTION__, varName, i, *(unsigned short *)value);
            break;
        case TppVarType::TYPE_BOOL:
        default:
            break;
        }
    }
}

void DynamiteSyncImpl::HandleSyncVar(const DynamiteMessage::MessageWrapper *w) {
    auto m = w->msg_as_SyncVar();
    spdlog::info("{}: {}", __PRETTY_FUNCTION__, m->text()->c_str());
}

bool DynamiteSyncImpl::Send(flatbuffers::FlatBufferBuilder *builder) const {
    if (gameSocket == nullptr) {
        spdlog::info("{}, socket is null", __PRETTY_FUNCTION__);
        return false;
    }

    uint8_t *buf = builder->GetBufferPointer();
    int size = builder->GetSize();
    if (size == 0 || size > 1000) {
        spdlog::info("{}, invalid size", __PRETTY_FUNCTION__, size);
        return false;
    }

    if (buf == nullptr) {
        spdlog::info("{}, buffer is null", __PRETTY_FUNCTION__);
        return false;
    }

    // spdlog::info("{}: {} {}", __PRETTY_FUNCTION__, size, bytes_to_hex(buf, size));

    auto target = 0;
    if (Dynamite::cfg.Host) {
        target = 1;
    }

    FoxNtImplGameSocketImplRequestToSendToMember(gameSocket, target, 0, buf, size);
    return true;
}

void DynamiteSyncImpl::AddFixedUserMarker(const Vector3 *pos) const {
    flatbuffers::FlatBufferBuilder builder(128);
    const auto p = DynamiteMessage::Vec3(pos->x, pos->y, pos->z);
    const auto sv = DynamiteMessage::CreateAddFixedUserMarker(builder, &p);
    const auto message = DynamiteMessage::CreateMessageWrapper(builder, DynamiteMessage::Message_AddFixedUserMarker, sv.Union());
    builder.Finish(message);
    auto res = Send(&builder);
    spdlog::info("{}: {}", __PRETTY_FUNCTION__, res);
}

void DynamiteSyncImpl::Write() {
    spdlog::info("{}", __PRETTY_FUNCTION__);

    if (gameSocket == nullptr) {
        spdlog::info("{}, socket is null", __PRETTY_FUNCTION__);
        return;
    }

    flatbuffers::FlatBufferBuilder builder(1000);
    flatbuffers::Offset<flatbuffers::String> weapon_one_name = builder.CreateString("Sword");
    auto sv = DynamiteMessage::CreateSyncVar(builder, weapon_one_name);
    auto message = DynamiteMessage::CreateMessageWrapper(builder, DynamiteMessage::Message_SyncVar, sv.Union());
    builder.Finish(message);
    uint8_t *buf = builder.GetBufferPointer();
    int size = builder.GetSize();
    if (size == 0 || size > 1000) {
        // fail
    }

    if (buf == nullptr) {
        // fail
    }

    spdlog::info("{}: {} {}", __PRETTY_FUNCTION__, size, bytes_to_hex(buf, size));

    auto target = 0;
    if (Dynamite::cfg.Host) {
        target = 1;
    }

    FoxNtImplGameSocketImplRequestToSendToMember(gameSocket, target, 0, buf, size);
}
