if (${input$entity} instanceof IGeckoLibEntity geckoLibEntity) {
    if (${input$player} instanceof Player player) {
            geckoLibEntity.addOrModifyPlayerRenderLayer(${input$layerKey}, player, "${field$renderType}");
    }
}