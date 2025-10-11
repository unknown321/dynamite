#include "DynamiteSyncImpl.h"

#include "DynamiteHook.h"
#include "DynamiteSyncSchema_generated.h"
#include "flatbuffers/flatbuffers.h"
#include "memtag.h"
#include "mgsvtpp_func_typedefs.h"
#include "spdlog/spdlog.h"
#include "util.h"

#include <ranges>
#include <vector>

DynamiteSyncImpl::DynamiteSyncImpl() = default;

DynamiteSyncImpl::~DynamiteSyncImpl() {
    Stop();
    if (this->gameSocket != nullptr) {
        FoxNtImplGameSocketImplGameSocketImplDtor(this->gameSocket, 1);
    }
}

void DynamiteSyncImpl::SyncInit() {
    spdlog::info("{}", __PRETTY_FUNCTION__);
    syncStatus.clear();

    for (const auto &v : enemyVars) {
        spdlog::info("{}, {}", __PRETTY_FUNCTION__, v);
        syncStatus[v] = false;
    }
}

void DynamiteSyncImpl::Init() {
    spdlog::info("{}", __PRETTY_FUNCTION__);

    packetNumber = 0;
    packetSeen = 0;
}

void DynamiteSyncImpl::Stop() {
    spdlog::info("{}", __PRETTY_FUNCTION__);
    if (syncThread.joinable()) {
        syncThread.request_stop();
        syncThread.join();
    }
    spdlog::info("{}, sync thread {}", __PRETTY_FUNCTION__, syncThread.joinable());

    packetNumber = 0;
    packetSeen = 0;
}

void DynamiteSyncImpl::RemoveGameSocket() {
    spdlog::info("{}", __PRETTY_FUNCTION__);
    if (this->gameSocket != nullptr) {
        spdlog::info("{}, removing socket", __PRETTY_FUNCTION__);
        FoxNtImplGameSocketImplGameSocketImplDtor(this->gameSocket, 1);
        this->gameSocket = nullptr;
    } else {
        spdlog::info("{}, no socket", __PRETTY_FUNCTION__);
    }
}

bool DynamiteSyncImpl::IsSynchronized() {
    if (std::ranges::all_of(syncStatus, [](const auto &pair) { return pair.second; })) {
        spdlog::info("{}, sync done", __PRETTY_FUNCTION__);
        return true;
    }

    return false;
}

void DynamiteSyncImpl::CreateGameSocket() {
    auto qt = GetQuarkSystemTable();
    // auto a = *(void **)((char *)qt + 0x98);
    // auto statusController = *(void **)((char *)a + 0xf8);
    // if (!StatusControllerImplIsSet(statusController, S_IS_ONLINE)) {
    //     spdlog::info("{}, no online flag", __PRETTY_FUNCTION__);
    //     return;
    // }

    const auto networkSystemImpl = *(void **)((char *)qt + 0x78);
    auto desc = fox::nt::GameSocketDesc{
        .socketNumber = 90,
        .value = 1,
    };

    if (this->gameSocket == nullptr) {
        this->gameSocket = FoxNtImplNetworkSystemImplCreateGameSocket(networkSystemImpl, &desc);
        spdlog::info("{}, socket {}", __PRETTY_FUNCTION__, this->gameSocket);
        FoxNtImplGameSocketImplSetInterval(this->gameSocket, 90, 0, 0);
        FoxNtImplGameSocketImplSetInterval(this->gameSocket, 90, 1, 0);
    }
}

void DynamiteSyncImpl::WaitForSync() {
    spdlog::info("{}", __PRETTY_FUNCTION__);
    if (syncStatus.size() == 0) {
        spdlog::info("{} nothing to wait for", __PRETTY_FUNCTION__);
        return;
    }

    if (syncThread.joinable()) {
        syncThread.request_stop();
        syncThread.join();
    }

    syncThread = std::jthread([this](const std::stop_token &stoken) {
        spdlog::info("{}, starting sync thread", __PRETTY_FUNCTION__);
        while (!stoken.stop_requested()) {
            for (const auto &[key, value] : syncStatus) {
                if (value) {
                    continue;
                }

                RequestVar("svars", key);
            }

            if (IsSynchronized()) {
                break;
            }

            std::this_thread::sleep_for(std::chrono::milliseconds(500));
        }

        spdlog::info("{}, stopping sync thread", __PRETTY_FUNCTION__);
    });
}

void DynamiteSyncImpl::Ping() {
    spdlog::info("{}", __PRETTY_FUNCTION__);
    packetNumber++;
    flatbuffers::FlatBufferBuilder builder(512);
    const auto sv = DynamiteMessage::CreatePing(builder, 1);
    const auto message = DynamiteMessage::CreateMessageWrapper(builder, packetNumber, DynamiteMessage::Message_Ping, sv.Union());
    builder.Finish(message);
    auto res = SendRaw(&builder);
    spdlog::info("{}, res {}", __PRETTY_FUNCTION__, res);
}

void DynamiteSyncImpl::RequestVar(const std::string &catName, const std::string &varName) {
    packetNumber++;
    flatbuffers::FlatBufferBuilder builder(512);
    const flatbuffers::Offset<flatbuffers::String> category = builder.CreateString(catName);
    const flatbuffers::Offset<flatbuffers::String> name = builder.CreateString(varName);
    const auto sv = DynamiteMessage::CreateRequestVar(builder, category, name);
    const auto message = DynamiteMessage::CreateMessageWrapper(builder, packetNumber, DynamiteMessage::Message_RequestVar, sv.Union());
    builder.Finish(message);
    auto res = SendRaw(&builder);
    spdlog::info("{}, request for {}.{}, res {}", __PRETTY_FUNCTION__, catName, varName, res);
}

void DynamiteSyncImpl::HandleRequestVar(const DynamiteMessage::MessageWrapper *w) {
    const auto m = w->msg_as_RequestVar();
    SyncVar(m->category()->c_str(), m->name()->c_str());
}

void DynamiteSyncImpl::HandleAddFixedUserMarker(const DynamiteMessage::MessageWrapper *w) {
    if (Dynamite::MarkerSystemImpl == nullptr) {
        spdlog::error("{}, marker system is null!", __PRETTY_FUNCTION__);
        return;
    }

    auto m = w->msg_as_AddFixedUserMarker();
    auto pos = m->pos();
    spdlog::info("{}: x: {:f}, y: {:f}, z: {:f}", __PRETTY_FUNCTION__, pos->x(), pos->y(), pos->z());
    auto vv = Vector3{
        .x = pos->x(),
        .y = pos->y(),
        .z = pos->z(),
    };

    Marker2SystemImplPlacedUserMarkerFixed(Dynamite::MarkerSystemImpl, &vv);
}

void DynamiteSyncImpl::AddFollowUserMarker(const Vector3 *pos, uint32_t objectID) {
    packetNumber++;
    flatbuffers::FlatBufferBuilder builder(128);
    const auto p = DynamiteMessage::Vec3(pos->x, pos->y, pos->z);
    const auto sv = DynamiteMessage::CreateAddFollowUserMarker(builder, &p, objectID);
    const auto message = DynamiteMessage::CreateMessageWrapper(builder, packetNumber, DynamiteMessage::Message_AddFollowUserMarker, sv.Union());
    builder.Finish(message);
    auto res = SendRaw(&builder);
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

void DynamiteSyncImpl::RemoveUserMarker(const uint32_t markerID) {
    packetNumber++;
    flatbuffers::FlatBufferBuilder builder(128);
    auto sv = DynamiteMessage::CreateRemoveUserMarker(builder, markerID);
    auto message = DynamiteMessage::CreateMessageWrapper(builder, packetNumber, DynamiteMessage::Message_RemoveUserMarker, sv.Union());
    builder.Finish(message);
    auto res = SendRaw(&builder);
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

void DynamiteSyncImpl::SetSightMarker(const uint32_t objectID, const uint32_t duration) {
    packetNumber++;
    flatbuffers::FlatBufferBuilder builder(128);
    const auto sv = DynamiteMessage::CreateSetSightMarker(builder, objectID, duration);
    const auto message = DynamiteMessage::CreateMessageWrapper(builder, packetNumber, DynamiteMessage::Message_SetSightMarker, sv.Union());
    builder.Finish(message);
    auto res = SendRaw(&builder);
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

void DynamiteSyncImpl::GetVar(const std::string &catName, const std::string &varName) {
    const auto hash = (uint32_t)(FoxStrHash32(varName.c_str(), varName.length()) & 0xffffffff);
    const auto catHash = (uint32_t)(FoxStrHash32(catName.c_str(), catName.length()) & 0xffffffff);

    const auto qt = GetQuarkSystemTable();
    const auto v1 = *(uint64_t *)((char *)qt + 0x98);
    const auto scriptSystemImpl = *(void **)(v1 + 0x18);

    auto handle = BlockHeapAlloc(8, 8, MEMTAG_TPP_SYSTEM2SCRIPT);
    TppGmImplScriptSystemImplGetScriptDeclVarHandle(scriptSystemImpl, handle, catHash, hash);
    if (handle == nullptr) {
        spdlog::error("{}, no handle for var {}.{}", __PRETTY_FUNCTION__, catName, varName);
        return;
    }

    auto varType = *(byte *)((char *)handle + 0xC) & 7;
    if (varType > TYPE_MAX) {
        spdlog::error("{}, invalid var type {}.{} {}", __PRETTY_FUNCTION__, catName, varName, varType);
        return;
    }

    auto arraySize = *(unsigned short *)((char *)handle + 0x8);
    if (arraySize == 0) {
        spdlog::error("{}, invalid var size {}.{}: {}", __PRETTY_FUNCTION__, catName, varName, arraySize);
        return;
    }

    spdlog::info("{}: {}, type {}, size {}", __PRETTY_FUNCTION__, varName, varType, arraySize);

    auto elementSize = 1;

    switch (varType) {
    case TYPE_INT32:
        elementSize = 4;
        break;
    case TYPE_UINT32:
        elementSize = 4;
        break;
    case TYPE_FLOAT:
        elementSize = 4;
        break;
    case TYPE_INT8:
        elementSize = 1;
        break;
    case TYPE_UINT8:
        elementSize = 1;
        break;
    case TYPE_INT16:
        elementSize = 2;
        break;
    case TYPE_UINT16:
        elementSize = 2;
        break;
    case TYPE_BOOL:
        break;
    default:
        break;
    }

    std::vector<bool> bools;
    std::vector<int32_t> int32s;
    std::vector<uint32_t> uint32s;
    std::vector<float> floats;
    std::vector<int8_t> int8s;
    std::vector<uint8_t> uint8s;
    std::vector<int16_t> int16s;
    std::vector<uint16_t> uint16s;

    const auto dataStart = *(unsigned short *)((char *)handle + 0xA);
    const auto offset = *(uint64_t *)handle;
    BlockHeapFree(handle);
    for (int i = 0; i < arraySize; i++) {
        if (varType == TYPE_BOOL) {
            auto res = (*(byte *)(((i + dataStart) >> 3) + offset) & 1 << ((byte)(i + dataStart) & 7)) != 0;
            bools.push_back(res);

            spdlog::info("{}, {}, {}: {}", __PRETTY_FUNCTION__, varName, i, res);
            continue;
        }

        auto value = offset + (dataStart + i) * elementSize;
        switch (varType) {
        case TYPE_INT32:
            spdlog::info("{}, {}, {}: {}", __PRETTY_FUNCTION__, varName, i, *(int32_t *)value);
            int32s.push_back(*(int32_t *)value);
            break;
        case TYPE_UINT32: {
            spdlog::info("{}, {} {}: {}", __PRETTY_FUNCTION__, varName, i, *(uint32_t *)value);
            uint32s.push_back(*(uint32_t *)value);
            break;
        }
        case TYPE_FLOAT:
            spdlog::info("{}, {} {}: {}", __PRETTY_FUNCTION__, varName, i, *(float *)value);
            floats.push_back(*(float *)value);
            break;
        case TYPE_INT8:
            spdlog::info("{}, {} {}: {:d}", __PRETTY_FUNCTION__, varName, i, *(signed char *)value);
            int8s.push_back(*(int8_t *)value);
            break;
        case TYPE_UINT8:
            spdlog::info("{}, {} {}: {}", __PRETTY_FUNCTION__, varName, i, *(unsigned char *)value);
            uint8s.push_back(*(uint8_t *)value);
            break;
        case TYPE_INT16:
            spdlog::info("{}, {} {}: {}", __PRETTY_FUNCTION__, varName, i, *(short *)value);
            int16s.push_back(*(int16_t *)value);
            break;
        case TYPE_UINT16:
            spdlog::info("{}, {} {}: {}", __PRETTY_FUNCTION__, varName, i, *(unsigned short *)value);
            uint16s.push_back(*(uint16_t *)value);
            break;
        case TYPE_BOOL:
        default:
            break;
        }
    }
}

void DynamiteSyncImpl::SyncVar(const std::string &catName, const std::string &varName) {
    const auto hash = (uint32_t)(FoxStrHash32(varName.c_str(), varName.length()) & 0xffffffff);
    const auto catHash = (uint32_t)(FoxStrHash32(catName.c_str(), catName.length()) & 0xffffffff);

    const auto qt = GetQuarkSystemTable();
    const auto v1 = *(uint64_t *)((char *)qt + 0x98);
    const auto scriptSystemImpl = *(void **)(v1 + 0x18);

    auto handle = BlockHeapAlloc(8, 8, MEMTAG_TPP_SYSTEM2SCRIPT);
    TppGmImplScriptSystemImplGetScriptDeclVarHandle(scriptSystemImpl, handle, catHash, hash);
    if (handle == nullptr) {
        spdlog::error("{}, no handle for var {}.{}", __PRETTY_FUNCTION__, catName, varName);
        return;
    }

    auto varType = *(byte *)((char *)handle + 0xC) & 7;
    if (varType > TYPE_MAX) {
        spdlog::error("{}, invalid var type {}.{} {}", __PRETTY_FUNCTION__, catName, varName, varType);
        return;
    }

    auto arraySize = *(unsigned short *)((char *)handle + 0x8);
    if (arraySize == 0) {
        spdlog::error("{}, invalid var size {}.{}: {}", __PRETTY_FUNCTION__, catName, varName, arraySize);
        return;
    }

    spdlog::info("{}: {}, type {}, size {}", __PRETTY_FUNCTION__, varName, varType, arraySize);

    auto elementSize = 1;

    DynamiteMessage::ArrayValues valType = DynamiteMessage::ArrayValues_NONE;

    switch (varType) {
    case TYPE_INT32:
        valType = DynamiteMessage::ArrayValues_Int32;
        elementSize = 4;
        break;
    case TYPE_UINT32:
        valType = DynamiteMessage::ArrayValues_Uint32;
        elementSize = 4;
        break;
    case TYPE_FLOAT:
        valType = DynamiteMessage::ArrayValues_Float;
        elementSize = 4;
        break;
    case TYPE_INT8:
        valType = DynamiteMessage::ArrayValues_Int8;
        elementSize = 1;
        break;
    case TYPE_UINT8:
        valType = DynamiteMessage::ArrayValues_Uint8;
        elementSize = 1;
        break;
    case TYPE_INT16:
        valType = DynamiteMessage::ArrayValues_Int16;
        elementSize = 2;
        break;
    case TYPE_UINT16:
        valType = DynamiteMessage::ArrayValues_Uint16;
        elementSize = 2;
        break;
    case TYPE_BOOL:
        valType = DynamiteMessage::ArrayValues_Bool;
        break;
    default:
        break;
    }

    if (valType == DynamiteMessage::ArrayValues_NONE) {
        spdlog::error("{}, valType is NONE", __PRETTY_FUNCTION__);
        return;
    }

    std::vector<bool> bools;
    std::vector<int32_t> int32s;
    std::vector<uint32_t> uint32s;
    std::vector<float> floats;
    std::vector<int8_t> int8s;
    std::vector<uint8_t> uint8s;
    std::vector<int16_t> int16s;
    std::vector<uint16_t> uint16s;

    const auto dataStart = *(unsigned short *)((char *)handle + 0xA);
    const auto offset = *(uint64_t *)handle;
    BlockHeapFree(handle);
    for (int i = 0; i < arraySize; i++) {
        if (varType == TYPE_BOOL) {
            auto res = (*(byte *)(((i + dataStart) >> 3) + offset) & 1 << ((byte)(i + dataStart) & 7)) != 0;
            bools.push_back(res);

            spdlog::info("{}, {}, {}: {}", __PRETTY_FUNCTION__, varName, i, res);
            continue;
        }

        auto value = offset + (dataStart + i) * elementSize;
        // spdlog::info("{}, {}, value addr {:x}, offset {:x}", __PRETTY_FUNCTION__, i, value, offset);
        switch (varType) {
        case TYPE_INT32:
            spdlog::info("{}, {}, {}: {}", __PRETTY_FUNCTION__, varName, i, *(int32_t *)value);
            int32s.push_back(*(int32_t *)value);
            break;
        case TYPE_UINT32: {
            if (*(uint32_t *)value != 0) {
                spdlog::info("{}, {} {}: {}", __PRETTY_FUNCTION__, varName, i, *(uint32_t *)value);
            }
            uint32s.push_back(*(uint32_t *)value);
            break;
        }
        case TYPE_FLOAT:
            spdlog::info("{}, {} {}: {}", __PRETTY_FUNCTION__, varName, i, *(float *)value);
            floats.push_back(*(float *)value);
            break;
        case TYPE_INT8:
            spdlog::info("{}, {} {}: {:d}", __PRETTY_FUNCTION__, varName, i, *(signed char *)value);
            int8s.push_back(*(int8_t *)value);
            break;
        case TYPE_UINT8:
            spdlog::info("{}, {} {}: {}", __PRETTY_FUNCTION__, varName, i, *(unsigned char *)value);
            uint8s.push_back(*(uint8_t *)value);
            break;
        case TYPE_INT16:
            spdlog::info("{}, {} {}: {}", __PRETTY_FUNCTION__, varName, i, *(short *)value);
            int16s.push_back(*(int16_t *)value);
            break;
        case TYPE_UINT16:
            spdlog::info("{}, {} {}: {}", __PRETTY_FUNCTION__, varName, i, *(unsigned short *)value);
            uint16s.push_back(*(uint16_t *)value);
            break;
        case TYPE_BOOL:
        default:
            break;
        }
    }

    spdlog::info("{}, values pushed", __PRETTY_FUNCTION__);

    flatbuffers::FlatBufferBuilder builder(1024);
    const flatbuffers::Offset<flatbuffers::String> category = builder.CreateString(catName);
    const flatbuffers::Offset<flatbuffers::String> name = builder.CreateString(varName);

    flatbuffers::Offset<DynamiteMessage::Bool> bools_offset;
    flatbuffers::Offset<DynamiteMessage::Int8> int8s_offset;
    flatbuffers::Offset<DynamiteMessage::Uint8> uint8s_offset;
    flatbuffers::Offset<DynamiteMessage::Int16> int16s_offset;
    flatbuffers::Offset<DynamiteMessage::Uint16> uint16s_offset;
    flatbuffers::Offset<DynamiteMessage::Int32> int32s_offset;
    flatbuffers::Offset<DynamiteMessage::Uint32> uint32s_offset;
    flatbuffers::Offset<DynamiteMessage::Float> floats_offset;

    switch (varType) {
    case TYPE_BOOL: {
        auto v = builder.CreateVector(bools);
        bools_offset = DynamiteMessage::CreateBool(builder, v);
        break;
    }
    case TYPE_INT32: {
        auto v = builder.CreateVector(int32s);
        int32s_offset = DynamiteMessage::CreateInt32(builder, v);
        break;
    }
    case TYPE_UINT32: {
        auto v = builder.CreateVector(uint32s);
        uint32s_offset = DynamiteMessage::CreateUint32(builder, v);
        break;
    }
    case TYPE_FLOAT: {
        auto v = builder.CreateVector(floats);
        floats_offset = DynamiteMessage::CreateFloat(builder, v);
        break;
    }
    case TYPE_INT8: {
        auto v = builder.CreateVector(int8s);
        int8s_offset = DynamiteMessage::CreateInt8(builder, v);
        break;
    }
    case TYPE_UINT8: {
        auto v = builder.CreateVector(uint8s);
        uint8s_offset = DynamiteMessage::CreateUint8(builder, v);
        break;
    }
    case TYPE_INT16: {
        auto v = builder.CreateVector(int16s);
        int16s_offset = DynamiteMessage::CreateInt16(builder, v);
        break;
    }
    case TYPE_UINT16: {
        auto v = builder.CreateVector(uint16s);
        uint16s_offset = DynamiteMessage::CreateUint16(builder, v);
        break;
    }
    default:
        break;
    }

    DynamiteMessage::SyncVarBuilder svb(builder);

    auto arrayStart = 0;
    svb.add_category(category);
    svb.add_name(name);
    svb.add_array_size(arraySize);
    svb.add_array_start(arrayStart);
    svb.add_array_values_type(valType);

    switch (varType) {
    case TYPE_BOOL: {
        svb.add_array_values(bools_offset.Union());
        break;
    }
    case TYPE_INT32: {
        svb.add_array_values(int32s_offset.Union());
        break;
    }
    case TYPE_UINT32: {
        svb.add_array_values(uint32s_offset.Union());
        break;
    }
    case TYPE_FLOAT: {
        svb.add_array_values(floats_offset.Union());
        break;
    }
    case TYPE_INT8: {
        svb.add_array_values(int8s_offset.Union());
        break;
    }
    case TYPE_UINT8: {
        svb.add_array_values(uint8s_offset.Union());
        break;
    }
    case TYPE_INT16: {
        svb.add_array_values(int16s_offset.Union());
        break;
    }
    case TYPE_UINT16: {
        svb.add_array_values(uint16s_offset.Union());
        break;
    }
    default:
        break;
    }
    auto svo = svb.Finish();

    packetNumber++;
    DynamiteMessage::MessageWrapperBuilder mwb(builder);
    mwb.add_msg_type(DynamiteMessage::Message_SyncVar);
    mwb.add_msg(svo.Union());
    mwb.add_packet_num(packetNumber);

    auto mo = mwb.Finish();
    builder.Finish(mo);
    auto res = SendRaw(&builder);
    spdlog::info("{}: send: {}", __PRETTY_FUNCTION__, res);
}

void DynamiteSyncImpl::HandleSyncVar(const DynamiteMessage::MessageWrapper *w) {
    const auto m = w->msg_as_SyncVar();
    spdlog::info("{}: {}.{}, size {}, start {}, type {}",
        __PRETTY_FUNCTION__,
        m->category()->c_str(),
        m->name()->c_str(),
        m->array_size(),
        m->array_start(),
        static_cast<short>(m->array_values_type()));

    void *vars = nullptr;
    if (strcmp(m->category()->c_str(), "gvars") == 0) {
        vars = TppGmGetGVars();
    }

    if (strcmp(m->category()->c_str(), "svars") == 0) {
        vars = TppGmGetSVars();
    }

    if (vars == nullptr) {
        spdlog::error("{}, bad category {}", __PRETTY_FUNCTION__, m->category()->c_str());
        return;
    }

    auto name = FoxStrHash32(m->name()->c_str(), strlen(m->name()->c_str())) & 0xffffffff;
    auto varIndex = TppGmImplScriptDeclVarsImplGetVarIndexWithName(vars, name);
    spdlog::info("{}, {}.{} index {}", __PRETTY_FUNCTION__, m->category()->c_str(), m->name()->c_str(), varIndex);
    if (varIndex == 0xffffffff) {
        spdlog::error("{}, cannot get var index for {}.{} ({:x})", __PRETTY_FUNCTION__, m->category()->c_str(), m->name()->c_str(), name);
        return;
    }

    bool res = false;
    switch (m->array_values_type()) {
    case DynamiteMessage::ArrayValues_Bool:
        res = SyncBoolVar(m, vars, varIndex);
        break;
    case DynamiteMessage::ArrayValues_Int32:
        res = SyncInt32Var(m, vars, varIndex);
        break;
    case DynamiteMessage::ArrayValues_Uint32:
        res = SyncUint32Var(m, vars, varIndex);
        break;
    case DynamiteMessage::ArrayValues_Float:
        res = SyncFloatVar(m, vars, varIndex);
        break;
    case DynamiteMessage::ArrayValues_Int8:
        res = SyncInt8Var(m, vars, varIndex);
        break;
    case DynamiteMessage::ArrayValues_Uint8:
        res = SyncUint8Var(m, vars, varIndex);
        break;
    case DynamiteMessage::ArrayValues_Int16:
        res = SyncInt16Var(m, vars, varIndex);
        break;
    case DynamiteMessage::ArrayValues_Uint16:
        res = SyncUint16Var(m, vars, varIndex);
        break;
    default:
        spdlog::error("{}, unknown array values type", __PRETTY_FUNCTION__);
        break;
    }

    syncStatus[m->name()->c_str()] = res;
}

bool DynamiteSyncImpl::SyncBoolVar(const DynamiteMessage::SyncVar *m, void *vars, const uint32_t varIndex) {
    const auto asBool = m->array_values_as_Bool();
    if (asBool == nullptr) {
        spdlog::error("{}, array values is null", __PRETTY_FUNCTION__);
        return false;
    }

    const auto values = asBool->value();
    if (values == nullptr) {
        spdlog::error("{}, values is null", __PRETTY_FUNCTION__);
        return false;
    }

    if (values->size() < 1) {
        spdlog::error("{}, {}.{} size is 0!", __PRETTY_FUNCTION__, m->category()->c_str(), m->name()->c_str());
        return false;
    }

    spdlog::info("{}, setting {}.{}", __PRETTY_FUNCTION__, m->name()->c_str(), m->category()->c_str());
    for (size_t i = 0; i < values->size(); i++) {
        const auto val = values->Get(i);
        ScriptDeclVarsImplSetVarValue(vars, varIndex, m->array_start() + i, 0, val);
    }

    spdlog::info("{}, {}.{}: done", __PRETTY_FUNCTION__, m->name()->c_str(), m->category()->c_str());
    return true;
}

bool DynamiteSyncImpl::SyncInt32Var(const DynamiteMessage::SyncVar *m, void *vars, const uint32_t varIndex) {
    const auto asInt32 = m->array_values_as_Int32();
    if (asInt32 == nullptr) {
        spdlog::error("{}, array values is null", __PRETTY_FUNCTION__);
        return false;
    }

    const auto values = asInt32->value();
    if (values == nullptr) {
        spdlog::error("{}, values is null", __PRETTY_FUNCTION__);
        return false;
    }

    if (values->size() < 1) {
        spdlog::error("{}, {}.{} size is 0!", __PRETTY_FUNCTION__, m->category()->c_str(), m->name()->c_str());
        return false;
    }

    spdlog::info("{}, setting {}.{}", __PRETTY_FUNCTION__, m->name()->c_str(), m->category()->c_str());
    for (size_t i = 0; i < values->size(); i++) {
        const auto val = values->Get(i);
        ScriptDeclVarsImplSetVarValue(vars, varIndex, m->array_start() + i, 0, val);
    }

    spdlog::info("{}, {}.{}: done", __PRETTY_FUNCTION__, m->name()->c_str(), m->category()->c_str());
    return true;
}

bool DynamiteSyncImpl::SyncUint32Var(const DynamiteMessage::SyncVar *m, void *vars, const uint32_t varIndex) {
    const auto as32 = m->array_values_as_Uint32();
    if (as32 == nullptr) {
        spdlog::error("{}, array values is null", __PRETTY_FUNCTION__);
        return false;
    }

    const auto values = as32->value();
    if (values == nullptr) {
        spdlog::error("{}, values is null", __PRETTY_FUNCTION__);
        return false;
    }

    if (values->size() < 1) {
        spdlog::error("{}, {}.{} size is 0!", __PRETTY_FUNCTION__, m->category()->c_str(), m->name()->c_str());
        return false;
    }

    GetVar(m->category()->c_str(), m->name()->c_str());
    spdlog::info("{}, setting {}.{}", __PRETTY_FUNCTION__, m->name()->c_str(), m->category()->c_str());
    for (size_t i = 0; i < values->size(); i++) {
        const auto val = values->Get(i);
        spdlog::info("{}, {}: {}", __PRETTY_FUNCTION__, i, val);
        ScriptDeclVarsImplSetVarValue(vars, varIndex, m->array_start() + i, 0, val);
    }
    GetVar(m->category()->c_str(), m->name()->c_str());

    spdlog::info("{}, {}.{}: done", __PRETTY_FUNCTION__, m->name()->c_str(), m->category()->c_str());
    return true;
}
bool DynamiteSyncImpl::SyncInt16Var(const DynamiteMessage::SyncVar *m, void *vars, const uint32_t varIndex) {
    const auto as16 = m->array_values_as_Int16();
    if (as16 == nullptr) {
        spdlog::error("{}, array values is null", __PRETTY_FUNCTION__);
        return false;
    }

    const auto values = as16->value();
    if (values == nullptr) {
        spdlog::error("{}, values is null", __PRETTY_FUNCTION__);
        return false;
    }

    if (values->size() < 1) {
        spdlog::error("{}, {}.{} size is 0!", __PRETTY_FUNCTION__, m->category()->c_str(), m->name()->c_str());
        return false;
    }

    spdlog::info("{}, setting {}.{}", __PRETTY_FUNCTION__, m->name()->c_str(), m->category()->c_str());
    for (size_t i = 0; i < values->size(); i++) {
        const auto val = values->Get(i);
        ScriptDeclVarsImplSetVarValue(vars, varIndex, m->array_start() + i, 0, val);
    }

    spdlog::info("{}, {}.{}: done", __PRETTY_FUNCTION__, m->name()->c_str(), m->category()->c_str());
    return true;
}

bool DynamiteSyncImpl::SyncUint16Var(const DynamiteMessage::SyncVar *m, void *vars, const uint32_t varIndex) {
    const auto as16 = m->array_values_as_Uint16();
    if (as16 == nullptr) {
        spdlog::error("{}, array values is null", __PRETTY_FUNCTION__);
        return false;
    }

    const auto values = as16->value();
    if (values == nullptr) {
        spdlog::error("{}, values is null", __PRETTY_FUNCTION__);
        return false;
    }

    if (values->size() < 1) {
        spdlog::error("{}, {}.{} size is 0!", __PRETTY_FUNCTION__, m->category()->c_str(), m->name()->c_str());
        return false;
    }

    spdlog::info("{}, setting {}.{}", __PRETTY_FUNCTION__, m->name()->c_str(), m->category()->c_str());
    for (size_t i = 0; i < values->size(); i++) {
        const auto val = values->Get(i);
        ScriptDeclVarsImplSetVarValue(vars, varIndex, m->array_start() + i, 0, val);
    }

    spdlog::info("{}, {}.{}: done", __PRETTY_FUNCTION__, m->name()->c_str(), m->category()->c_str());
    return true;
}

bool DynamiteSyncImpl::SyncInt8Var(const DynamiteMessage::SyncVar *m, void *vars, const uint32_t varIndex) {
    const auto as8 = m->array_values_as_Int8();
    if (as8 == nullptr) {
        spdlog::error("{}, array values is null", __PRETTY_FUNCTION__);
        return false;
    }

    const auto values = as8->value();
    if (values == nullptr) {
        spdlog::error("{}, values is null", __PRETTY_FUNCTION__);
        return false;
    }

    if (values->size() < 1) {
        spdlog::error("{}, {}.{} size is 0!", __PRETTY_FUNCTION__, m->category()->c_str(), m->name()->c_str());
        return false;
    }

    spdlog::info("{}, setting {}.{}", __PRETTY_FUNCTION__, m->name()->c_str(), m->category()->c_str());
    for (size_t i = 0; i < values->size(); i++) {
        const auto val = values->Get(i);
        ScriptDeclVarsImplSetVarValue(vars, varIndex, m->array_start() + i, 0, val);
    }

    spdlog::info("{}, {}.{}: done", __PRETTY_FUNCTION__, m->name()->c_str(), m->category()->c_str());
    return true;
}

bool DynamiteSyncImpl::SyncUint8Var(const DynamiteMessage::SyncVar *m, void *vars, const uint32_t varIndex) {
    const auto as8 = m->array_values_as_Uint8();
    if (as8 == nullptr) {
        spdlog::error("{}, array values is null", __PRETTY_FUNCTION__);
        return false;
    }

    const auto values = as8->value();
    if (values == nullptr) {
        spdlog::error("{}, values is null", __PRETTY_FUNCTION__);
        return false;
    }

    if (values->size() < 1) {
        spdlog::error("{}, {}.{} size is 0!", __PRETTY_FUNCTION__, m->category()->c_str(), m->name()->c_str());
        return false;
    }

    spdlog::info("{}, setting {}.{}", __PRETTY_FUNCTION__, m->name()->c_str(), m->category()->c_str());
    for (size_t i = 0; i < values->size(); i++) {
        const auto val = values->Get(i);
        ScriptDeclVarsImplSetVarValue(vars, varIndex, m->array_start() + i, 0, val);
    }

    spdlog::info("{}, {}.{}: done", __PRETTY_FUNCTION__, m->name()->c_str(), m->category()->c_str());
    return true;
}

bool DynamiteSyncImpl::SyncFloatVar(const DynamiteMessage::SyncVar *m, void *vars, const uint32_t varIndex) {
    const auto asFloat = m->array_values_as_Float();
    if (asFloat == nullptr) {
        spdlog::error("{}, array values is null", __PRETTY_FUNCTION__);
        return false;
    }

    const auto values = asFloat->value();
    if (values == nullptr) {
        spdlog::error("{}, values is null", __PRETTY_FUNCTION__);
        return false;
    }

    if (values->size() < 1) {
        spdlog::error("{}, {}.{} size is 0!", __PRETTY_FUNCTION__, m->category()->c_str(), m->name()->c_str());
        return false;
    }

    spdlog::info("{}, setting {}.{}", __PRETTY_FUNCTION__, m->name()->c_str(), m->category()->c_str());
    for (size_t i = 0; i < values->size(); i++) {
        const auto val = values->Get(i);
        ScriptDeclVarsImplSetVarValue(vars, varIndex, m->array_start() + i, 0, val);
    }

    spdlog::info("{}, {}.{}: done", __PRETTY_FUNCTION__, m->name()->c_str(), m->category()->c_str());
    return true;
}

void DynamiteSyncImpl::SyncEnemyVars() {
    spdlog::info("{}", __PRETTY_FUNCTION__);
    for (const auto &v : enemyVars) {
        RequestVar("svars", v);
    }
}

// sends data over GameSocket, unused
bool DynamiteSyncImpl::Send(const flatbuffers::FlatBufferBuilder *builder) const {
    if (this->gameSocket == nullptr) {
        spdlog::info("{}, socket is null", __PRETTY_FUNCTION__);
        return false;
    }

    uint8_t *buf = builder->GetBufferPointer();
    int size = builder->GetSize();
    if (size == 0 || size > 1000) {
        spdlog::info("{}, invalid size {}", __PRETTY_FUNCTION__, size);
        return false;
    }

    if (buf == nullptr) {
        spdlog::info("{}, buffer is null", __PRETTY_FUNCTION__);
        return false;
    }

    // spdlog::info("{}: {} {}", __PRETTY_FUNCTION__, size, bytes_to_hex(buf, size));
    //    auto wrapper = DynamiteMessage::GetMessageWrapper(buf);
    //    switch (wrapper->msg_type()) {
    //    case DynamiteMessage::Message_SyncVar: {
    //        spdlog::info("{}, sync var", __PRETTY_FUNCTION__);
    //        HandleSyncVar(wrapper);
    //        break;
    //    }
    //    default:
    //        break;
    //    }

    auto target = 0;
    if (Dynamite::cfg.Host) {
        target = 1;
    }

    const auto session = FoxNtSessionGetMainSession();
    if (session == nullptr) {
        spdlog::error("{} Main session is null", __PRETTY_FUNCTION__);
        return false;
    }

    auto session2impl = (void *)((char *)session + 0x20);
    if (session2impl == nullptr) {
        spdlog::error("{} Session2Impl is null", __PRETTY_FUNCTION__);
        return false;
    }

    // const auto memInterface = FoxNtImplSessionImpl2GetMemberInterfaceAtIndex(session2impl, target);
    // if (memInterface == nullptr) {
    //     spdlog::error("{}, memInterface is null", __PRETTY_FUNCTION__);
    //     return false;
    // }
    //
    // const auto index = *(byte *)((char *)memInterface + 0x28);
    // spdlog::info("{}, target index {}", __PRETTY_FUNCTION__, index);

    auto index = 0;
    if (Dynamite::cfg.Host) {
        index = 1;
    }

    // TODO replace with something like transiever manager does? or player sync?
    Dynamite::FoxNtImplGameSocketImplRequestToSendToMemberHook(gameSocket, index, 0, buf, size);
    return true;
}

void DynamiteSyncImpl::AddFixedUserMarker(const Vector3 *pos) {
    spdlog::info("{}, {} {} {}", __PRETTY_FUNCTION__, pos->x, pos->y, pos->z);
    packetNumber++;
    flatbuffers::FlatBufferBuilder builder(256);

    DynamiteMessage::Vec3 p(pos->x, pos->y, pos->z);
    auto sv = DynamiteMessage::CreateAddFixedUserMarker(builder, &p);
    auto message = DynamiteMessage::CreateMessageWrapper(builder, packetNumber, DynamiteMessage::Message_AddFixedUserMarker, sv.Union());
    builder.Finish(message);
    auto res = SendRaw(&builder);
    spdlog::info("{}: {}", __PRETTY_FUNCTION__, res);
}

bool DynamiteSyncImpl::SendRaw(const flatbuffers::FlatBufferBuilder *builder) const {
    if (steamUDPSocket == nullptr) {
        spdlog::info("{}, steamUDPSocket is null", __PRETTY_FUNCTION__);
        return false;
    }

    auto buf = builder->GetBufferPointer();
    auto size = builder->GetSize();
    if (size == 0 || size > (sizeof(this->updateBuffer) + sizeof(DYNAMITE_RAW_HEADER))) {
        spdlog::info("{}, invalid size {}", __PRETTY_FUNCTION__, size);
        return false;
    }

    if (buf == nullptr) {
        spdlog::info("{}, buffer is null", __PRETTY_FUNCTION__);
        return false;
    }

    auto bfSize = size + sizeof(DYNAMITE_RAW_HEADER);
    const auto newBuf = malloc(bfSize);
    if (newBuf == nullptr) {
        spdlog::error("{}, malloc failed", __PRETTY_FUNCTION__);
        return false;
    }

    memset(newBuf, 0, bfSize);
    memcpy(newBuf, DYNAMITE_RAW_HEADER, sizeof(DYNAMITE_RAW_HEADER));
    memcpy((char *)newBuf + sizeof(DYNAMITE_RAW_HEADER), buf, size);

    if (Dynamite::cfg.debug.dynamiteMsg) {
        auto dump = bytes_to_hex(newBuf, bfSize);
        spdlog::info("{}, size={}, bufSize={}, dump={}", __PRETTY_FUNCTION__, size, bfSize, dump);
    }

    // auto snf = *(SteamNetworkingFunc*)0x14db4f7c8;
    // auto networking = snf();
    FoxNioImplSteamUdpSocketImplSend(steamUDPSocket, newBuf, bfSize, steamUDPSocketInfo, steamUDPAddress);

    free(newBuf);

    return true;
}

bool DynamiteSyncImpl::RecvRaw(void *buffer, int32_t size) {
    if (Dynamite::cfg.debug.dynamiteMsg) {
        auto bytes = bytes_to_hex(buffer, size);
        spdlog::info("{}, size={}, dump={}", __PRETTY_FUNCTION__, size, bytes);
    }

    if ((size - sizeof(DYNAMITE_RAW_HEADER)) > sizeof(this->updateBuffer)) {
        spdlog::error("{}, incoming packet is too big ({})", __PRETTY_FUNCTION__, size);
        return false;
    }

    auto buflen = size - sizeof(DYNAMITE_RAW_HEADER);
    memset(this->updateBuffer, 0, sizeof(this->updateBuffer));
    memcpy(this->updateBuffer, (char *)buffer + sizeof(DYNAMITE_RAW_HEADER),  buflen);

    auto verifier = flatbuffers::Verifier((uint8_t*)this->updateBuffer, sizeof(this->updateBuffer));
    auto ok = DynamiteMessage::VerifyMessageWrapperBuffer(verifier);
    if (!ok) {
        spdlog::error("{}, message wrapper verification failed", __PRETTY_FUNCTION__);
        return false;
    }

    auto wrapper = DynamiteMessage::GetMessageWrapper(this->updateBuffer);
    spdlog::info("{}, incoming packet {}, have {}", __PRETTY_FUNCTION__, wrapper->packet_num(), packetSeen);
    if (wrapper->packet_num() <= packetSeen) {
        return false;
    }

    packetSeen = wrapper->packet_num();

    switch (wrapper->msg_type()) {
    case DynamiteMessage::Message_Ping:
        spdlog::info("{}, ping", __PRETTY_FUNCTION__);
        break;
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
    case DynamiteMessage::Message_RequestVar:
        HandleRequestVar(wrapper);
        break;
    default:
        spdlog::error("{}, unknown message type {}", __PRETTY_FUNCTION__, static_cast<uint32_t>(wrapper->msg_type()));
        break;
    }

    return true;
}