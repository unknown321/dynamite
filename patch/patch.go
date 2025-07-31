package patch

import (
	"bytes"
	"dynamite/util"
	"encoding/binary"
	"fmt"
	"io"
	"log/slog"
	"net/url"
	"os"
	"strings"
)

var oldURL = "https://mgstpp-game.konamionline.com/tppstm/gate"

var exePath = "./mgsvtpp.exe"
var vendorPath = "./mgsvtpp.exe.vendor"

var playerID byte

type Patch struct {
	Offset   int64
	Expected []byte
	Patch    []byte
	Force    bool
	Name     string
}

// these break the game
var deadPatches = []Patch{
	{
		// tpp::gm::player::impl::Player2Impl::AddPlugins
		Offset: 0x009ba373,
		Expected: []byte{
			0x41, 0xbb, 0x1, 0x00, 0x00, 0x00, // MOV R10D,0x1
			0x66, 0x3b, 0xc8, // CMP CX, AX
			0x45, 0x0f, 0x44, 0xd3, // CMOVZ R10D, R11D
		},
		Patch: []byte{
			0x41, 0xba, 0x1, 0x00, 0x00, 0x00, // MOV R10D,0x1
			0x66, 0x48, 0x90, // NOP
			0x48, 0x90, // NOP
			0x48, 0x90, // NOP
		},
		Name: "Player2Impl always add online plugins - crash",
	},
	{
		// tpp::gm::player::impl::LifeControllerImpl::Update
		Offset:   0x011f6707,
		Expected: []byte{0x74, 0x07}, // JZ 0x1411f7310
		Patch:    []byte{0x48, 0x90}, // NOP
		Name:     "one hit kills player and keeps killing",
	},
	{
		// tpp::gm::player::impl::LifeControllerImpl::CalculateDamageValueAtIndex
		Offset:   0x011f5528,
		Expected: []byte{0x74, 0x14}, // JZ 0x1411f613e
		Patch:    []byte{0xeb, 0x14}, // JMP 0x1411f613e
		Name:     "???",
	},
	{
		// tpp::gm::player::impl::Player2GameObjectImpl::UpdateCanStartMission
		Offset:   0x009cb654,
		Expected: []byte{0xb8, 0x82, 0xc3, 0x00, 0x00}, // MOV EAX, 0xc382
		Patch:    []byte{0xe9, 0x09, 0x00, 0x00, 0x00}, // JMP 0x1409cc262
		Name:     "UpdateCanStartMission, remove mission ID check, random crash for host",
	},
}

var Patches []Patch

var unusedPatches = []Patch{
	{
		// tpp::net::FobTarget::CreateHostSession
		Offset:   0x0630b273,
		Expected: []byte{0x48, 0x8d, 0x05, 0x66, 0x0a, 0xdf, 0xf9}, // LEA, RAX,0x14024a8e0
		Patch:    []byte{0x48, 0x8d, 0x05, 0xa6, 0x9f, 0x59, 0xff}, // LEA, RAX,0x1459f3e20
		Name:     "replace TppNetworkUtil.EnableMultiPlaySession with tpp::net::FobTarget::CreateHostSession, moved to hook",
	},
	{
		// tpp::net::FobTarget::CreateClientSession
		Offset:   0x630b1a5,
		Expected: []byte{0x48, 0x8d, 0x05, 0x34, 0x0b, 0xdf, 0xf9},
		Patch:    []byte{0x48, 0x8d, 0x05, 0x64, 0x9b, 0x59, 0xff},
		Name:     "replace TppNetworkUtil.SyncedExecute with CreateClientSession, moved to hook",
	},
	{
		// tpp::net::FobTarget::CreateClientSession
		Offset:   0x58a4d47,
		Expected: []byte{0x83, 0x3b, 0x00, 0x75, 0xf4},
		Patch: []byte{
			0x66, 0x48, 0x90, // NOP
			0x48, 0x90, // NOP
		},
		// this patch must be applied along with previous patch
		// check was triggered by memory garbage from lua
		Name: "CreateClientSession, remove SessionConnectInfo null check",
	},
	{
		// fox::nt::FirstPartyP2pConnectionManager::Impl::StartClientSession
		Offset:   0xd21cd26,
		Expected: []byte{0x48, 0x8b, 0x02, 0x48, 0x89, 0x41, 0x01},
		Patch: []byte{
			0xe9, 0xd5, 0x2e, 0xfd, 0xf6, // JMP 0x14433e800
			0x48, 0x90, // NOP
		},
		Name: "StartClientSession, jump to hardcode server steamID",
	},
	{
		// tpp::sys::`anonymous_namespace`::PlayerInfoInterfaceImpl::IsDefenseTeamByOnlineFobLocal
		Offset: 0x0d86b7cc,
		Expected: []byte{
			0x84, 0xc0, // TEST AL, AL
			0x0f, 0x94, 0xd0, // SETZ AL
		},
		Patch: []byte{
			0x48, 0x90, // NOP
			0x40, 0xb0, 0x00, // MOV AL, 0x0
		},
		Name: "player defence team check is always false, moved to dll",
	},
	{
		// tpp::sys::`anonymous_namespace`::PlayerInfoInterfaceImpl::IsOffenseTeamByOnlineFobLocal
		Offset: 0x01e02244,
		Expected: []byte{
			0xe8, 0xa7, 0xc5, 0xdf, 0xfe, // CALL fox::GetQuarkSystemTable
			0x48, 0x8b, 0x48, 0x78, // MOV RCX, qword ptr [RAX + 0x78]
		},
		Patch: []byte{
			0xb0, 0x01, // MOV AX, 0x1
			0xeb, 0x11, // JMP 0x141e02e59
		},
		Name: "player offence check is always true, moved to dll",
	},
	{
		// tpp::sys::`anonymous_namespace`::PlayerInfoInterfaceImpl::IsOffenseTeamByOnlineFobLocal
		Offset:   0x01e0225d,
		Expected: []byte{0x48},
		Patch:    []byte{0xc3},
		Name:     "player offence check is always true, ret, moved to dll",
	},
	{
		// tpp::sys::`anonymous_namespace`::PlayerInfoInterfaceImpl::GetFobDefensePlayerInstanceIndex
		Offset:   0x0d860fc5,
		Expected: []byte{0xe8, 0x26, 0xf8, 0x24, 0xf3}, // CALL fox::GetQuarkSystemTable
		Patch:    []byte{0xe9, 0x16, 0x00, 0x00, 0x00}, // JMP 0x14d9afbe0
		Name:     "set fob defence player instance index to -1, moved to dll",
	},
	{
		// tpp::gm::impl::cp::CommandPost2Impl::UpdateCommonState
		Offset:   0x00d6485a,
		Expected: []byte{0xff, 0x90, 0x20, 0x02, 0x00, 0x00},     // CALL qword ptr [RAX + 0x220]
		Patch:    []byte{0xc7, 0xc1, playerID, 0x00, 0x00, 0x00}, // MOV ECX, 0x0
		Name:     "cp common state, use current player as offensive, ignore call to GetFobOffensePlayerInstanceIndex, moved to dll",
	},
	{
		// tpp::gm::impl::cp::CommandPost2Impl::ExecuteSerially
		Offset:   0x071510db,
		Expected: []byte{0x0f, 0x84, 0x97, 0x00, 0x00, 0x00}, // JZ 0x14729fd78
		Patch: []byte{
			0xf2, 0x48, 0x90, // NOP
			0xf2, 0x48, 0x90, // NOP
		},
		Name: "command post executeSerially always update as host, skip IsHost check, run host code - not needed, host sets the rules",
	},
	{
		// fix cameras not noticing you
		// tpp::gm::securitycamera::impl::SecurityCamera2AuthorizerImpl::Update
		Offset:   0x0131908c,
		Expected: []byte{0xff, 0x52, 0x28}, // CALL qword ptr [RDX + 0x28]
		Patch:    []byte{0x40, 0xb0, 0x01}, // MOV AL,0x1
		Name:     "camera authorizer always host, set IsHost call result to always true - not needed, host sets the rules",
	},
	{
		// fix soldiers not noticing you
		// tpp::gm::soldier::impl::Soldier2AuthorizerImpl::Update
		Offset:   0x01399575,
		Expected: []byte{0x0f, 0x84, 0x1a, 0x01, 0x00, 0x00}, // JZ 0x14139a295
		Patch:    []byte{0x66, 0x48, 0x90, 0x66, 0x48, 0x90}, // NOP NOP
		Name:     "Soldier2AuthorizerImpl always run host code (attacker), ignore IsHost call - not needed, host sets the rules",
	},
	{
		// tpp::gm::impl::AiControllerImpl::Update
		Offset:   0x00c0f2a2,
		Expected: []byte{0xff, 0x52, 0x28}, // CALL qword ptr [RDX + 0x28]
		Patch:    []byte{0x40, 0xb0, 0x01}, // MOV AL,0x1
		Name:     "ai controller remove host check, set IsHost call result to always true - not needed, host sets the rules",
	},
	{
		// tpp::net::Daemon::StarFobP2pNameResolver
		Offset: 0x58674b5,
		Expected: []byte{
			0x48, 0x83, 0x79, 0x58, 0x00, // CMP qword ptr [RCX + 0x58], 0x0
			0x48, 0x89, 0xcb, // MOV RBX, RCX
			0x75, 0x09, // JMP LAB_1459b60c8
		},
		Patch: []byte{
			0xf2, 0x48, 0x90, // NOP
			0x48, 0x90, // NOP
			0x48, 0x89, 0xcb, // MOV RBX, RCX
			0x48, 0x90, // NOP
		},
		Name: "always start fob p2p resolver, ignore exists check",
	},
	{
		// tpp::gm::player::impl::Player2GameObjectImpl::DoesFobGhostPlayer
		// without this player parts won't load
		Offset:   0x0611111a,
		Expected: []byte{0x75, 0xd},  // JNZ 0x14625fd29
		Patch:    []byte{0x48, 0x90}, // NOP
		Name:     "DoesFobGhostPlayer remove mission ID check",
	},
	// trap
	{
		// tpp::TrapCheckIsPlayerAndHostCallback
		Offset:   0x04cf8345,
		Expected: []byte{0x30, 0xc0}, // XOR AL, AL
		Patch:    []byte{0xb0, 0x01}, // MOV AL, 0x1
		Name:     "trap check is player and host is always true, fix crash on enter",
	},
	{
		// tpp::TrapCheckIsPlayerAndHostCallback::ExecCallback
		Offset:   0x04cf3e8e,
		Expected: []byte{0x30, 0xc0}, // XOR AL, AL
		Patch:    []byte{0xb0, 0x01}, // MOV AL, 0x1
		Name:     "trap check is player and local is always true, fix crash on enter",
	},
	{
		// tpp::TrapCheckIsPlayerAndLocalCallback::ExecCallback
		Offset:   0x04cf3e62,
		Expected: []byte{0x0f, 0x094, 0xd0}, // SETZ AL
		Patch:    []byte{0x40, 0xb0, 0x01},  // MOV AL, 0x01
		Name:     "trap check is player and local is always true #2, fix crash on enter",
	},

	// various fixes
	{
		// tpp::ui::menu::LoadingTipsEv::UpdateActPhase
		Offset:   0x05b81385,
		Expected: []byte{0x74, 0x09}, // JZ 0x145ccff90
		Patch:    []byte{0x48, 0x90}, // NOP
		Name:     "skip Resume Game prompt",
	},
	{
		// tpp::ui::hud::impl::TppUIFobResultImpl::UpdateFobResult
		Offset:   0x01601ace,
		Expected: []byte{0xff, 0x90, 0x68, 0x03, 0x00, 0x00}, // CALL qword ptr RAX+0x368
		Patch: []byte{
			0xf2, 0x48, 0x90, // NOP
			0xf2, 0x48, 0x90, // NOP
		},
		Name: "do not send sneak result on mission end (fob)",
	},
	{
		// tpp::ui::menu::GameOverEvCall::UpdateGameOver
		Offset:   0x00886d05,
		Expected: []byte{0x74, 0x1c}, // JZ 0x140887923
		Patch:    []byte{0xeb, 0x1c}, // JMP 0x140887923
		Name:     "do not send sneak result on game over",
	},
	{
		// tpp::gm::hostage::impl::Hostage2FlagInfoImpl::RequestSetAndSyncImpl
		Offset:   0x00ebc3c4,
		Expected: []byte{0x74, 0x2e}, // JZ 0x140ebcff4
		Patch:    []byte{0x48, 0x90}, // NOP
		Name:     "client always uses host code for Hostage2Flag",
	},
	{
		// tpp::gm::impl::`anonymous_namespace`::SightControllerImpl::Update
		Offset:   0x0133cdcb,
		Expected: []byte{0x0f, 0x84, 0xdc, 0x03, 0x00, 0x00}, // JZ 0x14133ddad
		Patch:    []byte{0x66, 0x48, 0x90, 0x66, 0x48, 0x90}, // NOP NOP
		Name:     "skip sight controller host check, always run host code, ignore IsHost call",
	},
	{
		// tpp::gm::player::impl::RespawnActionPluginImpl::UpdatePlaySubState
		Offset:   0x017a140e,
		Expected: []byte{0x74, 0x19}, // JZ 0x1417a2029
		Patch:    []byte{0x48, 0x90}, // NOP
		Name:     "always respawn player no matter what",
	},
	{
		Offset:   0x09e08ec7,
		Expected: []byte{0x74, 0x1a}, // JZ 0x149f57ae3
		Patch:    []byte{0xeb, 0x1a}, // JMP 0x149f57ae3
		Name:     "always update action task, soldier reacts to client",
	},
	{
		Offset:   0x01377609,
		Expected: []byte{0x74, 0x5c},
		Patch:    []byte{0x48, 0x90},
		Name:     "damage fix attempt",
	},
	{
		Offset:   0x00ff9dff,
		Expected: []byte{0x74, 0x07},
		Patch:    []byte{0xeb, 0x07},
		Name:     "add damage",
	},
}

func initPatches() {
	Patches = []Patch{
		// client reticle turns red
		//{
		//	// tpp::sys::`anonymous_namespace`::PlayerInfoInterfaceImpl::GetFobOffensePlayerInstanceIndex
		//	Offset: 0x0d861509,
		//	Expected: []byte{
		//		0x48, 0x89, 0xc1, // MOV RCX, RAX
		//		0xff, 0x12, // CALL qword ptr [RDX]
		//	},
		//	Patch: []byte{
		//		0x40, 0xb0, playerID, // MOV AL, 0x1
		//		0x48, 0x90, // NOP
		//	},
		//	Name: "set fob offense player instance index to current player, moved to dll",
		//},
	}
}

func PatchSteam(hostID uint64) {
	res := make([]byte, 8)
	serverSteamID := hostID
	binary.LittleEndian.PutUint64(res, serverSteamID)

	ExpectedHardcodedServerSteamID := [23]byte{0x00}
	HardcodedServerSteamIDTemplate := []byte{
		0x48, 0x90, // NOP
		0xc7, 0x44, 0x21, 0x01, 0xDE, 0xAD, 0xBE, 0xEF, // MOV dword ptr [RCX+0x1], lower bits
		0xc7, 0x44, 0x21, 0x05, 0xCA, 0xFE, 0xBA, 0xBE, // MOV dword ptr [RCX+0x5], 0x01100001
		0xe9, 0x14, 0xd1, 0x02, 0x09, // JMP 0x14d36b926
	}

	HardcodedServerSteamIDTemplate = bytes.Replace(HardcodedServerSteamIDTemplate, []byte{0xDE, 0xAD, 0xBE, 0xEF}, res[0:4], 1)
	HardcodedServerSteamIDTemplate = bytes.Replace(HardcodedServerSteamIDTemplate, []byte{0xCA, 0xFE, 0xBA, 0xBE}, res[4:8], 1)
	PatchInstruction(0x41efc00, HardcodedServerSteamIDTemplate, ExpectedHardcodedServerSteamID[:], "hardcode server steamID, jump back to StartClientSession", true)
	slog.Info("coop server", "steamID", serverSteamID)
}

func PatchAll(hostID uint64) {
	if hostID != 0 {
		//PatchSteam(hostID)
	}
	for _, p := range Patches {
		PatchInstruction(p.Offset, p.Patch, p.Expected, p.Name, p.Force)
	}
	/*
			// tpp::net::impl::NetworkSystemImpl::NetInfoCreateSession
			//NetInfoCreateSession := []byte{0x48, 0x8d, 0x05, 0xf6, 0x21, 0x60, 0x07}

			//// tpp::net::impl::NetworkSystemImpl::RequestDetail
			//ExpectedStartNetSynchronizer := []byte{0x48, 0x8d, 0x05, 0x4c, 0x0b, 0xdf, 0xf9}
			//RequestDetail := []byte{0x48, 0x8d, 0x05, 0x6c, 0x8e, 0x60, 0x07}
			//PatchInstruction(0x630b18d, RequestDetail, ExpectedStartNetSynchronizer, "RequestDetail")

		//expectedPlayerInfoReference := []byte{0xb8, 0x97, 0x8c, 0x02, 0x00, 0x00} // MOV EDX, dword ptr [RDI+0x28c]
		//alwaysRequestPlayer0 := []byte{0xc7, 0xc2, 0x00, 0x00, 0x00, 0x00}        // MOV EDX, 0x0
		//PatchInstruction(0x013506c7, alwaysRequestPlayer0, expectedPlayerInfoReference, "soldier2ExecuteSerially, request player 0 info reference", false)
	*/
}

// PatchInstruction replace one byte array with another at offset
func PatchInstruction(offset int64, patch []byte, expected []byte, name string, force bool) {
	file, err := os.OpenFile(exePath, os.O_RDWR, 0644)
	if err != nil {
		slog.Error("cannot open file", "path", exePath, "error", err.Error())
		return
	}

	defer file.Close()

	_, err = file.Seek(offset, io.SeekStart)
	if err != nil {
		slog.Error("cannot seek file", "path", exePath, "error", err.Error())
		return
	}

	infile := make([]byte, len(expected))
	err = binary.Read(file, binary.LittleEndian, &infile)
	if err != nil {
		slog.Info("cannot read", "error", err.Error(), "name", name)
		return
	}

	if bytes.Compare(patch, infile[:]) == 0 {
		slog.Info("already patched", "name", name)
		return
	}

	if bytes.Compare(expected, infile[:]) != 0 {
		slog.Error("unexpected exe contents", "exe", fmt.Sprintf("%+v", infile), "expected", fmt.Sprintf("%+v", expected), "name", name)
		if force {
			slog.Info("forced update")
		} else {
			slog.Info("skipped", "name", name)
			return
		}
	}

	_, err = file.Seek(offset, io.SeekStart)
	if err != nil {
		slog.Error("cannot seek file", "path", exePath, "error", err.Error())
		return
	}

	_, err = file.Write(patch)
	if err != nil {
		slog.Error("cannot patch file", "error", err.Error(), "name", name)
		return
	}

	slog.Info("patched", "name", name)
}

func UpdateURL(gateURL string) {
	file, err := os.OpenFile(exePath, os.O_RDWR, 0644)
	if err != nil {
		slog.Error("cannot open file", "path", exePath, "error", err.Error())
		return
	}

	defer file.Close()

	_, err = file.Seek(35746160, io.SeekStart)
	if err != nil {
		slog.Error("cannot seek file", "path", exePath, "error", err.Error())
		return
	}

	padLen := len(oldURL) - len(gateURL)
	pad := make([]byte, padLen)
	_, err = file.Write([]byte(gateURL))
	if err != nil {
		slog.Error("cannot write url", "error", err.Error())
		return
	}

	_, err = file.Write(pad)
	if err != nil {
		slog.Error("cannot write padding", "error", err.Error())
		return
	}

	slog.Info("updated url", "url", gateURL)
}

func CopyFile(src string, dst string) error {
	source, err := os.Open(src)
	if err != nil {
		return err
	}
	defer source.Close()

	destination, err := os.Create(dst)
	if err != nil {
		return err
	}
	defer destination.Close()

	if _, err = destination.ReadFrom(source); err != nil {
		return err
	}

	return nil
}

func WriteCoopTxt(isHost bool) {
	coopFile, err := os.OpenFile("./coop.txt", os.O_TRUNC|os.O_RDWR|os.O_CREATE, 0644)
	if err != nil {
		slog.Error("coop.txt", "error", err.Error())
		os.Exit(1)
	}
	if isHost {
		_, err = coopFile.Write([]byte("1\r\n"))
	} else {
		_, err = coopFile.Write([]byte("0\r\n"))
	}
	if err != nil {
		slog.Error("coop.txt write", "error", err.Error())
		os.Exit(1)
	}
}

func vendorExists() bool {
	_, err := os.Stat(vendorPath)
	return err == nil
}

func vendorValid(path string) (bool, error) {
	sum, err := util.Md5sum(path)
	if err != nil {
		return false, err
	}

	// 7cc5f282b068f741adda2bb1076fb721
	// version 1.0.15.3
	target := []byte{0x7c, 0xc5, 0xf2, 0x82, 0xb0, 0x68, 0xf7, 0x41, 0xad, 0xda, 0x2b, 0xb1, 0x07, 0x6f, 0xb7, 0x21}

	return bytes.Compare(sum, target) == 0, nil
}

func backupVendor() error {
	if !vendorExists() {
		ok, err := vendorValid(exePath)
		if err != nil {
			return err
		}

		if ok {
			if err := CopyFile(exePath, vendorPath); err != nil {
				return err
			}
		} else {
			return fmt.Errorf("bad md5 sum for %s, exiting", exePath)
		}
	}

	return nil
}

type PatchOpts struct {
	ServerURL  string
	ServerOnly bool
	HostID     uint64
	IsHost     bool
}

func Run(o *PatchOpts) error {
	//if err := backupVendor(); err != nil {
	//	return err
	//}

	if !strings.HasSuffix(o.ServerURL, "/tppstm/gate") {
		u, err := url.Parse(o.ServerURL)
		if err != nil {
			return fmt.Errorf("invalid url: %w", err)
		}
		u = u.JoinPath("tppstm", "gate")
		o.ServerURL = u.String()
	}

	slog.Info("from", "vendor", vendorPath, "to", exePath)
	if err := CopyFile(vendorPath, exePath); err != nil {
		return err
	}

	slog.Info("patching", "file", exePath)
	//UpdateURL(o.ServerURL)
	if o.ServerOnly {
		return nil
	}

	if o.HostID == 0 && !o.IsHost {
		slog.Info("server only is false but no -host nor -hostID provided, exiting")
		return nil
	}

	if !o.IsHost {
		playerID = 1
	}

	slog.Info("mode", "hosting coop?", o.IsHost, "hostID", o.HostID, "playerID", playerID)

	initPatches()
	//PatchAll(o.HostID)

	//WriteCoopTxt(o.IsHost)

	return nil
}
