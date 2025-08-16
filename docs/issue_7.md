issue 7
=======

This is a document describing issue 7 in detail.

## The issue

Mission 12, `HELLBOUND` (10070), starts with a cutscene. After the end of the cutscene (skipped or not), host player 
enters infinite loading screen (not a crash/hang). This is coop-only issue, not reproduced in regular game.

### Details

Mission sequence is defined in `master/chunk2.dat`, `/Assets/tpp/pack/mission2/story/s10070/s10070_area01.fpkd`. Dynamite
modifies sequence file (`s10070_sequence.lua`) in same manner as others. Removing those changes in that file does not 
fix the issue.

Let's trace the problem. Mission starts with `Seq_Demo_SahelanTest` [link][1]. Essentially it plays the cutscene with 
two functions executed on start and end: `s10070_demo.SahelanTest( startFunc, endFunc )`.

```lua
local endFunc = function()
     this.SwitchpowerPlantGateDoor( true )
     Gimmick.SetEventDoorInvisible( EVENT_DOOR_NAME , EVENT_DOOR_PATH , false )
 
     TppMission.Reload{
         isNoFade = false,
         showLoadingTips = false,
         missionPackLabelName = "afterSahelanTestDemo",
         OnEndFadeOut = function()
             TppScriptBlock.LoadDemoBlock("Demo_GetIntel", false )
             TppSequence.ReserveNextSequence("Seq_Demo_MissionTitle")
 
             TppMission.UpdateCheckPoint("CHK_AfterSahelanTestDemo")
         end,
     }
end
```

The problem goes away after removing `TppMission.Reload` call. What does it do? It does some checks and eventually ends
up calling `Mission.LoadMission()` - lua-exposed exe function.

### Mission loading

By calling `Mission.LoadMission()` you invoke `tpp::gm::anonymous_namespace::Mission_LoadMission` (`0x14646d710`). It
sets some global variables - mission code, location code and `force` flag (irrelevant). These variables are used by
`tpp::gm::impl::anonymous_namespace::SimpleMissionBlockController::Update` (`0x140a1dc80`). On change, it unloads 
old "blocks" and replaces them with new ones. What are blocks?

### Blocks

Currently (August 15, 2025), there is no definitive conclusion on what blocks are. There was some digging around in 
Discord, but these crumbs of knowledge are hard to collect and summarize, so I had to do it from scratch myself.

Block is an object represented by `fox::Block` class in the exe. It can be created, loaded, activated, deactivated and 
unloaded. It occupies a chunk of memory and keeps track of memory which was allocated during `active` phase (maybe 
others?). Phase is changed by updating its "state" flag. Blocks can be grouped in 
`fox::BlockGroup` (irrelevant for this document).

Block lifecycle:
    - load
    - process
    - activate
    - deactivate
    - unload

Load phase (very rough description):
  - parse one or more `fox::PackFile`s (`.fpk`) (multi-threaded)
  - find DataSet2 files (`.fox2`) inside
  - parse and cast DataSet entities into objects (multi-threaded)
  - call callbacks if needed

Process:
  - switch / case to select next phase

Activate / Deactivate:
  - set or unset `fox::DataBodySet` (what's that?) "active" flag

Unload:
  - call callbacks on unload
  - clear allocated memory

Block definition in lua looks like [this][3]:

```lua
s[1] = { "/Assets/tpp/pack/ui/gz/gz_pause_key_setting_data.fpk", "/Assets/tpp/pack/mission2/init/init.fpk" }
```

It consists of 2 fpk files with 2 corresponding fpkds. That table is fed to `SimpleMissionBlockController::Update`
using MissionPackagePathFunc (set in lua).

### Back to the problem

Now that we know what blocks are, we can take a better look. Logs before and during infinite loading screen:

```
[2025-08-15 21:39:31.881] [dynamite] [info] tid 7676, block mission_block (0x723de3c8), loading /Assets/tpp/pack/location/afgh/pack_common/afgh_script.fpk (1/43)
[2025-08-15 21:39:31.882] [dynamite] [info] tid 7676, block mission_block (0x723de3c8), loading /Assets/tpp/pack/mission2/common/online_challenge.fpk (2/43)
...
[2025-08-15 21:39:31.883] [dynamite] [info] tid 7676, block mission_block (0x723de3c8), loading /Assets/tpp/pack/fova/chara/prs/prs2_main0_v00.fpk (43/43)
[2025-08-15 21:39:32.686] [dynamite] [info] tid 7676, process mission_block (0x723de3c8), mem 0 65437088 0 75403264 0
[2025-08-15 21:39:33.588] [dynamite] [info] tid 7756, process mission_block (0x723de3c8), mem 0 65131408 0 75403264 0
[2025-08-15 21:39:33.610] [dynamite] [info] l_CreateHostSession                                                         <-- Dynamite.CreateHostSession is called
[2025-08-15 21:39:37.538] [dynamite] [info] tid 7676, activate mission_block (0x723de3c8), res 0
[2025-08-15 21:39:49.473] [dynamite] [info] tid 7676, deactivate mission_block (0x723de3c8), res 0
[2025-08-15 21:39:49.615] [dynamite] [info] tid 7676, unload mission_block (0x723de3c8), res 0
[2025-08-15 21:39:57.944] [dynamite] [info] tid 7752, process mission_block (0x723de3c8), mem 0 65128320 0 75403264 10274680
[2025-08-15 21:40:06.286] [dynamite] [info] tid 7736, process mission_block (0x723de3c8), mem 0 65128320 0 75403264 10274680
[2025-08-15 21:40:14.627] [dynamite] [info] tid 7756, process mission_block (0x723de3c8), mem 0 65128320 0 75403264 10274680
```

We are looping in `fox::Block::Process` at `0x14006e8df` after attempting to unload `mission_block` block.

```c++
    fox::impl::BlockMemory::RecycleTail(this,local_f0);
    if ((uint)((*(int *)(this + 0x60) - *(int *)(this + 0x18)) + *(int *)(this + 0x40) + *(int *)(this + 0x10)) <= *(uint *)(this + 0x148)) {
      *(undefined8 *)((longlong)param_3 + 0x24) = 0;
      *(undefined4 *)(this + 0x84) = 0xd;
      return 0.0;
    }
```

It attempts to free memory and check memory counters after. If conditions are met, block is marked unloaded. Log prints
all five variables:

```
x = 0 - 65128320 + 0 + 75403264 // 10274944
x <= 10274680 // false

10274944 - 10274680 = 264
```

264 bytes are still occupied by what?

### Starting coop session

As I've mentioned before, bug is present only in coop and only for host, so it must be host coop function that breaks 
the game.

```c++
    __cdecl int l_CreateHostSession(lua_State *L) {
        auto ft = (FobTarget *)BlockHeapAlloc(8, 8, MEMTAG_NULL);
        ft = FobTargetCtor(ft);
        CreateHostSession(ft);
        BlockHeapFree(ft);
        return 0;
    }
```

Here we allocate 8 bytes for `FobTarget` pointer somewhere on the heap and free them afterwards, should be fine, right?
But this code produces a bug. Let's take a look at BlockHeapAlloc:

```c++
void * __cdecl fox::BlockHeapAlloc(uint64_t sizeInBytes,uint64_t alignment,uint32_t categoryTag)

{
  BlockMemory *this;
  void *pAllocatedMemory;
  
  this = (BlockMemory *)BlockPackageContext::GetCurrentBlockMemory();
  if (this != (BlockMemory *)0x0) {
    pAllocatedMemory = impl::BlockMemory::AllocTail(this,sizeInBytes,alignment,categoryTag);
    return pAllocatedMemory;
  }
  pAllocatedMemory = impl::BlockMemory::AllocHeap(sizeInBytes,alignment,(ulonglong)categoryTag);
  return pAllocatedMemory;
}
```

Actually, memory is allocated in current block. It is hard to say what makes a block "current", but at least 
`GetCurrentBlockMemory` returns pointer to `Block` instance, not some random address - now we can link allocation to 
corresponding block in logs. So, session is created, memory is allocated at the end of current block, but it is not
freed, even though `BlockHeapFree` was called. Another question: I asked for 8 bytes, but it says there are 264?

Thankfully allocations are tagged with "memory tags" - some category number. By hooking `BlockHeapAlloc` we can track
specific tags. 88 is taken by `tpp::net::BandWidthManager::Create`, `tpp::net::impl::BandWidthManagerJob::Create` asks 
for 144.

```shell
	mgsvtpp.00000001459BEB3E = tpp::net::BandWidthManager::Create                 <--- 88
	mgsvtpp.000000014595B267 = tpp::net::NetworkInfo::CreateBandWidthManager
	mgsvtpp.00000001459F3F10 = tpp::net::FobTarget::CreateHostSession
	
    mgsvtpp.00000001459BEF91 = tpp::net::impl::BandWidthManagerJob::Create        <--- 144
	mgsvtpp.00000001459BD181 = tpp::net::impl::BandWidthManagerImpl::BandWidthManagerImpl
	mgsvtpp.00000001459BEB50 = tpp::net::BandWidthManager::Create
	mgsvtpp.000000014595B267 = tpp::net::NetworkInfo::CreateBandWidthManager
	mgsvtpp.00000001459F3F10 = tpp::net::FobTarget::CreateHostSession
```

This code is called only when some flag in `tpp::net::NetworkInfo` instance is not set (initialized?). Same code is 
called when you attempt to invade fob for the first time in that game session, but the game doesn't 
break. These allocations must happen somewhere else - not in the current block. What makes a block "current"?

`fox::BlockPackageContext::GetCurrentBlockMemory`:

```c++
undefined8 fox::BlockPackageContext::GetCurrentBlockMemory(void)

{
  return *(undefined8 *)
          (*(longlong *)((longlong)ThreadLocalStoragePointer + (ulonglong)_tls_index * 8) + 0x48);
}
```

Blocks belong to threads. Let's take a look at full stacktrace of regular FOB host session creation:

```
	mgsvtpp.00000001459BEF91 = tpp::net::impl::BandWidthManagerJob::Create
	mgsvtpp.00000001459BD181 = tpp::net::impl::BandWidthManagerImpl::BandWidthManagerImpl
	mgsvtpp.00000001459BEB50 = tpp::net::BandWidthManager::Create
	mgsvtpp.000000014595B267 = tpp::net::NetworkInfo::CreateBandWidthManager
	mgsvtpp.00000001459F3F10 = tpp::net::FobTarget::CreateHostSession
	mgsvtpp.00000001416994CC = tpp::ui::menu::mbm::impl::FobMission2CallbackImpl::Update
	mgsvtpp.000000014D72C20B = fox::ui::Event::MainProcess
	mgsvtpp.000000014D91CF24 = fox::ui::Phase::Update
	mgsvtpp.000000014D91EA8B = fox::ui::Page::Update
	mgsvtpp.000000014D85DFA7 = fox::ui::Graph::Update
	mgsvtpp.000000014D9647FC = fox::ui::WindowManager::UpdateGraphs
	mgsvtpp.0000000142F2646A = fox::Job::Execute
	mgsvtpp.0000000142F2ADBA = fox::JobExecutor::Execute
	mgsvtpp.0000000142EF5AEE = fox::WorkerThread<>::operator()
	mgsvtpp.0000000142EE1CB0 = fox::thread::impl::Thread::Entry
```

This thread doesn't mention blocks at all.

What is the difference between dynamite and regular fob mission then? Dynamite follows same flow calling same functions 
as the game does, but functions are called from lua, which is executed in block context. Memory is allocated in block
context and never freed, resulting in infinite loading loop.

### Solution

We can force the game to allocate memory with network tag (0x73) on heap:

```c++
    void *BlockHeapAllocHook(uint64_t sizeInBytes, uint64_t alignment, uint32_t categoryTag) {
        if (categoryTag == 0x73) {
            return BlockMemoryAllocHeap(sizeInBytes, alignment, categoryTag);
        }
        return BlockHeapAlloc(sizeInBytes, alignment, categoryTag);
    }
```

It works, we can finally get past the cutscene into the mission, but:
  - this function is used everywhere, hooking it adds more overhead
  - all allocations with that tag will be made on heap

Indeed, there are other functions that allocate memory with 0x73 tag - `tpp::net::LoginUtility::Create`. It is always 
called at the game start, first function, so I decided just to skip it with a simple condition. 

After that you also need to make sure that host accepts the connection by calling 
`TppNetworkUtil.SessionEnableAccept( true )` from lua in post-cutscene sequence. It seems that mission reloading sets
that flag off.

## The end?

At that point everything works as expected, bug is no longer present - mission starts fine for host (no infinite
loading), client connected successfully. Overhead is, of course, is undesirable, but it can be dealt with later. 
Potential fix might be `fox::ScopeMemory` class.

[1]: https://github.com/unknown321/dynamite/blob/a5f29112fef52360d9376d18f65366ce6d96f728/moddata/s10070_area_fpkd/Assets/tpp/level/mission2/story/s10070/s10070_sequence.lua#L2372

[2]: https://github.com/unknown321/dynamite/blob/a5f29112fef52360d9376d18f65366ce6d96f728/moddata/standalone/TppMission.lua#L4063

[3]: https://github.com/unknown321/dynamite/blob/a5f29112fef52360d9376d18f65366ce6d96f728/moddata/standalone/TppMissionList.lua#L17

[4]: https://github.com/unknown321/dynamite/blob/a5f29112fef52360d9376d18f65366ce6d96f728/hook/src/DynamiteLua.cpp#L13