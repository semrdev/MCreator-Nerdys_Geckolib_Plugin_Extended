package net.nerdypuzzle.geckolib.ui.modgui;

import net.mcreator.ui.MCreator;
import net.mcreator.ui.component.util.PanelUtils;
import net.mcreator.ui.help.HelpUtils;
import net.mcreator.ui.init.L10N;
import net.mcreator.ui.minecraft.states.entity.JEntityDataList;
import net.mcreator.ui.modgui.ModElementGUI;
import net.mcreator.ui.validation.AggregatedValidationResult;
import net.mcreator.workspace.elements.ModElement;
import net.nerdypuzzle.geckolib.element.types.AEntityDataGroup;
import net.nerdypuzzle.geckolib.element.types.GeckolibElement;

import javax.swing.*;
import java.awt.*;

public class AEntityDataGroupGUI extends ModElementGUI<AEntityDataGroup> implements GeckolibElement {

    private JEntityDataList entityDataList;

    public AEntityDataGroupGUI(MCreator mcreator, ModElement modElement, boolean editingMode) {
        super(mcreator, modElement, editingMode);
        this.initGUI();
        super.finalizeGUI();
    }

    @Override protected void initGUI() {

        entityDataList = new JEntityDataList(mcreator, this);

        JPanel entityDataListPanel = new JPanel(new GridLayout());

        JComponent entityDataListComp = PanelUtils.northAndCenterElement(
                HelpUtils.wrapWithHelpButton(this.withEntry("entity/entity_data"),
                        L10N.label("elementgui.living_entity.entity_data")), entityDataList);
        entityDataListPanel.setOpaque(false);
        entityDataListComp.setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));
        entityDataListPanel.add(entityDataListComp);

        addPage(L10N.t("elementgui.living_entity.page_entity_data"), entityDataListPanel);
    }

    @Override public void reloadDataLists() {
        super.reloadDataLists();
    }

    @Override protected AggregatedValidationResult validatePage(int page) {
        return new AggregatedValidationResult.PASS();
    }

    @Override public void openInEditingMode(AEntityDataGroup livingEntity) {
        entityDataList.setEntries(livingEntity.entityDataEntries);
    }

    @Override public AEntityDataGroup getElementFromGUI() {
        AEntityDataGroup dataGroup = new AEntityDataGroup(modElement);
        dataGroup.entityDataEntries = entityDataList.getEntries();

        return dataGroup;
    }

}
