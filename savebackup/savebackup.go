package savebackup

import (
	"archive/zip"
	"fmt"
	"io"
	"log/slog"
	"os"
	"path/filepath"
	"regexp"
	"runtime"
	"strings"
	"time"

	"github.com/unknown321/squib/save"
)

var usernameRegex = regexp.MustCompile(`^[0-9]+$`)
var backupRegex = regexp.MustCompile(`^[0-9]+\.dynamite\.[0-9]+.zip$`)

func GetAccountDirectory() (string, error) {
	var steamPath string

	switch runtime.GOOS {
	case "windows":
		steamPath = os.Getenv("PROGRAMFILES(X86)")
		if steamPath == "" {
			return "", fmt.Errorf("can't get Program Files path")
		}
		steamPath = filepath.Join(steamPath, "Steam")
	default:
		steamPath = os.Getenv("HOME")
		if steamPath == "" {
			return "", fmt.Errorf("can't get HOME variable")
		}
		steamPath = filepath.Join(steamPath, ".steam", "steam")
	}

	steamPath = filepath.Join(steamPath, "userdata")

	return steamPath, nil
}

func GetSteamPath() (string, bool, error) {
	steamPath, err := GetAccountDirectory()
	if err != nil {
		return "", false, err
	}

	var steamUsers []string
	dirs, err := os.ReadDir(steamPath)
	if err != nil {
		return "", false, fmt.Errorf("list userdata, directory %s: %w", steamPath, err)
	}

	for _, d := range dirs {
		if !d.IsDir() {
			continue
		}

		if usernameRegex.MatchString(d.Name()) {
			steamUsers = append(steamUsers, d.Name())
		}
	}

	if len(steamUsers) != 1 {
		return "", true, fmt.Errorf("provide steam account path")
	}

	steamPath = filepath.Join(steamPath, steamUsers[0])

	return steamPath, false, nil
}

func BackupExists(userdataPath string) (bool, error) {
	var err error

	entries, err := os.ReadDir(userdataPath)
	if err != nil {
		return false, fmt.Errorf("backup dir %s: %w", userdataPath, err)
	}

	var tppFound bool
	var gzFound bool
	for _, v := range entries {
		if tppFound && gzFound {
			return true, nil
		}

		if v.IsDir() {
			continue
		}

		if backupRegex.MatchString(v.Name()) {
			if strings.HasPrefix(v.Name(), "287700") {
				tppFound = true
				continue
			}
		}

		if backupRegex.MatchString(v.Name()) {
			if strings.HasPrefix(v.Name(), "311340") {
				gzFound = true
				continue
			}
		}
	}

	return false, nil
}

func ZipDirectory(sourceDir, targetZip string) error {
	zipFile, err := os.Create(targetZip)
	if err != nil {
		return err
	}
	defer zipFile.Close()

	zipWriter := zip.NewWriter(zipFile)
	defer zipWriter.Close()

	baseDir := filepath.Base(sourceDir)

	return filepath.Walk(sourceDir, func(filePath string, fileInfo os.FileInfo, err error) error {
		if err != nil {
			return err
		}

		relPath, err := filepath.Rel(sourceDir, filePath)
		if err != nil {
			return err
		}

		zipPath := filepath.Join(baseDir, relPath)
		zipPath = filepath.ToSlash(zipPath)

		header, err := zip.FileInfoHeader(fileInfo)
		if err != nil {
			return err
		}

		header.Modified = fileInfo.ModTime()
		header.Name = zipPath
		header.Method = zip.Deflate

		if fileInfo.IsDir() {
			header.Name += "/"
			_, err = zipWriter.CreateHeader(header)
			return err
		}

		file, err := os.Open(filePath)
		if err != nil {
			return err
		}
		defer file.Close()

		writer, err := zipWriter.CreateHeader(header)
		if err != nil {
			return err
		}

		_, err = io.Copy(writer, file)
		return err
	})
}

type saveConvert struct {
	OldKey string
	NewKey string
}

func ConvertToDynamiteSaves(saveDir string) error {
	files := []saveConvert{
		{
			OldKey: "TPP_GAME_DATA",
			NewKey: "DYNAMITE_GAME_DATA",
		},
		{
			OldKey: "TPP_CONFIG_DATA",
			NewKey: "DYNAMITE_CONFIG_DATA",
		},
		{
			OldKey: "PERSONAL_DATA",
			NewKey: "DYNAMITE_PERSONAL_DATA",
		},
	}

	for _, k := range files {
		if _, err := os.Stat(filepath.Join(saveDir, k.NewKey)); err == nil {
			slog.Info("Save already exists", "name", k.NewKey)
			continue
		}

		data, err := os.ReadFile(filepath.Join(saveDir, k.OldKey))
		if err != nil {
			return err
		}
		save.Decode(k.OldKey, data)
		save.Decode(k.NewKey, data)

		// just in case, permission bits on windows are weird
		perm := 0666
		if err = os.WriteFile(filepath.Join(saveDir, k.NewKey), data, os.FileMode(perm)); err != nil {
			return fmt.Errorf("%s: %w", k.NewKey, err)
		}

		slog.Info("Converted save file", "old", k.OldKey, "new", k.NewKey)
	}

	return nil
}

func CreateLocalSaves(saveDir string, localSaveDir string) error {
	files := []string{
		"DYNAMITE_GAME_DATA",
		"DYNAMITE_CONFIG_DATA",
		"DYNAMITE_PERSONAL_DATA",
	}

	for _, k := range files {
		if _, err := os.Stat(filepath.Join(localSaveDir, k+"0")); err == nil {
			slog.Info("Local save already exists", "name", k+"0")
			continue
		}

		if _, err := os.Stat(filepath.Join(localSaveDir, k+"1")); err == nil {
			slog.Info("Local save already exists", "name", k+"1")
			continue
		}

		data, err := os.ReadFile(filepath.Join(saveDir, k))
		if err != nil {
			return err
		}

		perm := 0666
		if err = os.WriteFile(filepath.Join(localSaveDir, k+"0"), data, os.FileMode(perm)); err != nil {
			return fmt.Errorf("%s: %w", k+"0", err)
		}
		if err = os.WriteFile(filepath.Join(localSaveDir, k+"1"), data, os.FileMode(perm)); err != nil {
			return fmt.Errorf("%s: %w", k+"1", err)
		}

		slog.Info("Created local save file", "name", k)
	}

	return nil
}

func Run(accountDir string) (needUser bool, err error) {
	accDir := accountDir
	if accountDir == "" {
		accDir, needUser, err = GetSteamPath()
		if needUser {
			return needUser, nil
		}
	}

	if err != nil {
		return false, fmt.Errorf("get steam path: %w", err)
	}

	exists, err := BackupExists(accDir)
	if err != nil {
		return false, fmt.Errorf("check for backup: %w", err)
	}

	if exists {
		slog.Info("Backup already exists")
	} else {
		slog.Info("Creating backup")

		zipPath := filepath.Join(accDir, fmt.Sprintf("%d.dynamite.%d.zip", 287700, time.Now().Unix()))
		if err = ZipDirectory(filepath.Join(accDir, "287700"), zipPath); err != nil {
			return false, fmt.Errorf("TPP backup: %w", err)
		}
		slog.Info("created TPP backup", "filename", zipPath)

		zipPath = filepath.Join(accDir, fmt.Sprintf("%d.dynamite.%d.zip", 311340, time.Now().Unix()))
		if err = ZipDirectory(filepath.Join(accDir, "311340"), zipPath); err != nil {
			return false, fmt.Errorf("GZ backup: %w", err)
		}
		slog.Info("created GZ backup", "filename", zipPath)
	}

	saveDir := filepath.Join(accDir, "311340", "remote")
	if err = ConvertToDynamiteSaves(saveDir); err != nil {
		return false, fmt.Errorf("convert to dynamite saves: %w", err)
	}

	localSaveDir := filepath.Join(accDir, "287700", "local")
	if err = CreateLocalSaves(saveDir, localSaveDir); err != nil {
		return false, fmt.Errorf("create local files: %w", err)
	}

	return false, nil
}
