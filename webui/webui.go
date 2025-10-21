package webui

import (
	"dynamite/config"
	"dynamite/util"
	"dynamite/webui/handlers"
	"dynamite/webui/static"
	"errors"
	"fmt"
	"log/slog"
	"net/http"
	"os"
)

func withFlavor(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		handlers.GetFlavor()
		next.ServeHTTP(w, r)
	})
}

func Run(address string, conf *config.Config) {
	var err error
	if address == "" {
		address = "127.0.0.1:8070"
	}

	handlers.Init()

	mux := http.NewServeMux()
	hm := withFlavor(mux)
	srv := &http.Server{Addr: address, Handler: hm}
	handlers.Server = srv
	handlers.Config = conf
	handlers.Version = util.GetVersion()

	mux.Handle("/static/", http.StripPrefix("/static/", http.FileServer(http.FS(static.FS))))

	mux.HandleFunc("/", handlers.Start)
	mux.HandleFunc("/stop", handlers.Stop)
	mux.HandleFunc("/save-config", handlers.Save)
	mux.HandleFunc("/docs", handlers.Docs)
	mux.HandleFunc("/missionlist", handlers.MissionList)
	mux.HandleFunc("/donate", handlers.Donate)
	mux.HandleFunc("/donated", handlers.Donated)
	mux.HandleFunc("/license", handlers.License)
	mux.HandleFunc("/status", handlers.Status)
	mux.HandleFunc("/healthcheck", func(writer http.ResponseWriter, request *http.Request) {
		writer.WriteHeader(http.StatusOK)
		return
	})

	if err = srv.ListenAndServe(); err != nil {
		if !errors.Is(err, http.ErrServerClosed) {
			slog.Error("Web UI", "error", err.Error())
			slog.Error("Press Enter to exit.")
			var a []byte
			_, _ = fmt.Scanln(&a)
			os.Exit(1)
		}
	}
}
