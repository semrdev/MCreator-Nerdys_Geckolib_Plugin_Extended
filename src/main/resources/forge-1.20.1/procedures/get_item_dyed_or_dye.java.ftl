(
    ${input$item}.getItem() instanceof net.minecraft.world.item.DyeableLeatherItem
        ? ((net.minecraft.world.item.DyeableLeatherItem) ${input$item}.getItem()).hasCustomColor(${input$item})
        : (${input$item}.getItem() instanceof net.minecraft.world.item.DyeItem
            ? true
            : false
          )
)