package ${package}.utils;

public class ProcedureUtils {
    public static Entity getEntityWithUUIDWithinRadius(String stringUUID, double radius, double x, double y, double z) {
        Level level = Minecraft.getInstance().level;
        if (level == null) return null;
        AABB box = new AABB(x - radius, y - radius, z - radius, x + radius, y + radius, z + radius);

        List<Entity> foundEntities = level.getEntities(EntityTypeTest.forClass(Entity.class), box, entity -> entity.getStringUUID().equals(stringUUID));

        return foundEntities.isEmpty() ? null : foundEntities.get(0);
    }

    /**
    * Parses hex color strings into normalized floats [r,g,b,a] in [0,1].
    * Supports #RGB, #RGBA, #RRGGBB, #RRGGBBAA (leading '#' or '0x' optional).
    * Assumes 8-digit form is RRGGBBAA (alpha at the end).
    *
    * Returns a null object if the String could not be parsed.
    */
    public static float[] parseHexColor(String input) {
        if (input == null) {
            return null;
        }

        String hex = input.trim();
        if (hex.startsWith("#")) hex = hex.substring(1);
        if (hex.startsWith("0x") || hex.startsWith("0X")) hex = hex.substring(2);

        // Expand shorthand (#RGB -> #RRGGBB, #RGBA -> #RRGGBBAA)
        if (hex.length() == 3 || hex.length() == 4) {
            hex = expandShorthand(hex);
        }

        if (hex.length() != 6 && hex.length() != 8) {
            return null;
        }

        // Validate hex characters early
        if (!hex.matches("[0-9a-fA-F]+")) {
            return null;
        }

        // Parse
        int color = (int) Long.parseLong(hex, 16);

        int r, g, b, a;
        if (hex.length() == 6) {
            r = (color >> 16) & 0xFF;
            g = (color >> 8)  & 0xFF;
            b =  color        & 0xFF;
            a = 0xFF; // default alpha
        } else { // 8
            r = (color >> 24) & 0xFF;
            g = (color >> 16) & 0xFF;
            b = (color >> 8)  & 0xFF;
            a =  color        & 0xFF;  // assumes RRGGBBAA
        }

        return new float[] { r / 255f, g / 255f, b / 255f, a / 255f };
    }

    private static String expandShorthand(String shortHex) {
        StringBuilder sb = new StringBuilder(shortHex.length() * 2);
        for (int i = 0; i < shortHex.length(); i++) {
            char c = shortHex.charAt(i);
            sb.append(c).append(c); // duplicate each digit
        }
        return sb.toString();
    }
}