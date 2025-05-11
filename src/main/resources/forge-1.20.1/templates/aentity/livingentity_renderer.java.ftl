<#--
 # MCreator (https://mcreator.net/)
 # Copyright (C) 2012-2020, Pylo
 # Copyright (C) 2020-2022, Pylo, opensource contributors
 #
 # This program is free software: you can redistribute it and/or modify
 # it under the terms of the GNU General Public License as published by
 # the Free Software Foundation, either version 3 of the License, or
 # (at your option) any later version.
 #
 # This program is distributed in the hope that it will be useful,
 # but WITHOUT ANY WARRANTY; without even the implied warranty of
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 # GNU General Public License for more details.
 #
 # You should have received a copy of the GNU General Public License
 # along with this program.  If not, see <https://www.gnu.org/licenses/>.
 #
 # Additional permission for code generator templates (*.ftl files)
 #
 # As a special exception, you may create a larger work that contains part or
 # all of the MCreator code generator templates (*.ftl files) and distribute
 # that work under terms of your choice, so long as that work isn't itself a
 # template for code generation. Alternatively, if you modify or redistribute
 # the template itself, you may (at your option) remove this special exception,
 # which will cause the template and the resulting code generator output files
 # to be licensed under the GNU General Public License without this special
 # exception.
-->

<#-- @formatter:off -->

<#include "../procedures.java.ftl">

package ${package}.client.renderer;

import ${package}.client.renderer.utils.OffsetVertexConsumer;

import com.mojang.math.Axis;

import net.minecraftforge.client.ForgeRenderTypes;
import java.util.*;

<#assign shadowRadius = "this.shadowRadius = " + data.modelShadowSize + "f;">

public class ${name}Renderer extends GeoEntityRenderer<${name}Entity> {

    public static Set<GeoBone> HIDDEN_BONE_CACHE = new HashSet<GeoBone>();

    <#if data.mainHandItemBone?has_content || data.offHandItemBone?has_content>
    private static final String RIGHT_HAND = "${data.mainHandItemBone}";
    private static final String LEFT_HAND = "${data.offHandItemBone}";
    protected ItemStack mainHandItem;
    protected ItemStack offhandItem;
    </#if>

    public ${name}Renderer(EntityRendererProvider.Context renderManager) {
    super(renderManager, new ${name}Model());
    ${shadowRadius}
    <#if data.mobModelGlowTexture?has_content>
    this.addRenderLayer(new ${name}Layer(this));
    </#if>
    <#if data.mainHandItemBone?has_content || data.offHandItemBone?has_content>
    // Add held item rendering
        addRenderLayer(new BlockAndItemGeoLayer<>(this) {
            private float heldItemScale = 1.0f;

            @Nullable
            @Override
            protected ItemStack getStackForBone(GeoBone bone, ${name}Entity entity) {
                // Retrieve the items in the entity's hands for the relevant bone
                return switch (bone.getName()) {
                    case LEFT_HAND -> entity.isLeftHanded() ?
                            ${name}Renderer.this.mainHandItem : ${name}Renderer.this.offhandItem;
                    case RIGHT_HAND -> entity.isLeftHanded() ?
                            ${name}Renderer.this.offhandItem : ${name}Renderer.this.mainHandItem;
                    default -> null;
                };
            }

            @Override
            protected ItemDisplayContext getTransformTypeForStack(GeoBone bone, ItemStack stack, ${name}Entity entity) {
                // Apply the camera transform for the given hand
                return switch (bone.getName()) {
                    case LEFT_HAND, RIGHT_HAND -> ItemDisplayContext.THIRD_PERSON_RIGHT_HAND;
                    default -> ItemDisplayContext.NONE;
                };
            }

            // Do some quick render modifications depending on what the item is
            @Override
            protected void renderStackForBone(PoseStack poseStack, GeoBone bone, ItemStack stack, ${name}Entity entity,
                                              MultiBufferSource bufferSource, float partialTick, int packedLight, int packedOverlay) {
                if (stack == ${name}Renderer.this.mainHandItem) {
                    poseStack.mulPose(Axis.XP.rotationDegrees(-90f));

                    if (stack.getItem() instanceof ShieldItem)
                        poseStack.translate(0, 0.125, -0.25);
                }
                else if (stack == ${name}Renderer.this.offhandItem) {
                    poseStack.mulPose(Axis.XP.rotationDegrees(-90f));

                    if (stack.getItem() instanceof ShieldItem) {
                        poseStack.translate(0, 0.125, 0.25);
                        poseStack.mulPose(Axis.YP.rotationDegrees(180));
                    }
                }

                <#if hasProcedure(data.heldItemScale)>
                        Level world = entity.level();
                        double x = entity.getX();
                        double y = entity.getY();
                        double z = entity.getZ();
                        heldItemScale = (float) <@procedureOBJToNumberCode data.heldItemScale/>;
                <#else>
                        heldItemScale = ${data.heldItemScale.getFixedValue()}f;
                </#if>
                poseStack.scale(heldItemScale, heldItemScale, heldItemScale);

                super.renderStackForBone(poseStack, bone, stack, entity, bufferSource, partialTick, packedLight, packedOverlay);
            }
        });
     </#if>
    }

    @Override
    public RenderType getRenderType(${name}Entity animatable, ResourceLocation texture, MultiBufferSource bufferSource, float partialTick) {
        <#if data.renderType?? && data.renderType == "UNLIT_TRANSLUCENT">
        return ForgeRenderTypes.getUnlitTranslucent(texture);
        <#else>
        return RenderType.entityTranslucent(texture);
        </#if>
	}

	@Override
	public void preRender(PoseStack poseStack, ${name}Entity entity, BakedGeoModel model, MultiBufferSource bufferSource, VertexConsumer buffer, boolean isReRender, float partialTick, int packedLight, int packedOverlay, float red, float green,
			float blue, float alpha) {
			<#if data.mainHandItemBone?has_content || data.offHandItemBone?has_content>
              this.mainHandItem = entity.getMainHandItem();
              this.offhandItem = entity.getOffhandItem();
            </#if>
			<#if data.visualScale??>
			<#if hasProcedure(data.visualScale)>
        		Level world = entity.level();
        		double x = entity.getX();
        		double y = entity.getY();
        		double z = entity.getZ();
        		float scale = (float) <@procedureOBJToNumberCode data.visualScale/>;

        	<#else>
        		float scale = ${data.visualScale.getFixedValue()}f;
        	</#if>
                this.scaleHeight = scale;
                this.scaleWidth = scale;
            </#if>

        // Check if we should temporarily add any RenderLayers for custom textures
        for (GeoRenderLayer layerToAdd : entity.boneTextureLayers.values()) {
            if (!this.getRenderLayers().contains(layerToAdd)) {
                this.addRenderLayer(layerToAdd);
            }
        }

        // Refresh which bones should be hidden on this render pass.
        if (!isReRender) {
            hideBones(entity.hiddenBones);
        }

        super.preRender(poseStack, entity, model, bufferSource, buffer, isReRender, partialTick, packedLight, packedOverlay, red, green, blue, alpha);
	}

    private OffsetVertexConsumer cachedOffsetVertexConsumer = new OffsetVertexConsumer();
    private ${name}Entity.BoneUVOffset uvOffset;

    private BoneTextureLayer cachedBoneTextureLayer;

    @Override
    public void applyRenderLayers(PoseStack poseStack, ${name}Entity animatable, BakedGeoModel model, RenderType renderType, MultiBufferSource bufferSource,
    								   VertexConsumer buffer, float partialTick, int packedLight, int packedOverlay) {
        for (GeoRenderLayer<${name}Entity> renderLayer : getRenderLayers()) {
            if (renderLayer instanceof BoneTextureLayer boneTextureLayer)
            {
                this.cachedBoneTextureLayer = boneTextureLayer;
                if (this.cachedBoneTextureLayer.useRendererDefaultBoneSettings) {
                    hideBones(animatable.hiddenBones);
                }
                else {
                    hideBones(boneTextureLayer.hiddenBones);
                }
            }
            else {
                this.cachedBoneTextureLayer = null;
            }
            renderLayer.render(poseStack, animatable, model, renderType, bufferSource, buffer, partialTick, packedLight, packedOverlay);
        }
    }

    @Override
    public void renderRecursively(PoseStack poseStack, ${name}Entity entity, GeoBone bone, RenderType renderType, MultiBufferSource bufferSource,
                                  VertexConsumer buffer, boolean isReRender, float partialTick, int packedLight,
                                  int packedOverlay, float red, float green, float blue, float alpha) {

        this.uvOffset = null;
        if (entity.boneUVOffsets != null && entity.boneUVOffsets.containsKey(bone.getName())) {
            this.uvOffset = entity.boneUVOffsets.get(bone.getName());
        }

        /*
        if (isReRender && this.cachedBoneTextureLayer != null) {
            if (!this.cachedBoneTextureLayer.hasBone(bone.getName())) {
                // This is the processor for not rendering certain bones on the texture override layers.
                // This will also prevent the children of excluded bones from rendering.
                return;
            }
        }
        else if (entity.hiddenBones != null && entity.hiddenBones.contains(bone.getName())) {
            // This is the processor for not rendering any of the bones on the character.
            // This will also prevent its child bones from rendering.
            return;
        }
        */

        if (this.uvOffset != null) {
            this.cachedOffsetVertexConsumer.setup(buffer, this.uvOffset.uOffset(), this.uvOffset.vOffset());
            super.renderRecursively(poseStack, entity, bone, renderType, bufferSource, this.cachedOffsetVertexConsumer, isReRender, partialTick, packedLight, packedOverlay, red, green, blue, alpha);
        } else {
            super.renderRecursively(poseStack, entity, bone, renderType, bufferSource, buffer, isReRender, partialTick, packedLight, packedOverlay, red, green, blue, alpha);
        }
    }

    private void hideBones(Map<String, Boolean> hiddenBones) {
        // First, reset bones for fresh rendering pass.
        for (GeoBone bone : HIDDEN_BONE_CACHE) {
            if (bone != null) {
                bone.setHidden(false);
                bone.setChildrenHidden(false);
            }
        }

        // Now loop through and hide the ones from the provided hash set.
        if (!hiddenBones.isEmpty()) {
            for (Map.Entry<String, Boolean> hiddenBone : hiddenBones.entrySet()) {
                Optional<GeoBone> boneToHide = model.getBone(hiddenBone.getKey());
                if (boneToHide.isPresent()) {
                    boneToHide.get().setHidden(true);
                    // Only hide children if "recursive" is true.
                    boneToHide.get().setChildrenHidden(hiddenBone.getValue());
                    HIDDEN_BONE_CACHE.add(boneToHide.get());
                }
            }
        }
    }

    @Override
    public void renderFinal(PoseStack poseStack, ${name}Entity animatable, BakedGeoModel model, MultiBufferSource bufferSource, VertexConsumer buffer, float partialTick, int packedLight,
           							int packedOverlay, float red, float green, float blue, float alpha) {
        super.renderFinal(poseStack, animatable, model, bufferSource, buffer, partialTick, packedLight, packedOverlay, red, green, blue, alpha);
        this.cachedBoneTextureLayer = null;

        // Clean up the render layers that are no longer needed.
        for (GeoRenderLayer layerToRemove : animatable.boneTextureLayers.values()) {
            this.renderLayers.getRenderLayers().remove(layerToRemove);
        }
    }

    <#if data.disableDeathRotation>
    @Override
	protected float getDeathMaxRotation(${name}Entity entityLivingBaseIn) {
		return 0.0F;
	} 
    </#if>
}