#ifndef HOOK_DYNAMITE_H
#define HOOK_DYNAMITE_H

#include "Config.h"
#include "DynamiteCore.h"
#include "DynamiteSyncImpl/DynamiteSyncImpl.h"
#include "Tpp/TppNPCLifeState.h"
#include "Tpp/TppTypes.h"
#include "Version.h"
#include "lua/lua.h"
#include "patch.h"
#include "spdlog/logger.h"
#include "windows.h"

#include <eh.h>
#include <filesystem>
#include <map>
#include <memory>

namespace Dynamite {
    static const std::filesystem::path logPath = std::filesystem::path("dynamite") / std::filesystem::path("dynamite.log.txt");

    void TerminateHandler();
    inline terminate_function terminate_Original;
    static const std::string logName = "dynamite";
    inline std::map<std::string, uint64_t> addressSet;

    class Dynamite {
      public:
        Dynamite();
        ~Dynamite();

        void SetupLogger();

        void RebaseAddresses();

        void CreateHooks();

        void CreateDebugHooks();

        void ReadConfig();

        void SetFuncPtrs();

        static void AbortHandler(int signal_number);

        static LONG WINAPI UnhandledExceptionHandler(EXCEPTION_POINTERS * /*ExceptionInfo*/);

        static std::vector<Patch> GetPatches();

        static bool PatchMasterServerURL(const std::string &url);

        DynamiteSyncImpl dynamiteSyncImpl;

        DynamiteCore dynamiteCore;

        Config cfg{};

        std::map<uint32_t, std::string> messageDict;
        std::map<uint64_t, std::string> pathDict;
      private:
        static constexpr uint64_t BaseAddr = 0x140000000;
        uint64_t RealBaseAddr = 0;
        HMODULE thisModule{nullptr};
        std::shared_ptr<spdlog::logger> log = nullptr;

    };
}

#endif // HOOK_DYNAMITE_H
