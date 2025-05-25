if (${input$entity} instanceof IGeckoLibEntity geckoLibEntity) {
    geckoLibEntity.addOrModifyTextureRenderLayer(${input$layerKey}, ${input$texture}, "${field$renderType}");
}