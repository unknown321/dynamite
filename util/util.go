package util

import (
	"crypto/md5"
	"encoding/xml"
	"fmt"
	"io"
	"log/slog"
	"net/http"
	"os"
	"os/exec"
	"runtime"
	"runtime/debug"
	"strconv"
	"strings"
	"time"
)

func Md5sum(filePath string) ([]byte, error) {
	file, err := os.Open(filePath)
	if err != nil {
		return nil, err
	}
	defer file.Close()

	hash := md5.New()
	if _, err = io.Copy(hash, file); err != nil {
		return nil, err
	}

	hashInBytes := hash.Sum(nil)
	return hashInBytes, nil
}

type Version struct {
	Commit string
	Date   string
	Dirty  bool
	Tag    string
}

func GetVersion() Version {
	bf, ok := debug.ReadBuildInfo()
	if !ok {
		slog.Error("cannot read build info")
		slog.Error("Press Enter to exit.")
		var a []byte
		_, _ = fmt.Scanln(&a)
		os.Exit(1)
	}

	commit := ""
	commitDate := ""
	dirty := false
	tag := ""

	for _, k := range bf.Settings {
		switch k.Key {
		case "vcs.revision":
			commit = k.Value
		case "vcs.time":
			commitDate = k.Value
		case "vcs.modified":
			dirty = k.Value == "true"
		default:
		}
	}

	tag = strings.Split(bf.Main.Version, "-")[0]

	return Version{
		Commit: commit,
		Date:   commitDate,
		Dirty:  dirty,
		Tag:    tag,
	}
}

func GetVersionTime() int64 {
	vv := GetVersion()
	var currentVersion int64
	q, err := time.Parse(time.RFC3339, vv.Date)
	if err != nil {
		currentVersion = 0
	} else {
		currentVersion = q.Unix()
	}

	return currentVersion
}

type SteamProfileXML struct {
	SteamID64 uint64 `xml:"steamID64"`
}

func GetSteamID(steamID string) (uint64, error) {
	var result uint64
	var err error
	if strings.HasPrefix(steamID, "https://steamcommunity.com/id/") {
		var resp *http.Response
		resp, err = http.DefaultClient.Get(steamID + "?xml=1")
		if err != nil {
			return 0, err
		}
		defer resp.Body.Close()

		if resp.StatusCode != http.StatusOK {
			return 0, fmt.Errorf("get %s, http code %d", steamID, resp.StatusCode)
		}

		prof := SteamProfileXML{}
		body, err := io.ReadAll(resp.Body)
		if err != nil {
			return 0, fmt.Errorf("get %s, error %w", steamID, err)
		}

		if err = xml.Unmarshal(body, &prof); err != nil {
			return 0, fmt.Errorf("unmarshal %s, error %w", steamID, err)
		}

		return prof.SteamID64, nil
	}

	if strings.HasPrefix(steamID, "https://steamcommunity.com/profiles/") {
		result, err = strconv.ParseUint(
			strings.TrimSuffix(strings.TrimPrefix(steamID, "https://steamcommunity.com/profiles/"), "/"),
			10, 64)
		if err != nil {
			return 0, err
		}

		return result, nil
	}

	if strings.HasPrefix(steamID, "7") {
		result, err = strconv.ParseUint(steamID, 10, 64)
		if err != nil {
			return 0, err
		}

		return result, nil
	}

	return 0, fmt.Errorf("unrecognized input: %s", steamID)
}

func OpenURL(url string) error {
	var cmd string
	var args []string

	switch runtime.GOOS {
	case "windows":
		cmd = "cmd.exe"
		args = []string{"/c", "start", url}
	case "darwin":
		cmd = "open"
		args = []string{url}
	default:
		if isWSL() {
			cmd = "cmd.exe"
			args = []string{"/c", "start", url}
		} else {
			cmd = "xdg-open"
			args = []string{url}
		}
	}
	if len(args) > 1 {
		// args[0] is used for 'start' command argument, to prevent issues with URLs starting with a quote
		args = append(args[:1], append([]string{""}, args[1:]...)...)
	}
	cmnd := exec.Command(cmd, args...)
	g := GetAttr()
	cmnd.SysProcAttr = &g
	if err := cmnd.Start(); err != nil {
		return err
	}

	return cmnd.Wait()
}

func isWSL() bool {
	releaseData, err := exec.Command("uname", "-r").Output()
	if err != nil {
		return false
	}
	return strings.Contains(strings.ToLower(string(releaseData)), "microsoft")
}
