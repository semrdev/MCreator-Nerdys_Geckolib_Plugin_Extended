if (${input$entity} instanceof ${(field$name)?replace("CUSTOM:", "")}Entity) {
    ((${(field$name)?replace("CUSTOM:", "")}Entity) ${input$entity}).offsetBoneUVs(${input$bone}, (float) ${input$uOffset}, (float) ${input$vOffset});
}