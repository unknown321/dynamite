package handlers

import "embed"

//go:embed *.tmpl
//go:embed missionlist.md
var FS embed.FS
