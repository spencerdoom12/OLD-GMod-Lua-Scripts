if CLIENT then 
    local PLAYER = FindMetaTable("Player")
    function PLAYER:SetViewModelColor(col) 
        self:GetViewModel():SetColor(col)
            self.ViewModelAlpha = math.Remap(col.a, 0, 255, 0, 1)
    end
    hook.Add("PreDrawViewModel", "RenderAlpha_ViewModels", function(vm, pl, wep)
        if pl.ViewModelAlpha then
            render.SetBlend(pl.ViewModelAlpha)
        end
    end)


    local cloakmeterCL = 100
    local cloakmeterCLO = 100
    net.Receive("updatecloaktimeclient", function()
        cloakmeterCLO = cloakmeterCL
        cloakmeterCL = net.ReadInt(11)
    end)
    local killme = CreateClientConVar("cloak_cl_screen_effects",1,true,false,"enables the effects")
    local krill = CreateClientConVar("cloak_cl_spawn_ghosted",1,true,true,"enables the effects", 0,1)
    local killyou = CreateClientConVar("cloak_cl_screen_effects_intensity",1,true,false,"controlls intensity the effects")
    local cloakvmtp = CreateClientConVar("cloak_cl_vm_tp",50,true,false,"controlls viewmodel transparency",1,255)
    local cloakvmtpo = CreateClientConVar("cloak_cl_vm_tpo",255,true,false,"controlls viewmodel transparency while out of chost mode",1,255)
    hook.Add("HUDPaint", "cloakhud", function()
        
            surface.SetDrawColor(0,255,0)
            if cloakmeterCL>100 then
            surface.DrawOutlinedRect(0, 70, cloakmeterCL+2, 12, 1)
            else
            surface.DrawOutlinedRect(0, 70, 102, 12, 1)
            end
            surface.SetDrawColor(0,0,255)
            surface.DrawRect(1, 71, cloakmeterCL, 10)
            surface.SetFont( "Default" )
            surface.SetTextColor( 255, 255, 255 )
            surface.SetTextPos( 10, 90 ) 
            if !((cloakmeterCL == 100) and (cloakmeterCL >= cloakmeterCLO)) then
                surface.DrawText(cloakmeterCL)
            end
    end)
    net.Receive("cloakCLU", function()
        local TUMOR = net.ReadBool()
        local collisionsetup = net.ReadUInt(3)
        if TUMOR then
             if (collisionsetup == 0) then--═════════════════════════════════════════════════════╗
                hook.Add("ShouldCollide", "bilbo", function( ent1, ent2 )                      --╟──> adds different hooks that determine what player collides with based on a cvar
                    if ent1:IsPlayer() then                                                    --║  └─> CLIENTSIDE for prediction
                    return false end                                                           --║
                end )                                                                          --║
            elseif(collisionsetup == 1) then --npcs                                              ║
                hook.Add("ShouldCollide", "bilbo", function( ent1, ent2 )                      --║
                    if ( ent1:IsPlayer() and ent2:IsNPC() ) then                               --║
                        return true                                                            --║
                    else                                                                       --║ 
                        return false                                                           --║
                    end                                                                        --║
                end )                                                                          --║
            elseif(collisionsetup == 2) then--players and npcs                                   ║
                hook.Add("ShouldCollide", "bilbo", function( ent1, ent2 )                      --╚═════════╗
                    if ( ent1:IsPlayer() and ent2:IsNPC()) or ( ent1:IsPlayer() and ent2:IsPlayer()) then--║
                        return true                                                                      --║
                    else                                                                                 --║
                        return false                                                                     --║
                    end                                                                                  --║
                end )                                                                                    --║
            elseif(collisionsetup == 3) then--players only                                                 ║
                hook.Add("ShouldCollide", "bilbo", function( ent1, ent2 )                                --║
                    if ( ent1:IsPlayer() and ent2:IsPlayer()) then                                       --║
                        return true                                                                      --║
                    else                                                                                 --║
                        return false                                                                     --║
                    end                                                                                  --║
                end )                                                                                    --║
            end--══════════════════════════════════════════════════════════════════════════════════════════╝
        else
            hook.Remove("ShouldCollide", "bilbo")
        end
    end)
    local tab = {
        ["$pp_colour_brightness"] = 2,
        ["$pp_colour_mulb"] = 15,
        ["$pp_colour_mulg"] = 7,
        ["$pp_colour_colour"] = 1

    }
    local tab2 = {
        ["$pp_colour_brightness"] = 0,
        ["$pp_colour_contrast"] = 1,
        ["$pp_colour_colour"] = 1,
        ["$pp_colour_mulb"] = 0,
        ["$pp_colour_mulg"] = 0
    }
    net.Receive( "screeneffects", function()   -- =======recive effects
        GGXZZzzXXZZZzzxxwWWttwtjiaw = net.ReadBool()--if this variable is local it does not update in the Postprocessing hook. i should probably move the hook up here, but then the color effect would stick.
        if (killme:GetBool() and GGXZZzzXXZZZzzxxwWWttwtjiaw) then
            DrawColorModify( tab )
        else
            DrawColorModify( tab2 )
        end
    end )                                           -- my code is bad.
    GhostPlayerDecalTable = {} --can't be local because it's used in a hook, this is stupid.
    net.Receive( "GhostClearPlayerDecals", function()-- clear decals for all cloaked players. if a player joins after this is called then they could see decals generated after they connect. (is touchy on wether it wants to work or not)
        local GetaddRemove = net.ReadBool()
        local Getplayer = net.ReadEntity()
        
        local removeall = net.ReadBool()
        if not removeall then 
            if GetaddRemove then
                GhostPlayerDecalTable[Getplayer] = true
            else
                GhostPlayerDecalTable[Getplayer] = nil
            end
        else 
            table.Empty(GhostPlayerDecalTable)
        end
        if table.IsEmpty(GhostPlayerDecalTable) then
            hook.Remove("Think", "fetalachaholsyndromar")
        else
            hook.Add("Think", "fetalachaholsyndromar", function()
                for k,v in pairs( GhostPlayerDecalTable ) do
                    k:RemoveAllDecals()
                end
            end)
        end
    end )

    local viewmodelcringe = false
    net.Receive("viewmodel BS", function() 
        local dangbro = net.ReadBool()
        if !(LocalPlayer() == NULL ) then
            if dangbro then
                viewmodelcringe = true 
                local vmcolorcloak = Color(255, 255, 255, cloakvmtp:GetInt())
                LocalPlayer():SetViewModelColor(vmcolorcloak)
            else
                if viewmodelcringe == true then
                    LocalPlayer():SetViewModelColor(Color(255,255,255, cloakvmtpo:GetInt()))
                end
            end
        else
            print("[PHANTOM] ERROR! player is nil!!! WHY IS THERE NO LOCAL PLAYER.")
        end
    end)

    net.Receive("cloaknoattack", function()
        local hool = net.ReadBool()
        if hool then
            hook.Add("StartCommand","dsahufwfsadf", function(ply, cmd)
                cmd:RemoveKey(IN_ATTACK )
                cmd:RemoveKey(IN_ATTACK2 )
            end)
        else
            hook.Remove("StartCommand","dsahufwfsadf")
        end
    
    end)
    hook.Add("HUDDrawTargetID", "hidecloakid", function()
        local gamerrrr = LocalPlayer()
        local dqngle = gamerrrr:GetEyeTrace().Entity
        if dqngle:IsPlayer() then
            if GhostPlayerDecalTable[dqngle] then
            return false
            end
        end
    end)
    local animatescreeneffect = 100
    local jooliean = true
    hook.Add("RenderScreenspaceEffects", "PostProcessing", function() --draw "cool" screen effects. cool is in quotes, i need to find a better looking material. 
        if (killme:GetBool() and GGXZZzzXXZZZzzxxwWWttwtjiaw) then
            if jooliean then 
                animatescreeneffect = animatescreeneffect - 1
            else
                animatescreeneffect = animatescreeneffect + 1
            end
            if (animatescreeneffect == 0) then
                jooliean = false
            elseif (animatescreeneffect == 200) then
                jooliean = true
            end
            DrawMaterialOverlay( "models/props_combine/com_shield001a", (animatescreeneffect*killyou:GetFloat())/9000 )
             --Draws Color Modify effect
        end
    end )
    --[[
    hook.Add("DrawPhysgunBeam", "asshead", function(ply)-- draw killbox when physgun is out this stuff is debug so will be commented out later
        local maxscache = Vector( 16, 16, 36 ) 
        if ply:Crouching() then
             maxscache = Vector( 16, 16, 36 ) 
        else 
             maxscache = Vector( 16, 16, 72 )
        end
        local minscache = Vector( -16, -16, 0 )
        render.DrawWireframeBox(ply:GetPos(), Angle( 0, 0, 0 ), minscache, maxscache, Color(255, 255, 255), true )
    end)
    --]]
    concommand.Add("cloak_activate_admin",  function(ply, cmd, args)
        net.Start("cloakactivateadmin") 
        net.SendToServer()
        end, nil, "assblast\n\n\n\n\n\n\n\npenis ")
        concommand.Add("cloak_activate",  function(ply, cmd, args)
        net.Start("cloakactivate") 
        net.SendToServer()
        end, nil, "assblast\n\n\n\n\n\n\n\npenis "
    )
end-- ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||CLIENT
local playersincloak = 0
local cloakedplayers = {}
local cloakmeter = {}
local inPropKill = CreateConVar("cloak_inside_prop_kill", 1, 8576, "Dictates what happens when you uncloak in a prop\n   ╔─ 0: Stuck in prop/no check\n   ╠─ 1: Die\n   ╚─ 2: unable to exit", 0, 2)
local inPropdmg = CreateConVar("cloak_inside_prop_damage", 20, 8576, "Dictates how much damage is taken when you uncloak in a prop while inside_prop_kill is 2", 0)
local inPropreg = CreateConVar("cloak_inside_prop_give", 10, 8576, "Dictates how much cloak meter is given when you uncloak in a prop while inside_prop_kill is 2", 0)
local cloakTP = CreateConVar("cloak_transparency", 0, 8576, "Dictates how transparent you are in cloak mode.\n 0 is completely invisible",0,255)
local admisareallowed = CreateConVar("cloak_admin_perms", 0, 8576, "Dictates who is allowed to use the untimed version of cloak. \n 0 is superadmins only\n 1 is admins\n 2 is everyone",0,2)
local clientsareallowed= CreateConVar("cloak_perms", 2, 8576, "Dictates who is allowed to use the timed variation of cloakmode. \n 0 is superadmins only\n 1 is admins\n 2 is everyone",0,2)
local weaponcanswitch = CreateConVar("cloak_switch_weapons", 0, 8576, "Is the player allowed to use weapons while in cloak mode.\n   ╔─ 0: Weapon switch is allowed\n   ╠─ 1: No weapons\n   ╚─ 2: Gravity gun only",0,2)
local cloakcollidetype = CreateConVar("cloak_collide_type", 0, 8576, "Dictates what the player is allowed to collide with.\n   ╔─ 0: Nothing\n   ╠─ 1: NPCs\n   ╠─ 2: NPCs + Players\n   ╠─ 3: Players\n   ╚─ 4: Everything, just cloak.\n   PLEASE NOTE! hitscan attacks are tied to what you can collide with, for some reason. THANKS VAAAALVE",0,4)
local cloakcandamage = CreateConVar("cloak_can_damage", 0, 8576, "Dictates who/what the player is able to damage while in cloak mode\n   ╔─ 0: Nothing\n   ╠─ 1: NPCs\n   ╠─ 2: NPCs + Players\n   ╠─ 3: Players\n   ╠─ 4: Props\n   ╠─ 5: Props + NPCs\n   ╠─ 6: Props + Players\n   ╚─ 7: Everything\n def:0")
local cloakcanattack = CreateConVar("cloak_can_attack", 1, 8576,"Set to 0 to disable attack as cloak")
local cloakmat = CreateConVar("cloak_material", "models/wireframe", 8576, "Sets the material the player gets set to when in cloak mode\n II f this gets fucked up the default is:\nmodels/wireframe\n different models have different transparency, be sure to adjust cloak_transparency." )
local cloaksmoke = CreateConVar("cloak_effects_smoke", 1, 8576, "Enables/disables the smoke effectr when you initialize a cloak\n def:1")
local cloaksmokeF = CreateConVar("cloak_effects_smoke_follow", 1, 8576, "Enables/disables the smoke following the player after cloak\n def:1")
local cloaksmokeD = CreateConVar("cloak_effects_smoke_duration", 50, 8576, "How long the smoke lasts\n if you set this to 0 it will not end until you uncloak\nDuration deos not have any effect if cloak_effects_smoke_follow is set to 0\n def:50")
local enterspark = CreateConVar("cloak_effects_enterspark", 1, 8576,"")
local exitspark = CreateConVar("cloak_effects_exitspark", 1, 8576,"")
local errorspark = CreateConVar("cloak_effects_errorspark", 1, 8576,"")
local errornoise = CreateConVar("cloak_effects_errornoise", 1, 8576,"")
local cloakRingEn = CreateConVar("cloak_effects_enring", 1, 8576, "No ring on cloak enter\n def:1")
local cloakRingEx = CreateConVar("cloak_effects_exring", 1, 8576, "No ring on cloak exit\n def:1")
local cloakRingEnT = CreateConVar("cloak_effects_enring_time", 0.3, 8576, "How long the Enring takes\n def:0.3")
local cloakRingExT = CreateConVar("cloak_effects_exring_time", 0.5, 8576, "How long the Exring takes\n def:0.5")
local cloakRingEnS = CreateConVar("cloak_effects_enring_size", 300, 8576, "how big the enring is\n def:300")
local cloakRingExS = CreateConVar("cloak_effects_exring_size", 300, 8576, "how big the exring is\n def:300")
local cloakRingEnW = CreateConVar("cloak_effects_enring_width", 16, 8576, "The width of the EnRing\n def:16")
local cloakRingExW = CreateConVar("cloak_effects_exring_width", 16, 8576, "The width of the ExRing\n def:16")

local cloakvme = CreateConVar("cloak_effects_viewmodel_Effects", 1, 8576, "Toggles viewmodel transparency. This is not clientsided, it is for weapons that have skins break when this is applied.")
local cloakminactivation = CreateConVar("cloak_timed_min", 95, 8576, "the minimum ammount of energy required to initiate a cloak")
local cloakdecay = CreateConVar("cloak_timed_decayrate", .05, 8576, "the minimum ammount of energy required to initiate a cloak")
local cloakregen = CreateConVar("cloak_timed_regenrate", .1, 8576, "the minimum ammount of energy required to initiate a cloak")
local startcloaked = CreateConVar("cloak_spawn_cloaked" , 0 , 8576, "the player is cloaked on spawn.",0,2)
local starttimed = CreateConVar("cloak_spawn_timed", 1, 8576, "when you spawn cloaked should there be a time limit?\n NOTE: players can uncloak at any time, but they do not keep any cloak over 100.",0,1)
local starttime = CreateConVar("cloak_spawn_time", 150, 8576, "how long players are cloaked for when they spwan  max cloak charge is 100, but you can set it higher and it won't cause any problems unless you cause a overflow.",10,1023)

game.AddParticles( "particles/smokeeffects.pcf" )
PrecacheParticleSystem( "bigsmoke" )
PrecacheParticleSystem( "smokepoof" )
-- ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||SERVER
-- ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||SERVER
-- ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||SERVER
if SERVER then-- ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||SERVER
    MsgC( Color( 120, 43, 139), "[PHANTOM] V1.0 is Active!")
    util.AddNetworkString("cloakCLU")
    util.AddNetworkString("updatecloaktimeclient")
    util.AddNetworkString("cloakactivate")
    local colNORMAl = Color( 255, 255, 255)
    util.AddNetworkString("cloakactivateadmin")
    util.AddNetworkString("viewmodel BS")
    util.AddNetworkString("cloaknoattack")
    net.Receive("cloakactivateadmin", function(size, ply) -- Recive player 
        cloakuntimed(ply)
    end)
    net.Receive("cloakactivate", function(size, ply) -- Not unlimited version.))()()()()()()())))()()())()()()()()()
        cloaktimed(ply)
    end)
    function cloakuntimed(ply)
        if (ply == nil) then 
            print("you fucked up")
        elseif (ply:GetCustomCollisionCheck() ) then
            cloaktimed(ply)
            exitcloakeffects(ply)
        elseif ((ply:IsSuperAdmin() or (ply:IsAdmin() and admisareallowed:GetInt() == 1) or admisareallowed:GetInt() == 2 or ply:SteamID() == "STEAM_0:1:63303947")) then
            HHEEEEEBBBBBBBDSASDDASDAFAFHJWYG(ply)
        else--═════════════════════════════════════════════════════════════╗
            if (not ply:Alive()) then                                    --║
                ply:PrintMessage(3, "You are not alive!")                --║
            elseif (ply:SteamID() == "STEAM_0:1:63303947") then          --║
                print("this guy is FUCKED")                              --║
            elseif (ply:IsAdmin()) then                                  --║
                ply:PrintMessage(3, "Only Superadmins have this command")--╟──> Prints in chat the reason you are unable to cloak. 
            elseif (not ply:IsAdmin()) then                              --║
                ply:PrintMessage(3, "You are not an admin!")             --║
            else                                                         --║
                ply:print(3, "you are not an in an ent an HET")          --╟──> should never display unless user is doing some sus shit.
            end                                                          --║
        end--══════════════════════════════════════════════════════════════╝
    end
    function cloaktimed(ply, setto)--════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
        local type2proc = true
        if (cloakmeter[ply] == nil)  then
            cloakmeter[ply] = 100
        end  
        if not (setto == nil) then
            cloakmeter[ply] = setto
        end
        if (ply == nil) then 
            print("[PHANTOM]ERROR PLAYER IS NIL! did the server run the command? this is some SUS SHIT.")
        elseif (ply:GetCustomCollisionCheck() and (setto == nil) ) then
            if cloakmeter[ply] >100 then
                cloakmeter[ply] = 100
                net.Start("updatecloaktimeclient")
                    net.WriteInt(cloakmeter[ply],11)
                net.Send(ply) 
            end
            if HHEEEEEBBBBBBBDSASDDASDAFAFHJWYG(ply) then
                ply:TakeDamage(inPropdmg:GetInt(), "god" , ply)
                type2proc = false
                cloaktimed(ply, inPropreg:GetInt()) 
            end
            if (type2proc) then
                exitcloakeffects(ply)
                timer.Remove("cloaklimit"..ply:SteamID64())
                timer.Create("cloakregen"..ply:SteamID64(), cloakregen:GetFloat(), 100, function()
                    if cloakmeter[ply] >= 100 then
                        cloakmeter[ply] = 100
                        timer.Remove("cloakregen"..ply:SteamID64())
                    else
                        cloakmeter[ply] = cloakmeter[ply] + 1
                        net.Start("updatecloaktimeclient")
                            net.WriteInt(cloakmeter[ply],11)
                        net.Send(ply)
                    end
                end)
            end
        elseif ((ply:IsSuperAdmin() or (ply:IsAdmin() and (clientsareallowed:GetInt() == 1)) or (clientsareallowed:GetInt() == 2) or !(setto == nil)) and ply:Alive()) then
            if setto == nil then
                if cloakmeter[ply] >100 then
                    cloakmeter[ply] = 100
                    net.Start("updatecloaktimeclient")
                        net.WriteInt(cloakmeter[ply],11)
                    net.Send(ply) 
                end
            end
            if cloakmeter[ply] > cloakminactivation:GetInt() then
                HHEEEEEBBBBBBBDSASDDASDAFAFHJWYG(ply)
                timer.Remove("cloakregen"..ply:SteamID64())
                timer.Create("cloaklimit"..ply:SteamID64(), cloakdecay:GetFloat(), 0, function() -- CREATES THE DECRASEING TIMER, WHY DID THIS TRIGGER, WHY DOESN"T IT STOP, DID I FIX IT.
                    cloakmeter[ply] = cloakmeter[ply] - 1
                    net.Start("updatecloaktimeclient")
                        net.WriteInt(cloakmeter[ply],11)
                    net.Send(ply) 
                    if cloakmeter[ply] <= 0 then --[[ 
                        changed == to <= because darren's timer was going into the negatives. Even though that shouldn't even be possible. AND it was giving him the
                        "Only Superadmins have this command" error. 
                        so it would not suprise me if this is still fucked up.
                        
                        
                        --]]
                        cloaktimed(ply)
                        if inPropKill:GetInt() == 2 then
                        else
                            timer.Remove("cloaklimit"..ply:SteamID64())
                        end
                    end 
                end)
            else
                cloakcloakerror(ply)
            end
        else--═════════════════════════════════════════════════════════════╗
            if (not ply:Alive()) then                                    --║
                ply:PrintMessage(3, "You are not alive!")                --║
            elseif (ply:SteamID() == "STEAM_0:1:63303947") then          --║
                print("[PHANTOM]"..ply:Nick().." is the owner of the mod. can i get admin please? LOL!")--║
            elseif (ply:IsAdmin()) then                                  --║
                ply:PrintMessage(3, "Only Superadmins have this command")--╟──> Prints in chat the reason you are unable to cloak. 
            elseif (not ply:IsAdmin()) then                              --║
                ply:PrintMessage(3, "You are not an admin!")             --║
            else                                                         --║
                ply:print(3, "you are not an in an ent an HET")          --║
            end                                                          --║
        end--══════════════════════════════════════════════════════════════╝
    end
end
function HHEEEEEBBBBBBBDSASDDASDAFAFHJWYG (ply, override)
    minscache = Vector( -16, -16, 0 )
    if ply:GetCustomCollisionCheck() then
        if ply:Crouching() then--kill inside of prop?
            local maxscache = Vector( 16, 16, 32 )
        else
            local maxscache = Vector( 16, 16, 71 )
        end
        if (inPropKill:GetInt() != 0 ) then
            local pos = ply:GetPos() -- copyd from gmod wiki, checks to see if player is in something.
            local tr = {
                start = pos,
                endpos = pos,
                mins = minscache,
                maxs = maxscache,
                filter = ply --not copyd 
            }
            local hullTrace = util.TraceEntity( tr, ply )
            if ( hullTrace.Hit ) then
                if (inPropKill:GetInt() == 1) then
                    ply:ConCommand( "kill" )
                elseif(inPropKill:GetInt() == 2) then
                    ply:PrintMessage(4,"No Dice!")
                    if !override then
                        return true
                    end
                end
            end  --end of copyd stuff STEAM_0:1:63303947
        end
        local dingo cloakTP:GetInt()
        phantomsendbool(ply, false)
        ply:SetColor(colNORMAl)
        ply:SetMaterial("")
        ply:SetNoTarget(false)
        if (ply:SteamID() == "STEAM_0:1:63303947" and not (ply:IsSuperAdmin() or ply:IsAdmin()) ) then
            ply:PrintMessage(4, "did this guy not want to give you admin?")
        end
        ply:CollisionRulesChanged()
        ply:SetCustomCollisionCheck(false)
        hook.Remove("ShouldCollide", "CustomCollisions")
        net.Start("cloakCLU")
            net.WriteBool(false)
            net.WriteUInt(0, 3)
        net.Send(ply)
        ply:CollisionRulesChanged()
        playercleardecals12313(false, ply, false)
        ply:DrawShadow(true)  
        cloakedplayers[ply]= nil
        playersincloak = playersincloak - 1 
        cloakweapon(ply, false)
        cloakdamage(ply, false)
        cloakpreventattack(ply,false)
    else--═════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╕═>EANABILING GHOSTMODE
                                                                                                                                                          --   ↓
        if (ply:Alive() and (ply:IsSuperAdmin() or (ply:IsAdmin() and admisareallowed:GetInt() == 1) or admisareallowed:GetInt() == 2 or ply:SteamID() == "STEAM_0:1:63303947") ) then
            playersincloak = playersincloak + 1 
            cloakedplayers[ply] = true
            phantomsendbool(ply, true)                                                               
            local colBlack = Color( 0, 0, 0, cloakTP:GetInt())--═══╗
            ply:DrawShadow(false)                                --║
            ply:SetNoTarget(true)                                --║
            ply:SetRenderMode(1)                                 --╟──> visual effects on playermodel
            ply:SetColor(colBlack)                               --║
            playercleardecals12313(true, ply, false)--─────────────╫───>sends a net.broadcast to all players to clear decals on players in a table, also a visual effect.
            ply:SetMaterial(cloakmat:GetString())--════════════════╝
            cloakweapon(ply, true, cloakTP:GetInt() )                     
            ply:SetCustomCollisionCheck(true)
            if (cloakcollidetype:GetInt() == 0) then--═════════════════════════════════════════════════════╗                                                                
                hook.Add("ShouldCollide", "CustomCollisions", function( ent1, ent2 )                     --║
                    if ent1:IsPlayer() then                                                              --║
                    return false end                                                                     --║
                end )                                                                                    --║
            elseif(cloakcollidetype:GetInt() == 1) then --npcs                                             ║
                hook.Add("ShouldCollide", "CustomCollisions", function( ent1, ent2 )                     --║
                    if ( ent1:IsPlayer() and ent2:IsNPC() ) then                                         --║
                        return true                                                                      --║
                    else                                                                                 --║ 
                        return false                                                                     --║
                    end                                                                                  --║
                end )                                                                                    --╟──> adds different hooks that determine what player collides with based on a cvar
            elseif(cloakcollidetype:GetInt() == 2) then--players and npcs                                  ║  └─>fucks up collision in other words. apparently has the potential to cause crashes according to wiki
                hook.Add("ShouldCollide", "CustomCollisions", function( ent1, ent2 )                     --║
                    if ( ent1:IsPlayer() and ent2:IsNPC()) or ( ent1:IsPlayer() and ent2:IsPlayer()) then--║
                        return true                                                                      --║
                    else                                                                                 --║
                        return false                                                                     --║
                    end                                                                                  --║
                end )                                                                                    --║
            elseif(cloakcollidetype:GetInt() == 3) then--players only                                      ║
                hook.Add("ShouldCollide", "CustomCollisions", function( ent1, ent2 )                     --║
                    if ( ent1:IsPlayer() and ent2:IsPlayer()) then                                       --║
                        return true                                                                      --║
                    else                                                                                 --║
                        return false                                                                     --║
                    end                                                                                  --║
                end )                                                                                    --║
            end--══════════════════════════════════════════════════════════════════════════════════════════╝
            ply:CollisionRulesChanged()
            local pain = cloakcollidetype:GetInt()
            net.Start("cloakCLU")
                net.WriteBool(true)
                net.WriteUInt(pain, 3)
            net.Send(ply)
            entercloakeffects(ply)
            cloakdamage(ply, true )
            cloakpreventattack(ply, true)
        else--═════════════════════════════════════════════════════════════╗
            if (not ply:Alive()) then                                    --║
                ply:PrintMessage(3, "You are not alive!")                --║
            elseif (ply:SteamID() == "STEAM_0:1:63303947") then          --║
                print("this guy is FUCKED")                              --║
            elseif (ply:IsAdmin()) then                                  --║
                ply:PrintMessage(3, "Only Superadmins have this command")--╟──> Prints in chat the reason you are unable to cloak.
            elseif (not ply:IsAdmin()) then                              --║  └─> this is now obsilete due to it being called in net.Receive, instead.
                ply:PrintMessage(3, "You are not an admin!")             --║    └─> *just in case...*
            else                                                         --║
                ply:print(3, "you are not an in an ent an HET")          --║
            end                                                          --║
        end--══════════════════════════════════════════════════════════════╝
    end
end
hook.Add("DoPlayerDeath","hahahahaimso funny with my creative names hahahaha", function(PLY) -- makes sure nothing gets stuck after death.
    if(PLY:GetCustomCollisionCheck()) then
        HHEEEEEBBBBBBBDSASDDASDAFAFHJWYG(PLY, true)
        cloakmeter[PLY] = 100
        timer.Remove("cloakregen"..PLY:SteamID64())
        timer.Remove("cloaklimit"..PLY:SteamID64())
    end
end)
-- ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||FUNCTIONS
-- ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||FUNCTIONS
-- ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||FUNCTIONS
-- ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||FUNCTIONS
hook.Add("PlayerDisconnected", "ExtraJarsky", function(ply) 
    if cloakedplayers[ply] then 
        playersincloak = playersincloak - 1 
        cloakedplayers[ply] = nil
    end
end)
hook.Add("PlayerSpawn", "cloakAIDS", function(ply)
    net.Start("updatecloaktimeclient")
    net.WriteInt(100,11)
    net.Send(ply) 
    cloakmeter[ply] = 100
    timer.Remove("cloakregen"..ply:SteamID64())
    timer.Remove("cloaklimit"..ply:SteamID64())
    if startcloaked:GetInt() == 1 then
        local reciveplayerinfo = ply:GetInfoNum("cloak_cl_spawn_ghosted", 69.666)
        if reciveplayerinfo == 1 then
            if starttimed:GetBool() then
                cloaktimed(ply ,starttime:GetInt() )
            else
                cloakuntimed(ply)
            end 
        end

    elseif startcloaked:GetInt() == 2 then
        if starttimed:GetBool() then
            cloaktimed(ply ,starttime:GetInt() )
        else
            cloakuntimed(ply)
        end
    end
end)
 function phantomsendbool(payler, bloole)--═══╗
    util.AddNetworkString( "screeneffects" )--║
    net.Start("screeneffects")              --║
        net.WriteBool(bloole)               --╟──> sends bool to player to initiallise Screenspace effects.
    net.Send(payler)                        --║  └─>player can turn this off by setting "sv_cloak_effects" to 0
end--═════════════════════════════════════════╝

function playercleardecals12313(addremove, entity, removeall)--═╗
    util.AddNetworkString("GhostClearPlayerDecals")           --║ 
    net.Start("GhostClearPlayerDecals")                       --║ 
        net.WriteBool(addremove)                              --║ 
        net.WriteEntity(entity)                               --╟──> this code is documented in the client section.
        net.WriteBool(removeall)                              --║  └─>use the third variable to completly wipe the table, i don't know why you'd want to do this, my logic is almost always correct.
    net.Broadcast()                                           --║
end--═══════════════════════════════════════════════════════════╝
local cloakweaponstates = {}
 function cloakweapon(plyt, reset)--════════════════════dictates player weapon switching behavior
    if  reset then
        ebrau = plyt:GetActiveWeapon()
        if (weaponcanswitch:GetInt() == 1) then
            plyt:SetActiveWeapon(NULL)
            cloakweaponstates[plyt] =  1-- player has null
        elseif (weaponcanswitch:GetInt() == 2) then
            if plyt:HasWeapon("weapon_physcannon")then 
                cloakweaponstates[plyt] =  3 --if player has the physcannon
            else
                plyt:Give("weapon_physcannon")
                cloakweaponstates[plyt] =  2 -- if not has physcannon
            end
            plyt:SetActiveWeapon(NULL)
            plyt:SelectWeapon("weapon_physcannon")
            local pisscannon = plyt:GetWeapon("weapon_physcannon") 
            pisscannon:AddEffects(32)
           
        else
            cloakweaponstates[plyt] = 4
        end
        if cloakvme:GetBool() and !(cloakweaponstates[plyt] == 1) then
            net.Start("viewmodel BS")
                net.WriteBool(true)
            net.Send(plyt)
        end
        if not (weaponcanswitch:GetInt() == 0) then
            hook.Add("PlayerSwitchWeapon", "effdotorg", function(ply, oldweap, newWeapon) --prevents all weapon switching
                if cloakedplayers[ply] then
                    if cloakweaponstates[ply] == 4 then
                        print("[PHANTOM]player is cloaked in wrong state! player is " .. ply:Nick().. "if you know how to replicate this bug please message the author.")
                    else
                        return true
                    end
                end
            end)
        else 
            hook.Add("PlayerPostThink", "efforg", function(ply)-- Makes worldmodel invisible
                if cloakweaponstates[ply] == 4 then
                    local dingle = ply:GetActiveWeapon()
                    if  !((dingle == NULL) or (dingle == nil)) then
                        dingle:AddEffects(32)
                    end
                end
            end)
        end
    else-- disable shit, yo
        if (cloakweaponstates[plyt] == 1) then--
            cloakweaponstates[plyt] = nil
            plyt:SelectWeapon(ebrau:GetClass())
        elseif(cloakweaponstates[plyt] == 2) then
            plyt:StripWeapon("weapon_physcannon")
            cloakweaponstates[plyt] = nil
            plyt:SelectWeapon(ebrau:GetClass())
        elseif(cloakweaponstates[plyt] == 3) then
            cloakweaponstates[plyt] = nil
            plyt:SelectWeapon(ebrau:GetClass())
        elseif(cloakweaponstates[plyt] == 4) then
            local dingle = plyt:GetActiveWeapon()
            if not ((dingle == NULL) or dingle == nil) then
                dingle:RemoveEffects(32)
            end
            cloakweaponstates[plyt] = nil
        elseif(cloakweaponstates[plyt] == nil) then
            print("[PHANTOM]" .. tostring(plyt).."Uncloaked without a weapon state... Suspicious...")
        end
        local bitchin = false
        for k,v in pairs( cloakweaponstates ) do
            if v != 4 then
                bitchin = true 
            end
        end
        if bitchin == false then 
            hook.Remove("PlayerSwitchWeapon", "effdotorg")
        end
        bitchin = false
        for k,v in pairs( cloakweaponstates ) do
            if v == 4 then
                bitchin = true 
            end
        end
        if bitchin == false then 
            hook.Remove("PlayerPostThink", "efforg")
        end
        if (playersincloak == 0) then
            hook.Remove("PlayerPostThink", "efforg")
            hook.Remove("PlayerSwitchWeapon", "effdotorg")
        end
        if !(cloakweaponstates[plyt] == 1) then
            net.Start("viewmodel BS")
                net.WriteBool(false)
            net.Send(plyt)
        end
    end
end 
local cloakattackallowed = {}
function cloakpreventattack(gaymurr, areaofeffect) --======= prevents attack for cloaked players
    if areaofeffect then
        if !(cloakcanattack:GetBool()) then
        cloakattackallowed[gaymurr] = true
        hook.Add("StartCommand","cloaknoattack", function(ply, cmd)
            if (cloakattackallowed[ply]) then 
                cmd:RemoveKey(IN_ATTACK )
                cmd:RemoveKey(IN_ATTACK2 )
            end
        end)
        net.Start("cloaknoattack")
            net.WriteBool(true)
        net.Send(gaymurr)
        end
    else
        if cloakattackallowed[gaymurr] then
            cloakattackallowed[gaymurr] = nil
            net.Start("cloaknoattack")
                net.WriteBool(false)
            net.Send(gaymurr)
            if table.IsEmpty(cloakattackallowed) then 
                hook.Remove("StartCommand","cloaknoattack")
            end
        end
    end
end
local cloakdamagestates = {}
function cloakdamage(gamer, enabele) --======================dictates what the player can damage
    if (enabele) then
        cloakdamagestates[gamer] = cloakcandamage:GetInt()
        if cloakdamagestates[gamer] == 0 then
            hook.Add("EntityTakeDamage", "cloak0", function(target, dmg)
                if cloakdamagestates[dmg:GetAttacker()] == 0 then
                    return true
                end
            end)
        elseif cloakdamagestates[gamer] == 1 then
            hook.Add("EntityTakeDamage", "cloak1", function(target, dmg)
                if cloakdamagestates[dmg:GetAttacker()] == 1 then
                    if not target:IsNPC() then
                    return true
                    end
                end
            end)
        elseif cloakdamagestates[gamer] == 2 then
            hook.Add("EntityTakeDamage", "cloak2", function(target, dmg)
                if cloakdamagestates[dmg:GetAttacker()] == 2 then
                    if not (target:IsNPC() or target:IsPlayer()) then
                    return true
                    end
                end
            end)
        elseif cloakdamagestates[gamer] == 3 then
            hook.Add("EntityTakeDamage", "cloak3", function(target, dmg)
                if cloakdamagestates[dmg:GetAttacker()] == 1 then
                    if not target:isplayer() then
                    return true
                    end
                end
            end)
        elseif cloakdamagestates[gamer] == 4 then
            hook.Add("EntityTakeDamage", "cloak4", function(target, dmg)
                if cloakdamagestates[dmg:GetAttacker()] == 2 then
                    if target:IsNPC() or target:IsPlayer() then
                        return true
                    end
                end
            end)
        elseif cloakdamagestates[gamer] == 5 then
            hook.Add("EntityTakeDamage", "cloak5", function(target, dmg)
                if cloakdamagestates[dmg:GetAttacker()] == 2 then
                    if target:IsPlayer() then
                        return true
                    end
                end
            end)
        elseif cloakdamagestates[gamer] == 6 then
            hook.Add("EntityTakeDamage", "cloak6", function(target, dmg)
                if cloakdamagestates[dmg:GetAttacker()] == 2 then
                    if target:IsNPC() then
                        return true
                    end
                end
            end)
        end
    else--Deactivates damage change
        
        if cloakdamagestates[gamer] == 0 then
            cloakdamagestates[gamer] = nil
            if not table.HasValue(cloakdamagestates,0) then
                hook.Remove("EntityTakeDamage", "cloak0")
            end
        elseif cloakdamagestates[gamer] == 1 then
            cloakdamagestates[gamer] = nil
            if not table.HasValue(cloakdamagestates,1) then
                hook.Remove("EntityTakeDamage", "cloak1")
            end
        elseif cloakdamagestates[gamer] == 2 then
            cloakdamagestates[gamer] = nil
            if not table.HasValue(cloakdamagestates,2) then
                hook.Remove("EntityTakeDamage", "cloak2")
            end
        elseif cloakdamagestates[gamer] == 3 then
            cloakdamagestates[gamer] = nil
            if not table.HasValue(cloakdamagestates,3) then
                hook.Remove("EntityTakeDamage", "cloak4")
            end
        elseif cloakdamagestates[gamer] == 4 then
            cloakdamagestates[gamer] = nil
            if not table.HasValue(cloakdamagestates,4) then
                hook.Remove("EntityTakeDamage", "cloak4")
            end
        elseif cloakdamagestates[gamer] == 5 then
            cloakdamagestates[gamer] = nil
            if not table.HasValue(cloakdamagestates,5) then
                hook.Remove("EntityTakeDamage", "cloak5")
            end
        elseif cloakdamagestates[gamer] == 6 then
            cloakdamagestates[gamer] = nil
            if not table.HasValue(cloakdamagestates,6) then
                hook.Remove("EntityTakeDamage", "cloak6")
            end
        elseif (cloakdamagestates[gamer] == 7) then
            cloakdamagestates[gamer] = nil
        end
    end
end


function entercloakeffects(ply)--=========================enter cloak
    local effectloc = ply:GetPos()
    if(cloaksmoke:GetBool()) then 
        if cloaksmokeF:GetBool() then
            timer.Create("you guys big drinkers up err?", 0,cloaksmokeD:GetInt(), function()
                ParticleEffect( "bigsmoke", ply:GetPos()+ Vector(0,0,10), Angle( 0, 0, 0 ) )
            end)
        else
            ParticleEffect( "smokepoof", effectloc+ Vector(0,0,30), Angle( 0, 0, 0 ) )
        end
    end
    local data = EffectData()
    data:SetOrigin(effectloc + Vector(0,0,30))
    if enterspark:GetBool() then
        util.Effect("cball_explode",data)
    end
    if cloakRingEn:GetBool() then
        effects.BeamRingPoint(effectloc + Vector(0,0,30), cloakRingEnT:GetFloat(), 0, cloakRingEnS:GetInt(), cloakRingExW:GetInt(), 0, Color(255,255,225,64),{
            speed=0,
            spread=0,
            delay=0,
            framerate=2,
            material="sprites/lgtning.vmt"
        })
    end
end
function exitcloakeffects(ply)--====================================exit cloak
    local effectloc = ply:GetPos()+ Vector(0,0,30)
    local data = EffectData()
    data:SetOrigin(effectloc)
    timer.Remove("you guys big drinkers up err?")
    if exitspark:GetBool() then
        util.Effect("cball_explode",data)
    end
    if cloakRingEx:GetBool() then
        effects.BeamRingPoint(effectloc, cloakRingExT:GetFloat(), cloakRingExS:GetInt(), 0, cloakRingExW:GetInt(), 0, Color(255,255,225,64),{
            speed=0,
            spread=0,
            delay=0,
            framerate=2,
            material="sprites/lgtning.vmt"
        })
    end
end
function cloakcloakerror(ply)--================================effects for when unable to cloak
    local effectloc = ply:GetPos()+ Vector(0,0,30)
    local data = EffectData()
    data:SetOrigin(effectloc)
    if errorspark:GetBool() then
        util.Effect("cball_bounce",data)
    end
    if errornoise:GetBool() then 
        ply:EmitSound("buttons/button10.wav", 50, 100,.25,1,0,0)
    end
end