local this = {}
local StrCode32 = Fox.StrCode32
local StrCode32Table = Tpp.StrCode32Table

local sequences = {}




local TARGET_ENEMY_NAME = "sol_vip_0000"
local TIME_VIP_WAIT_LONG = 120
local TIME_VIP_WAIT_NEAR = 19
local TIME_CLER_RADIO_WAIT_WITH_VIP = 13
local BOUNUCE_DIST = 100 * 100 




this.ENABLE_DEFAULT_HELI_MISSION_CLEAR = true
this.MAX_PLACED_LOCATOR_COUNT = 30

this.NPC_ENTRY_POINT_SETTING = {
	[ Fox.StrCode32("lz_drp_field_N0000|rt_drp_field_N_0000") ] = {
		[EntryBuddyType.VEHICLE] = { Vector3(803.316, 335.879, 1655.081), TppMath.DegreeToRadian( 45 ) }, 
		[EntryBuddyType.BUDDY] = { Vector3(792.560, 338.885, 1636.501), TppMath.DegreeToRadian( 45 ) }, 
	},
	[ Fox.StrCode32("lz_drp_field_W0000|rt_drp_field_W_0000") ] = {
		[EntryBuddyType.VEHICLE] = { Vector3(-346.607, 276.141, 1716.993), TppMath.DegreeToRadian( 45 ) }, 
		[EntryBuddyType.BUDDY] = { Vector3(-355.449, 276.317, 1720.251), TppMath.DegreeToRadian( 45 ) }, 
	},
}





function this.OnLoad()
	Fox.Log("#### OnLoad ####")

	TppSequence.RegisterSequences{
		
		"Seq_Game_MainGame",
		"Seq_Game_Escape",
		nil
	}
	TppSequence.RegisterSequenceTable(sequences)
end





this.saveVarsList = {
	isNearField 	= false,			
	isNearVip		= false,		
	isMoveVip		= 0,		
	isDownVip		= false,		
	isWatchPhoto	= false,	
	vipJinmonNum	= 0,		

	isFlag00	= false,	
	isFlag01	= false,	
	isFlag02	= false,
	isFlag03	= false,
	isFlag04	= false,
	isFlag05	= false,
	isFlag06	= false,
	isFlag07	= false,
	isFlag08	= false,
	isFlag09	= false,
	numFlag00 = 0,
	numFlag01 = 0,
	numFlag02 = 0,
	numFlag03 = 0,
	numFlag04 = 0,
	numFlag05 = 0,
	numFlag06 = 0,
	numFlag07 = 0,
	numFlag08 = 0,
	numFlag09 = 0,

}


this.checkPointList = {
	
	"CHK_MissionStart",		
	"CHK_TargetDown",			
	nil
}
this.baseList = {
	"field",
	"fieldEast",
	"fieldWest",
	nil
}







this.missionObjectiveDefine = {
	
	default_area_field = {
		gameObjectName = "default_area_field", visibleArea = 5, randomRange = 0,viewType="all", setNew = false,
		langId = "marker_info_mission_targetArea",
		mapRadioName = "s0036_mprg0010",
		announceLog = "updateMap",
		subGoal = 0,
	},
	marker_area_vip = { 
		gameObjectName = "marker_area_vip", visibleArea = 1, randomRange = 0,viewType="all", setNew = true,
		langId = "marker_info_mission_targetArea",
		announceLog = "updateMap",
		mapRadioName = "s0036_mprg0010",
	},	

	marker_VIP_far = { 
		gameObjectName = TARGET_ENEMY_NAME, goalType = "moving",viewType="map_and_world_only_icon", setNew = true,
		langId = "marker_ene_soviet",
		mapRadioName = "s0036_mprg0010",
	},
	marker_VIP = { 
		gameObjectName = TARGET_ENEMY_NAME, goalType = "moving",viewType="map_and_world_only_icon", setNew = true, setImportant = true,
		langId = "marker_info_mission_target",
		
		hudPhotoId = 10
	},
	
	default_photo = {
		photoId			= 10,
		addFirst = true,
		photoRadioName = "f1000_mprg0160",
		targetBgmCp = "afgh_field_cp",
	},
	clear_photo = {
		photoId			= 10,
		addFirst 		= true,
		subGoalId 		= 1,
		announceLog = "achieveAllObjectives",
	},
	
	hud_10 = {
		hudPhotoId = 10
	},	
	
	
	
	default_missionTask_00 = { missionTask = { taskNo = 0, isNew = true, isComplete = false, isFirstHide = false },},	
	
	default_missionTask_01 = { missionTask = { taskNo = 1, isNew = true, isComplete = false, isFirstHide = true },},	
	
	default_missionTask_02 = { missionTask = { taskNo = 2, isNew = true, isComplete = false, isFirstHide = true },},	
	
	default_missionTask_03 = { missionTask = { taskNo = 3, isNew = true, isComplete = false, isFirstHide = true },},	
	
	default_missionTask_04 = { missionTask = { taskNo = 4, isNew = true, isComplete = false, isFirstHide = true },},	

	
	clear_missionTask_00 = { missionTask = { taskNo = 0, isNew = true, isComplete = true },},	
	
	clear_missionTask_01 = { missionTask = { taskNo = 1, isNew = true },},	
	
	clear_missionTask_02 = { missionTask = { taskNo = 2, isNew = true },},	
	
	clear_missionTask_03 = { missionTask = { taskNo = 3, isNew = true, isComplete = true },},	
	
	clear_missionTask_04 = { missionTask = { taskNo = 4, isNew = true, isComplete = true },},	
	
	on_itm_s10036_material = {
		gameObjectName = "TppMarker2Locator_field_material",	goalType = "none", viewType = "map_only_icon", setNew = true, announceLog = "updateMap",
		langId = "marker_processed_res",
	},
	on_itm_s10036_herb = {
		gameObjectName = "TppMarker2Locator_field_herb",visibleArea = 1, randomRange = 0,	
		goalType = "none", viewType = "map_only_icon", setNew = true, announceLog = "updateMap",
		langId = "marker_area_medicinal_plant",
	},

	announce_rescue_target = {
		announceLog = "recoverTarget",
	},
	
	announce_kill_target = {
		announceLog = "eliminateTarget",
	},
}

this.missionObjectiveEnum = Tpp.Enum{
	"default_area_field",
	"marker_area_vip",
	"marker_VIP_far",
	"marker_VIP",
	"default_photo",
	"clear_photo",
	"on_itm_s10036_material",
	"on_itm_s10036_herb",
	"default_missionTask_00",
	"default_missionTask_01",
	"default_missionTask_02",
	"default_missionTask_03",
	"default_missionTask_04",
	"clear_missionTask_00",
	"clear_missionTask_01",
	"clear_missionTask_02",
	"clear_missionTask_03",
	"clear_missionTask_04",	
	"announce_rescue_target",
	"announce_kill_target",
	"hud_10",
}


this.missionObjectiveTree = {
	clear_photo = {
		default_photo = {},
		marker_VIP = {
			marker_VIP_far = {
				marker_area_vip = {
					default_area_field = {},
				},
			},
		},
	},
	on_itm_s10036_material = {},
	on_itm_s10036_herb = {},

	clear_missionTask_00 = {
		default_missionTask_00 = {},
	},
	clear_missionTask_01 = {
		default_missionTask_01 = {},
	},
	clear_missionTask_02 = {
		default_missionTask_02 = {},
	},
	clear_missionTask_03 = {
		default_missionTask_03 = {},
	},
	clear_missionTask_04 = {
		default_missionTask_04 = {},
	},
	announce_rescue_target = {},
	announce_kill_target = {},
	hud_10 = {},
}


this.specialBonus = {
	first = { 
		missionTask = { taskNo = 1 },
	},
	second = { 
		missionTask = { taskNo = 2 },
	},
}

this.missionStartPosition = {
		helicopterRouteList = {
			"lz_drp_field_I0000|rt_drp_field_I_0000",
			"lz_drp_field_N0000|rt_drp_field_N_0000",
			"lz_drp_field_W0000|rt_drp_field_W_0000",
		},
		orderBoxList = {
			"box_s10036_00",
			"box_s10036_01",
			"box_s10036_02",
		},
}





function this.commonUpdateMarkerTargetFound()
	Fox.Log("found target")
	svars.isFlag01 = true
	TppMission.UpdateObjective{
		objectives = { "marker_VIP", nil },
	}
	s10036_radio.FoundTarget()
	this.NearVipTimerCheck()
end



function this.NearVipTimerCheck()
	Fox.Log("nearVIP. check flag")
	if svars.isNearVip == false then
		Fox.Log("timer stop : timer_VIPmove")
		svars.isNearVip = true
		
		
		if svars.isMoveVip == 1 then
			
			GkEventTimerManager.Stop( "timer_VIPmove" )
			GkEventTimerManager.Start( "timer_VIPmove", TIME_VIP_WAIT_NEAR )
		end
	end
end


function this.GoToNextSeq()
		svars.isDownVip = true
		TppSequence.SetNextSequence("Seq_Game_Escape")
end



function this.CheckEnemyDistance()


	Fox.Log("::Get GameObject Pos")
	local gameObjectId = GameObject.GetGameObjectId( TARGET_ENEMY_NAME )
	local command = { id = "GetPosition" }
	local position = GameObject.SendCommand( gameObjectId, command )

	if position == nil then
		Fox.Error("can not get position")
		return false
	end

	local point1 = TppMath.Vector3toTable( position )
	local point2 = TppPlayer.GetPosition()

	Fox.Log("position1 = "..point1[1]..","..point1[2]..","..point1[3])
	Fox.Log("position2 = "..point2[1]..","..point2[2]..","..point2[3])

	local dist = TppMath.FindDistance( point1, point2 )
	Fox.Log("dist : "..dist )

	if dist >= BOUNUCE_DIST then
		Fox.Log("100m MuRyoKu!!")
		TppMission.UpdateObjective{
			objectives = { "clear_missionTask_01",nil },
		}
		
		TppResult.AcquireSpecialBonus{
	        first = { isComplete = true },
		}
		return true
	else
		return false	
	end
	

end

function this.ShowHud()
	TppSoundDaemon.PostEvent( 'sfx_s_enemytag_main_tgt' )
	TppMission.UpdateObjective{ objectives = { "hud_10" }, }
end







function this.MissionPrepare()
	local missionName = TppMission.GetMissionName()
	Fox.Log("*** " .. tostring(missionName) .. " MissionPrepare ***")
	
	TppMission.RegisterMissionSystemCallback{
		OnEstablishMissionClear = function( missionClearType )
			if svars.isDownVip == false then
				Fox.Log("Mission clear with VIP. On estableish mission clear")

				TppMission.UpdateObjective{	objectives = { "announce_rescue_target" },	}
				TppMission.UpdateObjective{	objectives = { "clear_missionTask_00","clear_missionTask_02" },	}
				
				TppResult.AcquireSpecialBonus{
			        second = { isComplete = true },
				}
				
				SubtitlesCommand.SetIsEnabledUiPrioStrong( true )
				s10036_radio.ClearRadioWithVIP()

				TppSound.PostJingleOnEstablishMissionClear()
				
				GkEventTimerManager.Start("Timer_PlayFullutonSE", 2)

				TppMission.MissionGameEnd{ delayTime = TIME_CLER_RADIO_WAIT_WITH_VIP, loadStartOnResult = true }
			else
				Fox.Log("Mission clear without VIP")
				if missionClearType == TppDefine.MISSION_CLEAR_TYPE.ON_FOOT then
					TppPlayer.PlayMissionClearCamera()
					TppMission.MissionGameEnd{
						loadStartOnResult = true,
						fadeDelayTime = TppPlayer.MISSION_CLEAR_CAMERA_FADE_DELAY_TIME,
						delayTime = TppPlayer.MISSION_CLEAR_CAMERA_DELAY_TIME,
					}
				else
					TppMission.MissionGameEnd{ loadStartOnResult = true }
				end
			end
		end,
		
		
		CheckMissionClearFunction = function()
			return TppEnemy.CheckAllTargetClear()
		end,
		
		OnRecovered = function()
			
			TppMission.UpdateObjective{	objectives = { "announce_rescue_target","clear_photo" },	}
			TppMission.UpdateObjective{	objectives = { "clear_missionTask_00","clear_missionTask_02" },	}
			
			TppResult.AcquireSpecialBonus{
		        second = { isComplete = true },
			}
			
			this.GoToNextSeq()
		end,
	}


	
	TppMarker.SetUpSearchTarget{
		{ gameObjectName = TARGET_ENEMY_NAME, gameObjectType = "TppSoldier2", messageName = TARGET_ENEMY_NAME, skeletonName = "SKL_004_HEAD", func = this.commonUpdateMarkerTargetFound },
	}
	
	TppRatBird.EnableRat() 
	
end




function this.OnRestoreSVars()
	local missionName = TppMission.GetMissionName()
	Fox.Log("*** " .. tostring(missionName) .. " OnRestoreSVars ***")

end








function this.Messages()
	return
	StrCode32Table {
		Player = {
			{
				msg = "OnPickUpCollection",
				func = function(gameObjectId, uniqueId, type)
					Fox.Log("Get collection "..uniqueId..":"..type )
					if uniqueId == 6856907 then
						
						TppMission.UpdateObjective{	objectives = { "clear_missionTask_04", nil },}
					elseif uniqueId == 4753294 then
						
						TppMission.UpdateObjective{	objectives = { "clear_missionTask_03", nil },}
					end
				end
			},
			{
				msg = "DeadInFOB",
				func = function (deadPlayerIndex, AttackerId)
					TppUiCommand.AnnounceLogView("Player " .. tostring(deadPlayerIndex) .. " died")
					if deadPlayerIndex == PlayerInfo.GetLocalPlayerIndex() then
						TppUiCommand.AnnounceLogView("Respawn in 10 seconds")
						GkEventTimerManager.Start("RespawnPlayer", 10 )
					end
				end
			},
		},
		Trap = {
			
			{
				msg = "Enter", sender = "trap_CHK_field_E01",
				func = function (trap,player)
				end
			},
		},
		Timer = {
			{
				msg = "Finish", sender = "Timer_PlayFullutonSE",
				func = function()
					Fox.Log("play SE fulton")
					TppSoundDaemon.PostEvent( 'sfx_m_fulton_6_lift_up' )
					
				end,
				option = { isExecMissionClear = true },
			},
			{
				msg = "Finish",
				sender = "RespawnPlayer",
				func = function ()
					TppUiCommand.AnnounceLogView("Respawning")
					TppUiStatusManager.ClearStatus("AnnounceLog")
					TppUiStatusManager.ClearStatus("EquipPanel")
					TppUiStatusManager.ClearStatus("HeadMarker")
					TppUiStatusManager.ClearStatus("WorldMarker")
					Player.RequestToRespawn()
				end
			},
		},
		GameObject = {
			{	
				msg = "BuddyPuppyFind",
				func = function( gameObjectId )
					Fox.Log( "**** s30010_sequence::BuddyPuppyFind ****" )
					if not TppRadio.IsPlayed("f1000_rtrg5040") then
						TppRadio.Play("f1000_rtrg5040", { delayTime = "long", isEnqueue = true } )
					end
				end
			},
			{	
				msg = "Damage",
				func = function( gameObjectId, attackId, attakerId )
					local puppyId = GameObject.GetGameObjectId("TppBuddyPuppy", "anml_BuddyPuppy_00")
					if puppyId ~= nil then
						if gameObjectId == puppyId and Tpp.IsPlayer( attakerId ) then
							Fox.Log( "**** s30010_sequence::Puppy Damaged by Player ****" )
							TppRadio.Play("f1000_rtrg5060", { delayTime = "short", } )
						end
					end
				end
			},
			{	
				msg = "Dead",
				func = function( gameObjectId, attakerId, attackId )
					local puppyId = GameObject.GetGameObjectId("TppBuddyPuppy", "anml_BuddyPuppy_00")
					if puppyId ~= nil then
						if gameObjectId == puppyId and Tpp.IsPlayer( attakerId ) then
							Fox.Log( "**** s30010_sequence::Puppy Dead ****" )
							TppRadio.Play("f1000_rtrg5070", { delayTime = "short", } )
						end
					end
				end
			},
			{	
				msg = "Fulton",
				func = function( gameObjectId, animaiId, arg2 )
					local puppyId = GameObject.GetGameObjectId("TppBuddyPuppy", "anml_BuddyPuppy_00")
					if puppyId ~= nil then
						if gameObjectId == puppyId then
							Fox.Log( "**** s30010_sequence::Puppy Fulton ****" )
							TppRadio.Play("f1000_rtrg5050", { delayTime = "long", isEnqueue = true } )
						end
					end
				end
			},
		},
		Network = {
			{
				msg = "FobPeerNameResolved",
				func = function ()
					TppUiCommand.AnnounceLogView("Co-op partner connecting")
				end
			},
		},
		Nt = {
			{
				msg = "SessionDeleteMember",
				func = function ()
					TppUiCommand.AnnounceLogView("Client Player Disconnected!")
				end
			},
			{
				msg = "SessionDisconnectFromHost",
				func = function ()
					TppUiCommand.AnnounceLogView("Host Player Disconnected!")
				end
			},
		},
		nil
	}
end





sequences.Seq_Game_MainGame = {

	Messages = function( self ) 
		return
		StrCode32Table {

			GameObject = {
				{ 
					msg = "Dead", sender = TARGET_ENEMY_NAME,
					func = self.TargetDead
				},
				{ 
					msg = "FultonFailed", sender = TARGET_ENEMY_NAME,
					func = function(id,arg1,arg2,type)
						Fox.Log("fulton failed "..type)
						if type == TppGameObject.FULTON_FAILED_TYPE_ON_FINISHED_RISE then
							
							self.TargetFaild()
						else
							
							Fox.Log("meybe inside")
						end
					end
				},
				{
					msg = "Fulton",sender = TARGET_ENEMY_NAME,
					func = function()
						if svars.isFlag01 == true then
							
							s10036_radio.GetVIP()
						else
							
							this.ShowHud()
							s10036_radio.GetVIPDontKnow()
						end
					end
				},
				{ 
					msg = "Neutralize", sender = TARGET_ENEMY_NAME,
					func = self.TargetUnconscious
				},
				{
					msg = "PlacedIntoVehicle",
					sender = TARGET_ENEMY_NAME,
					func = function (characterId, rideVehicleID)
						Fox.Log("target in vehicle. check is in heli")
						
						if Tpp.IsHelicopter(rideVehicleID) and TppEnemy.CheckAllTargetClear() then
							Fox.Log("in heli. go to next sequence")
							TppMission.UpdateObjective{	objectives = { "announce_rescue_target","clear_photo" },	}
							TppMission.UpdateObjective{	objectives = { "clear_missionTask_00","clear_missionTask_02" },	}
							
							TppResult.AcquireSpecialBonus{
						        second = { isComplete = true },
							}
							
							this.GoToNextSeq()
						else
							
							Fox.Log("not heli")
						end
					end
				},
				{
					
					msg = "RoutePoint2",
					func = function (gameObjectId, routeId ,routeNode, messageId )
						Fox.Log("vip lrrp end"..routeId..routeNode..messageId )
						if messageId == Fox.StrCode32( "endVipLrrp" )then
							if svars.isMoveVip == 0 then
								svars.isMoveVip = 1
								s10036_enemy.ChangeRouteSetsVIP()
								s10036_enemy.StopCpChat()
								
								
								
								if svars.isNearVip == true then
									svars.isMoveVip = 2
									GkEventTimerManager.Stop( "timer_VIPmove" )
									local time = TIME_VIP_WAIT_NEAR + 90 
									GkEventTimerManager.Start( "timer_VIPmove", time )
								
								
								else
									svars.isMoveVip = 2
									GkEventTimerManager.Stop( "timer_VIPmove" )
									local time = TIME_VIP_WAIT_LONG + 80	
									GkEventTimerManager.Start( "timer_VIPmove", time )

								end
							else
								
							end
						elseif messageId == Fox.StrCode32( "TalkStart" ) and svars.isFlag00 == false then
							svars.isFlag00 = true
							GkEventTimerManager.Start("Timer_StartTalk",9)
							
						end
					end
				},
				{
					msg = "ConversationEnd", 
					func = function()
						Fox.Log("talk is end")
					end
				},
				nil
			},
			Trap = {
				{
					msg = "Enter", sender = "trap_field",
					
					func = function()
						if svars.isNearField == false then
							svars.isNearField = true
							s10036_radio.ArrivedField()

							if svars.isMoveVip == 1 then
								Fox.Log("start timer: vip move")
								GkEventTimerManager.Start( "timer_VIPmove", TIME_VIP_WAIT_LONG )
							end
						else
							Fox.Log("flag is true. isNearField")
						end
					end,
				},
				
				{
					msg = "Enter", sender = "trap_nearVIP",
					func = this.NearVipTimerCheck
				},
			},
			Timer = {
				{
					msg = "Finish", sender = "Timer_StartTalk",
					func = function()
						s10036_enemy.TalkStart()
					end
				},
				{
					msg = "Finish", sender = "timer_VIPmove",
					func = function()
						if svars.isMoveVip < 3 then
							svars.isMoveVip = 3
							Fox.Log("its time! VIP route is reset")
							s10036_enemy.TalkEnd()
							GkEventTimerManager.Start("timer_VIPresetRoute", 4)
						end
					end
				
				},
				{
					msg = "Finish", sender = "timer_VIPresetRoute",
					func = function()
						s10036_enemy.resetRouteSetsVIP()
					end
				},
			},
			Marker = {
				{ 
					msg = "ChangeToEnable", sender = TARGET_ENEMY_NAME, 
					func = function(instanceName, makerType, s_gameObjectId, identificationCode )
						if identificationCode == Fox.StrCode32("Player") then		
							Fox.Log("Fond Target")
							TppMission.UpdateObjective{
								objectives = { "marker_VIP_far", nil },
							}
						else
							Fox.Log("marking by buddy")
						end
					end,
				},	
				nil

			},

			nil
		}
	end,

	OnEnter = function()
		if TppGameStatus.IsSet("Mission", "S_IS_ONLINE") then
			TppNetworkUtil.SessionEnableAccept( true )
			Dynamite.StartNearestEnemyThread()
		end

		TppTelop.StartCastTelop()
		
		
		s10036_radio.ORadioSet01()
		
		
		TppMission.UpdateObjective{
			objectives = { 
				"default_missionTask_00", 
				"default_missionTask_01", 
				"default_missionTask_02", 
				"default_missionTask_03", 
				"default_missionTask_04", 
				"default_photo",
				nil
			},
		}

		TppMission.UpdateObjective{
			radio = { radioGroups = "s0036_rtrg0010", },
			objectives = { "default_area_field" },
			options = { isMissionStart = true },
		}
		
		if svars.isMoveVip == 2 then
			
			GkEventTimerManager.Stop( "timer_VIPmove" )
			GkEventTimerManager.Start( "timer_VIPmove", 10 )
		end
	end,
	
	OnLeave = function ()
		
	end,
	
	TargetDead = function()
		Fox.Log("target dead")
		
		if svars.isDownVip == false then
			TppMission.UpdateObjective{	objectives = { "announce_kill_target","clear_photo" },	}
			TppMission.UpdateObjective{	objectives = { "clear_missionTask_00"},	}

			s10036_enemy.resetRouteSetsVIP()
			
			if svars.isFlag01 == true then
				s10036_radio.KillVIP()
			else			
				this.ShowHud()
				s10036_radio.KillVIPDontKnow()
			end
			this.GoToNextSeq()
		end
	end,

	
	TargetFaild = function()
		Fox.Log("target failed")
		
		if svars.isDownVip == false then

			TppMission.UpdateObjective{	objectives = { "announce_kill_target","clear_photo" },	}
			TppMission.UpdateObjective{	objectives = { "clear_missionTask_00"},	}

			s10036_enemy.resetRouteSetsVIP()
			
			if svars.isFlag01 == true then
				
				s10036_radio.KillVIP()
			else
				
				this.ShowHud()
				s10036_radio.FulutonVipDontKnow()
			end
			
			this.GoToNextSeq()
		end
	end,
	

	TargetUnconscious = function(gameObjectId, attakerId, type, cause)
		Fox.Log("get status "..TARGET_ENEMY_NAME )
		
		
		Fox.Log("check neutralize state. attaker:"..tostring(attakerId).." type"..tostring(type).." cause:"..tostring(cause))
		if Tpp.IsPlayer( attakerId ) then
		
			if type == NeutralizeType.DEAD or
			 type == NeutralizeType.FAINT or
			 type == NeutralizeType.SLEEP or
			 type == NeutralizeType.DYING or
			 type == NeutralizeType.FULTON then
			 	
				this.CheckEnemyDistance()
			end
		end
		
		
		local status = TppEnemy.GetLifeStatus( TARGET_ENEMY_NAME )
		Fox.Log( status )

		if status == TppGameObject.NPC_LIFE_STATE_SLEEP or
		status == TppGameObject.NPC_LIFE_STATE_FAINT then
			Fox.Log( TARGET_ENEMY_NAME.." is FAINT or SLEEP")
			s10036_radio.Unconscious()
		else
			Fox.Log("not FAINT or SLEEP")
		end	
	end,
}

sequences.Seq_Game_Escape = {
	
	OnEnter = function()
		Fox.Log("enter seq_game_escape")
		TppMission.CanMissionClear()
		s10036_radio.ORadioSet04()
		s10036_enemy.RemoveInterrogation()
	end,
}




return this