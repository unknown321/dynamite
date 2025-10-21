package main

import (
	"bytes"
	"log/slog"
	"os"
	"strings"

	"github.com/unknown321/datfpk/fox2"
	"github.com/unknown321/datfpk/fpk"
	"github.com/unknown321/datfpk/lng"
	"github.com/unknown321/datfpk/util"
)

var langs = []string{
	"eng",
	"ger",
	"ita",
	"jpn",
	"fre",
	"por",
	"spa",
	"rus",
}

var foxFile = "/Assets/tpp/ui/dynamite/lang_dynamite_eng.fox2.xml"

var lngFile = "/Assets/tpp/lang/ui/dynamite/dynamite_"

func Fpkd() {
	f := fpk.Fpk{}
	f.SetType(true)
	for _, langID := range langs {
		file := "moddata/tl/dynamite_" + langID + "_fpkd" + foxFile
		data, err := os.ReadFile(file)
		if err != nil {
			slog.Error("cannot read", "name", file, "error", err.Error())
			os.Exit(1)
		}

		fox := fox2.Fox2{}
		if err = fox.FromXML(bytes.NewReader(data)); err != nil {
			slog.Error("xml", "error", err.Error(), "name", file)
			os.Exit(1)
		}

		entry := fpk.Entry{
			FilePath: fpk.String{
				Data: strings.TrimSuffix(foxFile, ".xml"),
			},
		}

		d := []byte{}
		buf := util.NewByteArrayReaderWriter(d)
		if err = fox.Write(buf); err != nil {
			slog.Error("write", "error", err.Error(), "name", file)
			os.Exit(1)
		}
		entry.Data = buf.Bytes()

		f.Entries = append(f.Entries, entry)

		name := "./moddata/tl/dynamite_" + langID + ".fpkd"
		outfile, err := os.OpenFile(name, os.O_CREATE|os.O_TRUNC|os.O_RDWR, 0644)
		if err != nil {
			slog.Error("open", "error", err.Error(), "name", name)
			os.Exit(1)
		}

		if err = f.Write(outfile, "", false); err != nil {
			slog.Error("write", "error", err.Error())
			os.Exit(1)
		}

		f.Close()

		slog.Info("generated", "name", name)
	}
}

func Fpk() {
	f := fpk.Fpk{}
	f.SetType(false)
	for _, langID := range langs {
		file := "moddata/tl/dynamite_" + langID + "_fpk" + lngFile + langID + ".lng2.json"
		data, err := os.ReadFile(file)
		if err != nil {
			slog.Error("cannot read", "name", file, "error", err.Error())
			os.Exit(1)
		}

		l := lng.Lng{}
		if err = l.UnmarshalJSON(data); err != nil {
			slog.Error("json", "error", err.Error(), "name", file)
			os.Exit(1)
		}

		entry := fpk.Entry{
			FilePath: fpk.String{
				Data: lngFile + langID + ".lng2",
			},
		}

		d := []byte{}
		buf := util.NewByteArrayReaderWriter(d)
		if err = l.Write(buf); err != nil {
			slog.Error("write", "error", err.Error(), "name", file)
			os.Exit(1)
		}
		entry.Data = buf.Bytes()

		f.Entries = append(f.Entries, entry)

		name := "./moddata/tl/dynamite_" + langID + ".fpk"
		outfile, err := os.OpenFile(name, os.O_CREATE|os.O_TRUNC|os.O_RDWR, 0644)
		if err != nil {
			slog.Error("open", "error", err.Error(), "name", name)
			os.Exit(1)
		}

		if err = f.Write(outfile, "", false); err != nil {
			slog.Error("write", "error", err.Error())
			os.Exit(1)
		}

		f.Close()

		slog.Info("generated", "name", name)

	}
}

func Lng() {
	for _, langID := range langs {
		file := "moddata/tl/dynamite_" + langID + "_fpk" + lngFile + langID + ".lng2.json"
		data, err := os.ReadFile(file)
		if err != nil {
			slog.Error("cannot read", "name", file, "error", err.Error())
			os.Exit(1)
		}

		l := lng.Lng{}
		if err = l.UnmarshalJSON(data); err != nil {
			slog.Error("json", "error", err.Error(), "name", file)
			os.Exit(1)
		}

		entry := fpk.Entry{
			FilePath: fpk.String{
				Data: lngFile + langID + ".lng2",
			},
		}

		d := []byte{}
		buf := util.NewByteArrayReaderWriter(d)
		if err = l.Write(buf); err != nil {
			slog.Error("write", "error", err.Error(), "name", file)
			os.Exit(1)
		}
		entry.Data = buf.Bytes()

		outFileName := strings.TrimSuffix(file, ".json")
		if err = os.WriteFile(outFileName, buf.Bytes(), 0644); err != nil {
			slog.Error("write", "error", err.Error(), "name", file)
			os.Exit(1)
		}

		slog.Info("generated", "name", outFileName)
	}
}

func Tl() {
	Fpk()
	Fpkd()
}

func main() {
	Lng()
}
