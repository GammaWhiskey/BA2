-- Shared convars
CreateConVar("ba2_misc_maskfilters",1,FCVAR_ARCHIVE,"If enabled, gas mask filters will degrade over time and will need to be switched out occasionally.")
CreateConVar("ba2_misc_airwastevisuals",1,FCVAR_ARCHIVE,[[If enabled, air waste will create an opaque fog.]])
CreateConVar("ba2_misc_airwasteshake",1,FCVAR_ARCHIVE,"If enabled, players outside in Air Waste will have their screen occasionally shake around in the wind.")

-- Custom infected models
BA2_CustomInfs = {}
BA2_CustomArmInfs = {}

function BA2_WriteToAltModels(list)
    if list ~= nil then
        print("BA2: Overwriting ba2_altmodels.txt...")
        file.Write("ba2_altmodels.txt","")
        local file = file.Open("ba2_altmodels.txt","w","DATA")

        for i,mdl in pairs(list) do
            if line ~= "" then
                file:Write(string.Trim(mdl,"\n").."\n")
            end
        end

        file:Close()
    end
end
function BA2_GetAltModels(raw,noPrint)
    local tbl = {}
    local tblArm = {}

    if !file.Exists("ba2_altmodels.txt","DATA") then
        print("BA2: Creating ba2_altmodels.txt...")
        file.Write("ba2_altmodels.txt","")
    end

    local file = file.Open("ba2_altmodels.txt","r","DATA")
    local toProcessArm = false
    
    while !file:EndOfFile() do
        local line = string.Trim(file:ReadLine(),"\n")
        if line == "--ARMORED--" then
            if raw then
                table.insert(tblArm,line)
            end
            toProcessArm = true
            break
        elseif line ~= "" then
            if raw or util.IsValidRagdoll(line) then
                table.insert(tbl,string.lower(line))
            elseif !noPrint then
                print("BA2: Invalid custom model detected: "..line)
            end
        end
    end
    if #tbl == 0 and !raw then
        if SERVER and !noPrint then
            print("BA2: No valid custom models found! Using default...")
        end
        tbl = {
            "models/Humans/Group01/Male_Cheaple.mdl"
        }
    end

    if toProcessArm then
        while !file:EndOfFile() do
            local line = string.Trim(file:ReadLine(),"\n")
            if line ~= "" then
                if raw or util.IsValidRagdoll(line) then
                    table.insert(tblArm,string.lower(line))
                elseif !noPrint then
                    print("BA2: Invalid custom model detected: "..line)
                end
            end
        end
    end
    if #tblArm == 0 and !raw then
        tblArm = table.Copy(tbl)
    end

    return tbl,tblArm
end
function BA2_ReloadCustoms()
    if !file.Exists("ba2_altmodels.txt","DATA") then
        print("BA2: Creating ba2_altmodels.txt...")
        file.Write("ba2_altmodels.txt","")
    end
    
    BA2_CustomInfs,BA2_CustomArmInfs = BA2_GetAltModels()
    
    print("BA2: Custom Infected models loaded!") 
    return BA2_CustomInfs,BA2_CustomArmInfs
end

function BA2_GetCustomInfs()
    return BA2_CustomInfs,BA2_CustomArmInfs
end

--  Global variables
BA2_ConvertibleNpcs = {
    ["npc_kleiner"] = true,
    ["npc_mossman"] = true,
    ["npc_alyx"] = true,
    ["npc_eli"] = true,
    ["npc_breen"] = true,
    ["npc_magnusson"] = true,
    ["npc_odessa"] = true,
    ["npc_gman"] = true,
    ["npc_barney"] = true,
    ["npc_fisherman"] = true,
    ["npc_monk"] = true,

    ["npc_citizen"] = true,
    ["npc_combine_s"] = true,
    ["npc_combine_elite"] = true,
    ["npc_metropolice"] = true
}

BA2_GasmaskNpcs = {
    ["npc_combine_s"] = true,
    ["npc_combine_elite"] = true,
    ["npc_metropolice"] = true
}

BA2_FemaleModels = {
    ["models/alyx.mdl"] = true,
    ["models/mossman.mdl"] = true,
    ["models/player/alyx.mdl"] = true,
    ["models/player/mossman.mdl"] = true,
    ["models/player/mossman_arctic.mdl"] = true,
    ["models/player/p2_chell.mdl"] = true
}

BA2_ZombieTypes = {
    [0] = "nb_ba2_infected_citizen",
    [1] = "nb_ba2_infected_rebel",
    [2] = "nb_ba2_infected_police",
    [3] = "nb_ba2_infected_custom",
    [4] = "nb_ba2_infected_combine",
    [5] = "nb_ba2_infected_custom_armored",
}

DMG_BIOVIRUS = 83598

BA2_MODVERSION = "Main Branch Hotfix 2A, Gamma Edition v1.3.3"

BA2_JMod = (JMod_GetArmorBiologicalResistance ~= nil)

-- Sounds
sound.Add({
    name = "ba2_inf_m_groan",
    channel = CHAN_VOICE,
    level = 80,
    pitch = {85,95},
    sound = {
        "vo/npc/male01/moan01.wav",
        "vo/npc/male01/moan02.wav",
        "vo/npc/male01/moan03.wav",
        "vo/npc/male01/moan04.wav",
        "vo/npc/male01/moan05.wav",
        "ambient/voices/citizen_beaten3.wav",
        "ambient/voices/citizen_beaten4.wav"
    }
})
sound.Add({
    name = "ba2_inf_f_groan",
    channel = CHAN_VOICE,
    level = 80,
    pitch = {85,95},
    sound = {
        "vo/npc/female01/moan01.wav",
        "vo/npc/female01/moan02.wav",
        "vo/npc/female01/moan03.wav",
        "vo/npc/female01/moan04.wav",
        "vo/npc/female01/moan05.wav"
    }
})
sound.Add({
    name = "ba2_inf_c_groan",
    channel = CHAN_VOICE,
    level = 80,
    pitch = 100,
    sound = {
        "npc/zombine/zombine_idle1.wav",
        "npc/zombine/zombine_idle2.wav",
        "npc/zombine/zombine_idle3.wav",
        "npc/zombine/zombine_idle4.wav",
        "npc/zombine/zombine_alert1.wav",
        "npc/zombine/zombine_alert2.wav",
        "npc/zombine/zombine_alert3.wav",
        "npc/zombine/zombine_alert4.wav",
        "npc/zombine/zombine_alert5.wav",
        "npc/zombine/zombine_alert6.wav",
        "npc/zombine/zombine_alert7.wav",
        "npc/zombine/zombine_pain3.wav",
        "npc/zombine/zombine_pain4.wav",
    }
})
sound.Add({
    name = "ba2_inf_s_groan",
    channel = CHAN_VOICE,
    level = 80,
    pitch = 100,
    sound = {
        "vo/soldier_sf12_zombie01.mp3",
        "vo/soldier_sf12_zombie02.mp3",
        "vo/soldier_sf12_zombie03.mp3",
        "vo/soldier_sf12_zombie04.mp3",
        "vo/soldier_sf12_badmagic07.mp3",
        "vo/soldier_autodejectedtie03.mp3",
        "vo/soldier_negativevocalization06.mp3",
        "vo/soldier_mvm_resurrect03.mp3",
        "vo/soldier_mvm_resurrect05.mp3",
        "vo/soldier_mvm_resurrect06.mp3",
        "vo/soldier_dominationsoldier04.mp3",
        "vo/soldier_dominationengineer03.mp3",
        "vo/soldier_dominationsniper12.mp3",
        "vo/soldier_pickaxetaunt01.mp3",
        "vo/soldier_pickaxetaunt02.mp3",
        "vo/soldier_pickaxetaunt03.mp3",
        "vo/soldier_pickaxetaunt04.mp3",
        "vo/soldier_pickaxetaunt05.mp3",
        -- "vo/soldier_battlecry01.mp3",
        -- "vo/soldier_battlecry02.mp3",
        -- "vo/soldier_battlecry03.mp3",
        -- "vo/soldier_battlecry04.mp3",
        -- "vo/soldier_battlecry05.mp3",
        "vo/taunts/soldier_taunts01.mp3",
        "vo/taunts/soldier_taunts03.mp3",
        "vo/taunts/soldier_taunts04.mp3",
        "vo/taunts/soldier_taunts08.mp3",
        "vo/taunts/soldier_taunts10.mp3",
        "vo/taunts/soldier_taunts12.mp3",
        "vo/taunts/soldier_taunts14.mp3",
        "vo/taunts/soldier_taunts16.mp3",
        "vo/taunts/soldier_taunts19.mp3",
        "vo/taunts/soldier_taunts20.mp3"
    }
}) -- Rest in peace, Rick May

sound.Add({
    name = "ba2_inf_m_hurt",
    channel = CHAN_VOICE,
    level = 90,
    pitch = {70,85},
    sound = {
        "vo/npc/male01/pain01.wav",
        "vo/npc/male01/pain02.wav",
        "vo/npc/male01/pain03.wav",
        "vo/npc/male01/pain04.wav",
        "vo/npc/male01/pain05.wav",
        "vo/npc/male01/pain06.wav",
        "vo/npc/male01/pain07.wav",
        "vo/npc/male01/pain08.wav",
        "vo/npc/male01/pain09.wav",
    }
})
sound.Add({
    name = "ba2_inf_f_hurt",
    channel = CHAN_VOICE,
    level = 90,
    pitch = {70,85},
    sound = {
        "vo/npc/female01/pain01.wav",
        "vo/npc/female01/pain02.wav",
        "vo/npc/female01/pain03.wav",
        "vo/npc/female01/pain04.wav",
        "vo/npc/female01/pain05.wav",
        "vo/npc/female01/pain06.wav",
        "vo/npc/female01/pain07.wav",
        "vo/npc/female01/pain08.wav",
        "vo/npc/female01/pain09.wav",
    }
})
sound.Add({
    name = "ba2_inf_c_hurt",
    channel = CHAN_VOICE,
    level = 90,
    pitch = {85,95},
    sound = {
        "npc/zombine/zombine_die1.wav",
        "npc/zombine/zombine_die2.wav",
        "npc/combine_soldier/die1.wav",
        "npc/combine_soldier/die2.wav",
        "npc/combine_soldier/die3.wav",
        "npc/zombine/zombine_pain1.wav",
        "npc/zombine/zombine_pain2.wav"
    }
})
sound.Add({
    name = "ba2_inf_s_hurt",
    channel = CHAN_VOICE,
    level = 80,
    pitch = 100,
    sound = {
        "vo/soldier_painsevere01.mp3",
        "vo/soldier_painsevere02.mp3",
        "vo/soldier_painsevere03.mp3",
        "vo/soldier_painsevere04.mp3",
        "vo/soldier_painsevere05.mp3",
        "vo/soldier_painsevere06.mp3",
        "vo/soldier_sf12_badmagic14.mp3",
        "vo/soldier_negativevocalization05.mp3"
    }
})

sound.Add({
    name = "ba2_fleshtear",
    channel = CHAN_AUTO,
    level = 75,
    pitch = {90,110},
    sound = {
        "ba2/infected/gore/bullets/bullet_gib_01.wav",
        "ba2/infected/gore/bullets/bullet_gib_02.wav",
        "ba2/infected/gore/bullets/bullet_gib_03.wav",
        "ba2/infected/gore/bullets/bullet_gib_04.wav",
        "ba2/infected/gore/bullets/bullet_gib_05.wav",
        "ba2/infected/gore/bullets/bullet_gib_06.wav",
        "ba2/infected/gore/bullets/bullet_gib_07.wav",
        "ba2/infected/gore/bullets/bullet_gib_08.wav",
        "ba2/infected/gore/bullets/bullet_gib_09.wav",
        "ba2/infected/gore/bullets/bullet_gib_10.wav",
        "ba2/infected/gore/bullets/bullet_gib_11.wav",
        "ba2/infected/gore/bullets/bullet_gib_12.wav",
        "ba2/infected/gore/bullets/bullet_gib_13.wav",
        "ba2/infected/gore/bullets/bullet_gib_14.wav",
        "ba2/infected/gore/bullets/bullet_gib_15.wav",
        "ba2/infected/gore/bullets/bullet_gib_16.wav",
        "ba2/infected/gore/bullets/bullet_gib_17.wav"
    }
})
sound.Add({
    name = "ba2_headlessbleed",
    channel = CHAN_AUTO,
    level = 75,
    pitch = {90,110},
    sound = {
        "ba2/infected/gore/dismemberment/headless_bleed1.wav",
        "ba2/infected/gore/dismemberment/headless_bleed2.wav",
    }
})
sound.Add({
    name = "ba2_gibsplat",
    channel = CHAN_AUTO,
    level = 75,
    pitch = {75,85},
    sound = {
        "ba2/infected/gore/gibs/gib_splat1.wav",
        "ba2/infected/gore/gibs/gib_splat2.wav",
        "ba2/infected/gore/gibs/gib_splat3.wav",
    }
})
sound.Add({
    name = "ba2_corpsechomp",
    channel = CHAN_AUTO,
    level = 75,
    pitch = {75,100},
    sound = {
        "npc/barnacle/barnacle_crunch3.wav",
        "physics/flesh/flesh_bloody_break.wav",
        "physics/flesh/flesh_squishy_impact_hard1.wav",
        "physics/flesh/flesh_squishy_impact_hard2.wav",
        "physics/flesh/flesh_squishy_impact_hard3.wav",
        "physics/flesh/flesh_squishy_impact_hard4.wav",
    }
})

sound.Add({
    name = "ba2_infectdamage",
    channel = CHAN_AUTO,
    level = 75,
    pitch = {90,110},
    sound = {
        "ambient/voices/cough1.wav",
        "ambient/voices/cough2.wav",
        "ambient/voices/cough3.wav",
        "ambient/voices/cough4.wav",
        "ambient/voices/citizen_beaten3.wav",
        "ambient/voices/citizen_beaten4.wav"
    }
})
sound.Add({
    name = "ba2_infectcry",
    channel = CHAN_AUTO,
    level = 75,
    pitch = {90,110},
    sound = {
        "ba2/infected/hope/no_hope1.wav",
        "ba2/infected/hope/no_hope2.wav",
        "ba2/infected/hope/no_hope3.wav",
        "ba2/infected/hope/no_hope4.wav",
        "ba2/infected/hope/no_hope5.wav",
        "ba2/infected/hope/no_hope6.wav"
    }
})

sound.Add({
    name = "ba2_cureuse",
    channel = CHAN_ITEM,
    volume = 0.9,
    level = 75,
    pitch = 100,
    sound = {
        "ba2/cure_spray/cure_spray.wav"
    }
})
sound.Add({
	name = "ba2_curephys_soft",
	channel = CHAN_ITEM,
	volume = 0.8,
	level = 65,
	pitch = { 90, 110 },
	sound = { 
	    "physics/metal/soda_can_impact_soft1.wav",
	    "physics/metal/soda_can_impact_soft2.wav",
	    "physics/metal/soda_can_impact_soft3.wav"
	}
})
sound.Add({
	name = "ba2_curephys_hard",
	channel = CHAN_ITEM,
	volume = 0.8,
	level = 65,
	pitch = { 90, 110 },
	sound = { 
        "physics/metal/soda_can_impact_hard1.wav",
        "physics/metal/soda_can_impact_hard2.wav",
        "physics/metal/soda_can_impact_hard3.wav"
    }
})

-- Other
game.AddDecal("BA2_VirusBloodStain","decals/bloodstain_002")
team.SetUp(83598,"BA2_NPCs",Color(250,46,46),false)

if ArcticMedShots and not ArcticMedShots["ba2_cure"] then
    local COLOR_NEUTRAL = Color(255, 255, 255)
    local COLOR_GOOD = Color(25, 255, 25)
    local COLOR_BAD = Color(255, 25, 25)

    ArcticMedShots["ba2_cure"] = {
        QuickName = "Cure Shot",
        PrintName = "Bio-Virus Experimental Treatment",
        Description = {"Experimental drug to kill S2S-1 viral cells in humans.", "  Immediately eliminates infection."},
        DescriptionColors = {COLOR_NEUTRAL, COLOR_GOOD},
        AvailableForNPCs = true,
        OnInject = function(ply, infl)
            if SERVER then
                ply.BA2Infection = 0
            end
        end, -- shared
        Skin = 0,

        Material = Material("entities/ba2_arc_medshot_cure.png"),
        ShotMaterial = "models/weapons/v_models/arc_vm_healthshot/shot_ba2_cure"
    }

    ArcticMedShots["ba2_cure"].ID = #ArcticMedShots_IDToShortName + 1
    ArcticMedShots_IDToShortName[#ArcticMedShots_IDToShortName + 1] = "ba2_cure"

    ArcticMedShots["ba2_infect"] = {
        QuickName = "Bio-Virus",
        PrintName = "S2S-1 \"Bio-Virus\" Injectable Sample",
        Description = {"Sample containing live S2S-1 viral cells.", "Contains enough of the virus to kill anyone without external intervention.", "  Infects you with the Bio-Virus."},
        DescriptionColors = {COLOR_NEUTRAL, COLOR_NEUTRAL, COLOR_BAD},
        AvailableForNPCs = true,
        OnInject = function(ply, infl)
            if SERVER then
                BA2_AddInfection(ply, 18000)
            end
        end, -- shared
        Skin = 0,

        Material = Material("entities/ba2_arc_medshot_infect.png"),
        ShotMaterial = "models/weapons/v_models/arc_vm_healthshot/shot_ba2_infect"
    }

    ArcticMedShots["ba2_infect"].ID = #ArcticMedShots_IDToShortName + 1
    ArcticMedShots_IDToShortName[#ArcticMedShots_IDToShortName + 1] = "ba2_infect"

    AddCSLuaFile("entities/ba2_arc_medshot_cure.lua")
    AddCSLuaFile("entities/ba2_arc_medshot_infect.lua")
end