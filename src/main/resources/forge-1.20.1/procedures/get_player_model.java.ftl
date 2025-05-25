(${input$player} instanceof Player player ?
    (player.getGameProfile() != null ?
        DefaultPlayerSkin.getSkinModelName(player.getGameProfile().getId()) :
        "null"
    ) :
    "null"
)