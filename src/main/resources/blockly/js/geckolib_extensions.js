// Helper function to use in Blockly extensions that register one data list selector field to update contents of another
// The block may define input called "<targetName>Field" to customize field's position
// Note that the source field must be inserted before the target field for their values to be loaded properly
function appendAutoReloadingDataListField(sourceName, targetName, targetList) {
    return function () {
        const thisBlock = this;
        (this.getInput(targetName + 'Field') || this.appendDummyInput()).appendField(
            new FieldDataListSelector(targetList, undefined, {
                'customEntryProviders': function () {
                    return thisBlock.getFieldValue(sourceName);
                }
            }), targetName);
        this.setOnChange(function (changeEvent) {
            // Proceed if event represents change to field named "<sourceName>" on this block and was created in a group
            // Event triggered by FieldDataListSelector is only grouped if field value is modified in UI
            if (changeEvent.type === Blockly.Events.BLOCK_CHANGE &&
                changeEvent.group && changeEvent.blockId === this.id &&
                changeEvent.element === 'field' &&
                changeEvent.name === sourceName) {
                const group = Blockly.Events.getGroup();
                // Makes it so the update and the reset event get undone together.
                Blockly.Events.setGroup(changeEvent.group);
                this.setFieldValue('', targetName);
                Blockly.Events.setGroup(group);
            }
        });
    };
}

Blockly.Extensions.register('entity_data_group_logic_list_provider',
    appendAutoReloadingDataListField('entityDataGroup', 'accessor', 'entitydata_logic'));

Blockly.Extensions.register('entity_data_group_integer_list_provider',
    appendAutoReloadingDataListField('entityDataGroup', 'accessor', 'entitydata_integer'));

Blockly.Extensions.register('entity_data_group_string_list_provider',
    appendAutoReloadingDataListField('entityDataGroup', 'accessor', 'entitydata_string'));