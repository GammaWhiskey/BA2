AddCSLuaFile()

ENT.Base = "base_anim"
ENT.Type = "anim"

local bloodMat = util.DecalMaterial("Blood")

function ENT:Initialize()
    if SERVER then
        self:SetModelScale(0.5)
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
        self:GetPhysicsObject():SetMaterial("bloodyflesh")

        local gibLife = GetConVar("ba2_misc_corpselife"):GetFloat()
        if gibLife >= 0 then
            timer.Simple(gibLife,function()
                if IsValid(self) then
                    self:Remove()
                end
            end)
        end

        self.decalConvar = GetConVar("ba2_misc_gibdecals"):GetBool()
    else
        if GetConVar("ba2_cl_lowgibs"):GetBool() then
            local gibModels = {
                "models/props_junk/watermelon01_chunk02a.mdl",
                "models/props_junk/watermelon01_chunk02b.mdl",
                "models/props_junk/watermelon01_chunk01b.mdl",
                "models/gibs/antlion_gib_small_2.mdl",
            }
            self:SetModel(gibModels[math.random(1,#gibModels)])
            self:SetMaterial("models/flesh")
        end
    end
end

function ENT:PhysicsCollide(data,collider)
    -- if CLIENT then
    --     util.DecalEx(bloodMat,data.HitEntity,data.HitPos + data.HitNormal,VectorRand(),Color(255,255,255),.25,.25)
    -- end
    if data.Speed >= 50 then
        self:EmitSound("ba2_gibsplat")
        if self.decalConvar ~= true then return end
        if data.Speed >= 200 then
            util.Decal("Blood",data.HitPos - data.HitNormal,data.HitPos + data.HitNormal)
        end
    end
end

function ENT:OnTakeDamage(dmg)
    if !dmg:IsExplosionDamage() and CurTime() - self:GetCreationTime() >= .01 then
        self:EmitSound("physics/flesh/flesh_squishy_impact_hard"..math.random(1,4)..".wav")
        local eff = EffectData()
        eff:SetOrigin(self:GetPos())
        eff:SetScale(2)
        util.Effect("BloodImpact",eff)

        self:Remove()
    end
end