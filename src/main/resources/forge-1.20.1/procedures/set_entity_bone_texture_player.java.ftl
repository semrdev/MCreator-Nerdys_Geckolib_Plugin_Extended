if (${input$entity} instanceof IGeckoLibEntity geckoLibEntity) {
    if (${input$player} instanceof Player player) {
            geckoLibEntity.setBonesToPlayerTexture(${input$layerKey}, player, "${field$renderType}", ${input$bone}, ${input$hidden}, "${field$recursive}" == "TRUE");
    }
}