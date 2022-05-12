AddCSLuaFile()

ENT.Spawnable = false
ENT.Base = "base_anim"
ENT.Type = "anim"

function ENT:Initialize()
    self:SetCollisionGroup(COLLISION_GROUP_WORLD)
    self:SetSolid(SOLID_NONE)
    --self:AddEffects(EF_BONEMERGE)
    if CLIENT and GetConVar("ba2_cl_zomdecals"):GetBool() then
        for i = 1,5 do
            util.DecalEx(Material(util.DecalMaterial("Blood")),self,self:GetPos() + Vector(0,0,math.random(20,80)),VectorRand(),Color(255,255,255),1,1)
        end

        -- timer.Simple(1,function()
        --     print(self:EntIndex(),"\n\nWorld bones:")
        --     for i = 1, self:GetBoneCount() do
        --         local pos = self:GetBonePosition(i-1)
        --         if pos == self:GetPos() and self:GetBoneMatrix(i-1) ~= nil then
        --             pos = self:GetBoneMatrix(i-1):GetTranslation()
        --         else
        --             print("Invalid bone: "..self:GetBoneName(i-1))
        --         end

        --         if pos == game.GetWorld():GetPos() then
        --             print(self:GetBoneName(i-1),pos)
        --         end
        --     end
        -- end) -- Memorial to the time lost trying to fix the Spaghetti Wrists
    end
end

-- function ENT:Think()
--     if CLIENT then
--         local p = LocalPlayer()
--         local visTrace = util.TraceLine({
--             Start = self:GetPos(),
--             EndPos = EyePos(),
--             filter = self
--         })
--         debugoverlay.Line(visTrace.StartPos,visTrace.HitPos)
--         self:SetNoDraw(visTrace.HitEntity == p)
--     end
-- end