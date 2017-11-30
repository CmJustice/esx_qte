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

ESX = nil
local clicked = false
local qteActive = false



Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

function headsUp(text)
	SetTextComponentFormat('STRING')
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

RegisterNetEvent('qte:clientClicked')
AddEventHandler('qte:clientClicked', function(arrow)

end)

RegisterNetEvent('qte:clientClickFailed')
AddEventHandler('qte:clientClickFailed', function(arrow)

end)


RegisterNetEvent('qte:clientWait')
AddEventHandler('qte:clientWait', function(arrow, time, succesCb, failCb)
	clicked = false
	SendNUIMessage({type='qte', button = arrow, timee = time})
	SetNuiFocus(true,true)
	local time2 = 0
	while clicked == false and time2 < time/10 do
		time2 = time2 + 1
		Wait(0)
	end
	if clicked then
		--TriggerEvent('qte:clientClicked', arrow)
		succesCb()
	else
		--TriggerEvent('qte:clientClickFailed', arrow)
		failCb()
	end
	SetNuiFocus(false)

end)



RegisterNetEvent('qte:start')
AddEventHandler('qte:start', function(buttons, gameDuration, qteDuration, animLib, animName, succesCb, failCb, finishCb)


	qteActive = true
	RequestAnimDict(animLib)
	while not HasAnimDictLoaded(animLib) do
		Wait(1)
	end
	local ped = GetPlayerPed(-1)
	TaskPlayAnim(ped, animLib, animName, 8.0, 1.0, -1, 1, 0, 0, 0, 0)
	--Dance Loop
	for i=1,gameDuration do
		if qteActive == false then
			break
		end
		if math.fmod(i, 200) == 0 then
			local rand = math.random(1, #buttons)

			TriggerEvent('qte:clientWait', buttons[rand], qteDuration, succesCb, failCb)

			qteDuration = qteDuration - 100
		end
		Wait(0)
	 end
	 if qteActive then
	 	ClearPedTasks(GetPlayerPed(-1))
	 	print('Qte Done!')
	 	finishCb()
	 	qteActive = false
	 end


end)





RegisterNUICallback('success', function()
	clicked = true
end)