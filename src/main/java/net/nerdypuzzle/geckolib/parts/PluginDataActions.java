package net.nerdypuzzle.geckolib.parts;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import net.mcreator.generator.GeneratorUtils;
import net.mcreator.io.FileIO;
import net.mcreator.io.Transliteration;
import net.mcreator.ui.MCreator;
import net.mcreator.ui.action.BasicAction;
import net.mcreator.ui.action.impl.workspace.resources.ModelImportActions;
import net.mcreator.ui.dialogs.file.FileDialogs;
import net.mcreator.ui.init.L10N;
import net.nerdypuzzle.geckolib.registry.PluginActions;

import javax.annotation.Nullable;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.*;

public class PluginDataActions extends ModelImportActions {

    public static File getModElementsDir(MCreator mcreator) {
        return new File(mcreator.getWorkspace().getWorkspaceFolder(), "elements/");
    }

    public static List<File> getEntityDataGroups(MCreator mcreator) {
        return listEntityDataGroupsInDir(getModElementsDir(mcreator));
    }

    private static List<File> listEntityDataGroupsInDir(@Nullable File dir) {
        if (dir == null) {
            return Collections.emptyList();
        } else {
            List<File> retval = new ArrayList();
            File[] block = dir.listFiles();
            File[] var3 = block != null ? block : new File[0];
            int var4 = var3.length;

            for(int var5 = 0; var5 < var4; ++var5) {
                File element = var3[var5];
                if (element.getName().endsWith(".mod.json")) {
                    try {
                        String jsonString = Files.readString(Paths.get(element.getAbsolutePath()));
                        JsonObject elementData = JsonParser.parseString(jsonString).getAsJsonObject();
                        String type = elementData.get("_type").getAsString();
                        if (Objects.equals(type, "aentitydatagroup")) {
                            retval.add(element);
                        }
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
            }

            return retval;
        }
    }
}
