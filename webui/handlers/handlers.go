package handlers

import (
	"context"
	"dynamite/config"
	"dynamite/masterserver"
	"dynamite/savebackup"
	"dynamite/util"
	handlers "dynamite/webui/templates"
	"fmt"
	"html/template"
	"log/slog"
	"math/rand"
	"net/http"
	"net/url"
	"os"
	"path/filepath"
	"strconv"
	"strings"
)

var Server *http.Server
var Config *config.Config
var Version util.Version

var tmpl *template.Template

var StartInstallChan = make(chan bool, 1)

var InstallStat InstallStatus

var HasUpdate bool

type InstallStatus struct {
	Error     string
	Done      bool
	MetaTag   string
	HasUpdate bool
	Version   *util.Version
	Flavor    string
}

func Init() {
	var err error
	tmpl, err = template.New("").Funcs(template.FuncMap{
		"rawHTML": func(s string) template.HTML {
			return template.HTML(s)
		},
	}).ParseFS(handlers.FS, "*.tmpl")

	if err != nil {
		panic(err)
	}

	rand.Shuffle(len(Flavors), func(i, j int) { Flavors[i], Flavors[j] = Flavors[j], Flavors[i] })
}

type Account struct {
	Name  string
	Value string
}

type pageData struct {
	Config    *config.Config
	Version   *util.Version
	Keys      map[string]bool
	Examples  map[string]string
	MetaTag   string
	HasUpdate bool
	Blacklist []config.LimitListEntry
	Whitelist []config.LimitListEntry
	Accounts  []Account
	Done      bool
	Flavor    string
}

var Flavors = []string{
	"Support the project",
	"Buy me a hamburger",
	"Motherbase is in red, send GMP",
	"Miller needs your help",
	"Send GMP for wolbachia dose",
	"Help me expand Motherbase",
	"Send me a supply drop",
	"Be my buddy",
	"Requesting supplies",
}

var currentFlavorIDX = 0
var currentFlavorShown = 0
var currentFlavor = Flavors[currentFlavorIDX]

func Start(w http.ResponseWriter, r *http.Request) {
	if err := Config.Load(); err != nil {
		http.Error(w, fmt.Sprintf("load config: %s", err.Error()), http.StatusBadRequest)
		return
	}

	accs, err := savebackup.GetValidAccounts()
	if err != nil {
		slog.Error("Unable to find valid Steam account", "error", err.Error())
	}

	if accs == nil {
		accs = make([]string, 0)
	}

	aa := []Account{}
	if len(accs) == 1 {
		Config.Dynamite.AccountDir = accs[0]
	} else {
		for _, v := range accs {
			sid := filepath.Base(v)
			sid64, err := strconv.ParseUint(sid, 10, 64)
			if err != nil {
				slog.Warn("invalid account name", "name", sid, "error", err.Error())
				continue
			}

			name, err := util.GetSteamName(sid64)
			if err != nil {
				slog.Warn("Resolve account name", "error", err.Error())
			}
			aa = append(aa, Account{
				Name:  name,
				Value: v,
			})
		}
	}

	d := pageData{
		Config:    Config,
		Version:   &Version,
		Keys:      config.PlayerPadKeys,
		Examples:  make(map[string]string),
		HasUpdate: HasUpdate,
		Accounts:  aa,
		Flavor:    currentFlavor,
	}

	d.Examples["SteamID"] = "Example: 76561197960287930"
	d.Examples["SteamID2"] = "Example: https://steamcommunity.com/id/GabeLoganNewell/"
	d.Examples["SteamID3"] = "Example: https://steamcommunity.com/profiles/76561197960287930/"
	d.Examples["UI Address2"] = "Example: 127.0.0.1:8070"
	d.Examples["UI Address"] = "This page's address"
	d.Examples["Reload Key"] = "Press and hold this key with master key to update key bindings and host Steam ID while in game"

	bd, _ := savebackup.GetAccountDirectory()
	d.Examples["Account Directory2"] = "Example: " + filepath.Join(bd, "<numbers>")
	d.Examples["Account Directory"] = "Used to back up your saves"
	d.Examples["Master Server URL"] = "Example: http://192.168.10.101:6667"
	d.Examples["Master Server URL2"] = "Example: http://1.2.3.4:8080/tppstm/gate"

	for _, v := range Config.Coop.Blacklist {
		ll, err := config.FromString(v)
		if err != nil {
			http.Error(w, fmt.Sprintf("invalid blacklist entry %s: %s", v, err.Error()), http.StatusBadRequest)
			return
		}

		d.Blacklist = append(d.Blacklist, ll)
	}

	for _, v := range Config.Coop.Whitelist {
		ll, err := config.FromString(v)
		if err != nil {
			http.Error(w, fmt.Sprintf("invalid whitelist entry %s: %s", v, err.Error()), http.StatusBadRequest)
			return
		}

		d.Whitelist = append(d.Whitelist, ll)
	}

	if err := tmpl.ExecuteTemplate(w, "start.tmpl", d); err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
}

func Stop(w http.ResponseWriter, r *http.Request) {
	Server.Shutdown(context.Background())
}

type SaveData struct {
	Installed bool
	MetaTag   string
	HasUpdate bool
	Version   *util.Version
	Done      bool
	Flavor    string
}

func Save(w http.ResponseWriter, r *http.Request) {
	if r.Method != "POST" {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	err := r.ParseForm()
	if err != nil {
		http.Error(w, "Bad Request", http.StatusBadRequest)
		return
	}

	if r.FormValue("reinstall") == "on" {
		Config.Dynamite.Installed = false
	}

	Config.Coop.Host = r.FormValue("Config.Coop.Host") == "on"
	if Config.Coop.Host {
		Config.Coop.Blacklist = make([]string, 0, len(r.Form["Config.Coop.Blacklist.SteamID"]))
		for i, v := range r.Form["Config.Coop.Blacklist.SteamID"] {
			v = strings.TrimSpace(v)
			sid, err := util.GetSteamID(v)
			if err != nil {
				http.Error(w, fmt.Sprintf("cannot parse whitelist steamID %s: %s", v, err.Error()), http.StatusBadRequest)
				return
			}

			ll := config.LimitListEntry{
				SteamID: sid,
				Note:    r.Form["Config.Coop.Blacklist.Note"][i],
			}

			Config.Coop.Blacklist = append(Config.Coop.Blacklist, ll.String())
		}

		Config.Coop.Whitelist = make([]string, 0, len(r.Form["Config.Coop.Whitelist.SteamID"]))
		for i, v := range r.Form["Config.Coop.Whitelist.SteamID"] {
			v = strings.TrimSpace(v)
			sid, err := util.GetSteamID(v)
			if err != nil {
				http.Error(w, fmt.Sprintf("cannot parse whitelist steamID %s: %s", v, err.Error()), http.StatusBadRequest)
				return
			}

			ll := config.LimitListEntry{
				SteamID: sid,
				Note:    r.Form["Config.Coop.Whitelist.Note"][i],
			}

			Config.Coop.Whitelist = append(Config.Coop.Whitelist, ll.String())
		}
	} else {
		Config.Coop.HostSteamID, err = util.GetSteamID(r.FormValue("Config.Coop.HostSteamID"))
		if err != nil {
			http.Error(w, fmt.Sprintf("Bad host SteamID: %s", err.Error()), http.StatusBadRequest)
			return
		}
	}

	Config.Dynamite.AccountDir = r.FormValue("Config.Dynamite.AccountDir")
	Config.Dynamite.UIAddress = r.FormValue("Config.Dynamite.UIAddress")

	Config.Dynamite.MasterKey = r.FormValue("Config.Dynamite.MasterKey")
	if ok, _ := config.PlayerPadKeys[Config.Dynamite.MasterKey]; !ok {
		http.Error(w, "Invalid key "+Config.Dynamite.MasterKey, http.StatusBadRequest)
		return
	}

	Config.Dynamite.ReloadKey = r.FormValue("Config.Dynamite.ReloadKey")
	if ok, _ := config.PlayerPadKeys[Config.Dynamite.ReloadKey]; !ok {
		http.Error(w, "Invalid key "+Config.Dynamite.MasterKey, http.StatusBadRequest)
		return
	}

	Config.Dynamite.SkipConfig = r.FormValue("Config.Dynamite.SkipConfig") == "on"

	Config.Dynamite.UseLocalMasterServer = r.FormValue("Config.Dynamite.UseLocalMasterServer") == "on"
	if Config.Dynamite.UseLocalMasterServer {
		Config.MasterServer.URL = masterserver.DefaultClientAddress
	} else {
		Config.MasterServer.URL = r.FormValue("Config.MasterServer.URL")
		u, err := url.Parse(Config.MasterServer.URL)
		if err != nil {
			http.Error(w, fmt.Sprintf("Invalid master server url %s: %s", Config.MasterServer.URL, err.Error()), http.StatusBadRequest)
			return
		}

		if !strings.HasSuffix(u.RequestURI(), "/tppstm/gate") {
			if u.Path == "" || u.Path == "/" {
				u.Path = "/tppstm/gate"
				u.RawPath = ""
				u.RawQuery = ""
				u.RawFragment = ""
			} else {
				http.Error(w, fmt.Sprintf("Master server url must end in /tppstm/gate"), http.StatusBadRequest)
				return
			}
		}
		Config.MasterServer.URL = u.String()
	}

	Config.Misc.PlaySound = r.FormValue("Config.Misc.PlaySound") == "on"

	Config.Keys = []config.Key{}
	for i := 0; ; i++ {
		name := r.FormValue("Config.Keys[" + strconv.Itoa(i) + "].Name")
		if name == "" {
			break
		}
		if ok, _ := config.PlayerPadKeys[name]; !ok {
			http.Error(w, "Invalid key "+name, http.StatusBadRequest)
			return
		}

		Config.Keys = append(Config.Keys, config.Key{
			Name:     name,
			Module:   r.FormValue("Config.Keys[" + strconv.Itoa(i) + "].Module"),
			Function: r.FormValue("Config.Keys[" + strconv.Itoa(i) + "].Function"),
		})
	}

	Config.Debug.FoxBlock = r.FormValue("Config.Debug.FoxBlock") == "on"
	Config.Debug.FoxBlockProcess = r.FormValue("Config.Debug.FoxBlockProcess") == "on"
	Config.Debug.MemoryAllocTail = r.FormValue("Config.Debug.MemoryAllocTail") == "on"
	Config.Debug.PlayerTarget = r.FormValue("Config.Debug.PlayerTarget") == "on"
	Config.Debug.LuaLog = r.FormValue("Config.Debug.LuaLog") == "on"

	if Config.Dynamite.AccountDir == "" {
		http.Error(w, "Account directory is required", http.StatusBadRequest)
		return
	}

	s, err := os.Stat(Config.Dynamite.AccountDir)
	if err != nil {
		http.Error(w, fmt.Sprintf("Invalid account directory %s, error: %s", Config.Dynamite.AccountDir, err.Error()), http.StatusBadRequest)
		return
	}

	if !s.IsDir() {
		http.Error(w, fmt.Sprintf("Not a directory: %s", Config.Dynamite.AccountDir), http.StatusBadRequest)
		return
	}

	if err = Config.Save(); err != nil {
		http.Error(w, fmt.Sprintf("Failed to save config: %s", err.Error()), http.StatusInternalServerError)
		return
	}

	ss := SaveData{
		Installed: Config.Dynamite.Installed,
		MetaTag:   `<meta http-equiv="refresh" content="5;URL='/status'" />`,
		Version:   &Version,
		Flavor:    currentFlavor,
	}
	if err := tmpl.ExecuteTemplate(w, "save.tmpl", ss); err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	StartInstallChan <- true
}

func Status(w http.ResponseWriter, r *http.Request) {
	InstallStat.HasUpdate = HasUpdate
	InstallStat.Version = &Version
	InstallStat.MetaTag = ""
	InstallStat.Flavor = currentFlavor

	if !InstallStat.Done {
		InstallStat.MetaTag = `<meta http-equiv="refresh" content="2;" />`
	}

	if err := tmpl.ExecuteTemplate(w, "status.tmpl", InstallStat); err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
}

func Docs(w http.ResponseWriter, r *http.Request) {
	p := pageData{
		Config:    nil,
		Version:   &Version,
		Keys:      nil,
		Examples:  nil,
		MetaTag:   "",
		HasUpdate: HasUpdate,
		Flavor:    currentFlavor,
	}

	Config.Dynamite.DocsRead = true
	if err := Config.Save(); err != nil {
		http.Error(w, fmt.Sprintf("cannot save config: %s", err.Error()), http.StatusInternalServerError)
		return
	}

	if err := tmpl.ExecuteTemplate(w, "docs.tmpl", p); err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
}

func License(w http.ResponseWriter, r *http.Request) {
	p := pageData{
		Config:    nil,
		Version:   &Version,
		Keys:      nil,
		Examples:  nil,
		MetaTag:   "",
		HasUpdate: HasUpdate,
		Flavor:    currentFlavor,
	}

	if err := tmpl.ExecuteTemplate(w, "license.tmpl", p); err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
}

func GetFlavor() {
	if currentFlavorShown > 5 {
		currentFlavorShown = 0
		currentFlavorIDX++
		if currentFlavorIDX > len(Flavors)-1 {
			currentFlavorIDX = 0
		}
	} else {
		currentFlavorShown++
	}

	currentFlavor = Flavors[currentFlavorIDX]
}
