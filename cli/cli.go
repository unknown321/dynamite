package cli

import (
	"dynamite/config"
	"dynamite/installer"
	"dynamite/masterserver"
	"dynamite/updatecheck"
	"dynamite/util"
	"dynamite/webui"
	"dynamite/webui/handlers"
	"flag"
	"fmt"
	"log/slog"
	"net/http"
	"os"
	"time"
)

func Run() {
	var err error

	vers := util.GetVersion()

	installNow := false
	forceInstall := false
	installAndExit := false
	flag.BoolVar(&installNow, "installNow", false, "install now")
	flag.BoolVar(&forceInstall, "forceInstall", false, "force install")
	flag.BoolVar(&installAndExit, "installAndExit", false, "install and exit")

	flag.Usage = func() {
		fmt.Println("dynamite, MGSV:TPP co-op mod")
		dirty := ""
		if vers.Dirty {
			dirty = ", dirty"
		}
		fmt.Printf("Version %s (%s)%s\n", vers.Date, vers.Commit, dirty)
		fmt.Println()

		fmt.Printf("Usage of %s:\n", os.Args[0])
		fmt.Printf("\t%s [OPTION]\n", os.Args[0])
		fmt.Println()

		flag.PrintDefaults()
	}

	flag.Parse()

	slog.Info("dynamite, MGSV:TPP co-op mod", "version", vers.Tag, "commit", vers.Commit, "build time", vers.Date, "dirty", vers.Dirty)

	if _, err = os.Stat("mgsvtpp.exe"); err != nil {
		slog.Error("mgsvtpp.exe not found. Press Enter to exit.")
		var a []byte
		_, _ = fmt.Scanln(&a)
		os.Exit(1)
	}

	conf := config.Config{}
	if !conf.Exists() {
		slog.Info("Creating default config")
		if err = conf.Default(); err != nil {
			slog.Error("Config", "error", err.Error())
			slog.Error("Press Enter to exit.")
			var a []byte
			_, _ = fmt.Scanln(&a)
			os.Exit(1)
		}
		slog.Info("Config created")
	}

	if err = conf.Load(); err != nil {
		slog.Error("Config load", "error", err.Error())
		slog.Error("Press Enter to exit.")
		var a []byte
		_, _ = fmt.Scanln(&a)
		os.Exit(1)
	}

	if installNow {
		conf.Dynamite.SkipConfig = true
	}

	slog.Info("Checking for updates")
	hasUpdate, tag, err := updatecheck.Check()
	if err != nil {
		slog.Warn("Update check failed", "error", err.Error())
	} else {
		if hasUpdate {
			slog.Info("New update found", "new version", tag, "old version", vers.Tag)
			handlers.HasUpdate = true
		} else {
			slog.Info("No updates found")
		}
	}

	var StartLocalServer = make(chan bool, 1)

	// install
	go func(c *config.Config, ls chan bool) {
		for {
			select {
			case <-handlers.StartInstallChan:
				buildVersion := util.GetVersionTime()
				slog.Info("Install?", "installed", conf.Dynamite.Installed, "config version", conf.Dynamite.Version, "build version", buildVersion)
				if conf.Dynamite.Installed && (conf.Dynamite.Version >= buildVersion) && !forceInstall {
					slog.Info("already installed")
					handlers.InstallStat.Done = true
					handlers.InstallStat.Error = ""
					StartLocalServer <- true
				} else {
					handlers.InstallStat.Done = false
					handlers.InstallStat.Error = ""
					handlers.InstallStat.MetaTag = ""

					if err = installer.Install(c); err != nil {
						slog.Error("install", "error", err.Error())
						handlers.InstallStat.Error = err.Error()
						handlers.InstallStat.Done = true
					} else {
						handlers.InstallStat.Error = ""
						handlers.InstallStat.Done = true
						slog.Info("installed data")
						slog.Info("done")
						if installAndExit {
							slog.Info("Exiting per user request")
							os.Exit(0)
						}
						StartLocalServer <- true
					}
				}
			}
		}
	}(&conf, StartLocalServer)

	// fuse
	go func(c *config.Config, ls chan bool) {
	Loop:
		for {
			select {
			case <-ls:
				if c.Dynamite.UseLocalMasterServer {
					masterserver.Run()
					break Loop
				} else {
					slog.Info("Using remote master server", "address", c.MasterServer.URL)
				}
			}
		}
	}(&conf, StartLocalServer)

	// healthcheck that opens web ui as soon as it's up
	go func(c *config.Config, ls chan bool) {
		if c.Dynamite.SkipConfig {
			if c.Dynamite.UseLocalMasterServer {
				ls <- c.Dynamite.UseLocalMasterServer
			}
			return
		}

		cl := http.DefaultClient
		u := "http://" + c.Dynamite.UIAddress
		if !c.Dynamite.DocsRead {
			u = "http://" + c.Dynamite.UIAddress + "/docs"
		}
	HSLoop:
		for {
			time.Sleep(time.Second * 1)
			resp, err := cl.Get(u)
			if err != nil {
				slog.Warn("healthcheck", "error", err.Error())
			}
			if resp == nil {
				continue
			}
			if resp.StatusCode == http.StatusOK {

				slog.Info(fmt.Sprintf("Opening %s in browser", u))
				if err = util.OpenURL(u); err != nil {
					slog.Error("Cannot open Web UI in browser", "error", err.Error())
				}
				break HSLoop
			}
		}
	}(&conf, StartLocalServer)

	if installNow {
		slog.Info("Installing now")
		handlers.StartInstallChan <- true
		select {}
	} else {
		slog.Info("Starting Web UI", "address", conf.Dynamite.UIAddress)
		webui.Run(conf.Dynamite.UIAddress, &conf)
		slog.Info("Web UI stopped")
	}
}
