package main

import (
	"bytes"
	"log/slog"
	"os"
	"strings"

	"github.com/unknown321/datfpk/fox2"
	"github.com/unknown321/datfpk/fpk"
	"github.com/unknown321/datfpk/util"
)

var files = []string{
	"moddata/coop_essentials/coop_essentials_fpkd/Assets/tpp/level_asset/chara/player/game_object/two_player2_instances.fox2.xml",
	"moddata/coop_essentials/coop_essentials_fpkd/Assets/tpp/level_asset/chara/player/game_object/player2_additional_parts_x1.fox2.xml",
	"moddata/coop_essentials/coop_essentials_fpkd/Assets/tpp/level_asset/chara/player/game_object/player2_online_motion.fox2.xml",
	"moddata/coop_essentials/coop_essentials_fpkd/Assets/tpp/level_asset/chara/player/game_object/player2_mtbs_motion_loader.fox2.xml",
}

func main() {
	f := fpk.Fpk{}
	f.SetType(true)
	for _, file := range files {
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
				Data: strings.TrimSuffix(strings.TrimPrefix(file, `moddata/coop_essentials/coop_essentials_fpkd`), ".xml"),
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
	}
	name := "./moddata/coop_essentials/coop_essentials.fpkd"
	outfile, err := os.OpenFile(name, os.O_CREATE|os.O_TRUNC|os.O_RDWR, 0644)
	if err != nil {
		slog.Error("open", "error", err.Error(), "name", name)
		os.Exit(1)
	}

	if err = f.Write(outfile, "", false); err != nil {
		slog.Error("write", "error", err.Error())
		os.Exit(1)
	}

	slog.Info("generated coop_essentials.fpkd")
}
