hook.Add( "AddToolMenuCategories", "CustomCategory", function()
	spawnmenu.AddToolCategory( "Options", "Phantom", "#Phantom" )
end )

hook.Add( "PopulateToolMenu", "CustomMenuSettings", function()

        spawnmenu.AddToolMenuOption( "Options", "Phantom", "phantomopt", "#General Settings", "", "", function( panel )--SERVER OPTIONS
		panel:ClearControls()
		panel:Help("Only server operators can change these settings.")

		panel:NumSlider( "Obstruction behavior", "cloak_inside_prop_kill", 0, 2, 0 )
        panel:ControlHelp("Dictates what happens when you uncloak in a prop\n   ╔─ 0: Stuck in prop/no check\n   ╠─ 1: Die\n   ╚─ 2: unable to exit")

		panel:NumSlider("Obstruction Damage", "cloak_inside_prop_damage", 0, 200, 0)
		panel:ControlHelp("Dictates how much damage is taken when you uncloak in a prop while Obstruction behavior is 2")

		panel:NumSlider("Obstruction return", "cloak_inside_prop_give", 0, 200, 0)
		panel:ControlHelp("Dictates how much cloak meter is given back to you when you uncloak in a prop while Obstruction behavior is 2")


		panel:NumSlider("Cloak Transparency", "cloak_transparency", 0, 255, 0)
		panel:ControlHelp("Dictates how transparent you are in cloak mode.\n 0 is completely invisible, 255 is completely visible")

		panel:NumSlider("Untimed cloak perms","cloak_admin_perms", 0,2,0)
		panel:ControlHelp("Dictates who is allowed to use the untimed version of cloak. \n   ╔─ 0: Superadmins only\n   ╠─ 1: Admins + superadmins\n   ╚─ 2: everyone")

		panel:NumSlider("Timed cloak perms", "cloak_perms",0,2,0 )
		panel:ControlHelp("Dictates who is allowed to use the timed variation of cloak. \n   ╔─ 0: Superadmins only\n   ╠─ 1: Admins + superadmins\n   ╚─ 2: everyone")

		panel:NumSlider( "Swith weapons?", "cloak_switch_weapons", 0,2,0)
		panel:ControlHelp("Dictates wether player allowed to switch weapons while in cloak mode?\n   ╔─ 0: Weapon switch is allowed\n   ╠─ 1: No weapons\n   ╚─ 2: Gravity gun only")

		panel:NumSlider("Cloak collision type", "cloak_collide_type", 0 ,4,0)
		panel:ControlHelp("Dictaetes what the player is allowed to collide with.\n   ╔─ 0: Nothing\n   ╠─ 1: NPCs\n   ╠─ 2: NPCs + Players\n   ╠─ 3: Players\n   ╚─ 4: Everything, just cloak.\n   PLEASE NOTE! hitscan attacks are tied to what you can collide with, for some reason. THANKS VAAAALVE")

		panel:NumSlider("What can the cloak damage?", "cloak_can_damage", 0, 7,0)
		panel:ControlHelp("Dictates who/what the player is able to damage while in cloak mode\n   ╔─ 0: Nothing\n   ╠─ 1: NPCs\n   ╠─ 2: NPCs + Players\n   ╠─ 3: Players\n   ╠─ 4: Props\n   ╠─ 5: Props + NPCs\n   ╠─ 6: Props + Players\n   ╚─ 7: Everything")

		panel:CheckBox("Attack while cloaked?", "cloak_can_attack")
		panel:ControlHelp("Can the player attack while cloaked?")

		panel:TextEntry("Cloak material", "cloak_material")
		panel:ControlHelp("Default is models/wireframe\n sets the material of the cloaked player.\n enter \"\" to have no material.")
	end )
	spawnmenu.AddToolMenuOption( "Options", "Phantom", "plantomclopt", "#Client Settings", "", "", function( panel )--CLIENT OPTIONS
		panel:ClearControls()
		panel:CheckBox("Screen effects", "cloak_cl_screen_effects")
		panel:CheckBox("Spawn cloaked?", "cloak_cl_spawn_ghosted")
		panel:ControlHelp("If the server allows it, then you can use this to disable cloak on spawn.")

		panel:NumSlider("Screen effects intensity", "cloak_cl_screen_effects_intensity", 0, 100)
		panel:NumSlider( "Vmtp in cloak", "cloak_cl_vm_tp", 0, 255,0 )
		panel:ControlHelp("Viewmodel Transparency while cloaked.")

		panel:NumSlider( "Vmtp out of cloak", "cloak_cl_vm_tpo", 0, 255,0)
        panel:ControlHelp("In case you want a cool transparent weapon or something. This only updates after you exit cloak")

	end )
    spawnmenu.AddToolMenuOption( "Options", "Phantom", "phantomeffect", "#Effects Settings", "", "", function( panel )--EFFECTS OPTIONS
		panel:ClearControls()
		panel:Help("Only server operators can change these settings.")
		panel:CheckBox("Smoke effect","cloak_effects_smoke")
		panel:CheckBox("Smoke follows?","cloak_effects_smoke_follow")
		panel:NumSlider("Smoke duration","cloak_effects_smoke_duration", 1,1000,0)
		panel:CheckBox("Viewmodel effects","cloak_effects_viewmodel_Effects")
		panel:ControlHelp("Toggles viewmodel effects. This is not clientsided, it is for weapons that have skins break when this is applied.")
		panel:CheckBox("Enter cloak sparks","cloak_effects_enterspark")
		panel:CheckBox("Exit cloak sparks","cloak_effects_exitspark")
		panel:CheckBox("cloak error sparks","cloak_effects_errorspark")
		panel:CheckBox("cloak error noise", "cloak_effects_errornoise")
		panel:Help("Blast ring settings")
		panel:CheckBox("Enter ring effect","cloak_effects_enring")
		panel:CheckBox("Exit ring effect","cloak_effects_exring")
		panel:NumSlider("Enter ring time","cloak_effects_enring_time",0.01, 5, 2)
		panel:NumSlider("Exit ring time","cloak_effects_exring_time",0.01, 5, 2)
		panel:NumSlider("Enter ring size","cloak_effects_enring_size", 10, 1000, 0)
		panel:NumSlider("Exit ring size","cloak_effects_exring_size", 10, 1000, 0)
		panel:NumSlider("Enter ring width","cloak_effects_enring_width", 10, 100, 0)
		panel:NumSlider("Exit ring width","cloak_effects_exring_width", 10, 100, 0)
	end )
	spawnmenu.AddToolMenuOption("Options", "Phantom", "phantomtimersettings", "#Timed Cloak Settings", "", "", function( panel )
		panel:ClearControls()
		panel:Help("Only server operators can change these settings.")
		panel:NumSlider("Minimum Cloak", "cloak_timed_min", 0 ,99)
		panel:ControlHelp("The minimum ammount of energy required to initiate a cloak.\n def:95")

		panel:NumSlider("Energy decay rate","cloak_timed_decayrate", 0.01, 3)
		panel:ControlHelp("The rate at which energy depletes. Smaller numbers are faster.\n def:0.05")

		panel:NumSlider("Energy regen rate","cloak_timed_regenrate", 0.01, 3)
		panel:ControlHelp("The rate at which energy regenerates. Smaller numbers are faster.\n def:0.1")

		panel:NumSlider("Spawn cloaked?","cloak_spawn_cloaked",0,2,0)
		panel:ControlHelp("Dictates wether players spawn in cloak mode?\n   ╔─ 0: Players do not spawn cloaked\n   ╠─ 1: Players can choose wether they spawn cloaked.\n   ╚─ 2: All players spawn cloaked.")

		panel:CheckBox("Spawn cloaked time limit?","cloak_spawn_timed")
		panel:ControlHelp("When you spawn cloaked should there be a time limit?\n NOTE: Players can uncloak at any time, and they can not keep any cloak over 100.\n def:0")

		panel:NumSlider("Spawn cloaked energy","cloak_spawn_time",0,1000,0)
		panel:ControlHelp("How long players are cloaked for when they spwan. Max cloak charge is 100, but you can set it higher and it won't cause any problems unless you cause an integer overflow.\n def:150")
	end)
end )


--[[
		panel:NumSlider("",""0,2,0)
		panel:ControlHelp("Description\n   ╔─ 0: .\n   ╠─ 1: .\n   ╚─ 2: .")	
--]]