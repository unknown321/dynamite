package installer

import (
	"bytes"
	"dynamite/config"
	"dynamite/hook"
	"dynamite/moddata"
	"dynamite/savebackup"
	"dynamite/util"
	"encoding/json"
	"errors"
	"fmt"
	"io/fs"
	"log/slog"
	"os"
	"path/filepath"
	"slices"
	"strings"

	"github.com/unknown321/datfpk/fpk"
	"github.com/unknown321/datfpk/qar"
	"github.com/unknown321/hashing"
)

var vendor00 = filepath.Join("master", "0", "00.dat.vendor")
var plain00 = filepath.Join("master", "0", "00.dat")

var qarFiles = []string{
	vendor00,
	filepath.Join("master", "0", "01.dat"),
	filepath.Join("master", "chunk1.dat"),
	filepath.Join("master", "chunk2.dat"),
	filepath.Join("master", "chunk3.dat"),
	filepath.Join("master", "chunk4.dat"),
	filepath.Join("master", "data1.dat"),
}

var qars = make(map[string]*qar.Qar, 0)

// check if 00.dat.vendor exists
func vendorExists() bool {
	fp := vendor00
	_, err := os.Stat(fp)
	if errors.Is(err, fs.ErrNotExist) {
		return false
	}
	if err != nil {
		return false
	}

	return true
}

func vendorValid(path string) bool {
	h, err := util.Md5sum(path)
	if err != nil {
		return false
	}
	slog.Info("checksum", "path", path, "sum", fmt.Sprintf("%x", h))
	// 2779dcc79b7b700ed70b3900344cc164
	target := []byte{0x27, 0x79, 0xdc, 0xc7, 0x9b, 0x7b, 0x70, 0x0e, 0xd7, 0x0b, 0x39, 0x00, 0x34, 0x4c, 0xc1, 0x64}
	if bytes.Compare(h, target) != 0 {
		return false
	}

	return true
}

func backupVendor() error {
	if !vendorExists() {
		slog.Info("00.dat.vendor does not exist, creating")
		if !vendorValid(plain00) {
			return fmt.Errorf("00.dat is not valid. Verify integrity of data files using Steam and try again")
		}

		f, err := os.Open(plain00)
		if err != nil {
			return err
		}
		defer f.Close()

		vv, err := os.Create(vendor00)
		if err != nil {
			return err
		}
		defer vv.Close()

		if _, err = vv.ReadFrom(f); err != nil {
			return err
		}
	} else {
		if !vendorValid(vendor00) {
			slog.Warn("00.dat.vendor is invalid, you are on your own")
			slog.Warn("Press Enter to continue...")
			var a []byte
			_, _ = fmt.Scanln(&a)
		}
	}

	return nil
}

func unpackVendor() (string, error) {
	q := qar.Qar{}
	if err := q.ReadFrom(vendor00); err != nil {
		return "", fmt.Errorf("read qar %s: %w", vendor00, err)
	}
	defer q.Close()

	tempdir, err := os.MkdirTemp("", "dynamite-")
	if err != nil {
		return "", fmt.Errorf("create temp dir: %w", err)
	}

	dict := hashing.Dictionary{}
	outdir := filepath.Join(tempdir, strings.ReplaceAll(filepath.Base(plain00), ".dat", "_dat"))
	for n, e := range q.Entries {
		entryName, _ := dict.GetByHash(e.Header.PathHash)
		q.Entries[n].Header.FilePath = entryName

		q.Entries[n].Header.NameHashForPacking = e.Header.PathHash
		if _, err = q.Extract(entryName, e.Header.PathHash, outdir); err != nil {
			return "", fmt.Errorf("extract vendor: %w", err)
		}
	}
	slog.Info("unpacked", "file", vendor00)

	descName := filepath.Join(tempdir, filepath.Base(plain00)) + ".json"
	desc, err := os.OpenFile(descName, os.O_CREATE|os.O_TRUNC|os.O_RDWR, 0666)
	if err != nil {
		return "", fmt.Errorf("cannot open description file %s for writing: %w", descName, err)
	}
	defer desc.Close()

	if err = q.SaveDefinition(desc); err != nil {
		return "", fmt.Errorf("cannot save description to %s: %w", descName, err)
	}

	return outdir, nil
}

func packVendor(baseDir string) error {
	var err error
	qq := qar.Qar{}
	descName := filepath.Join(filepath.Dir(baseDir), "00.dat.json")
	var f []byte
	if f, err = os.ReadFile(descName); err != nil {
		return fmt.Errorf("read qar definition from %s: %w", descName, err)
	}

	if err = json.Unmarshal(f, &qq); err != nil {
		return fmt.Errorf("unmarshal qar definition: %w", err)
	}

	appends := []qar.Entry{
		{
			Header: qar.EntryHeader{
				FilePath:   "/Assets/tpp/pack/coop/coop_essentials.fpk",
				Compressed: true,
			},
		},
		{
			Header: qar.EntryHeader{
				FilePath:   "/Assets/tpp/pack/coop/coop_essentials.fpkd",
				Compressed: true,
			},
		},
	}

	for _, v := range appends {
		qq.Entries = append(qq.Entries, v)
		slog.Info("appended", "file", v.Header.FilePath)
	}

	dict := hashing.Dictionary{}

	for _, e := range moddata.ReplaceInFPK {
		hash := hashing.HashFileNameWithExtension(e.Source.NameInQar)
		fn, _ := dict.GetByHash(hash)
		prevFile := filepath.Join(baseDir, fn)
		if _, err = os.Stat(prevFile); err == nil {
			slog.Info("removing", "file", e.Source.NameInQar, "onDisk", prevFile)
			_ = os.Remove(prevFile)
		}

		found := false
		for k, v := range qq.Entries {
			if v.Header.NameHashForPacking == hash {
				qq.Entries[k].Header.FilePath = e.Source.NameInQar
				slog.Info("found existing file", "name", e.Source.NameInQar, "onDisk", prevFile)
				found = true
				break
			}
		}

		if !found {
			qq.Entries = append(qq.Entries, qar.Entry{
				Header: qar.EntryHeader{
					FilePath:   e.Source.NameInQar,
					Compressed: e.Compressed,
				},
			})
		}
	}

	for _, e := range moddata.ReplaceInQAR {
		hash := hashing.HashFileNameWithExtension(e.FileName)
		fn, _ := dict.GetByHash(hash)
		prevFile := filepath.Join(baseDir, fn)
		if _, err = os.Stat(prevFile); err == nil {
			slog.Info("removing", "file", e.FileName, "onDisk", prevFile)
			_ = os.Remove(prevFile)
		}

		found := false
		for k, v := range qq.Entries {
			if v.Header.NameHashForPacking == hash {
				qq.Entries[k].Header.FilePath = e.FileName
				slog.Info("found existing file", "name", e.FileName, "onDisk", prevFile)
				found = true
				break
			}
		}

		if !found {
			qq.Entries = append(qq.Entries, qar.Entry{
				Header: qar.EntryHeader{
					FilePath: e.FileName,
				},
			})
			slog.Info("added to qar", "name", e.FileName)
		}
	}

	if err = os.Remove(plain00); err != nil {
		return fmt.Errorf("removing stock 00.dat: %w", err)
	}

	outname := plain00
	out, err := os.OpenFile(outname, os.O_CREATE|os.O_TRUNC|os.O_RDWR, 0666)
	if err != nil {
		return fmt.Errorf("open QAR file for writing: %w", err)
	}

	slog.Info("packing vendor")

	if err = qq.Write(out, baseDir, false); err != nil {
		return fmt.Errorf("write qar: %w", err)
	}
	qq.Close()

	slog.Info("packed vendor", "filename", outname)

	return nil
}

func createEssentials(outdir string) error {
	mtar := moddata.FileFromQar{
		SourceQar: filepath.Join("master", "chunk3.dat"),
		NameInQar: "/Assets/tpp/pack/location/mtbs/pack_mission/mtbs_mission_fob.fpk",
	}
	mtarFpk, err := mtar.Unpack(qars)
	if err != nil {
		return err
	}

	fpkP := filepath.FromSlash("/Assets/tpp/pack/coop/")
	essDir := filepath.Join(outdir, fpkP)
	if err = os.MkdirAll(essDir, 0700); err != nil {
		return err
	}

	essOut := filepath.Join(essDir, "coop_essentials.fpk")
	outFile, err := os.OpenFile(essOut, os.O_CREATE|os.O_TRUNC|os.O_RDWR, 0666)
	if err != nil {
		return err
	}
	defer outFile.Close()

	if _, err = outFile.ReadFrom(bytes.NewReader(mtarFpk)); err != nil {
		return err
	}

	essOutd := filepath.Join(essDir, "coop_essentials.fpkd")
	outFile2, err := os.OpenFile(essOutd, os.O_CREATE|os.O_TRUNC|os.O_RDWR, 0666)
	if err != nil {
		return err
	}
	defer outFile2.Close()

	ff, err := moddata.ModData.ReadFile("coop_essentials/coop_essentials.fpkd")
	if err != nil {
		return err
	}
	if _, err = outFile2.ReadFrom(bytes.NewReader(ff)); err != nil {
		return err
	}

	return nil
}

func replaceFiles(outdir string) error {
	for _, f := range moddata.ReplaceInFPK {
		sourceFpkData, err := f.Source.Unpack(qars)
		if err != nil {
			return err
		}

		sourceFpk := fpk.Fpk{}
		if err = sourceFpk.Read(bytes.NewReader(sourceFpkData), false); err != nil {
			return err
		}

		for _, add := range f.Add {
			for i, e := range sourceFpk.Entries {
				if e.FilePath.Data == add.FileName {
					slog.Info("replacing", "name", add.FileName, "fpk", f.Source.NameInQar)
					sourceFpk.Entries[i].Data, err = moddata.ModData.ReadFile(add.SourceFile)
					if err != nil {
						return fmt.Errorf("source file not found: %w", err)
					}

					slog.Info("replaced", "file", add.FileName, "fpk", f.Source.NameInQar, "source dat", f.Source.SourceQar)
					break

				}
			}
		}

		toDelete := []string{}
		copy(toDelete, f.Delete)

		// TODO less loops?
	Start:
		for i, e := range sourceFpk.Entries {
			for k, d := range toDelete {
				if e.FilePath.Data == d {
					sourceFpk.Entries = slices.Delete(sourceFpk.Entries, i, i+1)
					toDelete = slices.Delete(toDelete, k, k+1)
					slog.Info("deleted", "name", d, "fpk", f.Source.NameInQar)
					goto Start
				}
			}
		}

		if len(toDelete) != 0 {
			ff := ""
			for _, v := range toDelete {
				ff += v + ","
			}
			ff = strings.TrimSuffix(ff, ",")
			return fmt.Errorf("failed to delete from %s: %s", f.Source, ff)
		}

		outPath := filepath.Join(outdir, f.Source.NameInQar)
		baseDir := filepath.Join(outdir, filepath.Dir(f.Source.NameInQar))
		_ = os.MkdirAll(baseDir, 0755)
		outfile, err := os.OpenFile(outPath, os.O_CREATE|os.O_TRUNC|os.O_RDWR, 0666)
		if err != nil {
			return fmt.Errorf("open replaced file: %w", err)
		}

		if err = sourceFpk.Write(outfile, "", false); err != nil {
			_ = outfile.Close()
			return fmt.Errorf("write fpk after replacing: %w", err)
		}

		if err = outfile.Close(); err != nil {
			return fmt.Errorf("close fpk: %w", err)
		}
		slog.Info("replaced in", "fpk", f.Source.NameInQar, "source dat", f.Source.SourceQar)
	}

	return nil
}

func addToQar(outdir string) error {
	for _, f := range moddata.ReplaceInQAR {
		outPath := filepath.Join(outdir, f.FileName)
		baseDir := filepath.Join(outdir, filepath.Dir(f.FileName))
		_ = os.MkdirAll(baseDir, 0755)
		outfile, err := os.OpenFile(outPath, os.O_CREATE|os.O_TRUNC|os.O_RDWR, 0666)
		if err != nil {
			return fmt.Errorf("open replaced file: %w", err)
		}

		source, err := moddata.ModData.ReadFile(f.SourceFile)
		if err != nil {
			_ = outfile.Close()
			return fmt.Errorf("read source file: %w", err)
		}

		if _, err = outfile.ReadFrom(bytes.NewReader(source)); err != nil {
			_ = outfile.Close()
			return err
		}

		if err = outfile.Close(); err != nil {
			return err
		}

		slog.Info("added", "file", f.FileName)
	}

	return nil
}

func outsideScripts() error {
	err := os.MkdirAll("./lua", 0755)
	if err != nil {
		if !os.IsExist(err) {
			return fmt.Errorf("cannot create lua directory: %w", err)
		}
	}

	scripts := []string{"LIP", "helpers"}
	for _, s := range scripts {
		f, err := os.OpenFile(filepath.Join("lua", s+".lua"), os.O_CREATE|os.O_TRUNC|os.O_RDWR, 0666)
		if err != nil {
			return err
		}

		data, err := moddata.OutsideScripts.ReadFile("outsidescripts/" + s + ".lua")
		if err != nil {
			_ = f.Close()
			return err
		}

		if _, err = f.ReadFrom(bytes.NewReader(data)); err != nil {
			_ = f.Close()
			return err
		}

		_ = f.Close()
	}

	return nil
}

func createHook() error {
	data, err := hook.FS.ReadFile("cmake-build-release-docker-mingw15/dinput8.dll")
	if err != nil {
		return err
	}

	if err = os.WriteFile("dinput8.dll", data, 0666); err != nil {
		return err
	}

	return nil
}

func Install(conf *config.Config) error {
	var err error

	err = savebackup.Run(conf.Dynamite.AccountDir)
	if err != nil {
		bd, _ := savebackup.GetAccountDirectory()
		return fmt.Errorf("steam user not found, provide full path to account directory in config, example: %s, error %s", bd, err.Error())
	}

	if err = backupVendor(); err != nil {
		return err
	}

	var outDir string
	if outDir, err = unpackVendor(); err != nil {
		return err
	}
	slog.Info("extracting", "outDir", outDir)
	defer func() {
		slog.Info("removing temp dir", "path", filepath.Dir(outDir))
		if err1 := os.RemoveAll(filepath.Dir(outDir)); err1 != nil {
			slog.Error("cannot remove temp dir %s: %w", filepath.Dir(outDir), err1)
		}
	}()

	for _, p := range qarFiles {
		q := qar.Qar{}
		if err = q.ReadFrom(p); err != nil {
			return fmt.Errorf("read qar %s: %w", p, err)
		}
		qars[p] = &q
	}

	defer func() {
		for _, v := range qars {
			v.Close()
		}
	}()

	if err = createEssentials(outDir); err != nil {
		return err
	}

	if err = replaceFiles(outDir); err != nil {
		return err
	}

	if err = addToQar(outDir); err != nil {
		return err
	}

	if err = packVendor(outDir); err != nil {
		return err
	}

	if err = outsideScripts(); err != nil {
		return err
	}

	if err = createHook(); err != nil {
		return fmt.Errorf("create hook file: %w", err)
	}

	buildVersion := util.GetVersionTime()
	conf.Dynamite.Installed = true
	if buildVersion > conf.Dynamite.Version {
		conf.Dynamite.Version = buildVersion
	}

	if err = conf.Save(); err != nil {
		return fmt.Errorf("save config post installation: %w", err)
	}

	return nil
}
