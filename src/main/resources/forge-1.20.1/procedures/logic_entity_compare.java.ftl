<#if field$entity?starts_with("DATAGROUP:")>
(${input$compareTo} instanceof I${field$entity?remove_beginning("DATAGROUP:")}EntityDataGroup)
<#else>
(${input$compareTo} instanceof ${generator.map(field$entity, "entities", 0)})
</#if>