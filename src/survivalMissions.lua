SurvivalMissions = {}
SurvivalMissions.name = "SurvivalMissions"

function SurvivalMissions:loadMap()
    print('Survival: Mission impossible 22')

    -- Optimize mission rewards
    AbstractFieldMission.REWARD_PER_HA = 600
    CultivateMission.REWARD_PER_HA = 600
    FertilizeMission.REWARD_PER_HA = 200
    FertilizeMission.REIMBURSEMENT_PER_HA = 250
    HarvestMission.REWARD_PER_HA_SMALL = 1000
    HarvestMission.REWARD_PER_HA_WIDE = 400
    PlowMission.REWARD_PER_HA = 1200
    SowMission.REWARD_PER_HA = 500
    SprayMission.REWARD_PER_HA = 150
    SprayMission.REIMBURSEMENT_PER_HA = 200
    BaleMission.REWARD_PER_HA_HAY = 2000
    BaleMission.REWARD_PER_HA_SILAGE = 2250
    BaleMission.REWARD_PER_METER = 1
    WeedMission.REWARD_PER_HA = 200

    -- Mission generation
    MissionManager.MAX_MISSIONS_PER_GENERATION = 20
    MissionManager.MAX_TRIES_PER_GENERATION = 10
    MissionManager.MAX_MISSIONS = 100
    MissionManager.MISSION_GENERATION_INTERVAL = 1800000
    MissionManager.MAX_TRANSPORT_MISSIONS = 0
    MissionManager.AI_PRICE_MULTIPLIER = 10

    -- Disable vehicle leasing
    AbstractFieldMission.hasLeasableVehicles = Utils.overwrittenFunction(AbstractFieldMission.hasLeasableVehicles,
        SurvivalMissions.hasLeasableVehicles)
end

function SurvivalMissions:hasLeasableVehicles()
	return false
end

addModEventListener(SurvivalMissions)
