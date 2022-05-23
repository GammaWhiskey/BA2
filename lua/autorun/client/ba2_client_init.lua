-- Derma elements
function BA2_NoNavmeshWarn()
    local DFrame = vgui.Create( "DFrame" )
    DFrame:SetPos( ScrW() / 2 - 400, ScrH() / 2 - 275 )
    DFrame:SetSize( 800, 550 )
    DFrame:SetTitle( "Navmesh Missing!" )
    DFrame:MakePopup()

    local img = vgui.Create("DImage",DFrame)
    img:SetSize(1000,600)
    img:SetPos(50,-25)
    img:SetImage("vgui/its_ya_boi_zambo")

    local lbl = vgui.Create("DLabel",DFrame)
    lbl:SetSize(800,100)
    lbl:SetPos(225,10)
    lbl:SetColor(Color(255,255,255))
    lbl:SetFont("DermaLarge")
    lbl:SetText("Hold on, friend!")

    local lbl = vgui.Create("DLabel",DFrame)
    lbl:SetSize(500,200)
    lbl:SetPos(50,50)
    lbl:SetColor(Color(255,255,255))
    lbl:SetWrap(true)
    lbl:SetText("Bio-Annihilation II’s zombies are Nextbots, and thus require a Navmesh to function. Unfortunately, the map you’ve just loaded doesn’t have a navmesh."
        .."\nBut that’s no problem! I, Zambo the Help Zombie, am here to help you fix this."
        .."\n\nTo add a navmesh to this map, the two simplest options are as follows:"
        .."\n• Some addons add a navmesh to specific maps. If you can find one for this map, install it and restart the server. It will work immediately!"
        .."\n• You can also generate the navmesh yourself. This process is straightforward, but can take time and may not work correctly depending on the map. I’ll walk you through it in the steps below."
        .."\n\n"
    )

    local lbl = vgui.Create("DLabel",DFrame)
    lbl:SetSize(500,200)
    lbl:SetPos(50,172)
    lbl:SetColor(Color(255,255,255))
    lbl:SetWrap(true)
    lbl:SetText("To generate a navmesh:"
        .."\n• Open the developer console and run the command “nav_generate.”"
        .."\n       ◦ By default, you will need to enable access to the console manually. You can do that in Options -> Keyboard -> Advanced..."
        .."\n• Wait for the generation process to finish. Be warned that this process will SIGNIFICANTLY REDUCE PERFORMANCE for a while, and then RESTART THE MAP when it’s done. Only do this when nobody is actively playing, and nobody would lose anything if the map restarts. Now would be a good time!"
        .."\n\nIf you would like to save yourself a few clicks, I can run nav_generate for you. Would you like to do that now?"
    )

    local btn = vgui.Create("DButton",DFrame)
    btn:SetSize(125,35)
    btn:SetPos(125,370)
    btn:SetText("Generate Navmesh")
    btn.DoClick = function()
        local ConfFrame = vgui.Create("DFrame")
        ConfFrame:SetSize(300,150)
        ConfFrame:SetPos( ScrW() / 2 - 150, ScrH() / 2 - 75 )
        ConfFrame:SetTitle("Confirm")
        ConfFrame:MakePopup()

        local lbl = vgui.Create("DLabel",ConfFrame)
        lbl:SetSize(300,100)
        lbl:SetPos(15,10)
        lbl:SetColor(Color(255,255,255))
        lbl:SetText("Are you sure? This process WILL slow down your game!")

        local btn = vgui.Create("DButton",ConfFrame)
        btn:SetSize(115,35)
        btn:SetPos(25,85)
        btn:SetText("Yes")
        btn.DoClick = function()
            LocalPlayer():ChatPrint("A navmesh is now being generated. What happens next will vary depending on the map.")
            LocalPlayer():ChatPrint("If you observe major lag, stand by until the map restarts. You can monitor the algorithm's progress in the console.")
            LocalPlayer():ChatPrint("If not, automatic generation has failed and is incompatible with this map.")
            RunConsoleCommand("nav_generate")
            DFrame:Remove()
            ConfFrame:Remove()
            DFrame:Remove()
        end

        local btn = vgui.Create("DButton",ConfFrame)
        btn:SetSize(115,35)
        btn:SetPos(160,85)
        btn:SetText("No")
        btn.DoClick = function()
            ConfFrame:Remove()
        end
    end

    local btn = vgui.Create("DButton",DFrame)
    btn:SetSize(125,35)
    btn:SetPos(125,415)
    btn:SetText("Close")
    btn.DoClick = function()
        DFrame:Remove()
    end

    local btn = vgui.Create("DButton",DFrame)
    btn:SetSize(125,35)
    btn:SetPos(125,460)
    btn:SetText("Don't remind me again")
    btn.DoClick = function()
        RunConsoleCommand("ba2_misc_navmeshwarn",0)
        LocalPlayer():ChatPrint("You can re-enable the warning later in Options -> Bio-Annihilation II -> Miscellaneous.")
        DFrame:Remove()
    end
end


-- Net messages
net.Receive("BA2NoNavmeshWarn",BA2_NoNavmeshWarn)

net.Receive("BA2ZomDeathNotice",function()
    local attacker = net.ReadEntity()
    local inflictor = net.ReadEntity()
    local team = nil
    local name = net.ReadString()

    if attacker:IsPlayer() then
        name = attacker:GetName()
        team = attacker:Team()
    else
        if IsValid(attacker) then
            name = "#"..attacker:GetClass()
        elseif attacker:IsWorld() then
            name = "#worldspawn"
        else
            name = " "
        end
        team = 83598
    end
    if attacker == inflictor and (attacker:IsPlayer() or attacker:IsNPC()) then
        inflictor = attacker:GetActiveWeapon() or inflictor
    end
    if !IsValid(inflictor) then
        inflictor = game.GetWorld()
    end

    GAMEMODE:AddDeathNotice(name,team,inflictor:GetClass(),"Infected",83598)
end)

net.Receive("BA2PerformanceHint", function()
    chat.AddText(Color(170,170,255), [[Bio-Annihilation II: Gamma Edition features some ]], Color(255,0,0), [[experimental ]], Color(170,170,255), [[performance improvements and other enhancements.
Scroll down to the bottom of the "Spawners" and "Zombies" options to find them!
]], Color(165,165,165), [[Disable this message in the "Miscellaneous" tab or with ba2_misc_gammaeditioninfo 0.]])
end)

-- Kill icons and names
killicon.Add("nb_ba2_infected","vgui/infect_killicon.vtf", Color( 255, 0, 0, 255 ) )
killicon.Add("nb_ba2_infected_citizen","vgui/infect_killicon.vtf", Color( 255, 0, 0, 255 ) )
killicon.Add("nb_ba2_infected_rebel","vgui/infect_killicon.vtf", Color( 255, 0, 0, 255 ) )
killicon.Add("nb_ba2_infected_combine","vgui/infect_killicon.vtf", Color( 255, 0, 0, 255 ) )
killicon.Add("ba2_infection_manager","vgui/infect_killicon.vtf", Color( 255, 0, 0, 255 ) )

language.Add("nb_ba2_infected","Infected")
language.Add("nb_ba2_infected_citizen","Infected")
language.Add("nb_ba2_infected_rebel","Infected")
language.Add("nb_ba2_infected_combine","Infected")
language.Add("nb_ba2_infected_police","Infected")
language.Add("nb_ba2_infected_custom","Infected")
language.Add("nb_ba2_infected_custom_armored","Infected")
language.Add("ba2_airwaste","Air Waste")
language.Add("ba2_barrel","Contaminant Barrel")
language.Add("ba2_infection_manager"," ") -- SpOoOoOoOoOoOoky killfeed
language.Add("ba2_virus_sample","Viral Sample")


-- Clientside convars
CreateClientConVar("ba2_cl_infdmgeff",1,true,true,"If enabled, your screen will flash green when you take damage from the Bio-Virus.")
CreateClientConVar("ba2_cl_playervoice",-1,true,true,[[The voice your zombie will use when raised.
    -1: Automatic
    0: Male
    1: Female
    2: Combine]],-1,2
)
CreateClientConVar("ba2_cl_maskhelp",1,true,true,"If enabled, you will see a help message with chat commands when you pick up a gas mask.")
CreateClientConVar("ba2_cl_zomdecals",1,true,true,"If enabled, zombies will be covered in blood. Turning this off may mitigate some crashes.")
CreateClientConVar("ba2_cl_lowgibs",0,true,true,"If enabled, gibs from zombies will use a simple model and texture. Enabling this may improve performance during gibbing.")


-- Gas mask model
local mask = nil
hook.Add("PostPlayerDraw","BA2_GasmaskDraw",function(p)
    local hasMask = p:GetNWBool("BA2_GasmaskOn",false)

    if hasMask then
        local head = p:LookupBone("ValveBiped.Bip01_Head1")

        if mask then
            SafeRemoveEntity(mask)
        end

        mask = ClientsideModel("models/barneyhelmet_faceplate.mdl")
        mask:SetColor(Color(72,72,72))
        if mask then
            mask:FollowBone(p,head)
            mask:SetAngles(p:GetAngles() + Angle(180,90,90))
            mask:SetPos(p:GetPos() + mask:LocalToWorld(Vector(2.1,0,2.4)))

            SafeRemoveEntityDelayed(mask,0)
        end
    end
end)

-- Gas mask + air waste HUD effects
function BA2_AirwasteSmog()
    local trace = util.TraceLine({
        start = LocalPlayer():EyePos(),
        endpos = LocalPlayer():EyePos() + Vector(0,0,1000),
        mask = MASK_PLAYERSOLID_BRUSHONLY
    })

    if !trace.HitWorld or trace.HitSky then
        surface.SetDrawColor(0,55,0,215)
        surface.DrawRect(0,0,ScrW(),ScrH())
    else
        surface.SetDrawColor(0,35,0,127)
        surface.DrawRect(0,0,ScrW(),ScrH())
    end
end

hook.Add("HUDPaintBackground","BA2_GamaskOverlay",function()
    if GetConVar("ba2_misc_airwastevisuals"):GetBool() and #ents.FindByClass("ba2_airwaste") > 0 then
        BA2_AirwasteSmog()
    end

    if LocalPlayer():GetNWBool("BA2_GasmaskOn",false) and LocalPlayer():GetViewEntity() == LocalPlayer() then
        DrawMaterialOverlay("overlay/ba2_gasmask",0)
    end
end)
hook.Add("HUDPaint","BA2_GasmaskHUD",function()
    if GetConVar("cl_drawhud"):GetBool() and LocalPlayer():GetNWBool("BA2_GasmaskOn",false) and GetConVar("ba2_misc_maskfilters"):GetBool() then
        local filterPct = math.ceil(LocalPlayer():GetNWInt("BA2_GasmaskFilterPct",0))
        local textColor

        if filterPct > 20 or CurTime() % 2 >= 1 then
            textColor = Color(255,255,255)
        else
            textColor = Color(255,0,0)
        end

        draw.DrawText("FILTER: "..filterPct.."%","DermaLarge",ScrW() * .01,ScrH() * .01,textColor)
        draw.DrawText("RESERVE: "..LocalPlayer():GetNWInt("BA2_GasmaskFilters",0),"Trebuchet24",ScrW() * .01,ScrH() * .04,textColor)
    end
end)
hook.Add("DrawOverlay","BA2_CameraSmog",function()
    if not IsValid(LocalPlayer()) then return end

    local wep = LocalPlayer():GetActiveWeapon()
    if IsValid(wep) and wep:GetClass() == "gmod_camera" and GetConVar("ba2_misc_airwastevisuals"):GetBool() and #ents.FindByClass("ba2_airwaste") > 0 then
       BA2_AirwasteSmog() 
    end
end)

-- Q-menu options
local adminString = "You must be a server admin to modify these settings. You're still allowed to look, though.\n"

function CreatePresets(vars)
    local presets = vgui.Create("ControlPresets")
    for i,v in pairs(vars) do
        presets:AddConVar(v)
    end

    return presets
end

hook.Add("PopulateToolMenu","ba2_options",function(panel)
    -- ABOUT
    spawnmenu.AddToolMenuOption("Options","Bio-Annihilation II","ba2_config_abt","About","","",function(panel)
        panel:Help("Gamma presents, a modified Gauss addon:")

        local img = vgui.Create("DImage")
        img:SetImage("vgui/ba2_splash")
        img:SetSize(300,350)
        img:SetKeepAspect(true)
        panel:AddItem(img)

        panel:Help("GAMMA EDITION")
        panel:Help("This is NOT the original mod!")

        if BA2_GIT then
            panel:Help(BA2_MODVERSION.." (Git Edition)")
        else
            panel:Help(BA2_MODVERSION.." (Workshop Edition)")
        end
        
        local url = vgui.Create("DLabelURL")
        url:SetText("Workshop")
        url:SetURL("https://steamcommunity.com/sharedfiles/filedetails/?id=2453712243")
        panel:AddItem(url)
        local url = vgui.Create("DLabelURL")
        url:SetText("Wiki")
        url:SetURL("https://github.com/Sninctbur/BA2/wiki")
        panel:AddItem(url)
        local url = vgui.Create("DLabelURL")
        url:SetText("Source Code")
        url:SetURL("https://github.com/GammaWhiskey/BA2")
        panel:AddItem(url)
        local url = vgui.Create("DLabelURL")
        url:SetText("Developer's Profile")
        url:SetURL("https://steamcommunity.com/id/gammawhiskey/")
        panel:AddItem(url)
        local url = vgui.Create("DLabelURL")
        url:SetText("Original Creator's Profile")
        url:SetURL("https://steamcommunity.com/id/sninctbur")
        panel:AddItem(url)
    end)

    -- CLIENT
    spawnmenu.AddToolMenuOption("Options","Bio-Annihilation II","ba2_config_cl","Client","","",function(panel)
        panel:Help("You can type \"find ba2_cl\" in the developer console for more information about these settings.")
        panel:Help("These settings change various cosmetic, arbitrary parts of the mod. They only affect you.")

        panel:CheckBox("Infection Damage Effect","ba2_cl_infdmgeff")
        panel:CheckBox("Gas Mask Help Text","ba2_cl_maskhelp")
        panel:CheckBox("Zombie Blood Decals","ba2_cl_zomdecals")
        panel:CheckBox("Low Performance Gibs","ba2_cl_lowgibs")

        local comboBox = panel:ComboBox("Player Voice","ba2_cl_playervoice")
        comboBox:AddChoice("-1. Automatic",-1)
        comboBox:AddChoice("0. Male",0)
        comboBox:AddChoice("1. Female",1)
        comboBox:AddChoice("2. Combine",2)
    end)

    -- COSMETIC
    spawnmenu.AddToolMenuOption("Options","Bio-Annihilation II","ba2_config_cos","Customs","","",function(panel)
        panel:Help("You can type \"find ba2_cos\" in the developer console for more information about these settings.")
        panel:Help("These settings change the appearance of Custom Infected.")

        -- panel:Help("Default Infected Color:")
        -- local mixer = vgui.Create("DColorMixer",panel)
        -- mixer:Dock(FILL)					-- Make Mixer fill place of Frame
        -- mixer:SetPalette(true)  			-- Show/hide the palette 				DEF:true
        -- mixer:SetAlphaBar(true) 			-- Show/hide the alpha bar 				DEF:true
        -- mixer:SetWangs(true) 				-- Show/hide the R G B A indicators 	DEF:true
        -- mixer:SetColor(Color(133,165,180)) 	-- Set the default color

        panel:CheckBox("Zombie Tint","ba2_cos_tint")

        panel:Help("Custom Model Paths:")
        panel:ControlHelp("Press Help key (F1) to keep the spawnmenu open")
        panel:ControlHelp("Type --ARMORED-- and place paths below the line to indicate Armored models")
        local tBox = vgui.Create("DTextEntry")
        tBox:SetMultiline(true)
        tBox:SetVerticalScrollbarEnabled(true)
        tBox:SetSize(400,300)

        local defText = ""
        local tbl1,tbl2 = BA2_GetAltModels(true)
        local tbl = table.Add(tbl1,tbl2)

        for i,str in pairs(tbl) do
            defText = defText..str.."\n"
        end

        tBox:SetValue(defText)

        panel:AddItem(tBox)

        local rButton = vgui.Create("DButton")
        rButton:SetText("Reload Custom Models")
        rButton.DoClick = function()
            BA2_WriteToAltModels(string.Split(tBox:GetValue(),"\n"))
            if LocalPlayer():IsAdmin() then
                net.Start("BA2ReloadCustoms")
                net.WriteTable(string.Split(tBox:GetValue(),"\n"))
                net.SendToServer()
            end
        end
        
        panel:AddItem(rButton)
        if(LocalPlayer():IsAdmin() == false) then
            panel:ControlHelp("You must be a server admin to set the server's custom models")
        end
    end)

    -- HORDE SPAWNER
    spawnmenu.AddToolMenuOption("Options","Bio-Annihilation II","ba2_config_hs","Spawners","","",function(panel)
        if(LocalPlayer():IsAdmin() == false) then
            panel:ControlHelp(adminString)
        end
        panel:Help("You can type \"find ba2_hs\" in the developer console for more information about these settings.")
        panel:Help("These settings change the behavior of the Horde Spawner and Point Spawner entities.")
        
        panel:CheckBox("Clean Up on Remove","ba2_hs_cleanup")
        panel:CheckBox("Clean Up Targetless Zombies","ba2_hs_notargetclean")
        panel:NumSlider("Maximum Zombies","ba2_hs_max",1,100,0)
        panel:NumSlider("Horde Spawner Interval","ba2_hs_interval",0.1,30,1)
        panel:NumSlider("Point Spawner Interval","ba2_ps_interval",0.1,30,1)
        panel:NumSlider("Maximum Radius","ba2_hs_maxradius",0,10000,0)
        panel:NumSlider("Safe Radius","ba2_hs_saferadius",0,10000,0)
        panel:NumSlider("Detection Range","ba2_hs_zom_range",0,10000,0)
        panel:ControlHelp("If set to 0, zombies spawned by the horde spawner will use the detection range from the \"Zombies\" tab. If you do change this, make sure to make it a bit greater than the Safe Radius.")

        -- local comboBox = panel:ComboBox("Zombie Appearance","ba2_hs_appearance")
        -- comboBox:AddChoice("0. Citizens",0)
        -- comboBox:AddChoice("1. Rebels",1)
        -- comboBox:AddChoice("2. Combine",2)
        -- comboBox:AddChoice("3. Custom",3)
        -- comboBox:AddChoice("4. Any of the above",4)
        -- comboBox:AddChoice("5. Any except Custom Infected",5)

        panel:Help("Appearance:")
        panel:CheckBox("Citizen","ba2_hs_appearance_0")
        panel:CheckBox("Rebel","ba2_hs_appearance_1")
        panel:CheckBox("Metrocop","ba2_hs_appearance_2")
        panel:CheckBox("Custom","ba2_hs_appearance_3")
        panel:NumSlider("Combine Chance","ba2_hs_combine_chance",0,100)
        panel:NumSlider("Custom Armored Chance","ba2_hs_carmor_chance",0,100)

        panel:Button("Delete Active Horde Spawner","ba2_hs_delete","")

        panel:Help("THE FOLLOWING SETTINGS ARE EXPERIMENTAL. USE AT YOUR OWN RISK!")
        panel:Help("(That being said, they might make the horde spawner better!)")
        
        panel:CheckBox("Clean Up Stuck Zombies","ba2_hs_stuckclean")
        panel:CheckBox("More Spawn Locations","ba2_hs_morespawnlocations")
        panel:CheckBox("Proximity Spawning","ba2_hs_proximityspawns")
        panel:CheckBox("Stop Targeting Outside Detection Range","ba2_hs_stoptargetingoutsidedetectionrange")
    end)

    -- INFECTION
    spawnmenu.AddToolMenuOption("Options","Bio-Annihilation II","ba2_config_inf","Infection","","",function(panel)
        if(LocalPlayer():IsAdmin() == false) then
            panel:ControlHelp(adminString)
        end
        panel:Help("You can type \"find ba2_inf\" in the developer console for more information about these settings.")
        panel:Help("These settings modify the titular Bio-Virus: its contagiousness, persistence, lethality, and ability to convert.")

        panel:CheckBox("Zombify Players","ba2_inf_plyraise")
        panel:CheckBox("Zombify NPCs","ba2_inf_npcraise")

        panel:CheckBox("Virus Must Kill to Raise","ba2_inf_killtoraise")
        panel:ControlHelp("The Bio-Virus or one of its hosts must directly kill the victim to raise them into a zombie")
        panel:CheckBox("Romero Mode","ba2_inf_romeromode")
        panel:ControlHelp("All dead players and NPCs raise as zombies, regardless of infection")

        panel:NumSlider("Maximum Zombies","ba2_inf_maxzoms",0,100,0)
        panel:ControlHelp("New zombies will not raise if there are this many zombies alive")
        panel:NumSlider("Contagion Radius","ba2_inf_contagionmult",0,10,2)
        panel:NumSlider("Player Infection","ba2_inf_plymult",0,10,2)
        panel:NumSlider("NPC Infection","ba2_inf_npcmult",0,10,2)
        panel:NumSlider("Infection Damage","ba2_inf_dmgmult",0,10,2)
        panel:ControlHelp("Set values to 0 to disable their respective features")

        panel:Button("Delete Contaminant Clouds","ba2_inf_deleteclouds")
        panel:Button("Delete Active Air Waste", "ba2_aw_delete")
    end)

    -- ZOMBIES
    spawnmenu.AddToolMenuOption("Options","Bio-Annihilation II","ba2_config_zom","Zombies","","",function(panel)
        if(LocalPlayer():IsAdmin() == false) then
            panel:ControlHelp(adminString)
        end
        panel:Help("You can type \"find ba2_zom\" in the developer console for more information about these settings.")
        panel:Help("These settings change the attributes of zombies, allowing you to change their behavior or make them easier or harder to kill.")

        panel:CheckBox("Target Swapping","ba2_zom_retargeting")
        panel:ControlHelp("May cause stuttering")
        panel:CheckBox("Stun by Damage","ba2_zom_damagestun")
        panel:CheckBox("Arm Damage/Disarming","ba2_zom_armdamage")
        panel:CheckBox("Leg Damage/Crippling","ba2_zom_legdamage")
        panel:CheckBox("Claw Attack Mode","ba2_zom_attackmode")

        panel:NumSlider("Health","ba2_zom_health",1,500,0)
        panel:NumSlider("Damage Multiplier","ba2_zom_dmgmult",0,10,2)
        panel:NumSlider("Infection Multiplier","ba2_zom_infectionmult",0,10,2)
        panel:NumSlider("Detection Range","ba2_zom_range",0,50000,0)
        panel:NumSlider("Non-Headshot Damage Multiplier","ba2_zom_nonheadshotmult",0,1,2)
        panel:NumSlider("Limb Damage Multiplier","ba2_zom_limbdamagemult",0,1,2)
        panel:NumSlider("Armored Damage Multiplier","ba2_zom_armordamagemult",0,1,2)
        panel:NumSlider("Infected Raise Time","ba2_zom_emergetime",0,300,0)
        panel:NumSlider("Medic Vial Drop Chance","ba2_zom_medicdropchance",0,100,0)
        panel:NumSlider("Pursuit Speed","ba2_zom_pursuitspeed_ge",45,300,0)
        panel:NumSlider("Arm Break Multiplier","ba2_zom_armbreakmultiplier",0,1,2)
        panel:NumSlider("Leg Break Multiplier","ba2_zom_legbreakmultiplier",0,1,2)

        panel:Help("")

        panel:CheckBox("Attack Props","ba2_zom_breakobjects")
        panel:ControlHelp("The next options require Attack Props")
        panel:CheckBox("Unfreeze/Unconstrain Props","ba2_zom_breakphys")
        panel:CheckBox("Break Down Doors","ba2_zom_breakdoors")
        panel:NumSlider("Prop Damage Multiplier","ba2_zom_propdmgmult",0,10,2)
        panel:CheckBox("Variable Prop Force","ba2_zom_variablepropforce")

        panel:NumSlider("Door Respawn Time","ba2_zom_doorrespawn",0,300,0)
        panel:ControlHelp("Set to 0 to not respawn doors until map cleanup")

        panel:Help("THE FOLLOWING SETTINGS ARE EXPERIMENTAL. USE AT YOUR OWN RISK!")
        panel:Help("(They also might help with performance issues, though!)")

        panel:CheckBox("Don't Target Noclipping Players","ba2_zom_notargetnoclip")
        panel:CheckBox("Pathtraced Wandering","ba2_zom_ptwander")
        panel:CheckBox("Handle Bad Paths","ba2_zom_handlebadpaths")
        panel:CheckBox("Better Door Breaking","ba2_zom_betterdoorbreaking")
    end)

    -- MISCELLANEOUS
    spawnmenu.AddToolMenuOption("Options","Bio-Annihilation II","ba2_config_misc","Miscellaneous","","",function(panel)
        if(LocalPlayer():IsAdmin() == false) then
            panel:ControlHelp(adminString)
        end
        panel:Help("You can type \"find ba2_misc\" in the developer console for more information about these settings.")
        panel:Help("These settings don't have a category in common, and can therefore change a variety of things.")

        panel:NumSlider("Zombie Corpse Lifetime","ba2_misc_corpselife",-1,300,0)
        panel:ControlHelp("Set to -1 for infinite lifetime (not recommended)")

        panel:CheckBox("Degradable Gas Mask Filters","ba2_misc_maskfilters")
        panel:CheckBox("Spawn with Gas Mask","ba2_misc_startwithmask")
        panel:CheckBox("Drop Gas Mask on Death","ba2_misc_deathdropmask")
        panel:CheckBox("Drop Filters on Death","ba2_misc_deathdropfilter")
        panel:NumSlider("Maximum Filters","ba2_misc_maxfilters",-1,100,0)
        panel:ControlHelp("Set to -1 for infinite capacity")

        panel:Help("")

        panel:CheckBox("Air Waste Visuals","ba2_misc_airwastevisuals")
        panel:CheckBox("Air Waste View Shake","ba2_misc_airwasteshake")
        panel:CheckBox("Gib Bloodstains","ba2_misc_gibdecals")
        panel:CheckBox("No Navmesh Warning","ba2_misc_navmeshwarn")
        panel:CheckBox("Zombie Kill Credit","ba2_misc_addscore")
        panel:CheckBox("Show Gamma Edition Info","ba2_misc_gammaeditioninfo")

        panel:Help("")

        panel:CheckBox("Count Zombies as NPCs","ba2_misc_isnpc")
        panel:ControlHelp("May cause Lua errors in other addons - enable at your own risk")
    end)
end)

-- See ba2_precache.lua for precaching