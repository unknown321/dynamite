#include "dynamite.h"
#include "patch.h"
#include <vector>

namespace Dynamite {
    std::vector<Patch> Dynamite::GetPatches() {
        return {
            {
                .address = 0x140ffa9ff,
                .expected = {0x74, 0x07}, // JZ 0x140ffaa08
                .patch = {0xeb, 0x07},    // JMP 0x140ffaa08
                .description = "Apply damage to player no matter what, "
                               "tpp::gm::player::impl::`anonymous_namespace'::DefenseCallback::TargetCallbackExec",
            },
            {
                .address = 0x141378209,
                .expected = {0x74, 0x5c}, // JZ 0x141378267
                .patch = {0x48, 0x90},    // NOP
                .description = "Attempt to fix damage (not needed?), "
                               "tpp::gm::soldier::impl::ActionCoreImpl::ExecGrazeCallback",
            },
            {
                .address = 0x149f57ac7,
                .expected = {0x74, 0x1a}, // JZ 0x149f57ae3
                .patch = {0xeb, 0x1a},    // JMP 0x149f57ae3
                .description = "Always update action task, "
                               "tpp::gm::soldier::impl::ActionControllerImpl::UpdateActionTask",
            },
            {
                .address = 0x1417a200e,
                .expected = {0x74, 0x19}, // JZ 0x1417a2029
                .patch = {0x48, 0x90},    // NOP
                .description = "Always respawn player no matter what, "
                               "tpp::gm::player::impl::RespawnActionPluginImpl::UpdatePlaySubState",
            },
            {
                .address = 0x14133d9cb,
                .expected = {0x0f, 0x84, 0xdc, 0x03, 0x00, 0x00}, // JZ 0x14133ddad
                .patch = {0x66, 0x48, 0x90, 0x66, 0x48, 0x90},    // NOP NOP
                .description = "Skip sight controller host check, always run host code, ignore IsHost call, "
                               "tpp::gm::impl::`anonymous_namespace`::SightControllerImpl::Update. "
                               "Without it soldiers will lose track of client after raising an alert.",
            },
            {
                .address = 0x140ebcfc4,
                .expected = {0x74, 0x2e}, // JZ 0x140ebcff4
                .patch = {0x48, 0x90},    // NOP
                .description = "Client always uses host code for SetHostage2Flag lua command, "
                               "tpp::gm::hostage::impl::Hostage2FlagInfoImpl::RequestSetAndSyncImpl",
            },
            {
                .address = 0x140887905,
                .expected = {0x74, 0x1c}, // JZ 0x140887923
                .patch = {0xeb, 0x1c},    // JMP 0x140887923
                .description = "Do not send sneak result (online request) on game over, "
                               "tpp::ui::menu::GameOverEvCall::UpdateGameOver",
            },
            {
                .address = 0x1416026ce,
                .expected = {0xff, 0x90, 0x68, 0x03, 0x00, 0x00}, // CALL qword ptr RAX+0x368
                .patch = {0xf2, 0x48, 0x90, 0xf2, 0x48, 0x90},    // NOP NOP
                .description = "Do not send sneak result on mission end (fob results screen)"
                               "tpp::ui::hud::impl::TppUIFobResultImpl::UpdateFobResult",
            },
            {
                .address = 0x145ccff85,
                .expected = {0x74, 0x09}, // JZ 0x145ccff90
                .patch = {0x48, 0x90},    // NOP
                .description = "Skip Resume Game prompt"
                               "tpp::ui::menu::LoadingTipsEv::UpdateActPhase",
            },
            {
                .address = 0x144e42a62,
                .expected = {0x0f, 0x094, 0xd0}, // SETZ AL
                .patch = {0x40, 0xb0, 0x01},     // MOV AL, 0x01
                .description = "Trap check is player and local is always true #2, fix crash on enter"
                               "tpp::TrapCheckIsPlayerAndLocalCallback::ExecCallback",
            },
            {
                .address = 0x144e42a8e,
                .expected = {0x30, 0xc0}, // XOR AL, AL
                .patch = {0xb0, 0x01},    // MOV AL, 0x1
                .description = "Trap check is player and local is always true, fix crash on enter"
                               "tpp::TrapCheckIsPlayerAndHostCallback::ExecCallback",
            },
            {
                .address = 0x144e46f45,
                .expected = {0x30, 0xc0}, // XOR AL, AL
                .patch = {0xb0, 0x01},    // MOV AL, 0x1
                .description = "Trap check is player and host is always true, fix crash on enter"
                               "tpp::TrapCheckIsPlayerAndHostCallback",
            },
            {
                .address = 0x14625fd1a,
                .expected = {0x75, 0xd}, // JNZ 0x14625fd29
                .patch = {0x48, 0x90},   // NOP
                .description = "DoesFobGhostPlayer remove mission ID check"
                               "tpp::gm::player::impl::Player2GameObjectImpl::DoesFobGhostPlayer"
                               "without it mission won't load (infinite loading)",
            },
            {
                .address = 0x1459b60b5,
                // clang-format off
                    .expected =
                        {
                            0x48, 0x83, 0x79, 0x58, 0x00, // CMP qword ptr [RCX + 0x58], 0x0
                            0x48, 0x89, 0xcb, // MOV RBX, RCX
                            0x75, 0x09, // JMP LAB_1459b60c8
                        },
                    .patch =
                        {
                            0xf2, 0x48, 0x90, // NOP
                            0x48, 0x90, // NOP
                            0x48, 0x89, 0xcb, // MOV RBX, RCX
                            0x48, 0x90, // NOP
                        },
                // clang-format on
                .description = "Always start fob p2p resolver, ignore exists check (not needed?)"
                               "tpp::net::Daemon::StarFobP2pNameResolver",
            },
            {
                .address = 0x140da58e5,
                .expected = {0x0f, 0x84, 0x41, 0x05, 0x00, 0x00}, // JZ LAB_140da5e2c
                .patch = {0x66, 0x48, 0x90, 0x66, 0x48, 0x90},    // NOP NOP
                .description =
                    "Always run host damage controller implementation"
                    "Fixes crash on shooting animals (like goats in PITCH BLACK after the village at {-711.90826416016, 5.1010074615479, 661.36602783203})"
                    "tpp::gm::impl::`anonymous_namespace'::DamageControllerImpl::Update",
            },
            {
                .address = 0x146457b68,
                .expected = {0x75, 0x13}, // JNZ LAB_146457b7d
                .patch = {0x48, 0x90},    // NOP
                .description = "always run full CloseSession code, ignore mission code check"
                               "tpp::gm::tool::`anonymous_namespace'::CloseSession",
            },
            {
                .address = 0x14163fcda,
                .expected = {0x0f, 0x84, 0xa2, 0x01, 0x00, 0x00}, // JZ LAB_14163fe82
                .patch = {0x66, 0x48, 0x90, 0x66, 0x48, 0x90},    // NOP NOP
                .description =
                    "add Quiet and Ocelot to staff list in sortie by ignoring tpp::ui::menu::impl::MissionPreparationSystemImpl::IsFobMissionMode check result"
                    "tpp::ui::menu::impl::CharacterSelectorCallbackImpl::SetupStaffList",

            },
            {
                .address = 0x1409cc6c0,
                .expected = {0x0f, 0x85, 0x9c, 0x07, 0x00, 0x00}, // JNZ LAB_1409cce62
                .patch = {0x48, 0xe9, 0x9c, 0x07, 0x00, 0x00},    // JMP LAB_1409cce62
                .description = "skip some check that resets player to Snake from Quiet/Ocelot"
                               "tpp::gm::player::impl::Player2GameObjectImpl::UpdatePartsStatus",
            },
            {
                .address = 0x149cfba54,
                .expected = {0x74, 0x10}, // JZ LAB_149cfba66
                .patch = {0x48, 0x90},    // NOP
                .description = "skip check and call FUN_1411b4350 that sets up dual revolvers for Ocelot"
                               "tpp::gm::player::impl::UnrealUpdaterImpl::PreUpdate",
            },
            {
                .address = 0x149f4f17b,
                .expected = {0x74, 0x07}, // JZ LAB_149f4f184
                .patch = {0xeb, 0x07},    // JMP LAB_149f4f184
                .description = "always use non-fob function to update cp member status"
                               "tpp::gm::soldier::impl::Soldier2Impl::UpdateCpMemberStatus",
            },

            {
                .address = 0x1409c9a13,
                // clang-format off
                .expected = {
                    0x84, 0xc0,             // TEST AL, AL
                    0x4c, 0x0f, 0x45, 0xc1, // CMOVNZ R8,RCX
                },
                .patch = {
                    0x49, 0x89, 0xc8, // MOV        R8,RCX
                    0x66, 0x48, 0x90, // NOP
                },
                // clang-format on
                .description = "always apply opponent (or partner) emblem"
                               "tpp::gm::player::impl::Player2Impl::SetEmblemTexture",
            },
            // {
            //     .address = 0x1409b9d3b,
            //     .expected = {0x74, 0x0a}, // JZ LAB_1409b9d47
            //     .patch = {0xeb, 0x0a},    // JMP LAB_1409b9d47
            //     .description = "skip IS_ONLINE check for player action status"
            //                    "allows player to climb wall cracks"
            //                    "this patch also makes player invisible and cannot be applied"
            //                    "tpp::gm::player::impl::Player2GameObjectImpl::Player2GameObjectImpl",
            // },

            // {
            //     .address = 0x1413536b6,
            //     // clang-format off
            //     .expected = {
            //         0x8b, 0xc1,          // MOV        EAX,ECX
            //         0xd1, 0xe8,          // SHR        EAX,0x1
            //         0xf7, 0xd0,          // NOT        EAX
            //         0x33, 0xc1,          // XOR        EAX,ECX
            //         0x83, 0xe0, 0x02,    // AND        EAX,0x2
            //         0x33, 0xc1,          // XOR        EAX,ECX
            //     },
            //     .patch = {
            //         0xb8, 0x02, 0x00, 0x00, 0x00, // MOV        EAX,0x2
            //         0x66, 0x48, 0x90 ,            // NOP
            //         0x66, 0x48, 0x90,             // NOP
            //         0x48, 0x90,                   // NOP
            //     },
            //     // clang-format on
            //     .description = "ignore IS_ONLINE check at 1409e6f18, always set flag based on that check to 2 instead of calculated 4"
            //                    "allows soldiers to get in vehicles"
            //                    "this patch also breaks client detection and cannot be applied"
            //                    "tpp::gm::soldier::impl::Soldier2Impl::Initialize",
            // },
        };
    }

    bool Dynamite::PatchMasterServerURL(const std::string &url) {
        // a better approach would be changing string address in tpp::net::LoginUtility::Update
        // that will allow longer addresses
        // lets keep it simple for now

        if (url.length() > 69) {
            return false;
        }
        // clang-format off
        const auto expected = std::vector<int16_t>{0x68, 0x74, 0x74, 0x70, 0x73, 0x3a, 0x2f, 0x2f, 0x6d, 0x67, 0x73,
            0x74, 0x70, 0x70, 0x2d, 0x67, 0x61, 0x6d, 0x65, 0x2e, 0x6b, 0x6f, 0x6e,
            0x61, 0x6d, 0x69, 0x6f, 0x6e, 0x6c, 0x69, 0x6e, 0x65, 0x2e, 0x63, 0x6f,
            0x6d, 0x2f, 0x74, 0x70, 0x70, 0x73, 0x74, 0x6d, 0x2f, 0x67, 0x61, 0x74,
            0x65, 0x0}; //  "https://mgstpp-game.konamionline.com/tppstm/gate\0"
        // clang-format on

        auto patch = std::vector<int16_t>();
        for (auto v : url) {
            patch.push_back(v);
        }
        patch.push_back(0);

        auto p = Patch{
            .address = 0x142218770,
            .expected = expected,
            .patch = patch,
            .description = "override master server url",
        };

        return p.Apply();
    }
}
