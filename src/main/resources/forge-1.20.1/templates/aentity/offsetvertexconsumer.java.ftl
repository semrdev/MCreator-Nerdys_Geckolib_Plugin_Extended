package ${package}.client.renderer.utils;

import com.mojang.blaze3d.vertex.VertexConsumer;
import com.mojang.math.Vector3f;

public class OffsetVertexConsumer implements VertexConsumer {
    private VertexConsumer delegate;
    public float uOffset;
    public float vOffset;

    public void setup(VertexConsumer delegate, float uOffset, float vOffset) {
        if (delegate instanceof OffsetVertexConsumer offsetVertexConsumer) {
            this.delegate = offsetVertexConsumer.getDelegate();
        }
        else {
            this.delegate = delegate;
        }
        this.uOffset = uOffset;
        this.vOffset = vOffset;
    }

    public VertexConsumer getDelegate() {
        return this.delegate;
    }

    @Override
    public VertexConsumer vertex(double x, double y, double z) {
        return delegate.vertex(x, y, z);
    }

    @Override
    public  VertexConsumer color(int red, int green, int blue, int alpha) {
        return delegate.color(red, green, blue, alpha);
    }

    @Override
    public VertexConsumer uv(float u, float v) {
        // The main purpose of this wrapper class - to offset the UVs as configured in setup.
        return delegate.uv(u + uOffset, v + vOffset);
    }

    @Override
    public VertexConsumer overlayCoords(int u, int v) {
        return delegate.overlayCoords(u, v);
    }

    @Override
    public VertexConsumer uv2(int u, int v) {
        return delegate.uv2(u, v);
    }

    @Override
    public VertexConsumer normal(float x, float y, float z) {
        return delegate.normal(x, y, z);
    }

    @Override
    public void endVertex() {
        delegate.endVertex();
    }

    @Override
    public void defaultColor(int r, int g, int b, int a) {
        delegate.defaultColor(r, g, b, a);
    }

    @Override
    public void unsetDefaultColor() {
        delegate.unsetDefaultColor();
    }
}