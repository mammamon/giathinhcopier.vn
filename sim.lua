--[[
    SCBI LibreScript - A script for SimCity BuildIt
    Copyright (C) 2026

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
]]

local defaultPath = "/storage/emulated/0/Download/LibreScript.txt"

local function shouldSkipMenu()
	local f = io.open(defaultPath, "r")
	if f then
		local content = f:read("*a")
		f:close()
		if content == "FFF" then
			return true
		else
			local expiryTimestamp = tonumber(content)
			if expiryTimestamp and os.time() < expiryTimestamp then
				return true
			end
		end
	end
	return false
end

local function saveSkipChoice()
	local input = gg.prompt({
		"Enter the path to save your choice:",
		"For how many days should this message not appear? (Type FFF for forever)",
	}, { defaultPath, "FFF" }, { "text", "text" })

	local path, days = defaultPath, "FFF"
	if input then
		path = input[1] or defaultPath
		days = input[2] or "FFF"
	end

	local saveValue = ""
	if days:upper() == "FFF" then
		saveValue = "FFF"
	else
		local numDays = tonumber(days)
		if numDays then
			saveValue = tostring(os.time() + (numDays * 24 * 60 * 60))
		else
			saveValue = "FFF"
		end
	end

	local f = io.open(path, "w")
	if f then
		f:write(saveValue)
		f:close()
	end

	gg.toast("✅ Choice saved!")
end

if not shouldSkipMenu() then
	local opt = gg.alert(
		[[
⚠️ 64-BITS SCRIPT ONLY
For more updates, join discord server

🔗 https://discord.gg/NUfNCUSJBB


  ]],
		"🚫 Don't show this again",
		"▶️ Continue to Script"
	)

	if opt == 1 then
		saveSkipChoice()
	elseif opt == 2 then
		gg.toast("🚀 Proceeding with the script...")
	else
		os.exit()
	end
end

function boostEditor()
	local boosts = {
		["Pump"] = { 1965976282, 1965976283, 1965976284 },
		["Umbrella"] = { 1587235432, 1587235433, 1587235434 },
		["Dud"] = { 91798751, 91798752, 91798753 },
		["Vampire"] = { 1736317036, 1736317037, 1736317038 },
		["Freeze"] = { 924894801, 924894802, 924894803 },
		["Jackpot"] = { 1692935226, 1692935227, 1692935228 },
		["Energy Thief"] = { 1147903624, 1147903625 },
	}

	local combinations = {
		{ item = "🔩 Metal", validationIndex = 267176888, boost = "Pump" },
		{ item = "🪵 Wood", validationIndex = 2090874750, boost = "Umbrella" },
		{ item = "💳 Plastic", validationIndex = -1270634091, boost = "Dud" },
		{ item = "🌱 Seeds", validationIndex = 274276185, boost = "Vampire" },
		{ item = "💎 Minerals", validationIndex = -1369888960, boost = "Freeze" },
		{ item = "🧪 Chemicals", validationIndex = 1570439054, boost = "Jackpot" },
		{ item = "🧵 Textiles", validationIndex = 144394935, boost = "Energy Thief" },
	}

	local function selectLevel()
		while true do
			local opcao =
				gg.choice({ "Level I", "Level II", "Level III", "🔙 Back" }, nil, "🔋 Select boost level:")
			if opcao == nil then
				gg.setVisible(false)
				while not gg.isVisible() do
					gg.sleep(100)
				end
			elseif opcao == 4 then
				return nil
			else
				return opcao
			end
		end
	end

	local function selectCombinations(level)
		while true do
			local comboList = {}
			for _, combo in ipairs(combinations) do
				if combo.boost ~= "Energy Thief" or level < 3 then
					table.insert(comboList, combo.item .. " --> " .. combo.boost)
				end
			end
			table.insert(comboList, "🔙 Back")
			local selected = gg.multiChoice(
				comboList,
				nil,
				"⚠️ Do NOT make more than 280 pieces at once!\nSelect the boosts to apply:"
			)
			if selected == nil then
				gg.setVisible(false)
				while not gg.isVisible() do
					gg.sleep(100)
				end
			elseif selected[#comboList] then
				return nil
			else
				local result = {}
				local j = 1
				for i = 1, #combinations do
					if combinations[i].boost ~= "Energy Thief" or level < 3 then
						if selected[j] then
							table.insert(result, combinations[i])
						end
						j = j + 1
					end
				end
				return result
			end
		end
	end

	local function applyBoosts(level, selectedCombos)
		gg.setRanges(gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS | gg.REGION_OTHER)
		for _, combo in ipairs(selectedCombos) do
			local index = combo.validationIndex
			local newID = boosts[combo.boost][level]
			gg.clearResults()
			gg.setVisible(false)
			gg.searchNumber(index, gg.TYPE_DWORD)
			gg.setVisible(false)
			local results = gg.getResults(100000)
			if #results == 0 then
				gg.toast("❌ Not found: " .. combo.item)
			else
				for i = 1, #results do
					results[i].value = newID
					results[i].flags = gg.TYPE_DWORD
				end
				gg.setValues(results)
				gg.toast("✔️ " .. combo.item .. " → ID " .. newID)
			end
		end
	end

	local level = selectLevel()
	if not level then
		return
	end

	local selectedCombos = selectCombinations(level)
	if not selectedCombos or #selectedCombos == 0 then
		return
	end

	applyBoosts(level, selectedCombos)
	gg.alert("Restart the game")
end

function Population()
	gg.setRanges(gg.REGION_C_ALLOC | gg.REGION_OTHER | gg.REGION_ANONYMOUS)
	gg.clearResults()
	gg.setVisible(false)
	gg.searchNumber("-1937242619", gg.TYPE_DWORD)
	local initialAnchors = gg.getResults(gg.getResultsCount())
	if #initialAnchors == 0 then
		gg.toast("Initial anchor not found.")
		return
	end

	local offsetResults = {}
	for i = 1, #initialAnchors do
		offsetResults[i] = { address = initialAnchors[i].address - 0x48, flags = gg.TYPE_DWORD }
	end
	offsetResults = gg.getValues(offsetResults)

	local smallestItem = nil
	for i = 1, #offsetResults do
		if offsetResults[i].value ~= 0 then
			if smallestItem == nil or offsetResults[i].value < smallestItem.value then
				smallestItem = offsetResults[i]
			end
		end
	end

	if not smallestItem then
		gg.toast("No valid offset value found.")
		return
	end

	local keyToSearch = gg.getValues({ { address = smallestItem.address - 0x8, flags = gg.TYPE_DWORD } })[1].value

	gg.clearResults()
	gg.searchNumber(keyToSearch, gg.TYPE_DWORD)
	local finalBases = gg.getResults(gg.getResultsCount())
	if #finalBases == 0 then
		gg.toast("Could not find population addresses.")
		return
	end

	local input = gg.prompt({ "How much population do you want?" }, nil, { "number" })
	if not input or not input[1] then
		gg.toast("Operation cancelled.")
		return
	end
	local desiredPopulation = tonumber(input[1])

	local edits = {}
	for i = 1, #finalBases do
		table.insert(edits, {
			address = finalBases[i].address + 0x9C,
			flags = gg.TYPE_DWORD,
			value = desiredPopulation,
		})
	end
	gg.setValues(edits)

	gg.toast("Population set to " .. desiredPopulation)
	gg.clearResults()
end

function warcards()
	gg.clearResults()
	gg.clearList()

	local warCards = {
		{ name = "📘 Comic Hand", value = 1430583743 },
		{ name = "🔬 Shrink Ray", value = 1430583746 },
		{ name = "🐙 Tentacle Vortex", value = 1430583748 },
		{ name = "🧲 Magnetism", value = 1430583749 },
		{ name = "🌪️ Not in Kansas", value = 1430583747 },
		{ name = "🗿 Giant Rock Monster", value = -35376651 },
		{ name = "🤖 Vu Robot", value = -35376655 },
		{ name = "🪩 Disco Twister", value = -35376689 },
		{ name = "🌿 Plant Monster", value = -35376688 },
		{ name = "❄️ Blizzaster", value = 1430583750 },
		{ name = "🐟 Fishaster", value = -35376685 },
		{ name = "🏺 Ancient Curse", value = -35376684 },
		{ name = "🖐️ Hands of Doom", value = 1430583751 },
		{ name = "⚖️ 16 Tons", value = -35376683 },
		{ name = "🕷️ Spiders", value = -35376680 },
		{ name = "🩰 Dance Shoes", value = -35376687 },
		{ name = "🚪 Building Portal", value = -35376681 },
		{ name = "🐍 Hissy Fit", value = -35376648 },
		{ name = "🎺 Mellow Bellow", value = -35376647 },
		{ name = "🦆 Doomsday Quack", value = -35376650 },
		{ name = "⚡ Electric Deity", value = -35376649 },
		{ name = "🛸 Zest From Above", value = -35376622 },
		{ name = "🛡️ Shield Buster", value = -35376623 },
		{ name = "🎬 B Movie Monster", value = -35376654 },
	}

	local factoryItems = {
		{ name = "🔩 Metal", validationIndex = 267176888 },
		{ name = "🪵 Wood", validationIndex = 2090874750 },
		{ name = "💳 Plastic", validationIndex = -1270634091 },
		{ name = "🌱 Seeds", validationIndex = 274276185 },
		{ name = "💎 Minerals", validationIndex = -1369888960 },
		{ name = "🧪 Chemicals", validationIndex = 1570439054 },
		{ name = "🧵 Textiles", validationIndex = 144394935 },
		{ name = "🍬 Sugar and Spices", validationIndex = 1807545838 },
		{ name = "🔎 Glass", validationIndex = 260292831 },
		{ name = "🥫 Animal Feed", validationIndex = 1658060491 },
		{ name = "🔌 Electrical Components", validationIndex = -181617693 },
	}

	while true do
		local warCardMenuNames = { "🔙 Back" }
		for _, card in ipairs(warCards) do
			table.insert(warCardMenuNames, card.name)
		end

		local warCardChoice = gg.choice(warCardMenuNames, nil, "Which card do you want to get?")

		if warCardChoice == nil then
			gg.setVisible(false)
			while not gg.isVisible() do
				gg.sleep(100)
			end
		elseif warCardChoice == 1 then
			return menup()
		else
			local selectedValue = warCards[warCardChoice - 1].value

			while true do
				local factoryItemMenuNames = { "🔙 Back" }
				for _, item in ipairs(factoryItems) do
					table.insert(factoryItemMenuNames, item.name)
				end

				local factoryItemChoice = gg.choice(factoryItemMenuNames, nil, "Which factory item to replace?")

				if factoryItemChoice == nil then
					gg.setVisible(false)
					while not gg.isVisible() do
						gg.sleep(100)
					end
				elseif factoryItemChoice == 1 then
					break
				else
					local validationValue = factoryItems[factoryItemChoice - 1].validationIndex

					gg.clearResults()
					gg.setRanges(gg.REGION_ANONYMOUS | gg.REGION_C_ALLOC | gg.REGION_OTHER)
					gg.setVisible(false)
					gg.searchNumber(validationValue, gg.TYPE_DWORD)
					gg.setVisible(false)
					local results = gg.getResults(gg.getResultsCount())

					if #results == 0 then
						gg.toast("Validation index not found.")
						break
					end

					for i = 1, #results do
						results[i].value = selectedValue
						results[i].flags = gg.TYPE_DWORD
					end

					gg.setValues(results)
					gg.alert("Restart the game")
					gg.clearResults()
					gg.clearList()
					return
				end
			end
		end
	end
end

validCellValues = {
	[1200] = true,
	[14500] = true,
	[42000] = true,
	[97000] = true,
}

local CONFIG = {
	{ name = "🪙 Simoleons", offsets = { 0x08, 0x0C, 0x10, 0x14 }, active = false },
	{ name = "💵 SimCash", offsets = { 0x20, 0x24, 0x28, 0x2C }, active = false },
	{ name = "🔑 Golden Keys", offsets = { 0x38, 0x3C, 0x40, 0x44 }, active = false },
	{ name = "🎟️ Golden Tickets", offsets = { 0x50, 0x54, 0x58, 0x5C }, active = false },
	{ name = "🗝️ Platinum Keys", offsets = { 0x68, 0x6C, 0x70, 0x74 }, active = false },
	{ name = "Ⓜ️ NeoSimoleons", offsets = { 0x80, 0x84, 0x88, 0x8C }, active = false },
}

local baseAddress = nil

function findPointerBase()
	gg.setVisible(false)
	gg.clearResults()
	gg.setRanges(gg.REGION_C_ALLOC | gg.REGION_C_DATA | gg.REGION_CODE_APP | gg.REGION_OTHER | gg.REGION_ANONYMOUS)
	gg.searchNumber("1729378197378015232", gg.TYPE_QWORD)

	local count = gg.getResultsCount()
	if count == 0 then
		gg.alert("❌ QWORD not found.")
		return false
	end

	local initialResults = gg.getResults(count)
	gg.clearResults()

	local possiblePointers1 = {}
	for i, v in ipairs(initialResults) do
		gg.searchNumber(string.format("%Xh", v.address), gg.TYPE_QWORD)
		local res = gg.getResults(gg.getResultsCount())
		for _, p in ipairs(res) do
			table.insert(possiblePointers1, p)
		end
		gg.clearResults()
	end

	if #possiblePointers1 == 0 then
		gg.alert("❌ No Level 1 pointers found.")
		return false
	end

	local finalBases = {}
	for i, v in ipairs(possiblePointers1) do
		gg.searchNumber(string.format("%Xh", v.address), gg.TYPE_QWORD)
		local res = gg.getResults(gg.getResultsCount())
		for _, p in ipairs(res) do
			table.insert(finalBases, p)
		end
		gg.clearResults()
	end

	if #finalBases == 0 then
		gg.alert("❌ No Level 2 pointers found.")
		return false
	end

	baseAddress = finalBases[1].address
	return true
end

function updateFrozenValues()
	gg.clearList()
	local listToFreeze = {}
	local hasActive = false

	for _, category in ipairs(CONFIG) do
		if category.active then
			hasActive = true
			for _, offset in ipairs(category.offsets) do
				local addr = baseAddress + offset
				table.insert(listToFreeze, {
					address = addr,
					flags = gg.TYPE_DWORD,
				})
			end
		end
	end

	if hasActive then
		listToFreeze = gg.getValues(listToFreeze)

		for i, item in ipairs(listToFreeze) do
			item.freeze = true
			item.name = "Frozen Currency"
		end

		gg.addListItems(listToFreeze)
	end
end

function currencymenu()
	if baseAddress == nil then
		if not findPointerBase() then
			return
		end
	end

	while true do
		gg.clearResults()
		local options = {
			"🔙 Back",
		}

		for i, cat in ipairs(CONFIG) do
			local statusEmoji = cat.active and "🟢 " or "🔴 "
			table.insert(options, cat.name .. " | " .. statusEmoji)
		end

		local choice = gg.choice(options, nil, "🚨 Currency Freeze Menu")

		if choice == nil then
			gg.setVisible(false)
			while not gg.isVisible() do
				gg.sleep(100)
			end
		elseif choice == 1 then
			return
		else
			local index = choice - 1
			if CONFIG[index] then
				CONFIG[index].active = not CONFIG[index].active
				updateFrozenValues()
			end
		end
	end
end

local cellData = {
	[1] = { name = "Cell 1 (10 Rewards)", rewardCount = 10 },
	[2] = { name = "Cell 2 (10 Rewards)", rewardCount = 10 },
	[3] = { name = "Cell 3 (10 Rewards)", rewardCount = 10 },
	[4] = { name = "Cell 4 (10 Rewards)", rewardCount = 10 },
}

local currencyData = {
	rail_tokens = {
		name = "🚆 Rail Tokens",
		isSpecial = false,
		hexCodes = { 0x69615212, 0x6B6F546c, 0x00006E65, 0x00000000, 0x00000000, 0x00000000 },
		prompt = "How many Rail Tokens do you want?",
	},
	golden_keys = {
		name = "🔑 Golden Keys",
		isSpecial = false,
		hexCodes = { 0x79656B08, 0x00000073, 0x00000000, 0x00000000, 0x00000000, 0x00000000 },
		prompt = "How many Golden Keys do you want?",
	},
	platinum_keys = {
		name = "🗝️ Platinum Keys",
		isSpecial = false,
		hexCodes = { 0x616C7010, 0x756E6974, 0x0000006D, 0x00000000, 0x00000000, 0x00000000 },
		prompt = "How many Platinum Keys do you want?",
	},
	simoleons = {
		name = "🪙 Simoleons",
		isSpecial = false,
		hexCodes = { 0x6D697312, 0x6F656C6F, 0x0000736E, 0x00000000, 0x00000000, 0x00000000 },
		prompt = "How many Simoleons do you want?",
	},
	neosimoleons = {
		name = "🌐 Neosimoleons",
		isSpecial = false,
		hexCodes = { 0x6F656E0E, 0x736D6973, 0x00000000, 0x00000000, 0x00000000, 0x00000000 },
		prompt = "How many Neosimoleons do you want?",
	},
	simcash = {
		name = "💵 SimCash",
		isSpecial = false,
		hexCodes = { 0x6D69730E, 0x68736163, 0x00000000, 0x00000000, 0x00000000, 0x00000000 },
		prompt = "How many SimCash do you want?",
	},
	blueprints = {
		name = "📘 Blueprint Design",
		isSpecial = true,
		hexCodes = {
			block1 = { 0x6D616320, 0x67696170, 0x7275636E, 0x636E6572, 0x00000079, 0x00000000 },
			block2 = { 0x035343406, 0x00000000, 0x6E686F4A, 0x6E61485F, 0x00545F63, 0x00000000 },
		},
		prompt = "How many Blueprints do you want?",
	},
	war_simoleons = {
		name = "⚔️ War Simoleons",
		isSpecial = false,
		hexCodes = { 0x7261770E, 0x736D6973, 0x00000000, 0x00000000, 0x00000000, 0x00000000 },
		prompt = "How many War Simoleons do you want?",
	},
	golden_ticket = {
		name = "🎟️ Golden Ticket",
		isSpecial = true,
		hexCodes = {
			block1 = { 0x65746908, 0x0000006D, 0x00000000, 0x00000000, 0x00000000, 0x00000000 },
			block2 = { 0x6C6F4718, 0x546E6564, 0x656B6369, 0x00000074, 0x00000000, 0x00000000 },
		},
		prompt = "How many Golden Tickets do you want?",
	},
	random_regional = {
		name = "❓ Random Regional",
		isSpecial = false,
		hexCodes = { 0x6765721E, 0x616E6F69, 0x61725F6C, 0x6D6F646E, 0x00000000, 0x00000000 },
		prompt = "How many Random Regional do you want?",
	},
	train_sims = {
		name = "🚂 Train Sims",
		isSpecial = false,
		hexCodes = { 0x61727412, 0x69736E69, 0x0000736D, 0x00000000, 0x00000000 },
		prompt = "How many Train Sims do you want?",
	},
	monaco_ticket = {
		name = "✨ Seasonal Coins",
		isSpecial = true,
		hexCodes = {
			block1 = { 0x6D616320, 0x67696170, 0x7275636E, 0x636E6572, 0x00000079, 0x00000000 },
			block2 = {},
		},
		prompt = "How many Seasonal Coins do you want?",
	},
}

local currencyDisplayOrder = {
	"simcash",
	"simoleons",
	"neosimoleons",
	"war_simoleons",
	"golden_keys",
	"platinum_keys",
	"rail_tokens",
	"train_sims",
	"blueprints",
	"golden_ticket",
	"random_regional",
	"monaco_ticket",
}

local cachedBaseAddresses = nil

local function findAllCellBases()
	gg.setVisible(false)
	gg.toast("Searching for Vu Pass cell bases...")
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS | gg.REGION_C_ALLOC | gg.REGION_OTHER)
	gg.searchNumber("8319099934827697938", gg.TYPE_QWORD)

	local results = gg.getResults(100)
	if #results == 0 then
		gg.setVisible(true)
		return nil
	end

	for _, r in ipairs(results) do
		local ptrAddr = r.address + 0x18
		local ptrValResult = gg.getValues({ { address = ptrAddr, flags = gg.TYPE_QWORD } })
		if ptrValResult and ptrValResult[1].value and ptrValResult[1].value ~= 0 then
			local ptrVal = ptrValResult[1].value
			local val180Result = gg.getValues({ { address = ptrVal + 0x180, flags = gg.TYPE_DWORD } })
			if val180Result and val180Result[1].value == 1145656354 then
				local pointer1_addr = val180Result[1].address - 0xF8
				local pointer1Result = gg.getValues({ { address = pointer1_addr, flags = gg.TYPE_QWORD } })
				if pointer1Result and pointer1Result[1].value and pointer1Result[1].value ~= 0 then
					local pointer1 = pointer1Result[1].value

					local baseAddresses, offsets = {}, { 0x00, 0x18, 0x30, 0x48 }

					local pointers_to_read = {}
					for _, offset in ipairs(offsets) do
						table.insert(pointers_to_read, { address = pointer1 + offset, flags = gg.TYPE_QWORD })
					end
					local cellPointers = gg.getValues(pointers_to_read)

					for _, cellPtrInfo in ipairs(cellPointers) do
						local cellPointer = cellPtrInfo.value

						if cellPointer and cellPointer ~= 0 then
							local validationResult =
								gg.getValues({ { address = cellPointer + 0xC, flags = gg.TYPE_DWORD } })

							if
								validationResult
								and validationResult[1].value
								and validCellValues[validationResult[1].value]
							then
								table.insert(baseAddresses, cellPointer + 0x30)
							end
						end
					end

					if #baseAddresses == 4 then
						gg.setVisible(true)
						gg.toast("✅ All 4 cell bases found and cached.")
						return baseAddresses
					end
				end
			end
		end
	end

	gg.setVisible(true)
	return nil
end

local function applyRewardsToCell(baseAddress, cellInfo, selectedCurrencyKeys, amounts)
	gg.clearList()
	gg.toast("Processing " .. cellInfo.name .. "...")

	local current = gg.getValues({
		{ address = baseAddress, flags = gg.TYPE_DWORD },
		{ address = baseAddress - 0x8, flags = gg.TYPE_DWORD },
		{ address = baseAddress - 0x10, flags = gg.TYPE_DWORD },
	})

	local accumulated = {}

	for i = 1, cellInfo.rewardCount do
		for _, v in ipairs(current) do
			table.insert(accumulated, v)
		end

		if i < cellInfo.rewardCount then
			local nextBatch = {}
			for _, v in ipairs(current) do
				table.insert(nextBatch, { address = v.address + 0xA0, flags = gg.TYPE_DWORD })
			end
			current = gg.getValues(nextBatch)
		end
	end

	gg.addListItems(accumulated)
	local list = gg.getListItems()

	local pointersToRead = {}
	for i = 1, #list, 3 do
		table.insert(pointersToRead, { address = list[i].address, flags = gg.TYPE_QWORD })
		table.insert(pointersToRead, { address = list[i + 1].address, flags = gg.TYPE_QWORD })
	end

	if #pointersToRead == 0 then
		return
	end
	local resolvedPointers = gg.getValues(pointersToRead)
	local allEdits, pointer_idx = {}, 1

	for i = 1, #list, 3 do
		local reward_counter = ((i - 1) / 3) + 1
		local currency_cycle_index = ((reward_counter - 1) % #selectedCurrencyKeys) + 1
		local currentKey = selectedCurrencyKeys[currency_cycle_index]
		local currency = currencyData[currentKey]
		local ptr1, ptr2 = resolvedPointers[pointer_idx].value, resolvedPointers[pointer_idx + 1].value
		pointer_idx = pointer_idx + 2

		if currency.isSpecial then
			if ptr1 and ptr1 ~= 0 and ptr2 and ptr2 ~= 0 then
				for j = 1, 6 do
					table.insert(
						allEdits,
						{ address = ptr1 + (j - 1) * 4, flags = gg.TYPE_DWORD, value = currency.hexCodes.block1[j] }
					)
					table.insert(
						allEdits,
						{ address = ptr2 + (j - 1) * 4, flags = gg.TYPE_DWORD, value = currency.hexCodes.block2[j] }
					)
				end
				table.insert(
					allEdits,
					{ address = list[i + 2].address, flags = gg.TYPE_DWORD, value = amounts[currentKey] }
				)
				table.insert(allEdits, { address = list[i + 2].address + 0x38, flags = gg.TYPE_DWORD, value = 0 })
			end
		else
			if ptr1 and ptr1 ~= 0 then
				for j, hex in ipairs(currency.hexCodes) do
					table.insert(allEdits, { address = ptr1 + (j - 1) * 4, flags = gg.TYPE_DWORD, value = hex })
				end
				table.insert(
					allEdits,
					{ address = list[i + 2].address, flags = gg.TYPE_DWORD, value = amounts[currentKey] }
				)
				table.insert(allEdits, { address = list[i + 2].address + 0x38, flags = gg.TYPE_DWORD, value = 0 })
			end
		end
	end
	if #allEdits > 0 then
		gg.setValues(allEdits)
	end
end

function mainMenuO()
	if not cachedBaseAddresses then
		cachedBaseAddresses = findAllCellBases()
		if not cachedBaseAddresses then
			gg.alert("❌ Failed to find cell bases. Cannot proceed.")
			return
		end
	else
		gg.toast("Using cached cell base addresses.")
	end

	while true do
		local menuItems, multiMenuKeys = { "♻️ Revert Changes", "🔙 Back" }, {}
		for _, key in ipairs(currencyDisplayOrder) do
			if currencyData[key] then
				table.insert(menuItems, currencyData[key].name)
				table.insert(multiMenuKeys, key)
			end
		end

		local selection = gg.multiChoice(menuItems, nil, "Select currencies (Max 10):")

		if selection == nil then
			gg.setVisible(false)
			while not gg.isVisible() do
				gg.sleep(100)
			end
		elseif selection[2] then
			return
		elseif selection[1] then
			gg.alert("To revert changes, visit the war map and return, or visit another city and come back.")
		else
			local chosenKeys = {}
			for index, checked in pairs(selection) do
				if checked and index >= 3 then
					table.insert(chosenKeys, multiMenuKeys[index - 2])
				end
			end

			if #chosenKeys == 0 then
				gg.toast("No currencies selected.")
			elseif #chosenKeys > 10 then
				gg.alert("❌ You cannot select more than 10 currencies because each cell only has 10 rewards.")
			else
				local amounts, promptData, defaultValues, inputTypes = {}, {}, {}, {}
				for _, key in ipairs(chosenKeys) do
					table.insert(promptData, currencyData[key].prompt)
					table.insert(defaultValues, "1")
					table.insert(inputTypes, "number")
				end

				local inputs = gg.prompt(promptData, defaultValues, inputTypes)
				if inputs == nil then
					gg.setVisible(false)
					while not gg.isVisible() do
						gg.sleep(100)
					end
				else
					local allValid = true
					for i, key in ipairs(chosenKeys) do
						local amount = tonumber(inputs[i])
						if not amount or amount < 0 then
							gg.alert("Invalid amount for " .. currencyData[key].name .. ". Aborting.")
							allValid = false
							break
						end
						amounts[key] = amount

						if key == "blueprints" then
							local blueprintInput = gg.prompt(
								{ "Enter blueprint code (max 3 digits):" },
								{ "449" },
								{ "number" }
							)
							if blueprintInput == nil then
								gg.toast("Canceled.")
								allValid = false
								break
							end

							local code = tostring(blueprintInput[1])
							if #code ~= 3 then
								gg.alert("❌ Invalid, insert exactly 3 digits.")
								allValid = false
								break
							end

							local reversed = string.reverse(code)
							local newHex = string.format(
								"0x03%s3%s3%s06",
								reversed:sub(1, 1) or "0",
								reversed:sub(2, 2) or "0",
								reversed:sub(3, 3) or "0"
							)
							currencyData.blueprints.hexCodes.block2[1] = tonumber(newHex)
						end
					end

					if allValid then
						local cellMenu = {}
						local cellMap = {}

						for i = 1, #cellData do
							table.insert(cellMenu, cellData[i].name)
							table.insert(cellMap, i)
						end

						table.insert(cellMenu, "✔️ All Cells")
						table.insert(cellMenu, "🔙 Back to currency selection")

						local cellChoice = gg.choice(cellMenu, nil, "Select which cell to apply rewards to:")

						if cellChoice == nil or cellChoice == #cellMenu then
						elseif cellChoice == #cellMenu - 1 then
							gg.setVisible(false)
							gg.toast("Applying rewards to all cells. Please wait...")
							for i = 1, 4 do
								applyRewardsToCell(cachedBaseAddresses[i], cellData[i], chosenKeys, amounts)
							end
							gg.setVisible(true)
							gg.toast("✅ All Vu Pass rewards have been modified successfully!")
						else
							local realCellIndex = cellMap[cellChoice]
							gg.setVisible(false)
							gg.toast("Applying rewards to " .. cellData[realCellIndex].name .. "...")
							applyRewardsToCell(
								cachedBaseAddresses[realCellIndex],
								cellData[realCellIndex],
								chosenKeys,
								amounts
							)
							gg.setVisible(true)
							gg.toast(
								"✅ Rewards for "
									.. cellData[realCellIndex].name
									.. " have been modified successfully!"
							)
						end
					end
				end
			end
		end
	end
end

local RewardsAddress = {}
local OriginalRewardBytes = {}
local RewardsReqValue = {}
local currentRank = 1

local rankRequirements = {
	[2] = 2500,
	[3] = 7500,
	[4] = 15000,
	[5] = 22500,
	[6] = 32500,
	[7] = 42500,
	[8] = 57500,
	[9] = 77500,
	[10] = 102500,
	[11] = 152500,
	[12] = 227500,
	[13] = 327500,
	[14] = 427500,
	[15] = 577500,
	[16] = 727500,
	[17] = 877500,
	[18] = 1027500,
	[19] = 1177500,
	[20] = 1377500,
	[21] = 1577500,
	[22] = 1777500,
	[23] = 1977500,
	[24] = 2177500,
	[25] = 2377500,
	[26] = 2577500,
	[27] = 2777500,
	[28] = 2977500,
	[29] = 3177500,
	[30] = 3377500,
	[31] = 3577500,
	[32] = 3777500,
	[33] = 3977500,
	[34] = 4177500,
	[35] = 4377500,
	[36] = 4577500,
	[37] = 4777500,
	[38] = 4977500,
	[39] = 5177500,
	[40] = 5377500,
	[41] = 5577500,
	[42] = 5777500,
	[43] = 5977500,
	[44] = 6177500,
	[45] = 6377500,
	[46] = 6577500,
	[47] = 6777500,
	[48] = 6977500,
	[49] = 7177500,
	[50] = 7377500,
	[51] = 7577500,
	[52] = 7777500,
	[53] = 7977500,
	[54] = 8177500,
	[55] = 8377500,
	[56] = 8577500,
	[57] = 8777500,
	[58] = 8977500,
	[59] = 9177500,
	[60] = 9377500,
	[61] = 9577500,
	[62] = 9777500,
	[63] = 9977500,
	[64] = 10177500,
	[65] = 10377500,
	[66] = 10577500,
	[67] = 10777500,
	[68] = 10977500,
	[69] = 11177500,
	[70] = 11377500,
	[71] = 11577500,
	[72] = 11777500,
	[73] = 11977500,
	[74] = 12177500,
	[75] = 12377500,
	[76] = 12577500,
	[77] = 12777500,
	[78] = 12977500,
	[79] = 13177500,
	[80] = 13377500,
	[81] = 13577500,
	[82] = 13777500,
	[83] = 13977500,
	[84] = 14177500,
	[85] = 14377500,
	[86] = 14577500,
	[87] = 14777500,
	[88] = 14977500,
	[89] = 15177500,
	[90] = 15377500,
	[91] = 15577500,
	[92] = 15777500,
	[93] = 15977500,
	[94] = 16177500,
	[95] = 16377500,
	[96] = 16577500,
	[97] = 16777500,
	[98] = 16977500,
	[99] = 17177500,
	[100] = 17377500,
	[101] = 17577500,
	[102] = 17777500,
	[103] = 17977500,
	[104] = 18177500,
	[105] = 18377500,
	[106] = 18577500,
	[107] = 18777500,
	[108] = 18977500,
	[109] = 19177500,
	[110] = 19377500,
	[111] = 19577500,
	[112] = 19777500,
	[113] = 19977500,
	[114] = 20177500,
	[115] = 20377500,
	[116] = 20577500,
	[117] = 20777500,
	[118] = 20977500,
	[119] = 21177500,
	[120] = 21377500,
	[121] = 21577500,
	[122] = 21777500,
	[123] = 21977500,
	[124] = 22177500,
	[125] = 22377500,
	[126] = 22637500,
	[127] = 22907500,
	[128] = 23187500,
	[129] = 23477500,
	[130] = 23777500,
	[131] = 24087500,
	[132] = 24407500,
	[133] = 24737500,
	[134] = 25077500,
	[135] = 25427500,
	[136] = 25787500,
	[137] = 26157500,
	[138] = 26537500,
	[139] = 26927500,
	[140] = 27327500,
	[141] = 27737500,
	[142] = 28157500,
	[143] = 28587500,
	[144] = 29027500,
	[145] = 29477500,
	[146] = 29937500,
	[147] = 30407500,
	[148] = 30887500,
	[149] = 31377500,
	[150] = 31877500,
	[151] = 32387500,
	[152] = 32907500,
	[153] = 33437500,
	[154] = 33977500,
	[155] = 34527500,
	[156] = 35087500,
	[157] = 35657500,
	[158] = 36237500,
	[159] = 36827500,
	[160] = 37427500,
	[161] = 38037500,
	[162] = 38657500,
	[163] = 39287500,
	[164] = 39927500,
	[165] = 40577500,
	[166] = 41237500,
	[167] = 41907500,
	[168] = 42587500,
	[169] = 43277500,
	[170] = 43977500,
	[171] = 44687500,
	[172] = 45407500,
	[173] = 46137500,
	[174] = 46877500,
	[175] = 47627500,
	[176] = 48387500,
	[177] = 49157500,
	[178] = 49937500,
	[179] = 50727500,
	[180] = 51527500,
	[181] = 52337500,
	[182] = 53157500,
	[183] = 53987500,
	[184] = 54827500,
	[185] = 55677500,
	[186] = 56537500,
	[187] = 57407500,
	[188] = 58287500,
	[189] = 59177500,
	[190] = 60077500,
	[191] = 60987500,
	[192] = 61907500,
	[193] = 62837500,
	[194] = 63777500,
	[195] = 64727500,
	[196] = 65687500,
	[197] = 66657500,
	[198] = 67637500,
	[199] = 68627500,
	[200] = 69627500,
	[201] = 70637500,
	[202] = 71657500,
	[203] = 72687500,
	[204] = 73727500,
	[205] = 74777500,
	[206] = 75837500,
	[207] = 76907500,
	[208] = 77987500,
	[209] = 79077500,
	[210] = 80177500,
	[211] = 81287500,
	[212] = 82407500,
	[213] = 83537500,
	[214] = 84677500,
	[215] = 85827500,
	[216] = 86987500,
	[217] = 88157500,
	[218] = 89337500,
	[219] = 90527500,
	[220] = 91727500,
	[221] = 92937500,
	[222] = 94157500,
	[223] = 95387500,
	[224] = 96627500,
	[225] = 97877500,
	[226] = 99137500,
	[227] = 100407500,
	[228] = 101687500,
	[229] = 102977500,
	[230] = 104277500,
	[231] = 105587500,
	[232] = 106907500,
	[233] = 108237500,
	[234] = 109577500,
	[235] = 110927500,
	[236] = 112287500,
	[237] = 113657500,
	[238] = 115037500,
	[239] = 116427500,
	[240] = 117827500,
	[241] = 119237500,
	[242] = 120657500,
	[243] = 122087500,
	[244] = 123527500,
	[245] = 124977500,
	[246] = 126437500,
	[247] = 127907500,
	[248] = 129387500,
	[249] = 130877500,
	[250] = 132377500,
	[251] = 133887500,
	[252] = 135407500,
	[253] = 136937500,
	[254] = 138477500,
	[255] = 140027500,
	[256] = 141587500,
	[257] = 143157500,
	[258] = 144737500,
	[259] = 146327500,
	[260] = 147927500,
	[261] = 149537500,
	[262] = 151157500,
	[263] = 152787500,
	[264] = 154427500,
	[265] = 156077500,
	[266] = 157737500,
	[267] = 159407500,
	[268] = 161087500,
	[269] = 162777500,
	[270] = 164477500,
	[271] = 166187500,
	[272] = 167907500,
	[273] = 169637500,
	[274] = 171377500,
	[275] = 173127500,
	[276] = 174887500,
	[277] = 176657500,
	[278] = 178437500,
	[279] = 180227500,
	[280] = 182027500,
	[281] = 183837500,
	[282] = 185657500,
	[283] = 187487500,
	[284] = 189327500,
	[285] = 191177500,
	[286] = 193037500,
	[287] = 194907500,
	[288] = 196787500,
	[289] = 198677500,
	[290] = 200577500,
	[291] = 202487500,
	[292] = 204407500,
	[293] = 206337500,
	[294] = 208277500,
	[295] = 210227500,
	[296] = 212187500,
	[297] = 214157500,
	[298] = 216137500,
	[299] = 218127500,
	[300] = 999999999,
}

local resourcesData = {
	simoleons = { name = "🪙 Simoleons", id = "Simoleons:" },
	simcash = { name = "💵 SimCash", id = "Simcash:" },
	neosimoleons = { name = "🌐 Neosimoleons", id = "Neosims:" },
	golden_keys = { name = "🔑 Golden Keys", id = "Keys:" },
	platinum_keys = { name = "🗝️ Platinum Keys", id = "Platinum:" },
	war_simoleons = { name = "⚔️ War Simoleons", id = "warsims:" },
	blueprints = { name = "📘 Blueprints", id = "Blueprints:" },
	golden_ticket = { name = "🎫 Golden Ticket", id = "GoldenTicket:" },
}

local resourceMenuOrder = {
	"simoleons",
	"simcash",
	"neosimoleons",
	"golden_keys",
	"platinum_keys",
	"war_simoleons",
	"blueprints",
	"golden_ticket",
}

local function findRewards()
	gg.setRanges(gg.REGION_C_ALLOC | gg.REGION_OTHER | gg.REGION_ANONYMOUS)
	gg.clearResults()
	gg.setVisible(false)
	gg.searchNumber("1952541776", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
	local results = gg.getResults(gg.getResultsCount())
	if #results == 0 then
		return false
	end
	gg.clearResults()
	local toGet = {}
	for i = 1, #results do
		toGet[i] = { address = results[i].address + 0x14, flags = gg.TYPE_DWORD }
	end
	local offsetValue = gg.getValues(toGet)
	RewardsAddress = {}
	for i = 1, #offsetValue do
		if offsetValue[i].value == 980706667 then
			RewardsAddress[#RewardsAddress + 1] = offsetValue[i].address - 0x14
		end
	end
	if #RewardsAddress == 0 then
		return false
	end
	return true
end

local function findRewardReq()
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS | gg.REGION_C_ALLOC | gg.REGION_OTHER)

	local proximityBack = 5000 * 4
	local proximityFwd = 20000 * 4
	local batchSize = 20000
	local dwordCheckValue = 33

	gg.toast("Searching for anchor value: 1027500...")
	gg.searchNumber("1027500", gg.TYPE_DWORD)
	local anchors = gg.getResults(gg.getResultsCount())
	if #anchors == 0 then
		gg.alert("Anchor rank (18) not found. Cannot proceed.")
		return false
	end
	gg.toast("Found " .. #anchors .. " potential anchor(s). Validating...")

	local foundRanksMap = {}

	for i, anchor in ipairs(anchors) do
		gg.toast(string.format("Processing anchor %d of %d...", i, #anchors))

		local baseAddress = anchor.address
		local startScanAddr = baseAddress - proximityBack
		local endScanAddr = baseAddress + proximityFwd

		local pointerOriginMap = {}
		local destinationAddresses = {}

		gg.toast("wait...")
		local pointerChunk = {}
		for candidateAddr = startScanAddr, endScanAddr, 4 do
			table.insert(pointerChunk, { address = candidateAddr + 0x8, flags = gg.TYPE_QWORD })
			if #pointerChunk >= batchSize then
				local readPointers = gg.getValues(pointerChunk)
				if readPointers then
					for _, pData in ipairs(readPointers) do
						if pData.value and pData.value ~= 0 then
							local originAddr = pData.address - 0x8
							if not pointerOriginMap[pData.value] then
								pointerOriginMap[pData.value] = {}
								table.insert(destinationAddresses, { address = pData.value, flags = gg.TYPE_DWORD })
							end
							table.insert(pointerOriginMap[pData.value], originAddr)
						end
					end
				end
				pointerChunk = {}
			end
		end
		if #pointerChunk > 0 then
			local readPointers = gg.getValues(pointerChunk)
			if readPointers then
				for _, pData in ipairs(readPointers) do
					if pData.value and pData.value ~= 0 then
						local originAddr = pData.address - 0x8
						if not pointerOriginMap[pData.value] then
							pointerOriginMap[pData.value] = {}
							table.insert(destinationAddresses, { address = pData.value, flags = gg.TYPE_DWORD })
						end
						table.insert(pointerOriginMap[pData.value], originAddr)
					end
				end
			end
		end

		if #destinationAddresses == 0 then
			goto next_anchor
		end

		gg.toast("Wait...")
		local destChunk = {}
		for _, destAddr in ipairs(destinationAddresses) do
			table.insert(destChunk, destAddr)
			if #destChunk >= batchSize then
				local finalValues = gg.getValues(destChunk)
				if finalValues then
					for _, finalData in ipairs(finalValues) do
						if finalData.value == dwordCheckValue then
							for _, originalAddr in ipairs(pointerOriginMap[finalData.address]) do
								local rankNumAddr = originalAddr - 0x8
								local rankRead = gg.getValues({ { address = rankNumAddr, flags = gg.TYPE_DWORD } })
								if rankRead and rankRead[1] then
									local rankNum = rankRead[1].value
									local pointsAddr = rankNumAddr + 0x8
									local pointsRead = gg.getValues({ { address = pointsAddr, flags = gg.TYPE_DWORD } })
									if
										pointsRead
										and pointsRead[1]
										and rankRequirements[rankNum]
										and rankRequirements[rankNum] == pointsRead[1].value
									then
										foundRanksMap[rankNum] =
											{ address = pointsAddr, value = pointsRead[1].value, rank = rankNum }
									end
								end
							end
						end
					end
				end
				destChunk = {}
			end
		end
		if #destChunk > 0 then
			local finalValues = gg.getValues(destChunk)
			if finalValues then
				for _, finalData in ipairs(finalValues) do
					if finalData.value == dwordCheckValue then
						for _, originalAddr in ipairs(pointerOriginMap[finalData.address]) do
							local rankNumAddr = originalAddr - 0x8
							local rankRead = gg.getValues({ { address = rankNumAddr, flags = gg.TYPE_DWORD } })
							if rankRead and rankRead[1] then
								local rankNum = rankRead[1].value
								local pointsAddr = rankNumAddr + 0x8
								local pointsRead = gg.getValues({ { address = pointsAddr, flags = gg.TYPE_DWORD } })
								if
									pointsRead
									and pointsRead[1]
									and rankRequirements[rankNum]
									and rankRequirements[rankNum] == pointsRead[1].value
								then
									foundRanksMap[rankNum] =
										{ address = pointsAddr, value = pointsRead[1].value, rank = rankNum }
								end
							end
						end
					end
				end
			end
		end
		::next_anchor::
	end

	local finalRankList = {}
	for _, rankData in pairs(foundRanksMap) do
		table.insert(finalRankList, rankData)
	end

	local totalRanksToFind = 0
	for _ in pairs(rankRequirements) do
		totalRanksToFind = totalRanksToFind + 1
	end

	if #finalRankList < totalRanksToFind then
		local missingRanks = {}
		for i = 2, 300 do
			if rankRequirements[i] and not foundRanksMap[i] then
				table.insert(missingRanks, tostring(i))
			end
		end
		local alertMessage = string.format(
			"%d of %d ranks found.\n\nMissing Ranks:\n%s",
			#finalRankList,
			totalRanksToFind,
			table.concat(missingRanks, ", ")
		)
		gg.alert(alertMessage)
		if #finalRankList == 0 then
			return false
		end
	end

	table.sort(finalRankList, function(a, b)
		return a.rank < b.rank
	end)
	RewardsReqValue = finalRankList
	return true
end

local function writeStringToRewards(text)
	if #OriginalRewardBytes == 0 and #RewardsAddress > 0 then
		local toGet = {}
		for i = 1, 28 do
			table.insert(toGet, { address = RewardsAddress[1] + i - 1, flags = gg.TYPE_BYTE })
		end
		local originalValues = gg.getValues(toGet)
		for i = 1, #originalValues do
			OriginalRewardBytes[i] = originalValues[i].value
		end
		gg.toast("Original reward saved for restoration.")
	end
	if string.len(text) > 28 then
		gg.alert("Error: Reward string is too long (max 28 characters).\nGenerated string: " .. text)
		return
	end
	local bytes = {}
	for i = 1, string.len(text) do
		bytes[i] = string.byte(text, i)
	end
	for i = #bytes + 1, 28 do
		bytes[i] = 0
	end
	local toSet = {}
	for i = 1, #RewardsAddress do
		for j = 1, 28 do
			table.insert(toSet, { address = RewardsAddress[i] + j - 1, flags = gg.TYPE_BYTE, value = bytes[j] })
		end
	end
	gg.setValues(toSet)
	gg.toast("Reward set successfully!")
end

local function revertRewardChanges()
	if #OriginalRewardBytes == 0 then
		gg.alert("No changes have been made yet, or the original reward could not be saved.")
		return
	end
	local toSet = {}
	for i = 1, #RewardsAddress do
		for j = 1, #OriginalRewardBytes do
			table.insert(
				toSet,
				{ address = RewardsAddress[i] + j - 1, flags = gg.TYPE_BYTE, value = OriginalRewardBytes[j] }
			)
		end
	end
	if #toSet > 0 then
		gg.setValues(toSet)
		gg.toast("Reward changes have been reverted.")
	else
		gg.alert("Failed to prepare data for revert.")
	end
end

local function _ensureInitialized()
	if #RewardsAddress > 0 and #RewardsReqValue > 0 then
		return true
	end
	gg.toast("Initializing script...")
	if not findRewards() or not findRewardReq() then
		gg.alert("Initialization failed. Please restart the script and the game.")
		return false
	end
	gg.toast("Initialization complete! Found " .. #RewardsReqValue .. " ranks.")
	return true
end

local WasUnlocked = nil

local function unlockAll()
	if #RewardsReqValue == 0 then
		gg.alert("Rank data not found. Please restart script.")
		return
	end

	local toSet = {}
	if WasUnlocked == nil then
		WasUnlocked = 1
		for i = 1, #RewardsReqValue do
			table.insert(toSet, {
				address = RewardsReqValue[i].address,
				flags = gg.TYPE_DWORD,
				value = 0,
			})
		end
		gg.setValues(toSet)
		currentRank = RewardsReqValue[#RewardsReqValue].rank
		gg.toast("All ranks unlocked.")
	else
		WasUnlocked = nil
		for i = 1, #RewardsReqValue do
			table.insert(toSet, {
				address = RewardsReqValue[i].address,
				flags = gg.TYPE_DWORD,
				value = RewardsReqValue[i].value,
			})
		end
		gg.setValues(toSet)
		currentRank = 1
		gg.toast("All ranks locked.")
	end
end

local function unlockNext()
	if #RewardsReqValue == 0 then
		gg.alert("Rank data not found. Please restart script.")
		return
	end
	if WasUnlocked == 1 then
		gg.alert("All rewards are already unlocked. Please lock them first to use this feature.")
		return
	end

	local nextRankInfo = nil
	for i = 1, #RewardsReqValue do
		if RewardsReqValue[i].rank > currentRank then
			nextRankInfo = RewardsReqValue[i]
			break
		end
	end

	if not nextRankInfo then
		gg.alert("All available ranks have been unlocked one by one.")
		if #RewardsReqValue > 0 then
			currentRank = RewardsReqValue[#RewardsReqValue].rank
		end
		return
	end

	local toSet = {}
	toSet[1] = {
		address = nextRankInfo.address,
		flags = gg.TYPE_DWORD,
		value = 0,
	}
	gg.setValues(toSet)
	currentRank = nextRankInfo.rank
	gg.toast("Unlocked rank " .. currentRank)
end

local function changeCurrentRank()
	local input = gg.prompt(
		{ "Enter your current rank so you don't have to tap 'unlock next' multiple times to get to your actual rank:" },
		{ tostring(currentRank) },
		{ "number" }
	)
	if input == nil or input[1] == "" then
		return
	end

	local newRank = tonumber(input[1])
	if newRank and rankRequirements[newRank] then
		currentRank = newRank
		gg.toast("Current rank set to " .. currentRank)
	elseif newRank then
		gg.alert("Error: Rank " .. newRank .. " does not exist in the data list.")
	else
		gg.alert("Invalid input. Please enter a number.")
	end
end

local function editRewardMenu()
	while true do
		local menuOptions = {}
		for _, key in ipairs(resourceMenuOrder) do
			table.insert(menuOptions, resourcesData[key].name)
		end
		table.insert(menuOptions, "🔙 Back")
		local selectedIndex = gg.choice(menuOptions, nil, "Select Reward Type")
		if selectedIndex == nil then
			gg.setVisible(false)
			while not gg.isVisible() do
				gg.sleep(100)
			end
		elseif selectedIndex == #menuOptions then
			return
		else
			local resourceKey = resourceMenuOrder[selectedIndex]
			local resource = resourcesData[resourceKey]
			if resource then
				local input = gg.prompt({ "Enter amount for " .. resource.name .. ":" }, { "1" }, { "number" })
				if input ~= nil then
					local amount = tonumber(input[1])
					if amount then
						local rewardString = resource.id .. amount
						writeStringToRewards(rewardString)
					else
						gg.alert("Invalid amount.")
					end
				end
			else
				gg.alert("Error: invalid resource selected.")
			end
		end
	end
end

local function mainb()
	if not _ensureInitialized() then
		return
	end
	while true do
		local unlockAllTitle = "🔓 Unlock/Lock ALL Ranks"
		if WasUnlocked == 1 then
			unlockAllTitle = "🔒 Lock ALL Ranks"
		end
		local unlockNextTitle = "🔓 Unlock Next Rank (Current: " .. tostring(currentRank) .. ")"

		local choice = gg.choice({
			"✨ Edit Reward Type",
			"🔄 Revert Reward Changes",
			unlockNextTitle,
			unlockAllTitle,
			"📊 Change Current Rank",
			"🔙 Back",
		}, nil, "Resource Generator")

		if choice == nil then
			gg.setVisible(false)
			while not gg.isVisible() do
				gg.sleep(100)
			end
		elseif choice == 6 then
			return
		elseif choice == 1 then
			editRewardMenu()
		elseif choice == 2 then
			revertRewardChanges()
		elseif choice == 3 then
			unlockNext()
		elseif choice == 4 then
			unlockAll()
		elseif choice == 5 then
			changeCurrentRank()
		end
	end
end

local contestRankCache = nil
local seasonalCurrencyCache = nil

local function findContestRankBaseAddress()
	if contestRankCache then
		return contestRankCache
	end

	gg.setVisible(false)
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS | gg.REGION_C_ALLOC | gg.REGION_OTHER)

	gg.searchNumber("6157391977344036723", gg.TYPE_QWORD)
	local results = gg.getResults(10000)

	if #results == 0 then
		return nil
	end

	for _, r in ipairs(results) do
		local p1Loc = r.address - 0x54
		local p1Val = gg.getValues({ { address = p1Loc, flags = gg.TYPE_QWORD } })[1].value

		if p1Val and p1Val ~= 0 then
			local p2Loc = p1Val + 0x58
			local p2Val = gg.getValues({ { address = p2Loc, flags = gg.TYPE_QWORD } })[1].value

			if p2Val and p2Val ~= 0 then
				local checkAddr = p2Val + 0x30
				local checkVal = gg.getValues({ { address = checkAddr, flags = gg.TYPE_DWORD } })[1].value

				if checkVal == 3000 then
					contestRankCache = checkAddr
					gg.toast("Contest Base Found!")
					return checkAddr
				end
			end
		end
	end

	return nil
end

local function detectSeasonalCurrency(baseAddress)
	if seasonalCurrencyCache then
		return seasonalCurrencyCache
	end

	local baseOffsets = {
		{ address = baseAddress, flags = gg.TYPE_DWORD },
		{ address = baseAddress - 0x8, flags = gg.TYPE_DWORD },
		{ address = baseAddress - 0x10, flags = gg.TYPE_DWORD },
	}

	local initial = gg.getValues(baseOffsets)
	local nextBatch = {}
	for _, v in ipairs(initial) do
		table.insert(nextBatch, { address = v.address + 0xA0, flags = gg.TYPE_DWORD })
	end

	local firstReward = gg.getValues(nextBatch)

	local ptr2 = gg.getValues({ { address = firstReward[2].address, flags = gg.TYPE_QWORD } })[1].value
	if ptr2 == 0 then
		return nil
	end

	local readList = {}
	for i = 0, 5 do
		table.insert(readList, { address = ptr2 + i * 4, flags = gg.TYPE_DWORD })
	end

	local values = gg.getValues(readList)
	local block2 = {}
	for i = 1, 6 do
		block2[i] = values[i].value ~= 0 and values[i].value or 0x0
	end

	seasonalCurrencyCache = {
		block1 = { 0x6D616320, 0x67696170, 0x7275636E, 0x636E6572, 0x00000079, 0x00000000 },
		block2 = block2,
	}

	gg.toast("Seasonal currency detected!")
	return seasonalCurrencyCache
end

local function applyContestRankRewards(baseAddress, selectedCurrencyKeys, amounts)
	if not baseAddress then
		return
	end
	gg.clearList()
	local isAnySpecial = false
	for _, key in ipairs(selectedCurrencyKeys) do
		if currencyData[key].isSpecial then
			isAnySpecial = true
			break
		end
	end

	local baseOffsets
	if isAnySpecial then
		baseOffsets = {
			{ address = baseAddress, flags = gg.TYPE_DWORD },
			{ address = baseAddress - 0x8, flags = gg.TYPE_DWORD },
			{ address = baseAddress - 0x10, flags = gg.TYPE_DWORD },
		}
	else
		baseOffsets = {
			{ address = baseAddress, flags = gg.TYPE_DWORD },
			{ address = baseAddress - 0x10, flags = gg.TYPE_DWORD },
		}
	end

	local initialValues = gg.getValues(baseOffsets)
	gg.addListItems(initialValues)

	local accumulated, current, rewardCount = {}, gg.getListItems(), 37
	for i = 1, rewardCount do
		local nextBatch = {}
		for _, v in ipairs(current) do
			table.insert(nextBatch, { address = v.address + 0xA0, flags = gg.TYPE_DWORD })
		end
		current = gg.getValues(nextBatch)
		for _, v in ipairs(current) do
			table.insert(accumulated, v)
		end
	end
	gg.addListItems(accumulated)

	local list = gg.getListItems()
	local step = isAnySpecial and 3 or 2
	local startPos = #baseOffsets + 1

	local pointersToRead = {}
	for i = startPos, #list, step do
		local reward_counter = ((i - startPos) / step) + 1
		if reward_counter > rewardCount then
			break
		end
		local currentKey = selectedCurrencyKeys[((reward_counter - 1) % #selectedCurrencyKeys) + 1]
		if currencyData[currentKey].isSpecial then
			table.insert(pointersToRead, { address = list[i].address, flags = gg.TYPE_QWORD })
			table.insert(pointersToRead, { address = list[i + 1].address, flags = gg.TYPE_QWORD })
		else
			table.insert(pointersToRead, { address = list[i].address, flags = gg.TYPE_QWORD })
		end
	end

	if #pointersToRead == 0 then
		return
	end
	local resolvedPointers = gg.getValues(pointersToRead)
	local allEdits, pointer_idx = {}, 1

	for i = startPos, #list, step do
		local reward_counter = ((i - startPos) / step) + 1
		if reward_counter > rewardCount then
			break
		end
		local currency_cycle_index = ((reward_counter - 1) % #selectedCurrencyKeys) + 1
		local currentKey = selectedCurrencyKeys[currency_cycle_index]
		local currency = currencyData[currentKey]

		if currency.isSpecial then
			if resolvedPointers[pointer_idx] and resolvedPointers[pointer_idx + 1] then
				local ptr1, ptr2 = resolvedPointers[pointer_idx].value, resolvedPointers[pointer_idx + 1].value
				if ptr1 and ptr1 ~= 0 and ptr2 and ptr2 ~= 0 then
					local qty_addr = list[i + 2].address
					for j = 1, 6 do
						table.insert(
							allEdits,
							{ address = ptr1 + (j - 1) * 4, flags = gg.TYPE_DWORD, value = currency.hexCodes.block1[j] }
						)
						table.insert(
							allEdits,
							{ address = ptr2 + (j - 1) * 4, flags = gg.TYPE_DWORD, value = currency.hexCodes.block2[j] }
						)
					end
					table.insert(allEdits, { address = qty_addr, flags = gg.TYPE_DWORD, value = amounts[currentKey] })
					table.insert(allEdits, { address = qty_addr + 0x38, flags = gg.TYPE_DWORD, value = 0 })
				end
			end
			pointer_idx = pointer_idx + 2
		else
			if resolvedPointers[pointer_idx] then
				local pointerQ = resolvedPointers[pointer_idx].value
				if pointerQ and pointerQ ~= 0 then
					local qty_addr = isAnySpecial and list[i + 2].address or list[i + 1].address
					for j, hex in ipairs(currency.hexCodes) do
						table.insert(allEdits, { address = pointerQ + (j - 1) * 4, flags = gg.TYPE_DWORD, value = hex })
					end
					table.insert(allEdits, { address = qty_addr, flags = gg.TYPE_DWORD, value = amounts[currentKey] })
					table.insert(allEdits, { address = qty_addr + 0x38, flags = gg.TYPE_DWORD, value = 0 })
				end
			end
			pointer_idx = pointer_idx + 1
		end
	end
	if #allEdits > 0 then
		gg.setValues(allEdits)
	end
end

local function calculateBlueprintHex(codeInput)
	local code = tonumber(codeInput)
	if not code then
		return nil
	end

	local d1 = math.floor(code / 100) % 10
	local d2 = math.floor(code / 10) % 10
	local d3 = code % 10

	local baseHex = 0x030303006
	local newHex = baseHex + (d3 * 0x1000000) + (d2 * 0x10000) + (d1 * 0x100)

	return newHex
end

function mainContestOfMayors()
	local baseAddress = findContestRankBaseAddress()
	if not baseAddress then
		return
	end

	local originalBlueprintHex = currencyData.blueprints.hexCodes.block2[1]

	while true do
		currencyData.blueprints.hexCodes.block2[1] = originalBlueprintHex

		local menuItems, multiMenuKeys = { "♻️ Revert Changes", "🔙 Back" }, {}
		table.insert(menuItems, 3, "✔️ All")
		for _, key in ipairs(currencyDisplayOrder) do
			if currencyData[key] then
				table.insert(menuItems, currencyData[key].name)
				table.insert(multiMenuKeys, key)
			end
		end

		local selection = gg.multiChoice(menuItems, nil, "Select currencies for Mayor's Pass:")

		if selection == nil then
			gg.setVisible(false)
			while not gg.isVisible() do
				gg.sleep(100)
			end
		elseif selection[2] then
			return
		elseif selection[1] then
			gg.alert("To revert changes, you must restart the game.")
		else
			local chosenKeys = {}

			if selection[3] then
				chosenKeys = multiMenuKeys
			else
				for index, checked in pairs(selection) do
					if checked and index >= 4 then
						table.insert(chosenKeys, multiMenuKeys[index - 3])
					end
				end
			end

			if #chosenKeys == 0 then
				gg.toast("No currencies selected.")
			elseif #chosenKeys > 37 then
				gg.alert("The Mayor's Pass supports a maximum of 37 rewards. You have selected " .. #chosenKeys .. ".")
			else
				local allValid = true
				local blueprintSelected = false
				local seasonalSelected = false

				for _, key in ipairs(chosenKeys) do
					if key == "blueprints" then
						blueprintSelected = true
					end

					if key == "monaco_ticket" then
						seasonalSelected = true
					end
				end

				if seasonalSelected then
					local seasonal = detectSeasonalCurrency(baseAddress)
					if seasonal then
						currencyData.monaco_ticket.hexCodes.block2 = seasonal.block2
					else
						gg.alert("Failed to detect seasonal currency.")
						allValid = false
					end
				end

				if blueprintSelected then
					local bp_input = gg.prompt({ "Enter blueprint code" }, { "449" }, { "text" })

					if bp_input == nil then
						allValid = false
					else
						local bp_code_str = bp_input[1]

						if bp_code_str:len() ~= 3 or not tonumber(bp_code_str) then
							gg.alert("Invalid code. Please enter exactly 3 numeric digits.")
							allValid = false
						else
							local newHex = calculateBlueprintHex(bp_code_str)
							currencyData.blueprints.hexCodes.block2[1] = newHex
						end
					end
				end

				if allValid then
					local amounts, promptData, defaultValues, inputTypes = {}, {}, {}, {}

					for _, key in ipairs(chosenKeys) do
						table.insert(promptData, currencyData[key].prompt)
						table.insert(defaultValues, "1")
						table.insert(inputTypes, "number")
					end

					local inputs = gg.prompt(promptData, defaultValues, inputTypes)

					if inputs == nil then
						allValid = false
					else
						for i, key in ipairs(chosenKeys) do
							local amount = tonumber(inputs[i])

							if not amount or amount < 0 then
								gg.alert("Invalid amount for " .. currencyData[key].name .. ". Aborting.")
								allValid = false
								break
							end

							amounts[key] = amount
						end
					end

					if allValid then
						gg.setVisible(false)
						gg.toast("Applying rewards... Please wait.")

						applyContestRankRewards(baseAddress, chosenKeys, amounts)

						gg.setVisible(true)
						gg.toast("✅ Mayor's Pass rewards applied successfully!")
					end
				end
			end
		end
	end
end

function option5Menu()
	while true do
		local escolha = gg.choice({
			"🔙 Back",
			"❄️ Freeze Currencies",
			"🏆 Currencies through Contest Rank",
			"🎟️ Currencies through Vu Pass",
			"🏛️ Currencies through Mayor Pass",
		}, nil, "Choose a method:")

		if escolha == nil then
			gg.setVisible(false)
			while not gg.isVisible() do
				gg.sleep(100)
			end
		elseif escolha == 2 then
			currencymenu()
		elseif escolha == 3 then
			mainb()
		elseif escolha == 4 then
			mainMenuO()
		elseif escolha == 5 then
			mainContestOfMayors()
		elseif escolha == 1 then
			return
		end
	end
end

local cellData = {
	[1] = { name = "Cell 2 (10 Rewards)", rewardCount = 10, baseIndex = 2 },
	[2] = { name = "Cell 3 (10 Rewards)", rewardCount = 10, baseIndex = 3 },
	[3] = { name = "Cell 4 (10 Rewards)", rewardCount = 10, baseIndex = 4 },
}

local trainCardData = {
	["LM Grade 23"] = {
		name = "🚂 LM Grade 23",
		isSpecial = false,
		hexCodes = { 0x31424410, 0x72614330, 0x00000064, 0x00000000, 0x00006472, 0x00000000 },
		prompt = "How many 'LM Grade 23' cards do you want?",
	},
	["Magnificent Mayor"] = {
		name = "🚂 Magnificent Mayor",
		isSpecial = false,
		hexCodes = { 0x7075531C, 0x68437265, 0x43666569, 0x00647261, 0x00006472, 0x00000000 },
		prompt = "How many 'Magnificent Mayor' cards do you want?",
	},
	["Quill Railroad OP1"] = {
		name = "🚂 Quill Railroad OP1",
		isSpecial = false,
		hexCodes = { 0x3147470E, 0x64726143, 0x6361506E, 0x63696669, 0x64726143, 0x00000000 },
		prompt = "How many 'Quill Railroad OP1' cards do you want?",
	},
	["SC Line 9001"] = {
		name = "🚂 SC Line 9001",
		isSpecial = false,
		hexCodes = { 0x43534E16, 0x7373616C, 0x64726143, 0x00000000, 0x64726143, 0x00000000 },
		prompt = "How many 'SC Line 9001' cards do you want?",
	},
	["Simeo Plus B"] = {
		name = "🚂 Simeo Plus B",
		isSpecial = false,
		hexCodes = { 0x72694D1C, 0x6C506F65, 0x43427375, 0x00647261, 0x43333473, 0x00000000 },
		prompt = "How many 'Simeo Plus B' cards do you want?",
	},
	["E5 Super Sim"] = {
		name = "🚂 E5 Super Sim",
		isSpecial = false,
		hexCodes = { 0x5335452C, 0x65697265, 0x69685373, 0x6E616B6E, 0x436E6573, 0x00647261 },
		prompt = "How many 'E5 Super Sim' cards do you want?",
	},
	["Flying Sim"] = {
		name = "🚂 Flying Sim",
		isSpecial = false,
		hexCodes = { 0x796C4624, 0x53676E69, 0x73746F63, 0x436E616D, 0x00647261, 0x00000000 },
		prompt = "How many 'Flying Sim' cards do you want?",
	},
	["Llama Line"] = {
		name = "🚂 Llama Line",
		isSpecial = false,
		hexCodes = { 0x6E655222, 0x6C436566, 0x33737361, 0x61433035, 0x00006472, 0x00000000 },
		prompt = "How many 'Llama Line' cards do you want?",
	},
	["Northwest Railways"] = {
		name = "🚂 Northwest Railways",
		isSpecial = false,
		hexCodes = { 0x756F5326, 0x72656874, 0x6361506E, 0x63696669, 0x64726143, 0x00000000 },
		prompt = "How many 'Northwest Railways' cards do you want?",
	},
	["Sim Rail Grade 00"] = {
		name = "🚂 Sim Rail Grade 00",
		isSpecial = false,
		hexCodes = { 0x6972422C, 0x68736974, 0x6C696152, 0x73616C43, 0x43333473, 0x00647261 },
		prompt = "How many 'Sim Rail Grade 00' cards do you want?",
	},
}

local trainCardDisplayOrder = {
	"LM Grade 23",
	"Magnificent Mayor",
	"Quill Railroad OP1",
	"SC Line 9001",
	"Simeo Plus B",
	"E5 Super Sim",
	"Flying Sim",
	"Llama Line",
	"Northwest Railways",
	"Sim Rail Grade 00",
}
local cachedBaseAddresses = nil

local function findAllCellBases()
	gg.setVisible(false)
	gg.toast("Searching for Vu Pass cell bases...")
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS | gg.REGION_C_ALLOC | gg.REGION_OTHER)
	gg.searchNumber("8319099934827697938", gg.TYPE_QWORD)

	local results = gg.getResults(100)
	if #results == 0 then
		gg.setVisible(true)
		return nil
	end

	for _, r in ipairs(results) do
		local ptrAddr = r.address + 0x18
		local ptrValResult = gg.getValues({ { address = ptrAddr, flags = gg.TYPE_QWORD } })
		if ptrValResult and ptrValResult[1].value and ptrValResult[1].value ~= 0 then
			local ptrVal = ptrValResult[1].value
			local val180Result = gg.getValues({ { address = ptrVal + 0x180, flags = gg.TYPE_DWORD } })
			if val180Result and val180Result[1].value == 1145656354 then
				local pointer1_addr = val180Result[1].address - 0xF8
				local pointer1Result = gg.getValues({ { address = pointer1_addr, flags = gg.TYPE_QWORD } })
				if pointer1Result and pointer1Result[1].value and pointer1Result[1].value ~= 0 then
					local pointer1 = pointer1Result[1].value

					local baseAddresses, offsets = {}, { 0x00, 0x18, 0x30, 0x48 }

					local pointers_to_read = {}
					for _, offset in ipairs(offsets) do
						table.insert(pointers_to_read, { address = pointer1 + offset, flags = gg.TYPE_QWORD })
					end
					local cellPointers = gg.getValues(pointers_to_read)

					for _, cellPtrInfo in ipairs(cellPointers) do
						local cellPointer = cellPtrInfo.value

						if cellPointer and cellPointer ~= 0 then
							local validationResult =
								gg.getValues({ { address = cellPointer + 0xC, flags = gg.TYPE_DWORD } })

							if
								validationResult
								and validationResult[1].value
								and validCellValues[validationResult[1].value]
							then
								table.insert(baseAddresses, cellPointer + 0x30)
							end
						end
					end

					if #baseAddresses == 4 then
						gg.setVisible(true)
						gg.toast("✅ All 4 cell bases found and cached.")
						return baseAddresses
					end
				end
			end
		end
	end

	gg.setVisible(true)
	return nil
end

local function applyRewardsToCell(baseAddress, cellInfo, selectedCards, amounts)
	gg.clearList()
	gg.toast("Processing " .. cellInfo.name .. "...")

	local current = gg.getValues({
		{ address = baseAddress, flags = gg.TYPE_DWORD },
		{ address = baseAddress - 0x8, flags = gg.TYPE_DWORD },
		{ address = baseAddress - 0x10, flags = gg.TYPE_DWORD },
	})

	local accumulated = {}

	for i = 1, cellInfo.rewardCount do
		for _, v in ipairs(current) do
			table.insert(accumulated, v)
		end

		if i < cellInfo.rewardCount then
			local nextBatch = {}
			for _, v in ipairs(current) do
				table.insert(nextBatch, { address = v.address + 0xA0, flags = gg.TYPE_DWORD })
			end
			current = gg.getValues(nextBatch)
		end
	end

	gg.addListItems(accumulated)
	local list = gg.getListItems()

	local pointersToRead = {}
	for i = 1, #list, 3 do
		table.insert(pointersToRead, { address = list[i].address, flags = gg.TYPE_QWORD })
		table.insert(pointersToRead, { address = list[i + 1].address, flags = gg.TYPE_QWORD })
	end

	if #pointersToRead == 0 then
		return
	end
	local resolvedPointers = gg.getValues(pointersToRead)
	local allEdits, pointer_idx = {}, 1

	for i = 1, #list, 3 do
		local reward_counter = ((i - 1) / 3) + 1
		local card_cycle_index = ((reward_counter - 1) % #selectedCards) + 1
		local currentKey = selectedCards[card_cycle_index]
		local card = trainCardData[currentKey]
		local ptr1, ptr2 = resolvedPointers[pointer_idx].value, resolvedPointers[pointer_idx + 1].value
		pointer_idx = pointer_idx + 2

		if ptr1 and ptr1 ~= 0 then
			for j, hex in ipairs(card.hexCodes) do
				table.insert(allEdits, { address = ptr1 + (j - 1) * 4, flags = gg.TYPE_DWORD, value = hex })
			end
			table.insert(
				allEdits,
				{ address = list[i + 2].address, flags = gg.TYPE_DWORD, value = amounts[currentKey] }
			)
			table.insert(allEdits, { address = list[i + 2].address + 0x38, flags = gg.TYPE_DWORD, value = 0 })
		end
	end
	if #allEdits > 0 then
		gg.setValues(allEdits)
	end
end

function mainMenuXXX()
	if not cachedBaseAddresses then
		cachedBaseAddresses = findAllCellBases()
		if not cachedBaseAddresses then
			gg.alert("❌ Failed to find cell bases. Cannot proceed.")
			return
		end
	else
		gg.toast("Using cached cell base addresses.")
	end

	while true do
		local menuItems, multiMenuKeys = { "♻️ Revert Changes", "🔙 Back" }, {}
		table.insert(menuItems, 3, "✔️ All Cards")

		for _, key in ipairs(trainCardDisplayOrder) do
			if trainCardData[key] then
				table.insert(menuItems, trainCardData[key].name)
				table.insert(multiMenuKeys, key)
			end
		end

		local selection = gg.multiChoice(menuItems, nil, "Select Train Cards to cycle through:")

		if selection == nil then
			gg.setVisible(false)
			while not gg.isVisible() do
				gg.sleep(100)
			end
		elseif selection[2] then
			return
		elseif selection[1] then
			gg.alert("To revert changes, visit the war map and return.")
		else
			local chosenKeys = {}
			if selection[3] then
				chosenKeys = multiMenuKeys
			else
				for index, checked in pairs(selection) do
					if checked and index >= 4 then
						table.insert(chosenKeys, multiMenuKeys[index - 3])
					end
				end
			end

			if #chosenKeys == 0 then
				gg.toast("No cards selected.")
			elseif #chosenKeys > 10 then
				gg.alert("❌ You cannot select more than 10 items.")
			else
				local amounts, promptData, defaultValues, inputTypes = {}, {}, {}, {}
				for _, key in ipairs(chosenKeys) do
					table.insert(promptData, trainCardData[key].prompt)
					table.insert(defaultValues, "1")
					table.insert(inputTypes, "number")
				end

				local inputs = gg.prompt(promptData, defaultValues, inputTypes)
				if inputs == nil then
					gg.setVisible(false)
					while not gg.isVisible() do
						gg.sleep(100)
					end
				else
					local allValid = true
					for i, key in ipairs(chosenKeys) do
						local amount = tonumber(inputs[i])
						if not amount or amount < 0 then
							gg.alert("Invalid amount. Aborting.")
							allValid = false
							break
						end
						amounts[key] = amount
					end

					if allValid then
						local cellMenu = {}
						local cellMap = {}

						for i = 1, #cellData do
							table.insert(cellMenu, cellData[i].name)
							table.insert(cellMap, i)
						end

						table.insert(cellMenu, "✔️ All Cells")
						table.insert(cellMenu, "🔙 Back to selection")

						local cellChoice = gg.choice(cellMenu, nil, "Select which cell to apply cards to:")

						if cellChoice == nil or cellChoice == #cellMenu then
						elseif cellChoice == #cellMenu - 1 then
							gg.setVisible(false)
							gg.toast("Applying cards to all cells...")
							for i = 1, 3 do
								local idx = cellData[i].baseIndex
								applyRewardsToCell(cachedBaseAddresses[idx], cellData[i], chosenKeys, amounts)
							end
							gg.setVisible(true)
							gg.toast("✅ Done!")
						else
							local dataIndex = cellMap[cellChoice]
							local realBaseIndex = cellData[dataIndex].baseIndex
							gg.setVisible(false)
							gg.toast("Applying cards to " .. cellData[dataIndex].name .. "...")
							applyRewardsToCell(
								cachedBaseAddresses[realBaseIndex],
								cellData[dataIndex],
								chosenKeys,
								amounts
							)
							gg.setVisible(true)
							gg.toast("✅ Done!")
						end
					end
				end
			end
		end
	end
end

function maxstorage()
	gg.setVisible(false)
	gg.clearList()
	gg.clearResults()

	local success = pcall(function()
		gg.searchNumber("Q ',Government_CityStorage' 00", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1)
		gg.refineNumber("44", gg.TYPE_BYTE)
		local results = gg.getResults(gg.getResultsCount())
		if #results == 0 then
			return
		end

		local offsetResults = {}
		for i, v in ipairs(results) do
			table.insert(offsetResults, {
				address = v.address + 0x18,
				flags = gg.TYPE_DWORD,
			})
		end

		offsetResults = gg.getValues(offsetResults)
		gg.clearList()
		gg.addListItems(offsetResults)
		for i = 1, #offsetResults do
			offsetResults[i].value = -1223400949
		end
		gg.setValues(offsetResults)
	end)

	gg.toast("Done! now go to daniel city and come back")
	if not success then
		return
	end
	gg.clearList()
	gg.clearResults()
end

local menuOptions = {
	productionAmount = { active = false, text = "⚙️ Change Production Amount" },
	timeRemoved = { active = false, text = "⏳ Change Production Time" },
	xpModified = { active = false, text = "🛠️ Get XP Producing Items" },
	removeNeed = { active = false, text = "🔨 Remove Production Item Need" },
}
local xpParaIniciarNivel = {
	[1] = 2,
	[2] = 53,
	[3] = 123,
	[4] = 233,
	[5] = 383,
	[6] = 563,
	[7] = 793,
	[8] = 1063,
	[9] = 1383,
	[10] = 1763,
	[11] = 2203,
	[12] = 2683,
	[13] = 3243,
	[14] = 3903,
	[15] = 4613,
	[16] = 5433,
	[17] = 6323,
	[18] = 7303,
	[19] = 8323,
	[20] = 9443,
	[21] = 10673,
	[22] = 11953,
	[23] = 13273,
	[24] = 14793,
	[25] = 16293,
	[26] = 18003,
	[27] = 19693,
	[28] = 21613,
	[29] = 23593,
	[30] = 25653,
	[31] = 28178,
	[32] = 30163,
	[33] = 32633,
	[34] = 35183,
	[35] = 37913,
	[36] = 40633,
	[37] = 43543,
	[38] = 46653,
	[39] = 49863,
	[40] = 53163,
	[41] = 56563,
	[42] = 60183,
	[43] = 63913,
	[44] = 67863,
	[45] = 71933,
	[46] = 76113,
	[47] = 80543,
	[48] = 85093,
	[49] = 89763,
	[50] = 94693,
	[51] = 99753,
	[52] = 104943,
	[53] = 110423,
	[54] = 116033,
	[55] = 121773,
	[56] = 127823,
	[57] = 134013,
	[58] = 140353,
	[59] = 147013,
	[60] = 153823,
	[61] = 160983,
	[62] = 168293,
	[63] = 175763,
	[64] = 183393,
	[65] = 191353,
	[66] = 199663,
	[67] = 208333,
	[68] = 217383,
	[69] = 226823,
	[70] = 236673,
	[71] = 246953,
	[72] = 257683,
	[73] = 268883,
	[74] = 280573,
	[75] = 292773,
	[76] = 305503,
	[77] = 318783,
	[78] = 332643,
	[79] = 347103,
	[80] = 362193,
	[81] = 377943,
	[82] = 394373,
	[83] = 411513,
	[84] = 429393,
	[85] = 448053,
	[86] = 467523,
	[87] = 487843,
	[88] = 509043,
	[89] = 531163,
	[90] = 554243,
	[91] = 578323,
	[92] = 603453,
	[93] = 629673,
	[94] = 657033,
	[95] = 685583,
	[96] = 715373,
	[97] = 746453,
	[98] = 778883,
	[99] = 812723,
}
local originalProductionTimes = {}
local originalValues = {}
local originalItemNeeds = {}

local cachedProductionGroup = nil
local cachedXPAddressFinal = nil
local currentProductionAmount = 1

function findAndCacheProductionGroup()
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS | gg.REGION_C_ALLOC | gg.REGION_OTHER)
	gg.setVisible(false)
	gg.searchNumber("-1782055607", gg.TYPE_DWORD)
	local results = gg.getResults(gg.getResultsCount())
	local minus48 = {}
	for i, r in ipairs(results) do
		minus48[i] = { address = r.address - 0x48, flags = gg.TYPE_DWORD }
	end
	minus48 = gg.getValues(minus48)
	local only16 = {}
	for _, v in ipairs(minus48) do
		if v.value == 16 then
			table.insert(only16, { address = v.address - 0x8, flags = gg.TYPE_DWORD })
		end
	end
	if #only16 == 0 then
		gg.alert("No 16 value found")
		return false
	end
	local searchValues = {}
	for _, item in ipairs(only16) do
		local val = gg.getValues({ item })[1]
		table.insert(searchValues, val.value)
	end
	gg.clearResults()
	gg.setVisible(false)
	gg.searchNumber(table.concat(searchValues, ";"), gg.TYPE_DWORD)
	local finalResults = gg.getResults(gg.getResultsCount())
	if #finalResults < 118 or #finalResults > 130 then
		gg.alert("ERROR32.")
		return false
	end

	cachedProductionGroup = finalResults
	cachedXPAddresses = {}

	for _, r in ipairs(finalResults) do
		local prodTimeAddr = r.address + 0x9C
		local baseAddr = prodTimeAddr - 0x94
		local checkVal = gg.getValues({ { address = baseAddr, flags = gg.TYPE_DWORD } })[1].value

		if checkVal == 16 then
			table.insert(cachedXPAddresses, baseAddr + 0x218)
		end
	end

	if #cachedXPAddresses == 0 then
		gg.alert("No valid item found, make sure their production time is set to normal")
		return false
	end

	gg.toast("✔ " .. #cachedXPAddresses .. " itens found")
	return true
end

function applyProductionMultiplier(quantity, targetItemID)
	if not cachedProductionGroup and not findAndCacheProductionGroup() then
		gg.alert("Error: Production group could not be cached.")
		return false
	end

	local edits = {}
	for _, base in ipairs(cachedProductionGroup) do
		local pointerAddress = base.address + 0x200
		local structureAddress = gg.getValues({ { address = pointerAddress, flags = gg.TYPE_QWORD } })[1].value
		if structureAddress ~= 0 then
			local shouldEdit = false
			if not targetItemID then
				shouldEdit = true
			else
				local identifier = gg.getValues({ { address = structureAddress, flags = gg.TYPE_QWORD } })[1].value
				if tostring(identifier) == targetItemID then
					shouldEdit = true
				end
			end

			if shouldEdit then
				local amountAddress = structureAddress + 0x18
				table.insert(edits, { address = amountAddress, flags = gg.TYPE_DWORD, value = quantity })
			end
		end
	end

	if #edits > 0 then
		gg.setValues(edits)
		if not targetItemID then
			currentProductionAmount = quantity
			menuOptions.productionAmount.text = quantity > 1 and ("🟢 Current Production Amount: " .. quantity)
				or "⚙️ Change Production Amount"
			menuOptions.productionAmount.active = quantity > 1
		end
		return true
	else
		return false
	end
end

function setamountcool()
	if not cachedProductionGroup and not findAndCacheProductionGroup() then
		return
	end
	local input = gg.prompt(
		{ "Enter the desired production quantity (1 to restore):" },
		{ currentProductionAmount or 1 },
		{ "number" }
	)
	if input and input[1] then
		local quantity = tonumber(input[1])
		applyProductionMultiplier(quantity)
	else
		gg.toast("Operation canceled.")
	end
end

function toggleProductionTime()
	if not cachedProductionGroup and not findAndCacheProductionGroup() then
		return
	end
	local input = gg.prompt({ "Enter new production time (in seconds), or 'r' to restore:" }, { "" }, { "text" })
	if not input or not input[1] then
		gg.toast("Operation cancelled.")
		return
	end
	local userInput = input[1]
	if userInput:lower() == "r" then
		if not originalProductionTimes or #originalProductionTimes == 0 then
			gg.alert("No saved times to restore.")
			return
		end
		gg.setValues(originalProductionTimes)
		originalProductionTimes = {}
		menuOptions.timeRemoved.active = false
		menuOptions.timeRemoved.text = "⏳ Change Production Time"
		gg.alert("Original production times restored.")
		return
	end
	local newTimeSec = tonumber(userInput)
	if not newTimeSec then
		gg.alert("Invalid value.")
		return
	end
	local newTimeMs = math.floor(newTimeSec * 1000)
	local edits = {}
	originalProductionTimes = {}
	for _, base in ipairs(cachedProductionGroup) do
		local address = base.address + 0x9C
		local currentVal = gg.getValues({ { address = address, flags = gg.TYPE_DWORD } })[1]
		table.insert(originalProductionTimes, currentVal)
		table.insert(edits, { address = address, flags = gg.TYPE_DWORD, value = newTimeMs })
	end
	gg.setValues(edits)
	menuOptions.timeRemoved.active = true
	menuOptions.timeRemoved.text = "🟢 ⏳ Time: " .. newTimeSec .. "s"
	gg.toast("Production time set to " .. newTimeSec .. " seconds.")
	gg.clearResults()
end

function toggleXpFromMetal()
	if (not cachedXPAddresses or #cachedXPAddresses == 0) and not findAndCacheProductionGroup() then
		return
	end

	if not menuOptions.xpModified.active then
		local inputs = gg.prompt(
			{ "Enter your current XP:", "Enter desired level:" },
			{ "0", "5" },
			{ "number", "number" }
		)
		if not inputs then
			gg.toast("Cancelled.")
			return
		end
		local currentXP, desiredLevel = tonumber(inputs[1]), tonumber(inputs[2])
		if not (currentXP and desiredLevel) then
			gg.alert("Error: All fields must be filled.")
			return
		end
		if not xpParaIniciarNivel[desiredLevel] then
			gg.alert("Error: Level " .. desiredLevel .. " was not found.")
			return
		end
		local xpNecessario = xpParaIniciarNivel[desiredLevel] - currentXP
		if xpNecessario <= 0 then
			gg.alert("Current XP is too high for this level.")
			return
		end

		local currentVal = gg.getValues({ { address = cachedXPAddresses[1], flags = gg.TYPE_DWORD } })[1].value
		if currentVal ~= 0 then
			gg.alert("XP value already modified (should be 0).")
			return
		end

		originalValues = {}
		local valuesToSet = {}
		for _, addr in ipairs(cachedXPAddresses) do
			table.insert(originalValues, { address = addr, value = 0, flags = gg.TYPE_DWORD })
			table.insert(valuesToSet, { address = addr, value = xpNecessario, flags = gg.TYPE_DWORD })
		end

		gg.setValues(valuesToSet)

		menuOptions.xpModified.active = true
		menuOptions.xpModified.text = "🟢 XP set: " .. xpNecessario
		gg.toast("XP set to " .. #valuesToSet .. " itens!")
	else
		if not originalValues or #originalValues == 0 then
			gg.alert("No saved values to restore.")
			return
		end
		gg.setValues(originalValues)
		originalValues = {}
		menuOptions.xpModified.active = false
		menuOptions.xpModified.text = "🛠️ Get XP Producing Items"
		gg.toast("XP restored!")
	end
end

function toggleRemoveNeed()
	if not cachedProductionGroup and not findAndCacheProductionGroup() then
		gg.alert("ERROR33.")
		return
	end
	if menuOptions.removeNeed.active then
		if not originalItemNeeds or #originalItemNeeds == 0 then
			gg.alert("⚠️ No saved values to restore.")
			menuOptions.removeNeed.active = false
			menuOptions.removeNeed.text = "🔨 Remove Production Item Need"
			return
		end
		gg.setValues(originalItemNeeds)
		originalItemNeeds = {}
		menuOptions.removeNeed.active = false
		menuOptions.removeNeed.text = "🔨 Remove Production Item Need"
		gg.alert("Production needs restored!")
		gg.clearResults()
		return
	end
	local edits = {}
	originalItemNeeds = {}
	local addressesToRead = {}
	for _, result in ipairs(cachedProductionGroup) do
		local sAddr = result.address
		table.insert(addressesToRead, { address = sAddr + 0x1E0, flags = gg.TYPE_DWORD })
		table.insert(addressesToRead, { address = sAddr + 0x1E8, flags = gg.TYPE_DWORD })
	end
	local origVals = gg.getValues(addressesToRead)
	for _, val in ipairs(origVals) do
		table.insert(originalItemNeeds, val)
		table.insert(edits, { address = val.address, flags = val.flags, value = 0 })
	end
	if #edits > 0 then
		gg.setValues(edits)
		menuOptions.removeNeed.active = true
		menuOptions.removeNeed.text = "🟢 Remove Production Item Need"
		gg.toast("Production needs removed!")
	else
		gg.alert("❌ ERROR34.")
		originalItemNeeds = {}
	end
	gg.clearResults()
end

local factoryItemsCache = {}
local factorySlotsCached = false

local factoryItemsMenuDefault = {
	[1] = "⛓️ Metal",
	[2] = "🪵 Wood",
	[3] = "💳 Plastic",
	[4] = "🌱 Seeds",
	[5] = "💎 Minerals",
	[6] = "🧪 Chemicals",
	[7] = "🧶 Textiles",
}
local factoryConstants = {
	[1] = "-1501685376",
	[2] = "-1477359097",
	[3] = "-389414878",
	[4] = "-331876130",
	[5] = "-777869928",
	[6] = "809598022",
	[7] = "-545412710",
}

function cacheFactorySlots()
	if factorySlotsCached then
		return true
	end
	gg.toast("Caching factory slot addresses...")
	gg.setVisible(false)
	local successCount = 0
	for i = 1, 7 do
		gg.setRanges(gg.REGION_C_ALLOC | gg.REGION_OTHER | gg.REGION_ANONYMOUS)
		gg.clearResults()
		gg.setVisible(false)
		gg.searchNumber(tonumber(factoryConstants[i]), gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
		gg.setVisible(false)
		local r = gg.getResults(1)
		if #r > 0 then
			local a = r[1].address + 0x1c
			local initialValueResult = gg.getValues({ { address = a, flags = gg.TYPE_QWORD } })[1]
			if initialValueResult then
				factoryItemsCache[i] = {
					address = a,
					initialValue = initialValueResult.value,
					currentBuildingId = nil,
				}
				successCount = successCount + 1
			end
		end
	end
	gg.setVisible(true)
	if successCount == 7 then
		gg.toast("✅ All factory slots cached successfully!")
		factorySlotsCached = true
		return true
	else
		gg.alert(
			"❌ Error: Failed to cache all factory slots. Found " .. successCount .. " of 11. Presets will not work."
		)
		return false
	end
end

local PYRAMID_BUILDING_MAP = {
	[908361498] = "Ghost Portal (Level 3)",
	[908361499] = "Ghost Portal (Level 4)",
	[908361500] = "Ghost Portal (Level 5)",
	[908361501] = "Ghost Portal (Level 6)",
	[908361502] = "Ghost Portal (Level 7)",
	[908361503] = "Ghost Portal (Level 8)",
	[908361504] = "Ghost Portal (Level 9)",
	[-88841656] = "Ghost Portal (Level 10)",
	[-88841655] = "Ghost Portal (Level 11)",
	[-88841654] = "Ghost Portal (Level 12)",
	[-88841653] = "Ghost Portal (Level 13)",
	[-88841652] = "Ghost Portal (Level 14)",
	[-88841651] = "Ghost Portal (Level 15)",
	[-88841650] = "Ghost Portal (Level 16)",
	[-88841649] = "Ghost Portal (Level 17)",
	[-88841648] = "Ghost Portal (Level 18)",
	[-88841647] = "Ghost Portal (Level 19)",
	[-88841623] = "Ghost Portal (Level 20)",
	[-88841622] = "Ghost Portal (Level 21)",
	[-88841621] = "Ghost Portal (Level 22)",
}
local presets = {
	["1️⃣ Buildings Level I"] = {
		{ id = 908361498 },
		{ id = 908361499 },
		{ id = 908361500 },
		{ id = 908361501 },
		{ id = 908361502 },
		{ id = 908361503 },
		{ id = 908361504 },
	},
	["2️⃣ Buildings Level II"] = {
		{ id = -88841656 },
		{ id = -88841655 },
		{ id = -88841654 },
		{ id = -88841653 },
		{ id = -88841652 },
		{ id = -88841651 },
		{ id = -88841650 },
	},
	["3️⃣ Buildings Level III"] = {
		{ id = -88841649 },
		{ id = -88841648 },
		{ id = -88841647 },
		{ id = -88841623 },
		{ id = -88841622 },
		{ id = -88841621 },
	},
}
local boosterMappings = {
	["1️⃣ Buildings Level I"] = {
		[1] = { name = "Pump 1", id = 1965976282 },
		[2] = { name = "Umbrella 1", id = 1587235432 },
		[3] = { name = "Dud 1", id = 91798751 },
		[4] = { name = "Vampire 1", id = 1736317036 },
		[5] = { name = "Freeze 1", id = 924894801 },
		[6] = { name = "Jackpot 1", id = 1692935226 },
		[7] = { name = "Energy Thief 1", id = 1147903624 },
	},
	["2️⃣ Buildings Level II"] = {
		[1] = { name = "Pump 2", id = 1965976283 },
		[2] = { name = "Umbrella 2", id = 1587235433 },
		[3] = { name = "Dud 2", id = 91798752 },
		[4] = { name = "Vampire 2", id = 1736317037 },
		[5] = { name = "Freeze 2", id = 924894802 },
		[6] = { name = "Jackpot 2", id = 1692935227 },
		[7] = { name = "Energy Thief 2", id = 1147903625 },
	},
	["3️⃣ Buildings Level III"] = {
		[1] = { name = "Pump 3", id = 1965976284 },
		[2] = { name = "Umbrella 3", id = 1587235434 },
		[3] = { name = "Dud 3", id = 91798753 },
		[4] = { name = "Vampire 3", id = 1736317038 },
		[5] = { name = "Freeze 3", id = 924894803 },
		[6] = { name = "Jackpot 3", id = 1692935228 },
	},
}

local factoryItemsMenuDefault = {
	[1] = "🔩 Metal",
	[2] = "🪵 Wood",
	[3] = "💳 Plastic",
	[4] = "🌱 Seeds",
	[5] = "💎 Minerals",
	[6] = "🧪 Chemicals",
	[7] = "🧶 Textiles",
}

local buildingDatabase = {}
local isInitialized = false
local factoryItemsCache = {}
local factorySlotsCached = false
local factoryConstants = {
	[1] = "-1501685376",
	[2] = "-1477359097",
	[3] = "-389414878",
	[4] = "-331876130",
	[5] = "-777869928",
	[6] = "809598022",
	[7] = "-545412710",
}

function cacheFactorySlots()
	if factorySlotsCached then
		return true
	end
	gg.toast("Caching factory slots for revert/apply functionality...")
	gg.setVisible(false)
	factoryItemsCache = {}
	local successCount = 0
	for i = 1, 7 do
		gg.clearResults()
		gg.setRanges(gg.REGION_C_ALLOC | gg.REGION_OTHER | gg.REGION_ANONYMOUS)
		gg.searchNumber(factoryConstants[i], gg.TYPE_DWORD)
		local results = gg.getResults(1)
		if #results > 0 then
			local slotAddress = results[1].address + 0x1C
			local values = gg.getValues({ { address = slotAddress, flags = gg.TYPE_QWORD } })
			if values and values[1] and values[1].value then
				factoryItemsCache[i] = { address = slotAddress, initialValue = values[1].value }
				successCount = successCount + 1
			end
		end
	end
	gg.setVisible(true)
	if successCount >= 1 then
		factorySlotsCached = true
		gg.toast(string.format("✅ %d/7 factory slots cached.", successCount))
		return true
	else
		gg.alert("❌ Failed to cache factory slots. Revert/Apply functionality may not work.")
		return false
	end
end

function revertFactoryChanges2(calledFromMenu)
	if not factorySlotsCached then
		if not cacheFactorySlots() then
			return
		end
	end
	local toRevert, revertedCount = {}, 0
	for i = 1, 7 do
		if factoryItemsCache[i] and factoryItemsCache[i].initialValue then
			table.insert(toRevert, {
				address = factoryItemsCache[i].address,
				flags = gg.TYPE_QWORD,
				value = factoryItemsCache[i].initialValue,
			})
			if factoryItemsCache[i].currentBuildingId then
				factoryItemsCache[i].currentBuildingId = nil
			end
			revertedCount = revertedCount + 1
		end
	end
	if #toRevert > 0 then
		gg.setValues(toRevert)
		gg.toast("✅ " .. revertedCount .. " factory slots have been reverted.")
	elseif calledFromMenu then
		gg.alert("No changes to revert or cache is empty.")
	end
end

function applyPreset(presetName)
	local buildingsInPreset = presets[presetName]
	if not buildingsInPreset then
		gg.alert("Error: Preset '" .. presetName .. "' not found.")
		return
	end
	if not isInitialized then
		if not initializeScript() then
			gg.alert("⚠️ Initialization failed. Cannot apply preset.")
			return
		end
	end
	if not factorySlotsCached then
		if not cacheFactorySlots() then
			return
		end
	end
	revertFactoryChanges2(false)
	gg.toast("Applying preset: " .. presetName)
	gg.setVisible(false)
	local notFoundCount, successCount = 0, 0
	local changesToApply = {}
	for i, building in ipairs(buildingsInPreset) do
		local buildingInfo = buildingDatabase[building.id]
		if buildingInfo then
			local itemData = factoryItemsCache[i]
			if itemData then
				table.insert(
					changesToApply,
					{ address = itemData.address, flags = gg.TYPE_QWORD, value = buildingInfo.pointer }
				)
				itemData.currentBuildingId = building.id
				successCount = successCount + 1
			end
		else
			notFoundCount = notFoundCount + 1
		end
	end
	if #changesToApply > 0 then
		gg.setValues(changesToApply)
	end
	gg.setVisible(true)
	if successCount > 0 then
		gg.alert(
			"✅ Preset '" .. presetName .. "' applied!\n" .. successCount .. " buildings have been set to the factory."
		)
	else
		gg.alert("❌ Failed to apply preset. Could not find factory slots in memory.")
	end
	if notFoundCount > 0 then
		gg.alert(notFoundCount .. " building(s) from the preset were not found and were skipped.")
	end
end

function initializeScript()
	gg.setVisible(false)
	local function findPointers(correctListStart)
		local toget_pointers = {}
		for i = 1, 5000 do
			toget_pointers[i] = { address = correctListStart.address + (i - 1) * 8, flags = gg.TYPE_QWORD }
		end
		local pResults = gg.getValues(toget_pointers)
		local aRDC = {}
		for _, r in ipairs(pResults) do
			if r.value and r.value ~= 0 then
				table.insert(aRDC, { address = r.value + 0x50, flags = gg.TYPE_DWORD, op = r.value })
			else
				break
			end
		end
		if #aRDC == 0 then
			return 0, 0
		end
		local cR = gg.getValues(aRDC)
		local foundCount, totalInList = 0, #aRDC
		buildingDatabase = {}
		for i, r in ipairs(cR) do
			if r.value then
				buildingDatabase[r.value] = { name = PYRAMID_BUILDING_MAP[r.value], pointer = aRDC[i].op }
				if PYRAMID_BUILDING_MAP[r.value] then
					foundCount = foundCount + 1
				end
			end
		end
		return foundCount, totalInList
	end
	gg.setRanges(gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS | gg.REGION_OTHER)
	gg.clearResults()
	gg.searchNumber("448264947", gg.TYPE_DWORD)
	local initialResults = gg.getResults(gg.getResultsCount())
	if #initialResults == 0 then
		gg.alert("Error: Initial value 448264947 not found.")
		gg.setVisible(true)
		return false
	end
	local addressesToReadPtr1 = {}
	for _, result in ipairs(initialResults) do
		table.insert(addressesToReadPtr1, { address = result.address - 0x8, flags = gg.TYPE_QWORD })
	end
	local firstPointers = gg.getValues(addressesToReadPtr1)
	local addressesToReadPtr2 = {}
	for _, ptr1 in ipairs(firstPointers) do
		if ptr1.value and ptr1.value ~= 0 then
			table.insert(addressesToReadPtr2, { address = ptr1.value + 0x4, flags = gg.TYPE_QWORD })
		end
	end
	if #addressesToReadPtr2 == 0 then
		gg.alert("Error: No valid sources found after first validation.")
		gg.setVisible(true)
		return false
	end
	local secondPointers = gg.getValues(addressesToReadPtr2)
	local validSources = {}
	for i, ptr2 in ipairs(secondPointers) do
		if ptr2.value and ptr2.value == 7235441155891999603 then
			table.insert(validSources, initialResults[i].address - 0x50)
		end
	end
	if #validSources == 0 then
		gg.alert("Error: No valid sources found after second validation.")
		gg.setVisible(true)
		return false
	end
	local possibleLists = {}
	for i, sourceAddr in ipairs(validSources) do
		gg.clearResults()
		gg.searchNumber(string.format("%Xh", sourceAddr), gg.TYPE_QWORD)
		gg.setVisible(false)
		local pSearchResults = gg.getResults(gg.getResultsCount())
		for _, pResult in ipairs(pSearchResults) do
			table.insert(possibleLists, pResult)
		end
	end
	if #possibleLists == 0 then
		gg.alert("❌ No building list was found.")
		gg.setVisible(true)
		return false
	end
	local totalKnownIds = 0
	for _ in pairs(PYRAMID_BUILDING_MAP) do
		totalKnownIds = totalKnownIds + 1
	end
	for i, listStart in ipairs(possibleLists) do
		local foundCount, totalInList = findPointers(listStart)
		if totalInList >= 2500 and foundCount == totalKnownIds then
			gg.setVisible(true)
			gg.clearResults()
			gg.toast(string.format("✅ Initialization Complete. Found %d of %d buildings.", foundCount, totalKnownIds))
			isInitialized = true
			return true
		end
	end
	gg.setVisible(true)
	gg.alert("❌ Initialization failed. Could not find a list containing all required buildings.")
	return false
end

function showBoosterInfo()
	local infoLines = {}
	local isFactorySet = false
	for i = 1, 7 do
		local cacheItem = factoryItemsCache[i]
		if cacheItem and cacheItem.currentBuildingId then
			isFactorySet = true
			local buildingId = cacheItem.currentBuildingId
			local foundPresetName = nil
			for presetName, buildingList in pairs(presets) do
				for j, buildingData in ipairs(buildingList) do
					if buildingData.id == buildingId and i == j then
						foundPresetName = presetName
						break
					end
				end
				if foundPresetName then
					break
				end
			end
			local boosterName = "Unknown"
			if foundPresetName and boosterMappings[foundPresetName] and boosterMappings[foundPresetName][i] then
				boosterName = boosterMappings[foundPresetName][i].name
			end
			table.insert(infoLines, (factoryItemsMenuDefault[i] or "Slot " .. i) .. " --> " .. boosterName)
		end
	end
	if not isFactorySet then
		gg.alert("You must set a building in the factory first.")
		return
	end
	local emojiLines =
		{ "(🧶) (🔩)    (🌱) (    )", "(     ) (🪵)    (💎) (    )", "(     ) (💳)    (🧪) (    )" }
	local alertText = "Current Booster Mapping:\n\n"
		.. table.concat(emojiLines, "\n")
		.. "\n\n"
		.. table.concat(infoLines, "\n")
	gg.alert(alertText)
end

function performDirectConversion(conversionMap)
	if not isInitialized then
		if not initializeScript() then
			gg.alert("Falha na inicialização. Não é possível converter.")
			return
		end
	end

	local changesToApply = {}
	local successCount = 0

	for _, conversion in ipairs(conversionMap) do
		local buildingId = conversion.buildingId
		local boosterId = conversion.boosterId

		local buildingInfo = buildingDatabase[buildingId]

		if buildingInfo and buildingInfo.pointer then
			table.insert(changesToApply, {
				address = buildingInfo.pointer + 0x50,
				value = boosterId,
				flags = gg.TYPE_DWORD,
			})
			successCount = successCount + 1
		end
	end

	if #changesToApply > 0 then
		gg.setValues(changesToApply)
		gg.alert(string.format("✅ Done! Restart the game to apply changes.", successCount))
	else
		gg.alert("❌ Error, restart game and try again.")
	end
end

function convertBuildingsMenu()
	while true do
		local menuItems = {
			"1️⃣ Level I Boosters",
			"2️⃣ Level II Boosters",
			"3️⃣ Level III Boosters",
			"💥 Convert ALL BOOSTERS 💥",
			"↩️ Back",
		}
		local choice = gg.choice(menuItems, nil, "🎯 Select Booster Level to Convert")
		if choice == nil then
			gg.setVisible(false)
			while not gg.isVisible() do
				gg.sleep(100)
			end
		else
			local selectedOption = menuItems[choice]
			if selectedOption == "↩️ Back" then
				return
			end
			if selectedOption == "💥 Convert ALL BOOSTERS 💥" then
				local conversionMap = {}
				for presetName, buildings in pairs(presets) do
					local boosters = boosterMappings[presetName]
					if boosters then
						for i, building in ipairs(buildings) do
							if boosters[i] then
								table.insert(conversionMap, { buildingId = building.id, boosterId = boosters[i].id })
							end
						end
					end
				end
				performDirectConversion(conversionMap)
			else
				local presetName
				if selectedOption == "1️⃣ Level I Boosters" then
					presetName = "1️⃣ Buildings Level I"
				elseif selectedOption == "2️⃣ Level II Boosters" then
					presetName = "2️⃣ Buildings Level II"
				else
					presetName = "3️⃣ Buildings Level III"
				end
				local boostersForLevel = boosterMappings[presetName]
				local buildingsInPreset = presets[presetName]
				local multiChoiceItems, conversionMapping = {}, {}
				for i = 1, #boostersForLevel do
					table.insert(
						multiChoiceItems,
						(PYRAMID_BUILDING_MAP[buildingsInPreset[i].id] or "Unk Building")
							.. " -> "
							.. (boostersForLevel[i].name or "Unk Booster")
					)
					conversionMapping[i] = { buildingId = buildingsInPreset[i].id, boosterId = boostersForLevel[i].id }
				end
				local selections = gg.multiChoice(
					multiChoiceItems,
					nil,
					"The buildings you collected will turn into the selected boosters"
				)
				if not selections then
					goto continue_loop
				end
				local conversionMap = {}

				for i, wasSelected in pairs(selections) do
					if wasSelected then
						table.insert(conversionMap, conversionMapping[i])
					end
				end

				if #conversionMap > 0 then
					performDirectConversion(conversionMap)
				else
					gg.toast("No conversions selected.")
				end
			end
		end
		::continue_loop::
	end
end

function levelsMenu()
	while true do
		local menuItems = {
			"1️⃣ Buildings Level I",
			"2️⃣ Buildings Level II",
			"3️⃣ Buildings Level III",
			"📜 What boosters will I get?",
			"↩️ Back",
		}
		local choice = gg.choice(menuItems, nil, "🏗️ Select Level")
		if choice == nil then
			gg.setVisible(false)
			while not gg.isVisible() do
				gg.sleep(100)
			end
		else
			local selectedOption = menuItems[choice]
			if selectedOption == "↩️ Back" then
				return
			elseif selectedOption == "📜 What boosters will I get?" then
				showBoosterInfo()
			else
				applyPreset(selectedOption)
			end
		end
	end
end

function warBoostersMenu()
	while true do
		local menuItems = {
			"❓ Help",
			"🏭 Set Buildings to Factory",
			"🔧 Convert Buildings into Boosters",
			menuOptions.productionAmount.text,
			"♻️ Revert Factory",
			"↩️ Back",
		}
		local choice = gg.choice(menuItems, nil, "⚔️ War Boosters Menu")
		if choice == nil then
			gg.setVisible(false)
			while not gg.isVisible() do
				gg.sleep(100)
			end
		else
			local selectedOption = menuItems[choice]
			if selectedOption == "↩️ Back" then
				return
			elseif selectedOption == "🏭 Set Buildings to Factory" then
				levelsMenu()
			elseif selectedOption == "🔧 Convert Buildings into Boosters" then
				convertBuildingsMenu()
			elseif selectedOption == menuOptions.productionAmount.text then
				gg.alert(
					[[
⚠️ WARNING ⚠️

This will change the production amount for ALL items (factory, stores, etc.).

After collecting your buildings, remember to set this back to a low number (like 1) to avoid accidentally filling your storage to the limit (1800).
]],
					"OK, I understand"
				)
				setamountcool()
			elseif selectedOption == "♻️ Revert Factory" then
				revertFactoryChanges2(true)
			elseif selectedOption == "❓ Help" then
				gg.alert([[
⚠️ ALERT ⚠️

This script converts buildings into boosters.

First, produce up to 280 buildings (make sure not to exceed 280 boosters, so, make sure you have room for that many of each booster. We do not recommend making any if your booster already shows 99+).

>>Also be sure to NOT have any buildings currently under active construction, like the airport of Vu tower<<

After producing the buildings, leave them stored and click convert buildings into boosters. Wait for GameGuardian to process and instruct you to restart the game. The buildings will be converted to boosters once you restart the game.
]])
			end
		end
	end
end

function maxdepo()
	gg.setVisible(false)
	gg.clearResults()
	gg.clearList()

	local success = pcall(function()
		gg.searchNumber(": Future_CityDepo", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1)
		gg.refineNumber("32", gg.TYPE_BYTE)
		local results = gg.getResults(gg.getResultsCount())
		if #results == 0 then
			return
		end

		local offsetResults = {}
		for i, v in ipairs(results) do
			table.insert(offsetResults, {
				address = v.address + 0x18,
				flags = gg.TYPE_DWORD,
			})
		end

		offsetResults = gg.getValues(offsetResults)
		gg.clearList()
		gg.addListItems(offsetResults)
		for i = 1, #offsetResults do
			offsetResults[i].value = -179140214
		end
		gg.setValues(offsetResults)
	end)

	gg.toast("go to daniel city and come back")
	if not success then
		return
	end
	gg.clearList()
	gg.clearResults()
end

function removeWarCardItem()
	local RootPointerBits =
		"h F3 53 BE A9 F3 03 00 AA FE 0B 00 F9 14 EC 40 F9 40 8C 00 B0 00 00 35 91 60 02 00 F9 94 01 00 B4"
	gg.toast("Loading root pointer...")
	gg.setVisible(false)
	gg.clearResults()
	gg.searchNumber(RootPointerBits, gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
	if gg.getResultsCount() < 1 then
		gg.alert("Root pointer not found, the script cannot continue.")
		os.exit()
	end
	gg.refineNumber(-13, gg.TYPE_BYTE)
	local buffer = gg.getResults(1)
	gg.clearResults()
	gg.searchNumber(buffer[1].address, gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
	local buffer = gg.getResults(gg.getResultsCount())
	RootPointer = buffer[1].address
	gg.clearResults()
	gg.toast("Root pointer loaded!")
	local warcardRootPtr = RootPointer + 0x63698
	gg.searchNumber(warcardRootPtr, gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
	local warcardBaseAddress = gg.getResults(gg.getResultsCount())
	gg.clearResults()
	local toSet = {}
	for i = 1, #warcardBaseAddress do
		for j = 1, 3 do
			toSet[j] = {
				address = warcardBaseAddress[i].address + 0x288 + ((j - 1) * 8),
				flags = gg.TYPE_QWORD,
				value = 0,
			}
		end
		gg.setValues(toSet)
	end
	gg.toast("Done! War card items are no longer required.")
end

function limits()
	gg.alert([[
📋 LIMITS AND RECOMMENDATIONS
━━━━━━━━━━━━━━━━━━━━━━
💰 -CURRENCIES-
Simoleons: 18,000,000  
Neosimoleons: 18,000,000  
Plat & Golden Keys: 500  
Simcash: 49,000  
Golden Tickets: 100,000  
Seasonal Currency: 18,000,000 
Rail Simoleons: 2,000,000  
Blueprint Design: 100,000  
Rail Tokens: 1,203  

🚫 -DO NOT COLLECT NEOSIMOLEONS BEFORE LEVEL 30!-
━━━━━━━━━━━━━━━━━━━━━━

📦 -BUILDINGS & POPULATION-
Buildings: ❓ unknown  
Population: I tested up to 10M, but only use to unlock  things  
XP from Metal: do not go beyond level 99
━━━━━━━━━━━━━━━━━━━━━━
🎫 -PASSES-
Mayor Pass:  
• Collect all rewards before unlocking again  
• Max 3 unlocks AND I would recommend don't do more than once

Vu Pass:  
• Same rules as Mayor Pass 

Premium Mayor and Vu Pass:
• Only unlock ONCE, after you reset the game it will be
locked again so unlock ONCE and collect all rewards before exiting the game

━━━━━━━━━━━━━━━━━━━━━━
🪖 -WAR CARDS-
Max 280 at a time  
(Reset game to do more 280)

📈 -WAR CARD UPGRADES-
To level 7:  
• Requirements:
  - DO NOT UPGRADE WHILE AT WAR
  - ANY CITY AGE

• Steps:
  - 280 cards  
  - Reset game  
  -Do 40 request  
  -Upgrade to 7

To level 20:  
• Requirements:  
  - City age: 90+ days  
  - War rank: 3+  
  - DO NOT UPGRADE WHILE AT WAR

• Steps:  
  - 280 cards  
  - Reset game  
  - 40 request → level 7  
  - 280 cards  
  - Reset game  
  - 40 request → level 14  
  - 280 cards  
  - Reset game
  - Upgrade to 19  
  - 🚨⚠️ -RESET GAME BEFORE LEVELING TO 20
  - 40 request 
  - Upgrade to 20

━━━━━━━━━━━━━━━━━━━━━━
🚆 -TRAIN CARDS & UPGRADES-
Train Cards:
• Most needs only 678 to max  
• Some (Northwest railways, SC Line 9001) needs 715  
• E5 Super Sim needs 835  

Train Upgrades:  
• No limits, no requirements
• 🔼 Max train wallet first (recommended)

━━━━━━━━━━━━━━━━━━━━━━
 🪖 -WAR BOOSTERS-
Don't do more than 280 pieces at once, so:
Do 280, reset game, do more 280 if needed.

I would recommend not to have more than 150 boosters of one type stored.
━━━━━━━━━━━━━━━━━━━━━━
]])
end

local isBuildingToolInitialized = false
local buildingDatabase = {}
local factoryItemsCache = {}
local validatedTargetAddresses = {}
local cachedPassBases = nil

local buildingNameById = {
	[448264947] = "Tier 0 Residencial Zone",
	[1522778645] = "Tier 1 Residencial Zone",
	[1522778646] = "Tier 2 Residencial Zone",
	[1522778647] = "Tier 3 Residencial Zone",
	[1522778648] = "Tier 4 Residencial Zone",
	[1522778649] = "Tier 5 Residencial Zone",
	[1522778650] = "Tier 6 Residencial Zone",
	[-863499632] = "Tier 0 Tokyo Town Zone",
	[1297585906] = "Tier 1 Tokyo Town Zone",
	[1336721299] = "Tier 2 Tokyo Town Zone",
	[1375856692] = "Tier 3 Tokyo Town Zone",
	[1414992085] = "Tier 4 Tokyo Town Zone",
	[1454127478] = "Tier 5 Tokyo Town Zone",
	[1493262871] = "Tier 6 Tokyo Town Zone",
	[1586435345] = "Tier 0 Parisian Zone",
	[-112185933] = "Tier 1 Parisian Zone",
	[1179282036] = "Tier 2 Parisian Zone",
	[-1824217291] = "Tier 3 Parisian Zone",
	[-532749322] = "Tier 4 Parisian Zone",
	[758718647] = "Tier 5 Parisian Zone",
	[2050186616] = "Tier 6 Parisian Zone",
	[672670940] = "Tier 0 London Zone",
	[452743614] = "Tier 1 London Zone",
	[121513631] = "Tier 2 London Zone",
	[-209716352] = "Tier 3 London Zone",
	[-540946335] = "Tier 4 London Zone",
	[-872176318] = "Tier 5 London Zone",
	[-1203406301] = "Tier 6 London Zone",
	[1412927788] = "Tier 0 Green Valley Zone",
	[1162567438] = "Tier 1 Green Valley Zone",
	[1983822959] = "Tier 2 Green Valley Zone",
	[-1489888816] = "Tier 3 Green Valley Zone",
	[-668633295] = "Tier 4 Green Valley Zone",
	[152622226] = "Tier 5 Green Valley Zone",
	[973877747] = "Tier 6 Green Valley Zone",
	[347909465] = "Tier 0 Cactus Canyon Zone",
	[127982139] = "Tier 1 Cactus Canyon Zone",
	[-203247844] = "Tier 2 Cactus Canyon Zone",
	[-534477827] = "Tier 3 Cactus Canyon Zone",
	[-865707810] = "Tier 4 Cactus Canyon Zone",
	[-1196937793] = "Tier 5 Cactus Canyon Zone",
	[-1528167776] = "Tier 6 Cactus Canyon Zone",
	[655828466] = "Tier 0 Sunny Isles Zone",
	[435901140] = "Tier 1 Sunny Isles Zone",
	[104671157] = "Tier 2 Sunny Isles Zone",
	[-226558826] = "Tier 3 Sunny Isles Zone",
	[-557788809] = "Tier 4 Sunny Isles Zone",
	[-889018792] = "Tier 5 Sunny Isles Zone",
	[-1220248775] = "Tier 6 Sunny Isles Zone",
	[1574896583] = "Tier 0 Frosty Fjords Zone",
	[-123724695] = "Tier 1 Frosty Fjords Zone",
	[1167743274] = "Tier 2 Frosty Fjords Zone",
	[-1835756053] = "Tier 3 Frosty Fjords Zone",
	[-544288084] = "Tier 4 Frosty Fjords Zone",
	[747179885] = "Tier 5 Frosty Fjords Zone",
	[2038647854] = "Tier 6 Frosty Fjords Zone",
	[-1855207166] = "Tier 0 Limestone Cliff Zone",
	[1651270308] = "Tier 1 Limestone Cliff Zone",
	[-406251547] = "Tier 2 Limestone Cliff Zone",
	[1831193894] = "Tier 3 Limestone Cliff Zone",
	[-226327961] = "Tier 4 Limestone Cliff Zone",
	[2011117480] = "Tier 5 Limestone Cliff Zone",
	[-46404375] = "Tier 6 Limestone Cliff Zone",
	[-1881032550] = "Turtle Education Epic",
	[-1881032549] = "Llama Education Epic",
	[-1881032548] = "Cheetah Education Epic",
	[-691412737] = "Turtle Gambling Epic",
	[-691412736] = "Llama Gambling Epic",
	[-691412735] = "Cheetah Gambling Epic",
	[-447372292] = "Turtle Entertainment Epic",
	[-447372291] = "Llama Entertainment Epic",
	[-447372290] = "Cheetah Entertainment Epic",
	[1813794918] = "Turtle Transportation Epic",
	[1813794919] = "Llama Transportation Epic",
	[1813794920] = "Cheetah Transportation Epic",
	[-113962680] = "Turtle Landmark Epic",
	[-113962679] = "Llama Landmark Epic",
	[-113962678] = "Cheetah Landmark Epic",
	[-1999290447] = "Turtle Beach Epic",
	[-1999290446] = "Llama Beach Epic",
	[-1999290445] = "Cheetah Beach Epic",
	[995463177] = "Turtle Mountain Epic",
	[995463178] = "Llama Mountain Epic",
	[995463179] = "Cheetah Mountain Epic",
	[-2014094902] = "Turtle Space Epic",
	[-2014094901] = "Llama Space Epic",
	[-2014094900] = "Cheetah Space Epic",
	[445208333] = "Tier 0 Omega Residence",
	[225281007] = "Tier 1 Omega Residence",
	[-105948976] = "Tier 2 Omega Residence",
	[-437178959] = "Tier 3 Omega Residence",
	[-768408942] = "Tier 4 Omega Residence",
	[-1099638925] = "Tier 5 Omega Residence",
	[-1430868908] = "Tier 6 Omega Residence",
	[1581693834] = "Tier 0 Latin America Zone",
	[-116927444] = "Tier 1 Latin America Zone",
	[1174540525] = "Tier 2 Latin America Zone",
	[-1828958802] = "Tier 3 Latin America Zone",
	[-537490833] = "Tier 4 Latin America Zone",
	[1647433881] = "Tier 0 Old Town House",
	[-1630222853] = "Tier 1 Old Town House",
	[-1562421476] = "Tier 2 Old Town House",
	[-979789707] = "Tier 0 Art Nouveau Zone",
	[352543127] = "Tier 1 Art Nouveau Zone",
	[-1988111720] = "Tier 2 Art Nouveau Zone",
	[-33799271] = "Tier 3 Art Nouveau Zone",
	[1920513178] = "Tier 4 Art Nouveau Zone",
	[562571616] = "Tier 0 Florentine Zone",
	[1579882178] = "Tier 1 Florentine Zone",
	[1647683555] = "Tier 2 Florentine Zone",
	[1715484932] = "Tier 3 Florentine Zone",
	[1783286309] = "Tier 4 Florentine Zone",
	[1581365320] = "Tier 0 Kyoto Zone",
	[-117255958] = "Tier 1 Kyoto Zone",
	[1174212011] = "Tier 2 Kyoto Zone",
	[-1829287316] = "Tier 3 Kyoto Zone",
	[-537819347] = "Tier 4 Kyoto Zone",
	[385991488] = "Tier 0 Cozy Homes",
	[-402498334] = "Tier 1 Cozy Homes",
	[1834947107] = "Tier 2 Cozy Homes",
	[-222574748] = "Tier 3 Cozy Homes",
	[2014870693] = "Tier 4 Cozy Homes",
	[-1664598021] = "Building Progress 1",
	[-999348963] = "Building Progress 2",
	[-999348962] = "Building Progress 3",
	[-999348961] = "Building Progress 4",
	[417978686] = "Building Progress 5",
	[-1715236448] = "Building Progress 6",
	[-1715236447] = "Building Progress 7",
	[-1715236446] = "Building Progress 8",
	[751144117] = "Wind Power Plant (Level 1)",
	[751144118] = "Wind Power Plant (Level 2)",
	[751144119] = "Wind Power Plant (Level 3)",
	[43959869] = "Deluxe Wind Power Plant (Level 1)",
	[43959870] = "Deluxe Wind Power Plant (Level 2)",
	[43959871] = "Deluxe Wind Power Plant (Level 3)",
	[43959872] = "Deluxe Wind Power Plant (Level 4)",
	[43959873] = "Deluxe Wind Power Plant (Level 5)",
	[-1297331478] = "Coal Power Plant (Level 1)",
	[-1297331477] = "Coal Power Plant (Level 2)",
	[-1297331476] = "Coal Power Plant (Level 3)",
	[-1548024564] = "Solar Power Plant (Level 1)",
	[-1548024563] = "Solar Power Plant (Level 2)",
	[-1548024562] = "Solar Power Plant (Level 3)",
	[-1548024561] = "Solar Power Plant (Level 4)",
	[-1548024560] = "Solar Power Plant (Level 5)",
	[270223151] = "Oil Power Plant (Level 1)",
	[270223152] = "Oil Power Plant (Level 2)",
	[270223153] = "Oil Power Plant (Level 3)",
	[270223154] = "Oil Power Plant (Level 4)",
	[270223155] = "Oil Power Plant (Level 5)",
	[1180238005] = "Nuclear Power Plant (Level 1)",
	[1180238006] = "Nuclear Power Plant (Level 2)",
	[1180238007] = "Nuclear Power Plant (Level 3)",
	[1180238008] = "Nuclear Power Plant (Level 4)",
	[1180238009] = "Nuclear Power Plant (Level 5)",
	[1180238010] = "Nuclear Power Plant (Level 6)",
	[1180238011] = "Nuclear Power Plant (Level 7)",
	[1180238012] = "Nuclear Power Plant (Level 8)",
	[287398143] = "Fusion Power Plant (Level 1)",
	[287398144] = "Fusion Power Plant (Level 2)",
	[287398145] = "Fusion Power Plant (Level 3)",
	[287398146] = "Fusion Power Plant (Level 4)",
	[287398147] = "Fusion Power Plant (Level 5)",
	[287398148] = "Fusion Power Plant (Level 6)",
	[287398149] = "Fusion Power Plant (Level 7)",
	[287398150] = "Fusion Power Plant (Level 8)",
	[287398151] = "Fusion Power Plant (Level 9)",
	[894204175] = "Fusion Power Plant (Level 10)",
	[-857301703] = "Omega Power Plant (Level 1)",
	[-857301702] = "Omega Power Plant (Level 2)",
	[-857301701] = "Omega Power Plant (Level 3)",
	[-857301700] = "Omega Power Plant (Level 4)",
	[-857301699] = "Omega Power Plant (Level 5)",
	[-857301698] = "Omega Power Plant (Level 6)",
	[-857301697] = "Omega Power Plant (Level 7)",
	[-857301696] = "Omega Power Plant (Level 8)",
	[-857301695] = "Omega Power Plant (Level 9)",
	[1773814921] = "Omega Power Plant (Level 10)",
	[882105506] = "Eco Power Plant (Level 1)",
	[882105507] = "Eco Power Plant (Level 2)",
	[882105508] = "Eco Power Plant (Level 3)",
	[882105509] = "Eco Power Plant (Level 4)",
	[882105510] = "Eco Power Plant (Level 5)",
	[882105511] = "Eco Power Plant (Level 6)",
	[882105512] = "Eco Power Plant (Level 7)",
	[882105513] = "Eco Power Plant (Level 8)",
	[882105514] = "Eco Power Plant (Level 9)",
	[-955289326] = "Eco Power Plant (Level 10)",
	[-752911844] = "Earth Day Solar Power Plant (Level 1)",
	[-752911843] = "Earth Day Solar Power Plant (Level 2)",
	[-752911842] = "Earth Day Solar Power Plant (Level 3)",
	[-752911841] = "Earth Day Solar Power Plant (Level 4)",
	[-752911840] = "Earth Day Solar Power Plant (Level 5)",
	[-752911839] = "Earth Day Solar Power Plant (Level 6)",
	[-752911838] = "Earth Day Solar Power Plant (Level 7)",
	[-752911837] = "Earth Day Solar Power Plant (Level 8)",
	[-752911836] = "Earth Day Solar Power Plant (Level 9)",
	[923712972] = "Earth Day Solar Power Plant (Level 10)",
	[1064573543] = "Geothermal Power Plant (Level 1)",
	[1064573544] = "Geothermal Power Plant (Level 2)",
	[1064573545] = "Geothermal Power Plant (Level 3)",
	[1064573546] = "Geothermal Power Plant (Level 4)",
	[1064573547] = "Geothermal Power Plant (Level 5)",
	[1064573548] = "Geothermal Power Plant (Level 6)",
	[1064573549] = "Geothermal Power Plant (Level 7)",
	[1064573550] = "Geothermal Power Plant (Level 8)",
	[1064573551] = "Geothermal Power Plant (Level 9)",
	[1900179467] = "Geothermal Power Plant (Level 10)",
	[-2001261127] = "Concentrated Solar Power Plant (Level 1)",
	[-2001261126] = "Concentrated Solar Power Plant (Level 2)",
	[-2001261125] = "Concentrated Solar Power Plant (Level 3)",
	[-2001261124] = "Concentrated Solar Power Plant (Level 4)",
	[-2001261123] = "Concentrated Solar Power Plant (Level 5)",
	[-2001261122] = "Concentrated Solar Power Plant (Level 6)",
	[-2001261121] = "Concentrated Solar Power Plant (Level 7)",
	[-2001261120] = "Concentrated Solar Power Plant (Level 8)",
	[-2001261119] = "Concentrated Solar Power Plant (Level 9)",
	[-747375459] = "Concentrated Solar Power Plant (Level 10)",
	[139346164] = "Basic Water Tower (Level 1)",
	[139346165] = "Basic Water Tower (Level 2)",
	[139346166] = "Basic Water Tower (Level 3)",
	[1575951748] = "Water Pumping Station (Level 1)",
	[1575951749] = "Water Pumping Station (Level 2)",
	[1575951750] = "Water Pumping Station (Level 3)",
	[1575951751] = "Water Pumping Station (Level 4)",
	[1575951752] = "Water Pumping Station (Level 5)",
	[-1678777763] = "Saltwater Treatment (Level 1)",
	[-1678777762] = "Saltwater Treatment (Level 2)",
	[-1678777761] = "Saltwater Treatment (Level 3)",
	[-1678777760] = "Saltwater Treatment (Level 4)",
	[-1678777759] = "Saltwater Treatment (Level 5)",
	[-1678777758] = "Saltwater Treatment (Level 6)",
	[-1678777757] = "Saltwater Treatment (Level 7)",
	[-320582719] = "Saltwater Treatment (Level 8)",
	[1551205035] = "Fresh Water Pumping Station (Level 1)",
	[1551205036] = "Fresh Water Pumping Station (Level 2)",
	[1551205037] = "Fresh Water Pumping Station (Level 3)",
	[1551205038] = "Fresh Water Pumping Station (Level 4)",
	[1551205039] = "Fresh Water Pumping Station (Level 5)",
	[1551205040] = "Fresh Water Pumping Station (Level 6)",
	[1551205041] = "Fresh Water Pumping Station (Level 7)",
	[1551205042] = "Fresh Water Pumping Station (Level 8)",
	[1551205043] = "Fresh Water Pumping Station (Level 9)",
	[1575952079] = "Fresh Water Pumping Station (Level 10)",
	[-1257426322] = "Omega Water Tower (Level 1)",
	[-1257426321] = "Omega Water Tower (Level 2)",
	[-1257426320] = "Omega Water Tower (Level 3)",
	[-1257426319] = "Omega Water Tower (Level 4)",
	[-1257426318] = "Omega Water Tower (Level 5)",
	[-1257426317] = "Omega Water Tower (Level 6)",
	[-1257426316] = "Omega Water Tower (Level 7)",
	[-1257426315] = "Omega Water Tower (Level 8)",
	[-1257426314] = "Omega Water Tower (Level 9)",
	[1454604382] = "Omega Water Tower (Level 10)",
	[182280403] = "Small Sewage Outflow Pipe (Level 1)",
	[182280404] = "Small Sewage Outflow Pipe (Level 2)",
	[182280405] = "Small Sewage Outflow Pipe (Level 3)",
	[182280406] = "Small Sewage Outflow Pipe (Level 4)",
	[182280407] = "Small Sewage Outflow Pipe (Level 5)",
	[-12118437] = "Basic Sewage Outflow Pipe (Level 1)",
	[-12118436] = "Basic Sewage Outflow Pipe (Level 2)",
	[-12118435] = "Basic Sewage Outflow Pipe (Level 3)",
	[-12118434] = "Basic Sewage Outflow Pipe (Level 4)",
	[-12118433] = "Basic Sewage Outflow Pipe (Level 5)",
	[-12118432] = "Basic Sewage Outflow Pipe (Level 6)",
	[-12118431] = "Basic Sewage Outflow Pipe (Level 7)",
	[-12118430] = "Basic Sewage Outflow Pipe (Level 8)",
	[175875598] = "Deluxe Sewage Treatment Plant (Level 1)",
	[175875599] = "Deluxe Sewage Treatment Plant (Level 2)",
	[175875600] = "Deluxe Sewage Treatment Plant (Level 3)",
	[175875601] = "Deluxe Sewage Treatment Plant (Level 4)",
	[175875602] = "Deluxe Sewage Treatment Plant (Level 5)",
	[175875603] = "Deluxe Sewage Treatment Plant (Level 6)",
	[175875604] = "Deluxe Sewage Treatment Plant (Level 7)",
	[175875605] = "Deluxe Sewage Treatment Plant (Level 8)",
	[175875606] = "Deluxe Sewage Treatment Plant (Level 9)",
	[1508927486] = "Deluxe Sewage Treatment Plant (Level 10)",
	[-212043960] = "Omega Sewage Treatment Plant (Level 1)",
	[-212043959] = "Omega Sewage Treatment Plant (Level 2)",
	[-212043958] = "Omega Sewage Treatment Plant (Level 3)",
	[-212043957] = "Omega Sewage Treatment Plant (Level 4)",
	[-212043956] = "Omega Sewage Treatment Plant (Level 5)",
	[-212043955] = "Omega Sewage Treatment Plant (Level 6)",
	[-212043954] = "Omega Sewage Treatment Plant (Level 7)",
	[-212043953] = "Omega Sewage Treatment Plant (Level 8)",
	[-212043952] = "Omega Sewage Treatment Plant (Level 9)",
	[1592483960] = "Omega Sewage Treatment Plant (Level 10)",
	[1074415607] = "High Tech Sewage Tower (Level 1)",
	[1074415608] = "High Tech Sewage Tower (Level 2)",
	[1074415609] = "High Tech Sewage Tower (Level 3)",
	[1074415610] = "High Tech Sewage Tower (Level 4)",
	[1074415611] = "High Tech Sewage Tower (Level 5)",
	[1074415612] = "High Tech Sewage Tower (Level 6)",
	[1074415613] = "High Tech Sewage Tower (Level 7)",
	[1074415614] = "High Tech Sewage Tower (Level 8)",
	[1074415615] = "High Tech Sewage Tower (Level 9)",
	[-2130901093] = "High Tech Sewage Tower (Level 10)",
	[-1696571358] = "Sewage Reclamation Plant (Level 1)",
	[-1696571357] = "Sewage Reclamation Plant (Level 2)",
	[-1696571356] = "Sewage Reclamation Plant (Level 3)",
	[-1696571355] = "Sewage Reclamation Plant (Level 4)",
	[-1696571354] = "Sewage Reclamation Plant (Level 5)",
	[-1696571353] = "Sewage Reclamation Plant (Level 6)",
	[-1696571352] = "Sewage Reclamation Plant (Level 7)",
	[-1696571351] = "Sewage Reclamation Plant (Level 8)",
	[-1696571350] = "Sewage Reclamation Plant (Level 9)",
	[-12118106] = "Sewage Reclamation Plant (Level 10)",
	[-741284489] = "Small Garbage Dump (Level 1)",
	[-741284488] = "Small Garbage Dump (Level 2)",
	[-741284487] = "Small Garbage Dump (Level 3)",
	[-741284486] = "Small Garbage Dump (Level 4)",
	[-741284485] = "Small Garbage Dump (Level 5)",
	[-935683329] = "Garbage Dump (Level 1)",
	[-935683328] = "Garbage Dump (Level 2)",
	[-935683327] = "Garbage Dump (Level 3)",
	[-935683326] = "Garbage Dump (Level 4)",
	[-935683325] = "Garbage Dump (Level 5)",
	[-1415031897] = "Garbage Incinerator (Level 1)",
	[-1415031896] = "Garbage Incinerator (Level 2)",
	[-1415031895] = "Garbage Incinerator (Level 3)",
	[-1415031894] = "Garbage Incinerator (Level 4)",
	[-1415031893] = "Garbage Incinerator (Level 5)",
	[-1415031892] = "Garbage Incinerator (Level 6)",
	[-1415031891] = "Garbage Incinerator (Level 7)",
	[-1415031890] = "Garbage Incinerator (Level 8)",
	[539569644] = "Recycling Center (Level 1)",
	[-1262937943] = "Recycling Center (Level 2)",
	[-1262937942] = "Recycling Center (Level 3)",
	[-1262937941] = "Recycling Center (Level 4)",
	[-1262937940] = "Recycling Center (Level 5)",
	[-1262937939] = "Recycling Center (Level 6)",
	[-1262937938] = "Recycling Center (Level 7)",
	[-1262937937] = "Recycling Center (Level 8)",
	[-1262937936] = "Recycling Center (Level 9)",
	[1272720856] = "Recycling Center (Level 10)",
	[-535421151] = "Omega Recycling Center (Level 1)",
	[-535421150] = "Omega Recycling Center (Level 2)",
	[-535421149] = "Omega Recycling Center (Level 3)",
	[-535421148] = "Omega Recycling Center (Level 4)",
	[-535421147] = "Omega Recycling Center (Level 5)",
	[-535421146] = "Omega Recycling Center (Level 6)",
	[-535421145] = "Omega Recycling Center (Level 7)",
	[-535421144] = "Omega Recycling Center (Level 8)",
	[-535421143] = "Omega Recycling Center (Level 9)",
	[-489028751] = "Omega Recycling Center (Level 10)",
	[562548413] = "Biodome Waste Facility (Level 1)",
	[562548414] = "Biodome Waste Facility (Level 2)",
	[562548415] = "Biodome Waste Facility (Level 3)",
	[562548416] = "Biodome Waste Facility (Level 4)",
	[562548417] = "Biodome Waste Facility (Level 5)",
	[562548418] = "Biodome Waste Facility (Level 6)",
	[562548419] = "Biodome Waste Facility (Level 7)",
	[562548420] = "Biodome Waste Facility (Level 8)",
	[562548421] = "Biodome Waste Facility (Level 9)",
	[-741567455] = "Biodome Waste Facility (Level 10)",
	[423504366] = "Waste To Energy Plant (Level 1)",
	[423504367] = "Waste To Energy Plant (Level 2)",
	[423504368] = "Waste To Energy Plant (Level 3)",
	[423504369] = "Waste To Energy Plant (Level 4)",
	[423504370] = "Waste To Energy Plant (Level 5)",
	[423504371] = "Waste To Energy Plant (Level 6)",
	[423504372] = "Waste To Energy Plant (Level 7)",
	[423504373] = "Waste To Energy Plant (Level 8)",
	[423504374] = "Waste To Energy Plant (Level 9)",
	[-1415031566] = "Waste To Energy Plant (Level 10)",
	[583140736] = "Small Fire Station (Level 1)",
	[583140737] = "Small Fire Station (Level 2)",
	[583140738] = "Small Fire Station (Level 3)",
	[583140739] = "Small Fire Station (Level 4)",
	[583140740] = "Small Fire Station (Level 5)",
	[388741896] = "Basic Fire Station (Level 1)",
	[388741897] = "Basic Fire Station (Level 2)",
	[388741898] = "Basic Fire Station (Level 3)",
	[388741899] = "Basic Fire Station (Level 4)",
	[388741900] = "Basic Fire Station (Level 5)",
	[1840115986] = "Deluxe Fire Station (Level 1)",
	[1840115987] = "Deluxe Fire Station (Level 2)",
	[1840115988] = "Deluxe Fire Station (Level 3)",
	[1840115989] = "Deluxe Fire Station (Level 4)",
	[1840115990] = "Deluxe Fire Station (Level 5)",
	[1840115991] = "Deluxe Fire Station (Level 6)",
	[1840115992] = "Deluxe Fire Station (Level 7)",
	[1840115993] = "Deluxe Fire Station (Level 8)",
	[-1959048893] = "Fire Service Headquarters (Level 1)",
	[-1959048892] = "Fire Service Headquarters (Level 2)",
	[-1959048891] = "Fire Service Headquarters (Level 3)",
	[-1959048890] = "Fire Service Headquarters (Level 4)",
	[-1959048889] = "Fire Service Headquarters (Level 5)",
	[-1959048888] = "Fire Service Headquarters (Level 6)",
	[-1959048887] = "Fire Service Headquarters (Level 7)",
	[-1959048886] = "Fire Service Headquarters (Level 8)",
	[-1959048885] = "Fire Service Headquarters (Level 9)",
	[-357520281] = "Fire Service Headquarters (Level 10)",
	[-1351265415] = "Grand Fire Station (Level 1)",
	[-1351265414] = "Grand Fire Station (Level 2)",
	[-1351265413] = "Grand Fire Station (Level 3)",
	[-1351265412] = "Grand Fire Station (Level 4)",
	[-1351265411] = "Grand Fire Station (Level 5)",
	[-1351265410] = "Grand Fire Station (Level 6)",
	[-1351265409] = "Grand Fire Station (Level 7)",
	[-1351265408] = "Grand Fire Station (Level 8)",
	[-1351265407] = "Grand Fire Station (Level 9)",
	[1840116317] = "Grand Fire Station (Level 10)",
	[1143813044] = "Chicago Firehouse (Level 1)",
	[1143813045] = "Chicago Firehouse (Level 2)",
	[1143813046] = "Chicago Firehouse (Level 3)",
	[1143813047] = "Chicago Firehouse (Level 4)",
	[1143813048] = "Chicago Firehouse (Level 5)",
	[1143813049] = "Chicago Firehouse (Level 6)",
	[1143813050] = "Chicago Firehouse (Level 7)",
	[1143813051] = "Chicago Firehouse (Level 8)",
	[1143813052] = "Chicago Firehouse (Level 9)",
	[-1566555016] = "Chicago Firehouse (Level 10)",
	[-150077002] = "Small Police Station (Level 1)",
	[-150077001] = "Small Police Station (Level 2)",
	[-150077000] = "Small Police Station (Level 3)",
	[-150076999] = "Small Police Station (Level 4)",
	[-150076998] = "Small Police Station (Level 5)",
	[-1397016258] = "Basic Police Station (Level 1)",
	[-1397016257] = "Basic Police Station (Level 2)",
	[-1397016256] = "Basic Police Station (Level 3)",
	[-1397016255] = "Basic Police Station (Level 4)",
	[-1397016254] = "Basic Police Station (Level 5)",
	[-898048428] = "Police Precint (Level 1)",
	[-898048427] = "Police Precint (Level 2)",
	[-898048426] = "Police Precint (Level 3)",
	[-898048425] = "Police Precint (Level 4)",
	[-898048424] = "Police Precint (Level 5)",
	[-898048423] = "Police Precint (Level 6)",
	[-898048422] = "Police Precint (Level 7)",
	[-898048421] = "Police Precint (Level 8)",
	[-358206684] = "Police Academy (Level 1)",
	[-358206683] = "Police Academy (Level 2)",
	[-358206682] = "Police Academy (Level 3)",
	[-358206681] = "Police Academy (Level 4)",
	[-358206680] = "Police Academy (Level 5)",
	[-358206679] = "Police Academy (Level 6)",
	[-358206678] = "Police Academy (Level 7)",
	[-358206677] = "Police Academy (Level 8)",
	[-358206676] = "Police Academy (Level 9)",
	[1333524968] = "Police Academy (Level 10)",
	[-1905893370] = "Evidence Lab (Level 1)",
	[-1905893369] = "Evidence Lab (Level 2)",
	[-1905893368] = "Evidence Lab (Level 3)",
	[-1905893367] = "Evidence Lab (Level 4)",
	[-1905893366] = "Evidence Lab (Level 5)",
	[-1905893365] = "Evidence Lab (Level 6)",
	[-1905893364] = "Evidence Lab (Level 7)",
	[-1905893363] = "Evidence Lab (Level 8)",
	[-1905893362] = "Evidence Lab (Level 9)",
	[-1361673718] = "Evidence Lab (Level 10)",
	[-770092677] = "Police Headquarters (Level 1)",
	[-770092676] = "Police Headquarters (Level 2)",
	[-770092675] = "Police Headquarters (Level 3)",
	[-770092674] = "Police Headquarters (Level 4)",
	[-770092673] = "Police Headquarters (Level 5)",
	[-770092672] = "Police Headquarters (Level 6)",
	[-770092671] = "Police Headquarters (Level 7)",
	[-770092670] = "Police Headquarters (Level 8)",
	[-770092669] = "Police Headquarters (Level 9)",
	[-898048097] = "Police Headquarters (Level 10)",
	[-66177429] = "Small Health Clinic (Level 1)",
	[-66177428] = "Small Health Clinic (Level 2)",
	[-66177427] = "Small Health Clinic (Level 3)",
	[-66177426] = "Small Health Clinic (Level 4)",
	[-66177425] = "Small Health Clinic (Level 5)",
	[1155556851] = "Health Clinic (Level 1)",
	[1155556852] = "Health Clinic (Level 2)",
	[1155556853] = "Health Clinic (Level 3)",
	[1155556854] = "Health Clinic (Level 4)",
	[1155556855] = "Health Clinic (Level 5)",
	[850245029] = "Hospital (Level 1)",
	[850245030] = "Hospital (Level 2)",
	[850245031] = "Hospital (Level 3)",
	[850245032] = "Hospital (Level 4)",
	[850245033] = "Hospital (Level 5)",
	[850245034] = "Hospital (Level 6)",
	[850245035] = "Hospital (Level 7)",
	[850245036] = "Hospital (Level 8)",
	[-1018686352] = "Medical Research Center (Level 1)",
	[-1018686351] = "Medical Research Center (Level 2)",
	[-1018686350] = "Medical Research Center (Level 3)",
	[-1018686349] = "Medical Research Center (Level 4)",
	[-1018686348] = "Medical Research Center (Level 5)",
	[-1018686347] = "Medical Research Center (Level 6)",
	[-1018686346] = "Medical Research Center (Level 7)",
	[-1018686345] = "Medical Research Center (Level 8)",
	[-1018686344] = "Medical Research Center (Level 9)",
	[1900838580] = "Medical Research Center (Level 10)",
	[870265644] = "Medical Center (Level 1)",
	[870265645] = "Medical Center (Level 2)",
	[870265646] = "Medical Center (Level 3)",
	[870265647] = "Medical Center (Level 4)",
	[870265648] = "Medical Center (Level 5)",
	[870265649] = "Medical Center (Level 6)",
	[870265650] = "Medical Center (Level 7)",
	[870265651] = "Medical Center (Level 8)",
	[870265652] = "Medical Center (Level 9)",
	[850245360] = "Medical Center (Level 10)",
	[-1781885157] = "Egyptian Hospital (Level 1)",
	[-1781885156] = "Egyptian Hospital (Level 2)",
	[-1781885155] = "Egyptian Hospital (Level 3)",
	[-1781885154] = "Egyptian Hospital (Level 4)",
	[-1781885153] = "Egyptian Hospital (Level 5)",
	[-1781885152] = "Egyptian Hospital (Level 6)",
	[-1781885151] = "Egyptian Hospital (Level 7)",
	[-1781885150] = "Egyptian Hospital (Level 8)",
	[-1781885149] = "Egyptian Hospital (Level 9)",
	[1947666751] = "Egyptian Hospital (Level 10)",
	[1357885702] = "Organic Food Stall (Level 1)",
	[-1079837309] = "Organic Food Stall (Level 2)",
	[-1079837308] = "Organic Food Stall (Level 3)",
	[-1079837307] = "Organic Food Stall (Level 4)",
	[-1079837306] = "Organic Food Stall (Level 5)",
	[896635826] = "Organic Food Market (Level 1)",
	[1557131439] = "Organic Food Market (Level 2)",
	[1557131440] = "Organic Food Market (Level 3)",
	[1557131441] = "Organic Food Market (Level 4)",
	[1557131442] = "Organic Food Market (Level 5)",
	[1557131443] = "Organic Food Market (Level 6)",
	[1557131444] = "Organic Food Market (Level 7)",
	[1557131445] = "Organic Food Market (Level 8)",
	[-373820456] = "Deluxe Organic Food Market (Level 1)",
	[672081685] = "Deluxe Organic Food Market (Level 2)",
	[672081686] = "Deluxe Organic Food Market (Level 3)",
	[672081687] = "Deluxe Organic Food Market (Level 4)",
	[672081688] = "Deluxe Organic Food Market (Level 5)",
	[672081689] = "Deluxe Organic Food Market (Level 6)",
	[672081690] = "Deluxe Organic Food Market (Level 7)",
	[672081691] = "Deluxe Organic Food Market (Level 8)",
	[672081692] = "Deluxe Organic Food Market (Level 9)",
	[703859140] = "Deluxe Organic Food Market (Level 10)",
	[-1555242166] = "Tourist Info Booth (Level 1)",
	[-328189625] = "Tourist Info Booth (Level 2)",
	[-328189624] = "Tourist Info Booth (Level 3)",
	[-328189623] = "Tourist Info Booth (Level 4)",
	[-328189622] = "Tourist Info Booth (Level 5)",
	[631816472] = "Tourism Center (Level 1)",
	[-1903432619] = "Tourism Center (Level 2)",
	[-1903432618] = "Tourism Center (Level 3)",
	[-1903432617] = "Tourism Center (Level 4)",
	[-1903432616] = "Tourism Center (Level 5)",
	[-1903432615] = "Tourism Center (Level 6)",
	[-1903432614] = "Tourism Center (Level 7)",
	[-1903432613] = "Tourism Center (Level 8)",
	[1883643952] = "Luxury Tourist Center (Level 1)",
	[-466742163] = "Luxury Tourist Center (Level 2)",
	[-466742162] = "Luxury Tourist Center (Level 3)",
	[-466742161] = "Luxury Tourist Center (Level 4)",
	[-466742160] = "Luxury Tourist Center (Level 5)",
	[-466742159] = "Luxury Tourist Center (Level 6)",
	[-466742158] = "Luxury Tourist Center (Level 7)",
	[-466742157] = "Luxury Tourist Center (Level 8)",
	[-466742156] = "Luxury Tourist Center (Level 9)",
	[1777377820] = "Luxury Tourist Center (Level 10)",
	[-1000687109] = "Geothermal Plant (Level 1)",
	[68640344] = "Geothermal Plant (Level 2)",
	[68640345] = "Geothermal Plant (Level 3)",
	[68640346] = "Geothermal Plant (Level 4)",
	[68640347] = "Geothermal Plant (Level 5)",
	[-2109117053] = "Large Geothermal Heating Plant (Level 1)",
	[-2051554080] = "Large Geothermal Heating Plant (Level 2)",
	[-2051554079] = "Large Geothermal Heating Plant (Level 3)",
	[-2051554078] = "Large Geothermal Heating Plant (Level 4)",
	[-2051554077] = "Large Geothermal Heating Plant (Level 5)",
	[-2051554076] = "Large Geothermal Heating Plant (Level 6)",
	[-2051554075] = "Large Geothermal Heating Plant (Level 7)",
	[-2051554074] = "Large Geothermal Heating Plant (Level 8)",
	[-774727411] = "Deluxe Heating Plant (Level 1)",
	[-1400849366] = "Deluxe Heating Plant (Level 2)",
	[-1400849365] = "Deluxe Heating Plant (Level 3)",
	[-1400849364] = "Deluxe Heating Plant (Level 4)",
	[-1400849363] = "Deluxe Heating Plant (Level 5)",
	[-1400849362] = "Deluxe Heating Plant (Level 6)",
	[-1400849361] = "Deluxe Heating Plant (Level 7)",
	[-1400849360] = "Deluxe Heating Plant (Level 8)",
	[-1400849359] = "Deluxe Heating Plant (Level 9)",
	[1016611193] = "Deluxe Heating Plant (Level 10)",
	[1505075029] = "Small Gas Refill Station (Level 1)",
	[1358265714] = "Small Gas Refill Station (Level 2)",
	[1358265715] = "Small Gas Refill Station (Level 3)",
	[1358265716] = "Small Gas Refill Station (Level 4)",
	[1358265717] = "Small Gas Refill Station (Level 5)",
	[-970400927] = "Big Gas Station (Level 1)",
	[1836436990] = "Big Gas Station (Level 2)",
	[1836436991] = "Big Gas Station (Level 3)",
	[1836436992] = "Big Gas Station (Level 4)",
	[1836436993] = "Big Gas Station (Level 5)",
	[1836436994] = "Big Gas Station (Level 6)",
	[1836436995] = "Big Gas Station (Level 7)",
	[1836436996] = "Big Gas Station (Level 8)",
	[-310535061] = "Deluxe Gas Station (Level 1)",
	[-1373345080] = "Deluxe Gas Station (Level 2)",
	[-1373345079] = "Deluxe Gas Station (Level 3)",
	[-1373345078] = "Deluxe Gas Station (Level 4)",
	[-1373345077] = "Deluxe Gas Station (Level 5)",
	[-1373345076] = "Deluxe Gas Station (Level 6)",
	[-1373345075] = "Deluxe Gas Station (Level 7)",
	[-1373345074] = "Deluxe Gas Station (Level 8)",
	[-1373345073] = "Deluxe Gas Station (Level 9)",
	[1924252631] = "Deluxe Gas Station (Level 10)",
	[-632815590] = "Street Food Stall (Level 1)",
	[358081559] = "Street Food Stall (Level 2)",
	[358081560] = "Street Food Stall (Level 3)",
	[358081561] = "Street Food Stall (Level 4)",
	[358081562] = "Street Food Stall (Level 5)",
	[-1890599034] = "Street Food Restaurant (Level 1)",
	[-369722365] = "Street Food Restaurant (Level 2)",
	[-369722364] = "Street Food Restaurant (Level 3)",
	[-369722363] = "Street Food Restaurant (Level 4)",
	[-369722362] = "Street Food Restaurant (Level 5)",
	[-369722361] = "Street Food Restaurant (Level 6)",
	[-369722360] = "Street Food Restaurant (Level 7)",
	[-369722359] = "Street Food Restaurant (Level 8)",
	[2135864390] = "Street Food Market (Level 1)",
	[1198143683] = "Street Food Market (Level 2)",
	[1198143684] = "Street Food Market (Level 3)",
	[1198143685] = "Street Food Market (Level 4)",
	[1198143686] = "Street Food Market (Level 5)",
	[1198143687] = "Street Food Market (Level 6)",
	[1198143688] = "Street Food Market (Level 7)",
	[1198143689] = "Street Food Market (Level 8)",
	[1198143690] = "Street Food Market (Level 9)",
	[884035890] = "Street Food Market (Level 10)",
	[-102058524] = "Small Drone Base (Level 1)",
	[-102058523] = "Small Drone Base (Level 2)",
	[-102058522] = "Small Drone Base (Level 3)",
	[-102058521] = "Small Drone Base (Level 4)",
	[-102058520] = "Small Drone Base (Level 5)",
	[-102058519] = "Small Drone Base (Level 6)",
	[-102058518] = "Small Drone Base (Level 7)",
	[-102058517] = "Small Drone Base (Level 8)",
	[-102058516] = "Small Drone Base (Level 9)",
	[927036052] = "Small Drone Base (Level 10)",
	[-85869556] = "Basic Drone Base (Level 1)",
	[-85869555] = "Basic Drone Base (Level 2)",
	[-85869554] = "Basic Drone Base (Level 3)",
	[-85869553] = "Basic Drone Base (Level 4)",
	[-85869552] = "Basic Drone Base (Level 5)",
	[-85869551] = "Basic Drone Base (Level 6)",
	[-85869550] = "Basic Drone Base (Level 7)",
	[-85869549] = "Basic Drone Base (Level 8)",
	[-85869548] = "Basic Drone Base (Level 9)",
	[1461271996] = "Basic Drone Base (Level 10)",
	[262958134] = "Deluxe Drone Base (Level 1)",
	[262958135] = "Deluxe Drone Base (Level 2)",
	[262958136] = "Deluxe Drone Base (Level 3)",
	[262958137] = "Deluxe Drone Base (Level 4)",
	[262958138] = "Deluxe Drone Base (Level 5)",
	[262958139] = "Deluxe Drone Base (Level 6)",
	[262958140] = "Deluxe Drone Base (Level 7)",
	[262958141] = "Deluxe Drone Base (Level 8)",
	[262958142] = "Deluxe Drone Base (Level 9)",
	[87683878] = "Deluxe Drone Base (Level 10)",
	[-184573351] = "Small Controlnet Tower (Level 1)",
	[-184573350] = "Small Controlnet Tower (Level 2)",
	[-184573349] = "Small Controlnet Tower (Level 3)",
	[-184573348] = "Small Controlnet Tower (Level 4)",
	[-184573347] = "Small Controlnet Tower (Level 5)",
	[-184573346] = "Small Controlnet Tower (Level 6)",
	[-184573345] = "Small Controlnet Tower (Level 7)",
	[-184573344] = "Small Controlnet Tower (Level 8)",
	[-184573343] = "Small Controlnet Tower (Level 9)",
	[-1795953239] = "Small Controlnet Tower (Level 10)",
	[1486108449] = "Basic Controlnet Tower (Level 1)",
	[1486108450] = "Basic Controlnet Tower (Level 2)",
	[1486108451] = "Basic Controlnet Tower (Level 3)",
	[1486108452] = "Basic Controlnet Tower (Level 4)",
	[1486108453] = "Basic Controlnet Tower (Level 5)",
	[1486108454] = "Basic Controlnet Tower (Level 6)",
	[1486108455] = "Basic Controlnet Tower (Level 7)",
	[1486108456] = "Basic Controlnet Tower (Level 8)",
	[1486108457] = "Basic Controlnet Tower (Level 9)",
	[1796938609] = "Basic Controlnet Tower (Level 10)",
	[180443307] = "Deluxe Controlnet Tower (Level 1)",
	[180443308] = "Deluxe Controlnet Tower (Level 2)",
	[180443309] = "Deluxe Controlnet Tower (Level 3)",
	[180443310] = "Deluxe Controlnet Tower (Level 4)",
	[180443311] = "Deluxe Controlnet Tower (Level 5)",
	[180443312] = "Deluxe Controlnet Tower (Level 6)",
	[180443313] = "Deluxe Controlnet Tower (Level 7)",
	[180443314] = "Deluxe Controlnet Tower (Level 8)",
	[180443315] = "Deluxe Controlnet Tower (Level 9)",
	[1659661883] = "Deluxe Controlnet Tower (Level 10)",
	[363210677] = "Controlnet HQ (Level 1)",
	[363210678] = "Controlnet HQ (Level 2)",
	[363210679] = "Controlnet HQ (Level 3)",
	[363210680] = "Controlnet HQ (Level 4)",
	[363210681] = "Controlnet HQ (Level 5)",
	[363210682] = "Controlnet HQ (Level 6)",
	[363210683] = "Controlnet HQ (Level 7)",
	[363210684] = "Controlnet HQ (Level 8)",
	[363210685] = "Controlnet HQ (Level 9)",
	[277401625] = "Controlnet HQ (Level 10)",
	[1987396064] = "Vu Tower (Level 1)",
	[41293853] = "Vu Tower (Level 2)",
	[41293854] = "Vu Tower (Level 3)",
	[41293855] = "Vu Tower (Level 4)",
	[41293856] = "Vu Tower (Level 5)",
	[41293857] = "Vu Tower (Level 6)",
	[41293858] = "Vu Tower (Level 7)",
	[41293859] = "Vu Tower (Level 8)",
	[41293860] = "Vu Tower (Level 9)",
	[1362697164] = "Vu Tower (Level 10)",
	[1362697165] = "Vu Tower (Level 11)",
	[1362697166] = "Vu Tower (Level 12)",
	[1362697167] = "Vu Tower (Level 13)",
	[1362697168] = "Vu Tower (Level 14)",
	[1362697169] = "Vu Tower (Level 15)",
	[1362697170] = "Vu Tower (Level 16)",
	[1362697171] = "Vu Tower (Level 17)",
	[1362697172] = "Vu Tower (Level 18)",
	[1028570315] = "Department Of Epic Projects",
	[925375395] = "Maxis Manor",
	[-1759495565] = "Omega Research Center",
	[134836917] = "Omega Lab",
	[153804537] = "Department Of Education",
	[1149140292] = "Nursery School",
	[-15379413] = "Grade School",
	[1416055094] = "Public Library",
	[234829448] = "High School",
	[-98121376] = "Community College",
	[135886467] = "University",
	[610955598] = "University Athletic Field",
	[-174697520] = "University Rowing Center",
	[22619681] = "Omega University",
	[771263701] = "University Campus Park",
	[-2089816908] = "University Library",
	[74113015] = "University Art Gallery",
	[-2072804076] = "University Campus Center",
	[1354351239] = "University Aquarium",
	[-854257755] = "University Observatory",
	[1440929251] = "Contemporary Art Museum (Level 1)",
	[1440929252] = "Contemporary Art Museum (Level 2)",
	[1440929253] = "Contemporary Art Museum (Level 3)",
	[1440929254] = "Contemporary Art Museum (Level 4)",
	[1440929255] = "Contemporary Art Museum (Level 5)",
	[1440929256] = "Contemporary Art Museum (Level 6)",
	[1440929257] = "Contemporary Art Museum (Level 7)",
	[1440929258] = "Contemporary Art Museum (Level 8)",
	[1440929259] = "Contemporary Art Museum (Level 9)",
	[306025075] = "Contemporary Art Museum (Level 10)",
	[1389918955] = "Martial Arts School (Level 1)",
	[1389918956] = "Martial Arts School (Level 2)",
	[1389918957] = "Martial Arts School (Level 3)",
	[1389918958] = "Martial Arts School (Level 4)",
	[1389918959] = "Martial Arts School (Level 5)",
	[1389918960] = "Martial Arts School (Level 6)",
	[1389918961] = "Martial Arts School (Level 7)",
	[1389918962] = "Martial Arts School (Level 8)",
	[1389918963] = "Martial Arts School (Level 9)",
	[-1377314693] = "Martial Arts School (Level 10)",
	[-392316057] = "Northern Lights Research Institute (Level 1)",
	[-392316056] = "Northern Lights Research Institute (Level 2)",
	[-392316055] = "Northern Lights Research Institute (Level 3)",
	[-392316054] = "Northern Lights Research Institute (Level 4)",
	[-392316053] = "Northern Lights Research Institute (Level 5)",
	[-392316052] = "Northern Lights Research Institute (Level 6)",
	[-392316051] = "Northern Lights Research Institute (Level 7)",
	[-392316050] = "Northern Lights Research Institute (Level 8)",
	[-392316049] = "Northern Lights Research Institute (Level 9)",
	[-61527945] = "Northern Lights Research Institute (Level 10)",
	[-1173511972] = "Oceanographic Institute (Level 1)",
	[-1173511971] = "Oceanographic Institute (Level 2)",
	[-1173511970] = "Oceanographic Institute (Level 3)",
	[-1173511969] = "Oceanographic Institute (Level 4)",
	[-1173511968] = "Oceanographic Institute (Level 5)",
	[-1173511967] = "Oceanographic Institute (Level 6)",
	[-1173511966] = "Oceanographic Institute (Level 7)",
	[-1173511965] = "Oceanographic Institute (Level 8)",
	[-1173511964] = "Oceanographic Institute (Level 9)",
	[-71189364] = "Oceanographic Institute (Level 10)",
	[2140683777] = "Secret Research Lab (Level 1)",
	[2140683778] = "Secret Research Lab (Level 2)",
	[2140683779] = "Secret Research Lab (Level 3)",
	[2140683780] = "Secret Research Lab (Level 4)",
	[2140683781] = "Secret Research Lab (Level 5)",
	[2140683782] = "Secret Research Lab (Level 6)",
	[2140683783] = "Secret Research Lab (Level 7)",
	[2140683784] = "Secret Research Lab (Level 8)",
	[2140683785] = "Secret Research Lab (Level 9)",
	[1923087953] = "Secret Research Lab (Level 10)",
	[1068709537] = "Artist Atelier",
	[-1967647249] = "University Of Ecology",
	[-1558709851] = "Department Of Transportation",
	[1057886574] = "Bus Terminal",
	[-1043014605] = "London Bus Terminal",
	[359437193] = "Airship Hangar",
	[1333485593] = "Balloon Park",
	[-658227156] = "Heliport",
	[-485403679] = "Omega Tube Terminal",
	[-593594007] = "Hot Air Balloons",
	[1035128858] = "Bicycle Track",
	[-467653071] = "Bus Terminal (Special)",
	[-16069529] = "Countryside Station",
	[43624901] = "Helipad",
	[1341745005] = "Modern Railway Station",
	[637054753] = "Locomotive Museum",
	[1591801772] = "Central Train Station",
	[1250769522] = "Hoverboard Terminal (Level 1)",
	[1250769523] = "Hoverboard Terminal (Level 2)",
	[1250769524] = "Hoverboard Terminal (Level 3)",
	[1250769525] = "Hoverboard Terminal (Level 4)",
	[1250769526] = "Hoverboard Terminal (Level 5)",
	[1250769527] = "Hoverboard Terminal (Level 6)",
	[1250769528] = "Hoverboard Terminal (Level 7)",
	[1250769529] = "Hoverboard Terminal (Level 8)",
	[1250769530] = "Hoverboard Terminal (Level 9)",
	[-1674278686] = "Hoverboard Terminal (Level 10)",
	[-1964080415] = "Bicycle Rental (Level 1)",
	[-1964080414] = "Bicycle Rental (Level 2)",
	[-1964080413] = "Bicycle Rental (Level 3)",
	[-1964080412] = "Bicycle Rental (Level 4)",
	[-1964080411] = "Bicycle Rental (Level 5)",
	[-1964080410] = "Bicycle Rental (Level 6)",
	[-1964080409] = "Bicycle Rental (Level 7)",
	[-1964080408] = "Bicycle Rental (Level 8)",
	[-1964080407] = "Bicycle Rental (Level 9)",
	[-390144207] = "Bicycle Rental (Level 10)",
	[522205641] = "Tuk Tuk Station (Level 1)",
	[522205642] = "Tuk Tuk Station (Level 2)",
	[522205643] = "Tuk Tuk Station (Level 3)",
	[522205644] = "Tuk Tuk Station (Level 4)",
	[522205645] = "Tuk Tuk Station (Level 5)",
	[522205646] = "Tuk Tuk Station (Level 6)",
	[522205647] = "Tuk Tuk Station (Level 7)",
	[522205648] = "Tuk Tuk Station (Level 8)",
	[522205649] = "Tuk Tuk Station (Level 9)",
	[52917017] = "Tuk Tuk Station (Level 10)",
	[-1215872470] = "Big Rig Route (Level 1)",
	[-1215872469] = "Big Rig Route (Level 2)",
	[-1215872468] = "Big Rig Route (Level 3)",
	[-1215872467] = "Big Rig Route (Level 4)",
	[-1215872466] = "Big Rig Route (Level 5)",
	[-1215872465] = "Big Rig Route (Level 6)",
	[-1215872464] = "Big Rig Route (Level 7)",
	[-1215872463] = "Big Rig Route (Level 8)",
	[-1215872462] = "Big Rig Route (Level 9)",
	[-1469085798] = "Big Rig Route (Level 10)",
	[1119327752] = "Quad Bike Station (Level 1)",
	[1119327753] = "Quad Bike Station (Level 2)",
	[1119327754] = "Quad Bike Station (Level 3)",
	[1119327755] = "Quad Bike Station (Level 4)",
	[1119327756] = "Quad Bike Station (Level 5)",
	[1119327757] = "Quad Bike Station (Level 6)",
	[1119327758] = "Quad Bike Station (Level 7)",
	[1119327759] = "Quad Bike Station (Level 8)",
	[1119327760] = "Quad Bike Station (Level 9)",
	[-1716889800] = "Quad Bike Station (Level 10)",
	[-887513832] = "Taxi Stop (Level 1)",
	[-887513831] = "Taxi Stop (Level 2)",
	[-887513830] = "Taxi Stop (Level 3)",
	[-887513829] = "Taxi Stop (Level 4)",
	[-887513828] = "Taxi Stop (Level 5)",
	[-887513827] = "Taxi Stop (Level 6)",
	[-887513826] = "Taxi Stop (Level 7)",
	[-887513825] = "Taxi Stop (Level 8)",
	[-887513824] = "Taxi Stop (Level 9)",
	[776814664] = "Taxi Stop (Level 10)",
	[-1672104106] = "Small Fountain Park",
	[712780976] = "Modern Art Park",
	[894179683] = "Plumbob Park",
	[410248493] = "Anchor Park",
	[1605023329] = "Deluxe Plumbob Park",
	[-1250093364] = "Reflecting Pool Park",
	[-1914603231] = "Llarry The Llama",
	[-958560911] = "Peaceful Park",
	[-958560910] = "Urban Plaza",
	[492706918] = "World's Largest Ball Of Twine",
	[619296955] = "Sculpture Garden",
	[619296956] = "Row Of Trees",
	[-1900447707] = "Soccer Field",
	[-958560909] = "Jogging Path",
	[619296954] = "Water Park Playground",
	[-1921690608] = "Giant Garden Gnome",
	[-1791367421] = "Basketball Court",
	[-813560860] = "Dolly The Dinosaur",
	[2039678676] = "Tokyo Town Gate",
	[-1685111278] = "Fish Market",
	[-788805066] = "Old Palace Park",
	[-1791367420] = "Skate Park",
	[673250798] = "Sakura Part",
	[-1170594527] = "Geometric Sculptures",
	[-2069325028] = "Dutch Windmill",
	[945525020] = "Royal Garden",
	[578424766] = "Baseball Park",
	[1414044701] = "Golf Course - Front 9",
	[1414044702] = "Golf Course - Back 9",
	[-1267678106] = "Swimming Pool",
	[-475654483] = "Omega Park",
	[-343974711] = "Ice Sculpture Park",
	[2040088750] = "Ultimate Mayor Statue",
	[81901075] = "Crescent Tent",
	[587994243] = "Topiary Turtle",
	[-1933624278] = "Topiary Llama",
	[1395124309] = "Topiary Cheetah",
	[-404556] = "Topiary Plumbob",
	[-777336438] = "Casino City Sign",
	[-383906791] = "Casino City Park",
	[58778652] = "University Park Cafeteria",
	[-301302384] = "University Park Quad",
	[-1344538987] = "Umaid Bhavan Garden",
	[-1379414401] = "Parliament Park",
	[1457786383] = "Nagoya Castle Garden",
	[-1713758072] = "St. James Park",
	[-1051718906] = "Himalayan Garden",
	[-154536615] = "Pena Garden",
	[1253523744] = "Windsor Home Park",
	[1500089335] = "Schonbrunn Palace Park",
	[1019069964] = "Crescent Garden",
	[334535581] = "Food Trucks",
	[1761412862] = "Victory Trophy",
	[2005587850] = "Simcity Cup Stadium",
	[668029703] = "Sports Field",
	[1136823044] = "Sports Fan Parade",
	[2057715442] = "Sports Star Statue",
	[-1935167258] = "Sports Merchandise",
	[1312201562] = "Outdoor Sports Theatre",
	[579388837] = "Pride Parade",
	[1014461305] = "Merry-Go-Round",
	[1168312438] = "Holiday Shopping Center",
	[-587405082] = "Santa's Greetings",
	[194738006] = "Holiday Hotel",
	[819620077] = "Festive Boulevard",
	[-1461779797] = "New Year's Walk",
	[-1357616746] = "New Year's Rooftop Bash",
	[-1067122351] = "Dog Sledding Tour",
	[417646355] = "Hot Springs Resort",
	[-343859364] = "Ice Sculpture Show",
	[1299459679] = "Lapland Resort",
	[125479983] = "Pinewood Farm",
	[-1425146120] = "Reindeer Farm",
	[1032094812] = "Yeti Sighting",
	[815397525] = "Year Of The Pig Parade",
	[-1442673990] = "Dragon Dance",
	[2011874625] = "Fireworks Show",
	[528807486] = "Dumpling Market",
	[-951464114] = "Plum Blossom Park",
	[438407953] = "Lion Dance",
	[1855633078] = "Lantern Festival",
	[-1876880368] = "Chinese Theatre Show",
	[-2005871118] = "The Cursed Swamp",
	[-451932982] = "The Nutcracker Ballet Hall",
	[836909204] = "Giant Snow Globe",
	[304782918] = "Romantic Carriage Ride",
	[1266250176] = "Straw Goat",
	[-962449382] = "Giant Snowman",
	[1116447266] = "Winter Bonfire",
	[273998439] = "2020 Ferris Wheel",
	[-1418657144] = "2020 Commemorative Statue",
	[-1477898388] = "Year Of The Rat Sculpture",
	[1079087194] = "Plaza Of Lights",
	[19974509] = "Romantic Hot Springs",
	[-77155734] = "The Lovers' Pathway",
	[1899649143] = "Egg Painting Contest",
	[-455642506] = "Pride Festival",
	[1936731727] = "Medieval Market",
	[-619959780] = "Festival Of Light",
	[2003618685] = "Romantic Floral Arches",
	[1970418852] = "Year Of The Ox",
	[-701221117] = "2021 Celebration Tower",
	[-79331805] = "Heartwarming Ice Rink",
	[-1670955522] = "Gambling Hq",
	[-1917164795] = "Gambling House",
	[-235971151] = "Sleek Casino",
	[-1377292447] = "Sleek Casino Tower",
	[1080258539] = "Sci-fi Casino",
	[206800155] = "Sci-fi Casino Tower",
	[-74247875] = "Luxurious Casino",
	[924802029] = "Luxurious Casino Tower",
	[1194588220] = "Omega Casino",
	[-1069324852] = "Lucky Stars Casino",
	[1606201192] = "Sin City Casino",
	[-1558646031] = "Four Aces Casino",
	[-1817972314] = "Golden Egg Casino",
	[-747550802] = "Four Leaf Clover Casino",
	[674800975] = "Wild West Casino",
	[130975190] = "House Of Spades Casino",
	[-1167932386] = "Snake Eyes Casino",
	[1598945637] = "Mahjong Hall (Level 1)",
	[1598945638] = "Mahjong Hall (Level 2)",
	[1598945639] = "Mahjong Hall (Level 3)",
	[1598945640] = "Mahjong Hall (Level 4)",
	[1598945641] = "Mahjong Hall (Level 5)",
	[1598945642] = "Mahjong Hall (Level 6)",
	[1598945643] = "Mahjong Hall (Level 7)",
	[1598945644] = "Mahjong Hall (Level 8)",
	[1598945645] = "Mahjong Hall (Level 9)",
	[1225598517] = "Mahjong Hall (Level 10)",
	[519360860] = "Oasis Casino (Level 1)",
	[519360861] = "Oasis Casino (Level 2)",
	[519360862] = "Oasis Casino (Level 3)",
	[519360863] = "Oasis Casino (Level 4)",
	[519360864] = "Oasis Casino (Level 5)",
	[519360865] = "Oasis Casino (Level 6)",
	[519360866] = "Oasis Casino (Level 7)",
	[519360867] = "Oasis Casino (Level 8)",
	[519360868] = "Oasis Casino (Level 9)",
	[-40960756] = "Oasis Casino (Level 10)",
	[687869582] = "Ice Casino (Level 1)",
	[687869583] = "Ice Casino (Level 2)",
	[687869584] = "Ice Casino (Level 3)",
	[687869585] = "Ice Casino (Level 4)",
	[687869586] = "Ice Casino (Level 5)",
	[687869587] = "Ice Casino (Level 6)",
	[687869588] = "Ice Casino (Level 7)",
	[687869589] = "Ice Casino (Level 8)",
	[687869590] = "Ice Casino (Level 9)",
	[1224859774] = "Ice Casino (Level 10)",
	[-808577937] = "Volcano Casino (Level 1)",
	[-808577936] = "Volcano Casino (Level 2)",
	[-808577935] = "Volcano Casino (Level 3)",
	[-808577934] = "Volcano Casino (Level 4)",
	[-808577933] = "Volcano Casino (Level 5)",
	[-808577932] = "Volcano Casino (Level 6)",
	[-808577931] = "Volcano Casino (Level 7)",
	[-808577930] = "Volcano Casino (Level 8)",
	[-808577929] = "Volcano Casino (Level 9)",
	[-913268097] = "Volcano Casino (Level 10)",
	[-1540556852] = "Space Hq",
	[489221826] = "Stellar Observatory",
	[-2086585878] = "Planetarium",
	[601625106] = "Satellite Communication Center",
	[-1012702525] = "Astronaut Training Center",
	[1537492520] = "Space Debris Recycling Centre",
	[1660604759] = "Small Moon Rover Track",
	[475491240] = "Large Moon Rover Track",
	[-2099437217] = "Planet X Habitat Simulation",
	[-1851880457] = "Sim G Centrifuge",
	[-1834122803] = "Rocket Engine Test Stand",
	[1283687826] = "Space Research Institute",
	[-235346] = "Satellite Manufacturing Plant",
	[-962892957] = "Launch Pad",
	[-711102984] = "Mission Control Center",
	[1666090104] = "Space Port",
	[-651881817] = "Starsphere",
	[-744052152] = "Large Binocular Scope",
	[235085977] = "Area Sim 1",
	[1445190666] = "Cosmic Drome",
	[-353516371] = "Ridiculously Large Radio Telescope",
	[618404915] = "Rocket Assembly Facility",
	[-1460623397] = "Entertainment Hq",
	[261606785] = "Hotel",
	[-1791367419] = "Amphitheater",
	[1411074401] = "Expo Center",
	[1829835246] = "Stadium",
	[891389804] = "Sydney Opera House",
	[-2064366556] = "Ferris Wheel 1",
	[277077801] = "Sumo Hall",
	[-853219444] = "Globe Theatre",
	[1414008796] = "Oslo Opera House",
	[-551239092] = "Tennis Stadium",
	[1669555514] = "Soccer Stadium",
	[1254680450] = "Track And Field Stadium",
	[-1420940367] = "Baseball Stadium",
	[1349962107] = "Football Stadium",
	[831775094] = "Arctic Hotel",
	[839756894] = "Ice Hockey Arena",
	[1601947513] = "Bumper Cars",
	[1071264761] = "Drop Tower",
	[-1945040199] = "Robot Ride",
	[-1522437091] = "Pendulum Ride",
	[365337543] = "Water Slide",
	[1908191700] = "Big Roller Coaster",
	[361777545] = "Movie Studio Gate",
	[1859792493] = "Romantic Movie Set",
	[1688808526] = "Action Movie Set",
	[-1323273224] = "Horror Movie Set",
	[-317083518] = "Epic Movie Set",
	[-578242114] = "Sci-fi Movie Set",
	[482467976] = "Wedding Hall",
	[-1448678802] = "Sims' Night Club",
	[-605237171] = "Carnival Of Venice",
	[-1547688759] = "Mardi Gras",
	[-1372107171] = "Flower Festival",
	[-1665863861] = "Rio Carnival",
	[-1240308601] = "Caribbean Carnival",
	[1881626558] = "Dragon Carnival",
	[-638492261] = "Wild West Town Hall",
	[-791443007] = "Horseshoe Stables",
	[1248520028] = "Little Schoolhouse",
	[-1977069583] = "Cowboy Bank",
	[2137596925] = "Sheriff's Office",
	[47615459] = "Sarsaparilla Saloon",
	[-1415565022] = "Dragon Boat Festival",
	[-383570677] = "Sim Music Festival",
	[1712268802] = "Summer Matsuri",
	[-323073335] = "Art Festival",
	[22727353] = "Floating Lantern Festival",
	[-1361544188] = "Furry Friends Festival",
	[-1201523453] = "Scandinavian Midsummer Festival",
	[-1639489307] = "Freestyle Park",
	[-285245984] = "Pond Hockey",
	[2030733757] = "Ice Fishing",
	[-1925857724] = "Outdoor Curling",
	[-1769493524] = "Snow Mobile Tour",
	[1997296934] = "Speed Skating",
	[433742234] = "Secret Agent Set",
	[1685265269] = "Blooming Love Set",
	[347828141] = "Maxis Man Vs. Dr. Vu Set",
	[347037782] = "Castle Haunts Set",
	[704258394] = "Jazz Noir Set",
	[1848476010] = "Science And Smog Set",
	[-770479640] = "Awards Ceremony",
	[-1654411707] = "Mysterious Mummy Set",
	[1984604518] = "Modern Treehouse",
	[504238071] = "Urban Garden",
	[1775470285] = "Treetop Adventure Park",
	[-1662845995] = "Modern Spa",
	[-96044553] = "Yoga And Meditation Retreat",
	[-1568907942] = "Art Hideaway",
	[-385893385] = "Pet Park (Level 1)",
	[-385893384] = "Pet Park (Level 2)",
	[-385893383] = "Pet Park (Level 3)",
	[-385893382] = "Pet Park (Level 4)",
	[-385893381] = "Pet Park (Level 5)",
	[-385893380] = "Pet Park (Level 6)",
	[-385893379] = "Pet Park (Level 7)",
	[-385893378] = "Pet Park (Level 8)",
	[-385893377] = "Pet Park (Level 9)",
	[150420231] = "Pet Park (Level 10)",
	[1529868062] = "Tea House (Level 1)",
	[1529868063] = "Tea House (Level 2)",
	[1529868064] = "Tea House (Level 3)",
	[1529868065] = "Tea House (Level 4)",
	[1529868066] = "Tea House (Level 5)",
	[1529868067] = "Tea House (Level 6)",
	[1529868068] = "Tea House (Level 7)",
	[1529868069] = "Tea House (Level 8)",
	[1529868070] = "Tea House (Level 9)",
	[-1053961458] = "Tea House (Level 10)",
	[865611739] = "UFO Landing Site (Level 1)",
	[865611740] = "UFO Landing Site (Level 2)",
	[865611741] = "UFO Landing Site (Level 3)",
	[865611742] = "UFO Landing Site (Level 4)",
	[865611743] = "UFO Landing Site (Level 5)",
	[865611744] = "UFO Landing Site (Level 6)",
	[865611745] = "UFO Landing Site (Level 7)",
	[865611746] = "UFO Landing Site (Level 8)",
	[865611747] = "UFO Landing Site (Level 9)",
	[-1499583637] = "UFO Landing Site (Level 10)",
	[1365487904] = "Longship Museum (Level 1)",
	[1365487905] = "Longship Museum (Level 2)",
	[1365487906] = "Longship Museum (Level 3)",
	[1365487907] = "Longship Museum (Level 4)",
	[1365487908] = "Longship Museum (Level 5)",
	[1365487909] = "Longship Museum (Level 6)",
	[1365487910] = "Longship Museum (Level 7)",
	[1365487911] = "Longship Museum (Level 8)",
	[1365487912] = "Longship Museum (Level 9)",
	[2111427920] = "Longship Museum (Level 10)",
	[2104576967] = "Luau Party (Level 1)",
	[2104576968] = "Luau Party (Level 2)",
	[2104576969] = "Luau Party (Level 3)",
	[2104576970] = "Luau Party (Level 4)",
	[2104576971] = "Luau Party (Level 5)",
	[2104576972] = "Luau Party (Level 6)",
	[2104576973] = "Luau Party (Level 7)",
	[2104576974] = "Luau Party (Level 8)",
	[2104576975] = "Luau Party (Level 9)",
	[731563223] = "Luau Party (Level 10)",
	[-252552979] = "Golden Gold Stadium (Level 1)",
	[-252552978] = "Golden Gold Stadium (Level 2)",
	[-252552977] = "Golden Gold Stadium (Level 3)",
	[910217341] = "Archery Competition",
	[1128525069] = "Jousting Reenactment",
	[-1760746598] = "Countess' Bath House",
	[1882292954] = "New Orleans Mardi Gras",
	[1924331360] = "Fairytale Castle",
	[145171385] = "Alien Movie Set",
	[-1459586527] = "Department Of Culture",
	[53972136] = "Tower Of Pisa",
	[-1825458979] = "Big Ben",
	[21495196] = "Arc De Triomphe",
	[-665683039] = "Brandenburg Gate",
	[1163495494] = "Empire State Building",
	[69272571] = "Statue Of Liberty",
	[-1348379480] = "Hemeji Castle",
	[-131513365] = "Washington Monument",
	[-1590776910] = "Eiffel Tower",
	[363479116] = "Cinquantenaire Arch",
	[350041419] = "Giralda",
	[-1707224834] = "Tokyo Tower",
	[-2089966647] = "Maxisman Statue",
	[-1868767674] = "Kolner Dom",
	[-15263492] = "Willis Tower",
	[761715179] = "Omega Tower",
	[2008139918] = "Old Town Stronghold",
	[2007992298] = "Stone Fort",
	[-1732753151] = "City Fortress",
	[1220305687] = "Duke's Castle",
	[-1987429224] = "Princess' Tower",
	[1855159866] = "Countess' Citadel",
	[1678435087] = "Imperial Palace",
	[656868003] = "Royal Castle",
	[-1862408169] = "No Name Castle",
	[-1862408168] = "Gothic Castle",
	[847736623] = "Hanging Gardens Of Babylon",
	[-721290017] = "Mausoleum Of Halicarnassus",
	[-564909075] = "Temple Of Artemis",
	[-1196208235] = "Angkor Wat",
	[-1171137074] = "Luxor",
	[-1205286250] = "Taj Mahal",
	[-2125393850] = "Umaid Bhawan Palace",
	[-1455092954] = "Budapest Parliament",
	[-714173635] = "Nagoya Castle",
	[8465538] = "Buckingham Palace",
	[-2108020290] = "Himalayan Palace",
	[752048879] = "Pena Palace",
	[489029428] = "Sim Island Statue",
	[-1552131900] = "Nazca Lines",
	[-155446785] = "Inca Temple",
	[-1181444434] = "Sphinx Of Simcity",
	[376074091] = "Pyramid Of Simcity",
	[1792601194] = "Machu Picchu",
	[1290873382] = "Windsor Castle",
	[1889305514] = "Schonbrunn Palace",
	[1521944178] = "Nazca Bird",
	[-1303500776] = "Nazca Llama",
	[227653008] = "Fortune Shrine",
	[-844999557] = "The Tundra",
	[-432641378] = "Savannah",
	[1343674377] = "The Arctic",
	[-33249811] = "Church",
	[366333194] = "Mosque",
	[628204727] = "Temple",
	[393735239] = "Modern Temple",
	[-1761216148] = "Rain Forest",
	[1913998027] = "Red Lagoon",
	[1266494209] = "Geyser",
	[1562079541] = "Stonewall Inn",
	[460000029] = "Castle On A Cake",
	[-373259240] = "Joya No Kane",
	[-228481548] = "Sunset Diner",
	[1169034027] = "Foods And Stuffs Store",
	[-2141420504] = "Hair And Clippers Salon",
	[-1678069979] = "Swingy Tunes Razz Club",
	[1936070297] = "Rustling Pages Bookstore",
	[-696532419] = "Simcity Bank",
	[1085959474] = "Post Office",
	[505963531] = "Italian Restaurant",
	[-2017049381] = "Simcity Telephone Company",
	[-1932365988] = "Pretty Petals Flower Store",
	[-158801032] = "Great Gas Station",
	[107684920] = "Big Leagues Bowling Alley",
	[-1973724413] = "New Wheels Car Dealer",
	[-856463128] = "Hill Of Romance",
	[-970872132] = "Backyard Basketball",
	[670564972] = "Vinyl Fever Record Store",
	[-1380596413] = "The Shaky Milkshake Lounge",
	[-2105219743] = "Simcity Newspaper Office",
	[-177840672] = "Crispy Clean Laundry Wash",
	[1350015626] = "Seaplane Dock",
	[-557351818] = "Firewheel Lounge",
	[2061628404] = "Relaxing Trailer Camp",
	[1500570218] = "Roller Skating Lounge",
	[-1497178654] = "The Sleeping Llama Motel",
	[-1128528791] = "Mysterious Scrapyard",
	[520733631] = "Venice Hotel",
	[1522577122] = "Venice Apartments",
	[207097599] = "Museum Of Saggezza",
	[534967956] = "Canal Tower",
	[-764851151] = "Garden La Pace",
	[1334986002] = "Garden Storico",
	[529718016] = "Patio Amore",
	[-1460235956] = "Restaurant Sapori",
	[-51470732] = "Garden Autunno",
	[-1941533902] = "Bridge Classico",
	[-765318734] = "Cafe Limone",
	[1783384776] = "Gondola Station",
	[-1630168928] = "Bridge Of Bellezza",
	[-26743007] = "Bridge Le Case",
	[-12337183] = "Harbor Paradiso",
	[1144653927] = "Fountain Della Natura",
	[973779621] = "Waterfall Dei Sogni",
	[537112411] = "Villa Classica",
	[-578627710] = "Cups And Cakes Bakery",
	[-234823370] = "The Chocolatiere",
	[1596383402] = "The 'Say Cheese!' Store",
	[2094173274] = "Holiday Decorations Store",
	[-554306193] = "The Clock Master's Workshop",
	[-993772563] = "Old Town Market",
	[969789273] = "Sausage Store",
	[1897965091] = "The Hopping Hare Tavern",
	[1303921313] = "The Hot Cup",
	[1008927481] = "Toys And Joys Store",
	[1748288711] = "The Wierd Frames Museum",
	[-782313601] = "Canalside Inn",
	[71878264] = "Canalside Manor",
	[-21879615] = "The Grand Ol' Clock",
	[1280256681] = "Fountain On A Lake",
	[-658932724] = "Fluffy Pillows Hotel",
	[-528257565] = "The Swiss Farm",
	[-1541713815] = "Gondola Elevator",
	[940927790] = "The Fun Funicular",
	[-692599993] = "Observation Deck",
	[1420331730] = "Repurposed Bus",
	[628949972] = "Pet Supply Store",
	[-1028564481] = "Vet Clinic",
	[1352191295] = "Vegan Restaurant",
	[-793195255] = "Glamorous Camping Site",
	[841927665] = "Animal Santuary",
	[-1832028984] = "Pet Activity Park",
	[1009787955] = "Reclaimed Oil Tanker",
	[1654598104] = "Vine Apartments",
	[1654598105] = "Green Heights",
	[-1155711237] = "Repurposed Airline",
	[500120150] = "Sustainable Goods Store",
	[-894379818] = "Thrift Shop",
	[-2099637388] = "Handicraft Store",
	[1049672355] = "Smoothie Bar",
	[-283640548] = "Community Garden",
	[185478176] = "Open Air Theatre",
	[1270694914] = "Flea Market",
	[-1080667116] = "Community Hobbies Park",
	[-63404680] = "Colorful Apartments",
	[-1133929159] = "Parque Da Capoeira",
	[-607576542] = "Banana Stand",
	[1827563311] = "Tango Ballroom",
	[-1493889867] = "Funicular De Santiago",
	[842987971] = "Galeria De Arte Frida",
	[333883096] = "Castillo Del Mar",
	[-488049658] = "Gateway To Xibalba",
	[-1631602454] = "Rainforest Waterpark",
	[-488049655] = "Sacred Ballgame Court",
	[1228122528] = "Sunday Street Market",
	[-2099185443] = "Street Football Pitch",
	[-455011019] = "Fancy Drinks Hideout",
	[-871762519] = "Mate Shop",
	[-263230876] = "Las Cascadas",
	[285565628] = "Buccaneer Isle",
	[-1357897112] = "Pyramid Of Quetzal",
	[1978796257] = "Museum Of Ancient Heritage",
	[-1357897111] = "Plaza Del Tollan",
	[-593976775] = "Ye Olde Bell Tower",
	[-257752610] = "Evergreen Granary",
	[-1862155080] = "Fancy Stables",
	[582727808] = "Guard House B&b",
	[896170607] = "Goose Feather Inn",
	[-543711205] = "The Useless Watermill",
	[442916474] = "Apothecary",
	[1279913324] = "Blacksmith Workshop",
	[1710067716] = "Commander's Armory",
	[-1048470682] = "Victorian Fountain",
	[319647626] = "Alchemist Lab",
	[-1375918246] = "Golden Llama Guild House",
	[-1710867123] = "The Precious Goldsmith",
	[-333981562] = "Merchant's Warehouse",
	[2143678023] = "Spice Merchant",
	[-1312883509] = "Historical Townhall",
	[-554928826] = "Silk Merchant",
	[-801555592] = "Secret Garden",
	[-945196983] = "Markku's Cat Cafe",
	[975980983] = "Classic Bicycle Shop",
	[754741008] = "Knitting Shop",
	[1981990599] = "Quaint Market Hall",
	[-1648844348] = "Scandinavian Design Shop",
	[-2127509491] = "Cross Country Ski Tracks",
	[286933340] = "Modern Library",
	[-768043684] = "Dining Hall",
	[-72260370] = "Oilpaper Umbrella Shop",
	[-946221856] = "Dainty Drunkery",
	[1242816945] = "Mellow Winery",
	[-533994156] = "Welcoming Inn",
	[-1920032065] = "Satin Workshop",
	[107636924] = "Chinese Food Stalls",
	[-485751013] = "Temple Of The Matchmaker",
	[1218180180] = "Pavillion Of Niu",
	[241887055] = "Koala Grove",
	[-1767311992] = "Windmill Water Pump",
	[1900459706] = "Kangaroo Field",
	[1702848470] = "Black Swan Lake",
	[12057423] = "Outback Station",
	[1271747456] = "Crocodile Swamp",
	[-2131349190] = "Uluru",
	[531443048] = "Emu Plains",
	[98625425] = "Corniche Of Gulf",
	[-1544783970] = "Tea House",
	[-372746083] = "Spice Souk",
	[-1629765520] = "Wool Rug Bazaar",
	[-777265174] = "Fountain Plaza",
	[1550327562] = "Falconry Demonstration",
	[-768450959] = "Ksar of Ait-Benhaddou",
	[250769903] = "Camel Racing Track",
	[-1079660811] = "Amsterdam Canal North",
	[-1079660810] = "Amsterdam Canal South",
	[-425463249] = "Central Park North",
	[-425463248] = "Central Park South",
	[396572438] = "Hohenschwangau Castle",
	[-442615840] = "Japanese Garden",
	[644629827] = "Luxembourg Garden",
	[1849903047] = "Rice Fields Of Yunnan",
	[598362567] = "Tuscany Villa",
	[2139952231] = "Victoria Inner Harbor",
	[-1555027266] = "Aerobics And Gym",
	[253685910] = "Sports Car Dealer",
	[656179119] = "Movie Rental",
	[-299732246] = "The Arcade",
	[761321168] = "The Mall",
	[1246751658] = "Hair Salon",
	[1865403167] = "Santa C. Beach",
	[1309962697] = "Outdoors Concert",
	[-363082332] = "Pond",
	[1092744876] = "Lake",
	[1502294909] = "Big Lake",
	[-1243599501] = "(HOPE BRIDGE)RED 1",
	[1922809432] = "Brass Arch Bridge",
	[1922820612] = "(HOPE BRIDGE)RED 2",
	[1784423030] = "(HOPE BRIDGE)RED 3",
	[428329242] = "Plumbob Bridge",
	[1903148850] = "Suspension Bridge",
	[1917814244] = "Omega Bridge",
	[-1368726365] = "Covered Bridge",
	[1370992939] = "Cobblestone Bridge",
	[1605630109] = "University Bridge",
	[-584187484] = "University Of Arts Bridge",
	[967331231] = "University Of Sciences Bridge",
	[916458293] = "Elevated Promenade",
	[-5887018] = "Modern Greenway",
	[1475606866] = "Aqueduct",
	[446054541] = "City Wall Section",
	[445479806] = "City Gates",
	[1831855182] = "Round Tower",
	[-793972515] = "Grey Wall Section",
	[-1460120914] = "Iron Gate",
	[626176382] = "Square Tower",
	[596459333] = "Wall Of Shi",
	[595884598] = "Gate Of Shi",
	[-1794721274] = "Tower Of Shi",
	[-1958508680] = "Wall Of Alsharq",
	[-1959083415] = "Gate Of Alsharq",
	[-209319783] = "Tower Of Alsharq",
	[-837296318] = "Riverboat",
	[-525828019] = "Steamboat",
	[1808158748] = "Riverside Restaurant",
	[704761493] = "Big Riverside Restaurant",
	[-2101937543] = "Aspen Grove",
	[-624314575] = "Small Aspen Grove",
	[-663978220] = "Acacia Forest",
	[-2028665844] = "Small Acacia Forest",
	[-2104424531] = "Pine Forest",
	[772660069] = "Small Pine Forest",
	[-2104311224] = "Winter Forest",
	[-696918464] = "Small Winter Forest",
	[537912937] = "Small Bamboo Forest",
	[1236803505] = "Bamboo Forest",
	[-1659461646] = "Small Palm Tree Forest",
	[-898062726] = "Palm Tree Forest",
	[1801539282] = "Small Joshua Tree Forest",
	[1705094490] = "Joshua Tree Forest",
	[107556157] = "Small Spruce Forest",
	[1588189061] = "Spruce Forest",
	[974874825] = "Small Weeping Willow Forest",
	[325671441] = "Weeping Willow Forest",
	[-1938389312] = "Small Sakura Forest",
	[-48122470] = "Sakura Forest",
	[-2107113271] = "Autumn Oak Tree",
	[-1541148143] = "Autumn Oak Forest",
	[75604580] = "Small Japanese Maple Forest",
	[1270299500] = "Japanese Maple Forest",
	[2040462821] = "Small Weeping Birch Forest",
	[-1432729043] = "Weeping Birch Forest",
	[-372535163] = "Small Aspen Forest",
	[1005937869] = "Aspen Forest",
	[-1270260082] = "Silver Fern Tree",
	[899129366] = "Silver Fern Forest",
	[-1943647209] = "Pohutukawa Tree",
	[160914143] = "Pohutukawa Forest",
	[-609873923] = "Birch Tree",
	[463710789] = "Birch Forest",
	[688733163] = "Coconut Tree",
	[-900990029] = "Coconut Tree Forest",
	[-1119845796] = "Small Cypress Forest",
	[413892964] = "Cypress Forest",
	[-488419785] = "Bluebell Tree",
	[-674937601] = "Bluebell Woods",
	[1092421520] = "Campsite",
	[-314508920] = "Small Campsite",
	[-404321844] = "Hot Spring",
	[-1652887500] = "Crop Circle",
	[518609087] = "Stonehenge",
	[-540950008] = "Dusty Desert",
	[-1866177619] = "Praire Point",
	[-1611181281] = "Tumbleweed Station",
	[421807020] = "Covered Wagon Camp Site",
	[552611] = "Rocky Pastures",
	[-3490912] = "Western Springs",
	[426132732] = "Cookout Camping",
	[-1798383991] = "Boat Camping",
	[-911645344] = "Cabin Camping",
	[165761577] = "Camping On The Lake",
	[1299998142] = "Summer Camp",
	[81113470] = "Tent Camping",
	[-578544303] = "Adventure Camping",
	[1419251096] = "Trailer Camp",
	[-1924106072] = "Swan Lake",
	[-546663096] = "Greenhouse",
	[-257591854] = "Green Pathway",
	[-1590388727] = "Relaxing Garden Plaza",
	[1534674107] = "Cattle Drive",
	[-102734049] = "Sheep Farm",
	[764118735] = "Volleyball Court",
	[813308529] = "Merman Statue",
	[-295480250] = "Carousel",
	[19878764] = "Waterpark",
	[1799705683] = "Bluebeard's Pirate Ship",
	[-517430528] = "Aquarium",
	[-1975436265] = "Lighthouse",
	[291034576] = "Lifegaurd Tower",
	[1334269703] = "Relaxing Beach",
	[-1683144483] = "Surfer Beach",
	[-843379253] = "Sailorman's Pier",
	[1962202416] = "Luxury Boat Marina",
	[2026792156] = "Astro-Twirl Rocket Ride",
	[1106695477] = "Beachfront Shopping Mall",
	[1573651112] = "Crescent Shopping Mall",
	[-1187429907] = "Bicycle Motocross Center",
	[-1388487448] = "Rowing Center",
	[-1524261240] = "Beach Volleyball Center",
	[-1869089609] = "Waterfront Wharf",
	[-1417405073] = "Yatch Club",
	[464006328] = "Boat House",
	[-2038081014] = "Luxury Beach House",
	[1685276410] = "Ocean Villa",
	[203311611] = "Sailing Club",
	[1893805226] = "Guardian Of Sailors",
	[1010574017] = "Beach Delta",
	[1047022577] = "Paradise Island",
	[-246355115] = "Luxury Beach Hotel",
	[295398699] = "Sailing Boat Pier",
	[1696366774] = "Royal Resort",
	[-1504571536] = "Luxury Mall",
	[1730432937] = "Luxury Cruise Ship",
	[-1891082744] = "Lighthouse Of Simcity",
	[300574244] = "Beach Theatre",
	[1364033785] = "Colossal Sandcastle",
	[1349768007] = "Isle Of Wight, The Needles",
	[1373299444] = "Pier Shopping Area",
	[-137548074] = "Sea Fireflies",
	[-1941621566] = "Sea Lions Center",
	[1167198283] = "Harbor Marketplace",
	[1029914302] = "Beach Torii",
	[-1022328473] = "Beach Sports Rental",
	[1532060468] = "Seashore Sauna Resort",
	[-1449629287] = "Beach Waterfall",
	[-365044955] = "Pebble Cliffs",
	[1502934459] = "Lagoon Retreat",
	[1941374121] = "Seaside Soiree",
	[-1468355025] = "Island Party",
	[2030134544] = "Hidden Lagoon",
	[-238866695] = "Entertainment Boardwalk",
	[-492173631] = "The Flying Dutchman",
	[-401195743] = "Ghost Fortress",
	[632880417] = "The Kraken",
	[1762731124] = "Siren's Call",
	[-2127049860] = "Sunken Village",
	[-1120214884] = "Eastegg Island",
	[1612699702] = "Blue Ocean Stadium (Level 1)",
	[1612699703] = "Blue Ocean Stadium (Level 2)",
	[1612699704] = "Blue Ocean Stadium (Level 3)",
	[-1734299794] = "Mountainside Train Station",
	[-2139578863] = "Ski Hotel",
	[-2025654154] = "Cozy Cottages",
	[-2025654153] = "Mountainside Cottages",
	[-2025654152] = "Hiker's Cottages",
	[157576222] = "Mountain Lift",
	[157244062] = "Alpine Cafe",
	[-1270815176] = "Halfpipe",
	[-1720727207] = "Ski Jumping Hill",
	[-2094361322] = "Ski Resort",
	[914769152] = "Communication Tower",
	[1853415023] = "Observatory",
	[-559421141] = "Castle",
	[206141169] = "Alpine Vineyard",
	[47626276] = "Mount Simcity",
	[-50933579] = "Mountain Palace",
	[157827808] = "City Name Sign",
	[1876019625] = "Whitewater Park",
	[1467693470] = "Paragliding Center",
	[607141114] = "Mountain Bike Park",
	[-1674266991] = "Snow Castle",
	[-1912214732] = "Mountain Climbing Camp",
	[1845899276] = "Waterfall Castle",
	[824472135] = "Stoneface Waterfall",
	[381249066] = "Gritty Gold Mine",
	[582544155] = "Petra Ruins",
	[220272830] = "Bobsled Track",
	[982418464] = "Glacier Climbing",
	[-2104088772] = "Hilltop Hotel",
	[-1693811819] = "Mountain Skywalk",
	[-1337103427] = "Snowboard Cross",
	[-1401192830] = "Family Sled Track",
	[-1929681207] = "Count's Castle",
	[483145387] = "Mountain Railway",
	[612373322] = "Small Factory",
	[-1199642511] = "Basic Factory",
	[693251512] = "Mass Production Factory",
	[-1344186495] = "High-Tech Factory",
	[734850349] = "Nano-Tech Factory",
	[1095995974] = "Ad-Powered Factory",
	[345830574] = "Green Factory",
	[-2097790136] = "Oil Plant",
	[-188513245] = "Coconut Farm",
	[-1396882817] = "Fishery",
	[-92995846] = "Mulberry Grove",
	[960415804] = "Tier 0 Buildings Supplies Store",
	[105664760] = "Tier 1 Buildings Supplies Store",
	[105664761] = "Tier 2 Buildings Supplies Store",
	[105664762] = "Tier 3 Buildings Supplies Store",
	[-187177827] = "Tier 0 Hardware Store",
	[-690676295] = "Tier 1 Hardware Store",
	[-690676294] = "Tier 2 Hardware Store",
	[-690676293] = "Tier 3 Hardware Store",
	[2030607321] = "Tier 0 Farmer's Market",
	[-1853924491] = "Tier 1 Farmer's Market",
	[-1853924490] = "Tier 2 Farmer's Market",
	[-1853924489] = "Tier 3 Farmer's Market",
	[1444038310] = "Tier 0 Furniture Store",
	[-1684984030] = "Tier 1 Furniture Store",
	[-1684984029] = "Tier 2 Furniture Store",
	[-1684984028] = "Tier 3 Furniture Store",
	[-1603072541] = "Tier 0 Gardening Supplies",
	[-1221457601] = "Tier 1 Gardening Supplies",
	[-1221457600] = "Tier 2 Gardening Supplies",
	[-1221457599] = "Tier 3 Gardening Supplies",
	[271162441] = "Tier 0 Donut Shop",
	[-516045339] = "Tier 1 Donut Shop",
	[-516045338] = "Tier 2 Donut Shop",
	[-516045337] = "Tier 3 Donut Shop",
	[-1470979549] = "Tier 0 Fashion Store",
	[-134466177] = "Tier 1 Fashion Store",
	[-134466176] = "Tier 2 Fashion Store",
	[-134466175] = "Tier 3 Fashion Store",
	[-1568621139] = "Tier 0 Fast Food Restaurant",
	[-92005175] = "Tier 1 Fast Food Restaurant",
	[-92005174] = "Tier 2 Fast Food Restaurant",
	[-92005173] = "Tier 3 Fast Food Restaurant",
	[-278168705] = "Tier 0 Home Appliances",
	[2135220571] = "Tier 1 Home Appliances",
	[2135220572] = "Tier 2 Home Appliances",
	[2135220573] = "Tier 3 Home Appliances",
	[1367458934] = "Tier 0 Eco Shop",
	[-643982606] = "Tier 1 Eco Shop",
	[-643982605] = "Tier 2 Eco Shop",
	[-643982604] = "Tier 3 Eco Shop",
	[369596261] = "Tier 0 Car Parts",
	[2142059393] = "Tier 1 Car Parts",
	[2142059394] = "Tier 2 Car Parts",
	[2142059395] = "Tier 3 Car Parts",
	[1740962423] = "Tier 0 Tropical Products Store",
	[178101587] = "Tier 1 Tropical Products Store",
	[178101588] = "Tier 2 Tropical Products Store",
	[178101589] = "Tier 3 Tropical Products Store",
	[-463325288] = "Tier 0 Fish Market Place",
	[1067438804] = "Tier 1 Fish Market Place",
	[1067438805] = "Tier 2 Fish Market Place",
	[1067438806] = "Tier 3 Fish Market Place",
	[-1466974139] = "Tier 0 Silk Store",
	[2074032225] = "Tier 1 Silk Store",
	[2074032226] = "Tier 2 Silk Store",
	[2074032227] = "Tier 3 Silk Store",
	[1997477714] = "Santa's Workshop",
	[363909911] = "Tier 0 Sports Shop",
	[-344837645] = "Tier 1 Sports Shop",
	[-344837644] = "Tier 2 Sports Shop",
	[-344837643] = "Tier 3 Sports Shop",
	[-627015643] = "Tier 0 Country Store",
	[-1662620607] = "Tier 1 Country Store",
	[-1662620606] = "Tier 2 Country Store",
	[-1662620605] = "Tier 3 Country Store",
	[-1176066318] = "Tier 0 Bureau Of Restauration",
	[-1816970258] = "Tier 1 Bureau Of Restauration",
	[-1816970257] = "Tier 2 Bureau Of Restauration",
	[-1816970256] = "Tier 3 Bureau Of Restauration",
	[-969924753] = "Chocolate Factory",
	[886231854] = "Vu's Random Generator",
	[-2091925481] = "Tier 0 Toy Shop",
	[1581645555] = "Tier 1 Toy Shop",
	[1581645556] = "Tier 2 Toy Shop",
	[1581645557] = "Tier 3 Toy Shop",
	[1271296665] = "Tier 0 Dessert Shop",
	[1021229621] = "Tier 1 Dessert Shop",
	[1021229622] = "Tier 2 Dessert Shop",
	[1021229623] = "Tier 3 Dessert Shop",
	[-53247827] = "World Tree",
	[1363276551] = "Old-Growth Forest",
	[1521635621] = "Forest Lake",
	[-365239469] = "Lay's Go-Kart Park",
	[-1351110122] = "Lay's Mountain Park",
	[1030140447] = "Lay's Bowl Park",
	[1904524427] = "Lay's Park",
	[-936132783] = "Ruffles Go-Kart Park",
	[-283671148] = "Ruffles Mountain Park",
	[-421759331] = "Ruffles Bowl Park",
	[-847252983] = "Ruffles Park",
	[-1177473833] = "Whale Watching Tower",
	[-415542704] = "Dolphin Watching Boat",
	[-905879128] = "Coral Reef",
	[-1738477098] = "Panda Habitat",
	[1950092739] = "Snow Leopard Habitat",
	[-1924457380] = "Gorilla Habitat",
	[149204635] = "(PLUMBOB PARK)RED",
	[-1634099085] = "(HEART PARK)RED",
	[706946425] = "(STAR PARK)RED",
	[-1669869661] = "(CITY NAME PARK)RED",
	[-1982142573] = "(BUS TERMINAL) RED",
	[-1452684878] = "(AIRSHIP HANGAR)RED",
	[259065734] = "(BALLOON PARK)RED",
	[71121177] = "(HELIPORT)RED",
	[-493714925] = "Drive-In Theater",
	[1306928805] = "Awards Auditorium",
	[-1690458379] = "Walk Of Plumbob",
	[-1674021276] = "Movie Studio Statue",
	[1248926735] = "Outdoor Cinema Park",
	[690586532] = "Movie Theater",
	[-2121152741] = "Spooky Park",
	[-2121152740] = "Monster Tree",
	[-2121152739] = "Pumpkin Man Statue",
	[-557690303] = "Haunted Mansion",
	[2063143272] = "Graveyard",
	[-647669663] = "Scary Carousel",
	[-1421810928] = "Mansion Of Horrors",
	[-571332033] = "Jack-o'-lantern",
	[1560466612] = "Ruined Bell Tower",
	[-1743195664] = "Holiday Gift Market",
	[-1743195663] = "Delicacy Market",
	[1359603596] = "Holiday Tree",
	[-118922403] = "Sledding Park",
	[815408777] = "Holiday Park",
	[-1820721636] = "Happy New Year Park",
	[592621734] = "Happy New Year Monument",
	[1767203460] = "Holiday Market",
	[-1226103885] = "Holiday Train Ride Park",
	[-2062857743] = "Festive Holiday Tree",
	[-482543179] = "Holiday Village",
	[-1573520756] = "Big Ice Skating Rink",
	[1649981261] = "Happy New Year 2018",
	[-1842272595] = "Extreme Skating Park",
	[1903483622] = "Lakeside Sauna",
	[428504772] = "Holiday Fountain Park",
	[-1085931401] = "Ice Skating Rink",
	[874082466] = "New Years Tower",
	[-1106159174] = "Snack Market",
	[-1106159173] = "Dumpling Alley",
	[-1887788971] = "Red Lantern Walkway",
	[-917097812] = "Welcoming Gate",
	[1381773871] = "Dragon Park",
	[-1516159089] = "Monkey Statue",
	[-135854200] = "Giant Lantern",
	[1244737708] = "Parrot Statue",
	[259481855] = "Carnival Gate",
	[452355042] = "Carnival Stage",
	[-539955733] = "Carnival Parade",
	[1255375549] = "Carnival Party",
	[1329015326] = "Day Of The Dead Park",
	[-1534700746] = "Little Teddy Park",
	[-45505667] = "Teddy Park",
	[883179021] = "Romantic Park",
	[-1808975027] = "Bridge Of Love",
	[-514396417] = "Cupid Angel Park",
	[326365644] = "Cupid Heart Park",
	[-289583874] = "Heart Balloon Park",
	[-1014462499] = "Lake Of Love",
	[2013586058] = "Beach Wedding",
	[-1217014048] = "Split Heart Left Side",
	[-1499497837] = "Split Heart Right Side",
	[660817399] = "Romeo And Juliet Balcone",
	[545400034] = "Swan Boat Park",
	[-956359243] = "Basket Bunny",
	[890019926] = "Spring Chick Statue",
	[-170854219] = "Chicken Park",
	[-863061950] = "Egg Park",
	[-1267834549] = "Egg Slide Park",
	[1011327376] = "Spiral Slide Park",
	[176580726] = "Bunny-Go-Round",
	[1858018973] = "Egg Twirl",
	[805796492] = "Hoppin' Waterslide",
	[-1740117831] = "Blooming Hill",
	[-1245468537] = "Fast Track To Spring",
	[1412631060] = "Over-Easy Rider",
	[1769335305] = "Cottontail Slide",
	[-101109207] = "Hare-raising Coaster",
	[-1822057967] = "Old Farm",
	[1875680775] = "Sheep Field",
	[-321464781] = "Horse Ranch",
	[-1587936417] = "Deer Meadow",
	[-540810843] = "Bear Cave",
	[-573396707] = "Rabbit Forest",
	[1321420829] = "Old Watermill",
	[-1712809431] = "Grand Souq",
	[-1035296432] = "Caravanserai Restaurant",
	[2104758484] = "Baklava Pastry Shop",
	[1408096025] = "Posada",
	[994100769] = "Santa Beach Party",
	[-1445063167] = "De Luxe Department Store",
	[1867708456] = "Little Candles Plaza",
	[-2081050059] = "Romantic Holiday Plaza",
	[1475708020] = "Karavaki",
	[1545376789] = "Poinsettia Greenhouse",
	[-916915172] = "Pohutukawa Tree Field",
	[446572583] = "Giant Lantern Festival",
	[-1366931139] = "Chocolate Fountain",
	[861156116] = "Festival Of Colors",
	[850460885] = "Lantern Shop",
	[101515232] = "Hanami",
	[-1950029431] = "Festival Of Breaking The Fast",
	[313160761] = "May Day Picnic",
	[2050118210] = "Chips And Dice Casino",
	[394421861] = "Dolphin Island",
	[-1350807063] = "University Auditorium",
	[-573061988] = "Ponte Milvio",
	[-894737628] = "Pantheon",
	[330989771] = "Altare Della Patria",
	[577541131] = "Arch Of Constatine",
	[-212251862] = "Castle Sant' Angelo",
	[2089810913] = "Colosseum",
	[382366963] = "Fontana De Trevi",
	[-1974175156] = "Roman Forum",
	[-891421167] = "Carnival Games Square",
	[240217640] = "Pirate Bay",
	[-42524362] = "Volcano Roller Coaster",
	[-2056847937] = "Dinosaur Safari Ride",
	[-1240507161] = "Ferris Wheel 2",
	[830720788] = "Haunted House",
	[-1055848850] = "Jungle Adventure",
	[1622396365] = "Teacup Ride",
	[-121780645] = "Beach Sauna Bar",
	[-1582890451] = "Nordic Fishing Dock",
	[1087687941] = "Ganesha Temple",
	[-715918088] = "Day Of The Dead Graveyard",
	[-222913838] = "Rooster Carnival",
	[-1484238889] = "The Mittens And Merrickbuttes",
	[-1243632684] = "Temple Of Kukulcan",
	[434915616] = "The Completely Normal House",
	[-1724734908] = "Mansion Of Recently Deceased",
	[58219099] = "Supernatural Hunters",
	[-519173045] = "Little Plant Of Horrors",
	[-2108507983] = "Cottage Forest",
	[1989632956] = "Carnival Of Eternity",
	[-1338562479] = "Flower City Name",
	[460314762] = "Year Of The Tiger",
	[319698076] = "2022 Party Island",
	[-1179688954] = "Olavinlinna",
	[-1689258632] = "Helsinki Central Railway Station",
	[-1862811391] = "Hame Castle",
	[1930061771] = "Hvittrask Mansion",
	[-819221854] = "Summer Cabin",
	[1389981153] = "Turku Castle",
	[-629253655] = "Helsinki Cathedral",
	[710609386] = "Alvar Aalto Culture House",
	[-839748800] = "Haka Rugby Pitch",
	[-977230501] = "Maori Gate",
	[2034183851] = "Maori Pa",
	[-583795522] = "Maori Houses",
	[576934165] = "Pataka",
	[-1012113601] = "Pouwhenua",
	[-776112980] = "Waka Boat Harbor",
	[-1264728310] = "Whale Watch",
	[707099742] = "Lake Saimaa",
	[-966691068] = "Northern Lights Cabin",
	[526900553] = "Monorail Station",
	[-327918657] = "Alhambra",
	[-1741650982] = "Colossus Of Rhodes",
	[1506675425] = "Whatville",
	[625950616] = "Scbi 7Th Anniversary",
	[2128064116] = "Hot-Air Balloon Festival",
	[769983670] = "Furusato No Oshogatsu",
	[-502533960] = "Mountain Temple",
	[-924392878] = "Dance Of Maiko",
	[615625595] = "Ryokan",
	[-150978828] = "Mountain Onsen",
	[312533906] = "Dagashiya",
	[1889845484] = "Fishing Harbor",
	[-1624139448] = "Seaside Village",
	[1341507156] = "Deer Park",
	[-87846684] = "Japanese Riverside Mansions",
	[-87846683] = "Japan Riverside Houses",
	[1421954182] = "Food Alleyways",
	[-1125378079] = "Grand Palais",
	[-652644598] = "Jardin Des Plantes",
	[1960640040] = "Parisan Brasserie",
	[404047226] = "Notre-Dame",
	[1714323392] = "Parc Des Buttes Chaumont",
	[-1714055807] = "Pere Lachaise Cemetery",
	[983359304] = "Musee D Orsay",
	[-1062501529] = "Sacre-Coeur",
	[-297334398] = "Pont Alexandre Iii",
	[1319627434] = "Pont Neuf",
	[1943054268] = "Musee Du Simcity",
	[-1578309862] = "Okinawa Beach",
	[-1770699378] = "Wisteria Park",
	[1727940088] = "Geylang Ramadan Bazaar",
	[1734153025] = "Iftar Tent",
	[-563490253] = "Ecological Community",
	[1959039626] = "Glass Egg Hall",
	[-860866556] = "Rustic Windmill",
	[-1187326347] = "Goat Park",
	[575885449] = "Poultry Haven",
	[1456232080] = "Cow Fields",
	[-1930074002] = "Old Farmhouse",
	[1957301671] = "Pig Pen",
	[-1894544896] = "Stables",
	[510579264] = "Backyard Farm",
	[1386839066] = "Rustic Village Bakery",
	[-108120760] = "Rustic Village Bus Station",
	[-755124704] = "Rustic Village Boat Harbor",
	[-2103635199] = "Rustic Village Inn",
	[344006469] = "Rustic Village Restaurant",
	[1919804018] = "Rustic Village Center",
	[1919804019] = "Rustic Village Market",
	[2054415556] = "Rustic Village School",
	[1350198096] = "Place De La Bastille",
	[-772442768] = "Rainbow Wedding",
	[-706548546] = "Farm Mansion",
	[1175560122] = "Farm Garden",
	[1051839001] = "Juice Farm",
	[-302791371] = "Small Animal Pastures",
	[-298047555] = "Large Animal Pastures",
	[1061538704] = "Small Flower Fields",
	[1066282520] = "Large Flower Fields",
	[785538783] = "Small Vineyards",
	[790282599] = "Large Vineyards",
	[-1867703810] = "Apple Tree",
	[-1862959994] = "Apple Forest",
	[745755992] = "Sunflower Field",
	[2064840565] = "Flower Garden Gazebo",
	[772540084] = "Palace Pier",
	[147228852] = "Rustic Castle",
	[1559447138] = "Broadway",
	[-1284290513] = "West Village",
	[-1922483555] = "Campus Park",
	[-527812764] = "Monument Library",
	[1128428129] = "Coney Island Broadwalk",
	[-19070014] = "Museum Of Art",
	[1577362781] = "Big Main Terminal",
	[-320983781] = "Times Square",
	[1422786598] = "Museum Of Natural History",
	[-2114742261] = "Campus Library",
	[-863859459] = "Bow Bridge",
	[314212659] = "George Washington Bridge",
	[-940140603] = "Brooklyn Bridge",
	[1282916073] = "Pebble Towers",
	[2114260105] = "Alpha Science Center",
	[-1504007666] = "Vertical Farm",
	[576980653] = "Alpha Yatch Club",
	[-1442679463] = "Vertical Garden",
	[-1614793130] = "Alpha Loop Park",
	[1460105340] = "Rainforest Towers",
	[-2126297497] = "Rotating Tower",
	[-2138253851] = "Floating Pod",
	[-1556544495] = "Oceanic Garden",
	[-1025714414] = "Omega Research Booster",
	[-295191895] = "Alpha Taxi Station",
	[-523194184] = "Feathery Mansion",
	[808131927] = "Zombie Mall",
	[-1665578542] = "Goth Mansion",
	[1999774098] = "Mountain Hotel",
	[16392513] = "Deserted Farm",
	[-226444335] = "Haunted Sanitarium",
	[462058679] = "Streets Of Diwali",
	[2030224591] = "Zombie Of Horrors",
	[-1009705288] = "Holiday Concert Hall",
	[-1859541172] = "Winter Garden",
	[-981667126] = "Piece De Bridgestane",
	[821544135] = "Cathedral Azure",
	[-895051274] = "Museum Of Festivities",
	[-1236049903] = "Winter Brasserie",
	[493374285] = "Galeries D' Art Nouveau",
	[-701156801] = "Threefold Bridge",
	[-153173616] = "Atelier Du Chocolate",
	[2108045910] = "Winter Wonder Vuppelin",
	[-213332959] = "Winter Holiday Street",
	[-1682346626] = "Winter Holiday Square",
	[1454171534] = "Winter Holiday Skating Pond",
	[-1053360456] = "Winter Holiday Park",
	[-1607734367] = "New Year's Palace (2023)",
	[-1278194285] = "Palolem Beach",
	[759087700] = "Baga Beach",
	[2062223335] = "Floating Casinos",
	[-865785951] = "Hilltop Party",
	[1198460338] = "Saturday Flea Market",
	[-2045014629] = "Dudhsagar Falls",
	[-1422692172] = "Fort Aguada",
	[1641938245] = "Basilica Of Goa",
	[-2096551982] = "Panjim Church",
	[-1110755257] = "Year Of The Rabbit",
	[-1856814337] = "Samba Parade",
	[678737156] = "Castle Of Towers",
	[-176279625] = "Country Castle",
	[1634727086] = "Island Fort",
	[-717173652] = "City Palace",
	[1394616471] = "Explorer's Castle",
	[88433670] = "Beach Castle",
	[-1664539688] = "Castle Of The Knights",
	[-1340825602] = "Grand Fotress",
	[-348181317] = "Round Castle",
	[1931893562] = "Dream Castle",
	[495800600] = "Ghostly Castle",
	[-1320764511] = "Hillside Castle",
	[1111477547] = "Spring Holiday Fountain",
	[166295189] = "Egg-o-Capsule",
	[-627960397] = "St. Patrick's Day Parade",
	[2095360422] = "Hillside Fort",
	[799630444] = "Iftar Market Square",
	[996317369] = "Majestic Umbrella Hall",
	[978473037] = "Renaissance Gallery",
	[-359649998] = "Old Palace",
	[1396765115] = "Garden Palace",
	[-1021810549] = "Grand Gardens",
	[1873405464] = "Cathedral Of Flowers",
	[795748] = "Government Plaza",
	[-1235643528] = "Square Of Da Simci",
	[1942240922] = "Romanesque Basilica",
	[559571178] = "Saint Basilica",
	[1175620110] = "Statue Of Daniel",
	[440188653] = "Mountain Gardens",
	[-1522363622] = "Loggia Del Llamalino",
	[1625696017] = "Bridge Of Da Simci",
	[440871015] = "Trinity Bridge",
	[-909196522] = "Grand Tuscan Villa",
	[-884003462] = "Royal X Station",
	[-1871036240] = "Railway Market",
	[-142685661] = "Golden Marsh Station",
	[622835743] = "Union Station",
	[-577081237] = "Victoria Memorial",
	[-857522815] = "Parkside Station",
	[-282846133] = "Central Station",
	[75958285] = "Lion's Station",
	[-438139921] = "Railway Cable Bridge",
	[1311318422] = "Railway Arch Bridge",
	[-2064543673] = "Railway Water Tower",
	[-1698050118] = "Signal Box",
	[-503453234] = "Cargo Lift",
	[1903354601] = "Metropolitan Railway Station",
	[-1353960721] = "Small Railway Station",
	[-1237103305] = "Medium Railway Station",
	[-1128001023] = "Large Railway Station",
	[869619892] = "Simcar Racetrack",
	[-428777932] = "Adventure Kingdom",
	[-1356181244] = "Oceanside Drive",
	[-381057314] = "Llamawood Urban Art",
	[-1885237895] = "Cypress Swamp",
	[1775919191] = "Sim West Quater",
	[-1780624383] = "Fort Danielson",
	[112132293] = "Sunscape Bridge",
	[1043459252] = "Wetlands Preserve",
	[922789833] = "Firefly Forest",
	[-949187712] = "Castillo De Las Llamas",
	[-1523086447] = "Space Launch Center",
	[482469978] = "The Simli Museum",
	[1627623011] = "The Southern Mansion",
	[614735804] = "Pride Fountain",
	[-161273939] = "4Th Of July Picnic",
	[-541487860] = "Strokkur Geyser",
	[-456229876] = "Svinafellsjokull Glacier",
	[-488981582] = "Seljalandsfoss Waterfall",
	[1786836125] = "Sapphire Cove",
	[1044093808] = "Versla Main Street",
	[1116497278] = "Tall Church",
	[671412064] = "Viking Village",
	[-990074740] = "Hvitserkur Beach",
	[308442350] = "Small Icelandic Hills",
	[-1216019777] = "Large Icelandic Hills",
	[439180802] = "Icelandic Volcano",
	[31567397] = "Icelandic Hot Spring",
	[570728233] = "Black Sand Beach",
	[767151428] = "Icelandic Horses",
	[816337669] = "Red House",
	[-1729576167] = "Columbia Road Flower Market",
	[-784692519] = "Fragment",
	[980195054] = "Westminster Abbey",
	[2069092396] = "Kensington Palace",
	[1526054020] = "Tower Bridge",
	[-1460626377] = "British Museum",
	[1914030145] = "Tower Of London",
	[850558660] = "London Tea House",
	[930890005] = "London Bookshop",
	[215546197] = "English Inn",
	[-2099673310] = "London Taxi Stand",
	[64967597] = "Piccadily Circus",
	[-375834911] = "Royal Albert Hall",
	[-1914983311] = "London Kew Garden",
	[1065081671] = "Eltham Palace",
	[1313095612] = "Tocho",
	[1813755749] = "Mode Gakuen Cocoon Tower",
	[-1310451524] = "Tokyo Cathedral",
	[-1564298652] = "Tokyo Big Sight",
	[-1367238659] = "Nakagin Capsule Tower",
	[822235988] = "Tokyo International Forum",
	[614170228] = "Hisao & Hiroko Taki Plaza",
	[-1854842861] = "Reiyukai Shakaden",
	[-1267520952] = "Akihabara Street",
	[243322819] = "Coffin House",
	[367631164] = "Witch Tree House",
	[391362933] = "Pumpkin Balloon",
	[1420845900] = "Chomper Backyard",
	[275335866] = "Pvz Museum",
	[404044642] = "Thanksgiving Fields",
	[1579400415] = "Maxis Hq",
	[-1961743034] = "Nordic Church",
	[649295752] = "Northern Museum",
	[-638228376] = "Arctic Aquarium",
	[-1515743305] = "Lofoten",
	[2138768342] = "Lean Library",
	[26934349] = "Treehouse Resort",
	[-952555316] = "Reindeer Sleigh Ride",
	[466163634] = "Ice Swimming Sauna",
	[-1487561462] = "Northern Lights Hut",
	[1708275201] = "Castle Of Ice",
	[-518370055] = "Temple Of Dawn",
	[-811436871] = "Tusk Tower",
	[208677870] = "Pixel Tower",
	[-1129122371] = "Dragon Temple",
	[1072852587] = "Robo Tower",
	[1747127097] = "Phi Phi Islands",
	[-1982220874] = "Mahidol Concert Hall",
	[-1128317133] = "Patong Beach",
	[-526752407] = "Phra Nang Cave Beach",
	[449920618] = "Year Of The Dragon Fountain",
	[-227072900] = "Year Of The Dragon Statue",
	[2044117905] = "Heart Shaped Park",
	[-132480798] = "Heart Shaped Maple Trees",
	[1665377053] = "Cannaregio Venice",
	[1665377054] = "San Polo Venice",
	[-1042592443] = "The Powder Tower",
	[-971391086] = "Charles Bridge",
	[-84591751] = "Quadrio Center",
	[1544098790] = "Petrin Tower",
	[-2099908710] = "Old Town Square",
	[1073072576] = "Prague Castle",
	[367160678] = "National Theatre",
	[892518849] = "Zizkov Television Tower",
	[404602461] = "Petrin Cathedral",
	[-1290779205] = "Legendary Emerald Skyscraper",
	[-1802872902] = "Legendary Golden Skyscraper",
	[-363029219] = "Legendary Abandoned Skyscraper",
	[2080167789] = "Gardencourt Estate",
	[1340343624] = "Knot College",
	[370759245] = "Rock Of Cashel",
	[124241177] = "Newgrange",
	[-264244925] = "Castle Of Eloquence",
	[1180472101] = "Doctor's Abbey",
	[-615692973] = "Wonderful Barn",
	[-1866149561] = "Hook Lighthouse",
	[2095303906] = "Giant's Causeway",
	[-918601870] = "Scenic Tower",
	[-1235671757] = "Tulum Ruins",
	[-2061240207] = "Mercado 28 Market",
	[-351525335] = "Mexican Grill House",
	[-1647877560] = "Xoximilco",
	[773330339] = "Hotel Zone",
	[1434641713] = "Cancun Aquarium",
	[-1591012233] = "La Isla Shopping Village",
	[-1740767685] = "Palapas Park",
	[-1310436183] = "English Easter Garden",
	[1338836999] = "Ramadan Resort",
	[-1958663965] = "Shamrock Alley",
	[1290075004] = "Castle Of Good Hope",
	[1077878471] = "Boulders Beach",
	[526649619] = "Cape Point Light House",
	[-1800058036] = "Cape Town Stadium",
	[-761420415] = "Cape Town Waterfront",
	[-124885990] = "African Safari",
	[-1695738094] = "Peers Cave",
	[1457386162] = "Cape Town Garden",
	[1547529770] = "Shark Tours",
	[-1931689325] = "Large African",
	[497895753] = "Large African Savannah",
	[-2005087996] = "Blue Llama Market",
	[-1645866108] = "Pink Hippo Park",
	[848369710] = "500 Soda Stop",
	[-646372006] = "Flip-Flop Motel",
	[-887832712] = "Smith Sisters Store",
	[-632375868] = "Clover's Tall Station",
	[1031128507] = "Blue Butterfly Motel",
	[-1275569118] = "Ufo Estate",
	[-205731966] = "Cucamonga Station",
	[211291018] = "Victorian Pride Centre",
	[-867480776] = "Pride Cafe",
	[634705318] = "May Queen Parade",
	[1003670731] = "Sim Song Contest",
	[1736540863] = "Legendary Golden Key Skyscraper",
	[1100779520] = "Legendary Platinum Key Skyscraper",
	[-672425292] = "Sagrada Familia",
	[591847594] = "La Rambla Street",
	[465188623] = "Cathedral Of The Sea",
	[-1592694037] = "Poble Espanyol",
	[-425205559] = "La Pedrera",
	[88852693] = "Park Guell",
	[-1206243115] = "Catalan Music Palace",
	[1026382411] = "Catalonia Square",
	[-1180395309] = "Montjuic Magic Fountain",
	[-1873109675] = "Sugarloaf Mountain",
	[-2043774337] = "Theatro Municipal",
	[-1294489020] = "Magic Stairs",
	[299388908] = "Jardim Botanico",
	[873877609] = "Llama's Landmark",
	[-173188499] = "Artist's Park",
	[-1341405639] = "Biblioteca Nacional",
	[925006678] = "Palcio do Catete (locked)",
	[-67713006] = "Rio Beaches (locked)",
	[-619996630] = "Telesports Arena",
	[-1779083345] = "Old Event Hall (locked)",
	[1169487741] = "Sim Sports Aquatic Arena",
	[851946800] = "Bon Odori",
	[-410571163] = "Daimonji Yaki",
	[252896069] = "4Th July Parade",
	[-888911843] = "The One Park",
	[1005029538] = "Australian Museum",
	[-1037153604] = "Beam Wireless",
	[-1644752812] = "Flowerbud (locked)",
	[-957241066] = "Green Exchange (locked)",
	[1484303005] = "The Paper Bag",
	[1942083942] = "Maritime Museum (Locked)",
	[841862582] = "Sydney Zoo",
	[-1332310259] = "The Harbour Casino",
	[1099952628] = "Rijksmuseum",
	[751497775] = "Stedeljik Museum",
	[789426060] = "The Concertgebouw",
	[40742115] = "Amsterdam Park",
	[-1079914711] = "The Gooyer Windmill",
	[1324835889] = "Amsterdam Art Museum",
	[1144335259] = "Openbare Bibliotheek Amsterdam",
	[1353024422] = "The Whale",
	[-1689674194] = "Oude Kerk",
	[-1089358459] = "Film Institue",
	[1013665086] = "Ganesh Pandal",
	[1936110901] = "Constructors Playground",
	[-1382928141] = "The Center",
	[1146948722] = "The Round Tower",
	[762126226] = "Two-cranes Tower",
	[-1344668426] = "Chin Lin Nunnery",
	[-346803870] = "Nan Lian Garden",
	[-1332037813] = "The Big Buddha",
	[-1184600102] = "Avenue Of Stars",
	[520534137] = "Astronomy Museum",
	[-1079855971] = "Blue House Centre",
	[1766656099] = "Black Friday Plaza",
	[2108628511] = "Haunted Crypt",
	[-180369097] = "Corvin Castle",
	[-1803477641] = "Acropolis",
	[-216863966] = "Kielce Bus Station",
	[-1277330427] = "Venice Galleria",
	[205563584] = "Green Groove Centre",
	[-1532317272] = "St. Peter Basilica",
	[409967627] = "Autumn Heights",
	[-414798630] = "Washinton Square Park",
	[629213863] = "Alpha Marine Center",
	[620695153] = "Ponte Vecchio",
	[683993281] = "The Historic House",
	[1298106798] = "Alola Tower",
	[1510126778] = "Iolani Palace",
	[-1401203318] = "Traditional Luau",
	[-685787832] = "Khenhana Beach",
	[-1166536161] = "Waimea Beach",
	[-1186052379] = "Hawain State Capital",
	[187355302] = "Open Air Centre",
	[1941041141] = "Hawai State Museum",
	[-489269854] = "Legendary Holiday Tree",
	[-590989751] = "New Year Lightshow Tower",
	[2144017770] = "Year Of The Snake Celebration",
	[-1580035610] = "10Th Anniversary Hologram",
	[-456252505] = "Castle Llamagero",
	[1556525192] = "Ponte Llamagero",
	[793178520] = "Heritage Chapel",
	[-651427441] = "Renosance Garden",
	[-309762273] = "Verona Defense Fort (locked)",
	[-785900738] = "Hilltop Stronghold",
	[-1427731579] = "Heritage House",
	[774201245] = "Gothic Balisica",
	[1522983483] = "Historic Manuscript Library",
	[-875916150] = "Twirly Tower",
	[-236889205] = "Floating Home",
	[484993016] = "Unfolding House",
	[-96408078] = "Parted Towers",
	[-1790106580] = "Alpha Research Centre",
	[-936762729] = "Alpha Arts Cente",
	[-810354714] = "Sky Garden",
	[69125020] = "Alpha Museum",
	[1784267536] = "Alpha Mountain Retreat",
	[-1749904249] = "Alpha Drone Show",
	[-1497387043] = "Sufi Celestial",
	[-1274599052] = "Carnival Heritage Club",
	[-428080869] = "St. Patrick's Celebration",
	[-1271450751] = "Valentine's Plaza",
	[2035616490] = "Brutalist Research Hub",
	[-1935541789] = "Thameside Stage",
	[-1936359749] = "Twin Pillars",
	[625101342] = "Bolivarian Arts Venue",
	[757805349] = "Welbeck Street Car Park",
	[-167244696] = "Boston City Hall",
	[-120122398] = "Abraxas Urban Ensemble",
	[-1165507424] = "Brutalist Pavilion",
	[1447364585] = "Organic High Rise (Level 1)",
	[1447364586] = "Organic High Rise (Level 2)",
	[1447364587] = "Organic High Rise (Level 3)",
	[1447364588] = "Organic High Rise (Level 4)",
	[1447364589] = "Organic High Rise (Level 5)",
	[1447364590] = "Organic High Rise (Level 6)",
	[1906963775] = "Prague Central",
	[1591925015] = "Arley Halt",
	[1589159150] = "Tiny Lake Railway",
	[1425658847] = "Upside Down House",
	[1100099735] = "Floaty Fields",
	[1743863887] = "Carrot House (Level 1)",
	[1743863888] = "Carrot House (Level 2)",
	[1743863889] = "Carrot House (Level 3)",
	[1743863890] = "Carrot House (Level 4)",
	[1743863891] = "Carrot House (Level 5)",
	[1743863892] = "Carrot House (Level 6)",
	[1211627510] = "Railway Iron Bridge",
	[466030933] = "Old Pedestrian Railway Bridge",
	[-2085888839] = "Modern Pedestrian Railway Bridge",
	[305016823] = "Pyramid Complex",
	[-1757264638] = "Coptic Museum",
	[1048005211] = "Cairo Citadel",
	[-862309625] = "Portal Ruins",
	[-236636393] = "Great Sphinx Of Giza",
	[157195590] = "Babylon Fortress",
	[-1834825207] = "Egyptian Museum",
	[1342567062] = "Cairo Tower",
	[-609346807] = "Pyramid of Giza (Level 1)",
	[-609346806] = "Pyramid of Giza (Level 2)",
	[-609346805] = "Pyramid of Giza (Level 3)",
	[-609346804] = "Pyramid of Giza (Level 4)",
	[-609346803] = "Pyramid of Giza (Level 5)",
	[-609346802] = "Pyramid of Giza (Level 6)",
	[-609346801] = "Pyramid of Giza (Level 7)",
	[-609346800] = "Pyramid of Giza (Level 8)",
	[-609346799] = "Pyramid of Giza (Level 9)",
	[1366391897] = "Pyramid of Giza (Level 10)",
	[1366391898] = "Pyramid of Giza (Level 11)",
	[1366391899] = "Pyramid of Giza (Level 12)",
	[1366391900] = "Pyramid of Giza (Level 13)",
	[1366391901] = "Pyramid of Giza (Level 14)",
	[1366391902] = "Pyramid of Giza (Level 15)",
	[1366391903] = "Pyramid of Giza (Level 16)",
	[1366391904] = "Pyramid of Giza (Level 17)",
	[1366391905] = "Pyramid of Giza (Level 18)",
	[1366391906] = "Pyramid of Giza (Level 19)",
	[1366391930] = "Pyramid of Giza (Level 20)",
	[1366391931] = "Pyramid of Giza (Level 21)",
	[1366391932] = "Pyramid of Giza (Level 22)",
	[1366391933] = "Pyramid of Giza (Level 23)",
	[1366391934] = "Pyramid of Giza (Level 24)",
	[1366391935] = "Pyramid of Giza (Level 25)",
	[199753195] = "Sand Dunes",
	[-1703886276] = "Big Sand Dunes",
	[515263002] = "Chicago River Bridge",
	[1617510064] = "Gothic Tower",
	[1816026088] = "Chicago Opera House",
	[1293387173] = "Riverwalk",
	[-1411219283] = "Heritage Museum",
	[-195252968] = "The Chicago Tower",
	[1987176175] = "Lakeside Fountain",
	[1608682685] = "Lakefront Aquarium",
	[-1416711138] = "Chicago Skyline",
	[334579237] = "Chicago Pride House",
	[1566999288] = "Eco Aquaculture (Level 1)",
	[1566999289] = "Eco Aquaculture (Level 2)",
	[1566999290] = "Eco Aquaculture (Level 3)",
	[1566999291] = "Eco Aquaculture (Level 4)",
	[1566999292] = "Eco Aquaculture (Level 5)",
	[1566999293] = "Eco Aquaculture (Level 6)",
	[1804636742] = "Tid_csv_building_u67_ky_fushimi_shrine_title",
	[-775465278] = "Torii Trails Shrine (Level 1)",
	[-775465277] = "Torii Trails Shrine (Level 2)",
	[-775465276] = "Torii Trails Shrine (Level 3)",
	[-775465275] = "Torii Trails Shrine (Level 4)",
	[-775465274] = "Torii Trails Shrine (Level 5)",
	[-775465273] = "Torii Trails Shrine (Level 6)",
	[-775465272] = "Torii Trails Shrine (Level 7)",
	[-775465271] = "Torii Trails Shrine (Level 8)",
	[-775465270] = "Torii Trails Shrine (Level 9)",
	[179449650] = "Torii Trails Shrine (Level 10)",
	[179449651] = "Torii Trails Shrine (Level 11)",
	[179449652] = "Torii Trails Shrine (Level 12)",
	[-1378499416] = "Stage Of Tradition",
	[-1508803973] = "Royal Oasis",
	[-1575923728] = "Kinkaku-Ji Temple",
	[-1599892208] = "Clifftop Wonder",
	[177013036] = "Mystic Springs",
	[-220214956] = "Royal Fortress",
	[-100126122] = "To-Ji Complex",
	[-228456819] = "Whispering Woods",
	[731552464] = "Tid_csv_u67_children's_playschool_wip_title",
	[1921388748] = "Children's Playschool",
	[1966539511] = "Lucky Cat Teas",
	[-1156436419] = "The Great Loop",
	[527731446] = "Royal Blimp",
	[261713855] = "Tid_csv_building_u67_monaco_casino_title",
	[-767464037] = "Monaco Casino (Level 1)",
	[-767464036] = "Monaco Casino (Level 2)",
	[-767464035] = "Monaco Casino (Level 3)",
	[-767464034] = "Monaco Casino (Level 4)",
	[-767464033] = "Monaco Casino (Level 5)",
	[-767464032] = "Monaco Casino (Level 6)",
	[-767464031] = "Monaco Casino (Level 7)",
	[-767464030] = "Monaco Casino (Level 8)",
	[-767464029] = "Monaco Casino (Level 9)",
	[443490603] = "Monaco Casino (Level 10)",
	[443490604] = "Monaco Casino (Level 11)",
	[443490605] = "Monaco Casino (Level 12)",
	[443490606] = "Monaco Casino (Level 13)",
	[443490607] = "Monaco Casino (Level 14)",
	[443490608] = "Monaco Casino (Level 15)",
	[596591918] = "Racetrack Casino",
	[2115973200] = "Oceanographic Museum",
	[-1044241208] = "Prince's Palace Of Monaco",
	[853495105] = "Luxurious Resort",
	[-142637299] = "Villa La Vigie",
	[-1125213535] = "Tid_csv_building_u67_monaco_port_hercules_title",
	[318391613] = "Port Hercules (Level 1)",
	[318391614] = "Port Hercules (Level 2)",
	[318391615] = "Port Hercules (Level 3)",
	[318391616] = "Port Hercules (Level 4)",
	[318391617] = "Port Hercules (Level 5)",
	[318391618] = "Port Hercules (Level 6)",
	[318391619] = "Port Hercules (Level 7)",
	[318391620] = "Port Hercules (Level 8)",
	[318391621] = "Port Hercules (Level 9)",
	[1916988685] = "Port Hercules (Level 10)",
	[-315083456] = "Monaco St Charles Church",
	[543287961] = "Opera De Monte Carlo",
	[479429225] = "Monaco Heliport Beach",
	[-1107119793] = "Larvotto Beach",
	[973252888] = "Heritage Clock Tower",
	[887213816] = "Old Town Hall Munich",
	[-1088582301] = "Bavarian Museum",
	[-647879449] = "Ruhmeshalle & Bavariapark",
	[504574092] = "Brezel Bliss",
	[-1176884113] = "Munich Beverage Garden",
	[-754540411] = "Linderhof Castle",
	[998179718] = "Marienplatz Square",
	[1102264025] = "Neuschwanstein Castle",
	[1319228739] = "Nymphenburg Palace",
	[-679157993] = "Highlight Towers",
	[1027459450] = "Munich Town Hall",
	[-912233089] = "Oktoberfest Funfair (Level 1)",
	[-912233088] = "Oktoberfest Funfair (Level 2)",
	[-912233087] = "Oktoberfest Funfair (Level 3)",
	[-912233086] = "Oktoberfest Funfair (Level 4)",
	[-912233085] = "Oktoberfest Funfair (Level 5)",
	[-912233084] = "Oktoberfest Funfair (Level 6)",
	[-912233083] = "Oktoberfest Funfair (Level 7)",
	[-912233082] = "Oktoberfest Funfair (Level 8)",
	[-912233081] = "Oktoberfest Funfair (Level 9)",
	[-38920817] = "Oktoberfest Funfair (Level 10)",
	[-38920816] = "Oktoberfest Funfair (Level 11)",
	[-38920815] = "Oktoberfest Funfair (Level 12)",
	[-38920814] = "Oktoberfest Funfair (Level 13)",
	[-38920813] = "Oktoberfest Funfair (Level 14)",
	[-38920812] = "Oktoberfest Funfair (Level 15)",
	[107488769] = "Paranormal Research Lab",
	[1122908991] = "Ghost Mansion",
	[-1201967217] = "Ghost Help Center",
	[-1516863731] = "Completely Normal Cave",
	[-14557179] = "Abandoned Station",
	[-294203145] = "Vampire Cemetery",
	[-1845673808] = "Hunter's Quarters",
	[-592072296] = "Warewolf Lair",
	[-778728861] = "Completely Normal Library",
	[-126619542] = "Completely Normal Lighthouse",
	[-2079583356] = "Completely Normal Picnic",
	[842265531] = "Hunters Academy (Level 1)",
	[842265532] = "Hunters Academy (Level 2)",
	[842265533] = "Hunters Academy (Level 3)",
	[842265534] = "Hunters Academy (Level 4)",
	[842265535] = "Hunters Academy (Level 5)",
	[842265536] = "Hunters Academy (Level 6)",
	[842265537] = "Hunters Academy (Level 7)",
	[842265538] = "Hunters Academy (Level 8)",
	[842265539] = "Hunters Academy (Level 9)",
	[2024958795] = "Hunters Academy (Level 10)",
	[2024958796] = "Hunters Academy (Level 11)",
	[2024958797] = "Hunters Academy (Level 12)",
	[2024958798] = "Hunters Academy (Level 13)",
	[908361496] = "Ghost Portal (Level 1)",
	[908361497] = "Ghost Portal (Level 2)",
	[908361498] = "Ghost Portal (Level 3)",
	[908361499] = "Ghost Portal (Level 4)",
	[908361500] = "Ghost Portal (Level 5)",
	[908361501] = "Ghost Portal (Level 6)",
	[908361502] = "Ghost Portal (Level 7)",
	[908361503] = "Ghost Portal (Level 8)",
	[908361504] = "Ghost Portal (Level 9)",
	[-88841656] = "Ghost Portal (Level 10)",
	[-88841655] = "Ghost Portal (Level 11)",
	[-88841654] = "Ghost Portal (Level 12)",
	[-88841653] = "Ghost Portal (Level 13)",
	[-88841652] = "Ghost Portal (Level 14)",
	[-88841651] = "Ghost Portal (Level 15)",
	[-88841650] = "Ghost Portal (Level 16)",
	[-88841649] = "Ghost Portal (Level 17)",
	[-88841648] = "Ghost Portal (Level 18)",
	[-88841647] = "Ghost Portal (Level 19)",
	[-88841623] = "Ghost Portal (Level 20)",
	[-88841622] = "Ghost Portal (Level 21)",
	[-88841621] = "Ghost Portal (Level 22)",
	[-88841620] = "Ghost Portal (Level 23)",
	[-88841619] = "Ghost Portal (Level 24)",
	[-88841618] = "Ghost Portal (Level 25)",
	[-88841617] = "Ghost Portal (Level 26)",
	[2524003] = "Gamle Bybro",
	[-288345590] = "Akershus Fortress",
	[353417886] = "Gamlehaugen",
	[-100751298] = "Heddal Stave Church",
	[646123099] = "The King's Fortress",
	[906860659] = "Rider's Croft",
	[157593763] = "Vardohus Fortress",
	[310463261] = "Vargr's Fang",
	[1449579514] = "The Blacksmith's Forge",
	[-1665459077] = "Viking Longhouse",
	[1122918423] = "Viking Tavern",
	[1472071215] = "Viking Watchtower",
	[174672663] = "Viking Wall",
	[174097928] = "Viking Gate",
	[1165880784] = "The Fjord-Serpent (Level 1)",
	[1165880785] = "The Fjord-Serpent (Level 2)",
	[1165880786] = "The Fjord-Serpent (Level 3)",
	[1165880787] = "The Fjord-Serpent (Level 4)",
	[1165880788] = "The Fjord-Serpent (Level 5)",
	[1165880789] = "The Fjord-Serpent (Level 6)",
	[1165880790] = "The Fjord-Serpent (Level 7)",
	[1165880791] = "The Fjord-Serpent (Level 8)",
	[1165880792] = "The Fjord-Serpent (Level 9)",
	[-180639744] = "The Fjord-Serpent (Level 10)",
	[-180639743] = "The Fjord-Serpent (Level 11)",
	[-180639742] = "The Fjord-Serpent (Level 12)",
	[-180639741] = "The Fjord-Serpent (Level 13)",
	[-180639740] = "The Fjord-Serpent (Level 14)",
	[-180639739] = "The Fjord-Serpent (Level 15)",
	[-1650930023] = "Black Friday Square",
	[1298001] = "Thanksgiving House",
	[-2134091861] = "Santa's Airport (Level 1)",
	[-2134091860] = "Santa's Airport (Level 2)",
	[-2134091859] = "Santa's Airport (Level 3)",
	[-2134091858] = "Santa's Airport (Level 4)",
	[-2134091857] = "Santa's Airport (Level 5)",
	[-2134091856] = "Santa's Airport (Level 6)",
	[-2134091855] = "Santa's Airport (Level 7)",
	[-2134091854] = "Santa's Airport (Level 8)",
	[-2134091853] = "Santa's Airport (Level 9)",
	[-1705554629] = "Santa's Airport (Level 10)",
	[-1705554628] = "Santa's Airport (Level 11)",
	[-1705554627] = "Santa's Airport (Level 12)",
	[290447830] = "Snowman's Club",
	[-1483365311] = "Bauble Restaurant",
	[-1751147328] = "Santa Post Office",
	[-602613545] = "Cozy Inn",
	[-798223803] = "Frozen Fountain",
	[697106250] = "Frozen Lake Lighthouse",
	[-2089765092] = "Gingerbread Mansion",
	[-1640460074] = "Reindeer Stable",
	[596946528] = "Santa's Castle",
	[1703812238] = "Santa's Express",
	[-2038009582] = "Holiday Ice Park",
	[1244998746] = "Giant Santa",
	[1273366] = "New Year Clock Tower (locked)",
	[1408975735] = "Castillo Del Moro",
	[-1917094736] = "Museum of Fine Arts",
	[2010575615] = "Cahuita Beach",
	[1841906504] = "Casa Amarilla",
	[1083481252] = "Castillo Azul",
	[-1192642314] = "The Diquis Spheres",
	[-1495640388] = "Edifício Metálico",
	[-517883782] = "Fort Heredia",
	[-1914537590] = "Irazu Volcano",
	[-1860597777] = "La Casona",
	[-515256005] = "Costa Rica Museum",
	[1214290160] = "Costa Rica Theater",
	[1429965560] = "Cahuita Slot Center",
	[-183618441] = "Coffee Farm (Level 1)",
	[-183618440] = "Coffee Farm (Level 2)",
	[-183618439] = "Coffee Farm (Level 3)",
	[-183618438] = "Coffee Farm (Level 4)",
	[-183618437] = "Coffee Farm (Level 5)",
	[-183618436] = "Coffee Farm (Level 6)",
	[-183618435] = "Coffee Farm (Level 7)",
	[-183618434] = "Coffee Farm (Level 8)",
	[-183618433] = "Coffee Farm (Level 9)",
	[-1764441209] = "Coffee Farm (Level 10)",
	[-1764441208] = "Coffee Farm (Level 11)",
	[-1764441207] = "Coffee Farm (Level 12)",
	[1545932128] = "Billboard Tower",
	[2053983474] = "The Night Market",
	[938195855] = "Neon Noodle Shop",
	[-98026244] = "Worker's Apartment",
	[214609986] = "Neon Walkway",
	[989916564] = "NeonCorp Tower",
	[198536949] = "The Lair Tower",
	[438386730] = "Future Hi-Rise",
	[1636054385] = "Cyber Lighthouse",
	[-1773435338] = "Neon Diner",
	[1224858325] = "Neon Nightclub",
	[-1505232642] = "CyberBowl Arena",
	[489126139] = "Neon Heart's Fountain",
	[1738728017] = "Neon Arcade (Level 1)",
	[1738728018] = "Neon Arcade (Level 2)",
	[1738728019] = "Neon Arcade (Level 3)",
	[1738728020] = "Neon Arcade (Level 4)",
	[1738728021] = "Neon Arcade (Level 5)",
	[1738728022] = "Neon Arcade (Level 6)",
	[1738728023] = "Neon Arcade (Level 7)",
	[1738728024] = "Neon Arcade (Level 8)",
	[1738728025] = "Neon Arcade (Level 9)",
	[1543449761] = "Neon Arcade (Level 10)",
	[1543449762] = "Neon Arcade (Level 11)",
	[1543449763] = "Neon Arcade (Level 12)",
	[1543449764] = "Neon Arcade (Level 13)",
	[1543449765] = "Neon Arcade (Level 14)",
	[1543449766] = "Neon Arcade (Level 15)",
	[1948622172] = "FireHorse Sculpture",
	[-941608828] = "High Tech Police Department (Level 1)",
	[1450980417] = "High Tech Police Department (Level 2)",
	[1450980418] = "High Tech Police Department (Level 3)",
	[1450980419] = "High Tech Police Department (Level 4)",
	[1450980420] = "High Tech Police Department (Level 5)",
	[1450980421] = "High Tech Police Department (Level 6)",
	[1450980422] = "High Tech Police Department (Level 7)",
	[1450980423] = "High Tech Police Department (Level 8)",
	[1450980424] = "High Tech Police Department (Level 9)",
	[637713520] = "High Tech Police Department (Level 10)",
	[-947779634] = "High Tech Fire Department (Level 1)",
	[-1265942709] = "High Tech Fire Department (Level 2)",
	[-1265942708] = "High Tech Fire Department (Level 3)",
	[-1265942707] = "High Tech Fire Department (Level 4)",
	[-1265942706] = "High Tech Fire Department (Level 5)",
	[-1265942705] = "High Tech Fire Department (Level 6)",
	[-1265942704] = "High Tech Fire Department (Level 7)",
	[-1265942703] = "High Tech Fire Department (Level 8)",
	[-1265942702] = "High Tech Fire Department (Level 9)",
	[1173563578] = "High Tech Fire Department (Level 10)",
	[-1445203177] = "High Tech Medical Center (Level 1)",
	[-1521921548] = "High Tech Medical Center (Level 2)",
	[-1521921547] = "High Tech Medical Center (Level 3)",
	[-1521921546] = "High Tech Medical Center (Level 4)",
	[-1521921545] = "High Tech Medical Center (Level 5)",
	[-1521921544] = "High Tech Medical Center (Level 6)",
	[-1521921543] = "High Tech Medical Center (Level 7)",
	[-1521921542] = "High Tech Medical Center (Level 8)",
	[-1521921541] = "High Tech Medical Center (Level 9)",
	[1316196483] = "High Tech Medical Center (Level 10)",
	[1767103065] = "Maxis Fortress (Level 1)",
	[1767103066] = "Maxis Fortress (Level 2)",
	[1767103067] = "Maxis Fortress (Level 3)",
	[1767103068] = "Maxis Fortress (Level 4)",
	[1767103069] = "Maxis Fortress (Level 5)",
	[1767103070] = "Maxis Fortress (Level 6)",
	[1767103071] = "Maxis Fortress (Level 7)",
	[1767103072] = "Maxis Fortress (Level 8)",
	[1767103073] = "Maxis Fortress (Level 9)",
	[-1815140951] = "Maxis Fortress (Level 10)",
	[-1815140950] = "Maxis Fortress (Level 11)",
	[-1815140949] = "Maxis Fortress (Level 12)",
	[-1815140948] = "Maxis Fortress (Level 13)",
	[-1815140947] = "Maxis Fortress (Level 14)",
	[-1815140946] = "Maxis Fortress (Level 15)",
	[-1383749794] = "Adoption Center",
	[-532409638] = "Bunny Café",
	[1592379678] = "Pony Stables",
	[487568484] = "St. Patrick's Fountain",
	[-208095773] = "The Grand Cat",
	[367596984] = "The Loyal Friend",
	[-1958338990] = "Petting Zoo",
	[-1650032148] = "Bubbly Bunny Spa",
	[-10488098] = "Pooch Palace",
	[2093954214] = "Puppy Paradise",
	[376088654] = "Reptile Sanctuary",
	[-53034311] = "Pet Supply Store",
	[-1951859690] = "Caring Hearts Clinic (Level 1)",
	[-1951859689] = "Caring Hearts Clinic (Level 2)",
	[-1951859688] = "Caring Hearts Clinic (Level 3)",
	[-1951859687] = "Caring Hearts Clinic (Level 4)",
	[-1951859686] = "Caring Hearts Clinic (Level 5)",
	[-1951859685] = "Caring Hearts Clinic (Level 6)",
	[-1951859684] = "Caring Hearts Clinic (Level 7)",
	[-1951859683] = "Caring Hearts Clinic (Level 8)",
	[-1951859682] = "Caring Hearts Clinic (Level 9)",
	[13139718] = "Caring Hearts Clinic (Level 10)",
	[1658205288] = "Llama Pastures",
	[1472889950] = "Big Llama Pastures",
	[233812440] = "Pets Amusement Park (Level 1)",
	[233812441] = "Pets Amusement Park (Level 2)",
	[233812442] = "Pets Amusement Park (Level 3)",
	[233812443] = "Pets Amusement Park (Level 4)",
	[233812444] = "Pets Amusement Park (Level 5)",
	[233812445] = "Pets Amusement Park (Level 6)",
	[233812446] = "Pets Amusement Park (Level 7)",
	[233812447] = "Pets Amusement Park (Level 8)",
	[233812448] = "Pets Amusement Park (Level 9)",
	[-874124024] = "Pets Amusement Park (Level 10)",
	[-874124023] = "Pets Amusement Park (Level 11)",
	[-874124022] = "Pets Amusement Park (Level 12)",
	[-874124021] = "Pets Amusement Park (Level 13)",
	[-874124020] = "Pets Amusement Park (Level 14)",
	[-874124019] = "Pets Amusement Park (Level 15)",
	[-2009450018] = "Ramadan Palace",
	[-487921576] = "Space Test Center",
	[-1785388164] = "Mission Control Center",
	[-133726632] = "Space Environments Complex",
	[1610412181] = "Space Flight Center",
	[-273451499] = "Michoud Assembly Facility",
	[-1784786146] = "Multi-Payload Processing Facility",
	[-676434706] = "Operations & Checkout Facility",
	[1900473521] = "Pegasus Barge",
	[-2079933462] = "Rotation, Processing and Surge Facility",
	[184225616] = "Orion Splashdown Site",
	[283751497] = "Space Center Visitor Complex",
	[214142813] = "Artemis II Rocket (Level 1)",
	[214142814] = "Artemis II Rocket (Level 2)",
	[214142815] = "Artemis II Rocket (Level 3)",
	[214142816] = "Artemis II Rocket (Level 4)",
	[214142817] = "Artemis II Rocket (Level 5)",
	[214142818] = "Artemis II Rocket (Level 6)",
	[214142819] = "Artemis II Rocket (Level 7)",
	[214142820] = "Artemis II Rocket (Level 8)",
	[214142821] = "Artemis II Rocket (Level 9)",
	[-1523221715] = "Artemis II Rocket (Level 10)",
	[-1523221714] = "Artemis II Rocket (Level 11)",
	[-1523221713] = "Artemis II Rocket (Level 12)",
	[-1523221712] = "Artemis II Rocket (Level 13)",
	[-1523221711] = "Artemis II Rocket (Level 14)",
	[-1523221710] = "Artemis II Rocket (Level 15)",
}

local presets = {
	["👑 Mayor Pass"] = {
		["Season 1 - Americana - Part 1"] = {
			{ id = -696532419, name = "SimCity Bank" },
			{ id = -970872132, name = "Backyard Basketball" },
			{ id = -177840672, name = "Crispy Clean Laundry Wash" },
			{ id = -2017049381, name = "SimCity Telephone Company" },
			{ id = 1936070297, name = "Rustling Pages Bookstore" },
			{ id = -2105219743, name = "SimCity Newspaper Office" },
			{ id = -2141420504, name = "Hair and Clippers Salon" },
			{ id = 1085959474, name = "Post Office" },
			{ id = -228481548, name = "Sunset Diner" },
			{ id = 1500570218, name = "Roller Skating Lounge" },
			{ id = -557351818, name = "Firewheel Lounge" },
		},
		["Season 1 - Americana - Part 2"] = {
			{ id = 670564972, name = "Vinyl Fever Record Store" },
			{ id = 505963531, name = "Italian Restaurant" },
			{ id = -1497178654, name = "The Sleeping Llama Motel" },
			{ id = -1932365988, name = "Pretty Petals Flower Store" },
			{ id = -158801032, name = "Great Gas Station" },
			{ id = -1973724413, name = "New Wheels Car Dealer" },
			{ id = 107684920, name = "Big Leagues Bowling Alley" },
			{ id = 1169034027, name = "Foods and Stuffs Store" },
			{ id = -1128528791, name = "Mysterious Scrapyard" },
			{ id = -1678069979, name = "Swingy Tunes Jazz Club" },
			{ id = -856463128, name = "Hill Of Romance" },
		},
		["Season 1 - Americana - Part 3"] = {
			{ id = -1380596413, name = "The Shaky Milkshake Lounge" },
			{ id = 1350015626, name = "Seaplane Dock" },
			{ id = 2061628404, name = "Relaxing Trailer Camp" },
		},
		["Season 2 - Venice - Part 1"] = {
			{ id = -1460235956, name = "Restaurant Sapori" },
			{ id = -764851151, name = "Garden La Pace" },
			{ id = -1941533902, name = "Bridge Classico" },
			{ id = 1522577122, name = "Venice Apartments" },
			{ id = -51470732, name = "Garden Autunno" },
			{ id = 207097599, name = "Museum of Saggezza" },
			{ id = 529718016, name = "Patio Amore" },
			{ id = 1334986002, name = "Garden Storico" },
			{ id = 534967956, name = "Canal Tower" },
			{ id = -26743007, name = "Bridge Le Case" },
			{ id = 520733631, name = "Venice Hotel" },
		},
		["Season 2 - Venice - Part 2"] = {
			{ id = 1783384776, name = "Gondola Station" },
			{ id = -1630168928, name = "Bridge of Bellezza" },
			{ id = -765318734, name = "Cafe Limone" },
			{ id = -12337183, name = "Harbor Paradiso" },
			{ id = 1144653927, name = "Fountain Della Natura" },
			{ id = 973779621, name = "Waterfall Dei Sogni" },
			{ id = 537112411, name = "Villa Classica" },
		},
		["Season 3 - Winter Downtown"] = {
			{ id = 1008927481, name = "Toys and Joys Store" },
			{ id = 1303921313, name = "The Hot Cup" },
			{ id = 1596383402, name = 'The "Say Cheese!" Store' },
			{ id = 2094173274, name = "Holiday Decorations Store" },
			{ id = -554306193, name = "The Clock Master's Workshop" },
			{ id = 969789273, name = "Sausage Store" },
			{ id = 1897965091, name = "The Hopping Hare Tavern" },
			{ id = -578627710, name = "Cups and Cakes Bakery" },
			{ id = -993772563, name = "Old Town Market" },
			{ id = -234823370, name = "The Chocolatiere" },
		},
		["Season 4 - Alpine"] = {
			{ id = -692599993, name = "Observation Deck" },
			{ id = 71878264, name = "Canalside Manor" },
			{ id = -21879615, name = "The Grand Ol' Clock" },
			{ id = 1748288711, name = "The Wired Frames Museum" },
			{ id = -782313601, name = "Canalside Inn" },
			{ id = 1280256681, name = "Fountain on a Lake" },
			{ id = 940927790, name = "The Fun Funicular" },
			{ id = -1541713815, name = "Gondola Elevator" },
			{ id = -528257565, name = "The Swiss Farm" },
			{ id = -658932724, name = "Fluffy Pillows Hotel" },
		},
		["Season 5 - Reclaimed by Nature"] = {
			{ id = 1654598105, name = "Green Heights" },
			{ id = 1654598104, name = "Vine Apartments" },
			{ id = 1420331730, name = "Repurposed Bus" },
			{ id = 628949972, name = "Pet Supply Store" },
			{ id = -793195255, name = "Glamorous Camping Site" },
			{ id = 1352191295, name = "Vegan Restaurant" },
			{ id = 841927665, name = "Animal Santuary" },
			{ id = -1028564481, name = "Vet Clinic" },
			{ id = 1009787955, name = "Reclaimed Oil Tanker" },
			{ id = -1832028984, name = "Pet Activity Park" },
		},
		["Season 6 - Back to Green"] = {
			{ id = -2099637388, name = "Handicraft Store" },
			{ id = -894379818, name = "Thrift Shop" },
			{ id = -283640548, name = "Community Garden" },
			{ id = 500120150, name = "Sustainable Goods Store" },
			{ id = 1049672355, name = "Smoothie Bar" },
			{ id = -63404680, name = "Colorful Apartments" },
			{ id = 185478176, name = "Open Air Theatre" },
			{ id = 1270694914, name = "Flea Market" },
			{ id = -1155711237, name = "Repurposed Airline" },
			{ id = -1080667116, name = "Community Hobbies Park" },
		},
		["Season 7 - America Latina"] = {
			{ id = -1133929159, name = "Parque da Capoeira" },
			{ id = -607576542, name = "Banana Stand" },
			{ id = 1827563311, name = "Tango Ballroom" },
			{ id = -1493889867, name = "Funicular de Santiago" },
			{ id = 842987971, name = "Galeria de arte Frida" },
			{ id = -488049658, name = "Gateway to Xibalba" },
			{ id = -1631602454, name = "Rainforest Waterpark" },
			{ id = -488049655, name = "Sacred Ballgame Court" },
			{ id = 333883096, name = "Castillo del Mar" },
		},
		["Season 8 - Transamericana"] = {
			{ id = 1228122528, name = "Sunday Street Market" },
			{ id = -2099185443, name = "Street Football Pitch" },
			{ id = -455011019, name = "Fancy Drinks Hideout" },
			{ id = -871762519, name = "Mate Shop" },
			{ id = -1357897112, name = "Pyramid of Quetzal" },
			{ id = -263230876, name = "Las Cascadas" },
			{ id = 285565628, name = "Buccaneer Isle" },
			{ id = -1357897111, name = "Plaza del Tollan" },
			{ id = 1978796257, name = "Museum of Ancient Heritage" },
		},
		["Season 9 - Crafts and Trades"] = {
			{ id = -593976775, name = "Ye Olde Bell Tower" },
			{ id = -257752610, name = "Evergreen Granary" },
			{ id = -1862155080, name = "Fancy Stables" },
			{ id = 582727808, name = "Guard House B&B" },
			{ id = 896170607, name = "Goose Feather Inn" },
			{ id = -543711205, name = "The Useless Watermill" },
			{ id = 442916474, name = "Apothecary" },
			{ id = 1279913324, name = "Blacksmith Workshop" },
			{ id = 1710067716, name = "Commander's Armory" },
		},
		["Season 10 - Ladies and Lords"] = {
			{ id = -1048470682, name = "Victorian Fountain" },
			{ id = 319647626, name = "Alchemist Lab" },
			{ id = -1375918246, name = "Golden Llama Guild House" },
			{ id = -1710867123, name = "The Precious Goldsmith" },
			{ id = -333981562, name = "Merchant's Warehouse" },
			{ id = 2143678023, name = "Spice Merchant" },
			{ id = -1312883509, name = "Historical Townhall" },
			{ id = -554928826, name = "Silk Merchant" },
			{ id = -801555592, name = "Secret Garden" },
		},
		["Season 11 - Hygge Winter"] = {
			{ id = -945196983, name = "Markku's Cat Cafe" },
			{ id = 1981990599, name = "Quaint Market Hall" },
			{ id = 754741008, name = "Knitting Shop" },
			{ id = -2127509491, name = "Cross Country Ski Tracks" },
			{ id = -1648844348, name = "Scandinavian Design Shop" },
			{ id = 286933340, name = "Modern Library" },
			{ id = -768043684, name = "Dining Hall" },
		},
		["Season 12 - The Year of the Ox"] = {
			{ id = -72260370, name = "Oilpaper Umbrella Shop" },
			{ id = -946221856, name = "Dainty Drunkery" },
			{ id = 1242816945, name = "Mellow Winery" },
			{ id = -1920032065, name = "Satin Workshop" },
			{ id = -533994156, name = "Welcoming Inn" },
			{ id = 107636924, name = "Chinese Food Stalls" },
			{ id = 1218180180, name = "Pavillion of Niu" },
			{ id = -485751013, name = "Temple of the Matchmaker" },
		},
		["Season 13 - Australian Outback"] = {
			{ id = 241887055, name = "Koala Grove" },
			{ id = -1767311992, name = "Windmill Water Pump" },
			{ id = 1900459706, name = "Kangaroo Field" },
			{ id = 1702848470, name = "Black Swan Lake" },
			{ id = 12057423, name = "Outback Station" },
			{ id = 1271747456, name = "Crocodile Swamp" },
			{ id = -2131349190, name = "Uluru" },
			{ id = 531443048, name = "Emu Plains" },
		},
		["Season 14 - The Timeless Sands"] = {
			{ id = 98625425, name = "Corniche of Gulf" },
			{ id = -1544783970, name = "Tea House" },
			{ id = -372746083, name = "Spice Souk" },
			{ id = -1629765520, name = "Wool Rug Bazaar" },
			{ id = -777265174, name = "Fountain Plaza" },
			{ id = 1550327562, name = "Falconry Demonstration" },
			{ id = -768450959, name = "Ksar of Ait-Benhaddou" },
			{ id = 250769903, name = "Camel Racing Track" },
		},
		["Season 15 - Roman Holiday"] = {
			{ id = -894737628, name = "Pantheon" },
			{ id = -212251862, name = "Castle Sant' Angelo" },
			{ id = 382366963, name = "Fontana de Trevi" },
			{ id = 2089810913, name = "Colosseum" },
			{ id = -1974175156, name = "Roman Forum" },
			{ id = 330989771, name = "Altare Della Patria" },
			{ id = 577541131, name = "Arch of Constatine" },
			{ id = -573061988, name = "Ponte Milvio" },
		},
		["Season 16 - Thrill City"] = {
			{ id = -2056847937, name = "Dinosaur Safari Ride" },
			{ id = 1622396365, name = "Teacup Ride" },
			{ id = 830720788, name = "Haunted House" },
			{ id = 240217640, name = "Pirate Bay" },
			{ id = -891421167, name = "Carnival Games Square" },
			{ id = -1240507161, name = "Ferris Wheel" },
			{ id = -42524362, name = "Volcano Roller Coaster" },
			{ id = -1055848850, name = "Jungle Adventure" },
		},
		["Season 17 - Changing Colors"] = {
			{ id = 2139952231, name = "Victoria Inner Harbor" },
			{ id = -1079660811, name = "Amsterdam Canal North" },
			{ id = -1079660810, name = "Amsterdam Canal South" },
			{ id = 598362567, name = "Tuscany Villa" },
			{ id = 1849903047, name = "Rice Fields of Yunnan" },
			{ id = -442615840, name = "Japanese Garden" },
			{ id = 396572438, name = "Hohenschwangau Castle" },
			{ id = 644629827, name = "Luxembourg Garden" },
			{ id = -425463249, name = "Central Park North" },
			{ id = -425463248, name = "Central Park South" },
		},
		["Season 18 - Back to the 80s"] = {
			{ id = 253685910, name = "Sports Car Dealer" },
			{ id = -1555027266, name = "Aerobics and Gym" },
			{ id = 656179119, name = "Movie Rental" },
			{ id = -299732246, name = "The Arcade" },
			{ id = 761321168, name = "The Mall" },
			{ id = 1246751658, name = "Hair Salon" },
			{ id = 1865403167, name = "Santa C. Beach" },
			{ id = 1309962697, name = "Outdoors Concert" },
		},
		["Season 19 - Finland"] = {
			{ id = 1389981153, name = "Turku Castle" },
			{ id = -819221854, name = "Summer Cabin" },
			{ id = 710609386, name = "Alvar Aalto Culture House" },
			{ id = 1930061771, name = "Hvittrask Mansion" },
			{ id = -629253655, name = "Helsinki Cathedral" },
			{ id = -1862811391, name = "Hame Castle" },
			{ id = -1689258632, name = "Helsinki Central Railway Station" },
			{ id = -1179688954, name = "Olavinlinna" },
		},
		["Season 20 - Maori"] = {
			{ id = -583795522, name = "Maori Houses" },
			{ id = -1012113601, name = "Pouwhenua" },
			{ id = 576934165, name = "Pataka" },
			{ id = -776112980, name = "Waka Boat Harbor" },
			{ id = -977230501, name = "Maori Gate" },
			{ id = -1264728310, name = "Whale Watch" },
			{ id = 2034183851, name = "Maori Pa" },
			{ id = -839748800, name = "Haka Rugby Pitch" },
		},
		["Season 21 - Japan"] = {
			{ id = -87846684, name = "Japanese Riverside Mansions" },
			{ id = -87846683, name = "Japanese Riverside Houses" },
			{ id = -924392878, name = "Dance of Maiko" },
			{ id = 312533906, name = "Dagashiya" },
			{ id = 615625595, name = "Ryokan" },
			{ id = 1341507156, name = "Deer Park" },
			{ id = 1889845484, name = "Fishing Harbor" },
			{ id = -150978828, name = "Mountain Onsen" },
			{ id = -502533960, name = "Mountain Temple" },
			{ id = -1624139448, name = "Seaside Village" },
		},
		["Season 22 - Paris"] = {
			{ id = -652644598, name = "Jardin des Plantes" },
			{ id = 1960640040, name = "Parisan Brasserie" },
			{ id = 983359304, name = "Musee d Orsay" },
			{ id = -1714055807, name = "Pere Lachaise Cemetery" },
			{ id = 1714323392, name = "Parc des Buttes Chaumont" },
			{ id = -1125378079, name = "Grand Palais" },
			{ id = 404047226, name = "Notre-Dame" },
			{ id = -1062501529, name = "Sacre-Coeur" },
		},
		["Season 23 - Farm Life"] = {
			{ id = -1930074002, name = "Old Farmhouse" },
			{ id = -860866556, name = "Rustic Windmill" },
			{ id = 510579264, name = "Backyard Farm" },
			{ id = 1957301671, name = "Pig Pen" },
			{ id = 575885449, name = "Poultry Haven" },
			{ id = -1187326347, name = "Goat Park" },
			{ id = 1456232080, name = "Cow Fields" },
			{ id = -1894544896, name = "Stables" },
		},
		["Season 24 - Rustic Village Living"] = {
			{ id = 1919804018, name = "Rustic Village Center" },
			{ id = 2054415556, name = "Rustic Village School" },
			{ id = -755124704, name = "Rustic Village Boat Harbor" },
			{ id = 1919804019, name = "Rustic Village Market" },
			{ id = 344006469, name = "Rustic Village Restaurant" },
			{ id = -2103635199, name = "Rustic Village Inn" },
			{ id = 1386839066, name = "Rustic Village Bakery" },
			{ id = -108120760, name = "Rustic Village Bus Station" },
		},
		["Season 25 - New York City"] = {
			{ id = 1559447138, name = "Broadway" },
			{ id = -1284290513, name = "West Village" },
			{ id = -1922483555, name = "Campus Park" },
			{ id = -527812764, name = "Monument Library" },
			{ id = 1128428129, name = "Coney Island Boardwalk" },
			{ id = -19070014, name = "Museum of Art" },
			{ id = 1577362781, name = "Big Main Terminal" },
			{ id = -320983781, name = "Times Square" },
		},
		["Season 26 - Alpha City"] = {
			{ id = 576980653, name = "Alpha Yatch Club" },
			{ id = -1614793130, name = "Alpha Loop Park" },
			{ id = 1460105340, name = "Rainforest Towers" },
			{ id = -1442679463, name = "Vertical Garden" },
			{ id = 2114260105, name = "Alpha Science Center" },
			{ id = -1504007666, name = "Vertical Farm" },
			{ id = -2126297497, name = "Rotating Tower" },
			{ id = 1282916073, name = "Pebble Towers" },
		},
		["Season 27 - European Classics"] = {
			{ id = -1009705288, name = "Holiday Concert Hall" },
			{ id = -1859541172, name = "Winter Garden" },
			{ id = -981667126, name = "Piece de Bridgestane" },
			{ id = 821544135, name = "Cathedral Azure" },
			{ id = -895051274, name = "Museum of Festivities" },
			{ id = -1236049903, name = "Winter Brasserie" },
			{ id = 493374285, name = "Galeries d'Art Nouveau" },
		},
		["Season 28 - Dream Holiday"] = {
			{ id = 1198460338, name = "Saturday Flea Market" },
			{ id = -865785951, name = "Hilltop Party" },
			{ id = -2096551982, name = "Panjim Church" },
			{ id = 1641938245, name = "Basilica of Goa" },
			{ id = -1278194285, name = "Palolem Beach" },
			{ id = -1422692172, name = "Fort Aguada" },
			{ id = -2045014629, name = "Dudhsagar Falls" },
			{ id = 2062223335, name = "Floating Casinos" },
		},
		["Season 29 - Castles of Spain"] = {
			{ id = 678737156, name = "Castle of Towers" },
			{ id = -176279625, name = "Country Castle" },
			{ id = 1634727086, name = "Island Fort" },
			{ id = -717173652, name = "City Palace" },
			{ id = 1394616471, name = "Explorer's Castle" },
			{ id = 88433670, name = "Beach Castle" },
			{ id = -1664539688, name = "Castle of the Knights" },
			{ id = -1340825602, name = "Grand Fotress" },
		},
		["Season 30 - Florence"] = {
			{ id = 1873405464, name = "Cathedral of Flowers" },
			{ id = 978473037, name = "Renaissance Gallery" },
			{ id = 795748, name = "Government Plaza" },
			{ id = -359649998, name = "Old Palace" },
			{ id = -1235643528, name = "Square of da Simci" },
			{ id = -1021810549, name = "Grand Gardens" },
			{ id = 1396765115, name = "Garden Palace" },
			{ id = 1942240922, name = "Romanesque Basilica" },
		},
		["Season 31 - Fabulous Florida"] = {
			{ id = -1356181244, name = "Oceanside Drive" },
			{ id = -381057314, name = "Llamawood Urban Art" },
			{ id = 112132293, name = "Sunscape Bridge" },
			{ id = 869619892, name = "SimCar Racetrack" },
			{ id = -1885237895, name = "Cypress Swamp" },
			{ id = -1780624383, name = "Fort Danielson" },
			{ id = -428777932, name = "Adventure Kingdom" },
			{ id = 1775919191, name = "Sim West Quater" },
		},
		["Season 32 - Iceland"] = {
			{ id = -541487860, name = "Strokkur Geyser" },
			{ id = 1044093808, name = "Versla Main Street" },
			{ id = 1116497278, name = "Tall Church" },
			{ id = -990074740, name = "Hvitserkur Beach" },
			{ id = 671412064, name = "Viking Village" },
			{ id = -456229876, name = "Svinafellsjokull Glacier" },
			{ id = -488981582, name = "Seljalandsfoss Waterfall" },
			{ id = 1786836125, name = "Sapphire Cove" },
		},
		["Season 33 - London"] = {
			{ id = -1729576167, name = "Columbia Road Flower Market" },
			{ id = 816337669, name = "Red House" },
			{ id = -784692519, name = "Fragment" },
			{ id = 2069092396, name = "Kensington Palace" },
			{ id = 980195054, name = "Westminster Abbey" },
			{ id = 1526054020, name = "Tower Bridge" },
			{ id = 1914030145, name = "Tower of London" },
			{ id = -1460626377, name = "British Museum" },
		},
		["Season 34 - Tokyo"] = {
			{ id = 1313095612, name = "Tocho" },
			{ id = 1813755749, name = "Mode Gakuen Cocoon Tower" },
			{ id = -1310451524, name = "Tokyo Cathedral" },
			{ id = 822235988, name = "Tokyo International Forum" },
			{ id = -1367238659, name = "Nakagin Capsule Tower" },
			{ id = -1564298652, name = "Tokyo Big Sight" },
		},
		["Season 35 - Super Services"] = {
			{ id = -12118106, name = "Sewage Reclamation Plant" },
			{ id = 1575952079, name = "Fresh Water Pumping Station" },
			{ id = -747375459, name = "Concentrated Solar Power Plant" },
			{ id = 423504374, name = "Waste to Energy Plant" },
			{ id = -898048097, name = "Police Headquaters" },
			{ id = 1840116317, name = "Grand Fire Station" },
		},
		["Season 36 - Lapland of Today"] = {
			{ id = -638228376, name = "Arctic Aquarium" },
			{ id = 2138768342, name = "Lean Library" },
			{ id = -1961743034, name = "Nordic Church" },
			{ id = -1515743305, name = "Lofoten" },
			{ id = 26934349, name = "Treehouse Resort" },
			{ id = 649295752, name = "Northern Museum" },
		},
		["Season 37 - Thailand"] = {
			{ id = -518370055, name = "Temple of Dawn" },
			{ id = -811436871, name = "Tusk Tower" },
			{ id = 208677870, name = "Pixel Tower" },
			{ id = -1129122371, name = "Dragon Temple" },
			{ id = 1072852587, name = "Robo Tower" },
			{ id = 1747127097, name = "Phi Phi Islands" },
		},
		["Season 38 - Historic Prague"] = {
			{ id = -1042592443, name = "The Powder Tower" },
			{ id = -971391086, name = "Charles Bridge" },
			{ id = -84591751, name = "Quadrio Center" },
			{ id = 1544098790, name = "Petrin Tower" },
			{ id = -2099908710, name = "Old Town Square" },
			{ id = 1073072576, name = "Prague Castle" },
		},
		["Season 39 - Ireland"] = {
			{ id = -615692973, name = "Wonderful Barn" },
			{ id = 124241177, name = "Newgrange" },
			{ id = 2095303906, name = "Giant's Causeway" },
			{ id = -264244925, name = "Castle of Eloquence" },
			{ id = 1180472101, name = "Doctor's Abbey" },
			{ id = 370759245, name = "Rock of Cashel" },
		},
		["Season 40 - Cancun"] = {
			{ id = -918601870, name = "Scenic Tower" },
			{ id = -1235671757, name = "Tulum Ruins" },
			{ id = -2061240207, name = "Mercado 28 Market" },
			{ id = -1647877560, name = "Xoximilco" },
			{ id = 1434641713, name = "Cancun Aquarium" },
			{ id = 773330339, name = "Hotel Zone" },
		},
		["Season 41 - Cape Town"] = {
			{ id = 1290075004, name = "Castle of Good Hope" },
			{ id = 1077878471, name = "Boulders Beach" },
			{ id = 526649619, name = "Cape Point Lighthouse" },
			{ id = -1800058036, name = "Cape Town Stadium" },
			{ id = -124885990, name = "African Safari" },
			{ id = -761420415, name = "Cape Town Waterfront" },
		},
		["Season 42 - Route 66"] = {
			{ id = -2005087996, name = "Blue Llama Market" },
			{ id = -646372006, name = "Flip-Flop Motel" },
			{ id = 848369710, name = "500 Soda Stop" },
			{ id = 1031128507, name = "Blue Butterfly Motel" },
			{ id = -1275569118, name = "UFO Estate" },
			{ id = -205731966, name = "Cucamonga Station" },
		},
		["Season 43 - Barcelona"] = {
			{ id = 591847594, name = "La Rambla Street" },
			{ id = -425205559, name = "La Pedrera" },
			{ id = 88852693, name = "Park Guell" },
			{ id = 1026382411, name = "Catalonia Square" },
			{ id = 465188623, name = "Cathedral of the Sea" },
			{ id = -672425292, name = "Sagrada Familia" },
		},
		["Season 44 - Rio de Janeiro"] = {
			{ id = -1294489020, name = "Magic Stairs" },
			{ id = 925006678, name = "Palácio Do Catete (locked)" },
			{ id = -67713006, name = "Rio Beaches (locked)" },
			{ id = 873877609, name = "Llama's Landmark" },
			{ id = -1873109675, name = "Sugarloaf Mountain" },
			{ id = 299388908, name = "Jardim Botanico" },
		},
		["Season 45 - Sydney"] = {
			{ id = -888911843, name = "The One park" },
			{ id = -1037153604, name = "Beam Wireless" },
			{ id = -957241066, name = "Green Exchange (locked)" },
			{ id = 1942083942, name = "Maritime Museum (Locked)" },
			{ id = 1005029538, name = "Australian Museum" },
			{ id = -1644752812, name = "The Flower Bud (locked)" },
		},
		["Season 46 - Amsterdam"] = {
			{ id = -1079914711, name = "The Gooyer Windmill" },
			{ id = 1324835889, name = "Amsterdam Art Museum" },
			{ id = 751497775, name = "Stedeljik Museum" },
			{ id = 1353024422, name = "The Whale" },
			{ id = 40742115, name = "Amsterdam park" },
			{ id = 1099952628, name = "Rijksmuseum" },
		},
		["Season 47 - Super Services 2"] = {
			{ id = -2130901093, name = "High Tech Sewage Tower" },
			{ id = -741567455, name = "Biodome Waste Facility" },
			{ id = -320582719, name = "Saltwater Treatment" },
			{ id = 1900838580, name = "Medical Research center" },
			{ id = 1900179467, name = "Geothermal Power Plant" },
			{ id = 1333524968, name = "Police Academy" },
		},
		["Season 48 - Hong Kong"] = {
			{ id = -1344668426, name = "Chin Lin Nunnery" },
			{ id = -1079855971, name = "Blue House Cluster" },
			{ id = -1382928141, name = "The Center" },
			{ id = -1332037813, name = "The Big Buddha" },
			{ id = 1146948722, name = "The Round Tower" },
			{ id = 520534137, name = "Astronomy Museum" },
		},
		["Season 49 - Memory Lane"] = {
			{ id = 620695153, name = "Ponte Vecchio" },
			{ id = -414798630, name = "Washinton Square Park" },
			{ id = -180369097, name = "Corvin Castle" },
			{ id = -1803477641, name = "Acropolis" },
			{ id = -1277330427, name = "Venice Galleria" },
			{ id = 629213863, name = "Alpha Marine Center" },
		},
		["Season 50 - Hawaii"] = {
			{ id = -685787832, name = "Khenhana beach" },
			{ id = 683993281, name = "The Historic House" },
			{ id = 1298106798, name = "Aloha Tower" },
			{ id = -1401203318, name = "Traditional Luau" },
			{ id = -1186052379, name = "Hawaii State Capitol" },
			{ id = 1510126778, name = "Iolani Palace" },
		},
		["Season 51 - Verona"] = {
			{ id = 793178520, name = "Heritage Chapel" },
			{ id = -651427441, name = "Renaissance Garden" },
			{ id = 1556525192, name = "Ponte Llamagero" },
			{ id = -309762273, name = "Verona Defense Fort (locked)" },
			{ id = -785900738, name = "Hilltop Stronghold" },
			{ id = -456252505, name = "Castel Llamagero" },
		},
		["Season 52 - Alpha City 2"] = {
			{ id = -1790106580, name = "Alpha Research Tower" },
			{ id = -236889205, name = "Floating Home" },
			{ id = 484993016, name = "Unfolding House" },
			{ id = -96408078, name = "Parted Towers" },
			{ id = -936762729, name = "Alpha Arts Center" },
			{ id = -875916150, name = "Twirly Tower" },
		},
		["Season 53 - Brutalist Architecture"] = {
			{ id = 2035616490, name = "Brutalist Research Hub" },
			{ id = -1936359749, name = "Twin Pillars" },
			{ id = -1165507424, name = "Brutalist Pavilion" },
			{ id = 625101342, name = "Bolivarian Arts Venue" },
			{ id = -1935541789, name = "Thameside Stage" },
		},
		["Season 54 - Railway Adventures"] = {
			{ id = -2064543673, name = "Railway Water Tower" },
			{ id = 466030933, name = "Old Pedestrian Railway Bridge" },
			{ id = -503453234, name = "Cargo Lift" },
			{ id = -1698050118, name = "Signal Box" },
			{ id = 1906963775, name = "Prague Central" },
		},
		["Season 55 - Mystic Cairo"] = {
			{ id = 305016823, name = "Pyramid Complex" },
			{ id = -1757264638, name = "Coptic Museum" },
			{ id = 1048005211, name = "Cairo Citadel" },
			{ id = -862309625, name = "Portal Ruins" },
			{ id = -236636393, name = "Great Sphinx of Giza" },
		},
		["Season 56 - Vibrant Chicago"] = {
			{ id = 1816026088, name = "Chicago Opera House" },
			{ id = -1411219283, name = "Heritage Museum" },
			{ id = -195252968, name = "The Chicago Tower" },
			{ id = 1608682685, name = "Lakefront Aquarium" },
			{ id = 1987176175, name = "Lakeside Fountain" },
		},
		["Season 57 - Wondrous Kyoto"] = {
			{ id = -100126122, name = "To-Ji Complex" },
			{ id = -1575923728, name = "Kinkaku-Ji Temple" },
			{ id = -1599892208, name = "Clifftop Wonder" },
			{ id = -220214956, name = "Royal Fortress" },
		},
		["Season 58 - Majestic Monaco"] = {
			{ id = 443490608, name = "Monaco Casino (Level 15)" },
			{ id = 1916988685, name = "Port Hercules (Level 10)" },
			{ id = 853495105, name = "Luxurious Resort" },
			{ id = -142637299, name = "Villa La Vigie" },
			{ id = 596591918, name = "Racetrack Casino" },
		},
		["Season 59 - Grand Munich Oktoberfest"] = {
			{ id = -647879449, name = "Ruhmeshalle & Bavariapark" },
			{ id = 504574092, name = "Brezel Bliss" },
			{ id = 998179718, name = "Marienplatz Square" },
			{ id = 1102264025, name = "Neuschwanstein Castle" },
		},
		["Season 60 - Completely Normal Pass"] = {
			{ id = -1516863731, name = "Completely Normal Cave" },
			{ id = -778728861, name = "Completely Normal Library" },
			{ id = -126619542, name = "Completely Normal Lighthouse" },
			{ id = -2079583356, name = "Completely Normal Picnic" },
		},
		["Season 61 - Historical Norway"] = {
			{ id = -1665459077, name = "Viking Longhouse" },
			{ id = 1122918423, name = "Viking Tavern" },
			{ id = 646123099, name = "The King's Fortress" },
			{ id = 310463261, name = "Vargr's Fang" },
		},
		["Season 62 - Cozy Winter"] = {
			{ id = 596946528, name = "Santa's Castle" },
			{ id = -1640460074, name = "Reindeer Stable" },
			{ id = -2038009582, name = "Holiday Ice Park" },
			{ id = -1751147328, name = "Santa Post Office" },
		},
		["Season 63 - Costa Rica"] = {
			{ id = 1841906504, name = "Casa Amarilla" },
			{ id = 1408975735, name = "Castillo Del Moro" },
			{ id = -1917094736, name = "Museum of Fine Arts" },
			{ id = -1914537590, name = "Irazu Volcano" },
			{ id = 1083481252, name = "Castillo Azul" },
		},
		["Season 64 - Cyberpunk"] = {
			{ id = 989916564, name = "NeonCorp Tower" },
			{ id = 1545932128, name = "Billboard Tower" },
			{ id = 1636054385, name = "Cyber Lighthouse" },
			{ id = -1505232642, name = "CyberBowl Arena" },
			{ id = 2053983474, name = "The Night Market" },
		},
		["Season 65 - Super Services 3"] = {
			{ id = 637713520, name = "High Tech Police Department (Level 10)" },
			{ id = 1173563578, name = "High Tech Fire Department (Level 10)" },
			{ id = 1316196483, name = "High Tech Medical Center (Level 10)" },
		},
		["Season 66 - Artemis II Mission"] = {
			{ id = 1900473521, name = "Pegasus Barge" },
			{ id = -676434706, name = "Operations & Checkout Facility" },
			{ id = -1785388164, name = "Mission Control Center" },
			{ id = 283751497, name = "Space Center Visitor Complex" },
			{ id = 184225616, name = "Orion Splashdown Site" },
		},
		["Season 67 - Whiskers and Paws"] = {
			{ id = -208095773, name = "The Grand Cat" },
			{ id = 376088654, name = "Reptile Sanctuary" },
			{ id = -1383749794, name = "Adoption Center" },
			{ id = 2093954214, name = "Puppy Paradise" },
			{ id = 1592379678, name = "Pony Stables" },
		},
	},
	["🏫 Education"] = {
		["Education - Part 1"] = {
			{ id = 153804537, name = "Department of Education" },
			{ id = 1149140292, name = "Nursery School" },
			{ id = -15379413, name = "Grade School" },
			{ id = 1416055094, name = "Public Library" },
			{ id = 234829448, name = "High School" },
			{ id = -98121376, name = "Community College" },
			{ id = 135886467, name = "University" },
			{ id = 610955598, name = "University Athletic Field" },
			{ id = -174697520, name = "University Rowing Center" },
			{ id = 22619681, name = "OMEGA University" },
			{ id = 771263701, name = "University Campus Park" },
		},
		["Education - Part 2"] = {
			{ id = -2089816908, name = "University Library" },
			{ id = 74113015, name = "University Art Gallery" },
			{ id = -2072804076, name = "University Campus Center" },
			{ id = 1354351239, name = "University Aquarium" },
			{ id = -854257755, name = "University Observatory" },
			{ id = 306025075, name = "Contemporary Art Museum (Level 10)" },
			{ id = -1377314693, name = "Martial Arts School (Level 10)" },
			{ id = -61527945, name = "Northern Lights Research Institute (Level 10)" },
			{ id = -71189364, name = "Oceanographic Institute (Level 10)" },
			{ id = 1923087953, name = "Secret Research Lab (Level 10)" },
			{ id = 1068709537, name = "Artist Atelier" },
		},
		["Education - Part 3"] = {
			{ id = -1967647249, name = "University of Ecology" },
			{ id = -1350807063, name = "University Auditorium" },
			{ id = 482469978, name = "The Simli Museum" },
			{ id = 930890005, name = "London Bookshop" },
			{ id = 275335866, name = "PvZ Museum" },
			{ id = 1340343624, name = "Knot College" },
			{ id = -1341405639, name = "Biblioteca Nacional" },
			{ id = 1484303005, name = "Paperbag" },
			{ id = 1144335259, name = "Openbare Bibliotheek Amsterdam" },
			{ id = 1941041141, name = "Hawai State Museum" },
			{ id = 69125020, name = "Alpha Museum" },
		},
		["Education - Part 4"] = {
			{ id = 1522983483, name = "Historic Manuscript Library" },
			{ id = -1834825207, name = "Egyptian Museum" },
			{ id = 1921388748, name = "Children's Playschool" },
			{ id = -1088582301, name = "Bavarian Museum" },
			{ id = -754540411, name = "Linderhof Castle" },
			{ id = 2024958798, name = "Hunters Academy (Level 13)" },
			{ id = 107488769, name = "Paranormal Research Lab" },
			{ id = -515256005, name = "Costa Rica Museum" },
			{ id = -1958338990, name = "Petting Zoo" },
			{ id = -133726632, name = "Space Environments Complex" },
		},
	},
	["🚀 Space"] = {
		["Space - Part 1"] = {
			{ id = -1540556852, name = "Space HQ" },
			{ id = 489221826, name = "Stellar Observatory" },
			{ id = -2086585878, name = "Planetarium" },
			{ id = 601625106, name = "Satellite Communication Center" },
			{ id = -1012702525, name = "Astronaut Training Center" },
			{ id = 1537492520, name = "Space Debris Recycling Centre" },
			{ id = 1660604759, name = "Small Moon Rover Track" },
			{ id = 475491240, name = "Large Moon Rover Track" },
			{ id = -2099437217, name = "Planet X Habitat Simulation" },
			{ id = -1851880457, name = "Sim G Centrifuge" },
			{ id = -1834122803, name = "Rocket Engine Test Stand" },
		},

		["Space - Part 2"] = {
			{ id = 1283687826, name = "Space Research Institute" },
			{ id = -235346, name = "Satellite Manufacturing Plant" },
			{ id = -962892957, name = "Launch Pad" },
			{ id = -711102984, name = "Misson Control Center" },
			{ id = 1666090104, name = "Space Port" },
			{ id = -651881817, name = "Starsphere" },
			{ id = -744052152, name = "Large Binocular scope" },
			{ id = 235085977, name = "Area sim 1" },
			{ id = 1445190666, name = "Cosmic Drome" },
			{ id = -353516371, name = "Ridiculously Large Radio Telescope" },
			{ id = 618404915, name = "Rocket Assembly Facility" },
		},

		["Space - Part 3"] = {
			{ id = 1610412181, name = "Space Flight Center" },
			{ id = -487921576, name = "Space Test Center" },
			{ id = -273451499, name = "Michoud Assembly Facility" },
			{ id = -1523221710, name = "Artemis II Rocket (Level 15)" },
			{ id = -1784786146, name = "Multi-Payload Processing Facility" },
			{ id = -2079933462, name = "Rotation, Processing and Surge Facility" },
		},
	},
	["🎰 Gambling"] = {
		["Gambling - Part 1"] = {
			{ id = -1670955522, name = "Gambling HQ" },
			{ id = -1917164795, name = "Gambling House" },
			{ id = -235971151, name = "Sleek Casino" },
			{ id = -1377292447, name = "Sleek Casino Tower" },
			{ id = 1080258539, name = "Sci-fi Casino" },
			{ id = 206800155, name = "Sci-fi Casino Tower" },
			{ id = -74247875, name = "Luxurious Casino" },
			{ id = 924802029, name = "Luxurious Casino Tower" },
			{ id = 1194588220, name = "OMEGA Casino" },
			{ id = 130975190, name = "House of Spades Casino" },
			{ id = -1167932386, name = "Snake Eyes Casino" },
		},
		["Gambling - Part 2"] = {
			{ id = -1069324852, name = "Lucky Stars Casino" },
			{ id = 1606201192, name = "Sin City Casino" },
			{ id = -1558646031, name = "Four Aces Casino" },
			{ id = -1817972314, name = "Golden Egg Casino" },
			{ id = -747550802, name = "Four Leaf Clover Casino" },
			{ id = 674800975, name = "Wild West Casino" },
			{ id = 1225598517, name = "Mahjong Hall (Level 10)" },
			{ id = -40960756, name = "Oasis Casino (Level 10)" },
			{ id = 1224859774, name = "Ice Casino (Level 10)" },
			{ id = -913268097, name = "Volcano Casino (Level 10)" },
			{ id = 2050118210, name = "Chips and Dice Casino" },
		},
		["Gambling - Part 3"] = {
			{ id = -1332310259, name = "The Harbour Casino" },
			{ id = 290447830, name = "Snowman's Club" },
			{ id = 1224858325, name = "Neon Nightclub" },
			{ id = -10488098, name = "Pooch Palace" },
		},
	},
	["🖼️ Landscape"] = {
		["Landscape - Part 1"] = {
			{ id = -363082332, name = "Pond" },
			{ id = 1092744876, name = "Lake" },
			{ id = 1502294909, name = "Big Lake" },
			{ id = 308442350, name = "Icelandic Hills" },
			{ id = -1216019777, name = "Large Icelandic Hills" },
			{ id = 439180802, name = "Icelandic Volcano" },
			{ id = 767151428, name = "Icelandic Horses" },
			{ id = 31567397, name = "Icelandic Hot Springs" },
			{ id = 199753195, name = "Sand Dunes" },
			{ id = -1703886276, name = "Big Sand Dunes" },
			{ id = -1931689325, name = "African Savannah" },
		},
		["Landscape - Part 2"] = {
			{ id = 497895753, name = "Large African Savannah" },
			{ id = -302791371, name = "Small Animal Pastures" },
			{ id = -298047555, name = "Large Animal Pastures" },
			{ id = 1061538704, name = "Small Flower Fields" },
			{ id = 1066282520, name = "Large Flower Fields" },
			{ id = 745755992, name = "Sunflower Field" },
			{ id = 785538783, name = "Small Vineyards" },
			{ id = 790282599, name = "Large Vineyards" },
			{ id = -1867703810, name = "Apple Tree" },
			{ id = -1862959994, name = "Apple Forest" },
			{ id = -1338562479, name = "Flowery City Name" },
		},
		["Landscape - Part 3"] = {
			{ id = 916458293, name = "Elevated Promenade" },
			{ id = -5887018, name = "Modern Greenway" },
			{ id = 1475606866, name = "Aqueduct" },
			{ id = 1421954182, name = "Food Alleyways" },
			{ id = 446054541, name = "City Wall Section" },
			{ id = 445479806, name = "City Gates" },
			{ id = 1831855182, name = "Round Tower" },
			{ id = -793972515, name = "Grey Wall Section" },
			{ id = -1460120914, name = "Iron Gate" },
			{ id = 626176382, name = "Square Tower" },
			{ id = 596459333, name = "Wall of Shi" },
		},
		["Landscape - Part 4"] = {
			{ id = 595884598, name = "Gate of Shi" },
			{ id = -1794721274, name = "Tower of Shi" },
			{ id = -1958508680, name = "Wall of Alsharq" },
			{ id = -1959083415, name = "Gate of Alsharq" },
			{ id = -209319783, name = "Tower of Alsharq" },
			{ id = -1243599501, name = "(HOPE BRIDGE)RED 1" },
			{ id = 1922820612, name = "(HOPE BRIDGE)RED 2" },
			{ id = 1784423030, name = "(HOPE BRIDGE)RED 3" },
			{ id = -1808975027, name = "Bridge of Love" },
			{ id = 1211627510, name = "Railway Iron Bridge" },
			{ id = 428329242, name = "Plumbob Bridge" },
		},
		["Landscape - Part 5"] = {
			{ id = 1903148850, name = "Suspension Bridge" },
			{ id = 1917814244, name = "Omega Bridge" },
			{ id = -1368726365, name = "Covered Bridge" },
			{ id = 1370992939, name = "Cobblestone Bridge" },
			{ id = 1605630109, name = "University Bridge" },
			{ id = -584187484, name = "University of Arts Bridge" },
			{ id = 967331231, name = "University of Sciences Bridge" },
			{ id = 1922809432, name = "Brass Arch Bridge" },
			{ id = -863859459, name = "Bow Bridge" },
			{ id = 314212659, name = "George Washington Bridge" },
			{ id = -940140603, name = "Brooklyn Bridge" },
		},
		["Landscape - Part 6"] = {
			{ id = -627960397, name = "St. Patrick's Day Parade" },
			{ id = -701156801, name = "Threefold Bridge" },
			{ id = 440871015, name = "Trinity Bridge" },
			{ id = 1625696017, name = "Bridge of da Simci" },
			{ id = -2085888839, name = "Modern Pedestrian Railway Bridge" },
			{ id = 515263002, name = "Chicago River Bridge" },
			{ id = -837296318, name = "Riverboat" },
			{ id = -525828019, name = "Steamboat" },
			{ id = 1808158748, name = "Riverside Restaurant" },
			{ id = 704761493, name = "Big Riverside Restaurant" },
			{ id = -2028665844, name = "Small Acacia Forest" },
		},
		["Landscape - Part 7"] = {
			{ id = -663978220, name = "Acacia Forest" },
			{ id = 772660069, name = "Small Pine Forest" },
			{ id = -2104424531, name = "Pine Forest" },
			{ id = -624314575, name = "Small Aspen Grove" },
			{ id = -2101937543, name = "Aspen Grove" },
			{ id = 537912937, name = "Small Bamboo Forest" },
			{ id = 1236803505, name = "Bamboo Forest" },
			{ id = -1659461646, name = "Small Palm Tree Forest" },
			{ id = -898062726, name = "Palm Tree Forest" },
			{ id = 1801539282, name = "Small Joshua Tree Forest" },
			{ id = 1705094490, name = "Joshua Tree Forest" },
		},
		["Landscape - Part 8"] = {
			{ id = 107556157, name = "Small Spruce Forest" },
			{ id = 1588189061, name = "Spruce Forest" },
			{ id = 974874825, name = "Small Weeping Willow Forest" },
			{ id = 325671441, name = "Weeping Willow Forest" },
			{ id = -1938389312, name = "Small Sakura Forest" },
			{ id = -48122470, name = "Sakura Forest" },
			{ id = -540950008, name = "Dusty Desert" },
			{ id = -1866177619, name = "Prairie Point" },
			{ id = -2107113271, name = "Autumn Oak Tree" },
			{ id = -1541148143, name = "Autumn Oak Forest" },
			{ id = 75604580, name = "Small Japanese Maple Forest" },
		},
		["Landscape - Part 9"] = {
			{ id = 1270299500, name = "Japanese Maple Forest" },
			{ id = 2040462821, name = "Small Weeping Birch Forest" },
			{ id = -1432729043, name = "Weeping Birch Forest" },
			{ id = -372535163, name = "Small Aspen Forest" },
			{ id = 1005937869, name = "Aspen Forest" },
			{ id = -609873923, name = "Birch Tree" },
			{ id = 463710789, name = "Birch Forest" },
			{ id = -1270260082, name = "Silver Fern Tree" },
			{ id = 899129366, name = "Silver Fern Forest" },
			{ id = -1943647209, name = "Pohutukawa Tree" },
			{ id = 160914143, name = "Pohutukawa Forest" },
		},
		["Landscape - Part 10"] = {
			{ id = 688733163, name = "Coconut Tree" },
			{ id = -900990029, name = "Coconut Tree Forest" },
			{ id = -1119845796, name = "Small Cypress Forest" },
			{ id = 413892964, name = "Cypress Forest" },
			{ id = -488419785, name = "Bluebell Grove" },
			{ id = -674937601, name = "Bluebell Woods" },
			{ id = -1611181281, name = "Tumbleweed Station" },
			{ id = 421807020, name = "Covered Wagon Camp Site" },
			{ id = 552611, name = "Rocky Pastures" },
			{ id = -3490912, name = "Western Springs" },
			{ id = -696918464, name = "Small Winter Forest" },
		},
		["Landscape - Part 11"] = {
			{ id = -2104311224, name = "Winter Forest" },
			{ id = 1903483622, name = "Lakeside Sauna" },
			{ id = -1822057967, name = "Old Farm" },
			{ id = 1875680775, name = "Sheep Field" },
			{ id = -321464781, name = "Horse Ranch" },
			{ id = -1587936417, name = "Deer Meadow" },
			{ id = -540810843, name = "Bear Cave" },
			{ id = -573396707, name = "Rabbit Forest" },
			{ id = 1321420829, name = "Old Watermill" },
			{ id = -314508920, name = "Small Campsite" },
			{ id = 1092421520, name = "Campsite" },
		},
		["Landscape - Part 12"] = {
			{ id = -404321844, name = "Hot Spring" },
			{ id = -1652887500, name = "Crop Circle" },
			{ id = 518609087, name = "Stonehenge" },
			{ id = 426132732, name = "Cookout Camping" },
			{ id = -1798383991, name = "Boat Camping" },
			{ id = -911645344, name = "Cabin Camping" },
			{ id = 165761577, name = "Camping on the Lake" },
			{ id = 1299998142, name = "Summer Camp" },
			{ id = 81113470, name = "Tent Camping" },
			{ id = 1419251096, name = "Trailer Camp" },
			{ id = -578544303, name = "Adventure Camping" },
		},
		["Landscape - Part 13"] = {
			{ id = -1924106072, name = "Swan Lake" },
			{ id = -546663096, name = "Greenhouse" },
			{ id = -257591854, name = "Green Pathway" },
			{ id = -1590388727, name = "Relaxing Garden Plaza" },
			{ id = 1534674107, name = "Cattle Drive" },
			{ id = -102734049, name = "Sheep Farm" },
			{ id = -2108507983, name = "Cottage in The Forest" },
			{ id = 707099742, name = "Lake Saimaa" },
			{ id = -909196522, name = "Grand Tuscan Villa" },
			{ id = 614735804, name = "Pride Fountain" },
			{ id = 1043459252, name = "Wetlands Preserve" },
		},
		["Landscape - Part 14"] = {
			{ id = 922789833, name = "Firefly Forest" },
			{ id = -1487561462, name = "Northern Lights Hut" },
			{ id = -132480798, name = "Heart Shaped Maple Trees" },
			{ id = 1665377053, name = "Cannaregio Venice" },
			{ id = 1665377054, name = "San Polo Venice" },
			{ id = -1749904249, name = "Alpha Drone Show" },
			{ id = 1100099735, name = "Floaty Fields" },
			{ id = -1871036240, name = "Railway Market" },
			{ id = -14557179, name = "Abandoned Station" },
			{ id = -592072296, name = "Warewolf Lair" },
		},
		["Landscape - Part 15"] = {
			{ id = 174097928, name = "Viking Gate" },
			{ id = 697106250, name = "Frozen Lake Lighthouse" },
			{ id = 174672663, name = "Viking Wall" },
			{ id = 2524003, name = "Gamle Bybro" },
			{ id = 938195855, name = "Neon Noodle Shop" },
			{ id = 1472889950, name = "Big Llama Pastures" },
			{ id = 1658205288, name = "Llama Pastures" },
			{ id = 214609986, name = "Neon Walkway" },
		},
	},
	["🎡 Entertainment"] = {
		["Entertainment - Part 1"] = {
			{ id = -1460623397, name = "Entertainment HQ" },
			{ id = 261606785, name = "Hotel" },
			{ id = -1791367419, name = "Amphitheater" },
			{ id = 1411074401, name = "Expo Center" },
			{ id = -551239092, name = "Tennis Stadium" },
			{ id = 1254680450, name = "Track and Field Stadium" },
			{ id = -1420940367, name = "Baseball Stadium" },
			{ id = 1349962107, name = "Football Stadium" },
			{ id = 1669555514, name = "Soccer Stadium" },
			{ id = -853219444, name = "Globe Theatre" },
			{ id = 1829835246, name = "Stadium" },
		},
		["Entertainment - Part 2"] = {
			{ id = 891389804, name = "Sydney Opera House" },
			{ id = -2064366556, name = "Ferris Wheel" },
			{ id = 277077801, name = "Sumo Hall" },
			{ id = 1414008796, name = "Oslo Opera House" },
			{ id = 839756894, name = "Ice Hockey Arena" },
			{ id = 831775094, name = "Arctic Hotel" },
			{ id = 690586532, name = "Movie Theater" },
			{ id = -493714925, name = "Drive-In Theater" },
			{ id = 1306928805, name = "Awards Auditorium" },
			{ id = 482467976, name = "Wedding Hall" },
			{ id = -1448678802, name = "Sims' Night Club" },
		},
		["Entertainment - Part 3"] = {
			{ id = 1601947513, name = "Bumper Cars" },
			{ id = -1945040199, name = "Robot Ride" },
			{ id = 1071264761, name = "Drop Tower" },
			{ id = -1522437091, name = "Pendulum Ride" },
			{ id = 365337543, name = "Water Slide" },
			{ id = 1908191700, name = "Big Roller Coaster" },
			{ id = 361777545, name = "Movie Studio Gate" },
			{ id = 1859792493, name = "Romantic Movie Set" },
			{ id = 1688808526, name = "Action Movie Set" },
			{ id = -578242114, name = "Sci-fi Movie Set" },
			{ id = -317083518, name = "Epic Movie Set" },
		},
		["Entertainment - Part 4"] = {
			{ id = -1323273224, name = "Horror Movie Set" },
			{ id = -605237171, name = "Carnival of Venice" },
			{ id = -1547688759, name = "Mardi Gras" },
			{ id = -1372107171, name = "Flower Festival" },
			{ id = -1665863861, name = "Rio Carnival" },
			{ id = -1240308601, name = "Caribbean Carnival" },
			{ id = 1881626558, name = "Dragon Carnival" },
			{ id = -638492261, name = "Wild West Town Hall" },
			{ id = -791443007, name = "Horseshoe Stables" },
			{ id = 1248520028, name = "Little Schoolhouse" },
			{ id = -1977069583, name = "Cowboy Bank" },
		},
		["Entertainment - Part 5"] = {
			{ id = 2137596925, name = "Sheriff's Office" },
			{ id = 47615459, name = "Sarsaparilla Saloon" },
			{ id = -1361544188, name = "Furry Friends Festival" },
			{ id = -1415565022, name = "Dragon Boat Festival" },
			{ id = 1712268802, name = "Summer Matsuri" },
			{ id = -383570677, name = "Sim Music Festival" },
			{ id = -323073335, name = "Art Festival" },
			{ id = -1201523453, name = "Scandinavian Midsummer Festival" },
			{ id = 22727353, name = "Floating Lantern Festival" },
			{ id = -1639489307, name = "Freestyle Park" },
			{ id = -285245984, name = "Pond Hockey" },
		},
		["Entertainment - Part 6"] = {
			{ id = 2030733757, name = "Ice Fishing" },
			{ id = -1925857724, name = "Outdoor Curling" },
			{ id = -1769493524, name = "Snow Mobile Tour" },
			{ id = 1997296934, name = "Speed Skating" },
			{ id = 433742234, name = "Secret Agent Set" },
			{ id = 1685265269, name = "Blooming Love Set" },
			{ id = 347828141, name = "Maxis Man vs. Dr. Vu Set" },
			{ id = 347037782, name = "Castle Haunts Set" },
			{ id = 704258394, name = "Jazz Noir Set" },
			{ id = 1848476010, name = "Science and Smog Set" },
			{ id = -770479640, name = "Awards Ceremony" },
		},
		["Entertainment - Part 7"] = {
			{ id = -1654411707, name = "Mysterious Mummy Set" },
			{ id = 1984604518, name = "Modern Treehouse" },
			{ id = 504238071, name = "Urban Garden" },
			{ id = 1775470285, name = "Treetop Adventure Park" },
			{ id = -1662845995, name = "Modern Spa" },
			{ id = -96044553, name = "Yoga & Meditation Retreat" },
			{ id = -1568907942, name = "Art Hideaway" },
			{ id = 150420231, name = "Pet Park (Level 10)" },
			{ id = -1053961458, name = "Tea House (Level 10)" },
			{ id = -1499583637, name = "UFO Landing Site (Level 10)" },
			{ id = 2111427920, name = "Longship Museum (Level 10)" },
		},
		["Entertainment - Part 8"] = {
			{ id = 731563223, name = "Luau Party (Level 10)" },
			{ id = -1712809431, name = "Grand Souq" },
			{ id = -1035296432, name = "Caravanserai Restaurant" },
			{ id = 2104758484, name = "Baklava Pastry Shop" },
			{ id = -252552977, name = "Golden Goal Stadium (Level 3)" },
			{ id = 910217341, name = "Archery Competition" },
			{ id = 1128525069, name = "Jousting Reenactment" },
			{ id = -1760746598, name = "Countess' Bath House" },
			{ id = 1882292954, name = "New Orleans Mardi Gras" },
			{ id = 1924331360, name = "Fairytale Castle" },
			{ id = 145171385, name = "Alien Movie Set" },
		},
		["Entertainment - Part 9"] = {
			{ id = -222913838, name = "Rooster Carnival" },
			{ id = -1484238889, name = "The Mittens and Merrick Buttes" },
			{ id = 1989632956, name = "Carnival of Eternity" },
			{ id = 625950616, name = "SCBI 7th Anniversary" },
			{ id = 1627623011, name = "The Southern Mansion" },
			{ id = 850558660, name = "London Tea House" },
			{ id = 215546197, name = "English Inn" },
			{ id = -375834911, name = "Royal Albert Hall" },
			{ id = 614170228, name = "Hisao & Hiroko Taki Plaza" },
			{ id = -1267520952, name = "Akihabara Street" },
			{ id = -952555316, name = "Reindeer Sleigh Ride" },
		},
		["Entertainment - Part 10"] = {
			{ id = 466163634, name = "Ice Swimming Sauna" },
			{ id = 1708275201, name = "Castle of Ice" },
			{ id = -1982220874, name = "Mahidol Concert Hall" },
			{ id = 367160678, name = "National Theatre" },
			{ id = 892518849, name = "Žižkov Television Tower" },
			{ id = -1958663965, name = "Shamrock Alley" },
			{ id = -1591012233, name = "La Isla Shopping Village" },
			{ id = -351525335, name = "Mexican Grill House" },
			{ id = -867480776, name = "Pride Café" },
			{ id = 1003670731, name = "Sim Song Contest" },
			{ id = -632375868, name = "Clover's Tall Station" },
		},
		["Entertainment - Part 11"] = {
			{ id = -619996630, name = "TeleSports Arena" },
			{ id = -1779083345, name = "Old Event Hall" },
			{ id = 851946800, name = "Bon Odori" },
			{ id = -1592694037, name = "Poble Espanyol" },
			{ id = -1206243115, name = "Catalan Music Palace" },
			{ id = 252896069, name = "4th July Parade" },
			{ id = -2043774337, name = "Theatro Municipal" },
			{ id = -1089358459, name = "Film Institute" },
			{ id = 789426060, name = "The Concertgebouw" },
			{ id = 1766656099, name = "Black Friday Plaza" },
			{ id = -590989751, name = "New Year Lightshow Tower" },
		},
		["Entertainment - Part 12"] = {
			{ id = 187355302, name = "Open-Air Center" },
			{ id = -1497387043, name = "Sufi Celestial Stage" },
			{ id = -1274599052, name = "Carnival Heritage Hub" },
			{ id = -428080869, name = "St. Patrick's Celebration" },
			{ id = -1271450751, name = "Valentine Plaza" },
			{ id = -810354714, name = "Sky Garden Tower" },
			{ id = -1427731579, name = "Heritage House" },
			{ id = 1425658847, name = "Upside Down House" },
			{ id = 1743863892, name = "Carrot House (Level 6)" },
			{ id = 1447364590, name = "Organic High-Rise (Level 6)" },
			{ id = 1293387173, name = "Riverwalk" },
		},
		["Entertainment - Part 13"] = {
			{ id = 1617510064, name = "Gothic Tower" },
			{ id = 334579237, name = "Chicago Pride House" },
			{ id = 177013036, name = "Mystic Springs" },
			{ id = -1378499416, name = "Stage of Tradition" },
			{ id = 1966539511, name = "Lucky-Cat Teas" },
			{ id = 543287961, name = "Opera de Monte-Carlo" },
			{ id = 973252888, name = "Heritage Clock Tower" },
			{ id = 1319228739, name = "Nymphenburg Palace" },
			{ id = -679157993, name = "Highlight Towers" },
			{ id = -38920812, name = "Oktoberfest Funfair (Level 15)" },
			{ id = -1201967217, name = "Ghost Help Center" },
		},
		["Entertainment - Part 14"] = {
			{ id = -1845673808, name = "Hunter's Quarters" },
			{ id = -1650930023, name = "Black Friday Square" },
			{ id = -602613545, name = "Cozy Inn" },
			{ id = -1483365311, name = "Bauble Restaurant" },
			{ id = 1214290160, name = "Costa Rica Theater" },
			{ id = -1773435338, name = "Neon Diner" },
			{ id = 1543449766, name = "Neon Arcade (Level 15)" },

			{ id = -874124019, name = "Pets Amusement Park (Level 15)" },
			{ id = -2009450018, name = "Ramadan Palace" },
			{ id = -532409638, name = "Bunny Café" },
			{ id = -1650032148, name = "Bubbly Bunny Spa" },
		},
	},
	["🚙 Transportation"] = {
		["Transportation - Part 1"] = {
			{ id = -1558709851, name = "Departament of Transportation " },
			{ id = -1982142573, name = "(BUS TERMINAL) RED" },
			{ id = -1452684878, name = "(AIRSHIP HANGAR)RED" },
			{ id = 259065734, name = "(BALLOON PARK)RED" },
			{ id = 71121177, name = "(HELIPORT)RED" },
			{ id = 1057886574, name = "Bus Terminal" },
			{ id = -1043014605, name = "London Bus Terminal" },
			{ id = 359437193, name = "Airship Hangar" },
			{ id = 1333485593, name = "Balloon Park" },
			{ id = -658227156, name = "Heliport" },
			{ id = -485403679, name = "OMEGA Tube Terminal" },
		},
		["Transportation - Part 2"] = {
			{ id = -295191895, name = "Alpha Taxi Station" },
			{ id = -593594007, name = "Hot Air Balloons" },
			{ id = 1035128858, name = "Bicycle Track" },
			{ id = -467653071, name = "Bus Terminal (Special)" },
			{ id = -16069529, name = "Countryside station" },
			{ id = 43624901, name = "Helipad" },
			{ id = 1341745005, name = "Modern Railway Station" },
			{ id = 637054753, name = "Locomotive Museum" },
			{ id = 1591801772, name = "Central Train Station" },
			{ id = -390144207, name = "Bicycle Rental (Level 10)" },
			{ id = -1674278686, name = "Hoverboard Terminal (Level 10)" },
		},
		["Transportation - Part 3"] = {
			{ id = 52917017, name = "Tuk Tuk Station (Level 10)" },
			{ id = -1469085798, name = "Big Rig Route (Level 10)" },
			{ id = -1716889800, name = "Quad Bike Station (Level 10)" },
			{ id = 776814664, name = "Taxi Stop (Level 10)" },
			{ id = 526900553, name = "Monorail Station" },
			{ id = -1523086447, name = "Space Launch Center" },
			{ id = -2099673310, name = "London Taxi Stand" },
			{ id = 391362933, name = "Pumpkin Balloon" },
			{ id = -216863966, name = "Kielce Bus Station" },
			{ id = 757805349, name = "Welbeck Street Car Park" },
			{ id = -1156436419, name = "The Great Loop" },
		},
		["Transportation - Part 4"] = {
			{ id = -88841617, name = "Ghost Portal (Level 26)" },
			{ id = -1705554627, name = "Santa's Airport (Level 12)" },
		},
	},
	["⛲ Parks"] = {
		["Parks - Part 1"] = {
			{ id = -1672104106, name = "Small Fountain Park" },
			{ id = 712780976, name = "Modern Art Park" },
			{ id = 1248926735, name = "Outdoor Cinema Park" },
			{ id = -1690458379, name = "Walk of Plumbob" },
			{ id = -1674021276, name = "Movie Studio Statue" },
			{ id = 706946425, name = "(STAR PARK)RED" },
			{ id = -1634099085, name = "(HEART PARK)RED" },
			{ id = 149204635, name = "(PLUMBOB PARK)RED" },
			{ id = -1669869661, name = "(CITY NAME PARK)RED" },
			{ id = 894179683, name = "Plumbob Park" },
			{ id = 81901075, name = "Crescent Tent" },
		},
		["Parks - Part 2"] = {
			{ id = 1019069964, name = "Crescent Garden" },
			{ id = 1605023329, name = "Deluxe Plumbob Park" },
			{ id = 1329015326, name = "Day of the Dead Park" },
			{ id = -2121152741, name = "Spooky Park" },
			{ id = -2121152740, name = "Monster Tree" },
			{ id = -647669663, name = "Scary Carousel" },
			{ id = -1421810928, name = "Mansion of Horrors" },
			{ id = 2063143272, name = "Graveyard" },
			{ id = -2121152739, name = "Pumpkin Man Statue" },
			{ id = 1560466612, name = "Ruined Bell Tower" },
			{ id = -571332033, name = "Jack-o'-lantern" },
		},
		["Parks - Part 3"] = {
			{ id = -557690303, name = "Haunted Mansion" },
			{ id = -2005871118, name = "The Cursed Swamp" },
			{ id = -523194184, name = "Feathery Mansion" },
			{ id = -1665578542, name = "Goth Mansion" },
			{ id = -226444335, name = "Haunted Sanitarium" },
			{ id = 16392513, name = "Deserted Farm" },
			{ id = 808131927, name = "Zombie Mall" },
			{ id = 2030224591, name = "Zombie of Horrors" },
			{ id = 462058679, name = "Streets of Diwali" },
			{ id = -343974711, name = "Ice Sculpture Park" },
			{ id = 815408777, name = "Holiday Park" },
		},
		["Parks - Part 4"] = {
			{ id = -118922403, name = "Sledding Park" },
			{ id = -1820721636, name = "Happy New Year Park" },
			{ id = 592621734, name = "Happy New Year Monument" },
			{ id = -1743195664, name = "Holiday Gift Market" },
			{ id = -1743195663, name = "Delicacy Market" },
			{ id = -1085931401, name = "Ice Skating Rink" },
			{ id = 1359603596, name = "Holiday Tree" },
			{ id = 874082466, name = "New Years Tower" },
			{ id = 428504772, name = "Holiday Fountain Park" },
			{ id = 1767203460, name = "Holiday Market" },
			{ id = -1226103885, name = "Holiday Train Ride Park" },
		},
		["Parks - Part 5"] = {
			{ id = -2062857743, name = "Festive Holiday Tree" },
			{ id = -482543179, name = "Holiday Village" },
			{ id = -1573520756, name = "Big Ice Skating Rink" },
			{ id = 1649981261, name = "Happy New Year 2018" },
			{ id = -1842272595, name = "Extreme Skating Park" },
			{ id = -1106159173, name = "Dumpling Alley" },
			{ id = -1106159174, name = "Snack Market" },
			{ id = -917097812, name = "Welcoming Gate" },
			{ id = -1887788971, name = "Red Lantern Walkway" },
			{ id = -135854200, name = "Giant Lantern" },
			{ id = -1516159089, name = "Monkey Statue" },
		},
		["Parks - Part 6"] = {
			{ id = 1381773871, name = "Dragon Park" },
			{ id = -539955733, name = "Carnival Parade" },
			{ id = 259481855, name = "Carnival Gate" },
			{ id = 452355042, name = "Carnival Stage" },
			{ id = 1244737708, name = "Parrot Statue" },
			{ id = 1255375549, name = "Carnival Party" },
			{ id = 883179021, name = "Romantic Park" },
			{ id = -1534700746, name = "Little Teddy Park" },
			{ id = -45505667, name = "Teddy Park" },
			{ id = -514396417, name = "Cupid Angel Park" },
			{ id = 326365644, name = "Cupid Heart Park" },
		},
		["Parks - Part 7"] = {
			{ id = -289583874, name = "Heart Balloon Park" },
			{ id = -1014462499, name = "Lake of Love" },
			{ id = -1217014048, name = "Split Heart Left Side" },
			{ id = -1499497837, name = "Split Heart Right Side" },
			{ id = 660817399, name = "Romeo and Juliet Balcony" },
			{ id = 545400034, name = "Swan Boat Park" },
			{ id = -956359243, name = "Basket Bunny" },
			{ id = 890019926, name = "Spring Chick Statue" },
			{ id = -170854219, name = "Chicken Park" },
			{ id = -863061950, name = "Egg Park" },
			{ id = -1267834549, name = "Egg Slide Park" },
		},
		["Parks - Part 8"] = {
			{ id = 1011327376, name = "Spiral Slide Park" },
			{ id = 176580726, name = "Bunny-Go-Round" },
			{ id = 1858018973, name = "Egg Twirl" },
			{ id = 805796492, name = "Hoppin' Waterslide" },
			{ id = -1740117831, name = "Blooming Hill" },
			{ id = -1245468537, name = "Fast Track to Spring" },
			{ id = 1412631060, name = "Over-Easy Rider" },
			{ id = 1769335305, name = "Cottontail Slide" },
			{ id = -101109207, name = "Hare-raising Coaster" },
			{ id = -53247827, name = "World Tree" },
			{ id = 1363276551, name = "Old-Growth Forest" },
		},
		["Parks - Part 9"] = {
			{ id = 1521635621, name = "Forest Lake" },
			{ id = 58778652, name = "University Park Cafeteria" },
			{ id = -301302384, name = "University Park Quad" },
			{ id = -365239469, name = "Lay's Go-Kart Park" },
			{ id = -1351110122, name = "Lay's Mountain Park" },
			{ id = 1030140447, name = "Lay's Bowl Park" },
			{ id = 1904524427, name = "Lay's Park" },
			{ id = -936132783, name = "Ruffles Go-Kart Park" },
			{ id = -283671148, name = "Ruffles Mountain Park" },
			{ id = -421759331, name = "Ruffles Bowl Park" },
			{ id = -847252983, name = "Ruffles Park" },
		},
		["Parks - Part 10"] = {
			{ id = -1250093364, name = "Reflecting Pool Park" },
			{ id = -1914603231, name = "Llarry the Llama" },
			{ id = -958560911, name = "Peaceful Park" },
			{ id = -958560910, name = "Urban Plaza" },
			{ id = 492706918, name = "World's Largest Ball of Twine" },
			{ id = 619296955, name = "Sculpture Garden" },
			{ id = 619296956, name = "Row of Trees" },
			{ id = 410248493, name = "Anchor Park" },
			{ id = -777336438, name = "Casino City Sign" },
			{ id = -383906791, name = "Casino City Park" },
			{ id = -1900447707, name = "Soccer Field" },
		},
		["Parks - Part 11"] = {
			{ id = 578424766, name = "Baseball Park" },
			{ id = -1267678106, name = "Swimming Pool" },
			{ id = 1414044701, name = "Golf Course - Front 9" },
			{ id = 1414044702, name = "Golf Course - Back 9" },
			{ id = -958560909, name = "Jogging Path" },
			{ id = 619296954, name = "Water Park Playground" },
			{ id = -1921690608, name = "Giant Garden Gnome" },
			{ id = -1791367421, name = "Basketball Court" },
			{ id = -813560860, name = "Dolly the Dinosaur" },
			{ id = 2039678676, name = "Tokyo Town Gate" },
			{ id = -1685111278, name = "Fish Market" },
		},
		["Parks - Part 12"] = {
			{ id = -788805066, name = "Old Palace Park" },
			{ id = -1791367420, name = "Skate Park" },
			{ id = 673250798, name = "Sakura Park" },
			{ id = -1170594527, name = "Geometric Sculptures" },
			{ id = -2069325028, name = "Dutch Windmill" },
			{ id = 945525020, name = "Royal Garden" },
			{ id = -475654483, name = "Omega Park" },
			{ id = 2040088750, name = "Ultimate Mayor Statue" },
			{ id = 587994243, name = "Topiary Turtle" },
			{ id = -1933624278, name = "Topiary Llama" },
			{ id = 1395124309, name = "Topiary Cheetah" },
		},
		["Parks - Part 13"] = {
			{ id = -404556, name = "Topiary Plumbob" },
			{ id = -1344538987, name = "Umaid Bhawan Garden" },
			{ id = -1379414401, name = "Parliament Park" },
			{ id = 1457786383, name = "Nagoya Castle Garden" },
			{ id = -1713758072, name = "St. James's Park" },
			{ id = -1051718906, name = "Himalayan Garden" },
			{ id = -154536615, name = "Pena Garden" },
			{ id = 1253523744, name = "Windsor Home Park" },
			{ id = 1500089335, name = "Schonbrunn Palace Park" },
			{ id = 334535581, name = "Food Trucks" },
			{ id = 668029703, name = "Sports Field" },
		},
		["Parks - Part 14"] = {
			{ id = 1761412862, name = "Victory Trophy" },
			{ id = 2005587850, name = "SimCity Cup Stadium" },
			{ id = 1136823044, name = "Sports Fan Parade" },
			{ id = -1935167258, name = "Sports Merchandise" },
			{ id = 1312201562, name = "Outdoor Sports Theater" },
			{ id = 2057715442, name = "Sports Star Statue" },
			{ id = 579388837, name = "Pride Parade" },
			{ id = 1014461305, name = "Merry-Go-Round" },
			{ id = 1168312438, name = "Holiday Shopping Center" },
			{ id = -587405082, name = "Santa's Greetings" },
			{ id = 194738006, name = "Holiday Hotel" },
		},
		["Parks - Part 15"] = {
			{ id = 819620077, name = "Festive Boulevard" },
			{ id = -1461779797, name = "New Year's Walk" },
			{ id = -1357616746, name = "New Year's Rooftop Bash" },
			{ id = -1067122351, name = "Dog Sledding Tour" },
			{ id = 417646355, name = "Hot Springs Resort" },
			{ id = -343859364, name = "Ice Sculpture Show" },
			{ id = 1299459679, name = "Lapland Resort" },
			{ id = 125479983, name = "Pinewood Farm" },
			{ id = -1425146120, name = "Reindeer Farm" },
			{ id = 1032094812, name = "Yeti Sighting" },
			{ id = 815397525, name = "Year of the Pig Parade" },
		},
		["Parks - Part 16"] = {
			{ id = -1442673990, name = "Dragon Dance" },
			{ id = 2011874625, name = "Fireworks Show" },
			{ id = 528807486, name = "Dumpling Market" },
			{ id = -951464114, name = "Plum Blossom Park" },
			{ id = 438407953, name = "Lion Dance" },
			{ id = 1855633078, name = "Lantern Festival" },
			{ id = -1876880368, name = "Chinese Theater Show" },
			{ id = -451932982, name = "The Nutcracker Ballet Hall" },
			{ id = 836909204, name = "Giant Snow Globe" },
			{ id = 304782918, name = "Romantic Carriage Ride" },
			{ id = 1266250176, name = "Straw Goat" },
		},
		["Parks - Part 17"] = {
			{ id = -962449382, name = "Giant Snowman" },
			{ id = 1116447266, name = "Winter Bonfire" },
			{ id = 273998439, name = "2020 Ferris Wheel" },
			{ id = -1418657144, name = "2020 Commemorative Statue" },
			{ id = -1477898388, name = "Year of the Rat Sculpture" },
			{ id = 1079087194, name = "Plaza of Lights" },
			{ id = 19974509, name = "Romantic Hot Springs" },
			{ id = -77155734, name = "The Lovers' Pathway" },
			{ id = 1899649143, name = "Egg Painting Contest" },
			{ id = -455642506, name = "Pride Festival" },
			{ id = 1936731727, name = "Medieval Market" },
		},
		["Parks - Part 18"] = {
			{ id = -619959780, name = "Festival of Light" },
			{ id = 1408096025, name = "Posada" },
			{ id = -1445063167, name = "De Luxe Department Store" },
			{ id = 1867708456, name = "Little Candles Plaza" },
			{ id = -2081050059, name = "Romantic Holiday Plaza" },
			{ id = 1475708020, name = "Karavaki" },
			{ id = 1545376789, name = "Poinsettia Greenhouse" },
			{ id = -916915172, name = "Pohutukawa Tree Field" },
			{ id = 446572583, name = "Giant Lantern Festival" },
			{ id = 2003618685, name = "Romantic Floral Arches" },
			{ id = 1970418852, name = "Year of the Ox" },
		},
		["Parks - Part 19"] = {
			{ id = -701221117, name = "2021 Celebration Tower" },
			{ id = 101515232, name = "Hanami" },
			{ id = 313160761, name = "May Day Picnic" },
			{ id = -1366931139, name = "Chocolate Fountain" },
			{ id = 861156116, name = "Festival of Colors" },
			{ id = 850460885, name = "Lantern Shop" },
			{ id = -1950029431, name = "Festival of Breaking the Fast" },
			{ id = 1087687941, name = "Ganesha Temple" },
			{ id = -715918088, name = "Day of the Dead Graveyard" },
			{ id = 434915616, name = "The Completely Normal House" },
			{ id = -1724734908, name = "Mansion of Recently Deceased" },
		},
		["Parks - Part 20"] = {
			{ id = -519173045, name = "Little Plant of Horrors" },
			{ id = 460314762, name = "Year of the Tiger" },
			{ id = -79331805, name = "Heartwarming Ice Rink" },
			{ id = 1506675425, name = "Whatville" },
			{ id = -1770699378, name = "Wisteria Park" },
			{ id = 1727940088, name = "Geylang Ramadan Bazaar" },
			{ id = 1734153025, name = "Iftar Tent" },
			{ id = -563490253, name = "Ecological Community" },
			{ id = -772442768, name = "Rainbow Wedding" },
			{ id = -706548546, name = "Farm Mansion" },
			{ id = 1175560122, name = "Farm Garden" },
		},
		["Parks - Part 21"] = {
			{ id = 1051839001, name = "Juice Farm" },
			{ id = 2064840565, name = "Flower Garden Gazebo" },
			{ id = -2138253851, name = "Floating Pod" },
			{ id = -213332959, name = "Winter Holiday Street" },
			{ id = -1682346626, name = "Winter Holiday Square" },
			{ id = 1454171534, name = "Winter Holiday Skating Pond" },
			{ id = -1053360456, name = "Winter Holiday Park" },
			{ id = 2108045910, name = "Winter Wonder Vuppelin" },
			{ id = -153173616, name = "Atelier Du Chocolate" },
			{ id = -1607734367, name = "New Year's Palace" },
			{ id = -1110755257, name = "Year of the Rabbit" },
		},
		["Parks - Part 22"] = {
			{ id = -1856814337, name = "Samba Parade" },
			{ id = 1111477547, name = "Spring Holiday Fountain" },
			{ id = 166295189, name = "Egg-o-Capsule" },
			{ id = 799630444, name = "Iftar Market Square" },
			{ id = 996317369, name = "Majestic Umbrella Hall" },
			{ id = -348181317, name = "Round Castle" },
			{ id = 1931893562, name = "Dream Castle" },
			{ id = 495800600, name = "Ghostly Castle" },
			{ id = -1522363622, name = "Loggia del Llamalino" },
			{ id = -161273939, name = "4th of July Picnic" },
			{ id = -1914983311, name = "London Kew Gardens" },
		},
		["Parks - Part 23"] = {
			{ id = 243322819, name = "Coffin House" },
			{ id = 367631164, name = "Witch Tree House" },
			{ id = 1420845900, name = "Chomper Backyard" },
			{ id = 404044642, name = "Thanksgiving Fields" },
			{ id = 449920618, name = "Year of the Dragon Fountain" },
			{ id = -227072900, name = "Year of the Dragon Statue" },
			{ id = 2044117905, name = "Heart Shaped Park" },
			{ id = -1310436183, name = "English Easter Garden" },
			{ id = 1338836999, name = "Ramadan Resort" },
			{ id = -1740767685, name = "Palapas Park" },
			{ id = 1457386162, name = "Cape Town Garden" },
		},
		["Parks - Part 24"] = {
			{ id = 211291018, name = "Victorian Pride Centre" },
			{ id = -1645866108, name = "Pink Hippo Park" },
			{ id = 634705318, name = "May Queen Parade" },
			{ id = -1180395309, name = "Montjuic Magic Fountain" },
			{ id = -173188499, name = "Artist's Park" },
			{ id = 1013665086, name = "Ganesh Pandal" },
			{ id = 1936110901, name = "Constructor's Playground" },
			{ id = 841862582, name = "Sydney Zoo" },
			{ id = -1689674194, name = "Oude Kerk" },
			{ id = 2108628511, name = "Haunted Crypt" },
			{ id = -346803870, name = "Nan Lian Garden" },
		},
		["Parks - Part 25"] = {
			{ id = 409967627, name = "Autumn Heights" },
			{ id = 205563584, name = "Green Grove Center" },
			{ id = 2144017770, name = "Year of the Snake Celebration" },
			{ id = 1589159150, name = "Tiny Lake Railway" },
			{ id = -228456819, name = "Whispering Woods" },
			{ id = 527731446, name = "Royal Blimp" },
			{ id = -1176884113, name = "Munich Beverage Garden" },
			{ id = -294203145, name = "Vampire Cemetery" },
			{ id = 1298001, name = "Thanksgiving House " },
			{ id = 353417886, name = "Gamlehaugen" },
			{ id = 1472071215, name = "Viking Watchtower" },
		},
		["Parks - Part 26"] = {
			{ id = 906860659, name = "Rider's Croft" },
			{ id = 1449579514, name = "The Blacksmith's Forge" },
			{ id = -798223803, name = "Frozen Fountain" },
			{ id = 1273366, name = "New Year Clock Tower (locked)" },
			{ id = 1429965560, name = "Cahuita Slot Center" },
			{ id = -1764441207, name = "Coffee Farm (Level 12)" },
			{ id = -1192642314, name = "The Diquis Spheres" },
			{ id = -1860597777, name = "La Casona" },
			{ id = 438386730, name = "Future Hi-Rise" },
			{ id = -98026244, name = "Worker's Apartment" },
			{ id = 489126139, name = "Neon Heart's Fountain" },
		},
		["Parks - Part 27"] = {
			{ id = 487568484, name = "St. Patrick's Fountain" },
			{ id = -53034311, name = "Pet Supply Store" },
		},
	},
	["🗼 Landmarks"] = {
		["Landmarks - Part 1"] = {
			{ id = -1459586527, name = "Department of Culture" },
			{ id = 53972136, name = "Tower of Pisa" },
			{ id = -1825458979, name = "Big Ben" },
			{ id = 21495196, name = "Arc de Triomphe" },
			{ id = -665683039, name = "Brandenburg Gate" },
			{ id = 1163495494, name = "Empire State Building" },
			{ id = 69272571, name = "Statue of Liberty" },
			{ id = -131513365, name = "Washington Monument" },
			{ id = -1348379480, name = "Himeji Castle" },
			{ id = -1590776910, name = "Eiffel Tower" },
			{ id = 363479116, name = "Cinquantenaire Arch" },
		},
		["Landmarks - Part 2"] = {
			{ id = 350041419, name = "Giralda" },
			{ id = -1707224834, name = "Tokyo Tower" },
			{ id = -1868767674, name = "Kölner Dom" },
			{ id = -15263492, name = "Willis Tower" },
			{ id = -2089966647, name = "MaxisMan Statue" },
			{ id = 761715179, name = "OMEGA Tower" },
			{ id = 2008139918, name = "Old Town Stronghold" },
			{ id = -1732753151, name = "City Fortress" },
			{ id = 1855159866, name = "Countess' Citadel" },
			{ id = -1987429224, name = "Princess' Tower" },
			{ id = 656868003, name = "Royal Castle" },
		},
		["Landmarks - Part 3"] = {
			{ id = 1678435087, name = "Imperial Palace" },
			{ id = 2007992298, name = "Stone Fort" },
			{ id = 1220305687, name = "Duke's Castle" },
			{ id = -1862408168, name = "Gothic Castle" },
			{ id = -564909075, name = "Temple of Artemis" },
			{ id = 847736623, name = "Hanging Gardens of Babylon" },
			{ id = -1196208235, name = "Angkor Wat" },
			{ id = -1171137074, name = "Luxor" },
			{ id = -1205286250, name = "Taj Mahal" },
			{ id = -2125393850, name = "Umaid Bhawan Palace" },
			{ id = -1455092954, name = "Budapest Parliament" },
		},
		["Landmarks - Part 4"] = {
			{ id = -714173635, name = "Nagoya Castle" },
			{ id = 8465538, name = "Buckingham Palace" },
			{ id = -2108020290, name = "Himalayan Palace" },
			{ id = 752048879, name = "Pena Palace" },
			{ id = 489029428, name = "Sim Island Statue" },
			{ id = -1552131900, name = "Nazca Lines" },
			{ id = -155446785, name = "Inca Temple" },
			{ id = -1181444434, name = "Sphinx of SimCity" },
			{ id = 376074091, name = "Pyramid of SimCity" },
			{ id = 1792601194, name = "Machu Picchu" },
			{ id = 1290873382, name = "Windsor Castle" },
		},
		["Landmarks - Part 5"] = {
			{ id = 1889305514, name = "Schönbrunn Palace" },
			{ id = 1521944178, name = "Nazca Bird" },
			{ id = -1303500776, name = "Nazca Llama" },
			{ id = 227653008, name = "Fortune Shrine" },
			{ id = -844999557, name = "The Tundra" },
			{ id = -432641378, name = "Savannah" },
			{ id = 1343674377, name = "The Arctic" },
			{ id = -1761216148, name = "Rain Forest" },
			{ id = 1913998027, name = "Red Lagoon" },
			{ id = 1266494209, name = "Geyser" },
			{ id = -33249811, name = "Church" },
		},
		["Landmarks - Part 6"] = {
			{ id = 366333194, name = "Mosque" },
			{ id = 628204727, name = "Temple" },
			{ id = 393735239, name = "Modern Temple" },
			{ id = 1562079541, name = "Stonewall Inn" },
			{ id = 460000029, name = "Castle on a Cake" },
			{ id = -373259240, name = "Joya no Kane" },
			{ id = -1243632684, name = "Temple of Kukulcan" },
			{ id = 58219099, name = "Supernatural Hunters" },
			{ id = -327918657, name = "Alhambra" },
			{ id = -1741650982, name = "Colossus of Rhodes" },
			{ id = -297334398, name = "Pont Alexandre III" },
		},
		["Landmarks - Part 7"] = {
			{ id = 1319627434, name = "Pont Neuf" },
			{ id = 1350198096, name = "Place de la Bastille" },
			{ id = 1943054268, name = "Musée du SimCity" },
			{ id = 147228852, name = "Rustic Castle" },
			{ id = 1422786598, name = "Museum of Natural History" },
			{ id = -2114742261, name = "Campus Library" },
			{ id = 559571178, name = "Saint Basilica" },
			{ id = 1175620110, name = "Statue of Daniel" },
			{ id = -949187712, name = "Castillo de Las Llamas" },
			{ id = 64967597, name = "Piccadilly Circus" },
			{ id = 1065081671, name = "Eltham Palace" },
		},
		["Landmarks - Part 8"] = {
			{ id = -1854842861, name = "Reiyūkai Shakaden" },
			{ id = 2080167789, name = "Gardencourt Estate" },
			{ id = -887832712, name = "Smith Sisters Store" },
			{ id = -410571163, name = "Daimonji Yaki" },
			{ id = 762126226, name = "Two-Cranes Tower" },
			{ id = -1532317272, name = "St. Peter's Basilica" },
			{ id = -1580035610, name = "10th Anniversary Hologram Statue" },
			{ id = -1290779205, name = "Legendary Emerald Skyscraper" },
			{ id = -1802872902, name = "Legendary Golden Skyscraper" },
			{ id = -363029219, name = "Legendary Abandoned Skyscraper" },
			{ id = 1736540863, name = "Legendary Golden Key Skyscraper" },
		},
		["Landmarks - Part 9"] = {
			{ id = 1100779520, name = "Legendary Platinum Key Skyscraper" },
			{ id = -489269854, name = "Legendary Holiday Tree" },
			{ id = 774201245, name = "Gothic Balisica" },
			{ id = -167244696, name = "Boston City Hall" },
			{ id = -120122398, name = "Abraxas Urban Ensemble" },
			{ id = 1342567062, name = "Cairo Tower" },
			{ id = 157195590, name = "Babylon Fortress" },
			{ id = 1366391935, name = "Great Pyramid of Giza" },
			{ id = -1416711138, name = "Chicago Skyline" },
			{ id = 179449652, name = "Torii Trails Shrine" },
			{ id = -1508803973, name = "Royal Oasis" },
		},
		["Landmarks - Part 10"] = {
			{ id = -1044241208, name = "Prince's Palace of Monaco" },
			{ id = -315083456, name = "Monaco St. Charles Church" },
			{ id = 887213816, name = "Old Town Hall Munich" },
			{ id = 1027459450, name = "Munich Town Hall" },
			{ id = 1122908991, name = "Ghost Mansion" },
			{ id = -100751298, name = "Heddal Stave Church" },
			{ id = 1244998746, name = "Giant Santa" },
			{ id = 157593763, name = "Vardohus Fortress" },
			{ id = -2089765092, name = "Gingerbread Mansion" },
			{ id = -288345590, name = "Akershus Fortress" },
			{ id = -517883782, name = "Fort Heredia" },
		},
		["Landmarks - Part 11"] = {
			{ id = -1495640388, name = "Edifício Metálico" },
			{ id = 198536949, name = "The Lair Tower" },
			{ id = 1948622172, name = "FireHorse Sculpture" },
			{ id = 367596984, name = "The Loyal Friend" },
		},
	},
	["⛱️ Beach"] = {
		["Beach - Part 1"] = {
			{ id = -1683144483, name = "Surfer Beach" },
			{ id = -415542704, name = "Dolphin Watching Boat" },
			{ id = -905879128, name = "Coral Reef" },
			{ id = -1177473833, name = "Whale Watching Tower" },
			{ id = 764118735, name = "Volleyball Court" },
			{ id = -1388487448, name = "Rowing Center" },
			{ id = -1524261240, name = "Beach Volleyball Center" },
			{ id = -1187429907, name = "Bicycle Motocross Center" },
			{ id = 291034576, name = "Lifegaurd Tower" },
			{ id = 1106695477, name = "Beachfront Shopping Mall" },
			{ id = 1573651112, name = "Crescent Shopping Mall" },
		},
		["Beach - Part 2"] = {
			{ id = 2013586058, name = "Beach Wedding" },
			{ id = 1334269703, name = "Relaxing Beach" },
			{ id = 813308529, name = "Merman Statue" },
			{ id = -295480250, name = "Carousel" },
			{ id = 1799705683, name = "Bluebeard's Pirate Ship" },
			{ id = 19878764, name = "Water Park" },
			{ id = -517430528, name = "Aquarium" },
			{ id = 2026792156, name = "Astro-Twirl Rocket Ride" },
			{ id = -1975436265, name = "Lighthouse" },
			{ id = -843379253, name = "Sailorman's Pier" },
			{ id = 1962202416, name = "Luxury Boat Marina" },
		},
		["Beach - Part 3"] = {
			{ id = 1010574017, name = "Beach Delta" },
			{ id = -1869089609, name = "Waterfront Wharf" },
			{ id = -1417405073, name = "Yatch Club" },
			{ id = 464006328, name = "Boat House" },
			{ id = -2038081014, name = "Luxury Beach House" },
			{ id = 1685276410, name = "Ocean Villa" },
			{ id = 203311611, name = "Sailing Club" },
			{ id = 1893805226, name = "Guardian of Sailors" },
			{ id = 1047022577, name = "Paradise Island" },
			{ id = -246355115, name = "Luxury Beach Hotel" },
			{ id = 295398699, name = "Sailing Boat Pier" },
		},
		["Beach - Part 4"] = {
			{ id = 1696366774, name = "Royal Resort" },
			{ id = -1504571536, name = "Luxury Mall" },
			{ id = 1730432937, name = "Luxury Cruise Ship" },
			{ id = -1891082744, name = "Lighthouse of SimCity" },
			{ id = 300574244, name = "Beach Theatre" },
			{ id = 1364033785, name = "Colossal Sandcastle" },
			{ id = 1349768007, name = "Isle of Wight, the Needles" },
			{ id = 1373299444, name = "Pier Shopping Area" },
			{ id = -137548074, name = "Sea Fireflies" },
			{ id = -1941621566, name = "Sea Lions Center" },
			{ id = 1167198283, name = "Harbor Marketplace" },
			{ id = 1029914302, name = "Beach Torii" },
			{ id = -1022328473, name = "Beach Sports Rental" },
		},
		["Beach - Part 5"] = {
			{ id = 1532060468, name = "Seashore Sauna Resort" },
			{ id = -1449629287, name = "Beach Waterfall" },
			{ id = -365044955, name = "Pebble Cliffs" },
			{ id = 1502934459, name = "Lagoon Retreat" },
			{ id = 1941374121, name = "Seaside Soiree" },
			{ id = -1468355025, name = "Island Party" },
			{ id = 2030134544, name = "Hidden Lagoon" },
			{ id = -238866695, name = "Entertainment Boardwalk" },
			{ id = 1762731124, name = "Siren's Call" },
			{ id = -2127049860, name = "Sunken Village" },
			{ id = -492173631, name = "The Flying Dutchman" },
		},
		["Beach - Part 6"] = {
			{ id = 632880417, name = "The Kraken" },
			{ id = -401195743, name = "Ghost Fortress" },
			{ id = -1120214884, name = "Eastegg Island" },
			{ id = 1612699704, name = "Blue Ocean Stadium (Level 3)" },
			{ id = 994100769, name = "Santa Beach Party" },
			{ id = 394421861, name = "Dolphin Island" },
			{ id = -1582890451, name = "Nordic Fishing Dock" },
			{ id = -121780645, name = "Beach Sauna Bar" },
			{ id = 319698076, name = "2022 Party Island" },
			{ id = -1578309862, name = "Okinawa Beach" },
			{ id = 409967627, name = "Palace Pier" },
		},
		["Beach - Part 7"] = {
			{ id = 40742115, name = "Oceanic Garden" },
			{ id = 759087700, name = "Baga Beach" },
			{ id = 570728233, name = "Black Sand Beach" },
			{ id = -1128317133, name = "Patong Beach" },
			{ id = -526752407, name = "Phra Nang Cave Beach" },
			{ id = -1866149561, name = "Hook Lighthouse" },
			{ id = 1547529770, name = "Shark Tours" },
			{ id = 1169487741, name = "Sim Sports Aquatic Arena" },
			{ id = -1184600102, name = "Avenue of Stars" },
			{ id = -1166536161, name = "Waimea Beach" },
			{ id = 1566999293, name = "Eco Aquaculture (Level 6)" },
		},
		["Beach - Part 8"] = {
			{ id = 2115973200, name = "Oceanographic Museum" },
			{ id = 479429225, name = "Monaco Heliport" },
			{ id = -1107119793, name = "Larvotto Beach" },
			{ id = -180639739, name = "The Fjord-Serpent (Level 15)" },
			{ id = 2010575615, name = "Cahuita Beach" },
		},
	},
	["🗻 Mountain"] = {
		["Mountain - Part 1"] = {
			{ id = 157827808, name = "City Name Sign" },
			{ id = -2025654154, name = "Cozy Cottages" },
			{ id = -1738477098, name = "Panda Habitat" },
			{ id = 1950092739, name = "Snow Leopard Habitat" },
			{ id = -1924457380, name = "Gorilla Habitat" },
			{ id = -2025654153, name = "Mountainside Cottages" },
			{ id = -2025654152, name = "Hiker's Cottages" },
			{ id = 157244062, name = "Alpine Cafe" },
			{ id = -1734299794, name = "Mountainside Train Station" },
			{ id = 1876019625, name = "Whitewater Park" },
			{ id = 1467693470, name = "Paragliding Center" },
		},
		["Mountain - Part 2"] = {
			{ id = 607141114, name = "Mountain Bike Park" },
			{ id = 206141169, name = "Alpine Vineyard" },
			{ id = 157576222, name = "Mountain Lift" },
			{ id = -1270815176, name = "Halfpipe" },
			{ id = -1720727207, name = "Ski Jumping Hill" },
			{ id = -2139578863, name = "Ski Hotel" },
			{ id = -2094361322, name = "Ski Resort" },
			{ id = 914769152, name = "Communication Tower" },
			{ id = 1853415023, name = "Observatory" },
			{ id = 47626276, name = "Mount SimCity" },
			{ id = -50933579, name = "Mountain Palace" },
		},
		["Mountain - Part 3"] = {
			{ id = -559421141, name = "Castle" },
			{ id = -1674266991, name = "Snow Castle" },
			{ id = -1912214732, name = "Mountain Climbing Camp" },
			{ id = 1845899276, name = "Waterfall Castle" },
			{ id = 824472135, name = "Stoneface Waterfall" },
			{ id = 381249066, name = "Gritty Gold Mine" },
			{ id = 582544155, name = "Petra Ruins" },
			{ id = 220272830, name = "Bobsled Track" },
			{ id = 982418464, name = "Glacier Climbing" },
			{ id = -2104088772, name = "Hilltop Hotel" },
			{ id = -1693811819, name = "Mountain Skywalk" },
		},
		["Mountain - Part 4"] = {
			{ id = -1337103427, name = "Snowboard Cross" },
			{ id = -1401192830, name = "Family Sled Track" },
			{ id = -1929681207, name = "Count's Castle" },
			{ id = 483145387, name = "Mountain Railway" },
			{ id = -966691068, name = "Northern Lights Cabin" },
			{ id = 2128064116, name = "Hot-Air Balloon Festival" },
			{ id = 769983670, name = "Furusato no Oshogatsu" },
			{ id = 1999774098, name = "Mountain Hotel" },
			{ id = 2095360422, name = "Hillside Fort" },
			{ id = -1320764511, name = "Hillside Castle" },
			{ id = 404602461, name = "Petrin Cathedral" },
		},
		["Mountain - Part 5"] = {
			{ id = 440188653, name = "Mountain Gardens" },
			{ id = -1695738094, name = "Peers Cave" },
			{ id = 1784267536, name = "Alpha Mountain Retreat" },
		},
	},
	["🚄 Railway Stations"] = {
		["Train Station Collection (Small Railway not Included)"] = {
			{ id = -1237103305, name = "Medium Railway Station" },
			{ id = -1128001023, name = "Large Railway Station" },
			{ id = 1903354601, name = "Metropolitan Railway Station" },
			{ id = -857522815, name = "Parkside Station" },
			{ id = -282846133, name = "Central Station" },
			{ id = -142685661, name = "Golden Marsh Station" },
			{ id = 622835743, name = "Union Station" },
			{ id = -884003462, name = "Royal X Station" },
			{ id = 75958285, name = "Lion's Station" },
			{ id = 1591925015, name = "Arley Halt" },
			{ id = 1906963775, name = "Prague Central" },
		},
		["Part 2"] = {
			{ id = -577081237, name = "Victoria Terminal" },
			{ id = 1703812238, name = "Santa's Express" },
		},
	},
	["🌃 Building Effects"] = {
		[" 🌆 Night Effects"] = {
			["Night Effects - Part 1"] = {
				{ id = -1516863731, name = "Completely Normal Cave" },
				{ id = -126619542, name = "Completely Normal Lighthouse" },
				{ id = -778728861, name = "Completely Normal Library" },
				{ id = -2079583356, name = "Completely Normal Picnic" },
				{ id = -42524362, name = "Volcano Roller Coaster" },
				{ id = 1122908991, name = "Ghost Mansion" },
				{ id = -1929681207, name = "Count's Castle" },
				{ id = -1712809431, name = "Grand Souq" },
				{ id = -1035296432, name = "Caravanserai Restaurant" },
				{ id = 2104758484, name = "Baklava Pastry Shop" },
				{ id = -1760746598, name = "Countess' Bath House" },
			},
			["Night Effects - Part 2"] = {
				{ id = -2127049860, name = "Sunken Village" },
				{ id = -492173631, name = "The Flying Dutchman" },
				{ id = -401195743, name = "Ghost Fortress" },
				{ id = -1749904249, name = "Alpha Drone Show" },
				{ id = 799630444, name = "Iftar Market Square" },
				{ id = -1607734367, name = "New Year's Palace (2023)" },
				{ id = 2108045910, name = "Winter Wonder Vuppelin" },
				{ id = -1053360456, name = "Winter Holiday Park" },
				{ id = -213332959, name = "Winter Holiday Street" },
				{ id = 1734153025, name = "Iftar Tent" },
				{ id = 1727940088, name = "Geylang Ramadan Bazaar" },
			},
			["Night Effects - Part 3"] = {
				{ id = -1950029431, name = "Festival of Breaking the Fast" },
				{ id = 462058679, name = "Streets Of Diwali" },
				{ id = 16392513, name = "Deserted Farm" },
				{ id = -226444335, name = "Haunted Sanitarium" },
			},
		},
		["🌁 City Effects"] = {
			["City Effects - Part 1"] = {
				{ id = -363029219, name = "Legendary Abandoned Skyscraper" },
				{ id = -489269854, name = "Legendary Holiday Tree" },
				{ id = 1617510064, name = "Gothic Tower" },
				{ id = -88841617, name = "Ghost Portal (Level 26)" },
			},
		},
	},
	["🔨 Services"] = {
		["⚡ Power"] = {
			{ id = 43959873, name = "Deluxe Wind Power Plant (Level 5)" },
			{ id = -1297331476, name = "Coal Power Plant (Level 3)" },
			{ id = -1548024560, name = "Solar Power Plant (Level 5)" },
			{ id = 270223155, name = "Oil Power Plant (Level 5)" },
			{ id = 1180238012, name = "Nuclear Power Plant (Level 8)" },
			{ id = 894204175, name = "Fusion Power Plant (Level 10)" },
			{ id = 1773814921, name = "Omega Power Plant (Level 10)" },
			{ id = -955289326, name = "Eco Power Plant (Level 10)" },
			{ id = 923712972, name = "Earth Day Solar Power Plant (Level 10)" },
			{ id = -747375459, name = "Concentrated Solar Power Plant (Level 10)" },
			{ id = 1900179467, name = "Geothermal Power Plant (Level 10)" },
		},
		["✨ Omega Services"] = {
			{ id = 1773814921, name = "Omega Power Plant (Level 10)" },
			{ id = 1454604382, name = "Omega Water Tower (Level 10)" },
			{ id = -489028751, name = "Omega Recycling Center (Level 10)" },
			{ id = 1592483960, name = "Omega Sewage Treatment Plant (Level 10)" },
			{ id = 925375395, name = "Maxis Manor" },
			{ id = 1579400415, name = "Maxis Hq" },
		},
		["💧 Water"] = {
			{ id = 139346166, name = "Basic Water Tower (Level 3)" },
			{ id = 1575951752, name = "Water Pumping Station (Level 5)" },
			{ id = 1454604382, name = "Omega Water Tower (Level 10)" },
			{ id = 1575952079, name = "Fresh Water Pumping Station (Level 10)" },
			{ id = -320582719, name = "Saltwater Treatment (Level 8)" },
		},
		["🚽 Sewage"] = {
			{ id = 182280407, name = "Small Sewage Outflow Pipe (Level 5)" },
			{ id = -12118430, name = "Basic Sewage Outflow Pipe (Level 8)" },
			{ id = 1508927486, name = "Deluxe Sewage Treatment Plant (Level 10)" },
			{ id = 1592483960, name = "Omega Sewage Treatment Plant (Level 10)" },
			{ id = -2130901093, name = "High Tech Sewage Tower (Level 10)" },
		},
		["♻️ Waste Management"] = {
			{ id = -741284485, name = "Small Garbage Dump (Level 5)" },
			{ id = -935683325, name = "Garbage Dump (Level 5)" },
			{ id = -1415031890, name = "Garbage Incinerator (Level 8)" },
			{ id = 1272720856, name = "Recycling Center (Level 10)" },
			{ id = -489028751, name = "Omega Recycling Center (Level 10)" },
			{ id = -741567455, name = "Biodome Waste Facility (Level 10)" },
			{ id = -1415031566, name = "Waste To Energy Plant (Level 10)" },
		},
		["🔥 Fire"] = {
			{ id = 925375395, name = "Maxis Manor" },
			{ id = 1579400415, name = "Maxis HQ" },
			{ id = -1566555016, name = "Chicago Firehouse (Level 10)" },
			{ id = -357520281, name = "Fire Service Headquarters (Level 10)" },
			{ id = 1840116317, name = "Grand Fire Station (Level 10)" },
			{ id = 1840115993, name = "Deluxe Fire Station (Level 8)" },
			{ id = 388741900, name = "Basic Fire Station (Level 5)" },
			{ id = 583140740, name = "Small Fire Station (Level 5)" },
			{ id = 1173563578, name = "High Tech Fire Department (Level 10)" },
		},
		["🚓 Police"] = {
			{ id = -150076998, name = "Small Police Station (Level 5)" },
			{ id = -1397016254, name = "Basic Police Station (Level 5)" },
			{ id = -898048424, name = "Police Precint (Level 5)" },
			{ id = -898048097, name = "Police Headquarters (Level 10)" },
			{ id = 1333524968, name = "Police Academy (Level 10)" },
			{ id = -1361673718, name = "Evidence Lab (Level 10)" },
			{ id = 925375395, name = "Maxis Manor" },
			{ id = 1579400415, name = "Maxis HQ" },
			{ id = 637713520, name = "High Tech Police Department (Level 10)" },
		},
		["🏥 Health"] = {
			{ id = -66177425, name = "Small Health Clinic (Level 5)" },
			{ id = 1155556855, name = "Health Clinic (Level 5)" },
			{ id = 850245036, name = "Hospital (Level 8)" },
			{ id = 850245360, name = "Medical Center (Level 10)" },
			{ id = 925375395, name = "Maxis Manor" },
			{ id = 1579400415, name = "Maxis HQ" },
			{ id = 1900838580, name = "Medical Research Center (Level 10)" },
			{ id = 1947666751, name = "Egyptian Hospital (Level 10)" },
			{ id = 13139718, name = "Caring Hearts Clinic (Level 10)" },
			{ id = 1316196483, name = "High Tech Medical Center (Level 10)" },
		},
		["🛰️ Omega Control and Drones"] = {
			{ id = -184573343, name = "Small Controlnet Tower (Level 9)" },
			{ id = 1796938609, name = "Basic Controlnet Tower (Level 10)" },
			{ id = 1659661883, name = "Deluxe Controlnet Tower (Level 10)" },
			{ id = 277401625, name = "Controlnet HQ (Level 10)" },
			{ id = 927036052, name = "Small Drone Base (Level 10)" },
			{ id = 1461271996, name = "Basic Drone Base (Level 10)" },
			{ id = 87683878, name = "Deluxe Drone Base (Level 10)" },
		},
	},
	["🌉 Bridges & Waterways"] = {
		["Classic & Stone Bridges"] = {
			{ id = 620695153, name = "Ponte Vecchio" },
			{ id = -573061988, name = "Ponte Milvio" },
			{ id = -971391086, name = "Charles Bridge" },
			{ id = 1370992939, name = "Cobblestone Bridge" },
			{ id = 1922809432, name = "Brass Arch Bridge" },
			{ id = -1368726365, name = "Covered Bridge" },
			{ id = -1808975027, name = "Bridge Of Love" },
			{ id = -297334398, name = "Pont Alexandre Iii" },
			{ id = 1319627434, name = "Pont Neuf" },
			{ id = 1475606866, name = "Aqueduct" },
			{ id = 1625696017, name = "Bridge Of Da Simci" },
		},
		["Modern & Suspension Bridges"] = {
			{ id = -940140603, name = "Brooklyn Bridge" },
			{ id = 314212659, name = "George Washington Bridge" },
			{ id = 1526054020, name = "Tower Bridge" },
			{ id = 1903148850, name = "Suspension Bridge" },
			{ id = 1917814244, name = "Omega Bridge" },
			{ id = 112132293, name = "Sunscape Bridge" },
			{ id = 1605630109, name = "University Bridge" },
			{ id = -584187484, name = "University Of Arts Bridge" },
			{ id = 967331231, name = "University Of Sciences Bridge" },
			{ id = -1243599501, name = "(HOPE BRIDGE)RED 1" },
		},
		["Railway Crossings"] = {
			{ id = 1211627510, name = "Railway Iron Bridge" },
			{ id = 466030933, name = "Old Pedestrian Railway Bridge" },
			{ id = -2085888839, name = "Modern Pedestrian Railway Bridge" },
			{ id = 1311318422, name = "Railway Arch Bridge" },
			{ id = -438139921, name = "Railway Cable Bridge" },
		},
		["Venetian Canals"] = {
			{ id = -1941533902, name = "Bridge Classico" },
			{ id = -1630168928, name = "Bridge Of Bellezza" },
			{ id = -26743007, name = "Bridge Le Case" },
			{ id = 1556525192, name = "Ponte Llamagero" },
			{ id = 1783384776, name = "Gondola Station" },
			{ id = 1665377053, name = "Cannaregio Venice" },
			{ id = 1665377054, name = "San Polo Venice" },
			{ id = -1079660811, name = "Amsterdam Canal North" },
			{ id = -1079660810, name = "Amsterdam Canal South" },
		},
		["Waterfront & Piers"] = {
			{ id = 1293387173, name = "Riverwalk" },
			{ id = -1869089609, name = "Waterfront Wharf" },
			{ id = -843379253, name = "Sailorman's Pier" },
			{ id = 1373299444, name = "Pier Shopping Area" },
			{ id = 1350015626, name = "Seaplane Dock" },
			{ id = 1808158748, name = "Riverside Restaurant" },
			{ id = 704761493, name = "Big Riverside Restaurant" },
			{ id = -837296318, name = "Riverboat" },
			{ id = -525828019, name = "Steamboat" },
		},
	},
	["🍂 Seasonal Events"] = {
		["🎃 Halloween"] = {
			["Halloween - Part 1"] = {
				{ id = -2005871118, name = "The Cursed Swamp" },
				{ id = -492173631, name = "The Flying Dutchman" },
				{ id = -401195743, name = "Ghost Fortress" },
				{ id = 632880417, name = "The Kraken" },
				{ id = 1762731124, name = "Siren's Call" },
				{ id = -2127049860, name = "Sunken Village" },
				{ id = -1929681207, name = "Count's Castle" },
				{ id = 495800600, name = "Ghostly Castle" },
				{ id = -2121152741, name = "Spooky Park" },
				{ id = -2121152740, name = "Monster Tree" },
				{ id = -2121152739, name = "Pumpkin Man Statue" },
			},
			["Halloween - Part 2"] = {
				{ id = -557690303, name = "Haunted Mansion" },
				{ id = 2063143272, name = "Graveyard" },
				{ id = -647669663, name = "Scary Carousel" },
				{ id = -1421810928, name = "Mansion Of Horrors" },
				{ id = -571332033, name = "Jack-o'-lantern" },
				{ id = 1560466612, name = "Ruined Bell Tower" },
				{ id = 434915616, name = "The Completely Normal House" },
				{ id = -1724734908, name = "Mansion Of Recently Deceased" },
				{ id = 58219099, name = "Supernatural Hunters" },
				{ id = -519173045, name = "Little Plant Of Horrors" },
				{ id = 1989632956, name = "Carnival Of Eternity" },
			},
			["Halloween - Part 3"] = {
				{ id = 808131927, name = "Zombie Mall" },
				{ id = -1665578542, name = "Goth Mansion" },
				{ id = 16392513, name = "Deserted Farm" },
				{ id = -226444335, name = "Haunted Sanitarium" },
				{ id = 2030224591, name = "Zombie Of Horrors" },
				{ id = 243322819, name = "Coffin House" },
				{ id = 367631164, name = "Witch Tree House" },
				{ id = 391362933, name = "Pumpkin Balloon" },
				{ id = 1420845900, name = "Chomper Backyard" },
				{ id = 275335866, name = "Pvz Museum" },
				{ id = 2108628511, name = "Haunted Crypt" },
			},
			["Halloween - Part 4"] = {
				{ id = 107488769, name = "Paranormal Research Lab" },
				{ id = 1122908991, name = "Ghost Mansion" },
				{ id = -1201967217, name = "Ghost Help Center" },
				{ id = -1516863731, name = "Completely Normal Cave" },
				{ id = -14557179, name = "Abandoned Station" },
				{ id = -294203145, name = "Vampire Cemetery" },
				{ id = -1845673808, name = "Hunter's Quarters" },
				{ id = -592072296, name = "Warewolf Lair" },
				{ id = -778728861, name = "Completely Normal Library" },
				{ id = -126619542, name = "Completely Normal Lighthouse" },
				{ id = -2079583356, name = "Completely Normal Picnic" },
			},
			["Halloween - Part 5"] = {
				{ id = 842265531, name = "Hunters Academy (Level 1)" },
				{ id = 908361496, name = "Ghost Portal (Level 1)" },
			},
		},
		["🎄 Christmas/New Year"] = {
			["Christmas - Part 1"] = {
				{ id = 1168312438, name = "Holiday Shopping Center" },
				{ id = -587405082, name = "Santa's Greetings" },
				{ id = 194738006, name = "Holiday Hotel" },
				{ id = 819620077, name = "Festive Boulevard" },
				{ id = -1461779797, name = "New Year's Walk" },
				{ id = -1357616746, name = "New Year's Rooftop Bash" },
				{ id = -1067122351, name = "Dog Sledding Tour" },
				{ id = 417646355, name = "Hot Springs Resort" },
				{ id = -343859364, name = "Ice Sculpture Show" },
				{ id = 1299459679, name = "Lapland Resort" },
				{ id = -1425146120, name = "Reindeer Farm" },
			},
			["Christmas - Part 2"] = {
				{ id = -451932982, name = "The Nutcracker Ballet Hall" },
				{ id = 836909204, name = "Giant Snow Globe" },
				{ id = 1266250176, name = "Straw Goat" },
				{ id = -962449382, name = "Giant Snowman" },
				{ id = 1116447266, name = "Winter Bonfire" },
				{ id = 273998439, name = "2020 Ferris Wheel" },
				{ id = -1418657144, name = "2020 Commemorative Statue" },
				{ id = -701221117, name = "2021 Celebration Tower" },
				{ id = -79331805, name = "Heartwarming Ice Rink" },
				{ id = 1997477714, name = "Santa's Workshop" },
				{ id = -1743195664, name = "Holiday Gift Market" },
			},
			["Christmas - Part 3"] = {
				{ id = -1743195663, name = "Delicacy Market" },
				{ id = 1359603596, name = "Holiday Tree" },
				{ id = -118922403, name = "Sledding Park" },
				{ id = 815408777, name = "Holiday Park" },
				{ id = -1820721636, name = "Happy New Year Park" },
				{ id = 592621734, name = "Happy New Year Monument" },
				{ id = 1767203460, name = "Holiday Market" },
				{ id = -1226103885, name = "Holiday Train Ride Park" },
				{ id = -2062857743, name = "Festive Holiday Tree" },
				{ id = -482543179, name = "Holiday Village" },
				{ id = -1573520756, name = "Big Ice Skating Rink" },
			},
			["Christmas - Part 4"] = {
				{ id = 1649981261, name = "Happy New Year 2018" },
				{ id = -1842272595, name = "Extreme Skating Park" },
				{ id = 1903483622, name = "Lakeside Sauna" },
				{ id = 428504772, name = "Holiday Fountain Park" },
				{ id = -1085931401, name = "Ice Skating Rink" },
				{ id = 874082466, name = "New Years Tower" },
				{ id = 994100769, name = "Santa Beach Party" },
				{ id = -1445063167, name = "De Luxe Department Store" },
				{ id = 1867708456, name = "Little Candles Plaza" },
				{ id = -2081050059, name = "Romantic Holiday Plaza" },
				{ id = 1475708020, name = "Karavaki" },
			},
			["Christmas - Part 5"] = {
				{ id = 1545376789, name = "Poinsettia Greenhouse" },
				{ id = -1009705288, name = "Holiday Concert Hall" },
				{ id = -1859541172, name = "Winter Garden" },
				{ id = -1236049903, name = "Winter Brasserie" },
				{ id = 2108045910, name = "Winter Wonder Vuppelin" },
				{ id = -213332959, name = "Winter Holiday Street" },
				{ id = -1682346626, name = "Winter Holiday Square" },
				{ id = 1454171534, name = "Winter Holiday Skating Pond" },
				{ id = -1053360456, name = "Winter Holiday Park" },
				{ id = -1607734367, name = "New Year's Palace (2023)" },
				{ id = -489269854, name = "Legendary Holiday Tree" },
			},
			["Christmas - Part 6"] = {
				{ id = -590989751, name = "New Year Lightshow Tower" },
				{ id = 1244998746, name = "Giant Santa" },
				{ id = -602613545, name = "Cozy Inn" },
				{ id = 290447830, name = "Snowman's Club" },
				{ id = -2089765092, name = "Gingerbread Mansion" },
				{ id = 596946528, name = "Santa's Castle" },
				{ id = -1640460074, name = "Reindeer Stable" },
				{ id = -2038009582, name = "Holiday Ice Park" },
				{ id = -1751147328, name = "Santa Post Office" },
				{ id = -1705554627, name = "Santa's Airport (Level 12)" },
				{ id = 1703812238, name = "Santa's Express" },
			},
			["Christmas - Part 7"] = {
				{ id = 1273366, name = "New Year Clock Tower" },
			},
		},
		["🐰 Easter / Spring"] = {
			["Easter - Part 1"] = {
				{ id = 1899649143, name = "Egg Painting Contest" },
				{ id = -1120214884, name = "Eastegg Island" },
				{ id = -1310436183, name = "English Easter Garden" },
				{ id = -956359243, name = "Basket Bunny" },
				{ id = 890019926, name = "Spring Chick Statue" },
				{ id = -170854219, name = "Chicken Park" },
				{ id = -863061950, name = "Egg Park" },
				{ id = -1267834549, name = "Egg Slide Park" },
				{ id = 176580726, name = "Bunny-Go-Round" },
				{ id = 1858018973, name = "Egg Twirl" },
				{ id = 1959039626, name = "Glass Egg Hall" },
			},
			["Easter - Part 2"] = {
				{ id = -1110755257, name = "Year Of The Rabbit" },
				{ id = 1111477547, name = "Spring Holiday Fountain" },
				{ id = 166295189, name = "Egg-o-Capsule" },
				{ id = -1740117831, name = "Blooming Hill" },
				{ id = -1245468537, name = "Fast Track To Spring" },
				{ id = 805796492, name = "Hoppin' Waterslide" },
				{ id = 1769335305, name = "Cottontail Slide" },
				{ id = -101109207, name = "Hare-raising Coaster" },
				{ id = -573396707, name = "Rabbit Forest" },
				{ id = 1412631060, name = "Over-Easy Rider" },
				{ id = 1743863892, name = "Carrot House (Level 6)" },
			},
		},
		["🏮 Lunar New Year"] = {
			["Lunar New Year - Part 1 (Celebrations)"] = {
				{ id = -1442673990, name = "Dragon Dance" },
				{ id = 2011874625, name = "Fireworks Show" },
				{ id = 528807486, name = "Dumpling Market" },
				{ id = -951464114, name = "Plum Blossom Park" },
				{ id = 438407953, name = "Lion Dance" },
				{ id = 1855633078, name = "Lantern Festival" },
				{ id = -1876880368, name = "Chinese Theatre Show" },
				{ id = 1381773871, name = "Dragon Park" },
				{ id = -135854200, name = "Giant Lantern" },
				{ id = 446572583, name = "Giant Lantern Festival" },
				{ id = 850460885, name = "Lantern Shop" },
			},
			["Lunar New Year - Part 2 (Zodiacs)"] = {
				{ id = -1516159089, name = "Monkey Statue" },
				{ id = -222913838, name = "Rooster Carnival" },
				{ id = 815397525, name = "Year Of The Pig Parade" },
				{ id = -1477898388, name = "Year Of The Rat Sculpture" },
				{ id = 1970418852, name = "Year Of The Ox" },
				{ id = 460314762, name = "Year Of The Tiger" },
				{ id = -1110755257, name = "Year Of The Rabbit" },
				{ id = 449920618, name = "Year Of The Dragon Fountain" },
				{ id = -227072900, name = "Year Of The Dragon Statue" },
				{ id = 2144017770, name = "Year Of The Snake Celebration" },
			},
		},
		["❤️ Valentine's Day"] = {
			["Valentine's - Part 1"] = {
				{ id = 304782918, name = "Romantic Carriage Ride" },
				{ id = 19974509, name = "Romantic Hot Springs" },
				{ id = -77155734, name = "The Lovers' Pathway" },
				{ id = 2003618685, name = "Romantic Floral Arches" },
				{ id = 482467976, name = "Wedding Hall" },
				{ id = -2081050059, name = "Romantic Holiday Plaza" },
				{ id = 883179021, name = "Romantic Park" },
				{ id = -1808975027, name = "Bridge Of Love" },
				{ id = 2013586058, name = "Beach Wedding" },
				{ id = 660817399, name = "Romeo And Juliet Balcone" },
				{ id = 545400034, name = "Swan Boat Park" },
			},
			["Valentine's - Part 2 (Hearts & Cupid)"] = {
				{ id = -514396417, name = "Cupid Angel Park" },
				{ id = 326365644, name = "Cupid Heart Park" },
				{ id = -289583874, name = "Heart Balloon Park" },
				{ id = -1014462499, name = "Lake Of Love" },
				{ id = -1217014048, name = "Split Heart Left Side" },
				{ id = -1499497837, name = "Split Heart Right Side" },
				{ id = -1271450751, name = "Valentine's Plaza" },
				{ id = 2044117905, name = "Heart Shaped Park" },
				{ id = -132480798, name = "Heart Shaped Maple Trees" },
				{ id = -79331805, name = "Heartwarming Ice Rink" },
			},
		},
		["🎭 Carnival & Mardi Gras"] = {
			["Carnival - Part 1"] = {
				{ id = -605237171, name = "Carnival Of Venice" },
				{ id = -1547688759, name = "Mardi Gras" },
				{ id = -1665863861, name = "Rio Carnival" },
				{ id = -1240308601, name = "Caribbean Carnival" },
				{ id = 1881626558, name = "Dragon Carnival" },
				{ id = 259481855, name = "Carnival Gate" },
				{ id = 452355042, name = "Carnival Stage" },
				{ id = -539955733, name = "Carnival Parade" },
				{ id = 1255375549, name = "Carnival Party" },
				{ id = 1882292954, name = "New Orleans Mardi Gras" },
				{ id = -1274599052, name = "Carnival Heritage Club" },
			},
		},
		["🏳️‍🌈 Pride"] = {
			["Pride"] = {
				{ id = 579388837, name = "Pride Parade" },
				{ id = -455642506, name = "Pride Festival" },
				{ id = -772442768, name = "Rainbow Wedding" },
				{ id = 211291018, name = "Victorian Pride Centre" },
				{ id = -867480776, name = "Pride Cafe" },
				{ id = 614735804, name = "Pride Fountain" },
				{ id = 334579237, name = "Chicago Pride House" },
				{ id = 1562079541, name = "Stonewall Inn" },
			},
		},
	},
}

local factoryItemsMenuDefault = {
	[1] = "🔩 Metal",
	[2] = "🪵 Wood",
	[3] = "💳 Plastic",
	[4] = "🌱 Seeds",
	[5] = "💎 Minerals",
	[6] = "🧪 Chemicals",
	[7] = "🧶 Textiles",
	[8] = "🍬 Sugar and Spices",
	[9] = "🔎 Glass",
	[10] = "🥫 Animal Feed",
	[11] = "🔌 Electrical Components",
}

local factoryConstants = {
	[1] = "-1501685376",
	[2] = "-1477359097",
	[3] = "-389414878",
	[4] = "-331876130",
	[5] = "-777869928",
	[6] = "809598022",
	[7] = "-545412710",
	[8] = "-2052593169",
	[9] = "-254286722",
	[10] = "-610175295",
	[11] = "-585905379",
}

function discoverBuildingPointers()
	local function saveData(correctListStart)
		local toget_pointers = {}
		for i = 1, 5000 do
			toget_pointers[i] = { address = correctListStart.address + (i - 1) * 8, flags = gg.TYPE_QWORD }
		end
		local pointerResults = gg.getValues(toget_pointers)
		local aRDC = {}
		for _, r in ipairs(pointerResults) do
			if r.value and r.value ~= 0 then
				table.insert(aRDC, { address = r.value + 0x50, flags = gg.TYPE_DWORD, op = r.value })
			else
				break
			end
		end
		if #aRDC == 0 then
			return false
		end
		local cR = gg.getValues(aRDC)
		local foundCount = 0
		buildingDatabase = {}
		for i, r in ipairs(cR) do
			local constID = r.value
			if constID and constID ~= 0 then
				buildingDatabase[constID] = { pointer = aRDC[i].op }
				foundCount = foundCount + 1
			end
		end
		local namedCount = 0
		for id, data in pairs(buildingDatabase) do
			if buildingNameById[id] then
				data.name = buildingNameById[id]
				namedCount = namedCount + 1
			end
		end
		gg.setVisible(true)
		if foundCount > 0 then
			gg.clearList()
			gg.addListItems({
				{ address = correctListStart.address, flags = gg.TYPE_QWORD, description = "Building List Start" },
			})
			gg.toast(string.format("✅ %d total buildings cached (%d with known names).", foundCount, namedCount))
			return true
		else
			gg.alert("❌ No building pointers could be discovered from the found list.")
			return false
		end
	end
	gg.setVisible(false)
	gg.setRanges(gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS | gg.REGION_OTHER)
	gg.clearResults()
	gg.searchNumber("448264947", gg.TYPE_DWORD)
	local initialResults = gg.getResults(gg.getResultsCount())
	if #initialResults == 0 then
		gg.alert("Initial value 448264947 not found.")
		gg.setVisible(true)
		return false
	end

	local addressesToReadPtr1 = {}
	for _, result in ipairs(initialResults) do
		table.insert(addressesToReadPtr1, { address = result.address - 0x8, flags = gg.TYPE_QWORD })
	end
	local firstPointers = gg.getValues(addressesToReadPtr1)

	local addressesToReadPtr2 = {}
	for _, ptr1 in ipairs(firstPointers) do
		if ptr1.value and ptr1.value ~= 0 then
			table.insert(addressesToReadPtr2, { address = ptr1.value + 0x4, flags = gg.TYPE_QWORD })
		end
	end
	if #addressesToReadPtr2 == 0 then
		gg.alert("No results passed the first validation step.")
		gg.setVisible(true)
		return false
	end

	local secondPointers = gg.getValues(addressesToReadPtr2)
	local validSources = {}
	for i, ptr2 in ipairs(secondPointers) do
		if ptr2.value and ptr2.value == 7235441155891999603 then
			table.insert(validSources, initialResults[i].address - 0x50)
		end
	end

	if #validSources == 0 then
		gg.alert("No results passed the second validation step.")
		gg.setVisible(true)
		return false
	end

	local possibleLists = {}
	for i, sourceAddr in ipairs(validSources) do
		gg.clearResults()
		gg.searchNumber(string.format("%Xh", sourceAddr), gg.TYPE_QWORD)
		local pointerSearchResults = gg.getResults(gg.getResultsCount())
		for _, pResult in ipairs(pointerSearchResults) do
			table.insert(possibleLists, pResult)
		end
	end
	if #possibleLists == 0 then
		gg.alert("❌ No building list was found after pointer search.")
		gg.setVisible(true)
		return false
	end

	local totalKnownIds = 0
	for _ in pairs(buildingNameById) do
		totalKnownIds = totalKnownIds + 1
	end

	for i, listStart in ipairs(possibleLists) do
		local pointersToCheck = {}
		for j = 0, 5000 do
			table.insert(pointersToCheck, { address = listStart.address + (j * 8), flags = gg.TYPE_QWORD })
		end
		local buildingPointers = gg.getValues(pointersToCheck)

		local idsToRead = {}
		for _, ptr in ipairs(buildingPointers) do
			if ptr.value and ptr.value ~= 0 then
				table.insert(idsToRead, { address = ptr.value + 0x50, flags = gg.TYPE_DWORD })
			else
				break
			end
		end

		if #idsToRead >= 2500 then
			local buildingIds = gg.getValues(idsToRead)
			local foundInThisList = {}
			local foundCount = 0
			for _, idData in ipairs(buildingIds) do
				if idData.value and buildingNameById[idData.value] and not foundInThisList[idData.value] then
					foundInThisList[idData.value] = true
					foundCount = foundCount + 1
				end
			end
			if foundCount >= math.ceil(totalKnownIds * 0.98) then
				gg.toast("✅ Building list found.")
				return saveData(listStart)
			end
		end
	end
	gg.alert(
		string.format(
			"❌ No list met the criteria (>= 2500 buildings AND containing all %d known IDs).",
			totalKnownIds
		)
	)
	gg.setVisible(true)
	return false
end

function searchBuildingByName(promptTitle, searchLabel)
	searchLabel = searchLabel or "Enter name (or leave blank for all):"
	local input = gg.prompt({ searchLabel }, { "" }, { "text" })
	if not input then
		gg.toast("Search canceled.")
		return nil
	end
	local searchTerm = string.lower(input[1])
	local matches = {}
	for id, data in pairs(buildingDatabase) do
		if data.name then
			if searchTerm == "" or string.find(string.lower(data.name), searchTerm, 1, true) then
				table.insert(matches, { id = id, name = data.name, pointer = data.pointer })
			end
		end
	end
	if #matches == 0 then
		gg.alert('No building found with the name "' .. input[1] .. '".')
		return nil
	end
	table.sort(matches, function(a, b)
		return a.name < b.name
	end)
	local currentPage, pageSize = 1, 30
	while true do
		local totalPages = math.ceil(#matches / pageSize)
		if currentPage > totalPages then
			currentPage = totalPages
		end
		if currentPage < 1 then
			currentPage = 1
		end
		local startIndex = (currentPage - 1) * pageSize + 1
		local endIndex = math.min(startIndex + pageSize - 1, #matches)
		local menuItems, topControls =
			{}, { "↩️ Back", "⚙️ Change Page Size (" .. pageSize .. ")", "⏭️ Skip To Page..." }
		if currentPage > 1 then
			table.insert(topControls, "⬅️ Previous Page")
		end
		for _, ctrl in ipairs(topControls) do
			table.insert(menuItems, ctrl)
		end
		table.insert(menuItems, string.format("Page %d/%d (%d Search Results)", currentPage, totalPages, #matches))
		for i = startIndex, endIndex do
			table.insert(menuItems, matches[i].name)
		end
		local bottomControls = {}
		if currentPage < totalPages then
			table.insert(bottomControls, "➡️ Next Page")
		end
		for _, ctrl in ipairs(bottomControls) do
			table.insert(menuItems, ctrl)
		end
		local choice = gg.choice(menuItems, nil, promptTitle)
		if not choice then
			gg.toast("Search Canceled.")
			return nil
		end
		local selectedText = menuItems[choice]
		if selectedText == "↩️ Back" then
			return nil
		elseif string.find(selectedText, "Change Page Size", 1, true) then
			local newSize = gg.prompt({ "Enter new page size:" }, { pageSize }, { "number" })
			if newSize and newSize[1] and tonumber(newSize[1]) > 0 then
				pageSize = tonumber(newSize[1])
				currentPage = 1
			end
		elseif selectedText == "⏭️ Skip To Page..." then
			local newPage = gg.prompt(
				{ string.format("Skip to page (1-%d):", totalPages) },
				{ currentPage },
				{ "number" }
			)
			if newPage and newPage[1] then
				local p = tonumber(newPage[1])
				if p >= 1 and p <= totalPages then
					currentPage = p
				else
					gg.toast("Invalid page number.")
				end
			end
		elseif selectedText == "⬅️ Previous Page" then
			currentPage = currentPage - 1
		elseif selectedText == "➡️ Next Page" then
			currentPage = currentPage + 1
		else
			for i = startIndex, endIndex do
				if matches[i] and matches[i].name == selectedText then
					return matches[i]
				end
			end
		end
	end
end

function replaceMethod()
	gg.toast("Recommended to use in Daniel's city to avoid crashes.")
	local buildingToReplace = searchBuildingByName("Results for OLD building", "Enter name of building TO BE REPLACED:")
	if not buildingToReplace then
		return
	end
	local buildingToPlace = searchBuildingByName("Results for NEW building", "Enter name of NEW building to place:")
	if not buildingToPlace then
		return
	end
	gg.toast("Replacing... This may take a moment.")
	gg.clearResults()
	gg.setVisible(false)
	gg.setRanges(gg.REGION_ANONYMOUS | gg.REGION_C_ALLOC | gg.REGION_OTHER)
	gg.searchNumber(buildingToReplace.pointer, gg.TYPE_QWORD)
	if gg.getResultsCount() > 0 then
		gg.getResults(gg.getResultsCount())
		gg.editAll(buildingToPlace.pointer, gg.TYPE_QWORD)
		gg.clearResults()
		gg.alert("Done! Now go to Daniel City or Switch regions to apply changes")
	else
		gg.alert("No occurrences of the building to be replaced were found.")
	end
end

function getFactoryItemData(itemIndex)
	if factoryItemsCache[itemIndex] then
		return factoryItemsCache[itemIndex]
	end
	gg.toast("Locating factory item " .. factoryItemsMenuDefault[itemIndex] .. "...")
	gg.setVisible(false)
	gg.setRanges(gg.REGION_C_ALLOC | gg.REGION_OTHER | gg.REGION_ANONYMOUS)
	gg.clearResults()
	gg.searchNumber(tonumber(factoryConstants[itemIndex]), gg.TYPE_DWORD)
	local r = gg.getResults(1)
	gg.clearResults()
	if #r > 0 then
		local a = r[1].address + 0x1c
		local d = gg.getValues({ { address = a, flags = gg.TYPE_QWORD } })
		if d and d[1] then
			factoryItemsCache[itemIndex] = { address = a, initialValue = d[1].value }
			return factoryItemsCache[itemIndex]
		end
	end
	gg.setVisible(true)
	gg.alert("Could not find factory item: " .. factoryItemsMenuDefault[itemIndex])
	return nil
end

function presetsMenu()
	local function customSort(a, b)
		local seasonA = tonumber(a:match("Season (%d+)")) or 0
		local seasonB = tonumber(b:match("Season (%d+)")) or 0
		local partA = tonumber(a:match("Part (%d+)")) or 0
		local partB = tonumber(b:match("Part (%d+)")) or 0

		if seasonA ~= seasonB then
			return seasonA > seasonB
		end

		if partA ~= partB then
			return partA < partB
		end

		return a < b
	end

	while true do
		if next(presets) == nil then
			gg.alert("You have not defined any presets in the script.")
			return
		end

		local categoryNames = {}
		for name, _ in pairs(presets) do
			table.insert(categoryNames, name)
		end

		local categoryPriority = {
			["👑 Mayor Pass"] = 1,
			["🔨 Services"] = 2,
			["🍂 Seasonal Events"] = 3,
			["🌃 Building Effects"] = 4,
			["🚄 Railway Stations"] = 99,
		}
		table.sort(categoryNames, function(a, b)
			local priorityA = categoryPriority[a] or 50
			local priorityB = categoryPriority[b] or 50
			if priorityA ~= priorityB then
				return priorityA < priorityB
			end
			return a < b
		end)

		table.insert(categoryNames, 1, "⬅️ Back")

		local categoryChoice = gg.choice(categoryNames, nil, "🎁 Choose a Preset Category")

		if categoryChoice == nil then
			gg.setVisible(false)
			while not gg.isVisible() do
				gg.sleep(100)
			end
		elseif categoryChoice == 1 then
			return
		else
			local selectedCategoryName = categoryNames[categoryChoice]
			local currentLevelData = presets[selectedCategoryName]
			local breadcrumb = selectedCategoryName
			local history = {}

			while true do
				if type(currentLevelData[1]) == "table" and currentLevelData[1].id then
					local buildingsInPreset = currentLevelData
					revertFactoryChanges(true)
					gg.toast("Applying preset: " .. breadcrumb)
					local notFoundCount = 0
					for i, building in ipairs(buildingsInPreset) do
						if i <= 11 then
							local buildingInfo = buildingDatabase[building.id]
							if buildingInfo then
								setFactoryItem(i, buildingInfo.pointer, buildingInfo.name)
							else
								notFoundCount = notFoundCount + 1
							end
						else
							break
						end
					end
					gg.toast("✅ Preset '" .. breadcrumb .. "' applied successfully!")
					if notFoundCount > 0 then
						gg.alert(
							notFoundCount .. " building(s) in the preset were not found in memory and were skipped."
						)
					end
					return
				end

				local menuItems = { "⬅️ Back" }
				local menuKeys = {}
				for key, _ in pairs(currentLevelData) do
					table.insert(menuKeys, key)
				end

				table.sort(menuKeys, customSort)

				for _, key in ipairs(menuKeys) do
					table.insert(menuItems, key)
				end

				local subMenuChoice = gg.choice(menuItems, nil, "🎁 " .. breadcrumb)

				if subMenuChoice == nil then
					gg.setVisible(false)
					while not gg.isVisible() do
						gg.sleep(100)
					end
				elseif subMenuChoice == 1 then
					if #history > 0 then
						local lastState = table.remove(history)
						currentLevelData = lastState.data
						breadcrumb = lastState.path
					else
						break
					end
				else
					table.insert(history, { data = currentLevelData, path = breadcrumb })

					local selectedKey = menuItems[subMenuChoice]
					currentLevelData = currentLevelData[selectedKey]
					breadcrumb = breadcrumb .. " > " .. selectedKey
				end
			end
		end
	end
end

function revertFactoryChanges(isSilent)
	local toRevert = {}
	for i = 1, 11 do
		if factoryItemsCache[i] and factoryItemsCache[i].initialValue then
			table.insert(toRevert, {
				address = factoryItemsCache[i].address,
				flags = gg.TYPE_QWORD,
				value = factoryItemsCache[i].initialValue,
			})
			factoryItemsCache[i].currentName = nil
		end
	end
	if #toRevert > 0 then
		gg.setValues(toRevert)
		if not isSilent then
			gg.toast("All modified factory items have been reverted.")
		end
	elseif not isSilent then
		gg.alert("No changes to revert.")
	end
end

function setFactoryItem(itemIndex, pointer, name)
	local itemData = getFactoryItemData(itemIndex)
	if not itemData then
		return
	end
	if not name then
		name = "Unknown"
	end
	gg.setValues({ { address = itemData.address, flags = gg.TYPE_QWORD, value = pointer } })
	itemData.currentName = name
	gg.toast(name .. " set to " .. (factoryItemsMenuDefault[itemIndex] or "Unknown"))
end

function factoryMethodMenu()
	while true do
		local menu = { "⬅️ Back", "🔄 Revert", "🏭 Production Settings", "🎁 Presets" }
		for i = 1, 11 do
			local currentName = "-> Not Set"
			if factoryItemsCache[i] and factoryItemsCache[i].currentName then
				currentName = "-> " .. factoryItemsCache[i].currentName
			end
			table.insert(menu, factoryItemsMenuDefault[i] .. " " .. currentName)
		end
		local choice = gg.choice(menu, nil, "Tap Item To Produce Specific Building")
		if not choice then
			gg.setVisible(false)
			while not gg.isVisible() do
				gg.sleep(100)
			end
		elseif choice == 1 then
			return
		elseif choice == 2 then
			revertFactoryChanges(false)
		elseif choice == 3 then
			factorySettings()
		elseif choice == 4 then
			local buildingsFromPrese = presetsMenu()
			if buildingsFromPrese then
				revertFactoryChanges(true)
				gg.toast("Applying preset...")
				local notFoundCount = 0
				for i, building in ipairs(buildingsFromPrese) do
					if i <= 11 then
						local buildingInfo = buildingDatabase[building.id]
						if buildingInfo then
							setFactoryItem(i, buildingInfo.pointer, buildingInfo.name)
						else
							notFoundCount = notFoundCount + 1
						end
					else
						break
					end
				end
				gg.toast("✅ Preset applied successfully!")
				if notFoundCount > 0 then
					gg.alert(notFoundCount .. " building(s) in the preset were not found and were skipped.")
				end
			end
		else
			local itemIndex = choice - 4
			local selectedBuilding =
				searchBuildingByName("Select building for " .. factoryItemsMenuDefault[itemIndex] .. ":")
			if selectedBuilding then
				setFactoryItem(itemIndex, selectedBuilding.pointer, selectedBuilding.name)
			end
		end
	end
end

local function presetsMenuBuilding(foundBuildingsCount)
	if not foundBuildingsCount then
		foundBuildingsCount = 0
	end
	if not presets or next(presets) == nil then
		gg.alert("You have not defined any presets in the script.")
		return nil
	end

	local function navigateAndSelect(currentTable, title)
		while true do
			local isLeafNode = false
			local firstKey = next(currentTable)
			if firstKey then
				local firstValue = currentTable[firstKey]
				if type(firstValue) == "table" and type(firstValue[1]) == "table" and firstValue[1].id then
					isLeafNode = true
				end
			end

			if isLeafNode then
				local presetNames = {}
				for name, _ in pairs(currentTable) do
					table.insert(presetNames, name)
				end

				local function extractNumber(name)
					return tonumber(string.match(name, "Part (%d+)"))
						or tonumber(string.match(name, "Season (%d+)"))
						or tonumber(string.match(name, "(%d+)"))
						or 0
				end

				if title:match("Mayor Pass") then
					table.sort(presetNames, function(a, b)
						return extractNumber(a) > extractNumber(b)
					end)
				else
					table.sort(presetNames, function(a, b)
						local numA, numB = extractNumber(a), extractNumber(b)
						if numA ~= 0 and numB ~= 0 then
							return numA < numB
						else
							return a < b
						end
					end)
				end

				local header = "Select presets (Total cannot exceed " .. foundBuildingsCount .. " buildings):"
				local choiceItems = { "?? Back" }
				for _, name in ipairs(presetNames) do
					table.insert(choiceItems, name)
				end

				local selections = gg.multiChoice(choiceItems, nil, header)

				if not selections then
					gg.setVisible(false)
					while not gg.isVisible() do
						gg.sleep(100)
					end
				elseif selections[1] then
					return "back"
				else
					local combinedPreset = {}
					local totalBuildingCount = 0
					for i = 2, #choiceItems do
						if selections[i] then
							totalBuildingCount = totalBuildingCount + #currentTable[choiceItems[i]]
						end
					end

					if totalBuildingCount > foundBuildingsCount then
						gg.alert(
							"Selection failed.\n\nTotal buildings in selected presets: "
								.. totalBuildingCount
								.. "\nReward slots found: "
								.. foundBuildingsCount
						)
					elseif totalBuildingCount > 0 then
						for i = 2, #choiceItems do
							if selections[i] then
								local buildings = currentTable[choiceItems[i]]
								for _, building in ipairs(buildings) do
									table.insert(combinedPreset, building)
								end
							end
						end
						return combinedPreset
					end
				end
			else
				local categoryNames = {}
				for name, _ in pairs(currentTable) do
					table.insert(categoryNames, name)
				end

				local categoryPriority =
					{ ["👑 Mayor Pass"] = 1, ["🔨 Services"] = 2, ["🚄 Railway Stations"] = 99 }
				table.sort(categoryNames, function(a, b)
					local pA = categoryPriority[a] or 50
					local pB = categoryPriority[b] or 50
					if pA ~= pB then
						return pA < pB
					end
					return a < b
				end)

				local menu = { "🔙 Back" }
				for _, name in ipairs(categoryNames) do
					table.insert(menu, name)
				end

				local categoryChoice = gg.choice(menu, nil, title)

				if not categoryChoice then
					gg.setVisible(false)
					while not gg.isVisible() do
						gg.sleep(100)
					end
				elseif categoryChoice == 1 then
					return "back"
				else
					local selectedCategoryName = menu[categoryChoice]
					local result = navigateAndSelect(currentTable[selectedCategoryName], selectedCategoryName)

					if type(result) == "table" then
						return result
					end
				end
			end
		end
	end

	local result = navigateAndSelect(presets, "🎁 Choose a Preset Category")
	if type(result) == "table" then
		return result
	end

	return nil
end

local function findAllCellBases()
	if cachedPassBases then
		gg.toast("Using cached cell base addresses.")
		return cachedPassBases
	end
	gg.setVisible(false)
	gg.toast("Searching for Vu Pass cell bases...")
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS | gg.REGION_C_ALLOC | gg.REGION_OTHER)
	gg.searchNumber("8319099934827697938", gg.TYPE_QWORD)

	local results = gg.getResults(100)
	if #results == 0 then
		gg.setVisible(true)
		return nil
	end

	for _, r in ipairs(results) do
		local ptrAddr = r.address + 0x18
		local ptrValResult = gg.getValues({ { address = ptrAddr, flags = gg.TYPE_QWORD } })
		if ptrValResult and ptrValResult[1].value and ptrValResult[1].value ~= 0 then
			local ptrVal = ptrValResult[1].value
			local val180Result = gg.getValues({ { address = ptrVal + 0x180, flags = gg.TYPE_DWORD } })
			if val180Result and val180Result[1].value == 1145656354 then
				local pointer1_addr = val180Result[1].address - 0xF8
				local pointer1Result = gg.getValues({ { address = pointer1_addr, flags = gg.TYPE_QWORD } })
				if pointer1Result and pointer1Result[1].value and pointer1Result[1].value ~= 0 then
					local pointer1 = pointer1Result[1].value

					local baseAddresses, offsets = {}, { 0x00, 0x18, 0x30, 0x48 }

					local pointers_to_read = {}
					for _, offset in ipairs(offsets) do
						table.insert(pointers_to_read, { address = pointer1 + offset, flags = gg.TYPE_QWORD })
					end
					local cellPointers = gg.getValues(pointers_to_read)

					for _, cellPtrInfo in ipairs(cellPointers) do
						local cellPointer = cellPtrInfo.value

						if cellPointer and cellPointer ~= 0 then
							local validationResult =
								gg.getValues({ { address = cellPointer + 0xC, flags = gg.TYPE_DWORD } })

							if
								validationResult
								and validationResult[1].value
								and validCellValues[validationResult[1].value]
							then
								table.insert(baseAddresses, cellPointer + 0x30)
							end
						end
					end

					if #baseAddresses == 4 then
						gg.setVisible(true)
						gg.toast("✅ All 4 cell bases found and cached.")
						return baseAddresses
					end
				end
			end
		end
	end

	gg.setVisible(true)
	return nil
end

local function applyRewardsToPass(baseAddress, cellInfo, towerDataModel, towerBlock2Spec, quantity, startIndexOffset)
	if not startIndexOffset then
		startIndexOffset = 0
	end
	gg.toast("Applying data to " .. cellInfo.name .. "...")
	gg.clearList()

	local current = gg.getValues({
		{ address = baseAddress, flags = gg.TYPE_DWORD },
		{ address = baseAddress - 0x8, flags = gg.TYPE_DWORD },
		{ address = baseAddress - 0x10, flags = gg.TYPE_DWORD },
	})

	local accumulated = {}

	for i = 1, cellInfo.rewardCount do
		for _, v in ipairs(current) do
			table.insert(accumulated, v)
		end

		if i < cellInfo.rewardCount then
			local nextBatch = {}
			for _, v in ipairs(current) do
				table.insert(nextBatch, { address = v.address + 0xA0, flags = gg.TYPE_DWORD })
			end
			current = gg.getValues(nextBatch)
		end
	end

	gg.addListItems(accumulated)
	local list = gg.getListItems()

	local pointersToRead = {}
	for i = 1, #list, 3 do
		table.insert(pointersToRead, { address = list[i].address, flags = gg.TYPE_QWORD })
		table.insert(pointersToRead, { address = list[i + 1].address, flags = gg.TYPE_QWORD })
	end

	if #pointersToRead == 0 then
		return
	end
	local resolvedPointers = gg.getValues(pointersToRead)
	local allEdits, pointer_idx = {}, 1

	local limit = math.min(cellInfo.rewardCount, #towerDataModel - startIndexOffset)

	for i = 1, limit do
		local model = towerDataModel[startIndexOffset + i]
		if not model or not model.values then
			pointer_idx = pointer_idx + 2
		else
			local idx = (i - 1) * 3
			local qty_addr = list[idx + 3].address
			local target_ptr_tower = resolvedPointers[pointer_idx].value
			local target_ptr_spec = resolvedPointers[pointer_idx + 1].value
			pointer_idx = pointer_idx + 2

			if target_ptr_tower and target_ptr_tower ~= 0 and target_ptr_spec and target_ptr_spec ~= 0 then
				for j = 1, #model.values do
					table.insert(
						allEdits,
						{ address = target_ptr_tower + (j - 1) * 4, flags = gg.TYPE_QWORD, value = model.values[j] }
					)
				end
				for j = 1, #towerBlock2Spec do
					table.insert(
						allEdits,
						{ address = target_ptr_spec + (j - 1) * 4, flags = gg.TYPE_QWORD, value = towerBlock2Spec[j] }
					)
				end
				table.insert(allEdits, { address = qty_addr, flags = gg.TYPE_DWORD, value = quantity })
				table.insert(allEdits, { address = qty_addr + 0x38, flags = gg.TYPE_DWORD, value = 0 })
			end
		end
	end
	if #allEdits > 0 then
		gg.setValues(allEdits)
	end
end

local cachedValidatedBankAddresses = {}
local lastSearchedBankIndex = 0

function advancedPassReplacementTool()
	if not isBuildingToolInitialized then
		if not discoverBuildingPointers() then
			return
		end
		isBuildingToolInitialized = true
	end
	if not cachedPassBases then
		cachedPassBases = findAllCellBases()
		if not cachedPassBases then
			gg.alert("❌ Failed to find Vu Pass cell bases. Try again inside Vu Pass.")
			return
		end
	end

	local fixedTowerData = {
		{ name = "Neo Bank 1", values = { 6876268013136727582, 7741231747193203027, 3905549274568352066, 909331551 } },
		{ name = "Neo Bank 2", values = { 6876268013136727582, 7741231747193203027, 3833491680530424130, 892554335 } },
		{ name = "Neo Bank 3", values = { 6876268013136727582, 7741231747193203027, 3761434086492496194, 875777119 } },
		{ name = "Neo Bank 4", values = { 6876268013136727582, 7741231747193203027, 3689376492454568258, 858999903 } },
		{ name = "Neo Bank 5", values = { 6876268013136727582, 7741231747193203027, 3617318898416640322, 842222687 } },
		{ name = "Neo Bank 6", values = { 6876268013136727582, 7741231747193203027, 3545261304378712386, 825445471 } },
		{ name = "Neo Bank 7", values = { 6876268013136727582, 7741231747193203027, 3473203710340784450, 808668255 } },
		{ name = "Neo Bank 8", values = { 6876268013136727582, 7741231747193203027, 4121440581705425218, 959597663 } },
		{ name = "Neo Bank 9", values = { 6876268013136727582, 7741231747193203027, 4049382987667497282, 942820447 } },
		{ name = "Neo Bank 10", values = { 6876268013136727582, 7741231747193203027, 3977325393629569346, 926043231 } },
		{ name = "Neo Bank 11", values = { 6876268013136727582, 7741231747193203027, 3905267799591641410, 909266015 } },
		{ name = "Neo Bank 12", values = { 6876268013136727582, 7741231747193203027, 3833210205553713474, 892488799 } },
		{ name = "Neo Bank 13", values = { 6876268013136727582, 7741231747193203027, 3761152611515785538, 875711583 } },
		{ name = "Neo Bank 14", values = { 6876268013136727582, 7741231747193203027, 3689095017477857602, 858934367 } },
		{ name = "Neo Bank 15", values = { 6876268013136727582, 7741231747193203027, 3617037423439929666, 842157151 } },
		{ name = "Neo Bank 16", values = { 6876268013136727582, 7741231747193203027, 3544979829402001730, 825379935 } },
		{ name = "Neo Bank 17", values = { 6876268013136727582, 7741231747193203027, 3472922235364073794, 808602719 } },
		{ name = "Neo Bank 18", values = { 6876268013136727582, 7741231747193203027, 4121159106728714562, 959532127 } },
		{ name = "Neo Bank 19", values = { 6876268013136727582, 7741231747193203027, 4049101512690786626, 942754911 } },
		{ name = "Neo Bank 20", values = { 6876268013136727582, 7741231747193203027, 3977043918652858690, 925977695 } },
		{ name = "Neo Bank 21", values = { 6876268013136727582, 7741231747193203027, 3904986324614930754, 909200479 } },
		{ name = "Neo Bank 22", values = { 6876268013136727582, 7741231747193203027, 3832928730577002818, 892423263 } },
		{ name = "Neo Bank 23", values = { 6876268013136727582, 7741231747193203027, 3760871136539074882, 875646047 } },
		{ name = "Neo Bank 24", values = { 6876268013136727582, 7741231747193203027, 3688813542501146946, 858868831 } },
		{ name = "Neo Bank 25", values = { 6876268013136727582, 7741231747193203027, 3616755948463219010, 842091615 } },
		{ name = "Neo Bank 26", values = { 6876268013136727582, 7741231747193203027, 3544698354425291074, 825314399 } },
		{ name = "Neo Bank 27", values = { 6876268013136727582, 7741231747193203027, 3472640760387363138, 808537183 } },
		{ name = "Neo Bank 28", values = { 6876268013136727580, 7741231747193203027, 16128046380507458, 3755103 } },
		{ name = "Neo Bank 29", values = { 6876268013136727580, 7741231747193203027, 15846571403796802, 3689567 } },
		{ name = "Neo Bank 30", values = { 6876268013136727580, 7741231747193203027, 15565096427086146, 3624031 } },
		{ name = "Neo Bank 31", values = { 6876268013136727580, 7741231747193203027, 15283621450375490, 3558495 } },
		{ name = "Neo Bank 32", values = { 6876268013136727580, 7741231747193203027, 15002146473664834, 3492959 } },
		{ name = "Neo Bank 33", values = { 6876268013136727580, 7741231747193203027, 14720671496954178, 3427423 } },
		{ name = "Neo Bank 34", values = { 6876268013136727580, 7741231747193203027, 14439196520243522, 3361887 } },
	}
	local towerBlock2Spec =
		{ 0x6C62617466696722, 0x75625F656C626174, 0x69646C6975625F65, 0x0000676E69646C69, 0x000000000000676E }

	local function findMoreBankBuildings(amountToFind)
		gg.toast(string.format("Finding %d more reward slots...", amountToFind))
		gg.setVisible(false)

		local towerIDs_in_order = {
			-741647361,
			-741647362,
			-741647363,
			-741647364,
			-741647365,
			-741647366,
			-741647367,
			-741647391,
			-741647392,
			-741647393,
			-741647394,
			-741647395,
			-741647396,
			-741647397,
			-741647398,
			-741647399,
			-741647400,
			-741647424,
			-741647425,
			-741647426,
			-741647427,
			-741647428,
			-741647429,
			-741647430,
			-741647431,
			-741647432,
			-741647433,
			1148880559,
			1148880558,
			1148880557,
			1148880556,
			1148880555,
			1148880554,
			1148880553,
		}

		local newlyFound = 0
		for i = 1, amountToFind do
			if lastSearchedBankIndex >= #towerIDs_in_order then
				gg.toast("All 34 reward slots have been found.")
				break
			end

			lastSearchedBankIndex = lastSearchedBankIndex + 1
			local id = towerIDs_in_order[lastSearchedBankIndex]
			local buildingInfo = buildingDatabase[id]

			if buildingInfo and buildingInfo.pointer then
				gg.clearResults()
				gg.searchNumber(buildingInfo.pointer, gg.TYPE_QWORD)

				if gg.getResultsCount() > 0 then
					for _, loc in ipairs(gg.getResults(gg.getResultsCount())) do
						local res = gg.getValues({ { address = loc.address - 0x18, flags = gg.TYPE_QWORD } })[1]
						if res and (res.value == 6876268013136727582 or res.value == 6876268013136727580) then
							table.insert(cachedValidatedBankAddresses, loc)
							newlyFound = newlyFound + 1
							gg.toast(string.format("%d/%d Buildings Found", newlyFound, amountToFind))
							break
						end
					end
				end
			end
		end

		gg.setVisible(true)
		gg.toast(
			string.format("Finished. Found %d new locations. Total: %d", newlyFound, #cachedValidatedBankAddresses)
		)
	end

	if #cachedValidatedBankAddresses == 0 then
		local promptMsg = [[
Cell 1: 10 Rewards
Cell 2: 10 Rewards
Cell 3: 10 Rewards
Cell 4: 10 Rewards

Type at least 11 if you want to use large presets (ex. Mayor's Pass).

How many buildings do you want to find?
]]
		local numToFind = gg.prompt({ promptMsg }, { "11" }, { "number" })
		if numToFind and tonumber(numToFind[1]) > 0 then
			findMoreBankBuildings(tonumber(numToFind[1]))
		else
			return
		end
	end

	while true do
		local header = string.format("%d/34 REWARD SLOTS FOUND", #cachedValidatedBankAddresses)
		local presetOptionText = "🎁 Presets"
		if #cachedValidatedBankAddresses < 11 then
			presetOptionText = "🎁 Can't use presets, find at least 11 buildings"
		end
		local menu = {
			"🔍Find More Buildings",
			"💻 Search Buildings & Apply",
			"🔀 Random Buildings ",
			presetOptionText,
			"🔙 Back",
		}

		local choice = gg.choice(menu, nil, header)

		if choice == nil then
			gg.setVisible(false)
			while not gg.isVisible() do
				gg.sleep(100)
			end
			goto continue_loop
		elseif choice == 5 then
			return
		end

		local pointerPattern = {}
		local isSearchMode = false

		if choice == 1 then
			local remaining = 34 - #cachedValidatedBankAddresses
			if remaining <= 0 then
				gg.alert("All 34 reward slots have been found.")
			else
				local numToFind = gg.prompt(
					{ "How many more slots to find? (Max " .. remaining .. ")" },
					{ "10" },
					{ "number" }
				)
				if numToFind and tonumber(numToFind[1]) > 0 then
					findMoreBankBuildings(tonumber(numToFind[1]))
				end
			end
		elseif choice == 2 then
			isSearchMode = true
			local bldg = searchBuildingByName("Select a building", "Enter name:")
			if bldg and bldg.pointer then
				table.insert(pointerPattern, bldg.pointer)
			end
		elseif choice == 3 then
			isSearchMode = false
			local numInput = gg.prompt({ "How many random buildings to apply?" }, { 11 }, { "number" })
			if not (numInput and tonumber(numInput[1]) and tonumber(numInput[1]) > 0) then
				goto continue_loop
			end
			local numToRandomize = tonumber(numInput[1])

			local allBuildingIds = {}
			for id, _ in pairs(buildingNameById) do
				table.insert(allBuildingIds, id)
			end
			math.randomseed(os.time())
			for i = 1, numToRandomize do
				local randomId = allBuildingIds[math.random(#allBuildingIds)]
				local b_info = buildingDatabase[randomId]
				if b_info and b_info.pointer then
					table.insert(pointerPattern, b_info.pointer)
				else
					i = i - 1
				end
			end
		elseif choice == 4 then
			if #cachedValidatedBankAddresses < 11 then
				gg.alert("You must find at least 11 reward slots.")
				goto continue_loop
			end
			isSearchMode = false
			local presetBuildingData = presetsMenuBuilding(#cachedValidatedBankAddresses)
			if not presetBuildingData or #presetBuildingData == 0 then
				goto continue_loop
			end
			for _, buildingData in ipairs(presetBuildingData) do
				local b_info = buildingDatabase[buildingData.id]
				if b_info and b_info.pointer then
					table.insert(pointerPattern, b_info.pointer)
				else
					gg.alert("Warning: Pointer for ID " .. tostring(buildingData.id) .. " not found.")
				end
			end
		end

		if #pointerPattern > 0 then
			local input = gg.prompt({ "How many buildings do you want?" }, { 1 }, { "number" })
			if not (input and tonumber(input[1]) > 0) then
				goto continue_loop
			end
			local quantity = tonumber(input[1])

			local cellData = {
				{ name = "Cell 1 (10 R.)", rc = 10, idx = 1 },
				{ name = "Cell 2 (10 R.)", rc = 10, idx = 2 },
				{ name = "Cell 3 (10 R.)", rc = 10, idx = 3 },
				{ name = "Cell 4 (10 R.)", rc = 10, idx = 4 },
			}
			local menuItems, menuMap = {}, {}

			local requiredSlots = #pointerPattern

			for i, cell in ipairs(cellData) do
				if requiredSlots > 10 and i == 4 then
				else
					table.insert(menuItems, cell.name)
					menuMap[#menuItems] = cell
				end
			end

			if #menuItems == 0 then
				gg.alert("No suitable cells available.")
				goto continue_loop
			end

			table.insert(menuItems, "🔙 Back")
			local cellChoice = gg.choice(
				menuItems,
				nil,
				"Apply to (Overflows to next cell if preset choosen has more than 10 buildings):"
			)

			if cellChoice == nil then
				gg.toast("Canceled")
				goto continue_loop
			elseif cellChoice == #menuItems then
				goto continue_loop
			end

			local selectedCell = menuMap[cellChoice]
			local cellIndex = selectedCell.idx
			local processedCount = 0

			gg.setVisible(false)

			while processedCount < requiredSlots do
				if cellIndex > 4 then
					gg.alert("Warning: Not enough cells to fit all buildings. Stopped at Cell 4.")
					break
				end

				local currentCell = cellData[cellIndex]
				gg.toast("Applying to " .. currentCell.name)

				local batchSize = math.min(10, requiredSlots - processedCount)
				local pointerEdits = {}
				local dataForPass = {}

				for i = 1, batchSize do
					local globalIndex = processedCount + i
					local newPointer = pointerPattern[globalIndex]

					if globalIndex <= #cachedValidatedBankAddresses then
						table.insert(pointerEdits, {
							address = cachedValidatedBankAddresses[globalIndex].address,
							flags = gg.TYPE_QWORD,
							value = newPointer,
						})
						table.insert(dataForPass, fixedTowerData[globalIndex])
					else
						gg.alert("Not enough validated reward slots found in memory!")
						break
					end
				end

				if #pointerEdits > 0 then
					gg.setValues(pointerEdits)
					applyRewardsToPass(
						cachedPassBases[currentCell.idx],
						{ name = currentCell.name, rewardCount = 10 },
						dataForPass,
						towerBlock2Spec,
						quantity,
						0
					)
				end

				processedCount = processedCount + batchSize
				cellIndex = cellIndex + 1
			end

			gg.setVisible(true)
			gg.toast("✅ Done!")
		end
		::continue_loop::
	end
end

function mainMenuBuildingTool()
	while true do
		local menuChoices = {
			"⬅️ Back",
			"↔️ Replace Method",
			"🏭 Factory Method",
			"🎁 Vu Pass Method",
			"❓ Help",
		}

		local selectedIndex = gg.choice(menuChoices, nil, "✨Building Tool ✨")

		if selectedIndex == nil then
			gg.setVisible(false)
			while not gg.isVisible() do
				gg.sleep(100)
			end
		elseif selectedIndex == 1 then
			return
		elseif selectedIndex == 2 then
			replaceMethod()
		elseif selectedIndex == 3 then
			factoryMethodMenu()
		elseif selectedIndex == 4 then
			advancedPassReplacementTool()
		elseif selectedIndex == 5 then
			gg.alert(
				"HELP:\n\n"
					.. "↔️ REPLACE METHOD:\n"
					.. "Allows you to replace an existing building with another...\n\n"
					.. "🏭 FACTORY METHOD:\n"
					.. "Allows you to produce any storable building using factory items...\n\n"
					.. "?? Vu Pass Method:\n"
					.. "Finds buildings, replaces their pointers in memory with your building choice then applies the result to the Vu Pass."
			)
		end
	end
end

function runBuildingTool()
	if not isBuildingToolInitialized then
		gg.toast("Initializing Building Tool for the first time... Please wait.")
		if discoverBuildingPointers() then
			isBuildingToolInitialized = true
		else
			gg.alert("Building Tool initialization failed. Could not find building data.")
			return
		end
	else
		gg.toast("Building Tool already loaded.")
	end
	mainMenuBuildingTool()
end

function excludewar()
	gg.clearResults()
	gg.clearList()
	gg.setVisible(false)
	gg.setRanges(gg.REGION_ANONYMOUS | gg.REGION_C_ALLOC | gg.REGION_OTHER)

	gg.searchNumber("1430583743", gg.TYPE_DWORD)
	local results = gg.getResults(10000)
	if #results == 0 then
		gg.toast("Error: no results found")
		return
	end

	local offsets1 = {}
	for i, v in ipairs(results) do
		table.insert(offsets1, { address = v.address - 0x48, flags = gg.TYPE_DWORD })
	end
	gg.clearResults()
	gg.loadResults(offsets1)
	gg.refineNumber("53", gg.TYPE_DWORD)
	local refined1 = gg.getResults(10000)
	if #refined1 == 0 then
		gg.toast("Error: no results after refining by 53")
		return
	end

	local offsets2 = {}
	for i, v in ipairs(refined1) do
		table.insert(offsets2, { address = v.address - 0x8, flags = gg.TYPE_DWORD })
	end
	gg.clearResults()
	gg.loadResults(offsets2)

	local baseValues = gg.getResults(100)
	gg.clearResults()

	gg.searchNumber(tostring(baseValues[1].value), gg.TYPE_DWORD)
	local found = gg.getResults(10000)

	local toEdit = {}
	for i, v in ipairs(found) do
		table.insert(toEdit, { address = v.address + 0x2B0, flags = gg.TYPE_DWORD })
		table.insert(toEdit, { address = v.address + 0x2B8, flags = gg.TYPE_DWORD })
		table.insert(toEdit, { address = v.address + 0x2C0, flags = gg.TYPE_DWORD })
	end

	gg.clearResults()
	gg.loadResults(toEdit)
	local resultsToEdit = gg.getResults(#toEdit)
	if #resultsToEdit == 0 then
		gg.toast("Error: no results to edit")
		return
	end
	gg.editAll("0", gg.TYPE_DWORD)
	gg.toast("Success")
	gg.clearResults()
	gg.clearList()
end

activeTask = activeTask or nil
originalTaskValues = originalTaskValues or {}

function findTaskTargets()
	gg.setVisible(false)
	gg.clearResults()
	gg.clearList()
	gg.setRanges(gg.REGION_C_ALLOC | gg.REGION_C_DATA | gg.REGION_CODE_APP | gg.REGION_OTHER)

	local RootPointerBits =
		"h FF C3 02 D1 FD 7B 05 A9 FC 6F 06 A9 FA 67 07 A9 F8 5F 08 A9 F6 57 09 A9 F4 4F 0A A9 FD 43 01 91 28 D4 41 39"
	gg.searchNumber(RootPointerBits, gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
	if gg.getResultsCount() == 0 then
		return nil
	end

	gg.refineNumber("-1", gg.TYPE_BYTE)
	if gg.getResultsCount() == 0 then
		return nil
	end
	local refinedResults = gg.getResults(gg.getResultsCount())

	local firstLevelPointers = {}
	for _, result in ipairs(refinedResults) do
		gg.setVisible(false)
		gg.clearResults()
		gg.clearList()
		gg.searchNumber(string.format("%Xh", result.address), gg.TYPE_QWORD)
		local currentPointers = gg.getResults(gg.getResultsCount())
		for _, p in ipairs(currentPointers) do
			table.insert(firstLevelPointers, p)
		end
	end
	if #firstLevelPointers == 0 then
		return nil
	end

	local finalResults = {}
	for _, p1 in ipairs(firstLevelPointers) do
		gg.clearResults()
		gg.searchNumber(string.format("%Xh", p1.address), gg.TYPE_QWORD)
		local currentPointers = gg.getResults(gg.getResultsCount())
		for _, p2 in ipairs(currentPointers) do
			table.insert(finalResults, p2)
		end
	end
	if #finalResults == 0 then
		return nil
	end

	return finalResults
end

function toggleTaskCompletion(taskKey, offset, newValue, name)
	if activeTask == taskKey then
		gg.setValues(originalTaskValues)
		originalTaskValues = {}
		activeTask = nil
		gg.alert(name .. " DISABLED!")
		return
	end

	if activeTask ~= nil then
		gg.alert("Please disable the other active option first.")
		return
	end

	local finalResults = findTaskTargets()
	if not finalResults then
		gg.alert("Error, restart the game and try again")
		return
	end

	local addressesToCache = {}
	for _, item in ipairs(finalResults) do
		table.insert(addressesToCache, { address = item.address + offset, flags = gg.TYPE_DWORD })
	end
	originalTaskValues = gg.getValues(addressesToCache)

	local modifiedResults = {}
	for _, item in ipairs(finalResults) do
		table.insert(modifiedResults, { address = item.address + offset, flags = gg.TYPE_DWORD, value = newValue })
	end
	gg.setValues(modifiedResults)

	activeTask = taskKey
	gg.alert(name .. " ENABLED!")
end

function completetask()
	while true do
		local function getButtonText(taskKey, name)
			if activeTask == taskKey then
				return "🔴 " .. name
			else
				return "🟢 " .. name
			end
		end

		local options = {
			getButtonText("dailyBonus", "Complete Daily and Bonus Assignments"),
			getButtonText("dailyWeekly", "Complete Daily and Weekly Assignments"),
			"🔙 Back",
		}

		local choice = gg.choice(
			options,
			nil,
			"IMPORTANT: Follow these steps in order:\n\nFirst, activate 'Daily and Weekly' and collect rewards.\n\nThen, deactivate Daily and Weekly and activate 'Daily and Bonus' to collect the final rewards."
		)

		if choice == nil then
			gg.setVisible(false)
			while not gg.isVisible() do
				gg.sleep(100)
			end
		elseif choice == 3 then
			return
		elseif choice == 1 then
			toggleTaskCompletion("dailyBonus", 0x110, 3, "Daily and Bonus Assignments")
		elseif choice == 2 then
			toggleTaskCompletion("dailyWeekly", 0x120, 0, "Daily and Weekly Assignments")
		end
	end
end

function maxbank()
	gg.setVisible(false)
	gg.clearList()
	gg.clearResults()

	local success = pcall(function()
		gg.setRanges(gg.REGION_ANONYMOUS | gg.REGION_C_ALLOC | gg.REGION_OTHER)
		gg.searchNumber(":Future_CityBank", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1)
		gg.refineNumber("30", gg.TYPE_BYTE)
		local results = gg.getResults(gg.getResultsCount())
		if #results == 0 then
			return
		end

		local offsetResults = {}
		for i, v in ipairs(results) do
			table.insert(offsetResults, {
				address = v.address + 0x18,
				flags = gg.TYPE_DWORD,
			})
		end

		offsetResults = gg.getValues(offsetResults)
		gg.clearList()
		gg.addListItems(offsetResults)
		for i = 1, #offsetResults do
			offsetResults[i].value = -741647361
		end
		gg.setValues(offsetResults)
	end)

	gg.toast("Go to daniel city and come back")
	if not success then
		return
	end
	gg.clearList()
	gg.clearResults()
end

function bytemask(n)
	local bits = 0
	while n ~= 0 do
		bits = bits + 8
		n = n >> 8
	end
	return (1 << bits) - 1
end

warcards_all = {}

function bytemask(n)
	local bits = 0
	while n ~= 0 do
		bits = bits + 8
		n = n >> 8
	end
	return (1 << bits) - 1
end

function findWarcards()
	gg.clearResults()
	gg.setVisible(false)
	gg.clearList()
	gg.searchNumber("313272657473h", 32)
	local results = gg.getResults(-1)
	if #results == 0 then
		gg.alert("Error: Initial search for war cards failed.")
		return false
	end

	for i, v in ipairs(results) do
		results[i].address = v.address + 16
	end
	results = gg.getValues(results)

	local check = {}
	for i, v in ipairs(results) do
		check[i] = { address = v.value + 16, flags = 32 }
	end
	check = gg.getValues(check)

	for i, v in ipairs(check) do
		check[i].address = v.value + 8
	end
	check = gg.getValues(check)

	gg.clearResults()
	for i, v in ipairs(check) do
		if (v.value & bytemask(0x313272657473)) == 0x313272657473 then
			gg.searchNumber(gg.getValues({ { address = results[i].value, flags = 32 } })[1].value, 32)
			break
		end
	end

	if gg.getResultsCount() == 0 then
		gg.alert("Error: Could not find war cards.")
		return false
	end
	warcards_all = gg.getResults(-1)
	return true
end

function warcardUpgrade40()
	gg.clearList()
	gg.clearResults()
	gg.setVisible(false)
	gg.setRanges(gg.REGION_ANONYMOUS | gg.REGION_C_ALLOC | gg.REGION_OTHER)

	if not findWarcards() then
		gg.toast("Failed to find war cards. Aborting.")
		gg.setVisible(true)
		return
	end

	local correctConstant = nil
	gg.clearResults()
	gg.searchNumber(1092744876, gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
	local parkConstant = gg.getResults(-1)
	gg.clearResults()

	if #parkConstant > 0 then
		local toGet = {}
		for i = 1, #parkConstant do
			toGet[i] = {
				address = parkConstant[i].address - 0x48,
				flags = gg.TYPE_DWORD,
			}
		end
		local correctConstantCheck = gg.getValues(toGet)
		for i = 1, #correctConstantCheck do
			if correctConstantCheck[i].value == 3 then
				correctConstant = parkConstant[i].address
				break
			end
		end
	end

	local toSet = {}
	local lockSuccess = false

	local offsetsToSetTo0 = { 0x330, 0x338, 0x340, 0x360, 0x368, 0x370 }
	for i = 1, #warcards_all do
		for j = 1, #offsetsToSetTo0 do
			table.insert(toSet, {
				address = warcards_all[i].address + offsetsToSetTo0[j],
				flags = gg.TYPE_QWORD,
				value = 0,
			})
		end
	end

	if correctConstant then
		local toGetPointers = {
			{ address = correctConstant + 0x328, flags = gg.TYPE_QWORD },
			{ address = correctConstant + 0x330, flags = gg.TYPE_QWORD },
			{ address = correctConstant + 0x330, flags = gg.TYPE_QWORD },
		}
		local correctPointers = gg.getValues(toGetPointers)
		for i = 1, #warcards_all do
			for j = 1, #correctPointers do
				table.insert(toSet, {
					address = warcards_all[i].address + 0x300 + ((j - 1) * 8),
					flags = gg.TYPE_QWORD,
					value = correctPointers[j].value,
				})
			end
		end
		lockSuccess = true
	else
		gg.alert("Could not find the pointer to lock card count. Only the free upgrade cost will be applied.")
	end

	gg.setValues(toSet)
	gg.setVisible(true)

	if lockSuccess then
		gg.toast("✅ Done! Free upgrades and card count locked.")
	else
		gg.toast("✅ Done! Only free upgrades were applied.")
	end
end

local bulldozerState = {
	isInitialized = false,
	isOn = false,
	originalValues = {},
}

function findAllPossibleNotes(
	initialValue,
	validationValue,
	validationOffset,
	noteOffset,
	scanStartOffset,
	targetScanValue,
	scanSteps,
	stepSize
)
	local foundMatches = {}
	gg.clearResults()
	gg.setVisible(false)
	gg.setRanges(gg.REGION_ANONYMOUS | gg.REGION_C_ALLOC | gg.REGION_OTHER)
	gg.searchNumber(initialValue, gg.TYPE_DWORD)
	gg.setVisible(false)
	local initialResults = gg.getResults(gg.getResultsCount())
	if #initialResults == 0 then
		return foundMatches
	end

	for _, result in ipairs(initialResults) do
		local validationAddress = result.address + validationOffset
		local validationResult = gg.getValues({ { address = validationAddress, flags = gg.TYPE_DWORD } })[1]
		if validationResult and validationResult.value == validationValue then
			local noteAddress = validationAddress + noteOffset
			local notedValueResult = gg.getValues({ { address = noteAddress, flags = gg.TYPE_DWORD } })[1]
			if notedValueResult then
				local scanStartAddress = result.address + scanStartOffset
				local addressesToScan = {}
				for i = 0, scanSteps - 1 do
					table.insert(
						addressesToScan,
						{ address = scanStartAddress + (i * stepSize), flags = gg.TYPE_DWORD }
					)
				end
				local scannedValues = gg.getValues(addressesToScan)
				for _, scannedResult in ipairs(scannedValues) do
					if scannedResult.value == targetScanValue then
						table.insert(foundMatches, {
							initialAddress = result.address,
							finalResult = scannedResult,
							notedValue = notedValueResult.value,
						})
					end
				end
			end
		end
	end
	return foundMatches
end

function initializeBulldozer()
	local validationValue = 3
	local validationOffset = -0x48
	local noteOffset = -0x8
	local scanStartOffset = 0x1EC
	local scanSteps = 1000
	local stepSize = 4

	gg.setRanges(gg.REGION_ANONYMOUS | gg.REGION_C_ALLOC | gg.REGION_OTHER)

	local all_results1 = findAllPossibleNotes(
		-1672104106,
		validationValue,
		validationOffset,
		noteOffset,
		scanStartOffset,
		65793,
		scanSteps,
		stepSize
	)
	if #all_results1 == 0 then
		gg.alert("Phase 1: Target 1 not found.")
		return false
	end

	local all_results2 = findAllPossibleNotes(
		1625696017,
		validationValue,
		validationOffset,
		noteOffset,
		scanStartOffset,
		257,
		scanSteps,
		stepSize
	)
	if #all_results2 == 0 then
		gg.alert("Phase 1: Target 1 found, but Target 2 not.")
		return false
	end

	local commonOffset, valueToSearch
	for _, r1 in ipairs(all_results1) do
		for _, r2 in ipairs(all_results2) do
			local offset1 = r1.finalResult.address - r1.initialAddress
			local offset2 = r2.finalResult.address - r2.initialAddress
			if offset1 == offset2 then
				commonOffset = offset1
				valueToSearch = r1.notedValue
				break
			end
		end
		if commonOffset then
			break
		end
	end

	if not commonOffset then
		gg.alert("Phase 1: Error! No common offset found between targets.")
		return false
	end

	local constOffset = 0x50
	gg.clearResults()
	gg.setVisible(false)
	gg.searchNumber(valueToSearch, gg.TYPE_DWORD)
	gg.setVisible(false)
	local keyResults = gg.getResults(gg.getResultsCount())
	if #keyResults == 0 then
		gg.alert("Phase 2: No results found for the noted value.")
		return false
	end
	gg.clearResults()
	gg.clearList()

	local addressesToCache = {}
	local protectedConstant = -1165637235
	local constantToIgnore = 1672104106

	local constantAddressesToRead = {}
	for _, keyResult in ipairs(keyResults) do
		table.insert(constantAddressesToRead, { address = keyResult.address + constOffset, flags = gg.TYPE_DWORD })
	end

	if #constantAddressesToRead > 0 then
		local constantValues = gg.getValues(constantAddressesToRead)

		for i, keyResult in ipairs(keyResults) do
			local constantValue = constantValues[i].value
			if constantValue and constantValue ~= protectedConstant and constantValue ~= constantToIgnore then
				local constantAddress = keyResult.address + constOffset
				local finalAddress = constantAddress + commonOffset
				table.insert(addressesToCache, { address = finalAddress, flags = gg.TYPE_DWORD })
			end
		end
	end

	if #addressesToCache > 0 then
		bulldozerState.originalValues = gg.getValues(addressesToCache)
		bulldozerState.isInitialized = true
		return true
	end

	gg.alert("Phase 2: No valid targets found after filtering.")
	return false
end

function storesupgrade()
	local buildings = {
		{ "Building Supplies Store", { 960415804, 105664760, 105664761, 105472916 } },
		{ "Hardware Store", { -187177827, -690676295, -690676294, -690676293 } },
		{ "Farmer's Market", { 2030607321, -1853924491, -1853924490, -1853924489 } },
		{ "Furniture Store", { 1444038310, -1684984030, -1684984029, -1684984028 } },
		{ "Gardening Supplies", { -1603072541, -1221457601, -1221457600, -1221457599 } },
		{ "Donut Shop", { 271162441, -516045339, -516045338, -516045337 } },
		{ "Fashion Store", { -1470979549, -134466177, -134466176, -134466175 } },
		{ "Fast Food Restaurant", { -1568621139, -92005175, -92005174, -92005173 } },
		{ "Home Appliances", { -278168705, 2135220571, 2135220572, 2135220573 } },
		{ "Eco Shop", { 1367458934, -643982606, -643982605, -643982604 } },
		{ "Car Parts", { 369596261, 2142059393, 2142059394, 2142481395 } },
		{ "Tropical Products Store", { 1740962423, 178101587, 178101588, 178101589 } },
		{ "Fish Market Place", { -463325288, 1067438804, 1067438805, 1067438806 } },
		{ "Silk Store", { -1466974139, 2074032225, 2074032226, 2074032227 } },
		{ "Sports Shop", { 363909911, -344837645, -344837644, -344837643 } },
		{ "Country Store", { -627015643, -1662620607, -1662620606, -1662620605 } },
		{ "Bureau of Restauration", { -1176066318, -1816970258, -1816970257, -1816970256 } },
		{ "Toy Shop", { -2091925481, 1581645555, 1581645556, 1581645557 } },
		{ "Dessert Shop", { 1271296665, 1021229621, 1021229622, 1021229623 } },
	}

	local tierOptions = {
		"Max Stores From Level 0",
		"Max Stores From Level I",
		"Max Stores From Level II",
		"🔙 Back",
	}

	while true do
		local tierChoice = gg.choice(tierOptions, nil, "📦 Select the base level:")
		if tierChoice == nil then
			gg.setVisible(false)
			while not gg.isVisible() do
				gg.sleep(100)
			end
		elseif tierChoice == 4 then
			return
		else
			local fromIndex = tierChoice

			local storeNames = { "🔙 Back" }
			for i = 1, #buildings do
				table.insert(storeNames, buildings[i][1])
			end

			while true do
				local selected =
					gg.multiChoice(storeNames, nil, "🏪 Select stores to max from Level " .. (fromIndex - 1))
				if selected == nil then
					gg.setVisible(false)
					while not gg.isVisible() do
						gg.sleep(100)
					end
				elseif selected[1] then
					break
				else
					gg.setVisible(false)
					gg.setRanges(gg.REGION_C_ALLOC | gg.REGION_OTHER)
					gg.clearResults()

					for i = 2, #storeNames do
						if selected[i] then
							local name, tiers = buildings[i - 1][1], buildings[i - 1][2]
							local from = tiers[fromIndex]
							local to = tiers[4]

							gg.searchNumber(from, gg.TYPE_DWORD)
							if gg.getResultCount() > 0 then
								local results = gg.getResults(100)
								for j = 1, #results do
									results[j].value = to
								end
								gg.setValues(results)
							end
							gg.clearResults()
						end
					end

					gg.toast("✅ Done! Now visit Daniel's city and return to yours.")
					break
				end
			end
		end
	end
end

local cache = {
	factorySlots = nil,
	factoryOriginals = nil,
	expansionGroups = nil,
	warItems = nil,
	expansionCertificates = nil,
	combinedTokens = nil,
	masterList = nil,
	constantMap = nil,
	masterListFactoryItems = nil,
	fallbackUsed = false,
	omegaItems = nil,
	slotInfo3 = nil,
	slotInfo11 = nil,
	lastOperationWas11Slots = false,
}

local masterListConstants = {
	[1] = 267176888,
	[2] = 2090874750,
	[3] = -1270634091,
	[4] = 274276185,
	[5] = -1369888960,
	[6] = 1570439054,
	[7] = 144394935,
	[8] = 1807545838,
	[9] = 260292831,
	[10] = 1658060491,
	[11] = -181617693,
	[12] = 268207452,
	[13] = 351941774,
	[14] = -188562685,
	[15] = -164698239,
	[16] = 2090296690,
	[17] = 270579361,
	[18] = 26243455,
	[19] = -297136870,
	[20] = 465115894,
	[21] = 1799827558,
	[22] = 256959164,
	[23] = 182451793,
	[24] = -1970978713,
	[25] = -2127979990,
	[26] = 1447646651,
	[27] = -161427822,
	[28] = 255768525,
	[29] = 2090108855,
	[30] = 2090156119,
	[31] = -161567233,
	[32] = 495471776,
	[33] = 1228123200,
	[34] = 255678199,
	[35] = 334762709,
	[36] = 260508453,
	[37] = -788997290,
	[38] = 1125663546,
	[39] = -1398164872,
	[40] = 566656095,
	[41] = 1818945505,
	[42] = -113650078,
	[43] = 1593061790,
	[44] = 123794044,
	[45] = -466890509,
	[46] = -325591165,
	[47] = -153089811,
	[48] = 1534432269,
	[49] = 274394919,
	[50] = -1018293267,
	[51] = -1408194775,
	[52] = 108385717,
	[53] = -719795061,
	[54] = 270885747,
	[55] = -1799384545,
	[56] = -712060721,
	[57] = -265079577,
	[58] = -1136019226,
	[59] = 5863855,
	[60] = 298050001,
	[61] = 1943086388,
	[62] = -1494660480,
	[63] = 1171629674,
	[64] = -2135434832,
	[65] = -2135434831,
	[66] = -2135434830,
	[67] = -852364093,
	[68] = -852364092,
	[69] = -852364091,
	[70] = 527492590,
	[71] = 527492591,
	[72] = 527492592,
	[73] = -1480795913,
	[74] = 1553334434,
	[75] = -2118495682,
	[76] = 1886510007,
	[77] = 953030492,
	[78] = -1964329030,
	[79] = -1290152913,
	[80] = -75965445,
	[81] = -760220352,
	[82] = 248304484,
	[83] = -1740539876,
	[84] = 449644219,
	[85] = 2090257423,
	[86] = 1939782264,
	[87] = 1148007126,
	[88] = 1321484032,
	[89] = 2090724376,
	[90] = 479440892,
	[91] = 193491386,
	[92] = 2090694637,
	[93] = 2090767284,
	[94] = 614594674,
	[95] = -2000852277,
	[96] = -942334081,
	[97] = 1661902171,
	[98] = 2062064496,
	[99] = 1156262088,
	[100] = 1846238891,
	[101] = 518625563,
	[102] = -1683538769,
	[103] = 880024505,
	[104] = 1754918885,
	[105] = -313937296,
	[106] = -1423167883,
	[107] = -1153640785,
	[108] = 636979469,
	[109] = -1937678477,
	[110] = 1990081263,
	[111] = -1057013087,
	[112] = -422625305,
	[113] = 367764140,
	[114] = 856126755,
	[115] = 501522350,
	[116] = 367767594,
	[117] = -1128736189,
	[118] = 254483049,
	[119] = 748950963,
	[120] = 1618544967,
	[121] = -1385976118,
	[122] = -1544477773,
	[123] = 2090437138,
	[124] = -197041447,
	[125] = -747030696,
	[126] = 758095603,
	[127] = -1012709557,
	[128] = 1568337616,
	[129] = 267517973,
	[130] = -1676475650,
}

function findInitialFactorySlots()
	if cache.slotInfo3 then
		return true
	end

	gg.toast("🏭 Finding and backing up the first 3 factory slots...")
	gg.setVisible(false)

	local ids_to_search = { -1501685376, -1477359097, -389414878 }
	local slotAddresses, slotListItems = {}, {}

	gg.setRanges(gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS | gg.REGION_OTHER)
	for _, id in ipairs(ids_to_search) do
		gg.clearResults()
		gg.searchNumber(id, gg.TYPE_DWORD)
		if gg.getResultsCount() > 0 then
			local addr = gg.getResults(1)[1].address + 0x1C
			table.insert(slotAddresses, addr)
			table.insert(slotListItems, { address = addr, flags = gg.TYPE_QWORD })
		else
			gg.alert("❌ Failed to find initial factory slot for ID: " .. id)
			return false
		end
	end

	local originalValues = gg.getValues(slotListItems)
	cache.slotInfo3 = { addresses = slotAddresses, originals = originalValues }
	cache.factorySlots = slotListItems

	gg.toast("✅ Backup of 3 slots complete.")
	return true
end

function findMasterList()
	if cache.masterList and cache.constantMap then
		return true
	end

	local MAX_LIST_LENGTH = 170
	local requiredConstants = {}
	local requiredCount = 0

	for _, constant in pairs(masterListConstants) do
		requiredConstants[constant] = true
		requiredCount = requiredCount + 1
	end

	gg.toast("Finding Master Item List...")
	gg.setVisible(false)
	gg.setRanges(gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS | gg.REGION_OTHER)
	gg.clearResults()
	gg.searchNumber(masterListConstants[1], gg.TYPE_DWORD)

	if gg.getResultsCount() == 0 then
		gg.alert("❌ Master List: Initial constant not found.")
		return false
	end

	local initialResults = gg.getResults(gg.getResultsCount())
	local toCheck = {}

	for _, res in ipairs(initialResults) do
		local ptrAddr = res.address - 0x8
		table.insert(toCheck, { address = ptrAddr, flags = gg.TYPE_QWORD })
	end

	local pointers = gg.getValues(toCheck)
	local validationQword = 7598807827128218224
	local toValidate = {}

	for i, ptr in ipairs(pointers) do
		if ptr.value ~= 0 then
			table.insert(toValidate, { address = ptr.value, flags = gg.TYPE_QWORD, original_index = i })
		end
	end

	if #toValidate == 0 then
		gg.alert("❌ Master List: No valid pointers to validate.")
		return false
	end

	local validationValues = gg.getValues(toValidate)
	local sourceAddr = nil

	for j = 1, #validationValues do
		local val = validationValues[j]
		if val.value == validationQword then
			local original_index = toValidate[j].original_index
			local originalConstantAddress = initialResults[original_index].address
			sourceAddr = originalConstantAddress - 0x50
			break
		end
	end

	if not sourceAddr then
		gg.alert("❌ Master List: Anchor QWORD validation failed.")
		return false
	end

	gg.clearResults()
	gg.searchNumber(string.format("%Xh", sourceAddr), gg.TYPE_QWORD)

	if gg.getResultsCount() == 0 then
		gg.alert("❌ Master List: Pointer Search returned no results.")
		return false
	end

	local pointerSearchResults = gg.getResults(gg.getResultsCount())

	for _, candidate in ipairs(pointerSearchResults) do
		local potentialListStart = candidate.address

		local pointersToRead = {}
		for i = 0, MAX_LIST_LENGTH - 1 do
			table.insert(pointersToRead, { address = potentialListStart + (i * 8), flags = gg.TYPE_QWORD })
		end

		local itemPointers = gg.getValues(pointersToRead)
		local constantsToRead = {}
		local allPointersValid = true

		for _, ptr in ipairs(itemPointers) do
			if not ptr or not ptr.value or ptr.value == 0 then
				break
			end
			table.insert(constantsToRead, { address = ptr.value + 0x50, flags = gg.TYPE_DWORD })
		end

		if #constantsToRead == 0 then
			goto next_candidate
		end

		local constantsFromMemory = gg.getValues(constantsToRead)

		local currentChecklist = {}
		for k, v in pairs(requiredConstants) do
			currentChecklist[k] = true
		end
		local foundCount = 0
		local finalConstantMap = {}

		for i = 1, #constantsFromMemory do
			local constant = constantsFromMemory[i].value
			if constant and currentChecklist[constant] then
				foundCount = foundCount + 1
				currentChecklist[constant] = nil

				local pointerInfo = itemPointers[i]
				finalConstantMap[constant] = pointerInfo
			end
		end

		if foundCount == requiredCount then
			gg.toast("💾 Master List found and cached.")

			cache.masterList = itemPointers
			cache.constantMap = finalConstantMap

			gg.setVisible(true)
			gg.clearList()
			gg.clearResults()
			return true
		end

		::next_candidate::
	end

	gg.alert("❌ Master List: No candidate from Pointer Search passed the final validation.")
	gg.setVisible(true)
	gg.clearList()
	gg.clearResults()
	return false
end

function revertFactory()
	local backupValues, backupAddresses, count

	if cache.slotInfo11 then
		backupValues = cache.slotInfo11.originals
		backupAddresses = cache.slotInfo11.addresses
		count = 11
	elseif cache.slotInfo3 then
		backupValues = cache.slotInfo3.originals
		backupAddresses = cache.slotInfo3.addresses
		count = 3
	else
		gg.alert("⚠️ No factory backup found to revert.")
		return false
	end

	gg.toast("♻️ Reverting " .. count .. " factory slots...")
	local valuesToRevert = {}
	for i = 1, #backupValues do
		table.insert(valuesToRevert, {
			address = backupAddresses[i],
			value = backupValues[i].value,
			flags = gg.TYPE_QWORD,
		})
	end
	gg.setValues(valuesToRevert)
	gg.toast("✅ Slots reverted successfully.")
	return true
end

function findCombinedSpeedUpTokens()
	if cache.combinedTokens then
		return true
	end
	gg.toast(" searching for all Speed-Up Token sources...")
	gg.setVisible(false)
	gg.setRanges(gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS | gg.REGION_OTHER)
	gg.clearResults()
	gg.searchNumber("1768742839", gg.TYPE_DWORD)
	local initialResults = gg.getResults(gg.getResultsCount())
	if #initialResults == 0 then
		gg.alert("❌ Tokens: Initial value not found.")
		return false
	end
	local validStage1Results = {}
	for _, r1 in ipairs(initialResults) do
		local ptrA_addr = r1.address - 0x8
		local ptrA_target = gg.getValues({ { address = ptrA_addr, flags = gg.TYPE_QWORD } })[1]
		if ptrA_target and ptrA_target.value ~= 0 then
			local valA_addr = ptrA_target.value + 0x8
			local valA_val = gg.getValues({ { address = valA_addr, flags = gg.TYPE_QWORD } })[1]
			if valA_val and valA_val.value == 7088517870907581281 then
				table.insert(validStage1Results, r1)
			end
		end
	end
	if #validStage1Results == 0 then
		gg.alert("❌ Tokens: First validation failed.")
		return false
	end
	local storeTokens, factoryTokens = {}, {}
	for _, r1_valid in ipairs(validStage1Results) do
		local ptrSearchSource_addr = r1_valid.address - 0x50
		gg.setVisible(false)
		gg.setRanges(gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS | gg.REGION_OTHER)
		gg.clearResults()
		gg.searchNumber(string.format("%Xh", ptrSearchSource_addr), gg.TYPE_QWORD)
		local pointerResults = gg.getResults(gg.getResultsCount())
		for _, r2 in ipairs(pointerResults) do
			local ptrB_addr = r2.address - 0x8
			local ptrB_target = gg.getValues({ { address = ptrB_addr, flags = gg.TYPE_QWORD } })[1]
			if ptrB_target and ptrB_target.value ~= 0 then
				local valB_addr = ptrB_target.value + 0x50
				local valB_val = gg.getValues({ { address = valB_addr, flags = gg.TYPE_DWORD } })[1]
				if valB_val and valB_val.value == -1247906808 then
					local ptrC_addr = ptrB_addr - 0x8
					local ptrC_target = gg.getValues({ { address = ptrC_addr, flags = gg.TYPE_QWORD } })[1]
					if ptrC_target and ptrC_target.value ~= 0 then
						local valC_addr = ptrC_target.value + 0x50
						local valC_val = gg.getValues({ { address = valC_addr, flags = gg.TYPE_DWORD } })[1]
						if valC_val and valC_val.value == -1247906874 then
							table.insert(
								factoryTokens,
								{ address = ptrB_addr, flags = gg.TYPE_QWORD, name = "Factory Token 1" }
							)
							table.insert(
								factoryTokens,
								{ address = ptrC_addr, flags = gg.TYPE_QWORD, name = "Factory Token 2" }
							)
							table.insert(
								factoryTokens,
								{ address = ptrB_addr + 0x8, flags = gg.TYPE_QWORD, name = "Factory Token 3" }
							)
							table.insert(
								storeTokens,
								{ address = ptrB_addr - 0x18, flags = gg.TYPE_QWORD, name = "Store Token 1" }
							)
							table.insert(
								storeTokens,
								{ address = ptrC_addr - 0x18, flags = gg.TYPE_QWORD, name = "Store Token 2" }
							)
							table.insert(
								storeTokens,
								{ address = ptrB_addr + 0x8 - 0x18, flags = gg.TYPE_QWORD, name = "Store Token 3" }
							)
							goto found_all_tokens
						end
					end
				end
			end
		end
	end
	::found_all_tokens::
	if #storeTokens == 3 and #factoryTokens == 3 then
		cache.combinedTokens = { store = storeTokens, factory = factoryTokens }
		gg.toast("💾 All Speed-Up Tokens found and cached.")
		return true
	else
		gg.alert("❌ Tokens: Validation chain failed. No pointers found.")
		return false
	end
end

function findExpansionCertificates()
	if cache.expansionCertificates then
		return true
	end
	gg.toast("Finding Expansion Certificate sources...")
	gg.setVisible(false)
	gg.setRanges(gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS | gg.REGION_OTHER)
	gg.clearResults()
	gg.searchNumber("222012102", gg.TYPE_DWORD)
	local initialResults = gg.getResults(gg.getResultsCount())
	if #initialResults == 0 then
		gg.alert("❌ Initial certificate value not found.")
		return false
	end
	local candidatePointers = {}
	for _, result in ipairs(initialResults) do
		local ptrAddr = result.address - 0x8
		local ptrVal = gg.getValues({ { address = ptrAddr, flags = gg.TYPE_QWORD } })[1]
		if ptrVal and ptrVal.value ~= 0 then
			local valAddr = ptrVal.value + 0xC
			local valVal = gg.getValues({ { address = valAddr, flags = gg.TYPE_QWORD } })[1]
			if valVal and valVal.value == 7022359169637113716 then
				local searchSrcAddr = result.address - 0x50
				gg.setVisible(false)
				gg.setRanges(gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS | gg.REGION_OTHER)
				gg.clearResults()
				gg.searchNumber(string.format("%Xh", searchSrcAddr), gg.TYPE_QWORD)
				for _, p in ipairs(gg.getResults(gg.getResultsCount())) do
					table.insert(candidatePointers, p)
				end
			end
		end
	end
	if #candidatePointers == 0 then
		gg.alert("❌ No candidate pointers found.")
		return false
	end
	local certificateSources = {}
	for _, p in ipairs(candidatePointers) do
		local pStore1 = p.address - 0x8
		local pTarget1 = gg.getValues({ { address = pStore1, flags = gg.TYPE_QWORD } })[1]
		if pTarget1 and pTarget1.value ~= 0 then
			local valAddr1 = pTarget1.value + 0x50
			local valVal1 = gg.getValues({ { address = valAddr1, flags = gg.TYPE_DWORD } })[1]
			if valVal1 and valVal1.value == -869378290 then
				local pStore2 = pStore1 - 0x8
				local pTarget2 = gg.getValues({ { address = pStore2, flags = gg.TYPE_QWORD } })[1]
				if pTarget2 and pTarget2.value ~= 0 then
					local valAddr2 = pTarget2.value + 0x50
					local valVal2 = gg.getValues({ { address = valAddr2, flags = gg.TYPE_DWORD } })[1]
					if valVal2 and valVal2.value == 1925954004 then
						table.insert(
							certificateSources,
							{ address = p.address, flags = gg.TYPE_QWORD, name = "Cert Source 1" }
						)
						table.insert(
							certificateSources,
							{ address = pStore1, flags = gg.TYPE_QWORD, name = "Cert Source 2" }
						)
						table.insert(
							certificateSources,
							{ address = pStore2, flags = gg.TYPE_QWORD, name = "Cert Source 3" }
						)
						break
					end
				end
			end
		end
	end
	if #certificateSources ~= 3 then
		gg.alert("❌ Could not validate and find all 3 Certificate sources.")
		return false
	end
	cache.expansionCertificates = certificateSources
	gg.toast("💾 Certificate sources found and cached.")
	return true
end

function findExpansionItems()
	if cache.expansionGroups then
		return true
	end

	local ANCHOR_VALIDATOR = -520565565
	local VALIDATOR_OFFSET_FROM_POINTER_TARGET = 0x50

	local validator_to_item_map = {
		[13285930] = { name = "Final Placeholder" },
		[21080992] = { name = "Init 1" },
		[543978041] = { name = "Init 2" },
		[1206566498] = { name = "Init 3" },
		[12777566] = { name = "Init 4" },
		[-1227768711] = { name = "Init 5" },
		[-520565565] = { name = "Vu Battery" },
		[-2038227] = { name = "Vu Remote" },
		[112710515] = { name = "Vu Glove" },
		[265268177] = { name = "Beach 1" },
		[265268178] = { name = "Beach 2" },
		[265268179] = { name = "Beach 3" },
		[745632329] = { name = "Extra 1" },
		[745632330] = { name = "Extra 2" },
		[745632331] = { name = "Extra 3" },
	}

	gg.setVisible(false)
	gg.setRanges(gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS | gg.REGION_OTHER)

	gg.clearResults()
	gg.searchNumber(tostring(ANCHOR_VALIDATOR), gg.TYPE_DWORD)
	local initial_results = gg.getResults(gg.getResultsCount())
	if #initial_results == 0 then
		gg.alert("FAILURE (Step 1): Anchor validator ('Vu Battery') was not found.")
		gg.setVisible(true)
		return false
	end

	local search_key_qword = nil
	for _, res in ipairs(initial_results) do
		local check_val = gg.getValues({ { address = res.address - 0x48, flags = gg.TYPE_DWORD } })[1]
		if check_val and check_val.value == 25 then
			local key_val = gg.getValues({ { address = res.address - 0x50, flags = gg.TYPE_QWORD } })[1]
			if key_val and key_val.value ~= 0 then
				search_key_qword = key_val.value
				break
			end
		end
	end

	if not search_key_qword then
		gg.alert("FAILURE (Step 2): No anchor passed validation.")
		gg.setVisible(true)
		return false
	end

	gg.clearResults()
	gg.searchNumber(tostring(search_key_qword), gg.TYPE_QWORD)
	local item_structures = gg.getResults(gg.getResultsCount())

	if #item_structures ~= 15 then
		gg.alert(string.format("FAILURE (Step 3): Expected 15 structures, but search returned %d.", #item_structures))
		gg.setVisible(true)
		return false
	end

	local checklist = {}
	for validator, _ in pairs(validator_to_item_map) do
		checklist[validator] = true
	end

	local identified_items = {}
	for _, structure in ipairs(item_structures) do
		local validator_addr = structure.address + VALIDATOR_OFFSET_FROM_POINTER_TARGET
		local result = gg.getValues({ { address = validator_addr, flags = gg.TYPE_DWORD } })[1]

		if result and result.value then
			local validator_from_memory = result.value
			if checklist[validator_from_memory] then
				local item_data = validator_to_item_map[validator_from_memory]
				table.insert(identified_items, {
					name = item_data.name,
					factory_value = structure.address,
				})
				checklist[validator_from_memory] = nil
			end
		end
	end

	if next(checklist) ~= nil then
		local missing_items_str = ""
		for validator, _ in pairs(checklist) do
			local item_name = validator_to_item_map[validator].name
			missing_items_str = missing_items_str .. "\n- " .. item_name .. " (Validator: " .. validator .. ")"
		end
		gg.alert(
			string.format(
				"FAILURE (Step 4): Could not find all 15 unique items.\n\nFound %d of 15.\n\nMissing items:%s",
				#identified_items,
				missing_items_str
			)
		)
		gg.setVisible(true)
		return false
	end

	local groups = {
		["🏢 Capital Expansion Items"] = {},
		["🏖️ Beach Expansion Items"] = {},
		["⛰️ Mountain Expansion Items"] = {},
		["📂 Storage Expansion Items"] = {},
		["👹 Vu Items"] = {},
	}
	for _, item in ipairs(identified_items) do
		local group_item = { name = item.name, value = item.factory_value, flags = gg.TYPE_QWORD }
		if item.name == "Final Placeholder" or item.name == "Init 1" or item.name == "Init 2" then
			table.insert(groups["📂 Storage Expansion Items"], group_item)
		elseif item.name == "Init 3" or item.name == "Init 4" or item.name == "Init 5" then
			table.insert(groups["🏢 Capital Expansion Items"], group_item)
		elseif string.find(item.name, "Vu") then
			table.insert(groups["👹 Vu Items"], group_item)
		elseif string.find(item.name, "Beach") then
			table.insert(groups["🏖️ Beach Expansion Items"], group_item)
		elseif string.find(item.name, "Extra") then
			table.insert(groups["⛰️ Mountain Expansion Items"], group_item)
		end
	end
	for name, list in pairs(groups) do
		table.sort(list, function(a, b)
			return a.name < b.name
		end)
	end

	cache.expansionGroups = groups
	gg.toast("✅ Expansion items found and cached successfully.")
	gg.setVisible(true)
	gg.clearList()
	gg.clearResults()
	return true
end

function findWarItems()
	if cache.warItems then
		return true
	end

	local ANCHOR_VALIDATOR = 1560176023
	local VALIDATOR_OFFSET_FROM_POINTER_TARGET = 0x50
	local CHECK_VALUE = 52

	local validator_to_item_map = {
		[1560176023] = { name = "Binoculars" },
		[253271711] = { name = "Anvil" },
		[860715237] = { name = "FireHydrant" },
		[-916988905] = { name = "Gasoline" },
		[-1540742631] = { name = "Megaphone" },
		[-1962827238] = { name = "Propeller" },
		[352219700] = { name = "Pliers" },
		[226338627] = { name = "Medkit" },
		[-1607480754] = { name = "Boots" },
		[471968558] = { name = "Duck" },
		[-1247109630] = { name = "Plunger" },
		[2090081903] = { name = "Ammo" },
	}

	gg.setVisible(false)
	gg.setRanges(gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS | gg.REGION_OTHER)

	gg.clearResults()
	gg.searchNumber(tostring(ANCHOR_VALIDATOR), gg.TYPE_DWORD)
	local initial_results = gg.getResults(gg.getResultsCount())
	if #initial_results == 0 then
		gg.alert("FAILURE (Step 1): Anchor validator ('Binoculars') was not found.")
		gg.setVisible(true)
		return false
	end

	local search_key_qword = nil
	for _, res in ipairs(initial_results) do
		local check_val = gg.getValues({ { address = res.address - 0x48, flags = gg.TYPE_DWORD } })[1]
		if check_val and check_val.value == CHECK_VALUE then
			local key_val = gg.getValues({ { address = res.address - 0x50, flags = gg.TYPE_QWORD } })[1]
			if key_val and key_val.value ~= 0 then
				search_key_qword = key_val.value
				break
			end
		end
	end

	if not search_key_qword then
		gg.alert("FAILURE (Step 2): No anchor passed validation.")
		gg.setVisible(true)
		return false
	end

	gg.clearResults()
	gg.searchNumber(tostring(search_key_qword), gg.TYPE_QWORD)
	local item_structures = gg.getResults(gg.getResultsCount())

	if #item_structures ~= 12 then
		gg.alert(
			string.format(
				"FAILURE (Step 3): Expected 12 War Item structures, but search returned %d.",
				#item_structures
			)
		)
		gg.setVisible(true)
		return false
	end

	local checklist = {}
	for validator, _ in pairs(validator_to_item_map) do
		checklist[validator] = true
	end

	local identified_items = {}
	for _, structure in ipairs(item_structures) do
		local validator_addr = structure.address + VALIDATOR_OFFSET_FROM_POINTER_TARGET
		local result = gg.getValues({ { address = validator_addr, flags = gg.TYPE_DWORD } })[1]

		if result and result.value then
			local validator_from_memory = result.value
			if checklist[validator_from_memory] then
				local item_data = validator_to_item_map[validator_from_memory]
				table.insert(identified_items, {
					name = item_data.name,
					factory_value = structure.address,
				})
				checklist[validator_from_memory] = nil
			end
		end
	end

	if next(checklist) ~= nil then
		local missing_items_str = ""
		for validator, _ in pairs(checklist) do
			local item_name = validator_to_item_map[validator].name
			missing_items_str = missing_items_str .. "\n- " .. item_name .. " (Validator: " .. validator .. ")"
		end
		gg.alert(
			string.format(
				"FAILURE (Step 4): Could not find all 12 unique War Items.\n\nFound %d of 12.\n\nMissing items:%s",
				#identified_items,
				missing_items_str
			)
		)
		gg.setVisible(true)
		return false
	end

	local foundItemsMap = {}
	for _, item in ipairs(identified_items) do
		foundItemsMap[item.name] = { name = item.name, value = item.factory_value, flags = gg.TYPE_QWORD }
	end

	cache.warItems = foundItemsMap
	gg.toast("✅ War Items found and cached successfully.")
	gg.setVisible(true)
	gg.clearList()
	gg.clearResults()
	return true
end

function executeChange(itemsToApply)
	if not itemsToApply or #itemsToApply == 0 then
		gg.alert("⚠️ Items not found in memory.\nThis can happen after a game update. The operation was cancelled.")
		return
	end

	if not findInitialFactorySlots() then
		return
	end
	revertFactory()

	local numItemsToApply = #itemsToApply
	local numSlotsAvailable = #cache.slotInfo3.addresses
	if numItemsToApply > numSlotsAvailable then
		gg.alert(
			string.format(
				"⚠️ Warning: Found %d items but only have %d factory slots available. Applying only the first %d items.",
				numItemsToApply,
				numSlotsAvailable,
				numSlotsAvailable
			)
		)
		numItemsToApply = numSlotsAvailable
	end

	local valuesToWrite = {}
	for i = 1, numItemsToApply do
		local currentValue = itemsToApply[i]
		local targetAddress = cache.slotInfo3.addresses[i]

		if currentValue and currentValue.value and targetAddress then
			table.insert(valuesToWrite, { address = targetAddress, value = currentValue.value, flags = gg.TYPE_QWORD })
		end
	end

	if #valuesToWrite > 0 then
		gg.setValues(valuesToWrite)
		gg.toast("✅ Applied " .. #valuesToWrite .. " items!")
	else
		gg.alert("❌ No valid items could be prepared for writing.")
		revertFactory()
	end
end

function showWarPresets()
	if not findWarItems() then
		return
	end

	local attacks = {
		{
			"💢 All items (no Ammo)",
			{
				"FireHydrant",
				"Anvil",
				"Binoculars",
				"Megaphone",
				"Pliers",
				"Propeller",
				"Plunger",
				"Duck",
				"Boots",
				"Gasoline",
				"Medkit",
			},
		},
		{ "💥 Comic Hand", { "Plunger", "Duck" } },
		{ "✨ Shrink Ray", { "Pliers", "Megaphone" } },
		{ "🗿 Giant Rock Monster", { "FireHydrant", "Binoculars" } },
		{ "🌪️ Not in Kansas", { "Anvil", "Propeller" } },
		{ "?? Magnetism", { "Binoculars", "FireHydrant", "Anvil" } },
		{ "🐙 Tentacle Vortex", { "Plunger", "Duck", "Propeller" } },
		{ "🤖 Flying Vu Robot", { "Ammo", "Gasoline" } },
		{ "🕺 Disco Twister", { "Megaphone", "Pliers", "Propeller" } },
		{ "🌱 Plant Monster", { "Plunger", "Gasoline", "Boots" } },
		{ "🥶 Blizzaster", { "Propeller", "Ammo", "Duck" } },
		{ "🐟 Fishaster", { "Duck", "Boots", "FireHydrant" } },
		{ "👻 Ancient Curse", { "Boots", "Megaphone", "Binoculars" } },
		{ "👊 Hands of Doom", { "Ammo", "Duck", "Pliers" } },
		{ "🏋️ 16 Tons", { "Pliers", "FireHydrant", "Anvil" } },
		{ "🕷️ Spiders", { "Gasoline", "Binoculars", "Ammo" } },
		{ "👟 Dance Shoes", { "Gasoline", "Binoculars", "Boots" } },
		{ "🏢 Building Portal", { "FireHydrant", "Plunger", "Propeller" } },
		{ "🦖 B Movie Monster", { "Boots", "Plunger", "Megaphone" } },
		{ "?? Hissy Fit", { "Binoculars", "Pliers", "Boots" } },
		{ "📢 Mellow Bellow", { "Megaphone", "Pliers", "Propeller" } },
		{ "🦆 Doomsday Quack", { "Duck" } },
		{ "⚡ Electric Deity", { "Megaphone", "Gasoline", "Anvil" } },
		{ "🛡️ Shield Buster", { "Gasoline", "Medkit" } },
		{ "👽 Zest from Above", { "Binoculars", "Anvil", "Ammo" } },
	}

	while true do
		local menuNames = { "🔙 Back" }
		for _, attackData in ipairs(attacks) do
			table.insert(menuNames, attackData[1])
		end
		local choice = gg.choice(menuNames, nil, "⚔️ Select a War Attack Preset:")

		if not choice then
			gg.setVisible(false)
			while not gg.isVisible() do
				gg.sleep(100)
			end
		elseif choice == 1 then
			return
		else
			if not findInitialFactorySlots() then
				goto next_choice
			end
			revertFactory()

			local selectedAttack = attacks[choice - 1]
			local isAllItemsOperation = (selectedAttack[1] == "💢 All items (no Ammo)")

			if isAllItemsOperation then
				if not cache.slotInfo11 or #cache.slotInfo11.addresses < 11 then
					gg.toast("Finding remaining 8 factory slots...")
					local remaining_ids = {
						-331876130,
						-777869928,
						809598022,
						-545412710,
						-2052593169,
						-254286722,
						-610175295,
						-585905379,
					}
					local newAddresses, newListItems = {}, {}
					gg.setVisible(false)
					gg.setRanges(gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS | gg.REGION_OTHER)
					for _, id in ipairs(remaining_ids) do
						gg.clearResults()
						gg.searchNumber(id, gg.TYPE_DWORD)
						if gg.getResultsCount() > 0 then
							local addr = gg.getResults(1)[1].address + 0x1C
							table.insert(newAddresses, addr)
							table.insert(newListItems, { address = addr, flags = gg.TYPE_QWORD })
						else
							gg.alert("❌ Failed to find slot for ID: " .. id .. ". Cannot apply 'All items' preset.")
							goto next_choice
						end
					end

					local newOriginalValues = gg.getValues(newListItems)
					local combinedAddresses = {}
					for _, addr in ipairs(cache.slotInfo3.addresses) do
						table.insert(combinedAddresses, addr)
					end
					for _, addr in ipairs(newAddresses) do
						table.insert(combinedAddresses, addr)
					end

					local combinedOriginals = {}
					for _, val in ipairs(cache.slotInfo3.originals) do
						table.insert(combinedOriginals, val)
					end
					for _, val in ipairs(newOriginalValues) do
						table.insert(combinedOriginals, val)
					end

					cache.slotInfo11 = { addresses = combinedAddresses, originals = combinedOriginals }
					gg.toast("✅ Backup of all 11 slots is complete.")
				end

				local itemsToApply = {}
				for _, itemName in ipairs(selectedAttack[2]) do
					table.insert(itemsToApply, cache.warItems[itemName])
				end

				local valuesToWrite = {}
				for i = 1, #itemsToApply do
					local currentItem = itemsToApply[i]
					local targetAddress = cache.slotInfo11.addresses[i]

					if currentItem and targetAddress then
						table.insert(
							valuesToWrite,
							{ address = targetAddress, value = currentItem.value, flags = gg.TYPE_QWORD }
						)
					else
						gg.alert(
							string.format(
								"Error applying 'All items'. Missing item or factory slot for index %d. Aborting.",
								i
							)
						)
						goto next_choice
					end
				end

				if #valuesToWrite > 0 then
					gg.setValues(valuesToWrite)
					gg.toast("✅ Applied " .. #valuesToWrite .. " items!")
				end
			else
				local itemsToApply = {}
				if selectedAttack[1] == "🦆 Doomsday Quack" then
					if not findMasterList() then
						goto next_choice
					end
					table.insert(itemsToApply, cache.warItems["Duck"])
					table.insert(itemsToApply, gg.getValues({ cache.constantMap[masterListConstants[42]] })[1])
				else
					for _, itemName in ipairs(selectedAttack[2]) do
						table.insert(itemsToApply, cache.warItems[itemName])
					end
				end

				local valuesToWrite = {}
				for i = 1, #itemsToApply do
					local currentItem = itemsToApply[i]
					local targetAddress = cache.slotInfo3.addresses[i]

					if currentItem and targetAddress then
						table.insert(
							valuesToWrite,
							{ address = targetAddress, value = currentItem.value, flags = gg.TYPE_QWORD }
						)
					else
						gg.alert(
							string.format(
								"Error applying preset. Missing item or factory slot for index %d. Aborting.",
								i
							)
						)
						goto next_choice
					end
				end

				if #valuesToWrite > 0 then
					gg.setValues(valuesToWrite)
					gg.toast("✅ Applied " .. #valuesToWrite .. " items!")
				end
			end
		end
		::next_choice::
	end
end

function runMasterListItems(groupIndex)
	local groups = {
		[1] = { masterListConstants[64], masterListConstants[65], masterListConstants[66] },
		[2] = { masterListConstants[67], masterListConstants[68], masterListConstants[69] },
		[3] = { masterListConstants[70], masterListConstants[71], masterListConstants[72] },
	}
	if not findMasterList() then
		return
	end
	local itemsToApply = {}
	local requiredConstants = groups[groupIndex]
	local itemsToRead = {}
	for _, constant in ipairs(requiredConstants) do
		local itemPointer = cache.constantMap[constant]
		if itemPointer then
			table.insert(itemsToRead, itemPointer)
		else
			gg.alert(string.format("❌ Error: Master List item for constant %d not found.", constant))
			return
		end
	end
	itemsToApply = gg.getValues(itemsToRead)
	executeChange(itemsToApply)
end

function findOmegaItems()
	if cache.omegaItems then
		return true
	end

	local ANCHOR_VALIDATOR = -1540641695
	local VALIDATOR_OFFSET_FROM_POINTER_TARGET = 0x50
	local CHECK_VALUE = 40

	local validator_to_item_map = {
		[-1540641695] = { name = "4D Printer" },
		[1940876015] = { name = "Holoprojector" },
		[-1307054383] = { name = "Hoverboard" },
		[1430745728] = { name = "Robopet" },
		[-661139406] = { name = "Telepod" },
		[638948574] = { name = "Antigravity Boots" },
		[-1847614967] = { name = "Solar Panels" },
		[-681051257] = { name = "Jet Pack" },
		[-477356184] = { name = "Cryofusion Chamber" },
		[-805181992] = { name = "Ultrawave Oven" },
	}

	gg.setVisible(false)
	gg.setRanges(gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS | gg.REGION_OTHER)

	gg.clearResults()
	gg.searchNumber(tostring(ANCHOR_VALIDATOR), gg.TYPE_DWORD)
	local initial_results = gg.getResults(gg.getResultsCount())
	if #initial_results == 0 then
		gg.alert("FAILURE (Step 1): Anchor validator ('4D Printer') was not found.")
		gg.setVisible(true)
		return false
	end

	local search_key_qword = nil
	for _, res in ipairs(initial_results) do
		local check_val = gg.getValues({ { address = res.address - 0x48, flags = gg.TYPE_DWORD } })[1]
		if check_val and check_val.value == CHECK_VALUE then
			local key_val = gg.getValues({ { address = res.address - 0x50, flags = gg.TYPE_QWORD } })[1]
			if key_val and key_val.value ~= 0 then
				search_key_qword = key_val.value
				break
			end
		end
	end

	if not search_key_qword then
		gg.alert("FAILURE (Step 2): No anchor passed validation.")
		gg.setVisible(true)
		return false
	end

	gg.clearResults()
	gg.searchNumber(tostring(search_key_qword), gg.TYPE_QWORD)
	local item_structures = gg.getResults(gg.getResultsCount())

	if #item_structures ~= 10 then
		gg.alert(
			string.format(
				"FAILURE (Step 3): Expected 10 Omega Item structures, but search returned %d.",
				#item_structures
			)
		)
		gg.setVisible(true)
		return false
	end

	local checklist = {}
	for validator, _ in pairs(validator_to_item_map) do
		checklist[validator] = true
	end

	local identified_items = {}
	for _, structure in ipairs(item_structures) do
		local validator_addr = structure.address + VALIDATOR_OFFSET_FROM_POINTER_TARGET
		local result = gg.getValues({ { address = validator_addr, flags = gg.TYPE_DWORD } })[1]

		if result and result.value then
			local validator_from_memory = result.value
			if checklist[validator_from_memory] then
				table.insert(identified_items, {
					name = validator_to_item_map[validator_from_memory].name,
					value = structure.address,
					flags = gg.TYPE_QWORD,
				})
				checklist[validator_from_memory] = nil
			end
		end
	end

	if next(checklist) ~= nil then
		local missing_items_str = ""
		for validator, _ in pairs(checklist) do
			local item_name = validator_to_item_map[validator].name
			missing_items_str = missing_items_str .. "\n- " .. item_name .. " (Validator: " .. validator .. ")"
		end
		gg.alert(
			string.format(
				"FAILURE (Step 4): Could not find all 10 unique Omega Items.\n\nFound %d of 10.\n\nMissing items:%s",
				#identified_items,
				missing_items_str
			)
		)
		gg.setVisible(true)
		return false
	end

	cache.omegaItems = identified_items
	gg.toast("✅ Omega Items found and cached successfully.")
	gg.setVisible(true)
	gg.clearList()
	gg.clearResults()
	return true
end

function showOmegaItemsMenu()
	if not findOmegaItems() then
		return true
	end

	local omegaItemMap = {}
	for _, item in ipairs(cache.omegaItems) do
		omegaItemMap[item.name] = item
	end

	while true do
		local choice = gg.choice({
			"🔙 Back",
			"⚜️ 4D Printer, Holoprojector, Hoverboard",
			"⚜️ Robopet, Telepod, Antigravity Boots",
			"⚜️ Solar Panels, Jet Pack, Cryofusion Chamber",
			"⚜️ Ultrawave Oven",
		}, nil, "🌌 Omega Items Menu")

		if not choice then
			gg.setVisible(false)
			while not gg.isVisible() do
				gg.sleep(100)
			end
		elseif choice == 1 then
			return
		else
			local itemsToApply = {}
			local itemNames
			if choice == 2 then
				itemNames = { "4D Printer", "Holoprojector", "Hoverboard" }
			elseif choice == 3 then
				itemNames = { "Robopet", "Telepod", "Antigravity Boots" }
			elseif choice == 4 then
				itemNames = { "Solar Panels", "Jet Pack", "Cryofusion Chamber" }
			elseif choice == 5 then
				itemNames = { "Ultrawave Oven" }
			end

			if itemNames then
				for _, name in ipairs(itemNames) do
					if omegaItemMap[name] then
						table.insert(itemsToApply, omegaItemMap[name])
					else
						gg.alert("Error: Omega item '" .. name .. "' not found in cache.")
						itemsToApply = nil
						break
					end
				end
			end

			if itemsToApply and #itemsToApply > 0 then
				executeChange(itemsToApply)
			end
		end
	end
end

function showTrainItemsMenu()
	if not findMasterList() then
		gg.alert("Master List needs to be found first.")
		return
	end

	while true do
		local choice = gg.choice({
			"🔙 Back",
			"🚂 Bolts, Conductor Hat, Vintage Lantern",
			"🚂 Pickaxe",
		}, nil, "?? Train Items")

		if not choice then
			gg.setVisible(false)
			while not gg.isVisible() do
				gg.sleep(100)
			end
		elseif choice == 1 then
			return
		else
			local itemsToApply = {}
			local requiredConstants = {}

			if choice == 2 then
				requiredConstants = { masterListConstants[118], masterListConstants[119], masterListConstants[120] }
			elseif choice == 3 then
				requiredConstants = { masterListConstants[121] }
			end

			local itemsToRead = {}
			local allItemsFound = true
			for _, constant in ipairs(requiredConstants) do
				local itemPointer = cache.constantMap[constant]
				if itemPointer then
					table.insert(itemsToRead, itemPointer)
				else
					gg.alert(string.format("❌ Error: Master List item for constant %d not found.", constant))
					allItemsFound = false
					break
				end
			end

			if allItemsFound then
				itemsToApply = gg.getValues(itemsToRead)
				executeChange(itemsToApply)
			end
		end
	end
end

function itemToolMenu()
	while true do
		local menuOptionsList = {
			"🔙 Back",
			"♻️ Revert Factory",
			"⚔️ War Items Presets",
			"🏢 Capital Expansion Items",
			"🏖️ Beach Expansion Items",
			"⛰️ Mountain Expansion Items",
			"📂 Storage Expansion Items",
			"👹 Vu Items",
			"🌌 Omega Items",
			"🗾 Tokyo Items",
			"🥖 Paris Items",
			"🎡 London Items",
			"🚂 Train Items",
			"📜 Expansion Certificates",
			"⏱️ Store Speed-Up Tokens",
			"🏭 Factory Speed-Up Tokens",
		}

		local choiceIndex = gg.choice(menuOptionsList, nil, "🛠️ Item Tool Menu")

		if not choiceIndex then
			gg.setVisible(false)
			while not gg.isVisible() do
				gg.sleep(100)
			end
		elseif choiceIndex == 1 then
			return
		elseif choiceIndex == 2 then
			revertFactory()
		elseif choiceIndex == 3 then
			showWarPresets()
		elseif choiceIndex >= 4 and choiceIndex <= 8 then
			local groupKeyMap = {
				[4] = "🏢 Capital Expansion Items",
				[5] = "🏖️ Beach Expansion Items",
				[6] = "⛰️ Mountain Expansion Items",
				[7] = "📂 Storage Expansion Items",
				[8] = "👹 Vu Items",
			}
			if findExpansionItems() then
				local itemsToApply = cache.expansionGroups[groupKeyMap[choiceIndex]]
				if itemsToApply and #itemsToApply > 0 then
					executeChange(itemsToApply)
				else
					gg.alert("Error: Could not retrieve items for this group.")
				end
			end
		elseif choiceIndex == 9 then
			showOmegaItemsMenu()
		elseif choiceIndex == 10 then
			runMasterListItems(1)
		elseif choiceIndex == 11 then
			runMasterListItems(2)
		elseif choiceIndex == 12 then
			runMasterListItems(3)
		elseif choiceIndex == 13 then
			showTrainItemsMenu()
		elseif choiceIndex == 14 then
			if findExpansionCertificates() then
				local itemsToApply = gg.getValues(cache.expansionCertificates)
				if itemsToApply then
					executeChange(itemsToApply)
				else
					gg.alert("Error: Could not read certificate data from memory.")
				end
			end
		elseif choiceIndex == 15 then
			if findCombinedSpeedUpTokens() then
				local itemsToApply = gg.getValues(cache.combinedTokens.store)
				if itemsToApply then
					executeChange(itemsToApply)
				else
					gg.alert("Error: Could not read store token data from memory.")
				end
			end
		elseif choiceIndex == 16 then
			if findCombinedSpeedUpTokens() then
				local itemsToApply = gg.getValues(cache.combinedTokens.factory)
				if itemsToApply then
					executeChange(itemsToApply)
				else
					gg.alert("Error: Could not read factory token data from memory.")
				end
			end
		end
	end
end

function freezeVuPass()
	gg.setVisible(false)
	gg.clearResults()
	gg.clearList()
	gg.setRanges(gg.REGION_ANONYMOUS | gg.REGION_C_ALLOC | gg.REGION_OTHER)

	gg.searchNumber("8319099934827697938", gg.TYPE_QWORD)
	local results = gg.getResults(9999)
	local baseList = {}
	for _, r in ipairs(results) do
		local ptrAddr = r.address + 0x18
		local ptrVal = gg.getValues({ { address = ptrAddr, flags = gg.TYPE_QWORD } })[1].value
		local val180 = gg.getValues({ { address = ptrVal + 0x180, flags = gg.TYPE_DWORD } })[1]
		if val180.value == 1145656354 then
			table.insert(baseList, val180.address)
		end
	end

	local editsZero = {}
	local readsCopy = {}

	for _, addr in ipairs(baseList) do
		table.insert(editsZero, { address = addr + 0x28, flags = gg.TYPE_QWORD, value = 0 })
		table.insert(readsCopy, { address = addr + 0x30, flags = gg.TYPE_QWORD })
	end

	if #editsZero > 0 then
		gg.setValues(editsZero)
	end

	if #readsCopy > 0 then
		local sourceValues = gg.getValues(readsCopy)
		local targetsFreeze = {}

		for _, item in ipairs(sourceValues) do
			local targetAddr = item.address + 0x8

			table.insert(targetsFreeze, {
				address = targetAddr,
				flags = gg.TYPE_QWORD,
				value = item.value,
				freeze = true,
				name = "Vu Frozen",
			})
		end

		gg.addListItems(targetsFreeze)
		gg.setValues(targetsFreeze)
	end

	gg.setVisible(false)
	gg.clearResults()
	gg.toast("Done")
end

function freezeMayorPass()
	gg.setVisible(false)
	gg.clearResults()
	gg.clearList()
	gg.setRanges(gg.REGION_ANONYMOUS | gg.REGION_C_ALLOC | gg.REGION_OTHER)

	gg.searchNumber("6157391977344036723", gg.TYPE_QWORD)
	local results = gg.getResults(gg.getResultsCount())

	if #results == 0 then
		return
	end

	local editsZero = {}
	local readsCopy = {}

	for _, r in ipairs(results) do
		local pointerLoc = r.address - 0x54
		local pointerVal = gg.getValues({ { address = pointerLoc, flags = gg.TYPE_QWORD } })[1].value

		if pointerVal ~= 0 then
			local base = pointerVal + 0x168

			table.insert(editsZero, { address = base + 0x40, flags = gg.TYPE_QWORD, value = 0 })
			table.insert(readsCopy, { address = base + 0x48, flags = gg.TYPE_QWORD })
		end
	end

	if #editsZero > 0 then
		gg.setValues(editsZero)
	end

	if #readsCopy > 0 then
		local sourceValues = gg.getValues(readsCopy)
		local targetsFreeze = {}

		for _, item in ipairs(sourceValues) do
			local targetAddr = item.address + 0x8

			table.insert(targetsFreeze, {
				address = targetAddr,
				flags = gg.TYPE_QWORD,
				value = item.value,
				freeze = true,
				name = "Mayor Frozen",
			})
		end

		gg.addListItems(targetsFreeze)
		gg.setValues(targetsFreeze)
	end

	gg.setVisible(false)
	gg.clearResults()
	gg.toast("Done")
end

function unlockVuPassBasic()
	gg.setVisible(false)
	gg.clearResults()
	gg.clearList()
	gg.setRanges(gg.REGION_ANONYMOUS | gg.REGION_C_ALLOC | gg.REGION_OTHER)

	gg.searchNumber("8319099934827697938", gg.TYPE_QWORD)
	local results = gg.getResults(9999)
	local baseList = {}
	for _, r in ipairs(results) do
		local ptrAddr = r.address + 0x18
		local ptrVal = gg.getValues({ { address = ptrAddr, flags = gg.TYPE_QWORD } })[1].value
		local val180 = gg.getValues({ { address = ptrVal + 0x180, flags = gg.TYPE_DWORD } })[1]
		if val180.value == 1145656354 then
			table.insert(baseList, val180.address)
		end
	end

	local finalList = {}
	local offsets = { 0x20, 0x24, 0x28, 0x2C, 0x30, 0x38, 0x40 }
	for _, addr in ipairs(baseList) do
		for _, off in ipairs(offsets) do
			table.insert(finalList, { address = addr + off, flags = gg.TYPE_DWORD, value = 0 })
		end
	end

	gg.setValues(finalList)
	gg.setVisible(false)
	gg.clearResults()
	gg.clearList()
	gg.toast("Sucess!")
end

function unlockMayorPassBasic()
	gg.setVisible(false)
	gg.clearResults()
	gg.clearList()
	gg.setRanges(gg.REGION_ANONYMOUS | gg.REGION_C_ALLOC | gg.REGION_OTHER)

	gg.searchNumber("6157391977344036723", gg.TYPE_QWORD)
	local results = gg.getResults(gg.getResultsCount())

	if #results == 0 then
		return
	end

	local finalResults = {}
	local offsets = { 0x38, 0x3C, 0x40, 0x44, 0x48, 0x50, 0x58 }

	for _, r in ipairs(results) do
		local pointerLoc = r.address - 0x54
		local readPointer = gg.getValues({ { address = pointerLoc, flags = gg.TYPE_QWORD } })

		if readPointer and readPointer[1].value ~= 0 then
			local structureAddress = readPointer[1].value
			local finalBase = structureAddress + 0x168

			for _, off in ipairs(offsets) do
				table.insert(finalResults, {
					address = finalBase + off,
					flags = gg.TYPE_DWORD,
					value = 0,
				})
			end
		end
	end

	if #finalResults > 0 then
		gg.setValues(finalResults)
		gg.toast("Sucess!")
	end

	gg.setVisible(false)
	gg.clearResults()
	gg.clearList()
end

local math = require("math")
local os = require("os")
local string = string

math.randomseed(os.time())

function shuffle(t)
	local n = #t
	while n > 1 do
		local k = math.random(n)
		t[n], t[k] = t[k], t[n]
		n = n - 1
	end
	return t
end

local allNewItems = {
	{ c = "4788000848756688662;7233174017949197671;1684104562;0;0;0;0" },
	{ c = "495958578184;115;0;0;0;0;0" },
	{ c = "7813543538904094750;8746382355283789939;8241996694932251753;1918989395;0;0;0" },
	{ c = "7809649008806808848;495739564645;115;0;0;0;0" },
	{ c = "32487744146788364;7564142;0;0;0;0;0" },
	{ c = "32495419253080844;7565929;0;0;0;0;0" },
	{ c = "7017568562947048210;126909327567213;29548;0;0;0;0" },
	{ c = "431366297352;100;0;0;0;0;0" },
	{ c = "126909461646858;29548;0;0;0;0;0" },
	{ c = "126939392919306;29555;0;0;0;0;0" },
	{ c = "435761727240;101;0;0;0;0;0" },
	{ c = "7598263491579626792;4858365177624687715;8030038460241568099;8389754680828259695;495874631022;115;0" },
	{ c = "7296522342584436248;7307497706036032617;495622648434;115;0;0;0" },
	{ c = "5074538002687869204;28258983318675821;6579557;0;0;0;0" },
	{ c = "32199629200247820;7497060;0;0;0;0;0" },
	{ c = "30510856834405132;7103862;0;0;0;0;0" },
	{ c = "126875035063050;29540;0;0;0;0;0" },
	{ c = "119165820423434;27745;0;0;0;0;0" },
	{ c = "119212881363978;27756;0;0;0;0;0" },
	{ c = "7089075267333084692;32481138503152741;7562604;0;0;0;0" },
	{ c = "32487697036755468;7564131;0;0;0;0;0" },
	{ c = "32772479204541196;7630437;0;0;0;0;0" },
	{ c = "7379508025304635414;8678228074668050291;2020557428;0;0;0;0" },
	{ c = "7163384721214033934;1667855475;0;0;0;0;0" },
	{ c = "7453010343496729374;7954892226976180587;8317138556340761685;1936484723;0;0;0" },
	{ c = "5941208256451269656;7308044089985034606;499917742945;116;0;0;0" },
	{ c = "7887055744160776988;7804865016518439785;32772462006530913;7630433;0;0;0" },
	{ c = "7008289818848019986;126887850570357;29543;0;0;0;0" },
	{ c = "32199668005947404;7497069;0;0;0;0;0" },
	{ c = "8093938717988049686;8315161591516721761;1936024425;0;0;0;0" },
	{ c = "1851868678;0;0;0;0;0;0" },
	{ c = "7742373195317069838;1802661734;0;0;0;0;0" },
	{ c = "7008578917374182162;111524752619876;25966;0;0;0;0" },
	{ c = "128017563209738;29806;0;0;0;0;0" },
	{ c = "435443159560;101;0;0;0;0;0" },
	{ c = "7308332244272501776;495622842740;115;0;0;0" },
	{ c = "7379508025304635410;126943771576179;29556;0;0;0;0" },
	{ c = "7598264659743165722;7013344243635877235;111533343663982;25968;0;0;0" },
	{ c = "8675433051803568152;7308332244272501861;495622842740;115;0;0;0" },
	{ c = "7233183901389507614;8389997634057760367;8315171534434943589;1936026740;0;0;0" },
	{ c = "120265081242378;28001;0;0;0;0;0" },
	{ c = "8386069061883091214;1952533857;0;0;0;0;0" },
	{ c = "4862043108376331040;8315163785492525682;7737574922178094440;435593241445;101;0;0" },
	{ c = "8315173686197174810;7599071701579951721;126943822697331;29556;0;0;0" },
	{ c = "7956018208487066652;8320773490242843752;30792323289404263;7169396;0;0;0" },
	{ c = "8314045578593260308;32481168853134439;7562611;0;0;0;0" },
	{ c = "114776381276938;26723;0;0;0;0;0" },
	{ c = "5075105312183240478;7597135469438985572;7310034288021238389;1701999988;0;0;0" },
	{ c = "126879497999114;29541;0;0;0;0;0" },
	{ c = "7809911852332569110;7449308262025027955;1734427237;0;0;0;0" },
	{ c = "5147162906221168408;7308620289727685988;495622909806;115;0;0;0" },
	{ c = "8318822956683051534;1936876903;0;0;0;0;0" },
	{ c = "32481138503144460;7562604;0;0;0;0;0" },
	{ c = "5291289089347111964;8245933057424387940;14200692808839277;3306356;0;0;0" },
	{ c = "7877761554973869850;7526763401609178725;111503398432623;25961;0;0;0" },
	{ c = "5657604;0;0;0;0;0;0" },
	{ c = "7023204680992378138;8525144178751401842;121382055667062;28261;0;0;0" },
	{ c = "474366296840;110;0;0;0;0;0" },
	{ c = "5072587434632954646;8315168226537730917;1936025970;0;0;0;0" },
	{ c = "7161128489026929168;461228830827;107;0;0;0;0" },
	{ c = "8097845299947656216;7453010347807560549;495656528236;115;0;0;0" },
	{ c = "107178667626506;24954;0;0;0;0;0" },
	{ c = "7308308050336372752;431198327667;100;0;0;0;0" },
	{ c = "5291289089347111964;8245933057424387940;14482167785549933;3371892;0;0;0" },
	{ c = "8021584255776866834;119212979938401;27756;0;0;0;0" },
	{ c = "32497670034506764;7566453;0;0;0;0;0" },
	{ c = "6444199693343933976;8247612020538369402;500136503151;116;0;0;0" },
	{ c = "7874946788094066970;8390891584405204577;54371944656752;12659;0;0;0" },
	{ c = "7308325668325249564;7089024685470147449;27981962692085348;6515058;0;0;0" },
	{ c = "28540463127413516;6645094;0;0;0;0;0" },
	{ c = "7958545964395876366;1852993379;0;0;0;0;0" },
	{ c = "28555851977999116;6648677;0;0;0;0;0" },
	{ c = "7306924860497023512;8031151179463879026;491496169842;114;0;0;0" },
	{ c = "7018141228116166944;7953730146163585603;7163387955541791597;448344455012;104;0;0" },
	{ c = "7874946788094066970;8390891584405204577;55471456284528;12915;0;0;0" },
	{ c = "7874952320161763354;8390891584405205865;54371944656752;12659;0;0;0" },
	{ c = "7811900816721330704;465675317863;108;0;0;0;0" },
	{ c = "439787799048;102;0;0;0;0;0" },
	{ c = "5291289089347111964;8245933057424387940;13919217832128621;3240820;0;0;0" },
	{ c = "8388324177595680270;1953058917;0;0;0;0;0" },
	{ c = "7310001298243147796;29401359240550259;6845537;0;0;0;0" },
	{ c = "7874952320161763354;8390891584405205865;56570967912304;13171;0;0;0" },
	{ c = "126939393312522;29555;0;0;0;0;0" },
	{ c = "7812726597537386256;495740281202;115;0;0;0;0" },
	{ c = "7309175427805955344;495623039059;115;0;0;0" },
	{ c = "8606182549772913682;125780121046382;29285;0;0;0;0" },
	{ c = "8241991261648929552;431415717730;100;0;0;0;0" },
	{ c = "7874952320161763354;8390891584405205865;55471456284528;12915;0;0;0" },
	{ c = "7874946788094066970;8390891584405204577;56570967912304;13171;0;0;0" },
	{ c = "7165037287190648848;461229740915;107;0;0;0;0" },
	{ c = "7588409720162962704;465623282287;108;0;0;0;0" },
	{ c = "126943872631306;29556;0;0;0;0;0" },
	{ c = "7017568576000381978;7598210753608509808;118121959670892;27502;0;0;0" },
	{ c = "7957667471751204890;7089040091669024871;111516181419111;25964;0;0;0" },
	{ c = "448612877832;104;0;0;0;0;0" },
	{ c = "4788000831392666390;8319396935306995043;1937010543;0;0;0;0" },
	{ c = "7310020956592882446;1701996884;0;0;0;0;0" },
	{ c = "7008573441409435154;111511867716713;25963;0;0;0;0" },
	{ c = "461380342536;107;0;0;0;0;0" },
	{ c = "7010527286372876560;469783700844;109;0;0;0;0" },
	{ c = "7311701108893241358;1702388075;0;0;0;0;0" },
	{ c = "29113321772045068;6778473;0;0;0;0;0" },
	{ c = "7296527818381677586;125762636249444;29281;0;0;0;0" },
	{ c = "7234309775326204696;8314045440985493097;495857003591;115;0;0;0" },
	{ c = "8388068060056147734;7957704726398134133;1852797513;0;0;0;0" },
	{ c = "8317992872698200846;1936683634;0;0;0;0;0" },
	{ c = "7306916073128416796;8389750136584495476;31088027508826444;7238245;0;0;0" },
	{ c = "8316298452215092240;504447462753;117;0;0;0;0" },
	{ c = "6297269738370319124;28270021669315958;6582127;0;0;0;0" },
	{ c = "7308327841679557402;8031135726171874675;111524990702436;25966;0;0;0" },
	{ c = "7956001767487066132;32195085293151604;7496002;0;0;0;0" },
	{ c = "7588395379284132624;465623278948;108;0;0;0;0" },
	{ c = "4788000904691665944;7738151095514588532;495722917740;115;0;0;0" },
	{ c = "4932414051745551126;7741240748992066674;1802398066;0;0;0;0" },
	{ c = "8386676005303960344;7009978643021788516;499848344175;116;0;0;0" },
	{ c = "8391734905363448596;30515087461936751;7104847;0;0;0;0" },
	{ c = "7310583983806500886;7308338832434555238;1701605234;0;0;0;0" },
	{ c = "7308338836880179982;1701605235;0;0;0;0;0" },
	{ c = "5072290605298696980;29400293567653230;6845289;0;0;0" },
	{ c = "4783783152032763928;7308061681901594990;499917747041;116;0;0;0" },
	{ c = "7020108392025309976;7441465509824720739;444114232692;103;0;0;0" },
	{ c = "28550371633677580;6647401;0;0;0;0;0" },
	{ c = "7020108392025309976;7008275520667021155;491258013044;114;0;0;0" },
	{ c = "8462073932930434576;483006567272;112;0;0;0;0" },
	{ c = "7309979247913813522;120265081242469;28001;0;0;0;0" },
	{ c = "8391734905363448590;1953853039;0;0;0;0;0" },
	{ c = "4788000904674624792;7308061681902577012;499917747041;116;0;0;0" },
	{ c = "7296527852875631124;32490986911463788;7564897;0;0;0;0" },
	{ c = "6011865068346626844;8603122552475119469;29382702203694689;6841193;0;0;0" },
	{ c = "435744754440;101;0;0;0;0;0" },
	{ c = "7595412496751482642;128034743538540;29810;0;0;0;0" },
	{ c = "8247343697136538640;521611277157;121;0;0;0;0" },
	{ c = "8234662935179248150;8315175850840909391;1936027745;0;0;0;0" },
	{ c = "7022923180564107278;1635151724;0;0;0;0;0" },
	{ c = "115897065753866;26984;0;0;0;0;0" },
}

function applyRandomItems(slots)
	local randomItems = shuffle(allNewItems)
	local randomCount = #randomItems

	revertSlotChanges(slots)
	gg.sleep(100)
	local writes = {}

	for i, s in ipairs(slots) do
		local itemIndex = ((i - 1) % randomCount) + 1
		local selectedItem = randomItems[itemIndex]

		local ptrAddr = s.header - 0x10
		local ptrVal = gg.getValues({ { address = ptrAddr, flags = gg.TYPE_QWORD } })[1].value

		if ptrVal ~= 0 and selectedItem then
			local codeStr = selectedItem.c
			codeStr = string.gsub(codeStr, ",", "")
			local vals = {}
			for v in string.gmatch(codeStr, "([^;]+)") do
				table.insert(vals, tonumber(v))
			end

			for k, v in ipairs(vals) do
				local addr = ptrVal + ((k - 1) * 4)
				table.insert(writes, { address = addr, flags = gg.TYPE_QWORD, value = v })
			end
		end
	end

	if #writes > 0 then
		gg.setValues(writes)
		gg.toast("✅ " .. #slots .. " Random Slots Filled!")
	else
		gg.toast("❌ Error accessing pointers during Random Refresh")
	end
end

local itemCategories = {
	["capital"] = {
		name = "🏢 Capital Expansion Items",
		items = {
			{
				c = "7089070916666278952;5142940815661822064;8243124913282442604;7954884637952931439;500068347246;116;0",
			},
			{ c = "7089070916666278950;4998825627585966192;7017581717894423916;7957695015157986660;1852795252;0;0" },
			{ c = "7089070916666278942;5791459162003173488;8316866899155576172;1936421473;0;0;0" },
		},
	},
	["beach"] = {
		name = "🏖️ Beach Expansion Items",
		items = {
			{ c = "7089070916666278946;4782652845472182384;7521962890171999596;54083979534693;12592;0;0" },
			{ c = "7089070916666278946;4782652845472182384;7521962890171999596;55183491162469;12848;0;0" },
			{ c = "7089070916666278946;4782652845472182384;7521962890171999596;56283002790245;13104;0;0" },
		},
	},
	["mountain"] = {
		name = "⛰️ Mountain Expansion Items",
		items = {
			{ c = "7089070916666278952;5575286379889389680;8389772276737729900;3489842628544853359;211265939809;49;0" },
			{ c = "7089070916666278952;5575286379889389680;8389772276737729900;3489842628544853359;215560907105;50;0" },
			{ c = "7089070916666278952;5575286379889389680;8389772276737729900;3489842628544853359;219855874401;51;0" },
		},
	},
	["storage"] = {
		name = "📂 Storage Expansion Items",
		items = {
			{ c = "7089070916666278944;6007631944116957296;7449366535721674092;435526137701;101;0;0" },
			{ c = "7089070916666278942;5791459162003173488;8243126012945065324;1919252335;0;0;0" },
			{ c = "7089070916666278942;6295862320268669040;8243122654398080364;1919251553;0;0;0" },
		},
	},
	["vu"] = {
		name = "👹 Vu Items",
		items = {
			{ c = "7089070916666278940;5070883221623894128;28554769125565804;6648425;0;0;0" },
			{ c = "7089070916666278944;5214998409699750000;8389187293518194028;448629858661;104;0;0" },
			{ c = "7089070916666278942;4854710439510110320;7308613709769696620;1701669234;0;0;0" },
		},
	},
	["tokyo"] = {
		name = "🗾 Tokyo Items",
		items = {
			{ c = "7,874,946,788,094,066,970;8,390,891,584,405,204,577;54,371,944,656,752;12,659;0;0;0" },
			{ c = "7,874,946,788,094,066,970;8,390,891,584,405,204,577;55,471,456,284,528;12,915;0;0;0" },
			{ c = "7,874,946,788,094,066,970;8,390,891,584,405,204,577;56,570,967,912,304;13,171;0;0;0" },
		},
	},
	["paris"] = {
		name = "🥖 Paris Items",
		items = {
			{ c = "7,874,952,320,161,763,354;8,390,891,584,405,205,865;54,371,944,656,752;12,659;0;0;0" },
			{ c = "7,874,952,320,161,763,354;8,390,891,584,405,205,865;55,471,456,284,528;12,915;0;0;0" },
			{ c = "7,874,952,320,161,763,354;8,390,891,584,405,205,865;56,570,967,912,304;13,171;0;0;0" },
		},
	},
	["london"] = {
		name = "🎡 London Items",
		items = {
			{ c = "5,291,289,089,347,111,964;8,245,933,057,424,387,940;13,919,217,832,128,621;3,240,820;0;0;0" },
			{ c = "5,291,289,089,347,111,964;8,245,933,057,424,387,940;14,200,692,808,839,277;3,306,356;0;0;0" },
			{ c = "5,291,289,089,347,111,964;8,245,933,057,424,387,940;14,482,167,785,549,933;3,371,892;0;0;0" },
		},
	},
	["train"] = {
		name = "🚂 Train Items",
		items = {
			{ c = "126,943,872,631,306;29,556;0;0;0;0;0" },
			{ c = "8,386,676,005,303,960,344;7,009,978,643,021,788,516;499,848,344,175;116;0;0;0" },
			{ c = "7,306,916,073,128,416,796;8,389,750,136,584,495,476;31,088,027,508,826,444;7,238,245;0;0;0" },
			{ c = "7,311,701,108,893,241,358;1,702,388,075;0;0;0;0;0" },
		},
	},
}

local menuOrder = {
	"capital",
	"beach",
	"mountain",
	"storage",
	"vu",
	"omega1",
	"omega2",
	"tokyo",
	"paris",
	"london",
	"train",
}

local menuState = {
	price = nil,
	qty = nil,
}

function revertSlotChanges(slots)
	local writes = {}
	for i, s in ipairs(slots) do
		local ptrAddr = s.header - 0x10
		local ptrVal = gg.getValues({ { address = ptrAddr, flags = gg.TYPE_QWORD } })[1].value
		if ptrVal ~= 0 and s.origPointerData then
			for k, val in ipairs(s.origPointerData) do
				local addr = ptrVal + ((k - 1) * 4)
				table.insert(writes, { address = addr, flags = gg.TYPE_QWORD, value = val })
			end
		end
	end
	if #writes > 0 then
		gg.setValues(writes)
	end
end

function applyCategory(slots, catKey)
	revertSlotChanges(slots)
	gg.sleep(100)
	local catData = itemCategories[catKey]
	local items = catData.items
	local itemCount = #items
	local writes = {}
	for i, s in ipairs(slots) do
		local ptrAddr = s.header - 0x10
		local ptrVal = gg.getValues({ { address = ptrAddr, flags = gg.TYPE_QWORD } })[1].value
		if ptrVal ~= 0 then
			local itemIndex = ((i - 1) % 3) + 1
			local codeStr = items[itemIndex].c
			codeStr = string.gsub(codeStr, ",", "")
			local vals = {}
			for v in string.gmatch(codeStr, "([^;]+)") do
				table.insert(vals, tonumber(v))
			end
			for k, v in ipairs(vals) do
				local addr = ptrVal + ((k - 1) * 4)
				table.insert(writes, { address = addr, flags = gg.TYPE_QWORD, value = v })
			end
		end
	end
	if #writes > 0 then
		gg.setValues(writes)
		gg.toast("✅ " .. catData.name .. " Applied")
	else
		gg.toast("❌ Error accessing pointers")
	end
end

function editSlotMenu(slots)
	local options = { "🔙 Back", "✨ Random Items" }
	local keys = { "random" }

	for _, k in ipairs(menuOrder) do
		if itemCategories[k] then
			table.insert(options, itemCategories[k].name)
			table.insert(keys, k)
		end
	end

	local choice = gg.choice(options, nil, "🏗️ Select Reward Type (Fixed + Random)")
	if choice == nil or choice == 1 then
		return
	end

	local selectedKey = keys[choice - 1]

	if selectedKey == "random" then
		applyRandomItems(slots)
	else
		applyCategory(slots, selectedKey)
	end
end

function mainMenu(slots)
	while true do
		local priceLabel = "💰 Edit Price"
		if menuState.price then
			priceLabel = "🟢 Edit Price = " .. menuState.price
		end
		local qtyLabel = "📦 Edit Quantity"
		if menuState.qty then
			qtyLabel = "🟢 Edit Quantity = " .. menuState.qty
		end
		local options = {
			"🔙 Back",
			priceLabel,
			qtyLabel,
			"🏗️ Edit Slot (Fixed Categories)",
			"🔄 In-game Refresh Slot",
			"♻️ Revert Slot Changes",
		}
		local choice = gg.choice(options, nil, "🚨 Main Menu (" .. #slots .. " Slots)")
		if choice == nil then
			gg.setVisible(false)
			while not gg.isVisible() do
				gg.sleep(100)
			end
		elseif choice == 1 then
			return
		elseif choice == 2 then
			if menuState.price then
				local updates = {}
				for i, s in ipairs(slots) do
					table.insert(updates, { address = s.price, flags = gg.TYPE_DWORD, value = s.origPrice })
				end
				gg.setValues(updates)
				menuState.price = nil
				gg.toast("Price Reverted")
			else
				local input = gg.prompt({ "Enter Price:" }, nil, { "number" })
				if input then
					local val = tonumber(input[1])
					local updates = {}
					for i, s in ipairs(slots) do
						table.insert(updates, { address = s.price, flags = gg.TYPE_DWORD, value = val })
					end
					gg.setValues(updates)
					menuState.price = val
					gg.toast("Price Updated")
				end
			end
		elseif choice == 3 then
			if menuState.qty then
				local updates = {}
				for i, s in ipairs(slots) do
					table.insert(updates, { address = s.qty, flags = gg.TYPE_DWORD, value = s.origQty })
				end
				gg.setValues(updates)
				menuState.qty = nil
				gg.toast("Quantity Reverted")
			else
				local input = gg.prompt({ "Enter Quantity:" }, nil, { "number" })
				if input then
					local val = tonumber(input[1])
					local proceed = true
					if val > 250 then
						local warn = gg.alert("More than 250 can cause a ban, continue anyway?", "Yes", "No")
						if warn ~= 1 then
							proceed = false
						end
					end
					if proceed then
						local updates = {}
						for i, s in ipairs(slots) do
							table.insert(updates, { address = s.qty, flags = gg.TYPE_DWORD, value = val })
						end
						gg.setValues(updates)
						menuState.qty = val
						gg.toast("Quantity Updated")
					end
				end
			end
		elseif choice == 4 then
			editSlotMenu(slots)
		elseif choice == 5 then
			local updates = {}
			for i, s in ipairs(slots) do
				table.insert(updates, { address = s.refresh, flags = gg.TYPE_QWORD, value = 0 })
			end
			gg.setValues(updates)
			gg.toast("Slots Refreshed")
		elseif choice == 6 then
			revertSlotChanges(slots)
			gg.toast("♻️ Reward Slots Reverted")
		end
	end
end

function startdaniel()
	gg.setVisible(false)
	gg.setRanges(gg.REGION_ANONYMOUS | gg.REGION_C_ALLOC | gg.REGION_OTHER)
	gg.clearResults()
	gg.searchNumber("49151", gg.TYPE_DWORD)
	local results = gg.getResults(10000)
	gg.clearResults()

	if #results == 0 then
		gg.alert("Error: 49151 not found.")
		gg.setVisible(true)
		return
	end

	local candidates = {}
	for i, v in ipairs(results) do
		candidates[#candidates + 1] = { address = v.address - 0x30, flags = gg.TYPE_DWORD }
	end

	local headers = gg.getValues(candidates)
	local validHeaders = {}
	for i, v in ipairs(headers) do
		if v.value == 100000 then
			table.insert(validHeaders, v.address)
		end
	end

	if #validHeaders == 0 then
		gg.alert("Error: No 100000 headers found.")
		gg.setVisible(true)
		return
	end

	table.sort(validHeaders)

	local sequences = {}
	local currentSeq = {}

	for i, addr in ipairs(validHeaders) do
		if #currentSeq == 0 then
			table.insert(currentSeq, addr)
		else
			local lastAddr = currentSeq[#currentSeq]
			if (addr - lastAddr) == 0x80 then
				table.insert(currentSeq, addr)
			else
				if #currentSeq > 0 then
					table.insert(sequences, currentSeq)
				end
				currentSeq = { addr }
			end
		end
	end
	if #currentSeq > 0 then
		table.insert(sequences, currentSeq)
	end

	local finalHeaders = {}
	for _, seq in ipairs(sequences) do
		if #seq > #finalHeaders then
			finalHeaders = seq
		end
	end

	validHeaders = finalHeaders

	local slots = {}
	for _, h in ipairs(validHeaders) do
		local slotData = {
			header = h,
			price = h - 0x8,
			qty = h - 0x14,
			refresh = h - 0x28,
			origPrice = 0,
			origQty = 0,
			origPointerData = {},
		}

		local pq = gg.getValues({
			{ address = slotData.price, flags = gg.TYPE_DWORD },
			{ address = slotData.qty, flags = gg.TYPE_DWORD },
		})

		if pq[1] and pq[2] then
			slotData.origPrice = pq[1].value
			slotData.origQty = pq[2].value

			local ptrAddr = slotData.header - 0x10
			local ptrValCheck = gg.getValues({ { address = ptrAddr, flags = gg.TYPE_QWORD } })

			if ptrValCheck[1] then
				local ptrVal = ptrValCheck[1].value
				if ptrVal ~= 0 then
					local rawReads = {}
					for k = 0, 6 do
						table.insert(rawReads, { address = ptrVal + (k * 4), flags = gg.TYPE_QWORD })
					end
					local rawData = gg.getValues(rawReads)
					for _, r in ipairs(rawData) do
						table.insert(slotData.origPointerData, r.value)
					end
				end
				table.insert(slots, slotData)
			end
		end
	end

	if #slots == 0 then
		gg.alert("Error: Could not construct slot objects.")
		gg.setVisible(true)
		return
	end

	gg.toast("✅ " .. #slots .. " Slots cached & ready")
	gg.setVisible(true)
	mainMenu(slots)
end

local alreadyCached = false
local quantityFrozen = false
local priceFrozen = false
local advertiseFrozen = false
local dontAdvertiseFrozen = false
local quantityValue = 0
local priceValue = 0

offset1C = nil
offset20 = nil
offset28 = nil
alreadyCached = false

quantityFrozen = false
priceFrozen = false
advertiseFrozen = false
quantityValue = 0
priceValue = 0

local offset1C, offset20, offset28

function cacheOffsets()
	if alreadyCached then
		return
	end

	gg.setVisible(false)
	gg.toast("🔍 Scanning for Items...")

	gg.clearResults()
	gg.searchNumber("8389209267074581518", gg.TYPE_QWORD)
	local results = gg.getResults(-1)

	if #results == 0 then
		gg.alert("❌ Initial value not found.")
		return
	end

	local validBaseAddress = 0
	local found = false

	for i, v in ipairs(results) do
		local check = gg.getValues({ { address = v.address + 0x38, flags = gg.TYPE_QWORD } })

		if check[1].value == 119165820423434 then
			validBaseAddress = v.address
			found = true
			break
		end
	end

	if not found then
		gg.alert("❌ Verification check failed (Offset 0x38).")
		return
	end

	gg.clearResults()
	gg.searchNumber(string.format("%Xh", validBaseAddress), gg.TYPE_QWORD)

	local pointerResults = gg.getResults(-1)
	if #pointerResults == 0 then
		gg.alert("❌ No pointers found to this object.")
		return
	end

	local pointer = pointerResults[1].address

	offset1C = { address = pointer + 0x1C, flags = gg.TYPE_DWORD }
	offset20 = { address = pointer + 0x20, flags = gg.TYPE_DWORD }
	offset28 = { address = pointer + 0x28, flags = gg.TYPE_DWORD }

	gg.addListItems({ offset1C, offset20, offset28 })

	alreadyCached = true
	gg.toast("✅ Offsets cached successfully!")
	gg.clearResults()
end

function sellingMenu()
	cacheOffsets()
	if offset1C == nil or offset20 == nil or offset28 == nil then
		gg.alert("⚠️ Offsets not available.")
		return
	end

	while true do
		local qState = quantityFrozen and string.format("(CURRENT: %d)", quantityValue) or "(OFF)"
		local pState = priceFrozen and string.format("(CURRENT: %d)", priceValue) or "(OFF)"
		local aState = advertiseFrozen and "(ON 🟢)" or "(OFF 🔴)"
		local dState = dontAdvertiseFrozen and "(ON 🟢)" or "(OFF 🔴)"

		local choice = gg.choice({
			"IMPORTANT 🚨⚠️",
			"🔙 Back",
			"📦 Quantity Freeze " .. qState,
			"💲 Price Freeze " .. pState,
			"📣 Auto Advertise " .. aState,
			"🚫 Don't Advertise Anything " .. dState,
			"♻️ Revert All",
		}, nil, "🛒 SELLING MENU")

		if choice == nil then
			gg.setVisible(false)
			while not gg.isVisible() do
				gg.sleep(100)
			end
		elseif choice == 1 then
			gg.alert([[
?? IMPORTANT WARNING 🚨

you can't edit the quantity of war-related items, even if you freeze at 5, it will show only 1.

Each item must have a minimum price of at least 1 simoleon to be visible to other players.

Example: if you freeze the quantity at 4 and the price at 0 or 3, players won't be able to see or purchase your items.

if you want to advertise price at Max, put 999999.
]])
		elseif choice == 3 then
			local input = gg.prompt({ "Enter quantity (max 5):" }, { "" }, { "number" })
			if input == nil or input[1] == "" then
				return
			end
			local q = tonumber(input[1])
			if q > 5 then
				gg.alert("❌ Impossible, this won't show up to other people.")
				return sellingMenu()
			end
			gg.setValues({ { address = offset1C.address, value = q, flags = gg.TYPE_DWORD } })
			gg.addListItems({ { address = offset1C.address, value = q, flags = gg.TYPE_DWORD, freeze = true } })
			quantityFrozen = true
			quantityValue = q
			gg.toast("📦 Quantity frozen at " .. q)
		elseif choice == 4 then
			local input = gg.prompt({ "Enter price:" }, { "" }, { "number" })
			if input == nil or input[1] == "" then
				return
			end
			local p = tonumber(input[1])
			gg.setValues({ { address = offset20.address, value = p, flags = gg.TYPE_DWORD } })
			gg.addListItems({ { address = offset20.address, value = p, flags = gg.TYPE_DWORD, freeze = true } })
			priceFrozen = true
			priceValue = p
			gg.toast("💲 Price frozen at " .. p)
		elseif choice == 5 then
			if dontAdvertiseFrozen then
				gg.alert("❌ 'Don't Advertise Anything' is active. Please disable it first.")
				return
			end
			if advertiseFrozen then
				gg.removeListItems({ { address = offset28.address, flags = gg.TYPE_DWORD } })
				gg.setValues({ { address = offset28.address, value = 0, flags = gg.TYPE_DWORD } })
				advertiseFrozen = false
				gg.toast("📣 Auto Advertise Disabled")
			else
				gg.setValues({ { address = offset28.address, value = 1, flags = gg.TYPE_DWORD } })
				gg.addListItems({ { address = offset28.address, value = 1, flags = gg.TYPE_DWORD, freeze = true } })
				advertiseFrozen = true
				gg.toast("📣 Auto Advertise Enabled")
			end
		elseif choice == 6 then
			if advertiseFrozen then
				gg.alert("❌ 'Auto Advertise' is active. Please disable it first.")
				return
			end
			if dontAdvertiseFrozen then
				gg.removeListItems({ { address = offset28.address, flags = gg.TYPE_DWORD } })
				dontAdvertiseFrozen = false
				gg.toast("🚫 'Don't Advertise Anything' Disabled")
			else
				gg.setValues({ { address = offset28.address, value = 0, flags = gg.TYPE_DWORD } })
				gg.addListItems({ { address = offset28.address, value = 0, flags = gg.TYPE_DWORD, freeze = true } })
				dontAdvertiseFrozen = true
				gg.toast("🚫 'Don't Advertise Anything' Enabled")
			end
		elseif choice == 7 then
			gg.removeListItems({
				{ address = offset1C.address, flags = gg.TYPE_DWORD },
				{ address = offset20.address, flags = gg.TYPE_DWORD },
				{ address = offset28.address, flags = gg.TYPE_DWORD },
			})
			gg.setValues({
				{ address = offset1C.address, value = 0, flags = gg.TYPE_DWORD },
				{ address = offset20.address, value = 0, flags = gg.TYPE_DWORD },
				{ address = offset28.address, value = 0, flags = gg.TYPE_DWORD },
			})
			quantityFrozen = false
			priceFrozen = false
			advertiseFrozen = false
			dontAdvertiseFrozen = false
			quantityValue = 0
			priceValue = 0
			gg.toast("♻️ All reverted.")
		elseif choice == 2 then
			return
		end
	end
end

gg.setRanges(gg.REGION_C_ALLOC | gg.REGION_OTHER | gg.REGION_ANONYMOUS)

local isInitialized = false
local buildingListStart = nil
local discoveredPointers = {}
local cachedBuildings = {}

local buildingData = {
	{
		name = "🌟 Epic Buildings",
		isEpicCategory = true,
		categories = {
			{
				name = "🎓 Education",
				tiers = {
					{ name = "🐢 Turtle", id = -1881032550 },
					{ name = "🦙 Llama", id = -1881032549 },
					{ name = "🐆 Cheetah", id = -1881032548 },
				},
			},
			{
				name = "🎰 Gambling",
				tiers = {
					{ name = "🐢 Turtle", id = -691412737 },
					{ name = "🦙 Llama", id = -691412736 },
					{ name = "?? Cheetah", id = -691412735 },
				},
			},
			{
				name = "🎪 Entertainment",
				tiers = {
					{ name = "🐢 Turtle", id = -447372292 },
					{ name = "🦙 Llama", id = -447372291 },
					{ name = "🐆 Cheetah", id = -447372290 },
				},
			},
			{
				name = "🚌 Transportation",
				tiers = {
					{ name = "🐢 Turtle", id = 1813794918 },
					{ name = "🦙 Llama", id = 1813794919 },
					{ name = "🐆 Cheetah", id = 1813794920 },
				},
			},
			{
				name = "🏛️ Landmark",
				tiers = {
					{ name = "🐢 Turtle", id = -113962680 },
					{ name = "🦙 Llama", id = -113962679 },
					{ name = "🐆 Cheetah", id = -113962678 },
				},
			},
			{
				name = "🏖️ Beach",
				tiers = {
					{ name = "🐢 Turtle", id = -1999290447 },
					{ name = "🦙 Llama", id = -1999290446 },
					{ name = "🐆 Cheetah", id = -1999290445 },
				},
			},
			{
				name = "🏔️ Mountain",
				tiers = {
					{ name = "🐢 Turtle", id = 995463177 },
					{ name = "🦙 Llama", id = 995463178 },
					{ name = "🐆 Cheetah", id = 995463179 },
				},
			},
			{
				name = "🚀 Space",
				tiers = {
					{ name = "🐢 Turtle", id = -2014094902 },
					{ name = "🦙 Llama", id = -2014094901 },
					{ name = "?? Cheetah", id = -2014094900 },
				},
			},
		},
	},
	{
		name = "🏠 Residential Zone",
		tiers = {
			{ name = "Tier 1", id = 1522778645 },
			{ name = "Tier 2", id = 1522778646 },
			{ name = "Tier 3", id = 1522778647 },
			{ name = "Tier 4", id = 1522778648 },
			{ name = "Tier 5", id = 1522778649 },
			{ name = "Tier 6", id = 1522778650 },
		},
	},
	{
		name = "🏠 Tokyo Town Zone",
		tiers = {
			{ name = "Tier 1", id = 1297585906 },
			{ name = "Tier 2", id = 1336721299 },
			{ name = "Tier 3", id = 1375856692 },
			{ name = "Tier 4", id = 1414992085 },
			{ name = "Tier 5", id = 1454127478 },
			{ name = "Tier 6", id = 1493262871 },
		},
	},
	{
		name = "🏠 Parisian Zone",
		tiers = {
			{ name = "Tier 1", id = -112185933 },
			{ name = "Tier 2", id = 1179282036 },
			{ name = "Tier 3", id = -1824217291 },
			{ name = "Tier 4", id = -532749322 },
			{ name = "Tier 5", id = 758718647 },
			{ name = "Tier 6", id = 2050186616 },
		},
	},
	{
		name = "🏠 London Zone",
		tiers = {
			{ name = "Tier 1", id = 452743614 },
			{ name = "Tier 2", id = 121513631 },
			{ name = "Tier 3", id = -209716352 },
			{ name = "Tier 4", id = -540946335 },
			{ name = "Tier 5", id = -872176318 },
			{ name = "Tier 6", id = -1203406301 },
		},
	},
	{
		name = "🏠 Green Valley Zone",
		tiers = {
			{ name = "Tier 1", id = 1162567438 },
			{ name = "Tier 2", id = 1983822959 },
			{ name = "Tier 3", id = -1489888816 },
			{ name = "Tier 4", id = -668633295 },
			{ name = "Tier 5", id = 152622226 },
			{ name = "Tier 6", id = 973877747 },
		},
	},
	{
		name = "🏠 Cactus Canyon Zone",
		tiers = {
			{ name = "Tier 1", id = 127982139 },
			{ name = "Tier 2", id = -203247844 },
			{ name = "Tier 3", id = -534477827 },
			{ name = "Tier 4", id = -865707810 },
			{ name = "Tier 5", id = -1196937793 },
			{ name = "Tier 6", id = -1528167776 },
		},
	},
	{
		name = "🏠 Sunny Isles Zone",
		tiers = {
			{ name = "Tier 1", id = 435901140 },
			{ name = "Tier 2", id = 104671157 },
			{ name = "Tier 3", id = -226558826 },
			{ name = "Tier 4", id = -557788809 },
			{ name = "Tier 5", id = -889018792 },
			{ name = "Tier 6", id = -1220248775 },
		},
	},
	{
		name = "🏠 Frosty Fjords Zone",
		tiers = {
			{ name = "Tier 1", id = -123724695 },
			{ name = "Tier 2", id = 1167743274 },
			{ name = "Tier 3", id = -1835756053 },
			{ name = "Tier 4", id = -544288084 },
			{ name = "Tier 5", id = 747179885 },
			{ name = "Tier 6", id = 2038647854 },
		},
	},
	{
		name = "🏠 Limestone Cliff Zone",
		tiers = {
			{ name = "Tier 1", id = 1651270308 },
			{ name = "Tier 2", id = -406251547 },
			{ name = "Tier 3", id = 1831193894 },
			{ name = "Tier 4", id = -226327961 },
			{ name = "Tier 5", id = 2011117480 },
			{ name = "Tier 6", id = -46404375 },
		},
	},
	{
		name = "🏠 Omega Residence",
		tiers = {
			{ name = "Tier 1", id = 225281007 },
			{ name = "Tier 2", id = -105948976 },
			{ name = "Tier 3", id = -437178959 },
			{ name = "Tier 4", id = -768408942 },
			{ name = "Tier 5", id = -1099638925 },
			{ name = "Tier 6", id = -1430868908 },
		},
	},
	{
		name = "🏠 Latin America Zone",
		tiers = {
			{ name = "Tier 1", id = -116927444 },
			{ name = "Tier 2", id = 1174540525 },
			{ name = "Tier 3", id = -1828958802 },
			{ name = "Tier 4", id = -537490833 },
		},
	},
	{
		name = "🏠 Old Town House",
		tiers = { { name = "Tier 1", id = -1630222853 }, {
			name = "Tier 2",
			id = -1562421476,
		} },
	},
	{
		name = "🏠 Art Nouveau Zone",
		tiers = {
			{ name = "Tier 1", id = 352543127 },
			{ name = "Tier 2", id = -1988111720 },
			{ name = "Tier 3", id = -33799271 },
			{ name = "Tier 4", id = 1920513178 },
		},
	},
	{
		name = "🏠 Florentine Zone",
		tiers = {
			{ name = "Tier 1", id = 1579882178 },
			{ name = "Tier 2", id = 1647683555 },
			{ name = "Tier 3", id = 1715484932 },
			{ name = "Tier 4", id = 1783286309 },
		},
	},
	{
		name = "?? Kyoto Zone",
		tiers = {
			{ name = "Tier 1", id = -117255958 },
			{ name = "Tier 2", id = 1174212011 },
			{ name = "Tier 3", id = -1829287316 },
			{ name = "Tier 4", id = -537819347 },
		},
	},
	{
		name = "🏠 Cozy Homes",
		tiers = {
			{ name = "Tier 1", id = -402498334 },
			{ name = "Tier 2", id = 1834947107 },
			{ name = "Tier 3", id = -222574748 },
			{ name = "Tier 4", id = 2014870693 },
		},
	},
}

local educationBuildingData = {
	{ id = 1149140292, verifier = 8751168572450229788, name = "Nursery School" },
	{ id = -15379413, verifier = 6007631909741545246, name = "Grade School" },
	{ id = 1416055094, verifier = 8751164169839528980, name = "Public Library" },
	{ id = 234829448, verifier = 7157169134838040604, name = "High School" },
	{ id = -98121376, verifier = 7597138734268498728, name = "Community College" },
	{ id = 135886467, verifier = 8318823020956112154, name = "University" },
}

local first_building_pointer = nil
local building_list_start = {}
local building_list_length = nil

function bytemask(n)
	local bits = 0
	while n ~= 0 do
		bits = bits + 8
		n = n >> 8
	end
	return (1 << bits) - 1
end

function readString(addrs, discard_if_invalid, max_length)
	local l = gg.getValues({ { address = addrs, flags = 1 } })[1].value
	local check = gg.getValues({ { address = addrs + 1, flags = 1 } })[1].value
	local bytes = {}
	if l <= 46 and l >= 0 and check ~= 0 then
		l = l / 2
		for i = 1, l do
			table.insert(bytes, { address = addrs + i, flags = 1 })
		end
	else
		l = gg.getValues({ { address = addrs, flags = 4 } })[1].value
		if l < 0 then
			return nil
		end
		if l > (max_length or 100) then
			return nil
		end
		local addrs2 = gg.getValues({ { address = addrs + 0x10, flags = 32 } })[1].value
		for i = 0, l - 1 do
			table.insert(bytes, { address = addrs2 + i, flags = 1 })
		end
	end
	if #bytes == 0 then
		return nil
	end
	bytes = gg.getValues(bytes)
	local bytes2 = {}
	for i, v in ipairs(bytes) do
		if v.value <= 0 then
			if discard_if_invalid then
				return nil
			else
				break
			end
		end
		table.insert(bytes2, v.value)
	end
	return string.char(table.unpack(bytes2))
end

function initializeData()
	gg.setVisible(false)

	local idsToValidate = {}
	local totalKnownIds = 0

	for _, mainCat in ipairs(buildingData) do
		if mainCat.isEpicCategory then
			for _, subCat in ipairs(mainCat.categories) do
				for _, tier in ipairs(subCat.tiers) do
					idsToValidate[tier.id] = true
					totalKnownIds = totalKnownIds + 1
				end
			end
		else
			for _, tier in ipairs(mainCat.tiers) do
				idsToValidate[tier.id] = true
				totalKnownIds = totalKnownIds + 1
			end
		end
	end

	for _, eduBuilding in ipairs(educationBuildingData) do
		idsToValidate[eduBuilding.id] = true
		totalKnownIds = totalKnownIds + 1
	end

	local function populateAndCache(correctListStart)
		local pointers_to_get = {}
		for i = 1, 5000 do
			pointers_to_get[i] = { address = correctListStart.address + (i - 1) * 8, flags = gg.TYPE_QWORD }
		end
		local pResults = gg.getValues(pointers_to_get)

		local aRDC = {}
		for _, r in ipairs(pResults) do
			if r.value and r.value ~= 0 then
				table.insert(aRDC, { address = r.value + 0x50, flags = gg.TYPE_DWORD, op = r.value })
			else
				break
			end
		end
		if #aRDC == 0 then
			return false
		end

		local cR = gg.getValues(aRDC)
		local namedCount = 0
		buildingDatabase = {}
		discoveredPointers = {}

		for i, r in ipairs(cR) do
			if r.value then
				discoveredPointers[r.value] = aRDC[i].op

				if buildingNameById[r.value] then
					buildingDatabase[r.value] = { name = buildingNameById[r.value], pointer = aRDC[i].op }
					namedCount = namedCount + 1
				end
			end
		end

		gg.setVisible(true)
		gg.toast(string.format("✅ Initialization Complete. Found %d buildings.", namedCount))
		isInitialized = true
		return true
	end

	gg.setRanges(gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS | gg.REGION_OTHER)
	gg.clearResults()
	gg.searchNumber("448264947", gg.TYPE_DWORD)
	local initialResults = gg.getResults(gg.getResultsCount())
	if #initialResults == 0 then
		gg.alert("Error: Initial value 448264947 not found.")
		gg.setVisible(true)
		return false
	end

	local addressesToReadPtr1 = {}
	for _, result in ipairs(initialResults) do
		table.insert(addressesToReadPtr1, { address = result.address - 0x8, flags = gg.TYPE_QWORD })
	end
	local firstPointers = gg.getValues(addressesToReadPtr1)

	local addressesToReadPtr2 = {}
	for _, ptr1 in ipairs(firstPointers) do
		if ptr1.value and ptr1.value ~= 0 then
			table.insert(addressesToReadPtr2, { address = ptr1.value + 0x4, flags = gg.TYPE_QWORD })
		end
	end
	if #addressesToReadPtr2 == 0 then
		gg.alert("Error: No valid sources found after first validation.")
		gg.setVisible(true)
		return false
	end

	local secondPointers = gg.getValues(addressesToReadPtr2)
	local validSources = {}
	for i, ptr2 in ipairs(secondPointers) do
		if ptr2.value and ptr2.value == 7235441155891999603 then
			table.insert(validSources, initialResults[i].address - 0x50)
		end
	end

	if #validSources == 0 then
		gg.alert("Error: No valid sources found after second validation.")
		gg.setVisible(true)
		return false
	end

	local possibleLists = {}
	for i, sourceAddr in ipairs(validSources) do
		gg.clearResults()
		gg.searchNumber(string.format("%Xh", sourceAddr), gg.TYPE_QWORD)
		local pSearchResults = gg.getResults(gg.getResultsCount())
		for _, pResult in ipairs(pSearchResults) do
			table.insert(possibleLists, pResult)
		end
	end
	if #possibleLists == 0 then
		gg.alert("❌ No building list was found.")
		gg.setVisible(true)
		return false
	end

	for i, listStart in ipairs(possibleLists) do
		local pointersToCheck = {}
		for j = 0, 5000 do
			table.insert(pointersToCheck, { address = listStart.address + (j * 8), flags = gg.TYPE_QWORD })
		end
		local buildingPointers = gg.getValues(pointersToCheck)

		local idsToRead = {}
		for _, ptr in ipairs(buildingPointers) do
			if ptr.value and ptr.value ~= 0 then
				table.insert(idsToRead, { address = ptr.value + 0x50, flags = gg.TYPE_DWORD })
			else
				break
			end
		end

		if #idsToRead >= 2500 then
			local buildingIds = gg.getValues(idsToRead)
			local foundInThisList = {}
			local foundCount = 0
			for _, idData in ipairs(buildingIds) do
				if idData.value and idsToValidate[idData.value] and not foundInThisList[idData.value] then
					foundInThisList[idData.value] = true
					foundCount = foundCount + 1
				end
			end

			if foundCount >= (totalKnownIds * 0.9) then
				gg.toast("✅ Building list found and validated.")
				return populateAndCache(listStart)
			end
		end
	end

	gg.setVisible(true)
	gg.alert("❌ Initialization failed. No list was found containing required buildings.")
	return false
end

function ensureEducationBuildingsAreFound(neededCount)
	if #cachedBuildings >= neededCount then
		return true
	end
	gg.setVisible(false)

	for i = #cachedBuildings + 1, neededCount do
		local target = educationBuildingData[i]
		if not target then
			break
		end

		gg.toast("⏳ Finding " .. target.name .. "...")
		local ptr = discoveredPointers[target.id]
		local wasFound = false
		if ptr and ptr ~= 0 then
			gg.clearResults()
			gg.searchNumber(ptr, gg.TYPE_QWORD)
			local found = gg.getResults(1000)
			for _, r in ipairs(found) do
				local verValue = gg.getValues({ { address = r.address - 0x18, flags = gg.TYPE_QWORD } })[1]
				if verValue and verValue.value == target.verifier then
					local finalAddr = r.address
					local currentPtrValue = gg.getValues({ { address = finalAddr, flags = gg.TYPE_QWORD } })[1].value
					cachedBuildings[i] = { address = finalAddr, originalValue = currentPtrValue, name = target.name }
					gg.toast("✅ " .. target.name .. " Found!")
					wasFound = true
					break
				end
			end
		end
		if not wasFound then
			gg.setVisible(true)
			gg.alert("❌ Could not find placed building: " .. target.name .. ".")
			return false
		end
	end
	gg.setVisible(true)
	return true
end

function revertAllChanges()
	if #cachedBuildings == 0 then
		gg.toast("ℹ️ No changes to revert.")
		return
	end
	local vS = {}
	for _, b in ipairs(cachedBuildings) do
		table.insert(vS, { address = b.address, value = b.originalValue, flags = gg.TYPE_QWORD })
	end
	gg.setValues(vS)
	gg.toast("✅ All changes reverted.")
end

function applyChanges(selectedTiers)
	if not ensureEducationBuildingsAreFound(#selectedTiers) then
		return
	end
	local valuesToSet, modifiedCount = {}, 0
	for i, building in ipairs(cachedBuildings) do
		if i <= #selectedTiers then
			local newTier = selectedTiers[i]
			local newBuildingPtr = discoveredPointers[newTier.id]
			if newBuildingPtr and newBuildingPtr ~= 0 then
				table.insert(valuesToSet, { address = building.address, value = newBuildingPtr, flags = gg.TYPE_QWORD })
				modifiedCount = modifiedCount + 1
			else
				gg.toast("⚠️ " .. newTier.name .. " not found in memory, skipping.")
			end
		else
			table.insert(
				valuesToSet,
				{ address = building.address, value = building.originalValue, flags = gg.TYPE_QWORD }
			)
		end
	end
	if #valuesToSet > 0 then
		gg.setValues(valuesToSet)
		if modifiedCount > 0 then
			gg.toast(string.format("Done! %d education buildings were modified.", modifiedCount))
		else
			gg.toast("✅ Buildings reset to original state.")
		end
	else
		gg.alert("❌ Failed to apply changes.")
	end
end

function showTierMenu(zone)
	while true do
		local menu = { "🔙 Back" }
		for _, t in ipairs(zone.tiers) do
			table.insert(menu, t.name)
		end
		local choice = gg.multiChoice(menu, nil, "Select types for " .. zone.name)
		if choice == nil then
			gg.setVisible(false)
			while not gg.isVisible() do
				gg.sleep(100)
			end
		elseif choice[1] then
			return
		else
			local sT = {}
			for i, s in pairs(choice) do
				if s and i > 1 then
					table.insert(sT, zone.tiers[i - 1])
				end
			end
			if #sT > 0 then
				applyChanges(sT)
				return
			else
				gg.toast("ℹ️ No items selected.")
			end
		end
	end
end

function showEpicCategoryMenu()
	while true do
		local menu = { "🔙 Back" }
		for _, c in ipairs(buildingData[1].categories) do
			table.insert(menu, c.name)
		end
		local choice = gg.choice(menu, nil, "Select Epic Building Category")
		if choice == nil then
			gg.setVisible(false)
			while not gg.isVisible() do
				gg.sleep(100)
			end
		elseif choice == 1 then
			return
		else
			showTierMenu(buildingData[1].categories[choice - 1])
		end
	end
end

function instantResidencesMenu()
	if not isInitialized then
		if not initializeData() then
			return
		end
	end

	while true do
		local menu = { "🔙 Back", "↩️ Revert All Changes" }
		for _, d in ipairs(buildingData) do
			table.insert(menu, d.name)
		end
		local choice = gg.choice(menu, nil, "Select Building Zone")

		if choice == nil then
			gg.setVisible(false)
			while not gg.isVisible() do
				gg.sleep(100)
			end
		elseif choice == 1 then
			return
		elseif choice == 2 then
			revertAllChanges()
		else
			local selectedData = buildingData[choice - 2]
			if selectedData.isEpicCategory then
				showEpicCategoryMenu()
			else
				showTierMenu(selectedData)
			end
		end
	end
end

function UnlockAllRegions()
	gg.setVisible(false)
	gg.clearResults()
	gg.clearList()
	gg.setRanges(gg.REGION_ANONYMOUS | gg.REGION_C_ALLOC | gg.REGION_OTHER)

	gg.searchNumber("7308044150550451494", gg.TYPE_QWORD)
	local targets = {}
	for _, r in ipairs(gg.getResults(10000)) do
		local a = r.address
		if gg.getValues({ { address = a + 0x4, flags = gg.TYPE_QWORD } })[1].value == 7450451749706097519 then
			local v8a = a + 0x8
			if gg.getValues({ { address = v8a, flags = gg.TYPE_QWORD } })[1].value == 4858943546476286564 then
				table.insert(targets, v8a - 0x8 - 0x58)
			end
		end
	end

	local pointers = {}
	for _, addr in ipairs(targets) do
		gg.clearResults()
		gg.searchNumber(string.format("%Xh", addr), gg.TYPE_QWORD)
		for _, p in ipairs(gg.getResults(gg.getResultsCount())) do
			if p.value ~= 0 then
				table.insert(pointers, p)
			end
		end
	end

	local labels = {
		[15000] = "First Region",
		[250000] = "Second Region",
		[1000000] = "Third Region",
		[10000000] = "Fourth Region",
	}

	local finals = {}
	for _, p in ipairs(pointers) do
		local p1 = gg.getValues({ { address = p.address - 0x8, flags = gg.TYPE_QWORD } })[1].value
		if p1 ~= 0 then
			local addr = p1 + 0x8
			local val = gg.getValues({ { address = addr, flags = gg.TYPE_DWORD } })[1]
			if labels[val.value] then
				val.name = labels[val.value]
				val.value = 0
				table.insert(finals, val)
			end
		end
	end

	table.sort(finals, function(a, b)
		return a.value < b.value
	end)
	gg.clearList()
	gg.clearResults()
	if #finals > 0 then
		gg.setValues(finals)
		gg.addListItems(finals)
		gg.toast("All Regions Unlocked")
	end
	gg.clearResults()
	gg.clearList()
end

local building_list_start = nil
local building_list_length = nil

function findBuildingList()
	gg.setVisible(false)
	gg.setRanges(gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS | gg.REGION_OTHER)
	gg.clearResults()
	gg.searchNumber("448264947", gg.TYPE_DWORD)
	local initialResults = gg.getResults(gg.getResultsCount())
	if #initialResults == 0 then
		gg.alert("Initial value 448264947 not found.")
		gg.setVisible(true)
		return false
	end

	local addressesToReadPtr1 = {}
	for _, result in ipairs(initialResults) do
		table.insert(addressesToReadPtr1, { address = result.address - 0x8, flags = gg.TYPE_QWORD })
	end
	local firstPointers = gg.getValues(addressesToReadPtr1)

	local addressesToReadPtr2 = {}
	for _, ptr1 in ipairs(firstPointers) do
		if ptr1.value and ptr1.value ~= 0 then
			table.insert(addressesToReadPtr2, { address = ptr1.value + 0x4, flags = gg.TYPE_QWORD })
		end
	end
	if #addressesToReadPtr2 == 0 then
		gg.alert("No results passed the first validation.")
		gg.setVisible(true)
		return false
	end

	local secondPointers = gg.getValues(addressesToReadPtr2)
	local validSources = {}
	for i, ptr2 in ipairs(secondPointers) do
		if ptr2.value and ptr2.value == 7235441155891999603 then
			table.insert(validSources, initialResults[i].address - 0x50)
		end
	end

	if #validSources == 0 then
		gg.alert("No results passed the second validation.")
		gg.setVisible(true)
		return false
	end

	local possibleLists = {}
	for i, sourceAddr in ipairs(validSources) do
		gg.clearResults()
		gg.searchNumber(string.format("%Xh", sourceAddr), gg.TYPE_QWORD)
		local pointerSearchResults = gg.getResults(gg.getResultsCount())
		for _, pResult in ipairs(pointerSearchResults) do
			table.insert(possibleLists, pResult)
		end
	end
	if #possibleLists == 0 then
		gg.alert("❌ No building lists found after pointer search.")
		gg.setVisible(true)
		return false
	end

	local idsToFind = {
		[448264947] = true,
		[1522778645] = true,
		[1522778646] = true,
		[1522778647] = true,
		[1522778648] = true,
		[1522778649] = true,
		[1522778650] = true,
		[1077878471] = true,
		[526649619] = true,
		[-1800058036] = true,
		[-761420415] = true,
		[-124885990] = true,
		[-1695738094] = true,
		[1457386162] = true,
		[1547529770] = true,
		[-1931689325] = true,
		[497895753] = true,
		[-2005087996] = true,
		[-1645866108] = true,
		[848369710] = true,
		[-646372006] = true,
		[-887832712] = true,
		[-632375868] = true,
		[1031128507] = true,
		[-1275569118] = true,
		[-205731966] = true,
		[211291018] = true,
		[-867480776] = true,
		[634705318] = true,
		[1003670731] = true,
		[1736540863] = true,
		[1100779520] = true,
		[-672425292] = true,
		[591847594] = true,
		[465188623] = true,
		[-1592694037] = true,
		[-425205559] = true,
		[88852693] = true,
		[-1206243115] = true,
		[1026382411] = true,
		[-1180395309] = true,
		[-1873109675] = true,
		[-2043774337] = true,
		[-1294489020] = true,
		[299388908] = true,
		[873877609] = true,
		[-173188499] = true,
		[-1341405639] = true,
		[925006678] = true,
		[-67713006] = true,
		[-619996630] = true,
		[-1779083345] = true,
		[1169487741] = true,
		[851946800] = true,
		[-410571163] = true,
		[252896069] = true,
		[-888911843] = true,
		[1005029538] = true,
		[-1037153604] = true,
		[-1644752812] = true,
		[-957241066] = true,
		[1484303005] = true,
		[1942083942] = true,
		[841862582] = true,
		[-1332310259] = true,
		[1099952628] = true,
		[751497775] = true,
		[789426060] = true,
		[40742115] = true,
		[-1079914711] = true,
		[1324835889] = true,
		[1144335259] = true,
		[1353024422] = true,
		[-1689674194] = true,
		[-1089358459] = true,
		[1013665086] = true,
		[1936110901] = true,
		[1333524968] = true,
		[-1361673718] = true,
		[-357520281] = true,
		[1900838580] = true,
		[277401625] = true,
		[1900179467] = true,
		[-320582719] = true,
		[-741567455] = true,
		[-2130901093] = true,
		[-1382928141] = true,
		[1146948722] = true,
		[762126226] = true,
		[-1344668426] = true,
		[-346803870] = true,
		[-1332037813] = true,
		[-1184600102] = true,
		[520534137] = true,
		[-1079855971] = true,
		[1766656099] = true,
		[2108628511] = true,
		[-180369097] = true,
		[-1803477641] = true,
		[-2146309853] = true,
	}
	local requiredMatches = 0
	for _ in pairs(idsToFind) do
		requiredMatches = requiredMatches + 1
	end

	for i, listStart in ipairs(possibleLists) do
		local pointersToCheck = {}
		for j = 0, 4999 do
			table.insert(pointersToCheck, { address = listStart.address + (j * 8), flags = gg.TYPE_QWORD })
		end
		local buildingPointers = gg.getValues(pointersToCheck)

		local idsToRead = {}
		local nonZeroPointerCount = 0
		for _, ptr in ipairs(buildingPointers) do
			if ptr.value and ptr.value ~= 0 then
				table.insert(idsToRead, { address = ptr.value + 0x50, flags = gg.TYPE_DWORD })
				nonZeroPointerCount = nonZeroPointerCount + 1
			else
				break
			end
		end

		if #idsToRead > 0 then
			local buildingIds = gg.getValues(idsToRead)
			local foundInThisList = {}
			local foundCount = 0
			for _, idData in ipairs(buildingIds) do
				if idsToFind[idData.value] and not foundInThisList[idData.value] then
					foundInThisList[idData.value] = true
					foundCount = foundCount + 1
				end
			end
			if foundCount >= requiredMatches then
				building_list_start = { { address = listStart.address, flags = gg.TYPE_QWORD } }
				building_list_length = nonZeroPointerCount
				gg.toast("✅ Correct building list found.")
				return true
			end
		end
	end
	gg.alert("❌ None of the possible lists contained the required buildings.")
	gg.setVisible(true)
	return false
end

function skipTutorial()
	gg.clearResults()
	gg.setVisible(false)
	gg.setRanges(gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS | gg.REGION_OTHER)
	gg.searchNumber("-1729554135", gg.TYPE_DWORD)
	gg.getResults(900)
	gg.editAll("-405662690", gg.TYPE_DWORD)
	gg.setVisible(false)
	gg.clearResults()
	gg.alert("Done. Restart the game to apply.")
end

function executeFinalJob()
	if type(building_list_length) ~= "number" or building_list_length <= 2000 then
		gg.setVisible(true)
		gg.alert("❌ Building list length is not valid.")
		return
	end

	local buildingListStartAddr = building_list_start[1].address
	local toGetPointers = {}
	for i = 1, building_list_length do
		table.insert(toGetPointers, { address = buildingListStartAddr + (i - 1) * 8, flags = gg.TYPE_QWORD })
	end
	local orderedPointers = gg.getValues(toGetPointers)

	local targetIndex = nil
	local ANCHOR_ID = -2146309853

	local toReadIDs = {}
	for i, p in ipairs(orderedPointers) do
		if p.value and p.value ~= 0 then
			table.insert(toReadIDs, { address = p.value + 0x50, flags = gg.TYPE_DWORD })
		else
			table.insert(toReadIDs, { address = 0, flags = gg.TYPE_DWORD })
		end
	end

	local idResults = gg.getValues(toReadIDs)
	for i = 1, #idResults do
		if idResults[i].value == ANCHOR_ID then
			targetIndex = i
			break
		end
	end

	if not targetIndex then
		gg.setVisible(true)
		gg.alert("Max storage anchor not found in the list.")
		return
	end

	local nameSequence = {}
	for i = 20, 596, 3 do
		table.insert(nameSequence, "Material Storage (" .. i .. ")")
	end

	local itemsToGet = #nameSequence
	local startIndex = targetIndex - (itemsToGet - 1)
	if startIndex < 1 then
		gg.setVisible(true)
		gg.alert("Anchor found too early in the list.")
		return
	end

	gg.setVisible(true)
	local input = gg.prompt({ "Enter your CURRENT Material Storage number:\n(Minimum is 20)" }, { "" }, { "number" })
	if not input or input[1] == "" then
		return
	end

	local userNumber = tonumber(input[1])
	if not userNumber then
		gg.alert("Invalid number.")
		return
	end

	local sourcePointer = nil
	local anchorPointer = orderedPointers[targetIndex].value
	local nameIndex = 1

	for i = startIndex, targetIndex do
		local currentName = nameSequence[nameIndex]
		local storageNum = tonumber(currentName:match("%((%d+)%)"))
		if storageNum and storageNum == userNumber then
			sourcePointer = orderedPointers[i].value
			break
		end
		nameIndex = nameIndex + 1
	end

	if not sourcePointer then
		gg.alert("Material Storage number " .. userNumber .. " was not found in the sequence.")
		return
	end

	if not anchorPointer then
		gg.alert("Anchor pointer could not be read.")
		return
	end

	gg.setVisible(false)
	gg.toast("Searching for all occurrences of '" .. userNumber .. "' to replace...")
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS | gg.REGION_C_ALLOC | gg.REGION_OTHER)
	gg.searchNumber(sourcePointer, gg.TYPE_QWORD)
	local count = gg.getResultsCount()

	if count == 0 then
		gg.alert("No occurrences of your current storage pointer were found to replace.")
		return
	end

	gg.toast("Replacing " .. count .. " items...")
	gg.getResults(count)
	gg.editAll(anchorPointer, gg.TYPE_QWORD)
	gg.setVisible(true)
	gg.toast("Done! Go to Daniel City and come back to apply.")
end

function maxmaterialstorage()
	gg.clearResults()
	if findBuildingList() then
		executeFinalJob()
	end
	gg.clearResults()
end

local cache = {}
local masterListConstants = {
	[1] = 267176888,
	[2] = 2090874750,
	[3] = -1270634091,
	[4] = 274276185,
	[5] = -1369888960,
	[6] = 1570439054,
	[7] = 144394935,
	[8] = 1807545838,
	[9] = 260292831,
	[10] = 1658060491,
	[11] = -181617693,
	[12] = 268207452,
	[13] = 351941774,
	[14] = -188562685,
	[15] = -164698239,
	[16] = 2090296690,
	[17] = 270579361,
	[18] = 26243455,
	[19] = -297136870,
	[20] = 465115894,
	[21] = 1799827558,
	[22] = 256959164,
	[23] = 182451793,
	[24] = -1970978713,
	[25] = -2127979990,
	[26] = 1447646651,
	[27] = -161427822,
	[28] = 255768525,
	[29] = 2090108855,
	[30] = 2090156119,
	[31] = -161567233,
	[32] = 495471776,
	[33] = 1228123200,
	[34] = 255678199,
	[35] = 334762709,
	[36] = 260508453,
	[37] = -788997290,
	[38] = 1125663546,
	[39] = -1398164872,
	[40] = 566656095,
	[41] = 1818945505,
	[42] = -113650078,
	[43] = 1593061790,
	[44] = 123794044,
	[45] = -466890509,
	[46] = -325591165,
	[47] = -153089811,
	[48] = 1534432269,
	[49] = 274394919,
	[50] = -1018293267,
	[51] = -1408194775,
	[52] = 108385717,
	[53] = -719795061,
	[54] = 270885747,
	[55] = -1799384545,
	[56] = -712060721,
	[57] = -265079577,
	[58] = -1136019226,
	[59] = 5863855,
	[60] = 298050001,
	[61] = 1943086388,
	[62] = -1494660480,
	[63] = 1171629674,
	[64] = -2135434832,
	[65] = -2135434831,
	[66] = -2135434830,
	[67] = -852364093,
	[68] = -852364092,
	[69] = -852364091,
	[70] = 527492590,
	[71] = 527492591,
	[72] = 527492592,
	[73] = -1480795913,
	[74] = 1553334434,
	[75] = -2118495682,
	[76] = 1886510007,
	[77] = 953030492,
	[78] = -1964329030,
	[79] = -1290152913,
	[80] = -75965445,
	[81] = -760220352,
	[82] = 248304484,
	[83] = -1740539876,
	[84] = 449644219,
	[85] = 2090257423,
	[86] = 1939782264,
	[87] = 1148007126,
	[88] = 1321484032,
	[89] = 2090724376,
	[90] = 479440892,
	[91] = 193491386,
	[92] = 2090694637,
	[93] = 2090767284,
	[94] = 614594674,
	[95] = -2000852277,
	[96] = -942334081,
	[97] = 1661902171,
	[98] = 2062064496,
	[99] = 1156262088,
	[100] = 1846238891,
	[101] = 518625563,
	[102] = -1683538769,
	[103] = 880024505,
	[104] = 1754918885,
	[105] = -313937296,
	[106] = -1423167883,
	[107] = -1153640785,
	[108] = 636979469,
	[109] = -1937678477,
	[110] = 1990081263,
	[111] = -1057013087,
	[112] = -422625305,
	[113] = 367764140,
	[114] = 856126755,
	[115] = 501522350,
	[116] = 367767594,
	[117] = -1128736189,
	[118] = 254483049,
	[119] = 748950963,
	[120] = 1618544967,
	[121] = -1385976118,
	[122] = -1544477773,
	[123] = 2090437138,
	[124] = -197041447,
	[125] = -747030696,
	[126] = 758095603,
	[127] = -1012709557,
	[128] = 1568337616,
	[129] = 267517973,
	[130] = -1676475650,
}

function storageWipe_findRegularItems()
	if cache.regularItems then
		return true
	end
	gg.setRanges(gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS | gg.REGION_OTHER)
	gg.clearResults()
	gg.searchNumber(masterListConstants[1], gg.TYPE_DWORD)
	if gg.getResultsCount() == 0 then
		return false
	end
	local initialResults = gg.getResults(gg.getResultsCount())
	local batchReads = {}
	for i, res in ipairs(initialResults) do
		table.insert(batchReads, { address = res.address - 0x48, flags = gg.TYPE_DWORD })
		table.insert(batchReads, { address = res.address - 0x50, flags = gg.TYPE_DWORD })
	end
	local readValues = gg.getValues(batchReads)
	local targetID = nil
	for i = 1, #readValues, 2 do
		if readValues[i].value == 17 then
			targetID = readValues[i + 1].value
			break
		end
	end
	if not targetID then
		return false
	end
	gg.clearResults()
	gg.searchNumber(targetID, gg.TYPE_DWORD)
	if gg.getResultsCount() == 0 then
		return false
	end
	local idResults = gg.getResults(gg.getResultsCount())
	local finalEditList = {}
	for i, res in ipairs(idResults) do
		table.insert(finalEditList, { address = res.address + 0x50, flags = gg.TYPE_DWORD })
	end
	cache.regularItems = finalEditList
	return true
end

function storageWipe_findWarItems()
	if cache.warItems then
		return true
	end
	local ANCHOR_VALIDATOR = 1560176023
	local validator_map = {
		[1560176023] = true,
		[253271711] = true,
		[860715237] = true,
		[-916988905] = true,
		[-1540742631] = true,
		[-1962827238] = true,
		[352219700] = true,
		[226338627] = true,
		[-1607480754] = true,
		[471968558] = true,
		[-1247109630] = true,
		[2090081903] = true,
	}
	gg.setRanges(gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS | gg.REGION_OTHER)
	gg.clearResults()
	gg.searchNumber(tostring(ANCHOR_VALIDATOR), gg.TYPE_DWORD)
	local initial_results = gg.getResults(gg.getResultsCount())
	if #initial_results == 0 then
		return false
	end
	local search_key = nil
	for _, res in ipairs(initial_results) do
		local check = gg.getValues({ { address = res.address - 0x48, flags = gg.TYPE_DWORD } })[1]
		if check and check.value == 52 then
			local key = gg.getValues({ { address = res.address - 0x50, flags = gg.TYPE_QWORD } })[1]
			if key and key.value ~= 0 then
				search_key = key.value
				break
			end
		end
	end
	if not search_key then
		return false
	end
	gg.clearResults()
	gg.searchNumber(tostring(search_key), gg.TYPE_QWORD)
	local structures = gg.getResults(gg.getResultsCount())
	if #structures ~= 12 then
		return false
	end
	local validator_addresses = {}
	for _, s in ipairs(structures) do
		local res = gg.getValues({ { address = s.address + 0x50, flags = gg.TYPE_DWORD } })[1]
		if res and res.value and validator_map[res.value] then
			table.insert(validator_addresses, { address = res.address, flags = gg.TYPE_DWORD })
		end
	end
	cache.warItems = validator_addresses
	return true
end

function storageWipe_findOmegaItems()
	if cache.omegaItems then
		return true
	end
	local ANCHOR_VALIDATOR = -1540641695
	local validator_map = {
		[-1540641695] = true,
		[1940876015] = true,
		[-1307054383] = true,
		[1430745728] = true,
		[-661139406] = true,
		[638948574] = true,
		[-1847614967] = true,
		[-681051257] = true,
		[-477356184] = true,
		[-805181992] = true,
	}
	gg.setRanges(gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS | gg.REGION_OTHER)
	gg.clearResults()
	gg.searchNumber(tostring(ANCHOR_VALIDATOR), gg.TYPE_DWORD)
	local initial_results = gg.getResults(gg.getResultsCount())
	if #initial_results == 0 then
		return false
	end
	local search_key = nil
	for _, res in ipairs(initial_results) do
		local check = gg.getValues({ { address = res.address - 0x48, flags = gg.TYPE_DWORD } })[1]
		if check and check.value == 40 then
			local key = gg.getValues({ { address = res.address - 0x50, flags = gg.TYPE_QWORD } })[1]
			if key and key.value ~= 0 then
				search_key = key.value
				break
			end
		end
	end
	if not search_key then
		return false
	end
	gg.clearResults()
	gg.searchNumber(tostring(search_key), gg.TYPE_QWORD)
	local structures = gg.getResults(gg.getResultsCount())
	if #structures ~= 10 then
		return false
	end
	local validator_addresses = {}
	for _, s in ipairs(structures) do
		local res = gg.getValues({ { address = s.address + 0x50, flags = gg.TYPE_DWORD } })[1]
		if res and res.value and validator_map[res.value] then
			table.insert(validator_addresses, { address = res.address, flags = gg.TYPE_DWORD })
		end
	end
	cache.omegaItems = validator_addresses
	return true
end

function storageWipe_findExpansionItems()
	if cache.expansionItems then
		return true
	end
	local ANCHOR_VALIDATOR = 21080992
	local validator_map = {
		[13285930] = true,
		[21080992] = true,
		[543978041] = true,
		[1206566498] = true,
		[12777566] = true,
		[-1227768711] = true,
		[-520565565] = true,
		[-2038227] = true,
		[112710515] = true,
		[265268177] = true,
		[265268178] = true,
		[265268179] = true,
		[745632329] = true,
		[745632330] = true,
		[745632331] = true,
	}
	gg.setRanges(gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS | gg.REGION_OTHER)
	gg.clearResults()
	gg.searchNumber(tostring(ANCHOR_VALIDATOR), gg.TYPE_DWORD)
	local initial_results = gg.getResults(gg.getResultsCount())
	if #initial_results == 0 then
		return false
	end
	local search_key = nil
	for _, res in ipairs(initial_results) do
		local check = gg.getValues({ { address = res.address - 0x48, flags = gg.TYPE_DWORD } })[1]
		if check and check.value == 25 then
			local key = gg.getValues({ { address = res.address - 0x50, flags = gg.TYPE_QWORD } })[1]
			if key and key.value ~= 0 then
				search_key = key.value
				break
			end
		end
	end
	if not search_key then
		return false
	end
	gg.clearResults()
	gg.searchNumber(tostring(search_key), gg.TYPE_QWORD)
	local structures = gg.getResults(gg.getResultsCount())
	if #structures ~= 15 then
		return false
	end
	local validator_addresses = {}
	for _, s in ipairs(structures) do
		local res = gg.getValues({ { address = s.address + 0x50, flags = gg.TYPE_DWORD } })[1]
		if res and res.value and validator_map[res.value] then
			table.insert(validator_addresses, { address = res.address, flags = gg.TYPE_DWORD })
		end
	end
	cache.expansionItems = validator_addresses
	return true
end

function storageWipe_processAndClearItems(validatorAddresses, itemTypeName)
	if not validatorAddresses or #validatorAddresses == 0 then
		return 0
	end
	local valuesToSetZero = {}
	for _, itemData in ipairs(validatorAddresses) do
		table.insert(valuesToSetZero, { address = itemData.address, flags = gg.TYPE_DWORD, value = 667465812 })
	end
	gg.setValues(valuesToSetZero)
	return #valuesToSetZero
end

function storageWipe_showMenu()
	while true do
		local choices = {
			"🗑️ Clear Regular Storage Items",
			"💣 Clear War Items",
			"🌌 Clear Omega Items",
			"🗺️ Clear Expansion & Vu Items",
			"🔙 Back",
		}
		local selection = gg.multiChoice(choices, nil, "🧹 Storage Cleaner")

		if selection == nil then
			gg.setVisible(false)
			while not gg.isVisible() do
				gg.sleep(100)
			end
		elseif selection[5] then
			return
		else
			cache = {}
			local totalCleared = 0

			if selection[1] then
				storageWipe_findRegularItems()
			end
			if selection[2] then
				storageWipe_findWarItems()
			end
			if selection[3] then
				storageWipe_findOmegaItems()
			end
			if selection[4] then
				storageWipe_findExpansionItems()
			end

			if selection[1] and cache.regularItems then
				totalCleared = totalCleared + storageWipe_processAndClearItems(cache.regularItems, "Regular Items")
			end
			if selection[2] and cache.warItems then
				totalCleared = totalCleared + storageWipe_processAndClearItems(cache.warItems, "War Items")
			end
			if selection[3] and cache.omegaItems then
				totalCleared = totalCleared + storageWipe_processAndClearItems(cache.omegaItems, "Omega Items")
			end
			if selection[4] and cache.expansionItems then
				totalCleared = totalCleared
					+ storageWipe_processAndClearItems(cache.expansionItems, "Expansion/Vu Items")
			end

			gg.clearResults()
			if totalCleared > 0 then
				gg.alert("✅ Operation Complete!\n" .. totalCleared .. " items processed.\n\nRESTART THE GAME.")
			else
				gg.toast("No items found. Check your storage.")
			end
		end
	end
end

function deleteIndividualWarItems()
	local items = {
		{ name = "🔭 Binoculars", searchValue = "1560176023i" },
		{ name = "⚖️ Anvils", searchValue = "253271711i" },
		{ name = "💧 Hydrants", searchValue = "860715237i" },
		{ name = "⛽ Gasoline", searchValue = "-916988905i" },
		{ name = "📢 Megaphones", searchValue = "-1540742631i" },
		{ name = "⚙️ Propellers", searchValue = "-1962827238i" },
		{ name = "✂️ Pliers", searchValue = "352219700i" },
		{ name = "⛑️ Med Kits", searchValue = "226338627i" },
		{ name = "👢 Boots", searchValue = "-1607480754i" },
		{ name = "🦆 Ducks", searchValue = "471968558i" },
		{ name = "🚽 Plungers", searchValue = "-1247109630i" },
		{ name = "💣 Ammo Boxes", searchValue = "2090081903i" },
	}
	local itemNames = {}
	for i = 1, #items do
		table.insert(itemNames, items[i].name)
	end

	local selection = gg.multiChoice(itemNames, nil, "Select the war items to delete:")
	if not selection or not next(selection) then
		gg.toast("No items selected. Operation cancelled.")
		return
	end

	local totalDeleted = 0
	for index, wasSelected in pairs(selection) do
		if wasSelected then
			local item = items[index]
			gg.toast(string.format("Searching for %s...", item.name))
			gg.clearResults()
			gg.searchNumber(item.searchValue, gg.TYPE_DWORD, false)
			local count = gg.getResultsCount()
			if count > 0 then
				gg.toast(string.format("%d found. Deleting...", count))
				gg.getResults(count)
				gg.editAll("0", gg.TYPE_DWORD)
				totalDeleted = totalDeleted + 1
			else
				gg.toast(string.format("No %s found.", item.name))
			end
		end
	end

	gg.clearResults()
	if totalDeleted > 0 then
		gg.toast(string.format("Deletion complete. %d item types were processed.", totalDeleted))
	else
		gg.toast("No items were deleted.")
	end
end

function Clearwacards()
	gg.clearResults()
	gg.clearList()
	local warCards = {
		{ name = "📘 Comic Hand", value = 1430583743 },
		{ name = "🔬 Shrink Ray", value = 1430583746 },
		{ name = "🐙 Tentacle Vortex", value = 1430583748 },
		{ name = "🧲 Magnetism", value = 1430583749 },
		{ name = "🌪️ Not in Kansas", value = 1430583747 },
		{ name = "🗿 Giant Rock Monster", value = -35376651 },
		{ name = "?? Vu Robot", value = -35376655 },
		{ name = "🪩 Disco Twister", value = -35376689 },
		{ name = "🌿 Plant Monster", value = -35376688 },
		{ name = "❄️ Blizzaster", value = 1430583750 },
		{ name = "🐟 Fishaster", value = -35376685 },
		{ name = "🏺 Ancient Curse", value = -35376684 },
		{ name = "🖐️ Hands of Doom", value = 1430583751 },
		{ name = "⚖️ 16 Tons", value = -35376683 },
		{ name = "🕷️ Spiders", value = -35376680 },
		{ name = "🩰 Dance Shoes", value = -35376687 },
		{ name = "🚪 Building Portal", value = -35376681 },
		{ name = "🐍 Hissy Fit", value = -35376648 },
		{ name = "🎺 Mellow Bellow", value = -35376647 },
		{ name = "🦆 Doomsday Quack", value = -35376650 },
		{ name = "⚡ Electric Deity", value = -35376649 },
		{ name = "?? Zest From Above", value = -35376622 },
		{ name = "🛡️ Shield Buster", value = -35376623 },
		{ name = "🎬 B Movie Monster", value = -35376654 },
	}

	local fixedValue = 667465812

	local warCardMenuNames = {}
	for _, card in ipairs(warCards) do
		table.insert(warCardMenuNames, card.name)
	end

	local selected = gg.multiChoice(warCardMenuNames, nil, "Select War Cards to clear:")

	if not selected then
		gg.toast("No cards selected. Exiting...")
		return
	end

	local totalReplaced = 0

	for i, chosen in pairs(selected) do
		if chosen then
			local idToSearch = warCards[i].value

			gg.clearResults()
			gg.setRanges(gg.REGION_ANONYMOUS | gg.REGION_C_ALLOC | gg.REGION_OTHER)
			gg.setVisible(false)
			gg.searchNumber(idToSearch, gg.TYPE_DWORD)
			gg.setVisible(false)
			local results = gg.getResults(gg.getResultsCount())

			if #results > 0 then
				for j = 1, #results do
					results[j].value = fixedValue
					results[j].flags = gg.TYPE_DWORD
				end
				gg.setValues(results)
				totalReplaced = totalReplaced + #results
				gg.toast("Cleared " .. warCards[i].name .. "")
			else
				gg.toast("No results found for " .. warCards[i].name)
			end
		end
	end
	gg.alert("✅ Conversion complete! Restart the game to see the changes.")
end

function Nuke_findBuildingRoots()
	gg.toast("Searching for Trade HQ anchor...")
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS | gg.REGION_C_ALLOC | gg.REGION_OTHER)
	gg.setVisible(false)

	gg.searchNumber("42C8000043200000h", gg.TYPE_QWORD)
	local results = gg.getResults(-1)
	if #results == 0 then
		gg.alert("Error: Could not find the Trade HQ anchor. The script cannot continue.")
		return nil
	end

	local validated_anchor_address = nil

	for _, anchor_candidate in ipairs(results) do
		local ptr_A_addr = anchor_candidate.address + 0x40
		local ptr_A_val = gg.getValues({ { address = ptr_A_addr, flags = gg.TYPE_QWORD } })[1]

		if ptr_A_val and ptr_A_val.value ~= 0 then
			local validation_addr = ptr_A_val.value + 0x50
			local validation_val = gg.getValues({ { address = validation_addr, flags = gg.TYPE_DWORD } })[1]

			if validation_val and validation_val.value == -1165637235 then
				validated_anchor_address = anchor_candidate.address
				break
			end
		end
	end

	if not validated_anchor_address then
		gg.alert("Error: Validation failed. Could not find the correct structure.")
		return nil
	end

	local other_root_ptr_table = gg.getValues({ { address = validated_anchor_address - 0x20, flags = gg.TYPE_QWORD } })
	local other_root_ptr = other_root_ptr_table[1] and other_root_ptr_table[1].value or 0

	if other_root_ptr == 0 then
		gg.alert("Error: Found validated structure, but the final pointer (-0x20) is invalid.")
		return nil
	end

	local building_roots = {
		Residential = other_root_ptr + 0x820,
		Other = other_root_ptr,
		Beach = other_root_ptr - 0x14E0,
		Mountain = other_root_ptr - 0x1190,
	}

	gg.toast("All building roots have been found.")
	return building_roots
end

function Nuke_execute()
	gg.setVisible(false)
	gg.toast("Starting Nuke Procedure...")

	local buildingRoots = Nuke_findBuildingRoots()
	if not buildingRoots then
		gg.setVisible(true)
		return
	end

	local allBuildingAddresses = {}

	for groupName, rootAddress in pairs(buildingRoots) do
		gg.toast("Targeting " .. groupName .. " buildings...")
		gg.clearResults()

		gg.searchNumber(rootAddress, gg.TYPE_QWORD)
		local buildingsInGroup = gg.getResults(-1)

		if #buildingsInGroup > 0 then
			gg.toast("Found " .. #buildingsInGroup .. " buildings in " .. groupName .. " group.")
			for _, building in ipairs(buildingsInGroup) do
				table.insert(allBuildingAddresses, building.address)
			end
		else
			gg.toast("No buildings found for " .. groupName .. " group.")
		end
	end

	if #allBuildingAddresses == 0 then
		gg.setVisible(true)
		gg.alert("No placed buildings were found on your map to nuke.")
		return
	end

	gg.toast("Preparing to nuke a total of " .. #allBuildingAddresses .. " buildings...")

	local nukeCoordinate = 9999999.0
	local toSet = {}

	for _, buildingAddr in ipairs(allBuildingAddresses) do
		table.insert(toSet, { address = buildingAddr + 0x18, flags = gg.TYPE_FLOAT, value = nukeCoordinate })
		table.insert(toSet, { address = buildingAddr + 0x1c, flags = gg.TYPE_FLOAT, value = nukeCoordinate })
	end

	gg.toast("Launching nuke...")
	gg.setValues(toSet)

	local toUpdate = {}
	for i = 1, #toSet, 2 do
		table.insert(toUpdate, { address = toSet[i].address, flags = gg.TYPE_FLOAT, value = nukeCoordinate + 0.4 })
	end
	gg.setValues(toUpdate)
	gg.sleep(50)
	gg.setValues(toSet)

	gg.setVisible(true)
	gg.alert("Nuke successful! Go to Daniel's City and come back to see the changes.")
end

function Nuke_startProcess()
	local confirm1 = gg.choice(
		{ "Yes, I'm sure", "No, cancel" },
		nil,
		"This will NUKE ALL placed buildings on your map.\n\nBuildings in storage will NOT be affected.\n\nAre you absolutely sure?"
	)

	if confirm1 == 2 or confirm1 == nil then
		gg.toast("Operation cancelled.")
		return
	end

	local confirm2 = gg.choice(
		{ "YES, PROCEED!", "No, stop" },
		nil,
		"⚠️ FINAL CONFIRMATION ⚠️\n\nThere is no going back after this step. Proceed with the nuke?"
	)

	if confirm2 == 1 then
		Nuke_execute()
	else
		gg.toast("Operation cancelled. Your city is safe.")
	end
end

gg.setRanges(gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS | gg.REGION_OTHER)

targetAddressCache = targetAddressCache or {}
originalValuesCache = originalValuesCache or {}

function findMainModTargets(initialValue, patternValue)
	gg.clearResults()
	gg.clearList()
	gg.setVisible(false)
	gg.searchNumber(tostring(initialValue), gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
	if gg.getResultsCount() == 0 then
		return nil
	end

	local targets = {}
	local initialResults = gg.getResults(gg.getResultsCount())
	for _, result in ipairs(initialResults) do
		local scanStartAddress = result.address + 0xB8
		local addressesToScan = {}
		for offset = 0, 499 do
			table.insert(addressesToScan, { address = scanStartAddress + (offset * 4), flags = gg.TYPE_DWORD })
		end
		local memoryChunk = gg.getValues(addressesToScan)

		for j = 1, #memoryChunk - 1 do
			if memoryChunk[j].value == 255 and memoryChunk[j + 1].value == patternValue then
				local masterValueAddress = result.address - 0x18
				local masterValueTable = gg.getValues({ { address = masterValueAddress, flags = gg.TYPE_QWORD } })
				local masterValueResult = masterValueTable[1].value
				local distance = memoryChunk[j + 1].address - masterValueAddress

				gg.clearResults()
				gg.clearList()
				gg.setVisible(false)
				gg.searchNumber(tostring(masterValueResult), gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
				if gg.getResultsCount() > 0 then
					local newResults = gg.getResults(gg.getResultsCount())
					for _, newResult in ipairs(newResults) do
						table.insert(
							targets,
							{ address = newResult.address + distance, flags = gg.TYPE_DWORD, value = 0 }
						)
					end
					return targets
				end
			end
		end
	end
	return nil
end

function toggleMainMod()
	local key1, key2 = "mainMod1", "mainMod2"
	if originalValuesCache[key1] then
		gg.setValues(originalValuesCache[key1])
		gg.setValues(originalValuesCache[key2])
		originalValuesCache[key1], originalValuesCache[key2] = nil, nil
		gg.toast("Hide Icons DISABLED!")
	else
		if not targetAddressCache[key1] then
			targetAddressCache[key1] = findMainModTargets("7016450394149775128", 8212)
			if not targetAddressCache[key1] then
				gg.alert("Error, restart the game.")
				return
			end
		end
		if not targetAddressCache[key2] then
			targetAddressCache[key2] = findMainModTargets("7592899038939411220", 8214)
			if not targetAddressCache[key2] then
				gg.alert("Error, restart the game.")
				return
			end
		end

		local addresses1 = {}
		for _, item in ipairs(targetAddressCache[key1]) do
			table.insert(addresses1, { address = item.address, flags = item.flags })
		end
		originalValuesCache[key1] = gg.getValues(addresses1)
		gg.setValues(targetAddressCache[key1])

		local addresses2 = {}
		for _, item in ipairs(targetAddressCache[key2]) do
			table.insert(addresses2, { address = item.address, flags = item.flags })
		end
		originalValuesCache[key2] = gg.getValues(addresses2)
		gg.setValues(targetAddressCache[key2])

		gg.toast("Hide Icons ENABLED!")
	end
end

function toggleModification(key, name)
	if originalValuesCache[key] then
		gg.setValues(originalValuesCache[key])
		originalValuesCache[key] = nil
		gg.toast(name .. " DISABLED!")
	else
		if not targetAddressCache[key] then
			local targets = {}
			gg.clearResults()
			if key == "zoomIn" then
				gg.clearResults()
				gg.clearList()
				gg.setVisible(false)
				gg.searchNumber("1615.0", gg.TYPE_FLOAT)
				if gg.getResultsCount() == 0 then
					gg.alert("Error, restart the game.")
					return
				end
				local results = gg.getResults(gg.getResultsCount())
				local checkAddresses = {}
				for _, r in ipairs(results) do
					table.insert(checkAddresses, { address = r.address - 0x4, flags = gg.TYPE_FLOAT })
				end
				local values = gg.getValues(checkAddresses)
				for _, v in ipairs(values) do
					if v.value == 700 then
						table.insert(targets, { address = v.address, flags = v.flags })
					end
				end
			elseif key == "horizontalView" then
				gg.clearResults()
				gg.clearList()
				gg.setVisible(false)
				gg.searchNumber("0.59690260887", gg.TYPE_FLOAT)
				if gg.getResultsCount() == 0 then
					gg.alert("Error, restart the game.")
					return
				end
				local results = gg.getResults(gg.getResultsCount())
				for _, r in ipairs(results) do
					table.insert(targets, { address = r.address, flags = r.flags })
				end
			elseif key == "zoomOut" then
				gg.clearResults()
				gg.clearList()
				gg.setVisible(false)
				gg.searchNumber("-1300.0", gg.TYPE_FLOAT)
				if gg.getResultsCount() == 0 then
					gg.alert("Error, restart the game.")
					return
				end
				local results = gg.getResults(gg.getResultsCount())
				local checkAddresses = {}
				for _, r in ipairs(results) do
					table.insert(checkAddresses, { address = r.address + 0x4, flags = gg.TYPE_FLOAT })
				end
				local values = gg.getValues(checkAddresses)
				for _, v in ipairs(values) do
					if v.value == 27 then
						table.insert(targets, { address = v.address, flags = v.flags })
					end
				end
			end
			if #targets == 0 then
				gg.alert("Error, restart the game.")
				return
			end
			targetAddressCache[key] = targets
		end

		local editList = {}
		local customValue

		if key == "zoomIn" then
			local input = gg.prompt(
				{ "Enter Zoom In value (smaller = more zoom ; you can enter negative values):" },
				{ -1 },
				{ 8 }
			)
			if not input or not input[1] then
				return
			end
			customValue = tonumber(input[1])
		elseif key == "zoomOut" then
			local input = gg.prompt(
				{ "Enter Zoom Out value (larger = more zoom):\nRecommended: less than 100 to avoid lag." },
				{ 100 },
				{ 8 }
			)
			if not input or not input[1] then
				return
			end
			customValue = tonumber(input[1])
		else
			customValue = -1
		end

		for _, item in ipairs(targetAddressCache[key]) do
			table.insert(editList, { address = item.address, flags = item.flags, value = customValue })
		end

		local addressesToCache = {}
		for _, item in ipairs(editList) do
			table.insert(addressesToCache, { address = item.address, flags = item.flags })
		end
		originalValuesCache[key] = gg.getValues(addressesToCache)
		gg.setValues(editList)
		gg.toast(name .. " ENABLED!")
	end
end

function Layoutmenu()
	while true do
		gg.clearResults()

		local function getButtonText(key, name)
			return (originalValuesCache[key] and "🔴 " or "🟢 ") .. name
		end

		local mainModText = (originalValuesCache["mainMod1"] and "🔴 " or "🟢 ") .. "Hide Icons"

		local options = {
			"🔙 Back",
			mainModText,
			getButtonText("zoomIn", "Zoom In"),
			getButtonText("zoomOut", "Zoom Out"),
			getButtonText("horizontalView", "Horizontal View"),
		}

		local choice = gg.choice(options, nil, "CONTROOOOOL")

		if choice == nil then
			gg.setVisible(false)
			while not gg.isVisible() do
				gg.sleep(100)
			end
		elseif choice == 1 then
			return
		elseif choice == 2 then
			toggleMainMod()
		elseif choice == 3 then
			toggleModification("zoomIn", "Zoom In")
		elseif choice == 4 then
			toggleModification("zoomOut", "Zoom Out")
		elseif choice == 5 then
			toggleModification("horizontalView", "Horizontal View")
		end
	end
end

function MainRegion()
	gg.setVisible(false)
	gg.clearResults()
	gg.setRanges(gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS | gg.REGION_OTHER)
	gg.searchNumber("6553784", gg.TYPE_DWORD)
	gg.setVisible(false)
	local r = gg.getResults(50)
	gg.clearResults(50)
	if #r == 0 then
		gg.alert("Error: Capital City (Base) not found.")
		return
	end

	local safeKey = nil

	for i, res in ipairs(r) do
		local checkData = gg.getValues({ { address = res.address - 0x8, flags = gg.TYPE_QWORD } })
		if checkData[1].value ~= 0 and checkData[1].value ~= nil then
			safeKey = checkData[1].value
			break
		end
	end

	if safeKey == nil then
		gg.alert("Error: Could not identify validation key (QWORD).")
		return
	else
		gg.toast("Security key saved!")
	end

	gg.clearResults()

	local list = {
		{ n = "Capital City", v = 6553784, s = false, b = {} },
		{ n = "Green Valley", v = 8388880, s = false, b = {} },
		{ n = "Sunny Isles", v = 4194688, s = false, b = {} },
		{ n = "Limestone Cliffs", v = 11534448, s = false, b = {} },
		{ n = "Cactus Canyon", v = 7340144, s = false, b = {} },
		{ n = "Frosty Fjords", v = 6291780, s = false, b = {} },
	}

	while true do
		local menu = { "🔙 Back" }
		for i, item in ipairs(list) do
			table.insert(menu, item.n .. (item.s and " 🟢" or " 🔴"))
		end

		local sel = gg.choice(menu, nil, "Region Menu")

		if sel == nil then
			gg.setVisible(false)
			while not gg.isVisible() do
				gg.sleep(100)
			end
		elseif sel == 1 then
			return
		else
			local item = list[sel - 1]

			if item.s then
				gg.setValues(item.b)
				item.b = {}
				item.s = false
				gg.toast("Reverted: " .. item.n)
			else
				gg.clearResults()
				gg.setVisible(false)
				gg.searchNumber(item.v, gg.TYPE_DWORD)
				gg.setVisible(false)
				local found = gg.getResults(2000)
				local tSet = {}

				for k, val in ipairs(found) do
					local vCheck = gg.getValues({ { address = val.address - 0x8, flags = gg.TYPE_QWORD } })
					if vCheck[1].value == safeKey then
						table.insert(tSet, { address = val.address, flags = gg.TYPE_DWORD, value = 20000000 })
						table.insert(item.b, { address = val.address, flags = gg.TYPE_DWORD, value = val.value })
					end
				end

				if #tSet > 0 then
					gg.setValues(tSet)
					item.s = true
					gg.toast("Activated: " .. item.n)
					gg.clearResults(2000)
				else
					gg.toast("Validation failed (Incorrect offset)")
				end
			end
		end
	end
end

local metalRevertCache = {}

function activateNegativeStorageAndMetal()
	gg.setVisible(false)
	if not applyProductionMultiplier(1760000000, "119165820423434") then
		gg.alert("Failed to set Metal production amount.")
		return
	end
	gg.clearResults()
	gg.searchNumber("828673277", gg.TYPE_DWORD)
	if gg.getResultsCount() == 0 then
		gg.alert("Failed (Step 1).")
		return
	end
	local initialResults = gg.getResults(gg.getResultsCount())
	local savedAddress = nil
	for _, res in ipairs(initialResults) do
		local checkValue = gg.getValues({ { address = res.address - 0x48, flags = gg.TYPE_DWORD } })[1]
		if checkValue and checkValue.value == 15 then
			savedAddress = checkValue.address - 0x8
			break
		end
	end
	if not savedAddress then
		gg.alert("Failed (Step 2).")
		return
	end
	gg.clearResults()
	gg.searchNumber("-1501685376", gg.TYPE_DWORD)
	if gg.getResultsCount() == 0 then
		gg.alert("Failed (Step 3).")
		return
	end

	local finalResults = gg.getResults(gg.getResultsCount())
	local addressesToCache = {}
	for _, res in ipairs(finalResults) do
		table.insert(addressesToCache, { address = res.address + 0x1C, flags = gg.TYPE_QWORD })
	end
	metalRevertCache.patchValue = gg.getValues(addressesToCache)

	local valuesToEdit = {}
	for _, res in ipairs(finalResults) do
		table.insert(valuesToEdit, { address = res.address + 0x1C, flags = gg.TYPE_QWORD, value = savedAddress })
	end

	gg.setValues(valuesToEdit)
	gg.toast("Negative Storage Activated!")
	gg.setVisible(true)
end

function revertMetal()
	gg.setVisible(false)
	applyProductionMultiplier(1, "119165820423434")
	if metalRevertCache.patchValue and #metalRevertCache.patchValue > 0 then
		gg.setValues(metalRevertCache.patchValue)
		metalRevertCache.patchValue = nil
		gg.toast("Negative Storage reverted.")
	end
	gg.toast("Done")
	gg.setVisible(true)
end

function revertMethod2()
	gg.setVisible(false)
	gg.setRanges(gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS | gg.REGION_OTHER)
	gg.clearResults()
	gg.searchNumber("828673277", gg.TYPE_DWORD)
	if gg.getResultsCount() == 0 then
		gg.alert("FAILURE (Step 1).")
		return
	end
	local initialResults = gg.getResults(gg.getResultsCount())
	local search_key_addr = nil
	for _, res in ipairs(initialResults) do
		local check = gg.getValues({ { address = res.address - 0x48, flags = gg.TYPE_DWORD } })[1]
		if check and check.value == 15 then
			search_key_addr = check.address - 0x8
			break
		end
	end
	if not search_key_addr then
		gg.alert("FAILURE (Step 2).")
		return
	end
	local search_key = gg.getValues({ { address = search_key_addr, flags = gg.TYPE_DWORD } })[1]
	if not search_key or search_key.value == 0 then
		gg.alert("FAILURE (Step 3).")
		return
	end
	gg.clearResults()
	gg.searchNumber(tostring(search_key.value), gg.TYPE_DWORD)
	if gg.getResultsCount() == 0 then
		gg.alert("FAILURE (Step 4).")
		return
	end
	local finalResults = gg.getResults(gg.getResultsCount())
	local valuesToEdit = {}
	for _, res in ipairs(finalResults) do
		table.insert(valuesToEdit, { address = res.address + 0x50, flags = gg.TYPE_DWORD, value = 667465812 })
	end
	gg.setValues(valuesToEdit)
	gg.alert("Done! Restart game to apply changes.")
	gg.clearResults()
	gg.setVisible(true)
end

function negstorage()
	while true do
		local choice = gg.choice({
			"🔙 Back",
			"?? TUTORIAL 📢",
			"🟢 Activate Negative Storage",
			"↩️ Revert Metal",
			"↩️ Revert Negative Storage",
		}, nil)

		if not choice then
			gg.setVisible(false)
			while not gg.isVisible() do
				gg.sleep(100)
			end
		elseif choice == 1 then
			return
		elseif choice == 2 then
			gg.alert([[
⚠️📢📢📢 IMPORTANT PLEASE READ 📢📢📢⚠️

🛠 To use this:
1️⃣ Activate Negative Storage, once done, collect 2 metals from factory and boom! Now you have negative storage
3️⃣ Use "Revert Metal" once done.
]])
		elseif choice == 3 then
			activateNegativeStorageAndMetal()
		elseif choice == 4 then
			revertMetal()
		elseif choice == 5 then
			revertMethod2()
		end
	end
end

local cache = {
	residential_base_anchor = nil,
	other_base_anchor = nil,
}

local cache = {}

function findBuildingAnchors()
	if cache.residential_base_anchor and cache.other_base_anchor then
		return true
	end

	gg.toast("Searching for Trade HQ...")
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS | gg.REGION_C_ALLOC | gg.REGION_OTHER)
	gg.setVisible(false)

	gg.searchNumber("42C8000043200000h", gg.TYPE_QWORD)
	local results = gg.getResults(-1)
	if #results == 0 then
		gg.alert("Error: Could not find the initial Trade HQ anchor.")
		return false
	end

	local validated_anchor_address = nil

	for _, anchor_candidate in ipairs(results) do
		local ptr_A_addr = anchor_candidate.address + 0x40
		local ptr_A_val_table = gg.getValues({ { address = ptr_A_addr, flags = gg.TYPE_QWORD } })

		if ptr_A_val_table and ptr_A_val_table[1] and ptr_A_val_table[1].value ~= 0 then
			local validation_addr = ptr_A_val_table[1].value + 0x50
			local validation_val_table = gg.getValues({ { address = validation_addr, flags = gg.TYPE_DWORD } })

			if validation_val_table and validation_val_table[1] and validation_val_table[1].value == -1165637235 then
				validated_anchor_address = anchor_candidate.address
				break
			end
		end
	end

	if not validated_anchor_address then
		gg.alert("Error: Validation failed. Could not find the correct structure.")
		return false
	end

	local other_anchor_ptr_table =
		gg.getValues({ { address = validated_anchor_address - 0x20, flags = gg.TYPE_QWORD } })

	if other_anchor_ptr_table and other_anchor_ptr_table[1] and other_anchor_ptr_table[1].value ~= 0 then
		local other_anchor_ptr = other_anchor_ptr_table[1].value
		cache.other_base_anchor = other_anchor_ptr
		cache.residential_base_anchor = other_anchor_ptr + 0x820

		gg.toast("Building anchors found successfully!")
		return true
	else
		gg.alert("Error: Found the validated structure, but the final pointer at offset -20h is invalid.")
		return false
	end
end

function performMoveOperation(anchor_base_address, group_name, newX, newY)
	if not anchor_base_address then
		gg.alert("ERROR: Anchor for group '" .. group_name .. "' is null. Cannot search.")
		return
	end

	gg.toast("Searching for '" .. group_name .. "' group...")
	gg.setVisible(false)
	gg.clearResults()
	gg.searchNumber(anchor_base_address, gg.TYPE_QWORD)
	local building_instances = gg.getResults(-1)
	if #building_instances == 0 then
		gg.alert("No buildings were found in the '" .. group_name .. "' group.")
		return
	end

	gg.toast("Identifying " .. #building_instances .. " buildings...")
	local foundBuildings, menuNames = {}, { "Move ALL buildings in this group" }

	local coord_x_offset = 0x18
	local coord_y_offset = 0x1C

	for i, instance in ipairs(building_instances) do
		local structureAddr = gg.getValues({ { address = instance.address + 0x60, flags = gg.TYPE_QWORD } })[1].value
		if structureAddr and structureAddr ~= 0 then
			local buildingId = gg.getValues({ { address = structureAddr + 0x50, flags = gg.TYPE_DWORD } })[1].value
			local buildingName = buildingNameById[buildingId] or "Unknown Building"
			local coords = gg.getValues({
				{ address = instance.address + coord_x_offset, flags = gg.TYPE_FLOAT },
				{ address = instance.address + coord_y_offset, flags = gg.TYPE_FLOAT },
			})
			table.insert(foundBuildings, { name = buildingName, address = instance.address })
			local menuEntry =
				string.format("[%d] %s (X: %.0f, Y: %.0f)", i, buildingName, coords[1].value, coords[2].value)
			table.insert(menuNames, menuEntry)
		end
	end

	if #foundBuildings == 0 then
		gg.alert("No buildings could be identified for the menu.")
		return
	end
	local selection =
		gg.multiChoice(menuNames, nil, "Select which buildings to move to (" .. newX .. ", " .. newY .. "):")
	if not selection then
		gg.toast("Operation cancelled.")
		return
	end

	local selectedTargets = {}
	if selection[1] then
		for _, b in ipairs(foundBuildings) do
			table.insert(selectedTargets, b.address)
		end
	else
		for index, isSelected in pairs(selection) do
			if isSelected and index > 1 then
				table.insert(selectedTargets, foundBuildings[index - 1].address)
			end
		end
	end
	if #selectedTargets == 0 then
		gg.toast("No buildings were selected.")
		return
	end

	local addressesToRead = {}
	for _, addr in ipairs(selectedTargets) do
		table.insert(addressesToRead, { address = addr + coord_x_offset, flags = gg.TYPE_FLOAT })
	end
	local currentCoords = gg.getValues(addressesToRead)

	local targetsToMove = {}
	for i, addr in ipairs(selectedTargets) do
		if currentCoords[i].value and math.abs(currentCoords[i].value - -1170.0) > 0.1 then
			table.insert(targetsToMove, addr)
		end
	end

	if #targetsToMove == 0 then
		gg.toast("No buildings to move (all selected were at X: -1170).")
		return
	end

	local toSet = {}
	for _, addr in ipairs(targetsToMove) do
		table.insert(toSet, { address = addr + coord_x_offset, flags = gg.TYPE_FLOAT, value = newX })
		table.insert(toSet, { address = addr + coord_y_offset, flags = gg.TYPE_FLOAT, value = newY })
	end
	gg.toast("Moving " .. #targetsToMove .. " building(s)...")
	gg.setValues(toSet)

	local toUpdate = {}
	for _, addr in ipairs(targetsToMove) do
		table.insert(toUpdate, { address = addr + coord_x_offset, flags = gg.TYPE_FLOAT, value = newX + 0.4 })
	end
	gg.setValues(toUpdate)
	gg.sleep(50)
	gg.setValues(toSet)
	gg.setVisible(true)
	gg.toast("Success! Moved " .. #targetsToMove .. " building(s).")
end

function startMoveProcess(destinationCoords)
	if not findBuildingAnchors() then
		gg.setVisible(true)
		return
	end

	local choice = gg.choice(
		{ "🏘️ Move Residences", "🖼️ Move Other Buildings (Parks, Landscape etc..)" },
		nil,
		"Which group do you want to move?"
	)
	if not choice then
		return
	end

	if choice == 1 then
		performMoveOperation(cache.residential_base_anchor, "Residences", destinationCoords.x, destinationCoords.y)
	elseif choice == 2 then
		performMoveOperation(cache.other_base_anchor, "Other Buildings", destinationCoords.x, destinationCoords.y)
	end
end

function presetsMoveMode()
	local presets = { { x = -920, y = 920 }, { x = 2600, y = 920 }, { x = -920, y = -920 }, { x = 2600, y = -920 } }
	local menuHeader = string.format(
		[[
    MOUNTAIN SIDE
    %s
    
    %s
    BEACH SIDE
    ]],
		string.format("%-25s %s", "1", "2"),
		string.format("%-25s %s", "3", "4")
	)
	local choice = gg.choice({ "1", "2", "3", "4" }, nil, menuHeader)
	if choice then
		startMoveProcess(presets[tonumber(choice)])
	end
end

function customCoordsMoveMode()
	local input = gg.prompt(
		{ "Enter New X Coordinate:", "Enter New Y Coordinate:" },
		{ -920, -920 },
		{ "number", "number" }
	)
	if not input then
		return
	end
	local newX, newY = tonumber(input[1]), tonumber(input[2])
	if not newX or not newY then
		gg.alert("Invalid input.")
		return
	end
	startMoveProcess({ x = newX, y = newY })
end

function buildingMoverMenu()
	while true do
		local choice = gg.choice({
			"🗺️ Use Presets",
			"✍️ Use Custom Coordinates",
			"🔙 Back",
		}, nil, "🏗️ Building Mover")

		if not choice then
			gg.setVisible(false)
			while not gg.isVisible() do
				gg.sleep(100)
			end
		end

		if choice == 3 then
			return
		end

		if choice == 1 then
			presetsMoveMode()
		elseif choice == 2 then
			customCoordsMoveMode()
		end
	end
end

local cellData = {
	[1] = { name = "Cell 1 (10 Rewards)", rewardCount = 10 },
	[2] = { name = "Cell 2 (10 Rewards)", rewardCount = 10 },
	[3] = { name = "Cell 3 (10 Rewards)", rewardCount = 10 },
	[4] = { name = "Cell 4 (10 Rewards)", rewardCount = 10 },
}

local specBlockQwords = { 469853563144, 109, 0, 0, 0, 0, 0 }

local warItemMap = {
	["Binoculars"] = "7815262058616275476;32495385078752111;7565921;0;0;0;0",
	["Ammo"] = "478577246472;111;0;0;0;0;0",
	["Pliers"] = "32495402207694860;7565925;0;0;0;0;0",
	["Anvil"] = "119200214302986;27753;0;0;0;0;0",
	["Megaphone"] = "8027754715064651026;111524989915233;25966;0;0;0;0",
	["Gasoline"] = "7956009442659616528;435644099695;101;0;0;0;0",
	["Propeller"] = "7812730987161473042;125779936306544;29285;0;0;0;0",
	["FireHydrant"] = "7239897476523181590;8389750299777648741;1953390962;0;0;0;0",
	["Plunger"] = "8243108417085657102;1919248238;0;0;0;0;0",
	["Medkit"] = "32766869826260236;7629131;0;0;0;0;0",
	["Boots"] = "4788000827081314838;8319396935306995042;1937010543;0;0;0;0",
	["Duck"] = "4932116015157170708;30227177818711394;7037813;0;0;0;0",
	["Donut"] = "32,497,670,034,506,764;7,566,453;0;0;0;0;0",
}

local warAttacks = {
	{
		"💢 All Items (No Donut/Ammo/Gas)",
		{
			"FireHydrant",
			"Anvil",
			"Binoculars",
			"Megaphone",
			"Pliers",
			"Propeller",
			"Plunger",
			"Duck",
			"Boots",
			"Medkit",
		},
	},
	{ "💥 Comic Hand", { "Plunger", "Duck" } },
	{ "✨ Shrink Ray", { "Pliers", "Megaphone" } },
	{ "🗿 Giant Rock Monster", { "FireHydrant", "Binoculars" } },
	{ "🌪️ Not in Kansas", { "Anvil", "Propeller" } },
	{ "🧲 Magnetism", { "Binoculars", "FireHydrant", "Anvil" } },
	{ "🐙 Tentacle Vortex", { "Plunger", "Duck", "Propeller" } },
	{ "🤖 Flying Vu Robot", { "Ammo", "Gasoline" } },
	{ "🕺 Disco Twister", { "Megaphone", "Pliers", "Propeller" } },
	{ "🌱 Plant Monster", { "Plunger", "Gasoline", "Boots" } },
	{ "🥶 Blizzaster", { "Propeller", "Ammo", "Duck" } },
	{ "🐟 Fishaster", { "Duck", "Boots", "FireHydrant" } },
	{ "👻 Ancient Curse", { "Boots", "Megaphone", "Binoculars" } },
	{ "👊 Hands of Doom", { "Ammo", "Duck", "Pliers" } },
	{ "🏋️ 16 Tons", { "Pliers", "FireHydrant", "Anvil" } },
	{ "🕷️ Spiders", { "Gasoline", "Binoculars", "Ammo" } },
	{ "👟 Dance Shoes", { "Gasoline", "Binoculars", "Boots" } },
	{ "🏢 Building Portal", { "FireHydrant", "Plunger", "Propeller" } },
	{ "🦖 B Movie Monster", { "Boots", "Plunger", "Megaphone" } },
	{ "🐍 Hissy Fit", { "Binoculars", "Pliers", "Boots" } },
	{ "📢 Mellow Bellow", { "Megaphone", "Pliers", "Propeller" } },
	{ "🦆 Doomsday Quack", { "Duck", "Donut" } },
	{ "⚡ Electric Deity", { "Megaphone", "Gasoline", "Anvil" } },
	{ "🛡️ Shield Buster", { "Gasoline", "Medkit" } },
	{ "👽 Zest from Above", { "Binoculars", "Anvil", "Ammo" } },
}

local itemDatabase = {
	["train"] = {
		name = "🚂 Train Items",
		items = {
			{ n = "Bolts", c = "126,943,872,631,306;29,556;0;0;0;0;0" },
			{
				n = "Conductor Hat",
				c = "8,386,676,005,303,960,344;7,009,978,643,021,788,516;499,848,344,175;116;0;0;0",
			},
			{
				n = "Vintage Lantern",
				c = "7,306,916,073,128,416,796;8,389,750,136,584,495,476;31,088,027,508,826,444;7,238,245;0;0;0",
			},
			{ n = "Pickaxe", c = "7,311,701,108,893,241,358;1,702,388,075;0;0;0;0;0" },
		},
	},
	["london"] = {
		name = "🎡 London Items",
		items = {
			{
				n = "TeaPot",
				c = "5,291,289,089,347,111,964;8,245,933,057,424,387,940;13,919,217,832,128,621;3,240,820;0;0;0",
			},
			{
				n = "Bobby's Helmet",
				c = "5,291,289,089,347,111,964;8,245,933,057,424,387,940;14,200,692,808,839,277;3,306,356;0;0;0",
			},
			{
				n = "Telephone Box",
				c = "5,291,289,089,347,111,964;8,245,933,057,424,387,940;14,482,167,785,549,933;3,371,892;0;0;0",
			},
		},
	},
	["paris"] = {
		name = "🥖 Paris Items",
		items = {
			{
				n = "Paris Clothes",
				c = "7,874,952,320,161,763,354;8,390,891,584,405,205,865;54,371,944,656,752;12,659;0;0;0",
			},
			{
				n = "Paris Bag",
				c = "7,874,952,320,161,763,354;8,390,891,584,405,205,865;55,471,456,284,528;12,915;0;0;0",
			},
			{
				n = "Paris Baguette",
				c = "7,874,952,320,161,763,354;8,390,891,584,405,205,865;56,570,967,912,304;13,171;0;0;0",
			},
		},
	},
	["tokyo"] = {
		name = "🗾 Tokyo Items",
		items = {
			{
				n = "Lucky Cat",
				c = "7,874,946,788,094,066,970;8,390,891,584,405,204,577;54,371,944,656,752;12,659;0;0;0",
			},
			{
				n = "Lantern",
				c = "7,874,946,788,094,066,970;8,390,891,584,405,204,577;55,471,456,284,528;12,915;0;0;0",
			},
			{
				n = "Bonsai Tree",
				c = "7,874,946,788,094,066,970;8,390,891,584,405,204,577;56,570,967,912,304;13,171;0;0;0",
			},
		},
	},
	["cert"] = {
		name = "📜 Expansion Certificates",
		items = {
			{
				n = "Mountain Cert",
				c = "7,598,538,361,081,972,012;8,022,158,261,043,293,793;5,579,508,500,462,333,551;8,389,772,276,738,712,939;31,078,114,724,312,431;7,235,937;0",
			},
			{
				n = "City Cert",
				c = "7,598,538,361,081,972,004;8,022,158,261,043,293,793;4,858,932,560,083,054,191;34,186,467,633,685,867;7,959,657;0;0",
			},
			{
				n = "Beach Cert",
				c = "7,598,538,361,081,972,006;8,022,158,261,043,293,793;4,786,874,966,045,126,255;7,521,962,890,172,982,635;1,751,343,461;0;0",
			},
		},
	},
	["store_token"] = {
		name = "⏱️ Store Speed-Up Tokens",
		items = {
			{
				n = "Turtle 2x",
				c = "6,079,699,403,846,669,336;7,814,997,101,646,933,605;7,946,883,453,083,218,549;8,026,370,369,911,324,773;32,480,047,799,690,579;493,928,801,390;115",
			},
			{ n = "Llama 4x", c = "5,503,238,651,543,245,846;7,020,374,511,906,156,133;1,634,558,316;0;0;0;0" },
			{
				n = "Cheetah 12x",
				c = "4,854,720,305,201,894,426;8,387,221,379,528,748,645;114,767,773,918,568;26,721;0;0;0",
			},
		},
	},
	["factory_token"] = {
		name = "🏭 Factory Speed-Up Tokens",
		items = {
			{
				n = "Turtle 2x",
				c = "5,070,893,087,315,678,240;8,031,153,304,952,073,829;3,629,753,357,087,040,353;516,241,193,330;120;0;0",
			},
			{
				n = "Llama 4x",
				c = "5,070,893,087,315,678,240;8,031,153,304,952,073,829;3,773,868,545,162,896,225;516,274,747,762;120;0;0",
			},
			{
				n = "Cheetah 12x",
				c = "5,070,893,087,315,678,242;8,031,153,304,952,073,829;3,557,695,763,049,112,417;132,156,972,038,514;30,770;0;0",
			},
		},
	},
	["omega"] = {
		name = "🌌 Omega Items",
		items = {
			{ n = "Holoprojector", c = "8030604709417928730;8386658438904705135;125823019607402;29295;0;0;0" },
			{ n = "Robopet", c = "8387233504742560270;1952804975;0;0;0;0;0" },
			{ n = "Telepod", c = "7237126707120264206;1685024869;0;0;0;0;0" },
			{ n = "Solar Panels", c = "7012230382572491542;8317134136599933537;1936483694;0;0;0;0" },
			{
				n = "AntiGravity Boots",
				c = "7021788471646634272;8751735933049661289;8390046962110720374;495874699074;115;0;0",
			},
			{ n = "4D Printer", c = "8389759095531648018;125780070656370;29285;0;0;0;0" },
			{ n = "Jet Pack", c = "7738135582930717198;1801675088;0;0;0;0;0" },
			{ n = "Ultrawave Oven", c = "7023189288115000602;8525144178751398258;121382055667062;28261;0;0;0" },
			{ n = "Hoverboard", c = "8026103266031912980;28273260477182565;6582881;0;0;0;0" },
			{
				n = "Cryofusion Chamber",
				c = "8319668515601793826;4858943546678666863;7092432088614203241;125779768598888;29285;0;0",
			},
		},
	},
	["capital"] = {
		name = "🏢 Capital Expansion Items",
		items = {
			{
				n = "Dozer Exhaust",
				c = "7089070916666278952;5142940815661822064;8243124913282442604;7954884637952931439;500068347246;116;0",
			},
			{
				n = "Dozer Blade",
				c = "7089070916666278950;4998825627585966192;7017581717894423916;7957695015157986660;1852795252;0;0",
			},
			{ n = "Dozer Wheel", c = "7089070916666278942;5791459162003173488;8316866899155576172;1936421473;0;0;0" },
		},
	},
	["storage"] = {
		name = "📂 Storage Expansion Items",
		items = {
			{
				n = "Storage Bars",
				c = "7089070916666278944;6007631944116957296;7449366535721674092;435526137701;101;0;0",
			},
			{
				n = "Storage Camera",
				c = "7089070916666278942;5791459162003173488;8243126012945065324;1919252335;0;0;0",
			},
			{ n = "Storage Lock", c = "7089070916666278942;6295862320268669040;8243122654398080364;1919251553;0;0;0" },
		},
	},
	["beach"] = {
		name = "🏖️ Beach Expansion Items",
		items = {
			{
				n = "Life Belt",
				c = "7089070916666278946;4782652845472182384;7521962890171999596;54083979534693;12592;0;0",
			},
			{
				n = "Ship's Wheel",
				c = "7089070916666278946;4782652845472182384;7521962890171999596;55183491162469;12848;0;0",
			},
			{
				n = "Scuba Mask",
				c = "7089070916666278946;4782652845472182384;7521962890171999596;56283002790245;13104;0;0",
			},
		},
	},
	["mountain"] = {
		name = "⛰️ Mountain Expansion Items",
		items = {
			{
				n = "Snowboard",
				c = "7089070916666278952;5575286379889389680;8389772276737729900;3489842628544853359;211265939809;49;0",
			},
			{
				n = "Compass",
				c = "7089070916666278952;5575286379889389680;8389772276737729900;3489842628544853359;215560907105;50;0",
			},
			{
				n = "Winter Hat",
				c = "7089070916666278952;5575286379889389680;8389772276737729900;3489842628544853359;219855874401;51;0",
			},
		},
	},
	["vu"] = {
		name = "👹 Vu Items",
		items = {
			{ n = "Vu's Battery", c = "7089070916666278940;5070883221623894128;28554769125565804;6648425;0;0;0" },
			{
				n = "Vu's Gloves",
				c = "7089070916666278944;5214998409699750000;8389187293518194028;448629858661;104;0;0",
			},
			{ n = "Vu's Remote", c = "7089070916666278942;4854710439510110320;7308613709769696620;1701669234;0;0;0" },
		},
	},
}

local cachedBaseAddresses = nil
local fixedAmount = nil

local function parseQwords(codeString)
	local values = {}
	for str in string.gmatch(codeString, "([^;]+)") do
		local cleanStr = string.gsub(str, ",", "")
		local val = tonumber(cleanStr)
		if val then
			table.insert(values, val)
		else
			table.insert(values, 0)
		end
	end
	while #values < 7 do
		table.insert(values, 0)
	end
	return values
end

local function findAllCellBases()
	gg.setVisible(false)
	gg.toast("Searching for Vu Pass cell bases...")
	gg.clearResults()
	gg.setRanges(gg.REGION_ANONYMOUS | gg.REGION_C_ALLOC | gg.REGION_OTHER)
	gg.searchNumber("8319099934827697938", gg.TYPE_QWORD)

	local results = gg.getResults(100)
	if #results == 0 then
		gg.setVisible(true)
		return nil
	end

	local baseAddresses = {}

	for _, r in ipairs(results) do
		local ptrAddr = r.address + 0x18
		local ptrValResult = gg.getValues({ { address = ptrAddr, flags = gg.TYPE_QWORD } })
		if ptrValResult and ptrValResult[1].value ~= 0 then
			local ptrVal = ptrValResult[1].value
			local val180Result = gg.getValues({ { address = ptrVal + 0x180, flags = gg.TYPE_DWORD } })
			if val180Result and val180Result[1].value == 1145656354 then
				local pointer1_addr = val180Result[1].address - 0xF8
				local pointer1Result = gg.getValues({ { address = pointer1_addr, flags = gg.TYPE_QWORD } })
				if pointer1Result and pointer1Result[1].value ~= 0 then
					local pointer1 = pointer1Result[1].value
					local pointers_to_read = {}
					for _, offset in ipairs({ 0x00, 0x18, 0x30, 0x48 }) do
						table.insert(pointers_to_read, { address = pointer1 + offset, flags = gg.TYPE_QWORD })
					end
					local cellPointers = gg.getValues(pointers_to_read)
					for _, cellPtrInfo in ipairs(cellPointers) do
						local cellPointer = cellPtrInfo.value
						if cellPointer and cellPointer ~= 0 then
							local validationResult =
								gg.getValues({ { address = cellPointer + 0xC, flags = gg.TYPE_DWORD } })
							if validationResult and validCellValues[validationResult[1].value] then
								table.insert(baseAddresses, cellPointer + 0x30)
							end
						end
					end
					if #baseAddresses == 4 then
						gg.setVisible(true)
						gg.toast("✅ All 4 cell bases found and cached.")
						return baseAddresses
					end
				end
			end
		end
	end
	gg.setVisible(true)
	return nil
end

local function applyRewardsToCell(baseAddress, cellInfo, itemsToApply, amount)
	gg.clearList()
	gg.toast("Applying items to " .. cellInfo.name .. "...")

	local current = gg.getValues({
		{ address = baseAddress, flags = gg.TYPE_DWORD },
		{ address = baseAddress - 0x8, flags = gg.TYPE_DWORD },
		{ address = baseAddress - 0x10, flags = gg.TYPE_DWORD },
	})

	local accumulated = {}

	for i = 1, cellInfo.rewardCount do
		for _, v in ipairs(current) do
			table.insert(accumulated, v)
		end

		if i < cellInfo.rewardCount then
			local nextBatch = {}
			for _, v in ipairs(current) do
				table.insert(nextBatch, { address = v.address + 0xA0, flags = gg.TYPE_DWORD })
			end
			current = gg.getValues(nextBatch)
		end
	end

	gg.addListItems(accumulated)
	local list = gg.getListItems()

	local pointersToRead = {}
	for i = 1, #list, 3 do
		table.insert(pointersToRead, { address = list[i].address, flags = gg.TYPE_QWORD })
		table.insert(pointersToRead, { address = list[i + 1].address, flags = gg.TYPE_QWORD })
	end

	if #pointersToRead == 0 then
		return
	end
	local resolvedPointers = gg.getValues(pointersToRead)
	local allEdits, pointer_idx = {}, 1

	for i = 1, #list, 3 do
		local reward_counter = ((i - 1) / 3) + 1

		local itemIndex = ((reward_counter - 1) % #itemsToApply) + 1
		local itemCodeString = itemsToApply[itemIndex]
		local itemQwords = parseQwords(itemCodeString)

		local ptr1 = resolvedPointers[pointer_idx].value
		local ptr2 = resolvedPointers[pointer_idx + 1].value
		pointer_idx = pointer_idx + 2

		if ptr1 and ptr1 ~= 0 and ptr2 and ptr2 ~= 0 then
			for k = 1, 7 do
				table.insert(
					allEdits,
					{ address = ptr1 + (k - 1) * 4, flags = gg.TYPE_QWORD, value = specBlockQwords[k] }
				)
			end
			for k = 1, 7 do
				table.insert(allEdits, { address = ptr2 + (k - 1) * 4, flags = gg.TYPE_QWORD, value = itemQwords[k] })
			end
			table.insert(allEdits, { address = list[i + 2].address, flags = gg.TYPE_DWORD, value = amount })
			table.insert(allEdits, { address = list[i + 2].address + 0x38, flags = gg.TYPE_DWORD, value = 0 })
		end
	end

	if #allEdits > 0 then
		gg.setValues(allEdits)
	end
end

local function askCellAndApply(finalCodeList)
	if not finalCodeList or #finalCodeList == 0 then
		return
	end

	local amount
	if fixedAmount then
		amount = fixedAmount
	else
		local amountInput = gg.prompt({ "Amount for selected items:" }, { "1" }, { "number" })
		if not amountInput then
			return
		end
		amount = tonumber(amountInput[1])
	end

	local cellMenu = {}
	for i = 1, #cellData do
		table.insert(cellMenu, cellData[i].name)
	end
	table.insert(cellMenu, "✔️ All Cells")

	local cellChoice = gg.choice(cellMenu, nil, "Apply to which cell?")
	if not cellChoice then
		return
	end

	if cellChoice == #cellMenu then
		for i = 1, 4 do
			applyRewardsToCell(cachedBaseAddresses[i], cellData[i], finalCodeList, amount)
		end
		gg.toast("✅ Applied to ALL cells!")
	else
		applyRewardsToCell(cachedBaseAddresses[cellChoice], cellData[cellChoice], finalCodeList, amount)
		gg.toast("✅ Applied to " .. cellData[cellChoice].name)
	end
end

local function handleWarMenu()
	local names = {}
	for _, atk in ipairs(warAttacks) do
		table.insert(names, atk[1])
	end

	local selection = gg.multiChoice(names, nil, "Select War Attacks/Presets:")
	if not selection then
		return
	end

	local finalCodes = {}
	for idx, isSelected in pairs(selection) do
		if isSelected then
			local attackInfo = warAttacks[idx]
			local itemList = attackInfo[2]
			for _, itemName in ipairs(itemList) do
				local code = warItemMap[itemName]
				if code then
					table.insert(finalCodes, code)
				end
			end
		end
	end

	if #finalCodes == 0 then
		gg.alert("No items found for selection.")
	else
		askCellAndApply(finalCodes)
	end
end

local function handleCategory(catKey)
	local category = itemDatabase[catKey]
	local mode = gg.choice({ "Apply ALL items in " .. category.name, "Select specific items" }, nil, category.name)

	local codesToApply = {}

	if not mode then
		return
	end

	if mode == 1 then
		for _, item in ipairs(category.items) do
			table.insert(codesToApply, item.c)
		end
	else
		local itemNames = {}
		for _, item in ipairs(category.items) do
			table.insert(itemNames, item.n)
		end

		local selection = gg.multiChoice(itemNames, nil, "Select items to include in cycle:")
		if not selection then
			return
		end

		for i, item in ipairs(category.items) do
			if selection[i] then
				table.insert(codesToApply, item.c)
			end
		end
	end

	if #codesToApply > 0 then
		askCellAndApply(codesToApply)
	end
end

function itemvu()
	if not cachedBaseAddresses then
		cachedBaseAddresses = findAllCellBases()
		if not cachedBaseAddresses then
			gg.alert("❌ Failed to find cell bases.")
			return
		end
	else
		gg.toast("Using cached cell base addresses.")
	end

	while true do
		local fixedAmountTxt = "🔴 Set fixed amount"
		if fixedAmount then
			fixedAmountTxt = "🟢 Fixed amount = " .. fixedAmount
		end

		local menuOptionsList = {
			"🔙 Back",
			fixedAmountTxt,
			"♻️ Revert Factory",
			"⚔️ War Items Presets",
			"🏢 Capital Expansion Items",
			"🏖️ Beach Expansion Items",
			"⛰️ Mountain Expansion Items",
			"📂 Storage Expansion Items",
			"👹 Vu Items",
			"🌌 Omega Items",
			"🗾 Tokyo Items",
			"🥖 Paris Items",
			"🎡 London Items",
			"🚂 Train Items",
			"📜 Expansion Certificates",
			"⏱️ Store Speed-Up Tokens",
			"🏭 Factory Speed-Up Tokens",
		}

		local choiceIndex = gg.choice(menuOptionsList, nil, "🛠️ Item Tool Menu")

		if not choiceIndex then
			gg.setVisible(false)
			while not gg.isVisible() do
				gg.sleep(100)
			end
		elseif choiceIndex == 2 then
			local currentVal = fixedAmount or 1
			local input = gg.prompt({ "Set fixed quantity (0 or empty to disable):" }, { currentVal }, { "number" })
			if input then
				local val = tonumber(input[1])
				if val and val > 0 then
					fixedAmount = val
					gg.toast("Fixed amount set to " .. val)
				else
					fixedAmount = nil
					gg.toast("Fixed amount disabled")
				end
			end
		elseif choiceIndex == 1 then
			return
		elseif choiceIndex == 3 then
			gg.alert("Visit war arena and return")
		elseif choiceIndex == 4 then
			handleWarMenu()
		else
			local map = {
				[5] = "capital",
				[6] = "beach",
				[7] = "mountain",
				[8] = "storage",
				[9] = "vu",
				[10] = "omega",
				[11] = "tokyo",
				[12] = "paris",
				[13] = "london",
				[14] = "train",
				[15] = "cert",
				[16] = "store_token",
				[17] = "factory_token",
			}

			local key = map[choiceIndex]
			if key then
				handleCategory(key)
			end
		end
	end
end

function menup()
	gg.hideUiButton()
	while true do
		local titleHeader = "• Main Menu • | LibreScript - 1.4"
		local menuItens = {
			"🚪 Exit Script",
			"📄 View Limits",
			"💰 Currencies",
			"🎫 Vu & Mayor Pass",
			"🪖 War Class",
			"🎴 Cards",
			"🗼 Complete CoM Tasks",
			"🏭 Production Settings",
			"🏢 Building Class",
			"🪟 View & UI Control",
			"👥 Population",
			"🗃️ Depot Class",
			"📦 Storage Class",
			"🌎 Unlock All Regions",
			"⏭️ Skip Initial Tutorial",
			"🔁 Return to GameGuardian",
		}

		local opcao = gg.choice(menuItens, nil, titleHeader)

		if opcao == nil then
			gg.setVisible(false)
			while not gg.isVisible() do
				gg.sleep(100)
			end
		elseif opcao == 1 then
			os.exit()
		elseif opcao == 2 then
			limits()
		elseif opcao == 3 then
			option5Menu()
		elseif opcao == 4 then
			vuMayorPassMenu()
		elseif opcao == 5 then
			warMenu()
		elseif opcao == 6 then
			cards()
		elseif opcao == 7 then
			completetask()
		elseif opcao == 8 then
			factorySettings()
		elseif opcao == 9 then
			buildingMenu()
		elseif opcao == 10 then
			Layoutmenu()
		elseif opcao == 11 then
			Population()
		elseif opcao == 12 then
			depotmenu()
		elseif opcao == 13 then
			storageMenu()
		elseif opcao == 14 then
			UnlockAllRegions()
		elseif opcao == 15 then
			skipTutorial()
		elseif opcao == 16 then
			gg.showUiButton()
			while true do
				if gg.isClickedUiButton() then
					gg.hideUiButton()
					break
				end
				gg.sleep(100)
			end
		end
	end
end

function cardsMenu()
	while true do
		local options = {
			"🔙 Back",
			"⁉️ HELP",
			"🏭 Set Cards to Factory",
			"🔄 Revert Factory",
		}

		local choice = gg.choice(options, nil, "?? Cards Menu")

		if choice == nil then
			gg.setVisible(false)
			while not gg.isVisible() do
				gg.sleep(100)
			end
		elseif choice == 1 then
			return
		elseif choice == 2 then
			gg.alert([[
To collect those cards, follow these steps:

start producing 1 common card and 1 legendary card and 1 rare card, or just 1 type of card if you don't want the other two ... (I made the script change the production quantity so you should receive 1120 Common cards, 980 legendary cards and 980 rare cards)

After collecting, open the monster and collect the cards (you will receive 140 of each card in the game. BUT YOU WONT RECEIVE HISSY FIT AND SHIELD BUSTER CARDS, IF YOU WANT THESE USE RAW MATERIAL METHOD!!!)

after that, go produce again 1 time of each type of card (NEVER collect twice, the process is to collect only one common, one legendary and one rare card and open the monster, if you accidentally collect 2 times, do not open the monster under any circumstances, contact admins.)

(You can know if you have collected more if you press above the war card in the factory, if you see that you have more than 1120 Common cards or more than 980 legendary or rare cards, you have collected more)

after you do the process twice you will have 280 cards of each common and legendary and rare, you can stop here and use 40 request to go up to level 7, then repeat the process for level 14 etc...

Or you can already collect 840 (enough for level 20 using 40 request) legendary, common and rare cards (doing the process of producing 1, opening the monster, collecting cards, producing 1 again etc...) if you want this option, you will have to do the process 6 times for all cards)
]])
		elseif choice == 3 then
			runCombinedModification()
		elseif choice == 4 then
			revertfactttt()
		end
	end
end

function vuMayorPassMenu()
	while true do
		gg.clearResults()
		local choice = gg.choice({
			"🔙 Back",
			"✂️ Item Tool (Vu Pass Version)",
			"🔓 Unlock Vu Pass Basic",
			"🏢 Unlock Mayor Pass Basic",
			"❄️ Re-unlock and Freeze Vu Pass",
			"❄️ Re-unlock and Freeze Mayor Pass",
		}, nil, "Unlock Vu & Mayor Pass Options")

		if choice == nil then
			gg.setVisible(false)
			while not gg.isVisible() do
				gg.sleep(100)
			end
		elseif choice == 1 then
			return
		elseif choice == 2 then
			itemvu()
		elseif choice == 3 then
			unlockVuPassBasic()
		elseif choice == 4 then
			unlockMayorPassBasic()
		elseif choice == 5 then
			freezeVuPass()
		elseif choice == 6 then
			freezeMayorPass()
		end
	end
end

function depotmenu()
	while true do
		gg.clearResults()
		local choice = gg.choice({
			"🔙 Back",
			"🏢 Hack Daniel Depot",
			"🛒 Selling Tool",
		}, nil, "Depot Options")

		if choice == nil then
			gg.setVisible(false)
			while not gg.isVisible() do
				gg.sleep(100)
			end
		elseif choice == 2 then
			startdaniel()
		elseif choice == 3 then
			sellingMenu()
		elseif choice == 1 then
			return
		end
	end
end

function warMenu()
	while true do
		gg.clearResults()
		local options = {
			"🔙 Back",
			"❌ Exclude War Item Request",
			"⚔️ War Boosters through Raw Material",
			"🪖 War Boosters through Buildings",
		}
		local choice = gg.choice(options, nil, "⚔️ War Class")

		if choice == nil then
			gg.setVisible(false)
			while not gg.isVisible() do
				gg.sleep(100)
			end
		elseif choice == 1 then
			return
		elseif choice == 2 then
			excludewar()
		elseif choice == 3 then
			boostEditor()
		elseif choice == 4 then
			gg.alert([[
Make sure you don't have these buildings placed, or else they will disappear.

Ghost Portal (Level 3)
Ghost Portal (Level 4)
Ghost Portal (Level 5)
Ghost Portal (Level 6)
Ghost Portal (Level 7)
Ghost Portal (Level 8)
Ghost Portal (Level 9)
Ghost Portal (Level 10)
Ghost Portal (Level 11)
Ghost Portal (Level 12)
Ghost Portal (Level 13)
Ghost Portal (Level 14)
Ghost Portal (Level 15)
Ghost Portal (Level 16)
Ghost Portal (Level 17)
Ghost Portal (Level 18)
Ghost Portal (Level 19)
Ghost Portal (Level 20)
Ghost Portal (Level 21)
Ghost Portal (Level 22)
]])
			warBoostersMenu()
		end
	end
end

function buildingMenu()
	gg.clearResults()
	gg.clearList()

	while true do
		local options = {
			"🔙 Back",

			"🏗 Building Tool (replace/factory/pass method)",
			"🏘️ Move Selected Buildings into One Spot",

			"🏞️ Offland Building",
			"🚜 Bulldoze / Store All Buildings",

			"🏠 Instant Residence",
			"☢️ Nuke Your Entire City",
		}

		if bulldozerState.isOn then
			options[5] = "🚜 Bulldoze/Store All Buildings ??"
		else
			options[5] = "🚜 Bulldoze / Store All Buildings 🔴"
		end

		local choice = gg.choice(options, nil, "🏢 Building Class")

		if choice == nil then
			gg.setVisible(false)
			while not gg.isVisible() do
				gg.sleep(100)
			end
		elseif choice == 1 then
			gg.clearResults()
			gg.clearList()
			return
		elseif choice == 2 then
			runBuildingTool()
		elseif choice == 3 then
			buildingMoverMenu()
		elseif choice == 4 then
			MainRegion()
		elseif choice == 5 then
			if not bulldozerState.isInitialized then
				local success = initializeBulldozer()
				if not success then
					goto continue_loop
				end
			end

			if bulldozerState.isOn then
				gg.setValues(bulldozerState.originalValues)
				bulldozerState.isOn = false
				gg.toast("Reverted")
				gg.setVisible(false)
			else
				local valuesToWrite = {}
				for _, item in ipairs(bulldozerState.originalValues) do
					table.insert(valuesToWrite, { address = item.address, flags = item.flags, value = -1 })
				end
				gg.setValues(valuesToWrite)
				bulldozerState.isOn = true
				gg.toast("Done")
				gg.setVisible(false)
			end
		elseif choice == 6 then
			instantResidencesMenu()
		elseif choice == 7 then
			Nuke_startProcess()
		end
		::continue_loop::
	end
end

function clearstorage()
	while true do
		gg.clearResults()
		local choice = gg.choice({
			"🔙 Back",
			"🗑️ Delete Item Categories",
			"💣 Delete Individual War Items",
		}, nil, "🧹 Storage Cleaner")

		if choice == nil then
			gg.setVisible(false)
			while not gg.isVisible() do
				gg.sleep(100)
			end
		elseif choice == 2 then
			storageWipe_showMenu()
		elseif choice == 3 then
			deleteIndividualWarItems()
		elseif choice == 1 then
			return
		end
	end
end

function storageMenu()
	while true do
		gg.clearResults()
		local options = {
			"🔙 Back",
			"➖ Negative Storage",
			"📦 Max City Storage",
			"🗄️ Max Material Storage",
			"🔋 Max Omega Storage",
			"🏦 Max NeoBank",
			"🚮 Clear Items",
		}

		local choice = gg.choice(options, nil, "📦 Storage Class")

		if choice == nil then
			gg.setVisible(false)
			while not gg.isVisible() do
				gg.sleep(100)
			end
		elseif choice == 1 then
			return
		elseif choice == 2 then
			negstorage()
		elseif choice == 3 then
			maxstorage()
		elseif choice == 4 then
			maxmaterialstorage()
		elseif choice == 5 then
			maxdepo()
		elseif choice == 6 then
			maxbank()
		elseif choice == 7 then
			clearstorage()
		end
	end
end

function factorySettings()
	while true do
		gg.clearResults()
		local menuItems = {
			"🔙 Back",
			"🛒 Upgrade Stores Level",
			"🚀 Produce Other Items",
			menuOptions.productionAmount.text,
			menuOptions.timeRemoved.text,
			menuOptions.xpModified.text,
			menuOptions.removeNeed.text,
		}
		local choice = gg.choice(menuItems, nil, "🏗️ Production Settings")

		if choice == nil then
			gg.setVisible(false)
			while not gg.isVisible() do
				gg.sleep(100)
			end
		elseif choice == 2 then
			storesupgrade()
		elseif choice == 3 then
			itemToolMenu()
		elseif choice == 4 then
			setamountcool()
		elseif choice == 5 then
			toggleProductionTime()
		elseif choice == 6 then
			toggleXpFromMetal()
		elseif choice == 7 then
			toggleRemoveNeed()
		elseif choice == 1 then
			return
		end
	end
end

function cards()
	while true do
		gg.clearResults()
		local options = {
			"🔙 Back",
			"🚆 Train Cards Through Vu Pass",
			"🔁 40 Request and Free War Card Upgrade",
			"⚙️ Turn Raw Material into War Cards",
			"🧹 Delete War Cards",
		}

		local choice = gg.choice(options, nil, "🚨 Cards Menu")

		if choice == nil then
			gg.setVisible(false)
			while not gg.isVisible() do
				gg.sleep(100)
			end
		elseif choice == 1 then
			return
		elseif choice == 2 then
			mainMenuXXX()
		elseif choice == 3 then
			warcardUpgrade40()
		elseif choice == 4 then
			warcards()
		elseif choice == 5 then
			Clearwacards()
		end
	end
end

menup()

-- Injected Memory Cleaner by Proxy --
if _v and type(_v) == "table" and _v[25] then
	_v[25]("collect")
	_v = nil
end
collectgarbage("collect")
