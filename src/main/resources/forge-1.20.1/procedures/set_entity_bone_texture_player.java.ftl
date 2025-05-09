if (${input$entity} instanceof IGeckoLibEntity geckoLibEntity) {
    if (${input$player} instanceof Player player) {
        geckoLibEntity.setBonesToPlayerTexture(player, ${input$bone}, ${input$recursive});
    }
}