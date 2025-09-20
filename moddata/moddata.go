package moddata

import (
	"embed"
	"fmt"
	"path/filepath"

	"github.com/unknown321/datfpk/qar"
)

//go:embed coop_essentials/coop_essentials.fpkd
//go:embed init_fpkd/*
//go:embed s*_area_fpkd/*
//go:embed standalone/*
//go:embed o50050_area_fpkd/*
//go:embed o50050_additional_fpkd/*
var ModData embed.FS

type FileFromQar struct {
	SourceQar string
	NameInQar string
}

func (f *FileFromQar) Unpack(qars map[string]*qar.Qar) ([]byte, error) {
	_, ok := qars[f.SourceQar]
	if !ok {
		return nil, fmt.Errorf("file not in map: %s", f.SourceQar)
	}

	data, err := qars[f.SourceQar].ReadFile(f.NameInQar)
	if err != nil {
		return nil, fmt.Errorf("qar: %s, filename: %s, error: %w", f.SourceQar, f.NameInQar, err)
	}

	return data, nil
}

type UpdateInFpk struct {
	Source         FileFromQar
	SourceFile     string
	FileName       string
	FileNameAsHash string
	Compressed     bool
	Delete         []string
}

type FpkFromSource struct {
	Files []FileFromQar
}

type AddToQar struct {
	SourceFile string
	FileName   string
}

//go:embed outsidescripts/*
var OutsideScripts embed.FS

var ReplaceInFPK = []UpdateInFpk{
	{
		// skip logos, skip "this game uses autosave" prompt
		Source: FileFromQar{
			SourceQar: filepath.Join("master", "0", "00.dat.vendor"),
			NameInQar: "/Assets/tpp/pack/mission2/init/init.fpkd",
		},
		SourceFile: "init_fpkd/Assets/tpp/level/mission2/init/init_sequence.lua",
		FileName:   "/Assets/tpp/level/mission2/init/init_sequence.lua",
	},
	{
		// mission 1, PHANTOM LIMBS, area 02
		Source: FileFromQar{
			SourceQar: filepath.Join("master", "chunk2.dat"),
			NameInQar: "/Assets/tpp/pack/mission2/story/s10020/s10020_area02.fpkd",
		},
		SourceFile: "s10020_area_fpkd/Assets/tpp/level/mission2/story/s10020/s10020_sequence.lua",
		FileName:   "/Assets/tpp/level/mission2/story/s10020/s10020_sequence.lua",
		Compressed: true,
		Delete: []string{
			"/Assets/tpp/level_asset/chara/player/game_object/single_pl2_instance_scarf.fox2",
		},
	},
	{
		// mission 1, PHANTOM LIMBS
		Source: FileFromQar{
			SourceQar: filepath.Join("master", "chunk2.dat"),
			NameInQar: "/Assets/tpp/pack/mission2/story/s10020/s10020_area.fpkd",
		},
		SourceFile: "s10020_area_fpkd/Assets/tpp/level/mission2/story/s10020/s10020_sequence.lua",
		FileName:   "/Assets/tpp/level/mission2/story/s10020/s10020_sequence.lua",
		Compressed: true,
		Delete: []string{
			"/Assets/tpp/level_asset/chara/player/game_object/single_pl2_instance_scarf.fox2",
		},
	},
	{
		// mission 3, A HERO'S WAY
		Source: FileFromQar{
			SourceQar: filepath.Join("master", "0", "00.dat.vendor"),
			NameInQar: "/Assets/tpp/pack/mission2/story/s10036/s10036_area.fpkd",
		},
		SourceFile: "s10036_area_fpkd/Assets/tpp/level/mission2/story/s10036/s10036_sequence.lua",
		FileName:   "/Assets/tpp/level/mission2/story/s10036/s10036_sequence.lua",
		Compressed: true,
		Delete: []string{
			"/Assets/tpp/level_asset/chara/player/game_object/single_pl2_instance_scarf.fox2",
		},
	},
	{
		// mission 4, C2W
		Source: FileFromQar{
			SourceQar: filepath.Join("master", "chunk2.dat"),
			NameInQar: "/Assets/tpp/pack/mission2/story/s10043/s10043_area.fpkd",
		},
		SourceFile: "s10043_area_fpkd/Assets/tpp/level/mission2/story/s10043/s10043_sequence.lua",
		FileName:   "/Assets/tpp/level/mission2/story/s10043/s10043_sequence.lua",
		Compressed: true,
		Delete: []string{
			"/Assets/tpp/level_asset/chara/player/game_object/single_pl2_instance_scarf.fox2",
		},
	},
	{
		// mission 5, OVER THE FENCE
		Source: FileFromQar{
			SourceQar: filepath.Join("master", "chunk2.dat"),
			NameInQar: "/Assets/tpp/pack/mission2/story/s10033/s10033_area.fpkd",
		},
		SourceFile: "s10033_area_fpkd/Assets/tpp/level/mission2/story/s10033/s10033_sequence.lua",
		FileName:   "/Assets/tpp/level/mission2/story/s10033/s10033_sequence.lua",
		Compressed: true,
		Delete: []string{
			"/Assets/tpp/level_asset/chara/player/game_object/single_pl2_instance_scarf.fox2",
		},
	},
	{
		// mission 6, WHERE DO THE BEES SLEEP
		Source: FileFromQar{
			SourceQar: filepath.Join("master", "chunk2.dat"),
			NameInQar: "/Assets/tpp/pack/mission2/story/s10040/s10040_area.fpkd",
		},
		SourceFile: "s10040_area_fpkd/Assets/tpp/level/mission2/story/s10040/s10040_sequence.lua",
		FileName:   "/Assets/tpp/level/mission2/story/s10040/s10040_sequence.lua",
		Compressed: true,
		Delete: []string{
			"/Assets/tpp/level_asset/chara/player/game_object/single_player2_instance.fox2",
		},
	},
	{
		// mission 7, RED BRASS
		Source: FileFromQar{
			SourceQar: filepath.Join("master", "chunk2.dat"),
			NameInQar: "/Assets/tpp/pack/mission2/story/s10041/s10041_area.fpkd",
		},
		SourceFile: "s10041_area_fpkd/Assets/tpp/level/mission2/story/s10041/s10041_sequence.lua",
		FileName:   "/Assets/tpp/level/mission2/story/s10041/s10041_sequence.lua",
		Compressed: true,
		Delete: []string{
			"/Assets/tpp/level_asset/chara/player/game_object/single_player2_instance.fox2",
		},
	},
	{
		// mission 8, OCCUPATION FORCES
		Source: FileFromQar{
			SourceQar: filepath.Join("master", "chunk2.dat"),
			NameInQar: "/Assets/tpp/pack/mission2/story/s10044/s10044_area.fpkd",
		},
		SourceFile: "s10044_area_fpkd/Assets/tpp/level/mission2/story/s10044/s10044_sequence.lua",
		FileName:   "/Assets/tpp/level/mission2/story/s10044/s10044_sequence.lua",
		Compressed: true,
		Delete: []string{
			"/Assets/tpp/level_asset/chara/player/game_object/single_pl2_instance_scarf.fox2",
		},
	},
	{
		// mission 9, BACKUP, BACK DOWN
		Source: FileFromQar{
			SourceQar: filepath.Join("master", "0", "00.dat.vendor"),
			NameInQar: "/Assets/tpp/pack/mission2/story/s10054/s10054_area.fpkd",
		},
		SourceFile: "s10054_area_fpkd/Assets/tpp/level/mission2/story/s10054/s10054_sequence.lua",
		FileName:   "/Assets/tpp/level/mission2/story/s10054/s10054_sequence.lua",
		Compressed: true,
		Delete: []string{
			"/Assets/tpp/level_asset/chara/player/game_object/single_player2_instance.fox2",
		},
	},
	{
		// mission 10, ANGEL WITH BROKEN WINGS
		Source: FileFromQar{
			SourceQar: filepath.Join("master", "chunk2.dat"),
			NameInQar: "/Assets/tpp/pack/mission2/story/s10052/s10052_area.fpkd",
		},
		SourceFile: "s10052_area_fpkd/Assets/tpp/level/mission2/story/s10052/s10052_sequence.lua",
		FileName:   "/Assets/tpp/level/mission2/story/s10052/s10052_sequence.lua",
		Compressed: true,
		Delete: []string{
			"/Assets/tpp/level_asset/chara/player/game_object/single_player2_instance.fox2",
		},
	},
	{
		// mission 11, CLOAKED IN SILENCE
		Source: FileFromQar{
			SourceQar: filepath.Join("master", "0", "00.dat.vendor"),
			NameInQar: "/Assets/tpp/pack/mission2/story/s10050/s10050_area.fpkd",
		},
		SourceFile: "s10050_area_fpkd/Assets/tpp/level/mission2/story/s10050/s10050_sequence.lua",
		FileName:   "/Assets/tpp/level/mission2/story/s10050/s10050_sequence.lua",
		Compressed: true,
		Delete: []string{
			"/Assets/tpp/level_asset/chara/player/game_object/single_pl2_instance_scarf.fox2",
		},
	},
	{
		// mission 11, CLOAKED IN SILENCE area01
		// same lua
		Source: FileFromQar{
			SourceQar: filepath.Join("master", "0", "00.dat.vendor"),
			NameInQar: "/Assets/tpp/pack/mission2/story/s10050/s10050_area01.fpkd",
		},
		SourceFile: "s10050_area_fpkd/Assets/tpp/level/mission2/story/s10050/s10050_sequence.lua",
		FileName:   "/Assets/tpp/level/mission2/story/s10050/s10050_sequence.lua",
		Compressed: true,
		Delete: []string{
			"/Assets/tpp/level_asset/chara/player/game_object/single_pl2_instance_scarf.fox2",
		},
	},
	{
		// mission 12, HELLBOUND area01
		// same lua
		Source: FileFromQar{
			SourceQar: filepath.Join("master", "chunk2.dat"),
			NameInQar: "/Assets/tpp/pack/mission2/story/s10070/s10070_area01.fpkd",
		},
		SourceFile: "s10070_area_fpkd/Assets/tpp/level/mission2/story/s10070/s10070_sequence.lua",
		FileName:   "/Assets/tpp/level/mission2/story/s10070/s10070_sequence.lua",
		Compressed: true,
		Delete: []string{
			"/Assets/tpp/level_asset/chara/player/game_object/single_pl2_instance_scarf.fox2",
		},
	},
	{
		// mission 12, HELLBOUND area02
		// same lua
		Source: FileFromQar{
			SourceQar: filepath.Join("master", "chunk2.dat"),
			NameInQar: "/Assets/tpp/pack/mission2/story/s10070/s10070_area02.fpkd",
		},
		SourceFile: "s10070_area_fpkd/Assets/tpp/level/mission2/story/s10070/s10070_sequence.lua",
		FileName:   "/Assets/tpp/level/mission2/story/s10070/s10070_sequence.lua",
		Compressed: true,
		Delete: []string{
			"/Assets/tpp/level_asset/chara/player/game_object/single_pl2_instance_scarf.fox2",
		},
	},
	{
		// mission 12, HELLBOUND area03
		// same lua
		Source: FileFromQar{
			SourceQar: filepath.Join("master", "chunk2.dat"),
			NameInQar: "/Assets/tpp/pack/mission2/story/s10070/s10070_area03.fpkd",
		},
		SourceFile: "s10070_area_fpkd/Assets/tpp/level/mission2/story/s10070/s10070_sequence.lua",
		FileName:   "/Assets/tpp/level/mission2/story/s10070/s10070_sequence.lua",
		Compressed: true,
		Delete: []string{
			"/Assets/tpp/level_asset/chara/player/game_object/single_pl2_instance_scarf.fox2",
		},
	},
	{
		// mission 12, HELLBOUND area04
		// same lua
		Source: FileFromQar{
			SourceQar: filepath.Join("master", "chunk2.dat"),
			NameInQar: "/Assets/tpp/pack/mission2/story/s10070/s10070_area04.fpkd",
		},
		SourceFile: "s10070_area_fpkd/Assets/tpp/level/mission2/story/s10070/s10070_sequence.lua",
		FileName:   "/Assets/tpp/level/mission2/story/s10070/s10070_sequence.lua",
		Compressed: true,
		Delete: []string{
			"/Assets/tpp/level_asset/chara/player/game_object/single_pl2_instance_scarf.fox2",
		},
	},
	{
		// mission 13, PITCH DARK
		// same lua
		Source: FileFromQar{
			SourceQar: filepath.Join("master", "chunk4.dat"),
			NameInQar: "/Assets/tpp/pack/mission2/story/s10080/s10080_area.fpkd",
		},
		SourceFile: "s10080_area_fpkd/Assets/tpp/level/mission2/story/s10080/s10080_sequence.lua",
		FileName:   "/Assets/tpp/level/mission2/story/s10080/s10080_sequence.lua",
		Compressed: true,
		Delete: []string{
			"/Assets/tpp/level_asset/chara/player/game_object/single_player2_instance.fox2",
		},
	},
	{
		// mission 13, PITCH DARK area01
		// same lua
		Source: FileFromQar{
			SourceQar: filepath.Join("master", "chunk4.dat"),
			NameInQar: "/Assets/tpp/pack/mission2/story/s10080/s10080_area01.fpkd",
		},
		SourceFile: "s10080_area_fpkd/Assets/tpp/level/mission2/story/s10080/s10080_sequence.lua",
		FileName:   "/Assets/tpp/level/mission2/story/s10080/s10080_sequence.lua",
		Compressed: true,
		Delete: []string{
			"/Assets/tpp/level_asset/chara/player/game_object/single_player2_instance.fox2",
		},
	},
	{
		// mission 13, PITCH DARK area02
		// same lua
		Source: FileFromQar{
			SourceQar: filepath.Join("master", "chunk4.dat"),
			NameInQar: "/Assets/tpp/pack/mission2/story/s10080/s10080_area02.fpkd",
		},
		SourceFile: "s10080_area_fpkd/Assets/tpp/level/mission2/story/s10080/s10080_sequence.lua",
		FileName:   "/Assets/tpp/level/mission2/story/s10080/s10080_sequence.lua",
		Compressed: true,
		Delete: []string{
			"/Assets/tpp/level_asset/chara/player/game_object/single_player2_instance.fox2",
		},
	},
	{
		// mission 14, LINGUA FRANCA
		Source: FileFromQar{
			SourceQar: filepath.Join("master", "0", "00.dat.vendor"),
			NameInQar: "/Assets/tpp/pack/mission2/story/s10086/s10086_area.fpkd",
		},
		SourceFile: "s10086_area_fpkd/Assets/tpp/level/mission2/story/s10086/s10086_sequence.lua",
		FileName:   "/Assets/tpp/level/mission2/story/s10086/s10086_sequence.lua",
		Compressed: true,
		Delete: []string{
			"/Assets/tpp/level_asset/chara/player/game_object/single_player2_instance.fox2",
		},
	},
	{
		// mission 15, FOOTPRINTS OF PHANTOMS
		Source: FileFromQar{
			SourceQar: filepath.Join("master", "chunk4.dat"),
			NameInQar: "/Assets/tpp/pack/mission2/story/s10082/s10082_area.fpkd",
		},
		SourceFile: "s10082_area_fpkd/Assets/tpp/level/mission2/story/s10082/s10082_sequence.lua",
		FileName:   "/Assets/tpp/level/mission2/story/s10082/s10082_sequence.lua",
		Compressed: true,
		Delete: []string{
			"/Assets/tpp/level_asset/chara/player/game_object/single_player2_instance.fox2",
		},
	},
	{
		// mission 16, TRAITORS’ CARAVAN
		Source: FileFromQar{
			SourceQar: filepath.Join("master", "chunk4.dat"),
			NameInQar: "/Assets/tpp/pack/mission2/story/s10090/s10090_area.fpkd",
		},
		SourceFile: "s10090_area_fpkd/Assets/tpp/level/mission2/story/s10090/s10090_sequence.lua",
		FileName:   "/Assets/tpp/level/mission2/story/s10090/s10090_sequence.lua",
		Compressed: true,
		Delete: []string{
			"/Assets/tpp/level_asset/chara/player/game_object/single_player2_instance.fox2",
		},
	},
	{
		// mission 17, RESCUE THE INTEL AGENTS
		Source: FileFromQar{
			SourceQar: filepath.Join("master", "chunk4.dat"),
			NameInQar: "/Assets/tpp/pack/mission2/story/s10091/s10091_area.fpkd",
		},
		SourceFile: "s10091_area_fpkd/Assets/tpp/level/mission2/story/s10091/s10091_sequence.lua",
		FileName:   "/Assets/tpp/level/mission2/story/s10091/s10091_sequence.lua",
		Compressed: true,
		Delete: []string{
			"/Assets/tpp/level_asset/chara/player/game_object/single_player2_instance.fox2",
		},
	},
	{
		// mission 18, BLOOD RUNS DEEP
		Source: FileFromQar{
			SourceQar: filepath.Join("master", "chunk4.dat"),
			NameInQar: "/Assets/tpp/pack/mission2/story/s10100/s10100_area.fpkd",
		},
		SourceFile: "s10100_area_fpkd/Assets/tpp/level/mission2/story/s10100/s10100_sequence.lua",
		FileName:   "/Assets/tpp/level/mission2/story/s10100/s10100_sequence.lua",
		Compressed: true,
		Delete: []string{
			"/Assets/tpp/level_asset/chara/player/game_object/single_player2_instance.fox2",
		},
	},
	{
		// mission 18, BLOOD RUNS DEEP, area02
		// same lua
		Source: FileFromQar{
			SourceQar: filepath.Join("master", "chunk4.dat"),
			NameInQar: "/Assets/tpp/pack/mission2/story/s10100/s10100_area02.fpkd",
		},
		SourceFile: "s10100_area_fpkd/Assets/tpp/level/mission2/story/s10100/s10100_sequence.lua",
		FileName:   "/Assets/tpp/level/mission2/story/s10100/s10100_sequence.lua",
		Compressed: true,
		Delete: []string{
			"/Assets/tpp/level_asset/chara/player/game_object/single_player2_instance.fox2",
		},
	},
	{
		// mission 19, ON THE TRAIL
		Source: FileFromQar{
			SourceQar: filepath.Join("master", "chunk4.dat"),
			NameInQar: "/Assets/tpp/pack/mission2/story/s10195/s10195_area.fpkd",
		},
		SourceFile: "s10195_area_fpkd/Assets/tpp/level/mission2/story/s10195/s10195_sequence.lua",
		FileName:   "/Assets/tpp/level/mission2/story/s10195/s10195_sequence.lua",
		Compressed: true,
		Delete: []string{
			"/Assets/tpp/level_asset/chara/player/game_object/single_player2_instance.fox2",
		},
	},
	{
		// mission 20, VOICES
		Source: FileFromQar{
			SourceQar: filepath.Join("master", "chunk4.dat"),
			NameInQar: "/Assets/tpp/pack/mission2/story/s10110/s10110_area.fpkd",
		},
		SourceFile: "s10110_area_fpkd/Assets/tpp/level/mission2/story/s10110/s10110_sequence.lua",
		FileName:   "/Assets/tpp/level/mission2/story/s10110/s10110_sequence.lua",
		Compressed: true,
		Delete: []string{
			"/Assets/tpp/level_asset/chara/player/game_object/single_player2_instance.fox2",
		},
	},
	{
		// mission 20, VOICES, area02
		Source: FileFromQar{
			SourceQar: filepath.Join("master", "chunk4.dat"),
			NameInQar: "/Assets/tpp/pack/mission2/story/s10110/s10110_area02.fpkd",
		},
		SourceFile: "s10110_area_fpkd/Assets/tpp/level/mission2/story/s10110/s10110_sequence.lua",
		FileName:   "/Assets/tpp/level/mission2/story/s10110/s10110_sequence.lua",
		Compressed: true,
		Delete: []string{
			"/Assets/tpp/level_asset/chara/player/game_object/single_player2_instance.fox2",
		},
	},
	{
		// mission 21, THE WAR ECONOMY
		Source: FileFromQar{
			SourceQar: filepath.Join("master", "chunk4.dat"),
			NameInQar: "/Assets/tpp/pack/mission2/story/s10121/s10121_area.fpkd",
		},
		SourceFile: "s10121_area_fpkd/Assets/tpp/level/mission2/story/s10121/s10121_sequence.lua",
		FileName:   "/Assets/tpp/level/mission2/story/s10121/s10121_sequence.lua",
		Compressed: true,
		Delete: []string{
			"/Assets/tpp/level_asset/chara/player/game_object/single_player2_instance.fox2",
		},
	},
	{
		// mission 23, WHITE MAMBA
		Source: FileFromQar{
			SourceQar: filepath.Join("master", "chunk4.dat"),
			NameInQar: "/Assets/tpp/pack/mission2/story/s10120/s10120_area.fpkd",
		},
		SourceFile: "s10120_area_fpkd/Assets/tpp/level/mission2/story/s10120/s10120_sequence.lua",
		FileName:   "/Assets/tpp/level/mission2/story/s10120/s10120_sequence.lua",
		Compressed: true,
		Delete: []string{
			"/Assets/tpp/level_asset/chara/player/game_object/single_player2_instance.fox2",
		},
	},
	{
		// mission 24, CLOSE CONTACT
		Source: FileFromQar{
			SourceQar: filepath.Join("master", "chunk4.dat"),
			NameInQar: "/Assets/tpp/pack/mission2/story/s10085/s10085_area.fpkd",
		},
		SourceFile: "s10085_area_fpkd/Assets/tpp/level/mission2/story/s10085/s10085_sequence.lua",
		FileName:   "/Assets/tpp/level/mission2/story/s10085/s10085_sequence.lua",
		Compressed: true,
		Delete: []string{
			"/Assets/tpp/level_asset/chara/player/game_object/single_player2_instance.fox2",
		},
	},
	{
		// mission 25, AIM TRUE, YE VENGEFUL
		Source: FileFromQar{
			SourceQar: filepath.Join("master", "chunk4.dat"),
			NameInQar: "/Assets/tpp/pack/mission2/story/s10200/s10200_area.fpkd",
		},
		SourceFile: "s10200_area_fpkd/Assets/tpp/level/mission2/story/s10200/s10200_sequence.lua",
		FileName:   "/Assets/tpp/level/mission2/story/s10200/s10200_sequence.lua",
		Compressed: true,
		Delete: []string{
			"/Assets/tpp/level_asset/chara/player/game_object/single_player2_instance.fox2",
		},
	},
	{
		// mission 26, HUNTING DOWN
		Source: FileFromQar{
			SourceQar: filepath.Join("master", "0", "00.dat.vendor"),
			NameInQar: "/Assets/tpp/pack/mission2/story/s10211/s10211_area.fpkd",
		},
		SourceFile: "s10211_area_fpkd/Assets/tpp/level/mission2/story/s10211/s10211_sequence.lua",
		FileName:   "/Assets/tpp/level/mission2/story/s10211/s10211_sequence.lua",
		Compressed: true,
		Delete: []string{
			"/Assets/tpp/level_asset/chara/player/game_object/single_player2_instance.fox2",
		},
	},
	{
		// mission 27, ROOT CAUSE
		Source: FileFromQar{
			SourceQar: filepath.Join("master", "chunk4.dat"),
			NameInQar: "/Assets/tpp/pack/mission2/story/s10081/s10081_area.fpkd",
		},
		SourceFile: "s10081_area_fpkd/Assets/tpp/level/mission2/story/s10081/s10081_sequence.lua",
		FileName:   "/Assets/tpp/level/mission2/story/s10081/s10081_sequence.lua",
		Compressed: true,
		Delete: []string{
			"/Assets/tpp/level_asset/chara/player/game_object/single_player2_instance.fox2",
		},
	},
	{
		// mission 28, CODE TALKER
		Source: FileFromQar{
			SourceQar: filepath.Join("master", "chunk4.dat"),
			NameInQar: "/Assets/tpp/pack/mission2/story/s10130/s10130_area.fpkd",
		},
		SourceFile: "s10130_area_fpkd/Assets/tpp/level/mission2/story/s10130/s10130_sequence.lua",
		FileName:   "/Assets/tpp/level/mission2/story/s10130/s10130_sequence.lua",
		Compressed: true,
		Delete: []string{
			"/Assets/tpp/level_asset/chara/player/game_object/single_player2_instance.fox2",
		},
	},
	{
		// mission 28, CODE TALKER, area02
		// same lua
		Source: FileFromQar{
			SourceQar: filepath.Join("master", "chunk4.dat"),
			NameInQar: "/Assets/tpp/pack/mission2/story/s10130/s10130_area02.fpkd",
		},
		SourceFile: "s10130_area_fpkd/Assets/tpp/level/mission2/story/s10130/s10130_sequence.lua",
		FileName:   "/Assets/tpp/level/mission2/story/s10130/s10130_sequence.lua",
		Compressed: true,
		Delete: []string{
			"/Assets/tpp/level_asset/chara/player/game_object/single_player2_instance.fox2",
		},
	},
	{
		// mission 28, CODE TALKER, area03
		// same lua
		Source: FileFromQar{
			SourceQar: filepath.Join("master", "chunk4.dat"),
			NameInQar: "/Assets/tpp/pack/mission2/story/s10130/s10130_area03.fpkd",
		},
		SourceFile: "s10130_area_fpkd/Assets/tpp/level/mission2/story/s10130/s10130_sequence.lua",
		FileName:   "/Assets/tpp/level/mission2/story/s10130/s10130_sequence.lua",
		Compressed: true,
		Delete: []string{
			"/Assets/tpp/level_asset/chara/player/game_object/single_player2_instance.fox2",
		},
	},
	{
		// mission 29, METALLIC ARCHAEA
		// same lua
		Source: FileFromQar{
			SourceQar: filepath.Join("master", "0", "00.dat.vendor"),
			NameInQar: "/Assets/tpp/pack/mission2/story/s10140/s10140_area.fpkd",
		},
		SourceFile: "s10140_area_fpkd/Assets/tpp/level/mission2/story/s10140/s10140_sequence.lua",
		FileName:   "/Assets/tpp/level/mission2/story/s10140/s10140_sequence.lua",
		Compressed: true,
		Delete: []string{
			"/Assets/tpp/level_asset/chara/player/game_object/single_player2_instance.fox2",
		},
	},
	{
		// mission 29, METALLIC ARCHAEA, area00
		// same lua
		Source: FileFromQar{
			SourceQar: filepath.Join("master", "0", "00.dat.vendor"),
			NameInQar: "/Assets/tpp/pack/mission2/story/s10140/s10140_area00.fpkd",
		},
		SourceFile: "s10140_area_fpkd/Assets/tpp/level/mission2/story/s10140/s10140_sequence.lua",
		FileName:   "/Assets/tpp/level/mission2/story/s10140/s10140_sequence.lua",
		Compressed: true,
		Delete: []string{
			"/Assets/tpp/level_asset/chara/player/game_object/single_player2_instance.fox2",
		},
	},
	{
		// mission 29, METALLIC ARCHAEA, area01
		// same lua
		Source: FileFromQar{
			SourceQar: filepath.Join("master", "0", "00.dat.vendor"),
			NameInQar: "/Assets/tpp/pack/mission2/story/s10140/s10140_area01.fpkd",
		},
		SourceFile: "s10140_area_fpkd/Assets/tpp/level/mission2/story/s10140/s10140_sequence.lua",
		FileName:   "/Assets/tpp/level/mission2/story/s10140/s10140_sequence.lua",
		Compressed: true,
		Delete: []string{
			"/Assets/tpp/level_asset/chara/player/game_object/single_player2_instance.fox2",
		},
	},
	{
		// mission 30, SCULL FACE, area01
		// same lua
		Source: FileFromQar{
			SourceQar: filepath.Join("master", "chunk2.dat"),
			NameInQar: "/Assets/tpp/pack/mission2/story/s10150/s10150_area01.fpkd",
		},
		SourceFile: "s10150_area_fpkd/Assets/tpp/level/mission2/story/s10150/s10150_sequence.lua",
		FileName:   "/Assets/tpp/level/mission2/story/s10150/s10150_sequence.lua",
		Compressed: true,
		Delete: []string{
			"/Assets/tpp/level_asset/chara/player/game_object/single_pl2_instance_scarf.fox2",
		},
	},
	{
		// mission 30, SCULL FACE, area02
		// same lua
		Source: FileFromQar{
			SourceQar: filepath.Join("master", "chunk2.dat"),
			NameInQar: "/Assets/tpp/pack/mission2/story/s10150/s10150_area02.fpkd",
		},
		SourceFile: "s10150_area_fpkd/Assets/tpp/level/mission2/story/s10150/s10150_sequence.lua",
		FileName:   "/Assets/tpp/level/mission2/story/s10150/s10150_sequence.lua",
		Compressed: true,
		Delete: []string{
			"/Assets/tpp/level_asset/chara/player/game_object/single_pl2_instance_scarf.fox2",
		},
	},
	{
		// mission 30, SKULL FACE, area03
		// same lua
		Source: FileFromQar{
			SourceQar: filepath.Join("master", "chunk2.dat"),
			NameInQar: "/Assets/tpp/pack/mission2/story/s10150/s10150_area03.fpkd",
		},
		SourceFile: "s10150_area_fpkd/Assets/tpp/level/mission2/story/s10150/s10150_sequence.lua",
		FileName:   "/Assets/tpp/level/mission2/story/s10150/s10150_sequence.lua",
		Compressed: true,
		Delete: []string{
			"/Assets/tpp/level_asset/chara/player/game_object/single_pl2_instance_scarf.fox2",
		},
	},
	{
		// mission 31, SAHELANTHROPUS, area01
		// same lua
		Source: FileFromQar{
			SourceQar: filepath.Join("master", "0", "00.dat.vendor"),
			NameInQar: "/Assets/tpp/pack/mission2/story/s10151/s10151_area01.fpkd",
		},
		SourceFile: "s10151_area_fpkd/Assets/tpp/level/mission2/story/s10151/s10151_sequence.lua",
		FileName:   "/Assets/tpp/level/mission2/story/s10151/s10151_sequence.lua",
		Compressed: true,
		Delete: []string{
			"/Assets/tpp/level_asset/chara/player/game_object/single_pl2_instance_scarf.fox2",
		},
	},
	{
		// mission 31, SAHELANTHROPUS, area02
		// same lua
		Source: FileFromQar{
			SourceQar: filepath.Join("master", "0", "00.dat.vendor"),
			NameInQar: "/Assets/tpp/pack/mission2/story/s10151/s10151_area02.fpkd",
		},
		SourceFile: "s10151_area_fpkd/Assets/tpp/level/mission2/story/s10151/s10151_sequence.lua",
		FileName:   "/Assets/tpp/level/mission2/story/s10151/s10151_sequence.lua",
		Compressed: true,
		Delete: []string{
			"/Assets/tpp/level_asset/chara/player/game_object/single_pl2_instance_scarf.fox2",
		},
	},
	{
		// mission 32, TO KNOW TOO MUCH
		Source: FileFromQar{
			SourceQar: filepath.Join("master", "chunk2.dat"),
			NameInQar: "/Assets/tpp/pack/mission2/story/s10045/s10045_area.fpkd",
		},
		SourceFile: "s10045_area_fpkd/Assets/tpp/level/mission2/story/s10045/s10045_sequence.lua",
		FileName:   "/Assets/tpp/level/mission2/story/s10045/s10045_sequence.lua",
		Compressed: true,
		Delete: []string{
			"/Assets/tpp/level_asset/chara/player/game_object/single_pl2_instance_scarf.fox2",
		},
	},
	{
		// mission 35, CURSED LEGACY
		Source: FileFromQar{
			SourceQar: filepath.Join("master", "chunk4.dat"),
			NameInQar: "/Assets/tpp/pack/mission2/story/s10093/s10093_area.fpkd",
		},
		SourceFile: "s10093_area_fpkd/Assets/tpp/level/mission2/story/s10093/s10093_sequence.lua",
		FileName:   "/Assets/tpp/level/mission2/story/s10093/s10093_sequence.lua",
		Compressed: true,
		Delete: []string{
			"/Assets/tpp/level_asset/chara/player/game_object/single_player2_instance.fox2",
		},
	},
	{
		// mission 38, EXTRAORDINARY
		Source: FileFromQar{
			SourceQar: filepath.Join("master", "chunk2.dat"),
			NameInQar: "/Assets/tpp/pack/mission2/story/s10156/s10156_area.fpkd",
		},
		SourceFile: "s10156_area_fpkd/Assets/tpp/level/mission2/story/s10156/s10156_sequence.lua",
		FileName:   "/Assets/tpp/level/mission2/story/s10156/s10156_sequence.lua",
		Compressed: true,
		Delete: []string{
			"/Assets/tpp/level_asset/chara/player/game_object/single_player2_instance.fox2",
		},
	},
	{
		// mission 41, PROXY WAR WITHOUT END
		Source: FileFromQar{
			SourceQar: filepath.Join("master", "chunk4.dat"),
			NameInQar: "/Assets/tpp/pack/mission2/story/s10171/s10171_area.fpkd",
		},
		SourceFile: "s10171_area_fpkd/Assets/tpp/level/mission2/story/s10171/s10171_sequence.lua",
		FileName:   "/Assets/tpp/level/mission2/story/s10171/s10171_sequence.lua",
		Compressed: true,
		Delete: []string{
			"/Assets/tpp/level_asset/chara/player/game_object/single_player2_instance.fox2",
		},
	},
	{
		// mission 43, SHINING LIGHTS, EVEN IN DEATH
		Source: FileFromQar{
			SourceQar: filepath.Join("master", "chunk3.dat"),
			NameInQar: "/Assets/tpp/pack/mission2/story/s10240/s10240_area.fpkd",
		},
		SourceFile: "s10240_area_fpkd/Assets/tpp/level/mission2/story/s10240/s10240_sequence.lua",
		FileName:   "/Assets/tpp/level/mission2/story/s10240/s10240_sequence.lua",
		Compressed: true,
		Delete: []string{
			"/Assets/tpp/level_asset/chara/player/game_object/single_pl2_instance_scarf.fox2",
		},
	},
	{
		// mission 43, SHINING LIGHTS, EVEN IN DEATH, area02
		Source: FileFromQar{
			SourceQar: filepath.Join("master", "chunk3.dat"),
			NameInQar: "/Assets/tpp/pack/mission2/story/s10240/s10240_area02.fpkd",
		},
		SourceFile: "s10240_area_fpkd/Assets/tpp/level/mission2/story/s10240/s10240_sequence.lua",
		FileName:   "/Assets/tpp/level/mission2/story/s10240/s10240_sequence.lua",
		Compressed: true,
		Delete: []string{
			"/Assets/tpp/level_asset/chara/player/game_object/single_pl2_instance_scarf.fox2",
		},
	},
	{
		// mission 45, A QUIET EXIT
		Source: FileFromQar{
			SourceQar: filepath.Join("master", "chunk2.dat"),
			NameInQar: "/Assets/tpp/pack/mission2/story/s10260/s10260_area.fpkd",
		},
		SourceFile: "s10260_area_fpkd/Assets/tpp/level/mission2/story/s10260/s10260_sequence.lua",
		FileName:   "/Assets/tpp/level/mission2/story/s10260/s10260_sequence.lua",
		Compressed: true,
		Delete: []string{
			"/Assets/tpp/level_asset/chara/player/game_object/single_pl2_instance_scarf.fox2",
		},
	},
	/* message logging during fob mission
	{
		Source: FileFromQar{
			SourceQar: filepath.Join("master", "0", "00.dat.vendor"),
			NameInQar: "/Assets/tpp/pack/mission2/online/o50050/o50050_area.fpkd",
		},
		SourceFile: "o50050_area_fpkd/Assets/tpp/script/mission/mission_main.lua",
		FileName:   "/Assets/tpp/script/mission/mission_main.lua",
	},
	*/

	//disable fob timer
	{
		Source: FileFromQar{
			SourceQar: filepath.Join("master", "0", "00.dat.vendor"),
			NameInQar: "/Assets/tpp/pack/mission2/online/o50050/o50050_additional.fpkd",
		},
		Compressed: true,
		SourceFile: "o50050_additional_fpkd/Assets/tpp/level/mission2/online/o50050/o50050_sequence.lua",
		FileName:   "/Assets/tpp/level/mission2/online/o50050/o50050_sequence.lua",
	},
}

var ReplaceInQAR = []AddToQar{
	{
		// 00.dat
		// add script_loader
		SourceFile: "standalone/Tpp.lua",
		FileName:   "/Assets/tpp/script/lib/Tpp.lua",
	},
	{
		// 00.dat
		// set and unset online flag (allocate and terminate respectfully)
		SourceFile: "standalone/TppMain.lua",
		FileName:   "/Assets/tpp/script/lib/TppMain.lua",
	},
	{
		// 00.dat
		// change save file name
		SourceFile: "standalone/TppDefine.lua",
		FileName:   "/Assets/tpp/script/lib/TppDefine.lua",
	},
	{
		// 00.dat
		// unset online flag on mission end
		// disable player death scripts
		SourceFile: "standalone/TppMission.lua",
		FileName:   "/Assets/tpp/script/lib/TppMission.lua",
	},
	{
		// 00.dat
		// setting variables to properly load mission
		SourceFile: "standalone/TppMissionList.lua",
		FileName:   "/Assets/tpp/script/list/TppMissionList.lua",
	},
	{
		// data1.dat
		// revenge mines prevent mission from loading
		SourceFile: "standalone/TppRevenge.lua",
		FileName:   "/Assets/tpp/script/lib/TppRevenge.lua",
	},
	{
		// 00.dat
		// damage params for us and soldiers (incomplete)
		SourceFile: "standalone/DamageParameterTables.lua",
		FileName:   "/Assets/tpp/level_asset/damage/ParameterTables/DamageParameterTables.lua",
	},
	{
		SourceFile: "standalone/script_loader.lua",
		FileName:   "/Assets/tpp/script/lib/script_loader.lua",
	},
	{
		// 00.dat
		// player cbox delivery, animations
		SourceFile: "standalone/TppPlayer.lua",
		FileName:   "/Assets/tpp/script/lib/TppPlayer.lua",
	},
}
