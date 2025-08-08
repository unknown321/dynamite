local this = {}
local StrCode32 = Fox.StrCode32
local StrCode32Table = Tpp.StrCode32Table

local sequences = {}





this.TARGET_ENEMY_NAME = "sol_vip_lrrp_0000" 

local VOLGIN_NAME = "s10110_enemy.VOLGIN_NAME"
local TARGET_ENEMY_NAME = "sol_vip_lrrp_0000" 
local Wall = "mafr_fctr001_wall008_gim_n0001|srt_mafr_fctr001_wall008" 
local Tunnel = "mafr_tnnl001_gim_n0001|srt_mafr_tnnl001" 
local WatorTower = "mafr_wttw003_gim_n0000|srt_mafr_wttw003" 





local resetGimmickIdTable = {
	
	"factory_wall",
	
	"factory_tnnl",
	
	"factory_stfr001",
}

local resetVolginGimmickIdTable = {
	
	"factory_stfr002",
	
	"factory_wttr001",
	"factory_wttr002",
	
	"factory_tank001",
	"factory_tank002",
	"factory_tank003",
	
	"factory_wtnk001",
	"factory_wtnk002",
	"factory_wtnk003",
	
	"factory_wsst001",
	"factory_wsst002",
	"factory_wsst003",
	"factory_wsst004",
}

local resetCrtnIdTable = {
	
	"factory_crtn001",
	"factory_crtn002",
	"factory_crtn003",
	"factory_crtn005",
	"factory_crtn006",
	"factory_crtn007",
	"factory_crtn008",
	"factory_crtn009",
	"factory_crtn010",
	"factory_crtn011",
	"factory_crtn012",
	"factory_crtn013",
	"factory_crtn015",
	"factory_crtn016",
	"factory_crtn017",
	"factory_crtn018",
	"factory_crtn019",
	"factory_crtn020",
	"factory_crtn021",
	"factory_crtn022",
	"factory_crtn023",
	"factory_crtn024",
	"factory_crtn026",
	"factory_crtn027",
	"factory_crtn028",
	"factory_crtn029",
	"factory_crtn030",
	"factory_crtn031",
	"factory_crtn032",
	"factory_crtn033",
	"factory_crtn034",
	"factory_crtn035",
	"factory_crtn036",
	"factory_crtn037",
	"factory_crtn039",
	"factory_crtn040",
	"factory_crtn041",
	"factory_crtn042",
	"factory_crtn043",
	"factory_crtn044",
	"factory_crtn045",
	"factory_crtn046",
	"factory_crtn047",
	"factory_crtn048",
	"factory_crtn049",
	"factory_crtn050",
	"factory_crtn051",
	"factory_crtn052",
	"factory_crtn053",
}


this.npcScriptPackList = {
	Bear = { TppDefine.MISSION_COMMON_PACK.LYCAON, TppDefine.MISSION_COMMON_PACK.WEST_TRUCK, TppDefine.MISSION_COMMON_PACK.WEST_TRUCK_ITEMBOX, "/Assets/tpp/pack/mission2/story/s10110/s10110_npc01.fpk" },	
	Volgin = { "/Assets/tpp/pack/mission2/story/s10110/s10110_npc02.fpk" },	
}





this.ENABLE_DEFAULT_HELI_MISSION_CLEAR = true


this.MAX_PLACED_LOCATOR_COUNT = 30








function this.OnLoad()
	Fox.Log("#### OnLoad ####")

	TppSequence.RegisterSequences{
		
		
		"Seq_Game_GoToFactory",		
		"Seq_Demo_Bed",				
		"Seq_Game_SearchTarget",	
		"Seq_Demo_Volgin",			
		"Seq_Game_Escape",			
		"Seq_Game_Escape2",			
		"Seq_Demo_MotherBase",			
		nil,
	}
	TppSequence.RegisterSequenceTable(sequences)
end





this.saveVarsList = {
	stopFollowing = false,
	AfterBreakingTunnel = false, 
	isGetIntel = false, 
	isInTunnel = false, 
	StartTravel_hill_factorySouth = false, 
	isLoadPlh = false,
	ConversationEnd_factorySouth = false,
	ConversationEnd_factory_gate = false,
	ConversationEnd_factory_end = false,
	isDeadDriver = false,
	
	isInTunnelAfter = false,
	isInTunnelBefore = false,
	inInGateBefore = false,
	isClearGate = false,
	isDamagedPlh = false,
	
	hill_JinmonNum = 0,
	fS_JinmonNum = 0,
	
	flag1 = false,
	flag2 = false,
	flag3 = false,
	flag4 = false,
	flag5 = false,
	flag6 = false,
	flag7 = false,
	
	flag8 = false,
	flag9 = false,
	flag10 = false,
	flag11 = false,
	flag12 = false,
	flag13 = false,
	flag14 = false,
	
	flag15 = false,
	flag16 = false,
	Count1 = 0,
	Count2 = 0,
	Count3 = 0,
	Count4 = 0,
	Count5 = 0,
	Count6 = 0,
	Count7 = 0,
	Count8 = 0,
	Count9 = 0,
	Count10 = 0,
	Count11 = 0,
	Count12 = 0,
	Count13 = 0,
	Count14 = 0,
	Count15 = 0,
}

this.missionVarsList = {
	BoyIsDead = false, 
	VOLGIN_LIFE_VANISHED = false, 
	VOLGIN_LIFE_VANISHED_FOREVER = false, 
	isBreakFrame = false, 
	isBreakWTTR = false, 
	isBreakWTTK0000 = false, 
	isBreakWTTK0001 = false, 
	HeliClear = false, 
	isKilledByVolgin = false, 
	
	DAMAGED_TYPE_BULLET_NORMAL = false, 
	DAMAGED_TYPE_BULLET_STAGGER = false, 
	DAMAGED_TYPE_BLOW = false, 
	DAMAGED_TYPE_BLAST_ABSORB = false, 
	DAMAGED_TYPE_VEHICLE = false, 
	DAMAGED_TYPE_SHOCK = false, 
	DAMAGED_TYPE_LIGHTNING = false, 
	DAMAGED_TYPE_SMOKE = false, 
	DAMAGED_TYPE_SLEEP = false, 
	DAMAGED_TYPE_FAINT = false, 
	DAMAGED_TYPE_WATER = false, 
	DAMAGED_TYPE_RAIN = false, 
	DAMAGED_TYPE_PUDDLE = false, 
	DAMAGED_TYPE_LAKE = false, 
	DAMAGED_TYPE_STEEL_FRAME = false, 
	DAMAGED_TYPE_MANTIS_DODGED = false, 
	DAMAGED_TYPE_MANTIS_DAMAGED = false, 
	DAMAGED_TYPE_MANTIS_DAMAGED2 = false,
	VolginFulton = false,
	VolginFultonFinished = false,
	DAMAGED_TYPE_WATER_GUN_1 = false, 
	DAMAGED_TYPE_WATER_GUN_2 = false, 
	DAMAGED_TYPE_WATER_GUN_3 = false, 
	
	isNotOpposite = false,
}


this.checkPointList = {
	"CHK_MissionStart",		
	"CHK_FinishBedDemo",
	"CHK_FinishVolginDemo",
	"CHK_AfterBreaking",
	"CHK_MotherBaseDemo",
	nil
}


this.REVENGE_MINE_LIST = {"mafr_hill"}


if TppLocation.IsMiddleAfrica() then
	this.baseList = {
		"hill",
		"factorySouth",
		"factory",
		"hillNorth",
		"factoryWest",
		nil
	}
end







this.missionObjectiveDefine = {
	
	default_area_factory = {
		gameObjectName = "10110_marker_factory", goalType = "moving", viewType = "all", visibleArea = 5, randomRange = 5, 
		setNew = true, 
		announceLog = "updateMap", 
		mapRadioName = "s0110_mprg0010",
		langId = "marker_info_mission_targetArea",
	},
	rv_fake = {
		gameObjectName = "10110_marker_fake_rv", goalType = "moving", viewType = "all", announceLog = "updateMap",
	},
	rv_fake_off = {
		announceLog = "updateMap",
	},
	
	default_photo = {
		photoId = 10,
		addFirst = true,
		photoRadioName = "s0110_mirg0010",
    },
	
	default_subGoal = {
		subGoalId= 0,
    },
	VolginDemoAfter_subGoal = {
		announceLog = "updateMissionInfo",
		subGoalId= 1,
    },
    
	MissionTask_SearchBoy = {
		missionTask = { taskNo=0, isNew=true, isComplete=false },
	},
	ClearTask_SearchBoy = {
		missionTask = { taskNo=0, isComplete=true },
	},
   	MissionTask_Vanish_Mantis = {
		missionTask = { taskNo=1, isNew=true, isComplete=false, isFirstHide=true },
	},
   	ClearTask_Vanish_Mantis = {
		missionTask = { taskNo=1, isNew=true },
	},
	MissionTask_Vanish_Volgin = {
		missionTask = { taskNo=2, isNew=true, isComplete=false, isFirstHide=true },
	},
	ClearTask_Vanish_Volgin = {
		missionTask = { taskNo=2, isNew=true },
	},
	MissionTask_GetIntel = {
		missionTask = { taskNo=3, isNew=true, isComplete=false, isFirstHide=true },
	},
	ClearTask_GetIntel = {
		announceLog = "updateMap",
		missionTask = { taskNo=3, isNew=true, isComplete=true },
		showEnemyRoutePoints = { groupIndex = 0, width = 50.0,
			points = {
				Vector3( 2606.7578125, 93.552062988281, -942.40093994141 ),
				Vector3( 2578.4436035156, 70.956268310547, -826.59613037109 ),
				Vector3( 2444.5803222656, 70.956268310547, -793.40582275391 ),
				Vector3( 2399.6296386719, 82.239875793457, -767.73284912109 ),
				Vector3( 2363.3200683594, 87.696304321289, -636.19348144531 ),
				Vector3( 2344.3688964844, 84.880355834961, -575.40319824219 ),
				Vector3( 2311.5583496094, 77.728630065918, -534.3505859375 ),
				Vector3( 2313.822265625, 75.475875854492, -449.54769897461 ),
				Vector3( 2303.1135253906, 70.836097717285, -372.11947631836 ),
				Vector3( 2311.6911621094, 73.112930297852, -328.18984985352 ),
				Vector3( 2338.9208984375, 69.163764953613, -177.81100463867 ),
			},
		},
	},
	MissionTask_Jackal = {
		missionTask = { taskNo=4, isNew=true, isComplete=false, isFirstHide=true },
	},
	ClearTask_Jackal = {
		missionTask = { taskNo=4, isNew=true, isComplete=true },
	},
	MissionTask_Talk = {
		missionTask = { taskNo=5, isNew=true, isComplete=false, isFirstHide=true },
	},
	ClearTask_Talk = {
		missionTask = { taskNo=5, isNew=true, isComplete=true },
	},

	
	targetCpSetting = {
		targetBgmCp = "mafr_factory_cp",
	},
	
	
	area_Intel_factorySouth = {
		gameObjectName = "10110_marker_Intel_factorySouth", 
	},
	
	area_Intel_factorySouth_get = {
		
	},
	
	area_Intel_factorySouth_lost = {
	},
	
	AchieveObjectives = {
		announceLog = "achieveAllObjectives",
	},
	
	UpdateMap = {
		announceLog = "updateMap",
	},
	
	clear_photo = {
		photoId = 10,
	},
}


this.specialBonus = {
        first = {
                missionTask = { taskNo = 1 },
        },
        second = {
                missionTask = { taskNo = 2 },
        }
}










this.missionObjectiveTree = {
	rv_fake_off = {
		rv_fake = {
			default_area_factory = {},
			targetCpSetting = {},
		},
	},
	VolginDemoAfter_subGoal = {
		default_subGoal = {},
	},
	ClearTask_SearchBoy = {
		MissionTask_SearchBoy = {},
	},
	ClearTask_Vanish_Volgin = {
		MissionTask_Vanish_Volgin = {},
	},
	ClearTask_Vanish_Mantis = {
		MissionTask_Vanish_Mantis = {},
	},
	ClearTask_GetIntel = {
		MissionTask_GetIntel = {},
	},
	ClearTask_Jackal = {
		MissionTask_Jackal = {},
	},
	ClearTask_Talk = {
		MissionTask_Talk = {},
	},
	area_Intel_factorySouth_lost = {
		area_Intel_factorySouth_get = {
			area_Intel_factorySouth = {},
		},
    },
 	clear_photo = {
		default_photo = {},
	},   
}





this.missionObjectiveEnum = Tpp.Enum {
	"default_area_factory",
	"rv_fake",
	"rv_fake_off",
	"default_photo",
	"default_subGoal",
	"VolginDemoAfter_subGoal",
	"MissionTask_SearchBoy",
	"ClearTask_SearchBoy",
	
	
	
	
	"MissionTask_Vanish_Volgin",
	"ClearTask_Vanish_Volgin",
	"MissionTask_Vanish_Mantis",
	"ClearTask_Vanish_Mantis",
	"MissionTask_GetIntel",
	"ClearTask_GetIntel",
	"MissionTask_Jackal",
	"ClearTask_Jackal",
	"MissionTask_Talk",
	"ClearTask_Talk",
	"targetCpSetting",
	"area_Intel_factorySouth",
    "area_Intel_factorySouth_get",
    "area_Intel_factorySouth_lost",
    "AchieveObjectives",
    "UpdateMap",
    "clear_photo",
}






this.missionStartPosition = {
	
	orderBoxList = {
		"box_s10110_00",
	},
	
	helicopterRouteList = {
		
		"lz_drp_hillWest_S0000|lz_drp_hillWest_S_0000"
	},
}






this.NPC_ENTRY_POINT_SETTING = {
        [Fox.StrCode32("lz_drp_hill_I0000|rt_drp_hill_I_0000")] = {
                [EntryBuddyType.VEHICLE] = { Vector3(2152.182, 55.992, 386.675), TppMath.DegreeToRadian( 80 ) }, 
                [EntryBuddyType.BUDDY] = { Vector3(2155.664, 55.679, 372.972), TppMath.DegreeToRadian( 60 ) }, 
        },
}







 
function this.MissionPrepare()
	local missionName = TppMission.GetMissionName()
	Fox.Log("*** " .. tostring(missionName) .. " MissionPrepare ***")
	
	
	TppScriptBlock.PreloadRequestOnMissionStart{
		{ demo_block = "Demo_GetIntel" },
	}
	
	
	TppUiCommand.InitAllEnemyRoutePoints()
	
	
	
	TppPlayer.AddTrapSettingForIntel{
			intelName = "Intel_factorySouth",
			autoIcon = true,
			identifierName = "GetIntelIdentifier",
			locatorName = "GetIntel_factorySouth",
			gotFlagName = "isGetIntel",
			trapName = "Trap_GetIntel_factorySouth",
			markerObjectiveName = "area_Intel_factorySouth",
			markerTrapName = "Trap_ArriveAtfactorySouthBuild2F",
	}
		
	
	TppScriptBlock.RegisterCommonBlockPackList( "npc_block", this.npcScriptPackList )
	
	
	function this.OnGameOver( gameOverType )
		Fox.Log("*** " .. tostring(gameOverType) .. " OnGameOver ***")
		
		if TppMission.CheckGameOverDemo( TppDefine.GAME_OVER_TYPE.PLAYER_DEAD ) and mvars.isKilledByVolgin == true then
			local gameObjectId = GameObject.GetGameObjectId( "Player" )
			Player.RequestToPlayCameraNonAnimation{
				characterId = gameObjectId, 
				isFollowPos = false,	
				isFollowRot = true,	
				followTime = 7,	
				followDelayTime = 0.1,	
				




				candidateRots = { {120, -50},},
				skeletonNames = {"SKL_004_HEAD",},	
				



				skeletonCenterOffsets = { Vector3(0,0,0) },
				skeletonBoundings = { Vector3(0,0.45,0) },
				offsetPos = Vector3(0.4,1.3,-2.0),	
				focalLength = 30.0,	
				aperture = 10.000,	
				timeToSleep = 10,	
				fitOnCamera = false,	
				timeToStartToFitCamera = 0.01,	
				fitCameraInterpTime = 0.24,	
				diffFocalLengthToReFitCamera = 16,	
			}
		
		elseif mvars.BoyIsDead == true then
			Fox.Log("Target boy is dead")
			TppPlayer.SetTargetDeadCamera{ gameObjectName = "TppHostage2GameObjectLocator"}
			TppMission.ShowGameOverMenu{ delayTime = TppDefine.GAME_OVER_TARGET_DEAD_DEMO_TIME }
			return true
		else
			Fox.Log("Normal_Dead")
		end
	end	
	
	TppMission.RegisterMissionSystemCallback{
		
		OnEstablishMissionClear = function(missionClearType)
			
			s10110_radio.PlayTelephoneRadio()
			
			gvars.mbFreeDemoPlayRequestFlag[TppDefine.MB_FREEPLAY_DEMO_REQUESTFLAG_DEFINE.PlayAfterDethFactory] = true
			if missionClearType == TppDefine.MISSION_CLEAR_TYPE.ON_FOOT then
				TppTerminal.ReserveHelicopterSoundOnMissionGameEnd()	
				TppPlayer.PlayMissionClearCamera()
				TppMission.MissionGameEnd{
					loadStartOnResult = false,
					
					fadeDelayTime = TppPlayer.MISSION_CLEAR_CAMERA_FADE_DELAY_TIME,
					
					delayTime = TppPlayer.MISSION_CLEAR_CAMERA_DELAY_TIME,					
				}
			else
				TppMission.MissionGameEnd()
				Fox.Log("MissionGameEndByHeli")
			end
		end,
		OnGameOver = this.OnGameOver,
		OnOutOfHotZoneMissionClear = this.ReserveMissionClear,
	}
end




function this.OnRestoreSVars()
	local missionName = TppMission.GetMissionName()
	Fox.Log("*** " .. tostring(missionName) .. " OnRestoreSVars ***")
	
	
	
	Fox.Log("Loading_npc_CheckPoint")
	this.CheckNpcScriptBlockLoad()
	
	GkEventTimerManager.StopAll()
		
end

function this.ReserveMissionClear()
	
	TppMission.ReserveMissionClear{
		missionClearType = TppDefine.MISSION_CLEAR_TYPE.ON_FOOT,
		nextMissionId = TppDefine.SYS_MISSION_ID.MTBS_FREE,
	}
	
	TppSound.StopSceneBGM()
	





end



	



function this.Messages()
	return
	StrCode32Table {
		GameObject = {
			{ 
				msg = "Fulton",
				func = function( GameObjectId, arg1, arg2, arg3 )
					local enemyId = GameObject.GetGameObjectId("sol_vip_lrrp_0000")
					local enemy_fS_Id = s10110_enemy.CheckRouteUsingSoldier("rts_Conversation_fS")
					local enemy_fW1_Id = s10110_enemy.CheckRouteUsingSoldier("rts_Conversation_fW1")
					local enemy_fW2_Id = s10110_enemy.CheckRouteUsingSoldier("rts_Conversation_fW2")
					if( gameObjectId == enemyId )then
						local enemy_fS_Id = s10110_enemy.CheckRouteUsingSoldier("rts_Conversation_fS")
						local enemy_fW1_Id = s10110_enemy.CheckRouteUsingSoldier("rts_Conversation_fW1")
						local enemy_fW2_Id = s10110_enemy.CheckRouteUsingSoldier("rts_Conversation_fW2")					
						TppEnemy.UnsetSneakRoute( enemy_fS_Id )
						TppEnemy.UnsetSneakRoute( enemy_fW1_Id )
						TppEnemy.UnsetSneakRoute( enemy_fW2_Id )
					elseif( gameObjectId == enemy_fS_Id )then
						svars.flag3 = true 
					elseif( gameObjectId == enemy_fW1_Id )then
						svars.flag4 = true 
					elseif( gameObjectId == enemy_fW2_Id )then
						svars.flag5 = true 
					end
				end,
			},
			
			{
				msg = "RoutePoint2",
				sender = this.TARGET_ENEMY_NAME,
				func = function (gameObjectId, routeId ,routeNode, messageId )
					Fox.Log("ConversationPoint")
					
					local enemyId = GameObject.GetGameObjectId("sol_vip_lrrp_0000")
					local enemy_fS_Id = s10110_enemy.CheckRouteUsingSoldier("rts_Conversation_fS")
					local enemy_fW1_Id = s10110_enemy.CheckRouteUsingSoldier("rts_Conversation_fW1")
					local enemy_fW2_Id = s10110_enemy.CheckRouteUsingSoldier("rts_Conversation_fW2")
					
					
					if messageId == StrCode32("route_factorySouth") then
						svars.ConversationEnd_factorySouth = true
						
						local lifeStatus = TppEnemy.GetLifeStatus( enemy_fS_Id )
						if(svars.flag1 == true)then
							
							s10110_radio.Speech_factorySouth( enemy_fS_Id )
						elseif(svars.flag2 == true)then
							
							s10110_radio.Speech_factorySouth( enemy_fS_Id )
						else
						end
						if TppEnemy.GetPhase("mafr_factorySouth_ob") > TppEnemy.PHASE.SNEAK or svars.flag3 == true or lifeStatus ~= TppGameObject.NPC_LIFE_STATE_NORMAL then
							s10110_enemy.Travel_factorySouth_factory()
						else
							Fox.Log("")
						end
					
					elseif messageId == StrCode32("route_factory_gate") then
						svars.ConversationEnd_factory_gate = true
						
						local lifeStatus = TppEnemy.GetLifeStatus( enemy_fW1_Id )
						if(svars.flag1 == true)then					
							
							s10110_radio.Speech_factory_gate( enemy_fW1_Id )
						elseif(svars.flag2 == true)then
							
							s10110_radio.Speech_factory_gate( enemy_fW1_Id )
						else
						end
						if TppEnemy.GetPhase("mafr_factoryWest_ob") > TppEnemy.PHASE.SNEAK or svars.flag4 == true or lifeStatus ~= TppGameObject.NPC_LIFE_STATE_NORMAL then
							s10110_enemy.Travel_factory()
						else
							Fox.Log("")
						end						
					
					elseif messageId == StrCode32("route_factory_end") then
						svars.ConversationEnd_factory_end = true
						
						local lifeStatus = TppEnemy.GetLifeStatus( enemy_fW2_Id )
						if(svars.flag1 == true)then	
							
							s10110_radio.Speech_factory_end( enemy_fW2_Id )
						elseif(svars.flag2 == true)then
							
							s10110_radio.Speech_factory_end( enemy_fW2_Id )
						else
						end
						if TppEnemy.GetPhase("mafr_factoryWest_ob") > TppEnemy.PHASE.SNEAK or svars.flag5 == true or lifeStatus ~= TppGameObject.NPC_LIFE_STATE_NORMAL then
							
							GameObject.SendCommand( enemyId, { id = "StartTravel", travelPlan = "" } )
							
							TppEnemy.SetSneakRoute( "sol_vip_lrrp_0000", "rt_factory_endpoint" )
							TppEnemy.SetCautionRoute( "sol_vip_lrrp_0000", "rt_factoryWest_c_0005" )
							Fox.Log("ConversationEnd_factory_end")
						else
							Fox.Log("")
						end
					
					elseif messageId == StrCode32("ReleaseTP") then					
						local enemyId = s10110_enemy.CheckRouteUsingSoldier("rts_Change_fW")
						TppEnemy.UnsetSneakRoute( enemyId )
					
					elseif messageId == StrCode32("BeforeFire") then
						
						local lifeStatus1 = TppEnemy.GetLifeStatus( enemy_fW_fire1 )
						local lifeStatus2 = TppEnemy.GetLifeStatus( enemy_fW_fire2 )
						
						if lifeStatus1 ~= TppGameObject.NPC_LIFE_STATE_NORMAL then
							TppEnemy.UnsetSneakRoute( enemy_fW_fire1 )
							TppEnemy.UnsetSneakRoute( enemy_fW_fire2 )
						elseif lifeStatus2 ~= TppGameObject.NPC_LIFE_STATE_NORMAL then
							TppEnemy.UnsetSneakRoute( enemy_fW_fire1 )
							TppEnemy.UnsetSneakRoute( enemy_fW_fire2 )						
						end
					end
				end
			},
			
			{
				msg = "RoutePoint2",
				func = function (gameObjectId, routeId ,routeNode, messageId )
					
					local enemy_fW_fire1 = s10110_enemy.CheckRouteUsingSoldier("rts_Fire_fW")
					local enemy_fW_fire2 = s10110_enemy.CheckRouteUsingSoldier("rts_Fire_fW2")
					if messageId == StrCode32("BeforeFire") then
						
						local lifeStatus1 = TppEnemy.GetLifeStatus( enemy_fW_fire1 )
						local lifeStatus2 = TppEnemy.GetLifeStatus( enemy_fW_fire2 )
						
						if lifeStatus1 == TppEnemy.LIFE_STATUS.NORMAL and lifeStatus2 == TppEnemy.LIFE_STATUS.NORMAL then
							Fox.Log("")
						else
							TppEnemy.UnsetSneakRoute( enemy_fW_fire1 )
							TppEnemy.UnsetSneakRoute( enemy_fW_fire2 )
						end
					else
					end
				end
			},			
			
			{
				
				msg = "ConversationEnd",
				func = function( cpGameObjectId, speechLabel, isSuccess )
					Fox.Log("ConversationEnd")
					
					if speechLabel == StrCode32( "speech090_EV010" ) then
					
						Fox.Log("ConversationEnd_factorySouth")
						s10110_enemy.Travel_factorySouth_factory()
					
					elseif speechLabel == StrCode32( "speech090_EV030" ) then
					
						Fox.Log("ConversationEnd_factory_gate")
						s10110_enemy.Travel_factory()
					
					elseif speechLabel == StrCode32( "speech090_EV040" ) then
						
						
						local enemyId = GameObject.GetGameObjectId("sol_vip_lrrp_0000")
						GameObject.SendCommand( enemyId, { id = "StartTravel", travelPlan = "" } )
						
						if(svars.flag1 == true)then
							
							local enemy_fW2_Id = s10110_enemy.CheckRouteUsingSoldier("rts_Conversation_fW2")
							TppEnemy.SetSneakRoute( enemy_fW2_Id, "rts_Change_fW" )
						elseif(svars.flag2 == true)then
							
							local enemy_fW2_Id = s10110_enemy.CheckRouteUsingSoldier("rts_Conversation_fW2")
							TppEnemy.SetSneakRoute( enemy_fW2_Id, "rts_Change_fW" )
						else
						end
						
						TppEnemy.SetSneakRoute( "sol_vip_lrrp_0000", "rt_factory_endpoint" )
						TppEnemy.SetCautionRoute( "sol_vip_lrrp_0000", "rt_factoryWest_c_0005" )
						Fox.Log("ConversationEnd_factory_end")
						
						local enemy_fS_Id = s10110_enemy.CheckRouteUsingSoldier("rts_Conversation_fS")
						local enemy_fW1_Id = s10110_enemy.CheckRouteUsingSoldier("rts_Conversation_fW1")
						
						TppEnemy.UnsetSneakRoute( enemy_fS_Id )
						TppEnemy.UnsetSneakRoute( enemy_fW1_Id )
						
					end
				end
			},
			{
				
				msg = "RouteEventFaild",
				func = function( gameObjectId, routeId, failureType)
					Fox.Log("FailedToGetInVehicle")
					
					TppRadio.ChangeIntelRadio( s10110_radio.intelRadioListDeadDriver )
					svars.isDeadDriver = true 
					if svars.ConversationEnd_factorySouth == true then
						Fox.Log("Continue_ConversationRoute")
					elseif svars.ConversationEnd_factorySouth == false and failureType == TppGameObject.ROUTE_EVENT_FAILED_TYPE_VEHICLE_GET_IN and gameObjectId == GameObject.GetGameObjectId("sol_vip_lrrp_0000") then
						TppEnemy.SetSneakRoute( "sol_vip_lrrp_0000", "rt_hill_h_0004")
						local enemyId = GameObject.GetGameObjectId("sol_vip_lrrp_0000")
						GameObject.SendCommand( enemyId, { id = "StartTravel", travelPlan = "" } )
						
						local enemy_fS_Id = s10110_enemy.CheckRouteUsingSoldier("rts_Conversation_fS")
						local enemy_fW1_Id = s10110_enemy.CheckRouteUsingSoldier("rts_Conversation_fW1")
						local enemy_fW2_Id = s10110_enemy.CheckRouteUsingSoldier("rts_Conversation_fW2")					
						TppEnemy.UnsetSneakRoute( enemy_fS_Id )
						TppEnemy.UnsetSneakRoute( enemy_fW1_Id )
						TppEnemy.UnsetSneakRoute( enemy_fW2_Id )
					end
				end
			},
			{	
				msg = "Dead",
				func = function( gameObjectId , attackerId , phase )
					local enemyId = GameObject.GetGameObjectId("sol_vip_lrrp_0000")
					local enemy_fS_Id = s10110_enemy.CheckRouteUsingSoldier("rts_Conversation_fS")
					local enemy_fW1_Id = s10110_enemy.CheckRouteUsingSoldier("rts_Conversation_fW1")
					local enemy_fW2_Id = s10110_enemy.CheckRouteUsingSoldier("rts_Conversation_fW2")
					if( gameObjectId == enemyId )then
						local enemy_fS_Id = s10110_enemy.CheckRouteUsingSoldier("rts_Conversation_fS")
						local enemy_fW1_Id = s10110_enemy.CheckRouteUsingSoldier("rts_Conversation_fW1")
						local enemy_fW2_Id = s10110_enemy.CheckRouteUsingSoldier("rts_Conversation_fW2")					
						TppEnemy.UnsetSneakRoute( enemy_fS_Id )
						TppEnemy.UnsetSneakRoute( enemy_fW1_Id )
						TppEnemy.UnsetSneakRoute( enemy_fW2_Id )
					elseif( gameObjectId == enemy_fS_Id )then
						svars.flag3 = true 
					elseif( gameObjectId == enemy_fW1_Id )then
						svars.flag4 = true 
					elseif( gameObjectId == enemy_fW2_Id )then
						svars.flag5 = true 
					end
				end
			},
			{
				msg = "VolginDamagedByType",
				func = function(gameObjectId, damageType)
					if (mvars.isBreakFrame == true) then
					Fox.Log( "VolginDamagedByType: " .. damageType )
						if (damageType == TppVolgin2.VOLGIN_DAMAGED_TYPE_BULLET_NORMAL and mvars.DAMAGED_TYPE_BULLET_NORMAL == false) then
							s10110_radio.PlayVolginDamaged_NormalRadio()
							mvars.DAMAGED_TYPE_BULLET_NORMAL = true 
						elseif (damageType == TppVolgin2.VOLGIN_DAMAGED_TYPE_STAGGER and mvars.DAMAGED_TYPE_BULLET_STAGGER == false) then
							s10110_radio.PlayVolginDamaged_StrongRadio()
							mvars.DAMAGED_TYPE_BULLET_STAGGER = true 
						elseif (damageType == TppVolgin2.VOLGIN_DAMAGED_TYPE_BLOW and mvars.DAMAGED_TYPE_BLOW == false) then
							s10110_radio.PlayVolginDamaged_BlastRadio()
							mvars.DAMAGED_TYPE_BLOW = true 
						elseif (damageType == TppVolgin2.VOLGIN_DAMAGED_TYPE_BLAST_ABSORB and mvars.DAMAGED_TYPE_BLAST_ABSORB == false) then
							s10110_radio.PlayVolginDamaged_ABSORBRadio()
							mvars.DAMAGED_TYPE_BLAST_ABSORB = true 
						elseif (damageType == TppVolgin2.VOLGIN_DAMAGED_TYPE_VEHICLE and mvars.DAMAGED_TYPE_VEHICLE == false) then
							
							mvars.DAMAGED_TYPE_VEHICLE = true 
						elseif (damageType == TppVolgin2.VOLGIN_DAMAGED_TYPE_SHOCK and mvars.DAMAGED_TYPE_SHOCK == false) then
							s10110_radio.PlayVolginDamaged_FAINTRadio()
							mvars.DAMAGED_TYPE_SHOCK = true 
						elseif (damageType == TppVolgin2.VOLGIN_DAMAGED_TYPE_LIGHTNING and mvars.DAMAGED_TYPE_LIGHTNING == false) then
							s10110_radio.PlayVolginDamaged_LIGHTNINGRadio()
							mvars.DAMAGED_TYPE_LIGHTNING = true 
						elseif (damageType == TppVolgin2.VOLGIN_DAMAGED_TYPE_SMOKE and mvars.DAMAGED_TYPE_SMOKE == false) then
							
							mvars.DAMAGED_TYPE_SMOKE = true 
						elseif (damageType == TppVolgin2.VOLGIN_DAMAGED_TYPE_SLEEP and mvars.DAMAGED_TYPE_SLEEP == false) then
							
							mvars.DAMAGED_TYPE_SLEEP = true 
						elseif (damageType == TppVolgin2.VOLGIN_DAMAGED_TYPE_FAINT and mvars.DAMAGED_TYPE_FAINT == false) then
							
							mvars.DAMAGED_TYPE_FAINT = true 
						elseif (damageType == TppVolgin2.VOLGIN_DAMAGED_TYPE_WATER and mvars.DAMAGED_TYPE_WATER == false) then
							s10110_radio.PlayVolginDamaged_WaterRadio()
							mvars.DAMAGED_TYPE_WATER = true 
						elseif (damageType == TppVolgin2.VOLGIN_DAMAGED_TYPE_RAIN and mvars.DAMAGED_TYPE_RAIN == false) then
							s10110_radio.PlayVolginDamaged_RainRadio()
							mvars.DAMAGED_TYPE_RAIN = true 
						elseif (damageType == TppVolgin2.VOLGIN_DAMAGED_TYPE_PUDDLE and mvars.DAMAGED_TYPE_PUDDLE == false) then
							
							mvars.DAMAGED_TYPE_PUDDLE = true 
						elseif (damageType == TppVolgin2.VOLGIN_DAMAGED_TYPE_LAKE and mvars.DAMAGED_TYPE_LAKE == false) then
							
							mvars.DAMAGED_TYPE_LAKE = true 
						elseif (damageType == TppVolgin2.VOLGIN_DAMAGED_TYPE_STEEL_FRAME and mvars.DAMAGED_TYPE_STEEL_FRAME == false) then
							
							mvars.DAMAGED_TYPE_STEEL_FRAME = true 
						elseif (damageType == TppVolgin2.VOLGIN_DAMAGED_TYPE_MANTIS_DODGED and mvars.DAMAGED_TYPE_MANTIS_DODGED == false) then
							s10110_radio.PlayMANTIS_DODGEDRadio()
							mvars.DAMAGED_TYPE_MANTIS_DODGED = true 
						elseif (damageType == TppVolgin2.VOLGIN_DAMAGED_TYPE_MANTIS_DAMAGED and mvars.DAMAGED_TYPE_MANTIS_DAMAGED == false and TppSequence.GetCurrentSequenceName() == "Seq_Game_Escape" ) then
							s10110_radio.PlayMANTIS_DAMAGEDRadio()
							mvars.DAMAGED_TYPE_MANTIS_DAMAGED = true 
							
							
							
							TppResult.AcquireSpecialBonus{
								first = { isComplete = true },
							}
						elseif (damageType == TppVolgin2.VOLGIN_DAMAGED_TYPE_MANTIS_DAMAGED and mvars.DAMAGED_TYPE_MANTIS_DAMAGED2 == false and TppSequence.GetCurrentSequenceName() == "Seq_Game_Escape2" ) then
							s10110_radio.PlayMANTIS_DAMAGEDRadio()
							mvars.DAMAGED_TYPE_MANTIS_DAMAGED2 = true 
							
							
							
							TppResult.AcquireSpecialBonus{
								first = { isComplete = true },
							}
						elseif (damageType == TppVolgin2.VOLGIN_DAMAGED_TYPE_WATER_GUN_1 and mvars.DAMAGED_TYPE_WATER_GUN_1 == false and TppSequence.GetCurrentSequenceName() == "Seq_Game_Escape2" ) then
							s10110_radio.PlayVolginDamaged_WATER_GUN_LowRadio()
							mvars.DAMAGED_TYPE_WATER_GUN_1 = true 
						elseif (damageType == TppVolgin2.VOLGIN_DAMAGED_TYPE_WATER_GUN_2 and mvars.DAMAGED_TYPE_WATER_GUN_2 == false and TppSequence.GetCurrentSequenceName() == "Seq_Game_Escape2" ) then
							s10110_radio.PlayVolginDamaged_WATER_GUN_HighRadio()
							mvars.DAMAGED_TYPE_WATER_GUN_2 = true 
						elseif (damageType == TppVolgin2.VOLGIN_DAMAGED_TYPE_WATER_GUN_3 and mvars.DAMAGED_TYPE_WATER_GUN_3 == false and TppSequence.GetCurrentSequenceName() == "Seq_Game_Escape2" ) then
							s10110_radio.PlayVolginDamaged_WATER_GUN_HighRadio()
							mvars.DAMAGED_TYPE_WATER_GUN_3 = true 
						else
							Fox.Log("NoDamaged")
						end
					else
						Fox.Log("NoDamagedBeforeBreakWall")
					end
				end
				},

			nil
		},
		Trap = {
			{
				msg = "Enter",
				sender = "Trap_LoadDemo_A",
				func = function ()
					
					Fox.Log("Load_Demo_GetIntel")
					TppScriptBlock.LoadDemoBlock("Demo_GetIntel")
				end		
			},
			{
				msg = "Enter",
				sender = "Trap_LoadDemo_B",
				func = function ()
					if TppSequence.GetCurrentSequenceName() == "Seq_Game_SearchTarget" then
						
						Fox.Log("Load_volginDemoName")
						TppScriptBlock.LoadDemoBlock("volginDemoName")
					else
						
						Fox.Log("Load_bedDemoName")
						TppScriptBlock.LoadDemoBlock("bedDemoName")
					end
				end		
			},
			{
				msg = "Enter",
				sender = "Trap_Load_Plh",
				func = function ()
					
					TppScriptBlock.Load( "npc_block", "Volgin", true )
					
					GameObject.SendCommand( GameObject.GetGameObjectId("sol_vip_lrrp_0000") , { id="SetEnabled", enabled=false } )
					
					svars.isLoadPlh = true
					
					
				end				
			},
			{
				msg = "Enter",
				sender = "Trap_Mist_ON",
				func = function ()
					
					WeatherManager.RequestTag("factory_fog", 5 )
					TppWeather.RequestWeather( TppDefine.WEATHER.FOGGY, 10, { fogDensity=0.00, fogType=WeatherManager.FOG_TYPE_EERIE, } )
					svars.flag15 = true 
					svars.flag16 = false
					
					if ( svars.flag6 == false ) then
						Fox.Log("SetPhaseBGM_Mist")
						TppSound.SetPhaseBGM( "bgm_volgin_phase_02" )
						svars.flag6 = true
					else
					end
				end				
			},
			{
				msg = "Enter",
				sender = "Trap_Mist2_ON",
				func = function ()
					
					WeatherManager.RequestTag("factory_fog", 0 )
					TppWeather.RequestWeather( TppDefine.WEATHER.FOGGY, 5, { fogDensity=0.03, fogType=WeatherManager.FOG_TYPE_EERIE, } )
					svars.flag16 = true 
					svars.flag15 = false
				end				
			},
			{
				msg = "Enter",
				sender = "Trap_Mist_OFF",
				func = function ()
					
					WeatherManager.RequestTag("default", 5 )
					TppWeather.CancelRequestWeather( TppDefine.WEATHER.CLOUDY, 5 )
					
					TppSound.ResetPhaseBGM()
					svars.flag6 = false
				end				
			},
			{ 
				msg = "Enter",
				sender = "Trap_MistTag",
				func = function ()
					
					WeatherManager.RequestTag("factory_fog", 0 )
					if svars.flag15 == true then
						TppWeather.RequestWeather( TppDefine.WEATHER.FOGGY, 5, { fogDensity=0.00, fogType=WeatherManager.FOG_TYPE_EERIE, } )
					else
						TppWeather.RequestWeather( TppDefine.WEATHER.FOGGY, 5, { fogDensity=0.03, fogType=WeatherManager.FOG_TYPE_EERIE, } )
					end
				end,
				option = { isExecMissionPrepare = true }
			},
			{
				msg = "Enter",
				sender = "Trap_shadow_long_ON",
				func = function ()
					WeatherManager.RequestTag("shadow_long", 3 )
				end				
			},
			{
				msg = "Enter",
				sender = "Trap_shadow_long_OFF",
				func = function ()
					WeatherManager.RequestTag("default", 3 )
				end				
			},
			{	
				msg = "Enter",
				sender = "jingleCharredTrap",
				func = function ()
					if svars.flag7 == false then
						GkEventTimerManager.Start( "timer_JingleCharred", 1 )
					else
					end
				end
			},
			{	
				msg = "Exit",
				sender = "jingleCharredTrap",
				func = function ()
					GkEventTimerManager.Stop( "timer_JingleCharred" )	
				end
			},
			








			{
				msg = "Enter",
				func = function( trapName, gameObjectId )
					Fox.Log( "s10100_sequence.Messages(): trapName:" .. tostring( trapName ) .. ", gameObjectId:" .. tostring( gameObjectId ) )
				end
			},
			{
				msg = "Enter",
				sender = "Trap_ChangePhase",
				func = function ()
					local gameObjectId = GameObject.GetGameObjectId( "mafr_factoryWest_ob" )
					local command = { id = "SetPhase", phase = TppGameObject.PHASE_SNEAK }
					GameObject.SendCommand( gameObjectId, command )
				end				
			},
			
			{
				msg = "Enter",
				sender = "Trap_BeforeHill",
				func = s10110_radio.PlayBeforeHillRadio
			},
			{
				msg = "Enter",
				sender = "Trap_ThroughHill",
				func = function()
					svars.flag8 = true 
				end
			},
			{
				msg = "Enter",
				sender = "Trap_BeforeCheckStation",
				func = s10110_radio.PlayCheckStationRadio
			},
			{
				msg = "Enter",
				sender = "Trap_BeforeBridge",
				func = s10110_radio.PlayBeforeBridgeRadio
			},
			{
				msg = "Enter",
				sender = "Trap_Opposite",
				func = s10110_radio.PlayOppositeRadio
			},
			{
				msg = "Enter",
				sender = "Trap_InTunnel",
				func = s10110_radio.PlayInTunnelRadio
			},
			{
				msg = "Enter",
				sender = "Trap_AfterRiver",
				func = s10110_radio.PlayAfterRiverRadio
			},
			{
				msg = "Enter",
				sender = "Trap_BeforeHumanFactory",
				func = s10110_radio.PlayBeforeHumanFactoryRadio
			},
			






			{
				msg = "Enter",
				sender = "Trap_Mist",
				func = s10110_radio.PlayMistRadio
			},
		},
		Timer = {
			{
				msg = "Finish",	sender = "timer_JingleCharred",	
				func = function()
					local phase_hill	= TppEnemy.GetPhase("mafr_hill_cp")
					local checkInCamera = Player.AddSearchTarget{
						name					= "charred_locator",
						dataIdentifierName		= "jingle_Identifier",
						keyName					= "jingle_charred",
						distance				= 19,
						checkImmediately		= true,
					}
					
					if checkInCamera == true and Player.GetGameObjectIdIsRiddenToLocal() == 65535 and Player.IsOnTheLoadingPlatform() == false and phase_hill == TppEnemy.PHASE.SNEAK	 then
						
						if PlayerInfo.OrCheckStatus{ PlayerStatus.DASH, PlayerStatus.BINOCLE, } then
							GkEventTimerManager.Start( "timer_JingleCharred", 1 )		
						else	
							
							TppSoundDaemon.PostEvent( 'sfx_s_bgm_dead_body' )
							
							Player.StartTargetConstrainCamera {
								cameraType = PlayerCamera.Around,		
								force = false,							
								fixed = false,							
								recoverPreOrientation = false,			
								dataIdentifierName = "jingle_Identifier",	
								keyName = "jingle_charred",				
								interpTime = 1.0,						
								time = 3,								
								focalLength = 32.0,						
								focalLengthInterpTime = 1.5,			
								minDistance = 2.0,						
								maxDistanve = 20.0,						
								doCollisionCheck = false,				
							}
							svars.flag7 = true
							GkEventTimerManager.Stop( "timer_JingleCharred" )	
						end
					else
						GkEventTimerManager.Start( "timer_JingleCharred", 1 )		
					end
				end
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


		Player = {
			{
				msg = "GetIntel", sender = "Intel_factorySouth",
				func = function( intelNameHash )
					TppPlayer.GotIntel( intelNameHash )
					
					s10110_demo.PlayGetIntel_factorySouth(func)					
					
					TppRadio.SetOptionalRadio("Set_s0110_oprg0020")
				end,					
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

        Subtitles = {
			{
				
				msg = "SubtitlesEndEventMessage",                               
						func = function( speechLabel, status )
						Fox.Log( "####SubtitlesEndEventMessage ####")
						if (speechLabel == SubtitlesCommand:ConvertToSubtitlesId( "stpf1000_099246_0_ened_af" )) then 
							TppMission.UpdateObjective{	objectives = { "ClearTask_Talk" } }
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
		nil,
	}
end


function this.Initialize_DAMAGED_TYPE()
	mvars.DAMAGED_TYPE_BULLET_NORMAL = false 
	mvars.DAMAGED_TYPE_BULLET_STAGGER = false 
	mvars.DAMAGED_TYPE_BLOW = false 
	mvars.DAMAGED_TYPE_BLAST_ABSORB = false 
	mvars.DAMAGED_TYPE_VEHICLE = false 
	mvars.DAMAGED_TYPE_SHOCK = false 
	mvars.DAMAGED_TYPE_LIGHTNING = false 
	mvars.DAMAGED_TYPE_SMOKE = false 
	mvars.DAMAGED_TYPE_SLEEP = false 
	mvars.DAMAGED_TYPE_FAINT = false 
	mvars.DAMAGED_TYPE_WATER = false 
	mvars.DAMAGED_TYPE_RAIN = false 
	mvars.DAMAGED_TYPE_PUDDLE = false 
	mvars.DAMAGED_TYPE_LAKE = false 
	mvars.DAMAGED_TYPE_STEEL_FRAME = false 
	mvars.DAMAGED_TYPE_MANTIS_DODGED = false 
	mvars.DAMAGED_TYPE_MANTIS_DAMAGED = false 
	mvars.DAMAGED_TYPE_MANTIS_DAMAGED2 = false
	mvars.VolginFulton = false
	mvars.DAMAGED_TYPE_WATER_GUN_1 = false
	mvars.DAMAGED_TYPE_WATER_GUN_2 = false
	mvars.DAMAGED_TYPE_WATER_GUN_3 = false
	mvars.VolginFultonFinished = false
end


function this.CheckNpcScriptBlockLoad()

	if TppSequence.GetMissionStartSequenceName() == "Seq_Game_Escape" 
		or TppSequence.GetMissionStartSequenceName() == "Seq_Game_Escape2" 
		or TppSequence.GetMissionStartSequenceName() == "Seq_Demo_Volgin" 
		or TppSequence.GetMissionStartSequenceName() == "Seq_Game_SearchTarget" then
		Fox.Log("Load Volgin Block!")
		TppScriptBlock.Load( "npc_block", "Volgin", true )
	else
		Fox.Log("Load Bear Block!")
		TppScriptBlock.Load( "npc_block", "Bear", true )
	end










end

this.OnFultonRecovered = function( s_gameObjectId )
	Fox.Log( "s10110_sequence.OnFultonRecovered( " .. s_gameObjectId .. " )" )	
	if Tpp.IsAnimal( s_gameObjectId ) then
		Fox.Log( "*** this.Messages Fulton Animal ***")
		local animalType = GameObject.GetTypeIndex( s_gameObjectId )
		
		if animalType == TppGameObject.GAME_OBJECT_TYPE_JACKAL and svars.isInTunnelBefore == true then
			TppMission.UpdateObjective{
				objectives = { "ClearTask_Jackal" },
			} 
		else
			Fox.Log("NotClear_MissionTask_Jackal")
		end
	else
		Fox.Log("NotClear_MissionTask_Jackal")
	end
end































































sequences.Seq_Game_GoToFactory = {

	Messages = function( self ) 
		return
		StrCode32Table {
			GameObject = {
			

















				{
					msg = "Fulton",
					func = function ( s_gameObjectId )
						local animalType = GameObject.GetTypeIndex( s_gameObjectId )
						if animalType == TppGameObject.GAME_OBJECT_TYPE_JACKAL and svars.isInTunnelBefore == true then
							TppMission.UpdateObjective{
								objectives = { "ClearTask_Jackal" },
							} 
						else
							Fox.Log("NotClear_MissionTask_Jackal")
						end					
					end,
				},
				{
					msg = "Dead",
					func = function( gameObjectId )
						if ( gameObjectId == GameObject.GetGameObjectId( "sol_vip_lrrp_0000" ) ) then
							
							Fox.Log("DeadDriver")
							TppRadio.ChangeIntelRadio( s10110_radio.intelRadioListDeadDriver )
							svars.isDeadDriver = true
						else
						end
					end
				},
				{	
					msg = "Damage" ,
					func = function ( gameObjectId , attackId , attackGameObjectId )
						Fox.Log("gameObjectId = "..gameObjectId.." !!")
						if gameObjectId == GameObject.GetGameObjectId("TppHostage2GameObjectLocator0000") and TppDamage.IsActiveByAttackId( attackId ) == true then
							svars.isDamagedPlh = true
						else
							Fox.Log("damage Character is not Demo_Plh ...")
						end
					end
				},
			},
			Timer = {
				{
					msg = "Finish",
					sender = "BrokenWatorTower",
					func = function()
						
						Fox.Log("finish_WatorTower_breaking")
					end
				},
			},

			Trap = {
				{
					msg = "Enter",
					sender = "Trap_StartFollowing",
					func = function()
						
						TppEnemy.UnsetCautionRoute( "sol_vip_lrrp_0000" )
						
						if svars.StartTravel_hill_factorySouth == false then
							Fox.Log( "StartTravel_hill_factorySouth" )
							s10110_enemy.Travel_hill_factorySouth()
							svars.StartTravel_hill_factorySouth = true

						else
							Fox.Log( "Not StartTravel_hill_factorySouth" )
						end
					end
				},
				{
					msg = "Enter",
					sender = "Trap_BeforeTunnel", 
					func = function()
						if svars.flag12 == false then
							Fox.Log("*** s10110_radio.PlayBeforeTunnelRadio ***")
							s10110_radio.PlayBeforeTunnelRadio()
							svars.flag12 = true
						else
						end
					end
				},
				











































				
















				{
					msg = "Enter",
					sender = "Trap_HideGimmick",	
					func = function()
					Fox.Log("#### Enter Trap_HideGimmick ####")
						TppDataUtility.SetVisibleDataFromIdentifier( "GimmickIdentifier", "Volgin_BrokenWall", false, true) 
						TppDataUtility.SetVisibleDataFromIdentifier( "GimmickIdentifier", "Volgin_BrokenTunnel", false, true) 
						
						TppDataUtility.SetVisibleDataFromIdentifier( "GimmickIdentifier", "Broken_stfr0001", false, true) 
						TppDataUtility.SetVisibleDataFromIdentifier( "GimmickIdentifier", "Broken_stfr0002", false, true) 
						
						TppDataUtility.SetVisibleDataFromIdentifier( "GimmickIdentifier", "door_after", true, true)
						TppDataUtility.SetVisibleDataFromIdentifier( "GimmickIdentifier", "door_before", false, true)
						
						TppDataUtility.SetVisibleDataFromIdentifier( "GimmickIdentifier", "bed_before", true, true)
						TppDataUtility.SetEnableDataFromIdentifier( "GimmickIdentifier", "Wall_bed_after", false )
						
						TppDataUtility.SetEnableDataFromIdentifier( "GimmickIdentifier", "Wall_door", false )
						
						TppDataUtility.SetEnableDataFromIdentifier( "GimmickIdentifier", "Wall_tunnel", false )
						TppDataUtility.SetEnableDataFromIdentifier( "GimmickIdentifier", "Wall_tunnel_after", false )
						TppDataUtility.SetEnableDataFromIdentifier( "GimmickIdentifier", "Wall_rock", false )
						
						
						
						
						
						
						














































						
						for i, gimmickId in pairs( resetGimmickIdTable ) do
							TppGimmick.ResetGimmick{ gimmickId = gimmickId, searchFromSaveData = false }
						end
						for i, gimmickId in pairs( resetVolginGimmickIdTable ) do
							TppGimmick.ResetGimmick{ gimmickId = gimmickId, searchFromSaveData = false }
						end
						for i, gimmickId in pairs( resetCrtnIdTable ) do
							TppGimmick.ResetGimmick{ gimmickId = gimmickId, searchFromSaveData = false }
						end
						
					end
				},
				
				{
					msg = "Enter",
					sender = "Trap_LycSleep",
					func = function()
						local timeOfDay = TppClock.GetTimeOfDay()
						if (timeOfDay == "day" and svars.isLoadPlh == false ) then
							TppAnimal.SetHerdRoute( "TppJackal", "JackalGameObjectLocator0002", "Lyc_d_0000" )
							TppAnimal.SetHerdRoute( "TppJackal", "JackalGameObjectLocator0003", "Lyc_d_0001" )
						elseif (timeOfDay == "night" and svars.isLoadPlh == false ) then
							TppAnimal.SetHerdRoute( "TppJackal", "JackalGameObjectLocator0002", "Lyc_n_0000" )
							TppAnimal.SetHerdRoute( "TppJackal", "JackalGameObjectLocator0003", "Lyc_n_0001" )
						else
						end
					end					
				},
				
				{
					msg = "Enter",
					sender = "Trap_Fire_fW",
					func = function()
						if svars.flag1 == true then 
							local enemy_fW_fire1_Id = s10110_enemy.CheckRouteUsingSoldier("rt_factoryWest_d_0001")
							local enemy_fW_fire2_Id = s10110_enemy.CheckRouteUsingSoldier("rt_factoryWest_d_0002")
							TppEnemy.SetSneakRoute( enemy_fW_fire1_Id, "rts_Fire_fW" , 0)
							TppEnemy.SetSneakRoute( enemy_fW_fire2_Id, "rts_Fire_fW2", 0)
						elseif svars.flag2 == true then
							local enemy_fW_fire1_Id = s10110_enemy.CheckRouteUsingSoldier("rt_factoryWest_n_0003")
							local enemy_fW_fire2_Id = s10110_enemy.CheckRouteUsingSoldier("rt_factoryWest_n_0002")
							TppEnemy.SetSneakRoute( enemy_fW_fire1_Id, "rts_Fire_fW" , 0)
							TppEnemy.SetSneakRoute( enemy_fW_fire2_Id, "rts_Fire_fW2", 0)
						else
						end
					end					
				},
				{
					msg = "Enter",
					sender = "Trap_Opposite2",
					func = function ()
						if ( mvars.isNotOpposite == false ) then
							s10110_radio.PlayOpposite2Radio()
						else
						end
					end
				},
				{
					msg = "Enter",
					sender = "Trap_Opposite2Cancel",
					func = function ()
						mvars.isNotOpposite = true
					end
				},
				{
					msg = "Enter",
					sender = "Trap_crto",
					func = function()
						Fox.Log( "Enter_Trap_crto" )
						
						Gimmick.PushGimmick(-1,"gntn_crto001_vrtn001_gim_n0007|srt_gntn_crto001_vrtn001","/Assets/tpp/level/location/mafr/block_large/factory/mafr_factory_asset.fox2", Vector3(0.5,0.5,0.5), 1 )
					end					
				},
				{
					msg = "Enter",
					sender = "Trap_gnsc",	
					func = function()
						Gimmick.BreakGimmick(TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION, "mafr_gnsc003_vrtn001_gim_n0000|srt_mafr_gnsc003_vrtn001","/Assets/tpp/level/location/mafr/block_large/factory/mafr_factory_asset.fox2", 0)
						
					end
				},
				{
					msg = "Enter",
					sender = "Trap_factoryBGM_OFF",	
					func = function()
						TppSound.StopSceneBGM()
					end
				},
				{
					msg = "Enter",
					sender = "Trap_factoryBGM_ON",	
					func = function()
						TppSound.SetSceneBGM( "bgm_factory" )
					end
				},
				{
					msg = "Enter",
					sender = "Trap_BedDemo",	
					func = function()
						TppSequence.SetNextSequence( "Seq_Demo_Bed" )
					end
				},				
				{
					msg = "Enter",
					sender = "Trap_InTunnelBeforeON",
					func = function ()
						
						TppRadio.SetOptionalRadio("Set_s0110_oprg0030")
						svars.inInGateBefore = false
						svars.isInTunnelBefore = true
						svars.isClearGate = true
					end		
				},
				{
					msg = "Enter",
					sender = "Trap_InTunnelBeforeOFF",
					func = function ()
						
						TppRadio.SetOptionalRadio("Set_s0110_oprg0020")
						svars.isInTunnelBefore = false
						svars.inInGateBefore = true
					end		
				},
				{
					msg = "Enter",
					sender = "Trap_InTunnelAfterON",
					func = function ()
						
						TppRadio.SetOptionalRadio("Set_s0110_oprg0040")
						svars.isInTunnelBefore = false
						svars.isInTunnelAfter = true
					end		
				},
				{
					msg = "Enter",
					sender = "Trap_InTunnelAfterOFF",
					func = function ()
						
						TppRadio.SetOptionalRadio("Set_s0110_oprg0030")
						svars.isInTunnelAfter = false
						svars.isInTunnelBefore = true
					end		
				},
				nil,
			},
			nil
		}
	end,

	OnEnter = function()
		if TppGameStatus.IsSet("Mission", "S_IS_ONLINE") then
			TppCoder.SetWorldCenter(Vector3(2367.914, 73.63837, -262.42664))
			TppNetworkUtil.SessionEnableAccept( true )
			Dynamite.StartNearestEnemyThread()
		end

		Fox.Log( "s10110_sequence.sequences.Seq_Game_GoToFactory.OnEnter()" )
		
		TppTelop.StartCastTelop()
		
		if TppSequence.GetContinueCount() > 0 then
			TppRadio.Play( "s0110_rtrg0012" )
		else
		end		
		
		
		
		mvars.isNotOpposite = false
		
		TppScriptBlock.Load( "npc_block", "Bear", true )
		
		TppUiCommand.SetMisionInfoCurrentStoryNo(0)
		
		if ( svars.isLoadPlh == false ) then
			TppAnimal.SetHerdRoute( "TppJackal", "JackalGameObjectLocator0002", "Lyc_d_0000" )
			TppAnimal.SetHerdRoute( "TppJackal", "JackalGameObjectLocator0003", "Lyc_d_0001" )
			TppAnimal.SetHerdRoute( "TppJackal", "JackalGameObjectLocator", "Lyc_d_0003" )
			TppAnimal.SetHerdRoute( "TppJackal", "JackalGameObjectLocator0001", "Lyc_d_0002" )
		else
		end
		
		if svars.flag1 == false and svars.flag2 == false then 
			
			TppEnemy.SetCautionRoute( "sol_vip_lrrp_0000", "rt_hill_c_0005" )
			local timeOfDay = TppClock.GetTimeOfDay()
			if timeOfDay=="day" then
				
				local enemy_fS_Id = s10110_enemy.CheckRouteUsingSoldier("rt_factorySouth_d_0003")
				TppEnemy.SetSneakRoute( enemy_fS_Id, "rts_Conversation_fS" )
				TppEnemy.SetCautionRoute( enemy_fS_Id, "rt_factorySouth_c_0005" )								
				
				local enemy_fW1_Id = s10110_enemy.CheckRouteUsingSoldier("rt_factoryWest_d_0005")
				TppEnemy.SetSneakRoute( enemy_fW1_Id, "rts_Conversation_fW1" )
				TppEnemy.SetCautionRoute( enemy_fW1_Id, "rt_factoryWest_c_0002" )								
				
				local enemy_fW2_Id = s10110_enemy.CheckRouteUsingSoldier("rt_factoryWest_d_0000")
				TppEnemy.SetSneakRoute( enemy_fW2_Id, "rts_Conversation_fW2" )
				TppEnemy.SetCautionRoute( enemy_fW2_Id, "rt_factoryWest_c_0000" )								
				svars.flag1 = true
			elseif timeOfDay=="night" then	
				
				local enemy_fS_Id = s10110_enemy.CheckRouteUsingSoldier("rt_factorySouth_n_0003")
				TppEnemy.SetSneakRoute( enemy_fS_Id, "rts_Conversation_fS" )
				TppEnemy.SetCautionRoute( enemy_fS_Id, "rt_factorySouth_c_0005" )
				
				local enemy_fW1_Id = s10110_enemy.CheckRouteUsingSoldier("rt_factoryWest_n_0005")
				TppEnemy.SetSneakRoute( enemy_fW1_Id, "rts_Conversation_fW1" )
				TppEnemy.SetCautionRoute( enemy_fW1_Id, "rt_factoryWest_c_0002" )
				
				local enemy_fW2_Id = s10110_enemy.CheckRouteUsingSoldier("rt_factoryWest_n_0000")
				TppEnemy.SetSneakRoute( enemy_fW2_Id, "rts_Conversation_fW2" )
				TppEnemy.SetCautionRoute( enemy_fW2_Id, "rt_factoryWest_c_0000" )
				svars.flag2 = true
			end
		else
		end	
		
		
		if svars.StartTravel_hill_factorySouth == false then
			TppEnemy.SetSneakRoute( "sol_vip_lrrp_0000" , "rt_hill_h_0005")
		else
		end		
		
		
		TppHelicopter.SetDisableLandingZone{ landingZoneName = "lz_Escape1" }
		TppHelicopter.SetDisableLandingZone{ landingZoneName = "lz_Escape2" }
		TppHelicopter.SetDisableLandingZone{ landingZoneName = "lz_Escape3" }
		TppHelicopter.SetDisableLandingZone{ landingZoneName = "s10110_lz0000" }
		
		
		if(svars.isInTunnelAfter == true)then
		
		TppRadio.SetOptionalRadio("Set_s0110_oprg0040")
		elseif(svars.isInTunnelBefore == true)then
		
		TppRadio.SetOptionalRadio("Set_s0110_oprg0030")
		elseif(svars.inInGateBefore == true) or (svars.isGetIntel == true)then
		
		TppRadio.SetOptionalRadio("Set_s0110_oprg0020")
		else
		
		TppRadio.SetOptionalRadio("Set_s0110_oprg0010")
		end
		
		TppMission.UpdateObjective{ 
			objectives = { 
				"default_subGoal",
				"default_photo",
				"MissionTask_SearchBoy",
				"MissionTask_Vanish_Volgin",
				"MissionTask_Vanish_Mantis",
				"MissionTask_GetIntel",
				"MissionTask_Jackal",
				"MissionTask_Talk",
				"targetCpSetting"
			}
		}
		
		TppMission.UpdateObjective{ radio = { radioGroups = { "s0110_rtrg0010" } }, 
			objectives = { 
				"default_area_factory",
			}
		}

	end,

	OnLeave = function ()

		Fox.Log( "s10110_sequence.sequences.Seq_Game_GoToFactory.OnLeave()" )

	end,

}

sequences.Seq_Demo_Bed = {
	Messages = function( self ) 
		return
		StrCode32Table {
			Demo = {
				{
					msg = "radio_off",
					func = function()
						Gimmick.InvisibleGimmick(-1,"mafr_mdeq001_vrtn001_gim_n0023|srt_mafr_mdeq001_vrtn001", "/Assets/tpp/level/location/mafr/block_large/factory/mafr_factory_asset.fox2", true)
					end,
					option = { isExecDemoPlaying = true },
				},
				{
					msg = "radio_on",
					func = function()
						Gimmick.ResetGimmickData( "mafr_mdeq001_vrtn001_gim_i0000|TppSharedGimmick_mafr_mdeq001_vrtn001", "/Assets/tpp/level/location/mafr/block_large/factory/mafr_factory_asset.fox2" )
					end,
					option = { isExecDemoPlaying = true },
				},
			},
		}
	end,

	OnEnter = function()
		if (svars.isDamagedPlh == true) then
			TppSequence.SetNextSequence( "Seq_Game_SearchTarget" )
			
			TppScriptBlock.LoadDemoBlock("volginDemoName")			
		else
			s10110_demo.PlayBedDemo( func )
			
			svars.isInTunnel = true
			TppScriptBlock.Load( "npc_block", "Volgin", true )

			
			TppDataUtility.SetVisibleDataFromIdentifier( "GimmickIdentifier", "bed_before", true, true)
			TppDataUtility.SetEnableDataFromIdentifier( "GimmickIdentifier", "Wall_bed_after", false )
			
			TppDataUtility.SetEnableDataFromIdentifier( "GimmickIdentifier", "Wall_door", false )
			
			TppDataUtility.SetEnableDataFromIdentifier( "GimmickIdentifier", "Wall_tunnel", false )
			TppDataUtility.SetEnableDataFromIdentifier( "GimmickIdentifier", "Wall_tunnel_after", false )
			TppDataUtility.SetEnableDataFromIdentifier( "GimmickIdentifier", "Wall_rock", false )
			
		end
	end,

	OnLeave = function()
		TppMission.UpdateCheckPoint( "CHK_FinishBedDemo" )
		
		
	end,

}

sequences.Seq_Game_SearchTarget = {

	Messages = function( self ) 
		return
		StrCode32Table {
			GameObject = {
				{
					msg = "BreakGimmick",
					func = function ( cpGameObjectId, gameObjectName )
						if gameObjectName == StrCode32( WatorTower ) then 
							
							
							
							Fox.Log("WatorTimerStart")
							mvars.isBreakWTTR = true 
						elseif gameObjectName == StrCode32( "mafr_stfr001_gim_n0002|srt_mafr_stfr001" ) then 
							
							Gimmick.BreakGimmick(TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION, "mafr_stfr001_vrtn002_gim_n0001|srt_mafr_stfr001_vrtn002","/Assets/tpp/level/location/mafr/block_large/factory/mafr_factory_asset.fox2", 0)
						else
							Fox.Log("break_other_gimmick")							
						end
					end,					
				},
				{	
					msg = "Damage" ,
					func = function ( gameObjectId , attackId , attackGameObjectId )
						Fox.Log("gameObjectId = "..gameObjectId.." !!")
						if gameObjectId == GameObject.GetGameObjectId("TppHostage2GameObjectLocator") and TppDamage.IsActiveByAttackId( attackId ) == true then
							if attackGameObjectId == 0 then		
								Fox.Log(" from PC !! ")
								mvars.BoyIsDead = true
								TppMission.ReserveGameOver( TppDefine.GAME_OVER_TYPE.TARGET_DEAD, TppDefine.GAME_OVER_RADIO.TARGET_DEAD ) 
							else								
								Fox.Log(" from not PC !! ")
							end
						
						else
							Fox.Log("damage Character is not Target boy ...")
						end
					end
				},
				












			},
			Timer = {
				{
					msg = "Finish",
					sender = "BrokenWatorTower",
					func = function()
						
						Fox.Log("finish_WatorTower_breaking")
					end
				},
			},
			Trap = {
				{
					msg = "Enter",
					sender = "Trap_bckt",
					func = function()
						Fox.Log("move_bckt")
						
						Gimmick.PushGimmick(-1,"mafr_bckt001_gim_n0075|srt_mafr_bckt001","/Assets/tpp/level/location/mafr/block_large/factory/mafr_factory_asset.fox2", Vector3(-1.5,1.5,1.5), 2 )
						
						local gameObjectId = {type = "TppRat", index = 0}
						local command = {
								id="SetRoute",                  
								name="RatGameObjectLocator",    
								ratIndex = 0,                   
								route="RatRoute",             
						}						
						GameObject.SendCommand( gameObjectId, command )
						
						local gameObjectId = {type = "TppRat", index = 0}
						local command = {
								id="SetRoute",                  
								name="RatGameObjectLocator0001",    
								ratIndex = 0,                   
								route="RatRoute0000",             
						}						
						GameObject.SendCommand( gameObjectId, command )

						local gameObjectId = {type = "TppRat", index = 0}
						local command = {
								id="SetRoute",                  
								name="RatGameObjectLocator0002",    
								ratIndex = 0,                   
								route="RatRoute0001",             
						}						
						GameObject.SendCommand( gameObjectId, command )					
						
						local gameObjectId = {type = "TppRat", index = 0}
						local command = {
								id="SetRoute",                  
								name="RatGameObjectLocator0004",    
								ratIndex = 0,                   
								route="RatRoute0003",             
						}						
						GameObject.SendCommand( gameObjectId, command )
	
						local gameObjectId = {type = "TppRat", index = 0}
						local command = {
								id="SetRoute",                  
								name="RatGameObjectLocator0005",    
								ratIndex = 0,                   
								route="RatRoute0004",             
						}						
						GameObject.SendCommand( gameObjectId, command )					
						
					end
				},
				{
					msg = "Enter",
					sender = "Trap_InRoom",
					func = function()
						
						s10110_radio.PlayAfterBedDemoRadio()
					end
				},
				{
					msg = "Enter",
					sender = "Trap_InRoom2",
					func = function()
						
						s10110_radio.PlayInRoomRadio()
						





					end
				},
				{
					msg = "Enter",
					sender = "Trap_VolginDemo",
					func = function()
						
						
						TppUiStatusManager.SetStatus( "PauseMenu", "INVALID" ) 
						s10110_demo.PlayVolginDemoBefore( func )
						TppSound.StopSceneBGM() 
					end
				},
				{
					msg = "Enter",
					sender = "Trap_InTunnelBeforeON",
					func = function ()
						
						TppRadio.SetOptionalRadio("Set_s0110_oprg0030")
						svars.inInGateBefore = false
						svars.isInTunnelBefore = true
						svars.isClearGate = true
					end		
				},
				{
					msg = "Enter",
					sender = "Trap_InTunnelBeforeOFF",
					func = function ()
						
						TppRadio.SetOptionalRadio("Set_s0110_oprg0020")
						svars.isInTunnelBefore = false
						svars.inInGateBefore = true
					end		
				},
				{
					msg = "Enter",
					sender = "Trap_InTunnelAfterON",
					func = function ()
						
						TppRadio.SetOptionalRadio("Set_s0110_oprg0040")
						svars.isInTunnelBefore = false
						svars.isInTunnelAfter = true
					end		
				},
				{
					msg = "Enter",
					sender = "Trap_InTunnelAfterOFF",
					func = function ()
						
						TppRadio.SetOptionalRadio("Set_s0110_oprg0030")
						svars.isInTunnelAfter = false
						svars.isInTunnelBefore = true
					end		
				},
				{
					msg = "Enter",
					sender = "Trap_factoryBGM_OFF",	
					func = function()
						TppSound.StopSceneBGM()
					end
				},
				{
					msg = "Enter",
					sender = "Trap_factoryBGM_ON",	
					func = function()
						TppSound.SetSceneBGM( "bgm_factory" )
					end
				},
				nil,
			},
			nil
		}
	end,

	OnEnter = function()
		
		
		
		
		TppUiCommand.SetMisionInfoCurrentStoryNo(0)
		
		TppHelicopter.SetDisableLandingZone{ landingZoneName = "lz_Escape1" }
		TppHelicopter.SetDisableLandingZone{ landingZoneName = "lz_Escape2" }
		TppHelicopter.SetDisableLandingZone{ landingZoneName = "lz_Escape3" }
		
		TppDataUtility.SetVisibleDataFromIdentifier( "GimmickIdentifier", "Volgin_BrokenWall", false, true)
		TppDataUtility.SetVisibleDataFromIdentifier( "GimmickIdentifier", "Volgin_BrokenTunnel", false, true)
			
		TppDataUtility.SetVisibleDataFromIdentifier( "GimmickIdentifier", "Broken_stfr0001", false, true) 
		TppDataUtility.SetVisibleDataFromIdentifier( "GimmickIdentifier", "Broken_stfr0002", false, true) 
		
		TppDataUtility.SetVisibleDataFromIdentifier( "GimmickIdentifier", "bed_before", true, true)
		TppDataUtility.SetEnableDataFromIdentifier( "GimmickIdentifier", "Wall_bed_after", false )
		
		TppDataUtility.SetVisibleDataFromIdentifier( "GimmickIdentifier", "door_after", true, true)
		TppDataUtility.SetVisibleDataFromIdentifier( "GimmickIdentifier", "door_before", false, true)
		
		TppDataUtility.SetEnableDataFromIdentifier( "GimmickIdentifier", "Wall_door", false )
		
		TppDataUtility.SetEnableDataFromIdentifier( "GimmickIdentifier", "Wall_tunnel", false )
		TppDataUtility.SetEnableDataFromIdentifier( "GimmickIdentifier", "Wall_tunnel_after", false )
		TppDataUtility.SetEnableDataFromIdentifier( "GimmickIdentifier", "Wall_rock", false )
		
		svars.isInTunnel = true
		
		
		TppRadio.ChangeIntelRadio( s10110_radio.intelRadioListSearchTarget )
		
		
		if(svars.isInTunnelAfter == true)then
		
		TppRadio.SetOptionalRadio("Set_s0110_oprg0040")
		
		TppRadio.EnableCommonOptionalRadio(false)
		elseif(svars.isInTunnelBefore == true)then
		
		TppRadio.SetOptionalRadio("Set_s0110_oprg0030")
		
		TppRadio.EnableCommonOptionalRadio(true)
		elseif(svars.inInGateBefore == true) or (svars.isGetIntel == true)then
		
		TppRadio.SetOptionalRadio("Set_s0110_oprg0020")
		
		TppRadio.EnableCommonOptionalRadio(true)
		else
		
		TppRadio.SetOptionalRadio("Set_s0110_oprg0010")
		
		TppRadio.EnableCommonOptionalRadio(true)
		end
		
	end,

	OnLeave = function()
		
		TppUiStatusManager.SetStatus( "AnnounceLog","INVALID_LOG")
		
	end,
	
	
	Seq_Demo_Volgin_Prepare = function()
		
		TppMission.Reload{
			isNoFade = false,													
			showLoadingTips = false, 
			missionPackLabelName = "AfterVolginDemo",					
			OnEndFadeOut = function()											
				TppSequence.ReserveNextSequence( "Seq_Demo_Volgin" )
				TppMission.UpdateCheckPointAtCurrentPosition()
			end,
		}
	end,

}

sequences.Seq_Demo_Volgin = {

	Messages = function( self ) 
		return
		StrCode32Table {
			Demo = {
				{
					msg = "crtnburn",
					func = function()
						
						Gimmick.BreakGimmick(TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION, "mafr_crtn002_gim_n0010|srt_mafr_crtn002","/Assets/tpp/level/location/mafr/block_large/factory/mafr_factory_asset.fox2", 0)
						Gimmick.BreakGimmick(TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION, "mafr_crtn002_gim_n0014|srt_mafr_crtn002","/Assets/tpp/level/location/mafr/block_large/factory/mafr_factory_asset.fox2", 0)
						Gimmick.BreakGimmick(TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION, "mafr_crtn002_gim_n0015|srt_mafr_crtn002","/Assets/tpp/level/location/mafr/block_large/factory/mafr_factory_asset.fox2", 0)
						Gimmick.BreakGimmick(TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION, "mafr_crtn002_vrtn002_gim_n0003|srt_mafr_crtn002_vrtn002","/Assets/tpp/level/location/mafr/block_large/factory/mafr_factory_asset.fox2", 0)
						Gimmick.BreakGimmick(TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION, "mafr_crtn002_vrtn002_gim_n0004|srt_mafr_crtn002_vrtn002","/Assets/tpp/level/location/mafr/block_large/factory/mafr_factory_asset.fox2", 0)
						Gimmick.BreakGimmick(TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION, "mafr_crtn002_vrtn003_gim_n0016|srt_mafr_crtn002_vrtn003","/Assets/tpp/level/location/mafr/block_large/factory/mafr_factory_asset.fox2", 0)
						Gimmick.BreakGimmick(TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION, "mafr_crtn002_vrtn003_gim_n0018|srt_mafr_crtn002_vrtn003","/Assets/tpp/level/location/mafr/block_large/factory/mafr_factory_asset.fox2", 0)
						
						TppDataUtility.SetVisibleEffectFromGroupId( "fire_outland", true )
						TppDataUtility.SetVisibleEffectFromGroupId( "fire_in_factory", true )
						TppDataUtility.SetVisibleEffectFromGroupId( "fire_outland_01b", true )
						TppDataUtility.CreateEffectFromGroupId( "fire_outland", true )
						TppDataUtility.CreateEffectFromGroupId( "fire_in_factory", true )
						TppDataUtility.CreateEffectFromGroupId( "fire_outland_01b", true )
						
						Gimmick.PowerCutOn( "PowerCutArea_factory0000" )
						
					end,
					option = { isExecDemoPlaying = true },
				},
				{
					msg = "crtnhide",
					func = function()
						
						Gimmick.InvisibleGimmick ( TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION, "mafr_crtn002_gim_n0014|srt_mafr_crtn002", "/Assets/tpp/level/location/mafr/block_large/factory/mafr_factory_asset.fox2", true )
						Gimmick.InvisibleGimmick ( TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION, "mafr_crtn002_vrtn003_gim_n0018|srt_mafr_crtn002_vrtn003", "/Assets/tpp/level/location/mafr/block_large/factory/mafr_factory_asset.fox2", true )
					end,
					option = { isExecDemoPlaying = true },
				},
				{
					msg = "Kill_Fx",
					func = function()
						TppDataUtility.SetVisibleEffectFromGroupId( "fire_outland", false )
						TppDataUtility.SetVisibleEffectFromGroupId( "fire_in_factory", false )
						TppDataUtility.SetVisibleEffectFromGroupId( "fire_outland_01b", false )
						TppDataUtility.CreateEffectFromGroupId( "fire_outland", false )
						TppDataUtility.CreateEffectFromGroupId( "fire_in_factory", false)
						TppDataUtility.CreateEffectFromGroupId( "fire_outland_01b", false)
					end,
					option = { isExecDemoPlaying = true },
				},
				{
					msg = "Skip",
					func = function()
						Gimmick.InvisibleGimmick ( TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION, "mafr_crtn002_vrtn003_gim_n0016|srt_mafr_crtn002_vrtn003", "/Assets/tpp/level/location/mafr/block_large/factory/mafr_factory_asset.fox2", true )
						Gimmick.InvisibleGimmick ( TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION, "mafr_crtn002_gim_n0015|srt_mafr_crtn002", "/Assets/tpp/level/location/mafr/block_large/factory/mafr_factory_asset.fox2", true )
					end,
					option = { isExecDemoPlaying = true },
				},
			},
		}
	end,

	OnEnter = function()
		






		
		
		TppHelicopter.SetDisableLandingZone{ landingZoneName = "lz_Escape1" }
		TppHelicopter.SetDisableLandingZone{ landingZoneName = "lz_Escape2" }
		TppHelicopter.SetDisableLandingZone{ landingZoneName = "lz_Escape3" }
		
		s10110_demo.PlayVolginDemo( func )
		
		
		svars.isGetIntel = true
		TppMission.UpdateObjective{
				objectives = { "area_Intel_factorySouth_lost" },
		}          

	end,
			
	OnLeave = function()

		TppMission.UpdateCheckPoint( "CHK_FinishVolginDemo" )
		
	end,

}

sequences.Seq_Game_Escape = {

	Messages = function( self ) 
		return
		StrCode32Table {
			GameObject = {
				{
					msg = "BreakGimmick",
					func = function ( cpGameObjectId, gameObjectName )
						if gameObjectName == StrCode32( Wall ) then 
							
							GkEventTimerManager.Start( "BrokenWall", 0.5 ) 
							GkEventTimerManager.Start( "BrokenWallAnimation", 1 ) 
							GkEventTimerManager.Start( "BrokenFrame", 0 ) 
							Fox.Log("WallTimerStart")
						elseif gameObjectName == StrCode32( WatorTower ) then 
							
							
							
							Fox.Log("WatorTimerStart")
							mvars.isBreakWTTR = true 
						elseif gameObjectName == StrCode32( "gntn_hydr001_gim_n0001|srt_gntn_hydr001" ) then
							
							Gimmick.BreakGimmick(TppGameObject.GAME_OBJECT_TYPE_IMPORTANT_BREAKABLE, "mafr_stfr001_gim_n0002|srt_mafr_stfr001","/Assets/tpp/level/location/mafr/block_large/factory/mafr_factory_asset.fox2", 0)
							
							Gimmick.BreakGimmick(TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION, "mafr_stfr001_vrtn002_gim_n0001|srt_mafr_stfr001_vrtn002","/Assets/tpp/level/location/mafr/block_large/factory/mafr_factory_asset.fox2", 0)
						elseif gameObjectName == StrCode32( "mafr_wttw005_gim_n0001|srt_mafr_wttw005" ) then
							mvars.isBreakWTTK0000 = true 
						elseif gameObjectName == StrCode32( "mafr_wttw005_gim_n0002|srt_mafr_wttw005" ) then
							mvars.isBreakWTTK0001 = true 
						else
							Fox.Log("break_other_gimmick")							
						end
					end,					
				},
				{
					msg = "VolginLifeStatusChanged",
					func = function(gameObjectId, newLifeStatus)
						if (newLifeStatus == TppVolgin2.VOLGIN_LIFE_STATUS_VANISHED_FOREVER) then 
							if mvars.DAMAGED_TYPE_LIGHTNING == true or mvars.DAMAGED_TYPE_RAIN == true or mvars.VolginFultonFinished == true then
								Fox.Log("OtherRadio")
							else
								s10110_radio.PlayVolgin_Vanished_ForeverRadio()
							end
							mvars.VOLGIN_LIFE_VANISHED_FOREVER = true
							
							
							TppSound.SetSceneBGMSwitch("Set_Switch_bgm_boss_phase_ed") 
							
							TppRadio.ChangeIntelRadio( s10110_radio.intelRadioListEscape )
							
							TppRadio.SetOptionalRadio("Set_s0110_oprg0050")
							
							
							
							TppResult.AcquireSpecialBonus{
								second = { isComplete = true },
							}
							
							local gameObjectId = { type="TppBuddyDog2", index=0 }
							local command = { id = "LuaAiStayAndSnarl" }	
							if GameObject.GetGameObjectIdByIndex( "TppBuddyDog2",0 ) ~= GameObject.NULL_ID then
								Fox.Log("")
								GameObject.SendCommand( gameObjectId, command )
							else
								Fox.Log("")
							end
							
							vars.playerDisableActionFlag = PlayerDisableAction.NONE
							
							TppMission.FinishBossBattle()
							
							
							
						elseif (newLifeStatus == TppVolgin2.VOLGIN_LIFE_STATUS_VANISHED) then 
							
							mvars.VOLGIN_LIFE_VANISHED = true
						elseif (newLifeStatus == TppVolgin2.VOLGIN_LIFE_STATUS_NORMAL) then 
							s10110_radio.PlayVolgin_NormalRadio()
							mvars.VOLGIN_LIFE_VANISHED = false
						else
							Fox.Log("VolginLifeStatusChanged_NoChanged")
						end
					end
				},
				{
					msg = "VolginAttack",
					func = function(gameObjectId, attackType)
						if ( attackType == TppVolgin2.VOLGIN_ATTACK_CHARGE_START) then
							s10110_radio.PlayCounterRadio()
						elseif( attackType == TppVolgin2.VOLGIN_ATTACK_CHARGE_RELEASE)then
							s10110_radio.PlayRunRadio()
						else
							Fox.Log("NoRadio")
						end
					end
				},
				{
					msg = "VolginChangePhase",
					func = function(gameObjectId, newPhase)
						if	(mvars.isBreakFrame == true) then
							if (newPhase == TppVolgin2.VOLGIN_PHASE_SNEAK) then 
								
								
							elseif (newPhase == TppVolgin2.VOLGIN_PHASE_ALERT) then 
								s10110_radio.PlayVolginChangePhase_AleartRadio()
								TppSound.SetSceneBGMSwitch("Set_Switch_bgm_boss_phase_al")
							end
						else
							Fox.Log("BGMNoChanged")
						end
					end
				},
				{
					msg = "RoutePoint2",
					sender = "SupportHeli",
					func = function(gameObjectId, routeId ,routeNode, messageId)
						if (messageId == StrCode32("HeliClear")) then
						
							Fox.Log("TppMission.ReserveMissionClear")
							TppMission.ReserveMissionClear{
								missionClearType = TppDefine.MISSION_CLEAR_TYPE.RIDE_ON_HELICOPTER,
								nextMissionId = TppDefine.SYS_MISSION_ID.MTBS_FREE,
							}
							
							mvars.HeliClear = true
							
							TppSound.StopSceneBGM()
						else
							
						end
					end
				},

				{
					msg = "VolginDestroyedFactoryWall",
					func = function()
						
						Fox.Log("StopChaseMode")
						local gameObjectId = { type="TppVolgin2", index=0 }
						local command = {id="SetChasePlayerMode", chasePlayer="chasePlayer"}
						command.chasePlayer = false
						GameObject.SendCommand(gameObjectId, command)
						
						local gameObjectId = { type="TppVolgin2", index=0 }
						local command = {id="Warp", position="position", rotationY="rotationY"}
						command.position = Vector3(2889.253174,102.877808,-902.706421)
						command.rotationY = 90.0
						GameObject.SendCommand(gameObjectId, command)
						
						Gimmick.BreakGimmick(TppGameObject.GAME_OBJECT_TYPE_IMPORTANT_BREAKABLE, "mafr_fctr001_wall008_gim_n0001|srt_mafr_fctr001_wall008","/Assets/tpp/level/location/mafr/block_large/factory/mafr_factory_asset.fox2", 0)
						
						WeatherManager.RequestTag("factory_Volgin_shadow_long", 3 )
					end
				},
				{
					msg = "VolginDestroyedTunnel",
					func = function()
						
						TppMission.UpdateObjective{ objectives = { "rv_fake_off" } }
						
						TppHelicopter.SetEnableLandingZone{ landingZoneName = "lz_Escape1" }
						TppHelicopter.SetEnableLandingZone{ landingZoneName = "lz_Escape2" }
						TppHelicopter.SetEnableLandingZone{ landingZoneName = "lz_Escape3" }
						TppHelicopter.SetDisableLandingZone{ landingZoneName = "s10110_lz0000" }
						TppUI.ShowAnnounceLog( "unlockLz" )
						
						TppDataUtility.CreateEffectFromId( "Volgin_Warp" )
						
						Gimmick.BreakGimmick(TppGameObject.GAME_OBJECT_TYPE_IMPORTANT_BREAKABLE, "mafr_tnnl001_gim_n0001|srt_mafr_tnnl001","/Assets/tpp/level/location/mafr/block_large/factory/mafr_factory_asset.fox2", 0)
						
						Gimmick.BreakGimmick(TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION, "mafr_tnnl001_frct001_gim_n0000|srt_mafr_tnnl001_frct001","/Assets/tpp/level/location/mafr/block_large/factory/mafr_factory_asset.fox2", 0)
						 
						GkEventTimerManager.Start( "BrokenTunnel", 0.5 )
						
						TppDataUtility.SetEnableDataFromIdentifier( "GimmickIdentifier", "Wall_tunnel", true )
						TppDataUtility.SetEnableDataFromIdentifier( "GimmickIdentifier", "Wall_tunnel_after", true )
																	
					end
				},
				{
					msg = "VolginGameOverAttackSuccess",
					func = function()
						mvars.isKilledByVolgin = true 
						Fox.Log("isKilledByVolgin")
					end
				},
				{
					msg = "FultonFailedEnd",
					func = function(gameObjectId, locatorName, locatorNameUpper, failureType)
						Fox.Log("FultonFailedEnd")
						if(gameObjectId == GameObject.GetGameObjectId( "vol_factory_0000" )) and ( failureType == TppGameObject.FULTON_FAILED_TYPE_ON_FINISHED_RISE ) then
							s10110_radio.PlayVolginFultonFailedRadio()
							mvars.VolginFultonFinished = true
						else
							Fox.Log("NoRadio")
						end
					end
				},
				nil,				
			},
			Timer = {
				{
					msg = "Finish",
					sender = "Rain",
					func = function()
						TppWeather.CancelRequestWeather( TppDefine.WEATHER.RAINY )
					end
				},
				{
					msg = "Finish",
					sender = "BrokenWall",
					func = function()
						TppDataUtility.SetVisibleDataFromIdentifier( "GimmickIdentifier", "Volgin_BrokenWall", true, true)
						Fox.Log("finish_wall_breaking")
					end
				},
				{
					msg = "Finish",
					sender = "BrokenWallAnimation",
					func = function()
						Gimmick.BreakGimmick(TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION, "mafr_fctr001_rbbl002_gim_n0000|srt_mafr_fctr001_rbbl002","/Assets/tpp/level/location/mafr/block_large/factory/mafr_factory_asset.fox2", 0)
						Fox.Log("finish_wall_breaking_animation")
						
						local gameObjectId = { type="TppVolgin2", index=0 }
						local command = {id="SetFireballMode", enable=false}
						GameObject.SendCommand(gameObjectId, command)
						
						local gameObjectId = { type="TppVolgin2", index=0 }
						local command = {id="EnableCombat"}
						GameObject.SendCommand(gameObjectId, command)						
					end
				},
				{
					msg = "Finish",
					sender = "BrokenTunnel",
					func = function()
						TppSequence.SetNextSequence( "Seq_Game_Escape2" )
						svars.AfterBreakingTunnel = true 
						TppDataUtility.SetVisibleDataFromIdentifier( "GimmickIdentifier", "Volgin_BrokenTunnel", true, true)
						s10110_radio.PlayBreakTunnelRadio()
						Fox.Log("finish_tunnel_breaking")
					end
				},
				{
					msg = "Finish",
					sender = "BrokenWatorTower",
					func = function()
						
						Fox.Log("finish_WatorTower_breaking")
					end
				},
				{
					msg = "Finish",
					sender = "BrokenFrame",
					func = function()
						
						Gimmick.BreakGimmick(TppGameObject.GAME_OBJECT_TYPE_IMPORTANT_BREAKABLE, "mafr_stfr001_gim_n0001|srt_mafr_stfr001","/Assets/tpp/level/location/mafr/block_large/factory/mafr_factory_asset.fox2", 0)
						
						Gimmick.ChangeSequentialEventAnimation("mafr_stfr001_vrtn002_ex_gim_n0002|srt_mafr_stfr001_vrtn002_ex","/Assets/tpp/level/location/mafr/block_large/factory/mafr_factory_asset.fox2", 0, 0.0, false, true)
						
						TppDataUtility.SetVisibleDataFromIdentifier( "GimmickIdentifier", "Broken_stfr0001", true, true) 
						Fox.Log("finish_Frame_breaking")
						
						local gameObjectId = GameObject.GetGameObjectId( "vol_factory_0000" )
						local command = {id="SetRoute", route="route", point="point"}
						if gameObjectId ~= NULL_ID then
							command.route = "rts_vol_sneak"
							command.point = 0
							GameObject.SendCommand(gameObjectId, command)
						end
						Fox.Log("mvars.isBreakFrame = true")
						mvars.isBreakFrame = true 
					end
				},

			},
			Player = {
				{
					msg = "PlayerFulton",
					func = function( playerId, gameObjectId )
						if gameObjectId == GameObject.GetGameObjectId( "vol_factory_0000" ) and mvars.VolginFulton == false then
							
							s10110_radio.PlayVolginFultonRadio()
							mvars.VolginFulton = true
						else
							Fox.Log("NoRadio")
						end
					end
				},
			},
			
			
			





























































			Trap = {
				{
					msg = "Enter",
					sender = "Trap_crtn",
					func = function()
						Gimmick.BreakGimmick(TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION, "mafr_crtn002_vrtn003_gim_n0007|srt_mafr_crtn002_vrtn003","/Assets/tpp/level/location/mafr/block_large/factory/mafr_factory_asset.fox2", 0)
						Gimmick.BreakGimmick(TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION, "mafr_crtn002_vrtn003_gim_n0006|srt_mafr_crtn002_vrtn003","/Assets/tpp/level/location/mafr/block_large/factory/mafr_factory_asset.fox2", 0)
						Gimmick.BreakGimmick(TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION, "mafr_crtn002_vrtn003_gim_n0005|srt_mafr_crtn002_vrtn003","/Assets/tpp/level/location/mafr/block_large/factory/mafr_factory_asset.fox2", 0)
						Gimmick.BreakGimmick(TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION, "mafr_crtn002_vrtn002_gim_n0002|srt_mafr_crtn002_vrtn002","/Assets/tpp/level/location/mafr/block_large/factory/mafr_factory_asset.fox2", 0)
						Gimmick.BreakGimmick(TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION, "mafr_crtn002_vrtn003_gim_n0004|srt_mafr_crtn002_vrtn003","/Assets/tpp/level/location/mafr/block_large/factory/mafr_factory_asset.fox2", 0)
						Gimmick.BreakGimmick(TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION, "mafr_crtn002_vrtn001_gim_n0001|srt_mafr_crtn002_vrtn001","/Assets/tpp/level/location/mafr/block_large/factory/mafr_factory_asset.fox2", 0)
						
						Gimmick.BreakGimmick(TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION, "mafr_crtn002_gim_n0016|srt_mafr_crtn002","/Assets/tpp/level/location/mafr/block_large/factory/mafr_factory_asset.fox2", 0)
					end
				},
				{
					msg = "Enter",
					sender = "Trap_BreakStfr",
					func = function ()
						Gimmick.ChangeSequentialEventAnimation("mafr_stfr001_vrtn002_ex_gim_n0002|srt_mafr_stfr001_vrtn002_ex","/Assets/tpp/level/location/mafr/block_large/factory/mafr_factory_asset.fox2", 1, 0.0, false, true)
						
						TppDataUtility.CreateEffectFromId( "BrkFx" )
						
						s10110_radio.PlayRunRadio()
					end,
				},
				{
					msg = "Enter",
					sender = "Trap_FireballMode",
					func = function ()		
					
						local gameObjectId = { type="TppVolgin2", index=0 }
						local command = {id="SetFireballMode", enable=true}
						GameObject.SendCommand(gameObjectId, command)
					end,				
				},
				{
					msg = "Enter",
					sender = "Trap_BreakWall",
					func = function ()
						
						Fox.Log("BGMVolginAleart")
						TppSound.SetSceneBGMSwitch("Set_Switch_bgm_boss_phase_al")	
						
						
						local gameObjectId = { type="TppVolgin2", index=0 }
						local command = {id="RequestAttack", attackType="attackType"}
						command.attackType = Fox.StrCode32("DestroyFactoryWallAttack")
						GameObject.SendCommand(gameObjectId, command)
						
						
						TppDataUtility.SetEnableDataFromIdentifier( "GimmickIdentifier", "Wall_door", true )
						
						TppDataUtility.SetVisibleEffectFromGroupId( "fire_in_factory_door", true )
						TppDataUtility.CreateEffectFromGroupId( "fire_in_factory_door", true )
						TppDataUtility.SetVisibleEffectFromGroupId( "fire_outland2", true )
						TppDataUtility.CreateEffectFromGroupId( "fire_outland2", true )
						TppDataUtility.DestroyEffectFromGroupId( "fire_in_factory", true )
						
						
						TppRadio.SetOptionalRadio("Set_s0110_oprg0070")					

					end,
					
				},
				
				
				{
					msg = "Enter",
					sender = "Trap_DD1" ,
					func = function()
						local gameObjectId = { type="TppBuddyDog2", index=0 }
						local pos1=Vector3(2827.033, 96.916, -886.182) 
						local pos2=Vector3(2820.780, 96.460, -876.221) 

						local command = { id = "LuaAiStayAndSnarl", position=pos1, look=pos2 }
						if GameObject.GetGameObjectIdByIndex( "TppBuddyDog2",0 ) ~= GameObject.NULL_ID then
							Fox.Log("#### Trap_DD1 #### DD Go!!")
							GameObject.SendCommand( gameObjectId, command )
						else
							Fox.Log("####  DD not exist...")
						end
					end,
				},
				{
					msg = "Enter",
					sender = "Trap_DD2" ,
					func = function()
						local gameObjectId = { type="TppBuddyDog2", index=0 }
						local pos1=Vector3(2788.069, 94.395, -910.213) 
						local pos2=Vector3(2780.872, 94.497, -910.925) 

						local command = { id = "LuaAiStayAndSnarl", position=pos1, look=pos2 }
						if GameObject.GetGameObjectIdByIndex( "TppBuddyDog2",0 ) ~= GameObject.NULL_ID then
							Fox.Log("#### Trap_DD2 #### DD Go!!")
							GameObject.SendCommand( gameObjectId, command )
						else
							Fox.Log("####  DD not exist...")
						end
					end,
				},
				{
					msg = "Enter",
					sender = "Trap_DD3" ,
					func = function()
						local gameObjectId = { type="TppBuddyDog2", index=0 }
						local pos1=Vector3(2772.567, 94.245, -865.468) 
						local pos2=Vector3(2771.378, 94.439, -869.841) 

						local command = { id = "LuaAiStayAndSnarl", position=pos1, look=pos2 }
						if GameObject.GetGameObjectIdByIndex( "TppBuddyDog2",0 ) ~= GameObject.NULL_ID then
							Fox.Log("#### Trap_DD3 #### DD Go!!")
							GameObject.SendCommand( gameObjectId, command )
						else
							Fox.Log("####  DD not exist...")
						end
					end,
				},
				{
					msg = "Enter",
					sender = "Trap_DD5" ,
					func = function()
						local gameObjectId = { type="TppBuddyDog2", index=0 }
						local pos1=Vector3(2861.887, 102.321, -861.647) 
						local pos2=Vector3(2855.434, 102.385, -852.745) 

						local command = { id = "LuaAiStayAndSnarl", position=pos1, look=pos2 }
						if GameObject.GetGameObjectIdByIndex( "TppBuddyDog2",0 ) ~= GameObject.NULL_ID then
							Fox.Log("#### Trap_DD5 #### DD Go!!")
							GameObject.SendCommand( gameObjectId, command )
						else
							Fox.Log("####  DD not exist...")
						end
					end,
				},
				{
					msg = "Enter",
					sender = "Trap_DD4" ,
					func = function()
						local gameObjectId = { type="TppBuddyDog2", index=0 }
						local pos1=Vector3(2827.033, 96.916, -886.182) 
						local pos2=Vector3(2820.780, 96.460, -876.221) 

						local command = { id = "LuaAiStayAndSnarl", position=pos1, look=pos2 }
						if GameObject.GetGameObjectIdByIndex( "TppBuddyDog2",0 ) ~= GameObject.NULL_ID then
							Fox.Log("#### Trap_DD4 #### DD Go!!")
							GameObject.SendCommand( gameObjectId, command )
						else
							Fox.Log("####  DD not exist...")
						end
					end,
				},
			},
			nil
		}
	end,

	OnEnter = function()
		Fox.Log("OnEnter_Seq_Game_Escape")
		
		TppMission.CanMissionClear()
		
		








		
		
		TppWeather.RequestWeather( TppDefine.WEATHER.CLOUDY )
		
		GkEventTimerManager.Start( "Rain", 600 )		
		
		mvars.HeliClear = false
		mvars.VOLGIN_LIFE_VANISHED = false 
		mvars.VOLGIN_LIFE_VANISHED_FOREVER = false 
		mvars.isKilledByVolgin = false 
		mvars.isBreakWTTK0000 = false 
		mvars.isBreakWTTK0001 = false
		
		this.Initialize_DAMAGED_TYPE()
		
		TppDataUtility.SetVisibleDataFromIdentifier( "GimmickIdentifier", "bed_before", false, true)
		TppDataUtility.SetEnableDataFromIdentifier( "GimmickIdentifier", "Wall_bed_after", true )
		TppDataUtility.SetVisibleDataFromIdentifier( "GimmickIdentifier", "bed_after", true, true)
		TppDataUtility.SetEnableDataFromIdentifier( "GimmickIdentifier", "Wall_bed_before", false )
		
		TppDataUtility.SetEnableDataFromIdentifier( "GimmickIdentifier", "Wall_door", false )
		
		TppDataUtility.SetEnableDataFromIdentifier( "GimmickIdentifier", "Wall_tunnel", false )
		TppDataUtility.SetEnableDataFromIdentifier( "GimmickIdentifier", "Wall_tunnel_after", false )
		TppDataUtility.SetEnableDataFromIdentifier( "GimmickIdentifier", "Wall_rock", false )
		
		
		for i, gimmickId in pairs( resetGimmickIdTable ) do
			TppGimmick.ResetGimmick{ gimmickId = gimmickId, searchFromSaveData = false }
		end		
		for i, gimmickId in pairs( resetVolginGimmickIdTable ) do
			TppGimmick.ResetGimmick{ gimmickId = gimmickId, searchFromSaveData = false }
		end	
				
		
		TppRadio.ChangeIntelRadio( s10110_radio.intelRadioListEscape )
		
		Fox.Log("BGMVolginSneak")
		TppSound.SetSceneBGM("bgm_volgin")
		TppSound.SetSceneBGMSwitch("Set_Switch_bgm_boss_phase_sn")
		
			
		
			
		
		TppHelicopter.SetDisableLandingZone{ landingZoneName = "lz_Escape1" }
		TppHelicopter.SetDisableLandingZone{ landingZoneName = "lz_Escape2" }
		TppHelicopter.SetDisableLandingZone{ landingZoneName = "lz_Escape3" }
		
		local gameObjectId = { type="TppVolgin2", index=0 }
		local command = {id="DisableCombat"}
		GameObject.SendCommand(gameObjectId, command)
		
		local gameObjectId = { type="TppVolgin2", index=0 }
		local command = {id="SetChasePlayerMode", chasePlayer="chasePlayer"}
		command.chasePlayer = true
		GameObject.SendCommand(gameObjectId, command)
		
		local gameObjectId = { type="TppVolgin2", index=0 }
		local command = {id="SetRoute", route="route", point="point"}
		command.route = "rts_vol_factory"
		command.point = 0
		GameObject.SendCommand(gameObjectId, command)
		
		TppDataUtility.SetVisibleDataFromIdentifier( "GimmickIdentifier", "Volgin_BrokenWall", false, true)
		TppDataUtility.SetVisibleDataFromIdentifier( "GimmickIdentifier", "Volgin_BrokenTunnel", false, true)
		
		TppDataUtility.SetVisibleDataFromIdentifier( "GimmickIdentifier", "Broken_stfr0001", false, true) 
		TppDataUtility.SetVisibleDataFromIdentifier( "GimmickIdentifier", "Broken_stfr0002", false, true) 
		
		TppDataUtility.SetVisibleEffectFromGroupId( "fire_outland", true )
		TppDataUtility.SetVisibleEffectFromGroupId( "fire_in_factory", true )
		TppDataUtility.SetVisibleEffectFromGroupId( "fire_outland_01b", true )
		TppDataUtility.CreateEffectFromGroupId( "fire_outland", true )
		TppDataUtility.CreateEffectFromGroupId( "fire_in_factory", true )
		TppDataUtility.CreateEffectFromGroupId( "fire_outland_01b", true )
		
		TppDataUtility.SetVisibleEffectFromGroupId( "fire_in_factory_door", false )
		TppDataUtility.CreateEffectFromGroupId( "fire_in_factory_door", false )
		
		TppDataUtility.SetVisibleDataFromIdentifier( "GimmickIdentifier", "door_after", true, true)
		TppDataUtility.SetVisibleDataFromIdentifier( "GimmickIdentifier", "door_before", false, true)
		
		TppDataUtility.SetEnableDataFromIdentifier( "GimmickIdentifier", "Wall_door", false )
		
		GameObject.SendCommand( GameObject.GetGameObjectId( "TppHeli2", "SupportHeli" ), { id = "CallToLandingZoneAtName", name = "s10110_lz0000" })
		GameObject.SendCommand( GameObject.GetGameObjectId( "TppHeli2", "SupportHeli" ), { id = "SetTakeOffWaitTime", time = 0 })
		
		TppRadio.SetOptionalRadio("Set_s0110_oprg0060")
		
		TppRadio.EnableCommonOptionalRadio(false)
		
		TppUiStatusManager.UnsetStatus( "AnnounceLog","INVALID_LOG")
		
		














		
		svars.isInTunnel = true
		
		TppMission.UpdateObjective{
			radio = { radioGroups = { "s0110_rtrg0130", "s0110_rtrg0140", "s0110_rtrg0150" } },
			objectives = { "AchieveObjectives", "VolginDemoAfter_subGoal", "ClearTask_SearchBoy", "rv_fake", "clear_photo" }
		}
		
		TppUiCommand.SetMisionInfoCurrentStoryNo(1)
		
		GameObject.SendCommand( { type="TppHeli2", index=0, }, { id="SetAutoWithdrawalEnabled", enabled=false } )
		
		vars.playerDisableActionFlag = PlayerDisableAction.TIME_CIGARETTE
		
		TppMission.StartBossBattle()
		
			Gimmick.InvisibleGimmick ( TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION, "mafr_crtn002_vrtn003_gim_n0016|srt_mafr_crtn002_vrtn003", "/Assets/tpp/level/location/mafr/block_large/factory/mafr_factory_asset.fox2", true )
			Gimmick.InvisibleGimmick ( TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION, "mafr_crtn002_gim_n0015|srt_mafr_crtn002", "/Assets/tpp/level/location/mafr/block_large/factory/mafr_factory_asset.fox2", true )
	end,
	
	OnLeave = function()
		TppMission.UpdateCheckPoint( "CHK_AfterBreaking" )
	end,

}


sequences.Seq_Game_Escape2 = {

	Messages = function( self ) 
		return
		StrCode32Table {
			GameObject = {
				{
					msg = "BreakGimmick",
					func = function ( cpGameObjectId, gameObjectName )
						if gameObjectName == StrCode32( "mafr_wttw003_gim_n0000|srt_mafr_wttw003" ) then
							mvars.isBreakWTTR = true 
							TppRadio.ChangeIntelRadio{ Espionage_Water_Tower0000 = "s0110_esrg0180" } 
						elseif gameObjectName == StrCode32( "mafr_wttw003_gim_n0001|srt_mafr_wttw003" ) then
							TppRadio.ChangeIntelRadio{ Espionage_Water_Tower0001 = "s0110_esrg0180" } 
						elseif gameObjectName == StrCode32( "gntn_hydr001_gim_n0001|srt_gntn_hydr001" ) then
							
							Gimmick.BreakGimmick(TppGameObject.GAME_OBJECT_TYPE_IMPORTANT_BREAKABLE, "mafr_stfr001_gim_n0002|srt_mafr_stfr001","/Assets/tpp/level/location/mafr/block_large/factory/mafr_factory_asset.fox2", 0)
							
							Gimmick.BreakGimmick(TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION, "mafr_stfr001_vrtn002_gim_n0001|srt_mafr_stfr001_vrtn002","/Assets/tpp/level/location/mafr/block_large/factory/mafr_factory_asset.fox2", 0)
							TppRadio.ChangeIntelRadio{ Espionage_Stfr0001 = "s0110_esrg0180" } 
						elseif gameObjectName == StrCode32( "mafr_wttw005_gim_n0001|srt_mafr_wttw005" ) then
							Fox.Log("Break_WaterTank")
							mvars.isBreakWTTK0000 = true 
							TppRadio.ChangeIntelRadio{ Espionage_Water_Tank0000 = "s0110_esrg0180"	} 
						elseif gameObjectName == StrCode32( "mafr_wttw005_gim_n0002|srt_mafr_wttw005" ) then
							mvars.isBreakWTTK0001 = true 
							TppRadio.ChangeIntelRadio{ Espionage_Water_Tank0001 = "s0110_esrg0180"	} 
						else
							Fox.Log("break_other_gimmick")							
						end
					end,
				},

				{
					msg = "VolginLifeStatusChanged",
					func = function(gameObjectId, newLifeStatus)
						if (newLifeStatus == TppVolgin2.VOLGIN_LIFE_STATUS_VANISHED_FOREVER) then 
							if mvars.DAMAGED_TYPE_LIGHTNING == true or mvars.DAMAGED_TYPE_RAIN == true or mvars.VolginFultonFinished == true then
								Fox.Log("OtherRadio")
							else
								s10110_radio.PlayVolgin_Vanished_ForeverRadio()
							end
							mvars.VOLGIN_LIFE_VANISHED_FOREVER = true
							
							
							TppSound.SetSceneBGMSwitch("Set_Switch_bgm_boss_phase_ed") 
							
							TppRadio.ChangeIntelRadio( s10110_radio.intelRadioListEscape )
							
							TppRadio.SetOptionalRadio("Set_s0110_oprg0050")
							
							TppMission.UpdateObjective{	objectives = { "ClearTask_Vanish_Volgin" } }
							
							TppResult.AcquireSpecialBonus{
								second = { isComplete = true },
							}
							
							local gameObjectId = { type="TppBuddyDog2", index=0 }
							local command = { id = "LuaAiStayAndSnarl" }	
							if GameObject.GetGameObjectIdByIndex( "TppBuddyDog2",0 ) ~= GameObject.NULL_ID then
								Fox.Log("")
								GameObject.SendCommand( gameObjectId, command )
							else
								Fox.Log("")
							end
							
							vars.playerDisableActionFlag = PlayerDisableAction.NONE
							
							TppMission.FinishBossBattle()
							
							
							
						elseif (newLifeStatus == TppVolgin2.VOLGIN_LIFE_STATUS_VANISHED) then 
							
							mvars.VOLGIN_LIFE_VANISHED = true
						elseif (newLifeStatus == TppVolgin2.VOLGIN_LIFE_STATUS_NORMAL) then 
							s10110_radio.PlayVolgin_NormalRadio()
							mvars.VOLGIN_LIFE_VANISHED = false
						else
							Fox.Log("VolginLifeStatusChanged_NoChanged")
						end
					end
				},
				{
					msg = "VolginChangePhase",
					func = function(gameObjectId, newPhase)
						if (newPhase == TppVolgin2.VOLGIN_PHASE_SNEAK) then 
							s10110_radio.PlayVolginChangePhase_SneakRadio()
							TppSound.SetSceneBGMSwitch("Set_Switch_bgm_boss_phase_sn")
							
							TppRadio.SetOptionalRadio("Set_s0110_oprg0080")
						elseif (newPhase == TppVolgin2.VOLGIN_PHASE_ALERT) then 
							s10110_radio.PlayVolginChangePhase_AleartRadio()
							TppSound.SetSceneBGMSwitch("Set_Switch_bgm_boss_phase_al")
							
							TppRadio.SetOptionalRadio("Set_s0110_oprg0090")
						else
							Fox.Log("BGMNoChanged")
						end
					end
				},
				{
					msg = "VolginGameOverAttackSuccess",
					func = function()
						mvars.isKilledByVolgin = true 
						Fox.Log("isKilledByVolgin")						
					end
				},
				{
					msg = "VolginAttack",
					func = function(gameObjectId, attackType)
						if ( attackType == TppVolgin2.VOLGIN_ATTACK_CHARGE_START) then
							s10110_radio.PlayCounterRadio()
						elseif( attackType == TppVolgin2.VOLGIN_ATTACK_CHARGE_RELEASE)then
							s10110_radio.PlayRunRadio()
						else
							Fox.Log("NoRadio")
						end
					end
				},
				{
					msg = "RoutePoint2",
					sender = "SupportHeli",
					func = function(gameObjectId, routeId ,routeNode, messageId)
						if (messageId == StrCode32("HeliClear")) then
						
							TppMission.ReserveMissionClear{
								missionClearType = TppDefine.MISSION_CLEAR_TYPE.RIDE_ON_HELICOPTER,
								nextMissionId = TppDefine.SYS_MISSION_ID.MTBS_FREE,
							}
							
							mvars.HeliClear = true
							
							TppSound.StopSceneBGM()
						else
							Fox.Log("NoRadio")
						end
						
					end
				},
				{
					msg = "FultonFailedEnd",
					func = function(gameObjectId, locatorName, locatorNameUpper, failureType)
						Fox.Log("FultonFailedEnd")
						if(gameObjectId == GameObject.GetGameObjectId( "vol_factory_0000" )) and ( failureType == TppGameObject.FULTON_FAILED_TYPE_ON_FINISHED_RISE ) then
							s10110_radio.PlayVolginFultonFailedRadio()
							mvars.VolginFultonFinished = true
						else
							Fox.Log("NoRadio")
						end
					end
				},
				{
					msg = "StartedMoveToLandingZone",
					func = function( gameObjectId, lzName )
					Fox.Log("StartedMoveToLandingZone")
						if( mvars.VOLGIN_LIFE_VANISHED == false ) and (mvars.VOLGIN_LIFE_VANISHED_FOREVER == false)then
							s10110_radio.PlayHeli_Volgin_Normal()
						else
							Fox.Log("NoRadio")
						end
					end
				},
				{
					msg = "LostControl",
					sender = SUPPORT_HELI,
					func = function(gameObject, state, attackerId)
						if( attackerId == GameObject.GetGameObjectId( "vol_factory_0000" ) and state == StrCode32("End") ) then
							if( GameObject.SendCommand(gameObjectId, { id="GetPassengerIds" }) == GameObject.GetGameObjectId( "Player" ) )then
								Fox.Log("NoRadio")
							elseif( svars.Count1 < 3 ) then
								s10110_radio.PlayHeliLostControlRadio()
								svars.Count1 = svars.Count1 + 1
							else
								s10110_radio.PlayHeliLostControl3Radio()
								svars.Count1 = 0
							end
						else
							Fox.Log("NoRadio")
						end
					end
				},
				nil,				
			},
			Timer = {
				{
					msg = "Finish",
					sender = "Rain",
					func = function()
						TppWeather.CancelRequestWeather( TppDefine.WEATHER.RAINY )
					end
				},
				{
					msg = "Finish",
					sender = "BrokenWatorTower",
					func = function()
						
						Fox.Log("finish_WatorTower_breaking")
					end
				},
				{
					msg = "Finish",
					sender = "TunnelWallVanished",
					func = function()
						TppDataUtility.SetEnableDataFromIdentifier( "GimmickIdentifier", "Wall_tunnel", false )
					end
				},
			},
			Player = {
				{
					msg = "PlayerFulton",
					func = function( playerId, gameObjectId )
						if gameObjectId == GameObject.GetGameObjectId( "vol_factory_0000" ) and mvars.VolginFulton == false then
							
							s10110_radio.PlayVolginFultonRadio()
							mvars.VolginFulton = true
						else
							Fox.Log("NoRadio")
						end
					end
				},
			},
			Trap = {
				{ 
					msg = "Enter",
					sender = "Trap_Lake",
					func = function ()
						if ( mvars.VOLGIN_LIFE_VANISHED_FOREVER == false ) then
							s10110_radio.PlayLakeRadio()
						else
						end
					end,
				},
				{
					msg = "Enter",
					sender = "Trap_wttr",
					func = function ( trap, player )
						if ( mvars.isBreakWTTR == false and mvars.VOLGIN_LIFE_VANISHED_FOREVER == false ) then
							TppRadio.Play("f1000_rtrg0710")
						else
						end
					end,
				},
				{
					msg = "Enter",
					sender = "Trap_wttk0000",
					func = function ( trap, player )
						if ( mvars.isBreakWTTK0000 == false and mvars.VOLGIN_LIFE_VANISHED_FOREVER == false ) then
							TppRadio.Play("s0110_rtrg0420")
						else
						end
					end,
				},
				{
					msg = "Enter",
					sender = "Trap_wttk0001",
					func = function ( trap, player )
						if ( mvars.isBreakWTTK0001 == false and mvars.VOLGIN_LIFE_VANISHED_FOREVER == false ) then
							TppRadio.Play("s0110_rtrg0420")
						else
						end
					end,
				},
				
				{
					msg = "Enter",
					sender = "Trap_DD2" ,
					func = function()
						local gameObjectId = { type="TppBuddyDog2", index=0 }
						local pos1=Vector3(2788.069, 94.395, -910.213) 
						local pos2=Vector3(2780.872, 94.497, -910.925) 

						local command = { id = "LuaAiStayAndSnarl", position=pos1, look=pos2 }
						if GameObject.GetGameObjectIdByIndex( "TppBuddyDog2",0 ) ~= GameObject.NULL_ID then
							Fox.Log("#### Trap_DD2 #### DD Go!!")
							GameObject.SendCommand( gameObjectId, command )
						else
							Fox.Log("####  DD not exist...")
						end
					end,
				},
				{
					msg = "Enter",
					sender = "Trap_DD3" ,
					func = function()
						local gameObjectId = { type="TppBuddyDog2", index=0 }
						local pos1=Vector3(2772.567, 94.245, -865.468) 
						local pos2=Vector3(2771.378, 94.439, -869.841) 

						local command = { id = "LuaAiStayAndSnarl", position=pos1, look=pos2 }
						if GameObject.GetGameObjectIdByIndex( "TppBuddyDog2",0 ) ~= GameObject.NULL_ID then
							Fox.Log("#### Trap_DD3 #### DD Go!!")
							GameObject.SendCommand( gameObjectId, command )
						else
							Fox.Log("####  DD not exist...")
						end
					end,
				},
				{
					msg = "Enter",
					sender = "Trap_DD5" ,
					func = function()
						local gameObjectId = { type="TppBuddyDog2", index=0 }
						local pos1=Vector3(2861.887, 102.321, -861.647) 
						local pos2=Vector3(2855.434, 102.385, -852.745) 

						local command = { id = "LuaAiStayAndSnarl", position=pos1, look=pos2 }
						if GameObject.GetGameObjectIdByIndex( "TppBuddyDog2",0 ) ~= GameObject.NULL_ID then
							Fox.Log("#### Trap_DD5 #### DD Go!!")
							GameObject.SendCommand( gameObjectId, command )
						else
							Fox.Log("####  DD not exist...")
						end
					end,
				},
				{
					msg = "Enter",
					sender = "Trap_DD4" ,
					func = function()
						local gameObjectId = { type="TppBuddyDog2", index=0 }
						local pos1=Vector3(2827.033, 96.916, -886.182) 
						local pos2=Vector3(2820.780, 96.460, -876.221) 

						local command = { id = "LuaAiStayAndSnarl", position=pos1, look=pos2 }
						if GameObject.GetGameObjectIdByIndex( "TppBuddyDog2",0 ) ~= GameObject.NULL_ID then
							Fox.Log("#### Trap_DD4 #### DD Go!!")
							GameObject.SendCommand( gameObjectId, command )
						else
							Fox.Log("####  DD not exist...")
						end
					end,
				},		
			},
			Radio = {
				
				{ 
					msg = "EspionageRadioPlay",
					sender = "s0110_esrg0120",		
					func = function() 
						TppRadio.ChangeIntelRadio{ vol_factory_0000 = "s0110_esrg0130"	}
					end,
				},
				{ 
					msg = "EspionageRadioPlay",
					sender = "s0110_esrg0130",		
					func = function() 
						TppRadio.ChangeIntelRadio{ vol_factory_0000 = "s0110_esrg0120"	}
					end,
				},
			},
		nil
		}
	end,
	
	OnEnter = function()
	
	TppSound.SetSceneBGM("bgm_volgin_02")
	
	TppSound.SkipDecendingLandingZoneJingle()	
	
	TppUiCommand.SetMisionInfoCurrentStoryNo(1)
	
	TppRadio.ChangeIntelRadio( s10110_radio.intelRadioListEscape2 )
	
	TppDataUtility.SetVisibleDataFromIdentifier( "GimmickIdentifier", "door_after", true, true)
	TppDataUtility.SetVisibleDataFromIdentifier( "GimmickIdentifier", "door_before", false, true)
	
	TppDataUtility.SetEnableDataFromIdentifier( "GimmickIdentifier", "Wall_door", true )
	
	TppDataUtility.SetEnableDataFromIdentifier( "GimmickIdentifier", "Wall_tunnel_after", true )
	
	svars.isInTunnel = true
	
	
	GkEventTimerManager.Start( "TunnelWallVanished", 10.0 )
	
	
	TppRadio.SetOptionalRadio("Set_s0110_oprg0080")
	
	TppRadio.EnableCommonOptionalRadio(false)
	
	GameObject.SendCommand( { type="TppHeli2", index=0, }, { id="SetLandingZnoeDoorFlag", name="lz_Escape1", leftDoor="Open", rightDoor="Close" } ) 
	GameObject.SendCommand( { type="TppHeli2", index=0, }, { id="SetLandingZnoeDoorFlag", name="lz_Escape2", leftDoor="Close", rightDoor="Open" } ) 
	GameObject.SendCommand( { type="TppHeli2", index=0, }, { id="SetLandingZnoeDoorFlag", name="lz_Escape3", leftDoor="Close", rightDoor="Open" } ) 
		if ( mvars.isBreakFrame ~= true ) then
			Fox.Log("OnEnter_Seq_Game_Escape2")
			
			TppMission.CanMissionClear()
			
			








			
			
				TppWeather.RequestWeather( TppDefine.WEATHER.CLOUDY )
			
			GkEventTimerManager.Start( "Rain", 600 )
			
			WeatherManager.RequestTag("factory_Volgin_shadow_long", 3 )
			
			mvars.HeliClear = false
			mvars.VOLGIN_LIFE_VANISHED = false 
			mvars.VOLGIN_LIFE_VANISHED_FOREVER = false 
			mvars.isBreakFrame = true 
			mvars.isKilledByVolgin = false 
			mvars.isBreakWTTK0000 = false 
			mvars.isBreakWTTK0001 = false
			
			this.Initialize_DAMAGED_TYPE()
			
			
			for i, gimmickId in pairs( resetVolginGimmickIdTable ) do
				TppGimmick.ResetGimmick{ gimmickId = gimmickId, searchFromSaveData = false }
			end
		
			
			Fox.Log("BGMVolginSneak")
			TppSound.SetSceneBGM("bgm_volgin_02")
			TppSound.SetSceneBGMSwitch("Set_Switch_bgm_boss_phase_sn")
			
			
			TppHelicopter.SetEnableLandingZone{ landingZoneName = "lz_Escape1" }
			TppHelicopter.SetEnableLandingZone{ landingZoneName = "lz_Escape2" }
			TppHelicopter.SetEnableLandingZone{ landingZoneName = "lz_Escape3" }
			TppHelicopter.SetDisableLandingZone{ landingZoneName = "s10110_lz0000" }
			TppUI.ShowAnnounceLog( "unlockLz" )
		
			
			local gameObjectId = { type="TppVolgin2", index=0 }
			local command = {id="Warp", position="position", rotationY="rotationY"}
			command.position = Vector3(2722.256,94.297,-931.92)
			command.rotationY = 90.0
			GameObject.SendCommand(gameObjectId, command)
			
			local gameObjectId = { type="TppVolgin2", index=0 }
			local command = {id="EnableCombat"}
			GameObject.SendCommand(gameObjectId, command)
			
			GameObject.SendCommand({type="TppVolgin2", group=0, index=0}, {id="SetTunnelDestroyed"})
			
			TppDataUtility.SetEnableDataFromIdentifier( "GimmickIdentifier", "Wall_tunnel", false )
			
			
			local gameObjectId = GameObject.GetGameObjectId( "vol_factory_0000" )
			local command = {id="SetRoute", route="route", point="point"}
			if gameObjectId ~= NULL_ID then
				command.route = "rts_vol_sneak"
				command.point = 0
				GameObject.SendCommand(gameObjectId, command)
			end
		
			
			TppDataUtility.SetVisibleDataFromIdentifier( "GimmickIdentifier", "Volgin_BrokenWall", true, true)
			TppDataUtility.SetVisibleDataFromIdentifier( "GimmickIdentifier", "Volgin_BrokenTunnel", true, true)
			
			TppDataUtility.SetVisibleDataFromIdentifier( "GimmickIdentifier", "Broken_stfr0001", false, true) 
			TppDataUtility.SetVisibleDataFromIdentifier( "GimmickIdentifier", "Broken_stfr0002", false, true) 
			
			TppDataUtility.SetVisibleEffectFromGroupId( "fire_outland", true )
			TppDataUtility.SetVisibleEffectFromGroupId( "fire_in_factory", true )
			TppDataUtility.SetVisibleEffectFromGroupId( "fire_outland_01b", true )
			TppDataUtility.CreateEffectFromGroupId( "fire_outland", true )
			TppDataUtility.CreateEffectFromGroupId( "fire_in_factory", true )
			TppDataUtility.CreateEffectFromGroupId( "fire_outland_01b", true )
			TppDataUtility.SetVisibleEffectFromGroupId( "fire_outland2", true )
			TppDataUtility.CreateEffectFromGroupId( "fire_outland2", true )
			TppDataUtility.SetVisibleEffectFromGroupId( "fire_in_factory", false )
			TppDataUtility.DestroyEffectFromGroupId( "fire_in_factory", true )
			
			TppDataUtility.SetVisibleEffectFromGroupId( "fire_in_factory_door", true )
			TppDataUtility.CreateEffectFromGroupId( "fire_in_factory_door", true )
			
			s10110_radio.PlayBreakTunnelRadio()
			
			GameObject.SendCommand( { type="TppHeli2", index=0, }, { id="SetAutoWithdrawalEnabled", enabled=false } )
			
			vars.playerDisableActionFlag = PlayerDisableAction.TIME_CIGARETTE
			
			TppMission.StartBossBattle()
			














		
		end
	end,
}
























return this
