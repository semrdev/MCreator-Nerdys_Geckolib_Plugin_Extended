package ${package}.entity;

<#include "../mcitems.ftl">
<#include "../procedures.java.ftl">

import net.minecraft.world.entity.ai.attributes.Attribute;
import net.minecraft.world.entity.ai.attributes.Attributes;
import net.minecraft.network.syncher.EntityDataAccessor;
import net.minecraft.network.syncher.EntityDataSerializers;
import net.minecraft.network.syncher.SynchedEntityData;

import javax.annotation.Nullable;
import java.util.*;

public interface IGeckoLibEntity {

	public void setTexture(String texture);

	public String getTexture();

    public void overrideAnimation(String animationType, String animID);

	public String getProcedureAnimation();

	public void setAnimation(String animation);

    public void toggleModelBones(String bones, Boolean visible);

    public void offsetBoneUVs(String bones, float uOffset, float vOffset);

    public void setPassengerOffset(double x, double y, double z, String boneName);

    public void resetPassengerOffset();

    public void setPassengerIsSitting(boolean isSitting);


}