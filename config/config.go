package config

import (
	"dynamite/masterserver"
	"dynamite/savebackup"
	"dynamite/util"
	"fmt"
	"github.com/unknown321/fuse/steamid"
	"gopkg.in/ini.v1"
	"log/slog"
	"os"
	"strings"
)

var Filename = "./dynamite/dynamite.ini"

var PlayerPadKeys = map[string]bool{
	"DECIDE":                true,
	"STANCE":                true,
	"DASH":                  true,
	"HOLD":                  true,
	"FIRE":                  true,
	"RIDE_ON":               true,
	"RIDE_OFF":              true,
	"ACTION":                true,
	"MOVE_ACTION":           true,
	"JUMP":                  true,
	"RELOAD":                true,
	"STOCK":                 true,
	"ZOOM_CHANGE":           true,
	"VEHICLE_CHANGE_SIGHT":  true,
	"MB_DEVICE":             true,
	"CALL":                  true,
	"INTERROGATE":           true,
	"SUBJECT":               true,
	"UP":                    true,
	"PRIMARY_WEAPON":        true,
	"DOWN":                  true,
	"SECONDARY_WEAPON":      true,
	"LEFT":                  true,
	"RIGHT":                 true,
	"VEHICLE_LIGHT_SWITCH":  true,
	"VEHICLE_TOGGLE_WEAPON": true,
	"CQC":                   true,
	"SIDE_ROLL":             true,
	"LIGHT_SWITCH":          true,
	"EVADE":                 true,
	"VEHICLE_FIRE":          true,
	"VEHICLE_CALL":          true,
	"VEHICLE_DASH":          true,
	"BUTTON_PLACE_MARKER":   true,
	"PLACE_MARKER":          true,
	"ESCAPE":                true,
}

type LimitListEntry struct {
	SteamID uint64
	Note    string
}

func (l LimitListEntry) String() string {
	return fmt.Sprintf("%d (%s)", l.SteamID, strings.ReplaceAll(l.Note, ",", " "))
}

func FromString(s string) (LimitListEntry, error) {
	splits := strings.Split(strings.TrimSuffix(s, ")"), "(")
	if len(splits) != 2 {
		return LimitListEntry{}, fmt.Errorf("invalid format, expected '123 (note)'")
	}

	sid, err := steamid.ValidateString(strings.TrimSpace(splits[0]))
	if err != nil {
		return LimitListEntry{}, err
	}

	ll := LimitListEntry{
		SteamID: sid,
		Note:    splits[1],
	}

	return ll, nil
}

type Coop struct {
	Host        bool
	HostSteamID uint64 `comment:"ex. 76561197960287930"`
	Blacklist   []string
	Whitelist   []string
}

type Key struct {
	Name     string
	Module   string
	Function string
}

type Misc struct {
	PlaySound bool `comment:"play sound on function execution"`
}

type Dynamite struct {
	Installed            bool
	AccountDir           string
	UIAddress            string
	UseLocalMasterServer bool
	MasterKey            string
	ReloadKey            string
	Version              int64
	SkipConfig           bool
	DocsRead             bool
}

type MasterServer struct {
	URL string
}

type Debug struct {
	FoxBlock                     bool
	FoxBlockProcess              bool
	MemoryAllocTail              bool
	PlayerTarget                 bool
	LuaLog                       bool
	SetScriptVars                bool
	Messages                     bool
	RouteGroupGetEventID         bool
	FoxCreateQuark               bool
	AiControllerNode             bool
	CoreAiVehicle                bool
	SoldierRouteVehicleGetInStep bool
	StatusControllerIsOnline     bool
	SoldierRouteAiImplPreUpdate  bool
	GetSVarHandle                bool
	RttAndLoss                   bool
	Nio                          bool
	MuxSendError                 bool
}

type Config struct {
	Coop         Coop
	Misc         Misc
	Dynamite     Dynamite
	MasterServer MasterServer
	Debug        Debug
	Keys         []Key `ini:"-"`
}

func (c *Config) Exists() bool {
	_, err := os.Stat(Filename)
	return err == nil
}

func (c *Config) Default() error {
	var err error

	fif, err := os.Stat("./dynamite")
	if err == nil {
		if !fif.IsDir() {
			return fmt.Errorf("dynamite data directory is not a directory")
		}
	} else {
		if err = os.Mkdir("dynamite", 0755); err != nil {
			return err
		}
	}

	c.Coop.HostSteamID = 0
	c.Coop.Host = false

	c.Misc.PlaySound = true
	c.Dynamite.UIAddress = "127.0.0.1:8070"
	c.Dynamite.Installed = false
	c.Dynamite.UseLocalMasterServer = true

	c.MasterServer.URL = masterserver.DefaultClientAddress

	c.Dynamite.ReloadKey = "ACTION"      // E
	c.Dynamite.MasterKey = "ZOOM_CHANGE" // V

	accs, err := savebackup.GetValidAccounts()
	if err != nil {
		slog.Info("Get valid accounts", "message", err.Error())
	}

	if len(accs) == 1 {
		c.Dynamite.AccountDir = accs[0]
	} else {
		for _, v := range accs {
			slog.Info("Valid Steam account found", "path", v)
		}
	}
	c.Dynamite.Version = util.GetVersionTime()
	c.Coop.Blacklist = make([]string, 0)
	c.Coop.Whitelist = make([]string, 0)

	keys := []Key{
		{
			Name:     "UP",
			Module:   "Dynamite",
			Function: "CreateClientSession",
		},
		{
			Name:     "LEFT",
			Module:   "Dynamite",
			Function: "ResetClientSessionStateWithNotification",
		},
		{
			Name:     "DOWN",
			Module:   "Dynamite",
			Function: "WarpToPartner",
		},
	}

	c.Keys = keys
	if err = c.Save(); err != nil {
		return err
	}

	return nil
}

func (c *Config) Save() error {
	var err error

	if !strings.HasPrefix(c.Dynamite.MasterKey, "PlayerPad.") {
		c.Dynamite.MasterKey = "PlayerPad." + c.Dynamite.MasterKey
	}
	if !strings.HasPrefix(c.Dynamite.ReloadKey, "PlayerPad.") {
		c.Dynamite.ReloadKey = "PlayerPad." + c.Dynamite.ReloadKey
	}

	cfg := ini.Empty()
	if err = cfg.ReflectFrom(c); err != nil {
		return err
	}

	for _, k := range c.Keys {
		_, err = cfg.Section(fmt.Sprintf("Keys PlayerPad.%s", k.Name)).NewKey("Module", k.Module)
		if err != nil {
			return err
		}
		_, err = cfg.Section(fmt.Sprintf("Keys PlayerPad.%s", k.Name)).NewKey("Function", k.Function)
		if err != nil {
			return err
		}
	}

	if err = cfg.SaveTo(Filename); err != nil {
		return err
	}

	return nil
}

func (c *Config) Load() error {
	cfg, err := ini.Load(Filename)
	if err != nil {
		return err
	}

	if err = cfg.MapTo(c); err != nil {
		return err
	}

	if strings.HasPrefix(c.Dynamite.MasterKey, "PlayerPad.") {
		c.Dynamite.MasterKey = strings.TrimPrefix(c.Dynamite.MasterKey, "PlayerPad.")
	}
	if strings.HasPrefix(c.Dynamite.ReloadKey, "PlayerPad.") {
		c.Dynamite.ReloadKey = strings.TrimPrefix(c.Dynamite.ReloadKey, "PlayerPad.")
	}

	c.Keys = make([]Key, 0)
	for _, s := range cfg.Sections() {
		if strings.HasPrefix(s.Name(), "Keys PlayerPad.") {
			key := strings.TrimSpace(strings.TrimPrefix(s.Name(), "Keys PlayerPad."))
			if _, ok := PlayerPadKeys[key]; !ok {
				return fmt.Errorf("invalid PlayerPad key name: %s", key)
			}

			luaModule, err := s.GetKey("Module")
			if err != nil {
				return fmt.Errorf("get module for key %s: %w", key, err)
			}

			luaFunction, err := s.GetKey("Function")
			if err != nil {
				return fmt.Errorf("get function for key %s: %w", key, err)
			}

			k := Key{
				Name:     key,
				Module:   strings.TrimSpace(luaModule.String()),
				Function: strings.TrimSpace(luaFunction.String()),
			}

			c.Keys = append(c.Keys, k)
		}
	}

	if !c.Coop.Host {
		if err = steamid.Validate(c.Coop.HostSteamID); err != nil {
			c.Coop.HostSteamID = 0
		}
	}

	for _, v := range c.Coop.Blacklist {
		_, err = FromString(v)
		if err != nil {
			return fmt.Errorf("invalid blacklist entry %s: %w", v, err)
		}
	}

	for _, v := range c.Coop.Whitelist {
		_, err = FromString(v)
		if err != nil {
			return fmt.Errorf("invalid whitelist entry %s: %w", v, err)
		}
	}

	return nil
}
