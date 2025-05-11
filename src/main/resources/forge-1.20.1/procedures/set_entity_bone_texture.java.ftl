if (${input$entity} instanceof IGeckoLibEntity geckoLibEntity) {
    geckoLibEntity.setBonesToTexture(${input$layerKey}, ${input$texture}, "${field$renderType}", ${input$bone}, ${input$hidden}, "${field$recursive}" == "TRUE");
}