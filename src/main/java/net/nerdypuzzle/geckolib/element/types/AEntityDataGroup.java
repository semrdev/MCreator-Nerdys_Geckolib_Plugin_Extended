package net.nerdypuzzle.geckolib.element.types;

import net.mcreator.element.BaseType;
import net.mcreator.element.GeneratableElement;
import net.mcreator.element.types.interfaces.ICommonType;
import net.mcreator.ui.minecraft.states.PropertyDataWithValue;
import net.mcreator.workspace.elements.ModElement;

import java.util.List;
import java.util.*;

@SuppressWarnings("unused")
public class AEntityDataGroup extends GeneratableElement
    implements ICommonType {

    public List<PropertyDataWithValue<?>> entityDataEntries;

    private AEntityDataGroup() {
        this(null);
    }

    public AEntityDataGroup(ModElement element) {
        super(element);
        this.entityDataEntries = new ArrayList<>();
    }

    public Collection<BaseType> getBaseTypesProvided() {
        return List.of(BaseType.ENTITY);
    }

    public class JSONWrapper {
        public AEntityDataGroup definition;
    }
}
