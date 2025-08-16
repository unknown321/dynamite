Usage
====

dynamite is a 2 player co-op mod for Metal Gear Solid V: The Phantom Pain in early development stage.

<!-- TOC -->
* [Usage](#usage)
* [I WANT TO PLAY NOW HOW DO I PLAY](#i-want-to-play-now-how-do-i-play)
* [I am capable of reading](#i-am-capable-of-reading)
    * [Requirements](#requirements)
    * [Configuration](#configuration)
      * [Co-op](#co-op)
      * [dynamite](#dynamite)
      * [Master server](#master-server)
      * [Key bindings](#key-bindings)
      * [Miscellaneous](#miscellaneous)
    * [Installing](#installing)
    * [Updating](#updating)
    * [Playing](#playing)
      * [Missions that are playable from start to finish with minor bugs (not impacting gameplay in a meaningful way):](#missions-that-are-playable-from-start-to-finish-with-minor-bugs-not-impacting-gameplay-in-a-meaningful-way)
      * [Missions that were recently updated and need testing:](#missions-that-were-recently-updated-and-need-testing)
      * [These missions are broken in one way or another:](#these-missions-are-broken-in-one-way-or-another)
      * [Untested missions:](#untested-missions)
      * [Host](#host)
      * [Client](#client)
    * [Issues](#issues)
      * [Mission not loading](#mission-not-loading)
      * [Providing crash info](#providing-crash-info)
    * [Uninstalling](#uninstalling)
    * [Executing custom lua code (info for modders)](#executing-custom-lua-code-info-for-modders)
    * [Supporting the mod](#supporting-the-mod)
    * [License](#license)
<!-- TOC -->

# I WANT TO PLAY NOW HOW DO I PLAY

Follow this guide: <a href="https://www.youtube.com/watch?v=SvePtu07XVY" target="_blank">link</a>

# I am capable of reading

### Requirements

  - OS:
    - Windows 10 or later
    - Linux kernel 3.2 or later / Steam OS
  - Legitimate and unmodified Steam copy of the game (JP version is not supported)
  - Connection to Steam network
  - At least 1GB free space on system partition and game location drive
  - A friend to play with

It is also heavily recommended to have 100% save to access all working missions.

If you are seeing this text in your browser after launching the mod executable, your OS is supported.

Non-Steam versions are not supported for variety of reasons not mentioned here.

To restore your game files and remove previously installed mods right-click on the game in your Library and 
choose `Properties`; then go to the `Local Files` tab and click on `Verify integrity of game cache…`.

Connection to Steam network is required to create initial connection between host and client. Co-op won't work during 
Steam weekly maintenance period. If there is no connection to Steam, you can check 
<a href="https://steamstat.us/" target="_blank">Unofficial Steam Status website</a>.

---

### Configuration

#### Co-op

Check `Host mode` to host the co-op session. See [Playing](#Playing) section for differences between hosting and 
joining as a client.

Otherwise, paste your host's Steam profile url to `Host Steam ID`. You can get it from Steam client by navigating to 
host's Steam profile, right-clicking the page and selecting `Copy Page URL`.

As a host, add unwanted persons to `Blacklist` or limit your co-op session to a close circle of friends
by adding them to `Whitelist`. If whitelist has entries in it, blacklist is ignored.

---

#### dynamite

Before installation dynamite creates backup of your save files in a zip file, creates a copy of them and uses that copy.
For that, `Account Directory` is used. If there is only one account on your PC and Steam is installed in usual location,
this field will be filled automatically.

If you need to change `Web UI address/port` to avoid port conflicts/listening interface, change the corresponding field.

`Master Key` is the key that will be used in combination with other keys during gameplay to invoke various dynamite 
features. Default value is `V` (`ZOOM_CHANGE`).

`Reload Key` is the key to reload configuration and loaded lua scripts in game. Hold `Master Key` and `Reload Key` 
for a second together; in case of success `Keys bound` will be printed in game log. Default value is `E` (`ACTION`).

Check `Skip Web UI on start` if you are fine with current settings; on the next launch Web UI won't open in browser, 
no installation will be performed, you can start the game right after launching dynamite executable.

---

#### Master server

Master server holds records about your online resources; game requires working connection to it to play co-op.
Usually, after a mission some data is sent to original master server, including your records. Co-op sessions differ 
from regular single-player missions in variety of ways; wrong or broken data might be sent to the server. Wrong data *may* 
result in online ban from original server. To protect your account, dynamite comes with bundled master server 
implementation <a href="https://github.com/unknown321/fuse" target="_blank">fuse</a>, which runs locally.

`Use Local Master Server` will start a local server on port 6667. If you want to connect to another public master server
instance (**not recommended**), uncheck it and enter address in the `URL` field.

---

#### Key bindings

You can add and change key combinations to run dynamite functions (see [Playing](#Playing)) or external lua scripts.

To use them, hold `Master Key` for a second and press key from the table to call corresponding function in game.

`Dynamite.CreateClientSession` entry is required to connect to the host; 
`Dynamite.ResetClientSessionStateWithNotification` is required to reset session state in case of connection issues. You 
should keep these entries; feel free to change default keys (`UP` and `LEFT` arrow buttons).

---

#### Miscellaneous

To indicate that function was executed, game will play a clicking sound. Uncheck `Play sound on function call` to 
disable it.

---

### Installing

1. Right-click the game in the Steam library and choose `Properties`, then go to the `Local files` tab and click `Browse local files`
2. Put dynamite executable into the game directory
3. Launch dynamite executable
4. Browser window will open
5. Linux / SteamOS only: you must set custom launch options before starting the game: Steam --> MGSV:TPP
--> Game properties --> Set Launch Options: `WINEDLLOVERRIDES="dinput8.dll=n,b" %command%`

Fill in required fields in `Configuration` tab, press `Save configuration`. Your config and game files will be updated.
You can track installation status in console window or wait for the information on status page. After installation 
keep console window open - master server is running in there.

---

### Updating

Download latest release from <a href="https://github.com/unknown321/dynamite/releases/latest" target="_blank">GitHub</a>
and launch the executable. This mod is **not** available on Nexus Mods or Discord and distributed only through GitHub.

---

### Playing

**Note**: dynamite uses its own save files, which are a copy of yours. However, online resources and funds are **not**
transferred to local master server; stub data is used instead.

**Note**: various online features (such as FOB missions, PF rankings) are not working at the moment.

Playing with others **requires** some sort of communication, be it text or voice (Steam Chat provides both).

Steps:

1. Agree on roles (host/client)
2. Configure dynamite
3. Launch the game
4. Choose working mission from list below and tell it to all session participants

---

#### Missions that are playable from start to finish with minor bugs (not impacting gameplay in a meaningful way):

<details>
<summary>Mission list (click me)</summary>

```
    1 - PHANTOM LIMBS - client loads into mission again (#12)
    5 - OVER THE FENCE - prisoner repeats his lines over and over for host
    7 - RED BRASS - commanders don't move from their spawn points (#40)
    8 - OCCUPATION FORCES - third tank spawn only for host (#19)
    14 - LINGUA FRANCA - prisoners must be extracted by each party (#14)
    15 - FOOTPRINTS OF PHANTOMS - walker gears are not fultonable (#21)
    16 - TRAITORS’ CARAVAN - skulls spawn only for one player (#41), no armored vehicle (#42)
    17 - RESCUE THE INTEL AGENTS - there may be some confusion with prisoner extraction order
    20 - VOICES - infinite loading after last cutscene (#37)
    21 - THE WAR ECONOMY - stucks on black screen after finishing the mission (#11)
    23 - THE WHITE MAMBA - client loads into mission again (#12), Eli is local
    26 - HUNTING DOWN - client loads into mission again (#12)
    27 - ROOT CAUSE - client stucks on black screen after finishing the mission (#11)
```


</details>

A good (read: tested) choice is Mission 5, OVER THE FENCE.

---

<p class="color-changing-text">NEW:</p> 

#### Missions that were recently updated and need testing:

Report if they are working on <a href="https://github.com/unknown321/dynamite/issues/32" target="_blank">GitHub</a> or 
<a href="https://discord.gg/3XwAsWV" target="_blank">Modders' Heaven Discord</a>, `modding-showcase`
channel, `dynamite` thread:

<details>
<summary>Click me</summary>

```
    6 - WHERE DO THE BEES SLEEP?
    8 - OCCUPATION FORCES
    10 - ANGEL WITH BROKEN WINGS - client loads into mission again (#12), prisoners must be extracted by each party (#14)
    11 - CLOAKED IN SILENCE - quiet is local
    12 - HELLBOUND
    18 - BLOOD RUNS DEEP
    19 - ON THE TRAIL
    24 - CLOSE CONTACT - client loads into mission again (#12), prisoners must be extracted by each party (#14)
    25 - AIM TRUE, YE VENGEFUL - client loads into mission again (#12)
    28 - CODE TALKER - client cannot pick up Code Talker (#15)
    29 - METALLIC ARCHAEA
    30 - SKULL FACE
    32 - TO KNOW TOO MUCH
    35 - CURSED LEGACY
    38 - EXTRAORDINARY
    41 - PROXY WAR WITHOUT END
    45 - A QUIET EXIT
```

</details>

---

#### These missions are broken in one way or another:

<details>
<summary>Click me</summary>

```
    3 - A HERO’S WAY - no target spawned
    4 - C2W  - cannot progress past "identify equipment" goal (#39)
    9 - BACKUP, BACK DOWN - no enemy vehicles spawned
    13 - PITCH DARK - mission may abort for host (out of mission area) if second partner connects too late.
        Infinite loading for both client and host after blowing up water tank.
    31 - SAHELANTHROPUS - loads, sahelan is local. Host may experience infinite loading after finishing the mission.
    43 - SHINING LIGHTS, EVEN IN DEATH - loads, host crash after entering the facility
```

</details>

---

#### Untested missions:

<details>
<summary>Click me</summary>

```
none?
```

</details>

---

#### EXTREME versions, tutorial missions and script-heavy missions are not included:

<details>
<summary>Click me</summary>

```
    PROLOGUE: AWAKENING
    2 - DIAMOND DOGS - skipped, tutorial mission
    22 - RETAKE THE PLATFORM
    33 - [SUBSISTENCE] C2W
    34 - [EXTREME] BACKUP, BACK DOWN
    36 - [TOTAL STEALTH] FOOTPRINTS OF PHANTOMS
    37 - [EXTREME] TRAITORS’ CARAVAN
    39 - [TOTAL STEALTH] OVER THE FENCE
    40 - [EXTREME] CLOAKED IN SILENCE
    42 - [EXTREME] METALLIC ARCHAEA
    44 - [TOTAL STEALTH] PITCH DARK
    47 - [TOTAL STEALTH] THE WAR ECONOMY
    48 - [EXTREME] CODE TALKER
    49 - [SUBSISTENCE] OCCUPATION FORCES
    50 - [EXTREME] SAHELANTHROPUS
    46 - TRUTH: THE MAN WHO SOLD THE WORLD
```

</details>

---

#### Host

Start the mission as usual. When you see your character (past mission splash screen), tell your partner to connect. Wait 
for partner at the landing zone.

**Warning**: By default (empty blacklist/whitelist), anyone can join your session if they know your SteamID and the fact that you 
are in mission. After establishing connection clients know your IP address. Use black/whitelists accordingly.

Video: <a href="https://youtu.be/ei4CW0x1CfY" target="_blank">Link</a>

---

#### Client

**IMPORTANT STEP**: Wait for host to load the mission, then press `Master Key` + `UP` arrow to connect 
(`Dynamite.CreateClientSession` key bind). It must be done every time by client before starting the mission.

Read the notifications in the game log; if the connection fails, try again. After `Connection established` message start
the same mission. If you are getting "You have been disconnected" popup, press `Master Key` + `LEFT` arrow to reset 
session state and try again.

An indication of success is broken camera in the intro sequence - it will fly around host's position instead of yours.

After that play the game.

Video: <a href="https://youtu.be/rJOufW-rp9g" target="_blank">Link</a>

---

**Notes:**

  - Due to various issues (see below) players respawn 10 seconds after death instead of failing the mission
  - To finish the mission, all players must exfiltrate the hot zone
  - Fultoning other players results in mission failure
  - Restarting mission from pause menu results in infinite loading
  - Host may have to wait up to 30 seconds to reach the results menu

---

### Issues

You can (and will) experience various issues such as:
  - crashes on triggering mission triggers
  - invisible players
  - invisible hostages
  - players not respawning after death
  - broken animations
  - wrong reticle color (green on enemies)
  - enemies unexpectedly switching targets
  - teleporting enemies
  - support vehicle desynchronization
  - D-Horse desynchronization
  - missing mission targets (soldiers, vehicles etc.)
  - broken mission scripts preventing you from finishing the mission
  - everything else

You can report these on <a href="https://github.com/unknown321/dynamite/issues" target="_blank">GitHub</a> (recommended)
or ask for help in <a href="https://discord.gg/3XwAsWV" target="_blank">Modders' Heaven Discord</a>.

---

#### Mission not loading

If you've selected a broken mission, it may never load. Close the game, select another mission from the list.

---

#### Providing crash info

Important information: 
  - mission id/name
  - your role (host/client)
  - what did you do (shot tree with non-lethal gun) 
  - where did you do it (at x.y.z, iDroid screenshot fully zoomed out)
  - video if possible (Steam Recording / NVIDIA ShadowPlay)

You can also collect a crash dump on Windows by following 
<a href="https://learn.microsoft.com/en-us/windows/win32/wer/collecting-user-mode-dumps" target="_blank">this guide</a>.
Set dump type to `Mini dump` (1).

---

### Uninstalling

To restore your game files right-click on the game in your Library and
choose `Properties`; then go to the `Local Files` tab and click on `Verify integrity of game cache…`.

Remove manually from game directory:
  - dynamite executable
  - dynamite directory
  - `dinput8.dll`

After that game will use your regular saves.

---

### Executing custom lua code (info for modders)

Create `example.lua` in `<game directory>/lua` directory. Contents:

```lua
local example = {}

function example.test()
	TppUiCommand.AnnounceLogView('IsSessionConnect: ' .. tostring(TppNetworkUtil.IsSessionConnect()))
end

return example
```

Now you can bind `test` function to a key combination using web UI. Put `example` as module and `test` as a function.
Code is dynamically reloaded on `Master Key` + `Reload Key` press (`V + E` by default).

---

<a href="/" class="btn-launch">Proceed to configuration</a>

---

### Supporting the mod

Support the project monetarily <a href="https://boosty.to/unknown321/donate" target="_blank">here</a>

---

### License

[Link](/license)