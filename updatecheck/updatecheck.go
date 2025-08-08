package updatecheck

import (
	"dynamite/util"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"time"
)

var u = "https://api.github.com/repos/unknown321/dynamite/tags"

type RespEntry struct {
	Name       string `json:"name"`
	ZipballUrl string `json:"zipball_url"`
	TarballUrl string `json:"tarball_url"`
	Commit     struct {
		Sha string `json:"sha"`
		Url string `json:"url"`
	} `json:"commit"`
	NodeId string `json:"node_id"`
}

func Check() (bool, string, error) {
	v := util.GetVersion()
	if v.Dirty {
		return false, "", fmt.Errorf("this build is dirty")
	}

	c := http.Client{Timeout: time.Second * 5}
	resp, err := c.Get(u)
	if err != nil {
		return false, "", fmt.Errorf("failed to check for updates: %w", err)
	}

	data, err := io.ReadAll(resp.Body)
	if err != nil {
		return false, "", fmt.Errorf("failed to read update data: %w", err)
	}

	tags := []RespEntry{}
	if err = json.Unmarshal(data, &tags); err != nil {
		return false, "", fmt.Errorf("failed to unmarshal update tag list: %w", err)
	}

	if len(tags) == 0 {
		return false, "", fmt.Errorf("no update tags found")
	}

	latest := tags[0].Name
	if v.Tag >= latest {
		return false, "", nil
	}

	return true, tags[0].Name, nil
}
