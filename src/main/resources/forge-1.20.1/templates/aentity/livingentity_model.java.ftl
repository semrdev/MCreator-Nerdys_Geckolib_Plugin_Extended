package ${package}.entity.model;

<#include "../procedures.java.ftl">
import software.bernie.geckolib.core.animation.AnimationState;

public class ${name}Model extends GeoModel<${name}Entity> {
    @Override
    public ResourceLocation getAnimationResource(${name}Entity entity) {
        return new ResourceLocation("${modid}", "animations/${data.model?replace(".geo.json", "")}.animation.json");
    }

    @Override
    public ResourceLocation getModelResource(${name}Entity entity) {
        return new ResourceLocation("${modid}", "geo/${data.model}");
    }

    @Override
    public ResourceLocation getTextureResource(${name}Entity entity) {
        return new ResourceLocation("${modid}", "textures/entities/" + entity.getTexture() + ".png");
    }

    <#if hasProcedure(data.headMovementProcedure) || data.headMovement>
    @Override
    public void setCustomAnimations(${name}Entity entity, long instanceId, AnimationState animationState) {
	    CoreGeoBone head = getAnimationProcessor().getBone("${data.groupName}");
	    if (head != null) {
	        <#if hasProcedure(data.headMovementProcedure)>
	            int x = entity.blockPosition().getX();
                int y = entity.blockPosition().getY();
                int z = entity.blockPosition().getZ();
                Level world = entity.level();
	            if (<@procedureOBJToConditionCode data.headMovementProcedure/>){
	        </#if>

		    EntityModelData entityData = (EntityModelData) animationState.getData(DataTickets.ENTITY_MODEL_DATA);
			head.setRotX(entityData.headPitch() * Mth.DEG_TO_RAD);
			head.setRotY(entityData.netHeadYaw() * Mth.DEG_TO_RAD);

	        <#if hasProcedure(data.headMovementProcedure)>
	            }
	        </#if>
		}

    }
    </#if>
}