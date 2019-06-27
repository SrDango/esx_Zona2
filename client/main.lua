local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}
local Accion = nil
local Mensaje = ''
local Dato = {}

ESX = nil
--Para traer el "player/object"
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	ESX.PlayerData = ESX.GetPlayerData()
end)


--Funcion para abrir el menu
function AbrirMenu()
    local opcis ={
        {label = _U('label1'),value = 'opcion1'},
        {label = _U('label2'),value = 'opcion2'},
        {label = _U('label3'),value = 'opcion3'}
    }
    local opcisSub ={
        {label = _U('label1s'),value = 'opcion1s'},
        {label = _U('label2s'),value = 'opcion2s'},
        {label = _U('label3s'),value = 'opcion3s'}
    }
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default',GetCurrentResourceName() ,'MenuPrincipal',
    {
       title = 'Titulo del Menu',
       align = 'bottom-right',
       elements = opcis

    },function(data,menu)

        if data.current.value == 'opcion1' then
        ESX.UI.Menu.Open('default',GetCurrentResourceName() ,'SubMenu',
    {
       title = 'SubMenu',
       align = 'bottom-right',
       elements = opcisSub

    }   ,function(data,menu)
            if data.current.value == 'opcion1s' then
            ESX.ShowNotification(_U('ac1s'))
            elseif data.current.value == 'opcion2s' then
                ESX.ShowNotification(_U('ac2s'))
            elseif data.current.value == 'opcion3' then
            ESX.ShowNotification(_U('ac3s'))
            end
        end,function(data,menu)
         menu.close()
        end)
        elseif data.current.value == 'opcion2' then
            ESX.ShowNotification(_U('ac2'))
        elseif data.current.value == 'opcion3' then
            ESX.ShowNotification(_U('ac3'))
        end



    
    end,function(data,menu)
    menu.close()

        Accion = 'menuPrincipal'
        Mensaje = _U('mensaje')
        Dato = {}
    end)
end


function AbrirMenu2()
    local opcis ={
        {label = _U('label1v'),value = 'opcion1v'},
        {label = _U('label2v'),value = 'opcion2v'},
        {label = _U('label3v'),value = 'opcion3v'}
    }
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default',GetCurrentResourceName() ,'MenuPrincipal2',
    {
       title = 'Segundo Menu',
       align = 'bottom-right',
       elements = opcis

    },function(data,menu)

        if data.current.value == 'opcion1v' then
            ESX.ShowNotification(_U('ac1'))
        elseif data.current.value == 'opcion2v' then
            ESX.ShowNotification(_U('ac2'))
        elseif data.current.value == 'opcion3v' then
            ESX.ShowNotification(_U('ac3'))
        end



    
    end,function(data,menu)
    menu.close()

        Accion = 'MenuPrincipal2'
        Mensaje = _U('mensaje')
        Dato = {}
    end)
end

--Evento de entrar en una Zona
AddEventHandler('esx_Zona:entrando',function(zone)
    if zone == 'Zona1' then
        Accion = 'menuPrincipal'
        Mensaje = _U('mensaje')
        Dato = {}
    elseif zone == "Zona2" then
        Accion = 'MenuPrincipal2'
        Mensaje = _U('mensaje')
        Dato = {}
    end


end)
--Evento de salir de la zona
AddEventHandler('esx_Zona:saliendo',function(zone)
    ESX.UI.Menu.CloseAll()
    Accion = nil
end)

--¿Esta dentro?
local HasAlreadyEnteredMarker   = false
local LastZone                  = nil
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
			--GetPlayerPed(-1)==PlayerPedId
			local coords = GetEntityCoords(PlayerPedId())
			local isInMarker, currentZone = false

			for k,v in pairs(Config.Zones) do
				local distance = GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true)

				if v.Type ~= -1 and distance < Config.DrawDistance then
					DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, false, 2, v.Rotate, nil, nil, false)
				end

				if distance < v.Size.x then
					isInMarker, currentZone = true, k
				end
			end

			if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
				HasAlreadyEnteredMarker, LastZone = true, currentZone
				TriggerEvent('esx_Zona:entrando', currentZone)
			end

			if not isInMarker and HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = false
				TriggerEvent('esx_Zona:saliendo', LastZone)
			end

	end
end)
--------------------------
--Si quereis que al llegar a una zona  no salga un menu y 
--solo se ejecute una accion, ponerla en una funcion.

--[[
function FUNCION()
    ACTO
end
]]--





--Controlar las teclas
Citizen.CreateThread(function()
    while true do

        Citizen.Wait(0)

        if Accion then
            ESX.ShowHelpNotification(Mensaje)

            if IsControlJustPressed(0, Keys['E'])then
                if Accion == 'menuPrincipal' then
                    AbrirMenu()
                elseif Accion == 'MenuPrincipal2' then
                --    AbrirMenu2()
                --FUNCION()     
                end

                Accion = nil

        end

        end
    end
end)
