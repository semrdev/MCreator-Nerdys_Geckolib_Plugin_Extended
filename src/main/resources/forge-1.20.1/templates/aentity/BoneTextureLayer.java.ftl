package ${package}.client.renderer;

import com.mojang.blaze3d.vertex.PoseStack;
import com.mojang.blaze3d.vertex.VertexConsumer;
import it.unimi.dsi.fastutil.ints.IntIntPair;
import it.unimi.dsi.fastutil.objects.Object2ObjectOpenHashMap;
import net.minecraft.client.renderer.MultiBufferSource;
import net.minecraft.client.renderer.RenderType;
import net.minecraft.client.renderer.entity.EntityRendererProvider;
import net.minecraft.resources.ResourceLocation;
import net.minecraft.world.entity.Entity;
import org.jetbrains.annotations.Nullable;
import org.joml.Matrix4f;
import org.joml.Vector3f;
import org.joml.Vector4f;
import software.bernie.geckolib.cache.object.*;
import software.bernie.geckolib.core.animatable.GeoAnimatable;
import software.bernie.geckolib.model.GeoModel;
import software.bernie.geckolib.util.RenderUtils;

import java.util.Map;

public class BoneTextureLayer<T extends GeoEntity> extends GeoRenderLayer<T> {

    private ResourceLocation texture;
    private RenderType renderType;

    public Boolean useRendererDefaultBoneSettings = true;
    public final Map<String, Boolean> hiddenBones = new HashMap<>();

    public BoneTextureLayer(GeoRenderer<T> renderer, ResourceLocation texture, String renderType) {
        super(renderer);
        setTextureAndRenderType(texture, renderType);
    }

    private RenderType GetRenderType(String renderType) {
        if (renderType == "TRANSLUCENT") {
            return RenderType.entityTranslucent(this.texture);
        }
        else if (renderType == "UNLIT_TRANSLUCENT") {
            return ForgeRenderTypes.getUnlitTranslucent(texture);
        }
        else if (renderType == "GLOW") {
            return RenderType.eyes(this.texture);
        }
        else {
            return RenderType.entityCutoutNoCull(this.texture);
        }
    }

    public void setTextureAndRenderType(ResourceLocation texture, String renderType) {
        if (texture != null) {
            this.texture = texture;
        }
        this.renderType = GetRenderType(renderType);
    }

    public void toggleLayerBones(String bones, Boolean visible, Boolean recursive) {
        String[] boneArray = bones.replaceAll("\\s+", "").split(",");

        for (String bone : boneArray) {
            this.useRendererDefaultBoneSettings = false;
            if (visible) {
                this.hiddenBones.remove(bone);
            }
            else {
                this.hiddenBones.put(bone, recursive);
            }
        }
    }

    public void toggleOverrideDefaultBoneSettings(Boolean override) {
        this.useRendererDefaultBoneSettings = !override;
    }

    @Override
    public void render(PoseStack poseStack, T animatable, BakedGeoModel bakedModel, RenderType renderType, MultiBufferSource bufferSource, VertexConsumer buffer, float partialTick, int packedLight, int packedOverlay) {
        getRenderer().reRender(getDefaultBakedModel(animatable), poseStack, bufferSource, animatable,
                               this.renderType, bufferSource.getBuffer(this.renderType), partialTick,
                               packedLight, OverlayTexture.NO_OVERLAY, 1, 1, 1, 1);
    }
}