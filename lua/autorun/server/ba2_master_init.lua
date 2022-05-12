include("autorun/ba2_shared.lua")
include("ba2/methods.lua")
include("ba2/door_manager.lua")

util.AddNetworkString("BA2NoNavmeshWarn")
util.AddNetworkString("BA2ReloadCustoms")
util.AddNetworkString("BA2ZomDeathNotice")
util.AddNetworkString("BA2PerformanceHint")

-- CreateConVar("ba2_cos_defaultcolor_r",133,FCVAR_ARCHIVE,[[Just save yourself the trouble and set this in the options menu.]])
-- CreateConVar("ba2_cos_defaultcolor_g",165,FCVAR_ARCHIVE,[[Just save yourself the trouble and set this in the options menu.]])
-- CreateConVar("ba2_cos_defaultcolor_b",180,FCVAR_ARCHIVE,[[Just save yourself the trouble and set this in the options menu.]])
CreateConVar("ba2_cos_tint",0,FCVAR_ARCHIVE,[[If enabled, Custom Infected will have blue-tinted models like other zombies.]])

CreateConVar("ba2_hs_max",40,FCVAR_ARCHIVE,[[The maximum number of Horde Spawner-created zombies that can be alive at once.
    More zombies means more difficulty - for both you and your machine.]],1)
CreateConVar("ba2_hs_interval",1,FCVAR_ARCHIVE,[[The Horde Spawner will wait this long before spawning a new group of zombies.
    The lower this is, the faster zombies will spawn.]],0.1)
CreateConVar("ba2_hs_saferadius",500,FCVAR_ARCHIVE,[[The Horde Spawner cannot spawn zombies closer to potential targets than this distance.
    You may need to decrease this value down on very small maps.]],0)
CreateConVar("ba2_hs_maxradius",0,FCVAR_ARCHIVE,[[If above 0, the Horde Spawner must spawn zombies within this distance of potential targets.
    Useful on very large maps, but may cause extra lag during spawning.]],0)
-- CreateConVar("ba2_hs_appearance",5,FCVAR_ARCHIVE,[[Configures the type of zombie the Horde Spawner creates.
--     0: Citizens
--     1: Rebels
--     2: Cobmine
--     3: Custom
--     4: Any of the above
--     5: Any except Custom Infected]],0,5
-- )
CreateConVar("ba2_hs_appearance_0",1,FCVAR_ARCHIVE,[[If enabled, Spawners  will create Infected Citizens.]])
CreateConVar("ba2_hs_appearance_1",1,FCVAR_ARCHIVE,[[If enabled, Spawners  will create Infected Rebels.]])
CreateConVar("ba2_hs_appearance_2",1,FCVAR_ARCHIVE,[[If enabled, Spawners  will create Infected Metrocops.]])
CreateConVar("ba2_hs_appearance_3",1,FCVAR_ARCHIVE,[[If enabled, Spawners  will create Custom Infected.]])
CreateConVar("ba2_hs_combine_chance",10,FCVAR_ARCHIVE,[[The chance for Spawners to spawn armored Infected Combine.]],0,100)
CreateConVar("ba2_hs_carmor_chance",0,FCVAR_ARCHIVE,[[The chance for Spawners to spawn Custom Armored Infected.]],0,100)
CreateConVar("ba2_hs_cleanup",1,FCVAR_ARCHIVE,[[If enabled, Spawners will also remove all of the zombies it created when it gets deleted.]])
concommand.Add("ba2_hs_delete",BA2_DestroyHS,nil,"Destroys the active Horde Spawner, if it exists.")
concommand.Add("ba2_aw_delete",BA2_DestroyAW,nil,"Destroys the active Air Waste, if it exists.")
CreateConVar("ba2_hs_notargetclean",1,FCVAR_ARCHIVE,[[If enabled, the Horde Spawner will delete and eventually replace zombies who do not find a target within 6 sceonds of spawning.]])
CreateConVar("ba2_hs_stuckclean",0,FCVAR_ARCHIVE,[[!EXPERIMENTAL! If enabled, the Horde Spawner will delete and eventually replace stuck zombies.]])
CreateConVar("ba2_hs_morespawnlocations",0,FCVAR_ARCHIVE,[[!EXPERIMENTAL! If enabled, the Horde Spawner will use more locations to spawn zombies.]])
CreateConVar("ba2_hs_proximityspawns",0,FCVAR_ARCHIVE,[[!EXPERIMENTAL! If enabled, the Horde Spawner will spawn zombies close to targets instead of all over the map.]])
CreateConVar("ba2_ps_interval",1,FCVAR_ARCHIVE,[[The Point Spawner will wait this long before spawning a new group of zombies.
The lower this is, the faster zombies will spawn.]],0.1)
CreateConVar("ba2_hs_zom_range",0,FCVAR_ARCHIVE,[[Multiply horde-spawned zombie targeting range by this amount.
    Set to 0 to use ba2_zom_range instead.
    If you do change this, make sure it is greater than ba2_hs_saferadius by a decent amount.]],0)
CreateConVar("ba2_hs_stoptargetingoutsidedetectionrange",0,FCVAR_ARCHIVE,[[!EXPERIMENTAL! If enabled, horde-spawned zombies will stop targeting entities outside of their detection range.]],0)

CreateConVar("ba2_inf_contagionmult",1,FCVAR_ARCHIVE,[[Mutliply the distance the Bio-Virus can spread to others by this amount.
    Set to 0 to disable contagion.]],0)
CreateConVar("ba2_inf_plymult",1,FCVAR_ARCHIVE,[[Multiply infection received by players by this amount.
    Set to 0 to prevent player infection.]],0)
CreateConVar("ba2_inf_npcmult",1,FCVAR_ARCHIVE,[[Multiply infection received by NPCs by this amount.
    Set to 0 to prevent NPC infection.]],0)
CreateConVar("ba2_inf_plyraise",1,FCVAR_ARCHIVE,[[If enabled, players killed by the Bio-Virus will be raised into zombies.]])
CreateConVar("ba2_inf_npcraise",1,FCVAR_ARCHIVE,[[If enabled, NPCs killed by the Bio-Virus will be raised into zombies.]])
CreateConVar("ba2_inf_dmgmult",1,FCVAR_ARCHIVE,[[Multiply damage dealt by infection by this amount.]],0)
CreateConVar("ba2_inf_killtoraise",1,FCVAR_ARCHIVE,[[If enabled, the Bio-Virus or one of its hosts must directly kill a victim to raise them into a zombie.
    This means that you can kill an infected entity to prevent them from becoming a zombie, or commit suicide to prevent yourself from being raised.]])
CreateConVar("ba2_inf_maxzoms",80,FCVAR_ARCHIVE,[[The Bio-Virus will not raise new zombies if there are this many active zombies; instead, the corpse despawns.
    More zombies means more difficulty - for both you and your machine.
    Set to 0 to enable expert mode: unlimited capacity.]],0)
CreateConVar("ba2_inf_romeromode",0,FCVAR_ARCHIVE,[[If enabled, all entities who die will become a zombie regardless of their infection level.]])
concommand.Add("ba2_inf_deleteclouds",BA2_DestroyClouds,nil,"Destroys all Contaminant Clouds on the map.")

CreateConVar("ba2_zom_pursuitspeed_ge",120,FCVAR_ARCHIVE,[[Configures the speed zombies run at when they find a target.
    45: Pacing speed ("*yawn* Let me get a drink...")
    120: Running ("Give me some space, will you?")
    300: Full sprint ("OH GOD RUN")]],0
)
CreateConVar("ba2_zom_health",100,FCVAR_ARCHIVE,[[Zombies have this much health. Minimum 1. Only affects new zombies.]],1)
CreateConVar("ba2_zom_dmgmult",1,FCVAR_ARCHIVE,[[Multiply zombie damage per attack by this amount.]],0)
CreateConVar("ba2_zom_propdmgmult",1,FCVAR_ARCHIVE,[[Multiply zombie damage per attack to props and doors by this amount.
Does not stack with ba2_zom_dmgmult.]],0)
CreateConVar("ba2_zom_infectionmult",1,FCVAR_ARCHIVE,[[Multiply zombie infection per attack by this amount.]],0)
CreateConVar("ba2_zom_range",10000,FCVAR_ARCHIVE,[[Multiply zombie targeting range by this amount.
    High values may result in more lag when there are no valid targets.
    Set to 0 to turn them into the most miserable beings in existence.]],0)
CreateConVar("ba2_zom_nonheadshotmult",1,FCVAR_ARCHIVE,[[Multiply zombie damage received on non-headshots by this amount.]],0,1)
CreateConVar("ba2_zom_limbdamagemult",.5,FCVAR_ARCHIVE,[[Multiply zombie damage received on limb shots by this amount.]],0,1)
CreateConVar("ba2_zom_armordamagemult",.75,FCVAR_ARCHIVE,[[Multiply armored zombie damage received to the head and torso by this amound.]],0,1)
CreateConVar("ba2_zom_damagestun",1,FCVAR_ARCHIVE,[[If enabled, zombies will stagger if they take more than half their current health in damage.]])
CreateConVar("ba2_zom_emergetime",8,FCVAR_ARCHIVE,[[After getting killed by an infectious source, entities will take this long to rise into a zombie.]])
CreateConVar("ba2_zom_armdamage",1,FCVAR_ARCHIVE,[[If enabled, zombies can have their arms broken.
    Each lost arm halves damage output. If both arms are broken, the zombie cannot grab targets or break down barricades.]])
CreateConVar("ba2_zom_legdamage",1,FCVAR_ARCHIVE,[[If enabled, zombies can have their legs broken.
    Legs are harder to break than arms, but breaking one forces them to crawl, making them slower and easier to headshot.]])
CreateConVar("ba2_zom_armbreakmultiplier",0.5,FCVAR_ARCHIVE,[[Zombies must have this percentage of their health missing before their arms can be removed.]],0,1)
CreateConVar("ba2_zom_legbreakmultiplier",0.75,FCVAR_ARCHIVE,[[Zombies must have this percentage of their health missing before their arms can be removed.]],0,1)
CreateConVar("ba2_zom_explimbdamage",1,FCVAR_ARCHIVE,[[If enabled, zombies have a chance to lose a random limb when they take explosive damage. (NYI)]])
CreateConVar("ba2_zom_medicdropchance",20,FCVAR_ARCHIVE,[[The percent chance for an Infected Rebel with a Medic model to drop a Health Vial on death.
    Set to 0 to disable this feature.]],0,100)
CreateConVar("ba2_zom_breakobjects",1,FCVAR_ARCHIVE,[[If enabled, zombies can swat at and damage props and doors in their way.]])
CreateConVar("ba2_zom_breakphys",1,FCVAR_ARCHIVE,[[If enabled, zombies can unfreeze and unconstrain props with their swatting.]])
CreateConVar("ba2_zom_breakdoors",1,FCVAR_ARCHIVE,[[If enabled, zombies can break down standard doors.]])
CreateConVar("ba2_zom_doorrespawn",30,FCVAR_ARCHIVE,[[The time in seconds it takes for a door to respawn after getting broken down.
    If this value is zero or less, then the door will not respawn until the map is cleaned up.]],0)
CreateConVar("ba2_zom_variablepropforce",0,FCVAR_ARCHIVE,[[If enabled, zombies will be able to push over much heavier props.]])
CreateConVar("ba2_zom_ptwander",0,FCVAR_ARCHIVE,[[!EXPERIMENTAL! If enabled, zombies will use path-tracing checks when wandering.
This can significantly increase performance when zombies are in confined areas.]])
CreateConVar("ba2_zom_handlebadpaths",0,FCVAR_ARCHIVE,[[!EXPERIMENTAL! If enabled, bad paths will be handled quickly instead of being left to lag the game.
This can significantly increase performance when zombies are in confined areas.]])
CreateConVar("ba2_zom_notargetnoclip",0,FCVAR_ARCHIVE,[[!EXPERIMENTAL! If enabled, zombies won't target noclipping players.]])
CreateConVar("ba2_zom_betterdoorbreaking",0,FCVAR_ARCHIVE,[[!EXPERIMENTAL! If enabled, many broken doors will not have a strange void behind them.]])
CreateConVar("ba2_zom_attackmode",0,FCVAR_ARCHIVE,[[Determines how zombies will attack their targets.
    0: Grab
    1: Claw]])
CreateConVar("ba2_zom_retargeting",1,FCVAR_ARCHIVE,[[If enabled, zombies will periodically switch targets if another target is closer to them for enough time.
This may cause stuttering, so it's recommended to disable this if you have performance issues with lots of zombies.]])
CreateConVar("ba2_zom_corpseeat",1,FCVAR_ARCHIVE,[[If enabled, zombies will seek out and eat corpses while there are no targets within their range.]])


CreateConVar("ba2_misc_corpselife",10,FCVAR_ARCHIVE,[[The amount of time before a zombie's corpse is cleaned up.
    Set to -1 for infinite lifetime.]],-1
)
CreateConVar("ba2_misc_navmeshwarn",1,FCVAR_ARCHIVE,[[If enabled, Zambo the Helper Zombie will notify you if the map has no navmesh when you load in.]])
CreateConVar("ba2_misc_maxfilters",4,FCVAR_ARCHIVE,[[The maximum number of gas mask filters each player can carry.
    Set to -1 to disable this limit.]],-1)
CreateConVar("ba2_misc_startwithmask",0,FCVAR_ARCHIVE,[[If enabled, all players will spawn with a gas mask on their person.]])
CreateConVar("ba2_misc_deathdropmask",1,FCVAR_ARCHIVE,[[If enabled, players will drop their gas mask on death.]])
CreateConVar("ba2_misc_deathdropfilter",1,FCVAR_ARCHIVE,[[If enabled, players will drop all of their gas mask filters on death.]])
CreateConVar("ba2_misc_headshoteff",1,FCVAR_ARCHIVE,[[If enabled, zombies' heads have a chance to comically explode when they are killed by a headshot.]])
CreateConVar("ba2_misc_addscore",1,FCVAR_ARCHIVE,[[If enabled, killing a zombie will award a frag to the player who killed them.]])
CreateConVar("ba2_misc_gammaeditioninfo",1,FCVAR_ARCHIVE,[[If enabled, shows information about experimental Gamma Edition features when you load in.]])
CreateConVar("ba2_misc_isnpc",1,FCVAR_ARCHIVE,[[If enabled, other addons will consider zombies an NPC for the purpose of IsNPC() checks.
Enabling this may correct interactions with some addons (for example, JMod), but can cause Lua errors in others. Enable at your own risk.]])
CreateConVar("ba2_misc_gibdecals",1,FCVAR_ARCHIVE,[[If enabled, zombie gibs will leave lovely bloodstains on any surface they fall onto.]])

concommand.Add("ba2_misc_maggots",BA2_ToggleMaggotMode,nil,"If God had wanted you to live, he would not have created ME!")
--CreateConVar("ba2_misc_kidsmode",0,FCVAR_ARCHIVE,[[If enabled, this mod will become less appalling to the ESRB.]])

concommand.Add("ba2_gasmask",BA2_ToggleGasmask,nil)
concommand.Add("ba2_dgasmask",BA2_DropGasmask,nil)
concommand.Add("ba2_dfilter",BA2_DropFilter,nil)
concommand.Add("ba2_ufilter",BA2_UFilter,nil)
concommand.Add("ba2_cfilter",BA2_CheckFilter,nil)


-- Net messages
net.Receive("BA2ReloadCustoms",function(l,p)
    if p:IsAdmin() then
        BA2_WriteToAltModels(net.ReadTable())
        BA2_ReloadCustoms()
    end
end)

-- Unique functions
function BA2_InfectionTick(ent)
    if ent.BA2Infection == nil or ent.BA2Infection == 0 then return end

    local dmg = DamageInfo()
    dmg:SetDamage(math.random(3,5) * GetConVar("ba2_inf_dmgmult"):GetFloat())
    dmg:SetDamageType(DMG_DIRECT)
    dmg:SetDamageCustom(DMG_BIOVIRUS)
    dmg:SetAttacker(BA2_InfectionManager())
    dmg:SetInflictor(BA2_InfectionManager())
    
    local lastArmor = nil
    local lastHealth = ent:Health()
    if ent:IsPlayer() and ent:Armor() > 0 then
        lastArmor = ent:Armor()
        ent:SetArmor(0)
    end
    if ent.BA2Infection_FirstTick then
        dmg:SetDamageType(DMG_NERVEGAS)
    end
    ent:TakeDamageInfo(dmg)
    if lastArmor then
        ent:SetArmor(lastArmor)
    end

    if ent.BA2Infection_FirstTick then
        if ent:Health() == lastHealth then
            ent.BA2Infection = 0
            return 
        end
        ent.BA2Infection_FirstTick = false  
    end

    if ent:IsPlayer() and ent:GetInfoNum("ba2_cl_infdmgeff",1) == 1 then
        ent:ScreenFade(SCREENFADE.IN,Color(74,127,0,32),.75,0)
    end

    if IsValid(ent) or (ent:IsPlayer() and ent:Alive()) then
        timer.Simple(0,function()
            if ent.BA2Infection == nil then return end

            if IsValid(ent) and GetConVar("ba2_inf_contagionmult"):GetFloat() > 0 and !BA2_GetActiveMask(ent) then
                if BA2_JMod and ent:IsPlayer() and JMod_GetArmorBiologicalResistance(ent,DMG_NERVEGAS) > 0 then
                    return
                end
                
                for i,e in pairs(ents.FindInSphere(ent:GetPos(),100 * GetConVar("ba2_inf_contagionmult"):GetFloat())) do
                    if BA2_JMod and e:IsPlayer() and JMod_GetArmorBiologicalResistance(e,DMG_NERVEGAS) > 0 then
                        continue
                    end

                    if e ~= ent and !BA2_GetActiveMask(e) and !(ent:IsNPC() and e:IsPlayer() and GetConVar("ai_ignoreplayers"):GetBool())
                    and (e.BA2Infection == nil or e.BA2Infection < ent.BA2Infection) then
                        BA2_AddInfection(e,ent.BA2Infection / math.random(4,8))
                    end
                end
            end
            
            if math.random(1,2) == 1 then
                ent:EmitSound("ba2_infectdamage",75,100,1,CHAN_VOICE)
            end
            if ent.BA2Infection * 3 > ent:Health() then
                --ent:SetColor(BA2_GetDefaultColor())
                ent:EmitSound("ba2_infectcry",75,100,1,CHAN_VOICE)
            -- elseif ent:GetColor() == BA2_GetDefaultColor() then
            --     ent:SetColor(Color(255,255,255))
            end
    
            ent.BA2Infection = math.max(0,ent.BA2Infection - 1)
        end)
    end
end


function BA2_InfectionDeath(ent,inflict,killer,dmg)
    --if ent.BA2Infection == 0 and not GetConVar("ba2_inf_romeromode"):GetBool() then return end
    if ent:IsNPC() and (!GetConVar("ba2_inf_npcraise"):GetInt() or (!BA2_ConvertibleNpcs[ent:GetClass()] and !ent.IsVJBaseSNPC_Human)) then return end
    if string.StartWith(ent:GetClass(),"nb_ba2_infected") then return end

    if GetConVar("ba2_inf_romeromode"):GetBool() or (!GetConVar("ba2_inf_killtoraise"):GetBool() and ent.BA2Infection > 0)
         or inflict == BA2_InfectionManager() or (dmg ~= nil and dmg:GetDamageCustom() == DMG_BIOVIRUS)
         or (IsValid(killer) and string.StartWith(killer:GetClass(),"nb_ba2_infected")) then
        local riseTime = GetConVar("ba2_zom_emergetime"):GetFloat()

        if riseTime == 0 then
            BA2_RaiseZombie(ent)
        else
            local body = ents.Create("prop_ragdoll")

            body:SetPos(ent:GetPos())
            body:SetAngles(ent:GetAngles())
            body:SetModel(ent:GetModel())
            body:SetColor(BA2_GetDefaultColor())
            body:SetSkin(ent:GetSkin())
            for i = 1,ent:GetNumBodyGroups() do
                body:SetBodygroup(i,ent:GetBodygroup(i))
            end
            body:SetCollisionGroup(COLLISION_GROUP_WEAPON)

            for id = 1,body:GetPhysicsObjectCount() do
                local bone = body:GetPhysicsObjectNum(id - 1)
                if IsValid(bone) then
                    local pos,angle = ent:GetBonePosition(body:TranslatePhysBoneToBone(id - 1))
                    bone:SetPos(pos)
                    bone:SetAngles(angle)
                    bone:AddVelocity(ent:GetVelocity())
        
                    body:ManipulateBoneScale(id - 1,ent:GetManipulateBoneScale(id - 1))
                end
            end

            if ent:IsPlayer() then
                local PlyVo = math.floor(ent:GetInfoNum("ba2_cl_playervoice",-1))
                if PlyVo ~= -1 then
                    body.InfVoice = PlyVo
                end
            end

            body:Spawn()
            body:Activate()
            body:SetVelocity(ent:GetVelocity())
            if dmg ~= nil then
                body:GetPhysicsObject():ApplyForceCenter(dmg:GetDamageForce())
            end

            timer.Simple(riseTime,function()
                if IsValid(body) then
                    BA2_RaiseZombie(body)
                    body:Remove()
                end
            end)
        end

        timer.Simple(0,function()
            SafeRemoveEntity(ent)
            if ent:IsPlayer() then
                SafeRemoveEntity(ent:GetRagdollEntity())
            end
        end)
    end
end

function BA2_ZombieGrab(zom,ent)
    if ent:IsPlayer() then
        if ent.InitWalk == nil then
            ent.InitWalk = ent:GetWalkSpeed()
        end
        if ent.InitRun == nil then
            ent.InitRun = ent:GetRunSpeed()
        end

        ent:ViewPunch(Angle(10,0,0))
    elseif ent:IsNPC() then
        ent.GrabPos = ent:GetPos()
        if ent.StopMoving then
            ent:StopMoving()
        end
    end

    timer.Create(zom:EntIndex().."-grab",0,0,function()
        if !IsValid(zom) or !IsValid(ent) or (ent:IsPlayer() and !ent:Alive()) or !zom:GetAttacking() then
            if ent:IsPlayer() then
                ent.BA2Grabbed = nil
            end
            timer.Remove(zom:EntIndex().."-grab")
        else
            if ent:IsPlayer() then
                ent.BA2Grabbed = true
            else
                ent:SetPos(ent.GrabPos)
            end
        end
    end)
end

function BA2_GetDefaultColor()
    return Color(133,165,180)
end

function BA2_ToggleMaggotMode()
    if not IsMounted("tf") then
        print("Numbnuts! You need to mount Team Fortress 2!")
    else
        if BA2_MaggotMode == nil then
            BA2_MaggotMode = true
            print("Maggot Mode activated! Booyah!")
        else
            BA2_MaggotMode = nil
            print("Maggot Mode is off! You have dishonored this entire unit.")
        end

        if os.date("%m") == "05" then
            print("You were good, son. Real good. Maybe even the best...")
        end
    -- else
    --     print("Come back the month of May, hippie!")
    end
end
function BA2_GetMaggotMode()
    return BA2_MaggotMode ~= nil
end

function BA2_DestroyHS()
    local hs = ents.FindByClass("ba2_hordespawner")
    if #hs >= 1 then
        hs[1]:Remove()
        print("BA2: Horde Spawner removed by console")
    else
        print("BA2: No Horde Spawner found!")
    end
end

function BA2_DestroyAW()
    local aw = ents.FindByClass("ba2_airwaste")
    if #aw >= 1 then
        aw[1]:Remove()
        print("BA2: Air Waste removed by console")
    else
        print("BA2: No Air Waste found!")
    end
end

function BA2_DestroyClouds()
    for i,c in pairs(ents.FindByClass("ba2_virus_cloud")) do
        c:Remove()
    end

    print("BA2: Clouds removed by console")
end


function BA2_ToggleGasmask(p)
    if p:GetNWBool("BA2_GasmaskOwned",false) then
        local bool = p:GetNWBool("BA2_GasmaskOn",false)

        if bool then
            p:EmitSound("npc/combine_soldier/zipline_hitground2.wav")
            BA2_GasmaskSound(p)
            
        else
            p:EmitSound("npc/combine_soldier/zipline_hitground1.wav")
            BA2_GasmaskSound(p,p.BA2_MaskSoundName or "ba2/gasmask/mask_breathe_light.wav")
        end

        p:SetNWBool("BA2_GasmaskOn",not bool)
        p:ViewPunch(Angle(10,0,0))
    else
        p:ChatPrint("You don't have a gas mask.")
    end
end

function BA2_DropGasmask(p)
    if !p:GetNWBool("BA2_GasmaskOwned",false) then
        p:ChatPrint("You don't have a gas mask.")
    else
        p:EmitSound("npc/combine_soldier/zipline_hitground2.wav")
        
        local mask = ents.Create("ba2_gasmask")
        mask:SetPos(p:EyePos())
        mask:SetAngles(p:EyeAngles())
        mask.BA2_FilterPct = p:GetNWInt("BA2_GasmaskFilterPct",100)
        mask:Spawn()
        mask:Activate()
        mask:GetPhysicsObject():ApplyForceCenter(p:GetForward() * 90)

        BA2_GasmaskSound(p)
        p:SetNWBool("BA2_GasmaskOn",false)
        p:SetNWBool("BA2_GasmaskOwned",false)
    end
end
function BA2_DropFilter(p)
    if p:GetNWInt("BA2_GasmaskFilters",0) == 0 then
        p:ChatPrint("You don't have any reserve filters.")
    else
        local filter = ents.Create("ba2_gasmask_filter")
        filter:SetPos(p:EyePos() + p:GetForward() * 9)
        filter:SetAngles(p:EyeAngles())
        filter:Spawn()
        filter:Activate()
        filter:GetPhysicsObject():ApplyForceCenter(p:GetForward() * 900)

        p:SetNWInt("BA2_GasmaskFilters",p:GetNWInt("BA2_GasmaskFilters",1) - 1)
        p:EmitSound("physics/metal/weapon_footstep2.wav")
    end
end
function BA2_CheckFilter(p)
    if p:GetNWBool("BA2_GasmaskOwned",false) then
        p:ChatPrint("Gas Mask: "..math.ceil(p:GetNWInt("BA2_GasmaskFilterPct",0)).."%")
    else
        p:ChatPrint("Gas Mask: N/A")
    end

    p:ChatPrint("Reserve Filters: "..p:GetNWInt("BA2_GasmaskFilters",0))
end
function BA2_UFilter(p)
    if !p:GetNWBool("BA2_GasmaskOwned",false) then
        p:ChatPrint("You don't have a gas mask.")
    elseif !GetConVar("ba2_misc_maskfilters"):GetBool() then
        p:ChatPrint("These filters are perpetual. Swapping them out won't be necessary.")
    elseif p:GetNWBool("BA2_GasmaskOn",false) then
        p:ChatPrint("You will need to take off your gas mask first. (!gasmask)")
    elseif p:GetNWInt("BA2_GasmaskFilters",0) == 0 then
        p:ChatPrint("You don't have any reserve filters.")
    elseif p:GetNWInt("BA2_GasmaskFilterPct",0) == 100 then
        p:ChatPrint("Your gas mask already has a fresh filter.")
    else
        p:SetNWInt("BA2_GasmaskFilterPct",100)
        p:SetNWInt("BA2_GasmaskFilters",p:GetNWInt("BA2_GasmaskFilters",1) - 1)

        local prop = ents.Create("ba2_gasmask_filter")
        prop.BA2_Scenic = true

        prop:SetPos(p:EyePos() + p:GetForward() * 18)
        prop:Spawn()
        prop:Activate()
        prop:GetPhysicsObject():ApplyForceCenter(p:GetForward() * 900)

        SafeRemoveEntityDelayed(prop,6)

        p:EmitSound("physics/metal/weapon_footstep1.wav")
        p:ViewPunch(Angle(10,0,0))
    end
end

function BA2_GasmaskSound(p,sound)
    if sound == nil then
        if p.BA2_MaskSound == nil then return end
        p.BA2_MaskSound:Stop()
        p.BA2_MaskSoundName = nil
    elseif p.BA2_MaskSound == nil then
        p.BA2_MaskSound = CreateSound(p,sound)
        p.BA2_MaskSoundName = sound
        p.BA2_MaskSound:Play()
    elseif sound ~= p.BA2_MaskSoundName then
        p.BA2_MaskSound:Stop()
        p.BA2_MaskSound = CreateSound(p,sound)
        p.BA2_MaskSoundName = sound
        p.BA2_MaskSound:Play()
    end
end

-- Hooks and timers
hook.Add("PlayerSpawn","ba2_initSpeed",function(p)
    p.BA2Infection = 0
    p.BA2_NoClipNoTarget = false
end)

hook.Add("SetupMove","BA2_GrabSlow",function(p,mv,cmd)
    if p.BA2Grabbed == true then
        mv:SetMaxClientSpeed(20)
    end
end)

hook.Add("OnEntityCreated","ba2_npcZomRelation",function(npc)
    if npc:IsNPC() then
        for i,z in pairs(ents.FindByClass("nb_ba2_infected*")) do
            if npc.IsVJBaseSNPC then
                timer.Simple(0,function()
                    if IsValid(npc) and IsValid(z) and npc.VJ_AddCertainEntityAsEnemy ~= nil then
                        table.insert(npc.VJ_AddCertainEntityAsEnemy,z)
                        table.insert(npc.CurrentPossibleEnemies,z)
                    end
                end)
            end
            npc:AddEntityRelationship(z,D_HT,1)
        end
    elseif string.StartWith(npc:GetClass(),"nb_ba2_infected") then -- Vrej, why must I hardcode this ;-;
        for i,n in pairs(ents.FindByClass("npc_*")) do
            if n.IsVJBaseSNPC then
                table.insert(n.VJ_AddCertainEntityAsEnemy,npc)
                table.insert(n.CurrentPossibleEnemies,npc)
                n:AddEntityRelationship(npc,D_HT,1)
            end
        end
    end
end)

hook.Add("PlayerNoClip", "BA2_NoClipNoTarget", function(ply, desiredNoClipState)
    if desiredNoClipState and GetConVar("ba2_zom_notargetnoclip"):GetBool() then
        ply.BA2_NoClipNoTarget = true
    else
        ply.BA2_NoClipNoTarget = false
    end
end)

-- ULX compatibility
if ULib and ulx then
    hook.Add(ULib.HOOK_COMMAND_CALLED, "BA2_NoClipNoTargetULX", function(executor, cmd, args)
        if cmd == "ulx noclip" then
            local targetPlayers = args

            if !targetPlayers or #targetPlayers == 0 then
                targetPlayers = {executor}
            end

            for i = 1, #targetPlayers do
                local target

                if type(targetPlayers[i]) == "Player" then
                    target = targetPlayers[i]
                else
                    target = ULib.getUser(targetPlayers[i], true, executor)
                end

                if !target or !IsValid(target) then continue end

                if !target.NoNoclip then
                    -- This is a little counterintuitive: 
                    -- If we're not noclipping, ULX is about to start us and we shouldn't be targeted.
                    -- If we're currently noclipping, ULX is about to stop us and we should be targeted. 
                    if target:GetMoveType() == MOVETYPE_WALK and GetConVar("ba2_zom_notargetnoclip"):GetBool() then
                        target.BA2_NoClipNoTarget = true
                    elseif target:GetMoveType() == MOVETYPE_NOCLIP then
                        target.BA2_NoClipNoTarget = false
                    end
                end
            end
        end
    end)
end

timer.Create("BA2_ServerTick",1.25,0,function()
    local entTable = table.Add(player.GetAll(),ents.FindByClass("npc_*"))

    for i,ent in pairs(entTable) do
        if ent.BA2Infection == nil then
            ent.BA2Infection = 0
        elseif ent.BA2Infection > 0 then
            BA2_InfectionTick(ent)
        end

        if ent:IsPlayer() then
            if ent.BA2_Exhaustion == nil then
                ent.BA2_Exhaustion = 0
            end

            local exhaustThres = 25 - (ent:GetMaxHealth() - ent:Health()) / 8
            if ((ent:IsSprinting() and ent:GetVelocity():Length() > 0) or ent:WaterLevel() == 3) and ent.BA2_Exhaustion < 40 then
                ent.BA2_Exhaustion = ent.BA2_Exhaustion + 5
            elseif ent:GetVelocity():Length() > ent:GetWalkSpeed() then
                ent.BA2_Exhaustion = ent.BA2_Exhaustion - 1
            else
                ent.BA2_Exhaustion = math.max(ent.BA2_Exhaustion - 3,0)
            end

            --print(ent.BA2_Exhaustion)
            if ent:GetNWBool("BA2_GasmaskOn",false) then
                if ent:WaterLevel() == 3 then
                    BA2_GasmaskSound(ent)
                elseif ent.BA2_Exhaustion >= exhaustThres then
                    BA2_GasmaskSound(ent,"ba2/gasmask/mask_breathe_heavy.wav")
                elseif !BA2_GetActiveMask(ent) or ent:Health() < ent:GetMaxHealth() / 5 then
                    BA2_GasmaskSound(ent,"ba2/gasmask/mask_strained.wav")
                else
                    BA2_GasmaskSound(ent,"ba2/gasmask/mask_breathe_light.wav")
                end
            end
        end
    end
end)

timer.Start("BA2_ServerTick")


timer.Create("BA2_GasmaskTick",0.5,0,function()
    for i,ent in pairs(player.GetAll()) do
        if GetConVar("ba2_misc_maskfilters"):GetBool() and ent:GetNWBool("BA2_GasmaskOn",false) then
            ent:SetNWInt("BA2_GasmaskFilterPct",math.max(0,ent:GetNWBool("BA2_GasmaskFilterPct") - 0.25))
        end
    end
end)

timer.Start("BA2_GasmaskTick")

hook.Add("PostCleanupMap","BA2_PostCleanup",function()
    for i,p in pairs(player.GetAll()) do
        if p:GetNWBool("BA2_GasmaskOn",false) and p.BA2_MaskSoundName ~= nil then
            p.BA2_MaskSound = CreateSound(p,p.BA2_MaskSoundName)
            p.BA2_MaskSound:Play()
        end
    end
end)


hook.Add("PlayerDeath","BA2_PlayerDeath",function(p,inf,ent,dmg)
    if inf ~= nil and inf:IsValid() and GetConVar("ba2_inf_plyraise"):GetBool() and (GetConVar("ba2_inf_romeromode"):GetBool() 
        or (IsValid(p) and p.BA2Infection > 0) 
        or inf:GetClass() == BA2_InfectionManager()) then
        BA2_InfectionDeath(p,inf,ent,dmg)
    end

    p.BA2Infection = 0
    p.BA2_Exhaustion = 0

    p:SetNWBool("BA2_GasmaskOn",false)
    if p.BA2_MaskSound then
        p.BA2_MaskSound:Stop()
    end
    if GetConVar("ba2_misc_deathdropmask"):GetBool() and p:GetNWBool("BA2_GasmaskOwned",false) then
        BA2_DropGasmask(p)
    end

    if GetConVar("ba2_misc_deathdropfilter"):GetBool() then
        for i = 1,p:GetNWInt("BA2_GasmaskFilters",0) do
            BA2_DropFilter(p)
        end
    end
end)

hook.Add("OnNPCKilled","BA2_NPCDeath",function(npc)
    if npc.BA2_MaskCitizen == true then
        local mask = ents.Create("ba2_gasmask")
        mask.BA2_FilterPct = math.random(55,95)
        mask:SetPos(npc:EyePos())
        mask:Spawn()
        mask:Activate()
    end
end)

hook.Add("EntityTakeDamage","BA2_OnDamage",function(e,dmg)
    if e:IsPlayer() and e:GetNWBool("BA2_GasmaskOn",false) and dmg:GetDamage() < e:Health() and dmg:GetDamage() * math.random(0,20) / 10 >= e:Health() / 4  then
        BA2_GasmaskSound(e)
        e:EmitSound("ba2/gasmask/mask_pain"..math.random(1,2)..".wav",90,110)
    end

    if e:Health() <= 0 then return end
    if (GetConVar("ba2_inf_romeromode"):GetBool() or dmg:GetInflictor() == BA2_InfectionManager() or dmg:GetDamageCustom() == DMG_BIOVIRUS
     or (e.BA2Infection and e.BA2Infection > 0 and !GetConVar("ba2_inf_killtoraise"):GetBool())) 
     and (e:IsNPC() or e:IsPlayer()) and e:Health() <= dmg:GetDamage() then
        if string.StartWith(dmg:GetAttacker():GetClass(),"nb_ba2_infected") and (!e.BA2Infection or e.BA2Infection == 0) then return end -- hardcoding this because fuck logic
        if e:IsPlayer() and GetConVar("ba2_inf_plyraise"):GetBool() then
            gamemode.Call("PlayerDeath",e,dmg:GetInflictor(),dmg:GetAttacker(),dmg)
            e:KillSilent()
            SafeRemoveEntity(e:GetRagdollEntity())
            return true
        elseif e:IsNPC() and (e.IsVJBaseSNPC_Human or BA2_ConvertibleNpcs[e:GetClass()]) and GetConVar("ba2_inf_npcraise"):GetBool() then
            BA2_InfectionDeath(e,dmg:GetInflictor(),dmg:GetAttacker(),dmg)
            gamemode.Call("OnNPCKilled",e,dmg:GetAttacker(),dmg:GetInflictor(),dmg)
            e:DropWeapon()
            e:Remove()
            return true
        end
    end
end)

hook.Add("EntityEmitSound","BA2_GasmaskMuffle",function(info)
    if info.Entity:GetNWBool("BA2_GasmaskOn",false) and info.Channel == CHAN_VOICE then
        info.DSP = 30 -- Low pass filter
        return true
    end
end)

hook.Add("PlayerSay","BA2_Chat",function(p,msg)
    if !p:Alive() then return end

    if msg == "!dgasmask" then
        BA2_DropGasmask(p)
        return ""
    end
    if msg == "!gasmask" then
        BA2_ToggleGasmask(p)
        return ""
    elseif msg == "!cfilter" then
        BA2_CheckFilter(p)
        return ""
    elseif msg == "!ufilter" then
        BA2_UFilter(p)
        return ""
    elseif msg == "!dfilter" then
        BA2_DropFilter(p)
        return ""
    end
end)
hook.Add("PlayerSpawn","BA2_PlayerSpawn",function(p)
    if GetConVar("ba2_misc_startwithmask"):GetBool() then
        p:SetNWBool("BA2_GasmaskOwned",true)
        p:SetNWInt("BA2_GasmaskFilterPct",100)
    end
end)

hook.Add("PostGamemodeLoaded","BA2_NavmeshWarn",function()
    timer.Simple(5,function()
        if GetConVar("ba2_misc_navmeshwarn"):GetBool() and #navmesh.GetAllNavAreas() == 0 then
            net.Start("BA2NoNavmeshWarn")
            net.Send(Entity(1))
        end

        if GetConVar("ba2_misc_gammaeditioninfo"):GetBool()
            and not GetConVar("ba2_hs_stuckclean"):GetBool()
            and not GetConVar("ba2_hs_morespawnlocations"):GetBool()
            and not GetConVar("ba2_hs_proximityspawns"):GetBool()
            and not GetConVar("ba2_hs_stoptargetingoutsidedetectionrange"):GetBool()
            and not GetConVar("ba2_zom_ptwander"):GetBool()
            and not GetConVar("ba2_zom_handlebadpaths"):GetBool()
            and not GetConVar("ba2_zom_notargetnoclip"):GetBool()
            and not GetConVar("ba2_zom_betterdoorbreaking"):GetBool()
        then
            net.Start("BA2PerformanceHint")
            net.Send(Entity(1))
        end
    end) 
end)

if ArcticMedShots then
    hook.Add("OnEntityCreated", "BA2_ArcticMedshotSamplerModifier", function (ent)
        if ent:GetClass() == "arc_medshot_sampler" then
            ent.Shots["ba2_cure"] = 1
            ent.Shots["ba2_infect"] = 1
        end
    end)
end
-- Code by Sninctbur