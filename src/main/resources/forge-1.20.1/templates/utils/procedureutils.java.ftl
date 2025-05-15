package ${package}.utils;

public class ProcedureUtils {
    public static Entity getEntityWithUUIDWithinRadius(String stringUUID, double radius, double x, double y, double z) {
        Level level = Minecraft.getInstance().level;
        if (level == null) return null;
        AABB box = new AABB(x - radius, y - radius, z - radius, x + radius, y + radius, z + radius);

        List<Entity> foundEntities = level.getEntities(EntityTypeTest.forClass(Entity.class), box, entity -> entity.getStringUUID().equals(stringUUID));

        return foundEntities.isEmpty() ? null : foundEntities.get(0);
    }
}