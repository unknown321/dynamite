package main

import (
	"bytes"
	"github.com/yuin/goldmark"
	"github.com/yuin/goldmark/extension"
	"github.com/yuin/goldmark/parser"
	"github.com/yuin/goldmark/renderer/html"
	html2 "html"
	"os"
	"strings"
)

func generate() {
	source, err := os.ReadFile("./webui/docs/docs.md")
	if err != nil {
		panic(err)
	}

	md := goldmark.New(
		goldmark.WithExtensions(extension.GFM),
		goldmark.WithParserOptions(
			parser.WithAutoHeadingID(),
		),
		goldmark.WithRendererOptions(
			html.WithXHTML(),
			html.WithUnsafe(),
		),
	)
	var buf bytes.Buffer
	if err = md.Convert(source, &buf); err != nil {
		panic(err)
	}

	data := "{{ template \"header\" . }}\n\n<div class='container'>" + buf.String() + "</div>\n{{ template \"footer\" . }}"
	if err = os.WriteFile("./webui/templates/docs.tmpl", []byte(data), 0644); err != nil {
		panic(err)
	}

	license, err := os.ReadFile("LICENSE")
	if err != nil {
		panic(err)
	}

	s := html2.EscapeString(string(license))
	s = strings.ReplaceAll(s, "\n", "<br>\n")
	s = "{{ template \"header\" . }}\n\n" + s + "\n{{ template \"footer\" . }}"

	err = os.WriteFile("./webui/templates/license.tmpl", []byte(s), 0644)
	if err != nil {
		panic(err)
	}
}

func main() {
	generate()
}
