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

    private final ResourceLocation texture;
    private final Set<String> bones = new HashSet<String>();
    private final RenderType renderType;

    public BoneTextureLayer(GeoRenderer<T> renderer, ResourceLocation texture, String[] bones) {
        super(renderer);

        this.texture = texture;
        this.addBones(bones);
        this.renderType = RenderType.entityCutoutNoCull(this.texture);
    }

    public boolean addBones(String[] bones) {
        this.bones.addAll(Arrays.asList(bones));
        return hasBones();
    }

    public boolean addBone(String bone) {
        this.bones.add(bone);
        return hasBones();
    }

    public boolean removeBones(String[] bones) {
        this.bones.removeAll(Arrays.asList(bones));
        return hasBones();
    }

    public boolean removeBone(String bone) {
        this.bones.remove(bone);
        return hasBones();
    }

    public boolean hasBones() {
        return !this.bones.isEmpty();
    }

    public boolean hasBone(String boneName) {
        return this.bones.contains(boneName);
    }

    @Override
    public void render(PoseStack poseStack, T animatable, BakedGeoModel bakedModel, RenderType renderType, MultiBufferSource bufferSource, VertexConsumer buffer, float partialTick, int packedLight, int packedOverlay) {
        getRenderer().reRender(getDefaultBakedModel(animatable), poseStack, bufferSource, animatable,
                               this.renderType, bufferSource.getBuffer(this.renderType), partialTick,
                               packedLight, OverlayTexture.NO_OVERLAY, 1, 1, 1, 1);
    }
}