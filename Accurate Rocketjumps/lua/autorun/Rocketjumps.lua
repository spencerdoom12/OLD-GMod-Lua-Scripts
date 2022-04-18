if CLIENT then return end
jjabrakkek = CreateConVar("sv_rj_enable" , 1 , 128, "Set this to 0 to disable rocketjumps. use sv_rj_apply to apply this setting")
rj_selfdamage = CreateConVar("sv_rj_overwrite_self", 0 , 128,"Overrides damage from your explosions. regardless of distance\n0 = default damage")
rj_damage = CreateConVar("sv_rj_overwrite_all", 0 , 128,"Overrides damage from all explosions, including other players's. regardless of distance\n0 = default damage")
rj_setdamage = CreateConVar("sv_rj_set_damage_mult", 0 , 12,"Set the damage to apply when damage override is on.")
rj_BM = CreateConVar("sv_rj_blastmult", 0.0195, 128, "Sets the force multiplier of explosions for players")
concommand.Add("sv_rj_apply", 
function(playerexecutecmd, cmd, args)
    foolishbooool()
end, nil, "enables/disables the addon on the fly!\nset to 0 to disable anything other than that is enabled.", 128)



function foolishbooool()
    if jjabrakkek:GetBool() then
        PrintMessage(3, "rocketjumps are enabled!")
        hook.Add("EntityTakeDamage", "HEEEBjjabbb", function (ply, dmginfo)
            if dmginfo:IsDamageType(64) and ply:IsPlayer() then -- if is explosion damage and entity taking damage is a player then do code.
                if(ply == dmginfo:GetAttacker() and rj_selfdamage:GetBool()) or rj_damage:GetBool() then --checks to make sure that cvars are on or if the attacker is the player
                    local dingo = dmginfo:GetDamageForce() * rj_BM:GetFloat()
                    local hooligan = rj_setdamage:GetFloat() * dmginfo:GetDamage()
                    dmginfo:SetDamage(hooligan)
                    dmginfo:SetDamageForce(dingo)
                    ply:SetVelocity(dingo)
                end
            end
        end)
    else
        hook.Remove("EntityTakeDamage", "HEEEBjjabbb")
        print("hook removed")
        PrintMessage(3, "rocketjumps are disabled!")
    end 
end
foolishbooool()
