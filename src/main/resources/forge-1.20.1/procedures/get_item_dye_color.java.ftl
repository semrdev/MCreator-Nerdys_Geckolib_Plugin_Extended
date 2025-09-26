(
    ${input$item}.getItem() instanceof net.minecraft.world.item.DyeableLeatherItem
        ? String.format(
            "#%06X",
            ((net.minecraft.world.item.DyeableLeatherItem) ${input$item}.getItem()).getColor(${input$item})
          )
        : (${input$item}.getItem() instanceof net.minecraft.world.item.DyeItem
            ? String.format(
                "#%06X",
                (
                    (net.minecraft.util.Mth.floor(((net.minecraft.world.item.DyeItem) ${input$item}.getItem()).getDyeColor().getTextureDiffuseColors()[0] * 255.0F) << 16)
                  | (net.minecraft.util.Mth.floor(((net.minecraft.world.item.DyeItem) ${input$item}.getItem()).getDyeColor().getTextureDiffuseColors()[1] * 255.0F) << 8)
                  |  net.minecraft.util.Mth.floor(((net.minecraft.world.item.DyeItem) ${input$item}.getItem()).getDyeColor().getTextureDiffuseColors()[2] * 255.0F)
                )
              )
            : "#FFFFFF"
          )
)