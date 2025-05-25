if (${input$entity} instanceof IGeckoLibEntity geckoLibEntity) {
    geckoLibEntity.setRenderLayerBoneSettings(${input$layerKey}, ${input$bone}, ${input$hidden}, "${field$recursive}" == "TRUE");
}