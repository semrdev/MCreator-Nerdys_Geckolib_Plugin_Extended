<#if (data.tameable && data.breedable && (!data.waterMob || data.flyingMob) && data.sprintToFollow)>
<#include "aiconditions.java.ftl">
this.goalSelector.addGoal(${cbi+1}, new SprintFollowOwnerGoal(this, ${field$speed}, (float) ${field$min_distance}, (float) ${field$max_distance}, false)<@conditionCode field$condition/>);
</#if>