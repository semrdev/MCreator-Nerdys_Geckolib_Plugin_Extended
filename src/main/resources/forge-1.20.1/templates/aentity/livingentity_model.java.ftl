package ${package}.entity.model;

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

    <#if data.headMovement>
    @Override
    public void setCustomAnimations(${name}Entity animatable, long instanceId, AnimationState animationState) {
	    CoreGeoBone head = getAnimationProcessor().getBone("${data.groupName}");
	    if (head != null) {
		    EntityModelData entityData = (EntityModelData) animationState.getData(DataTickets.ENTITY_MODEL_DATA);
			head.setRotX(entityData.headPitch() * Mth.DEG_TO_RAD);
			head.setRotY(entityData.netHeadYaw() * Mth.DEG_TO_RAD);
		}

        // This is the processor for hiding any of the bones on the character.
        if (animatable.hiddenBones != null) {
            for (String boneName : animatable.hiddenBones) {
                if (boneName != null) {
                    Optional<GeoBone> boneToHide = this.getBone(boneName);
                    if (boneToHide.isPresent()) {
                        boneToHide.get().setHidden(true);
                        boneToHide.get().setChildrenHidden(true);
                    }
                }
            }
            animatable.hiddenBones.clear();
        }

        // This is the processor for showing any of the bones on the character.
        if (animatable.shownBones != null) {
            for (String boneName : animatable.shownBones) {
                if (boneName != null) {
                    Optional<GeoBone> boneToShow = this.getBone(boneName);
                    if (boneToShow.isPresent()) {
                        boneToShow.get().setHidden(false);
                        boneToShow.get().setChildrenHidden(false);
                    }
                }
            }
            animatable.shownBones.clear();
        }
    }
    </#if>
}