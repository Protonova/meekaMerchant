  --++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
  --						Release 2 							  --
  -- 						06.01.2011							  --
  -- 				 Protonova of Rexxar - US					  --
  --															  --
  -- Original code based off of Nightcracker's ncImprovedMerchant --
  -- and TUKUI's merchant module.								  --
  --++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--


--[[----------------CONFIG---------------------
NOTE: These condictional variables can be set to either true or false. Nothing else.

sellgrays
	true: Will automatically sell grays when visiting a vendor.
	false: Won't automatically vendor gray quality items.

autorepair
	true: Will automatically repair when visiting a vendor.
	false: Won't repair automatically when visiting a vendor.

guildrepair
	true: Will automatically repair using guild funds while at a vendor.
	false: Won't repair automatically with guild funds while at a vendor.
]]

local sellgrays = true
local autorepair = true
local guildrepair = true
------------------END of CONFIG---------------


local f = CreateFrame("Frame")
f:SetScript("OnEvent", function()
	if sellgrays then
		local c = 0
		for b=0,4 do
			for s=1,GetContainerNumSlots(b) do
				local l,lid = GetContainerItemLink(b, s), GetContainerItemID(b, s)
				if l and lid then
					local p = select(11, GetItemInfo(l))*select(2, GetContainerItemInfo(b, s))
					if sellgrays and select(3, GetItemInfo(l))==0 then
						UseContainerItem(b, s)
						PickupMerchantItem()
						c = c+p
					end
				end
			end
		end
		if c>0 then
			local g, s, c = math.floor(c/10000) or 0, math.floor((c%10000)/100) or 0, c%100
			DEFAULT_CHAT_FRAME:AddMessage("Your vendor trash has been sold and you earned |cffffffff"..g.."|cffffd700g |cffffffff"..s.."|cffc7c7cfs|cffffffff "..c.."|cffeda55fc|r.",255,255,0)
		end
	end
	if not IsShiftKeyDown() then
		if CanMerchantRepair() and autorepair then	
			local cost, possible = GetRepairAllCost()
			
			-- try to guild repair first
			if ((cost > 0) and guildrepair and IsInGuild() and CanGuildBankRepair()) then
				RepairAllItems(1);
				
				-- get costs again
				cost, possible = GetRepairAllCost()
				DEFAULT_CHAT_FRAME:AddMessage("Your items have been repaird from guild funds.",255,255,0)
			end
			
			if cost>0 then
				if possible then
					RepairAllItems()
					local c = cost%100
					local s = math.floor((cost%10000)/100)
					local g = math.floor(cost/10000)
					DEFAULT_CHAT_FRAME:AddMessage("Your items have been repaired for: |cffffffff"..g.."|cffffd700g |cffffffff"..s.."|cffc7c7cfs|cffffffff "..c.."|cffeda55fc|r.",255,255,0)
				else
					DEFAULT_CHAT_FRAME:AddMessage("You don't have enough money for repair!",255,0,0)
				end
			end
		end
	end
end)
f:RegisterEvent("MERCHANT_SHOW")