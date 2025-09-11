<@macro print_input_text widget indent>
<#-- Create the text field and bind it to the view model -->
${""?left_pad(indent)}TextField textField_${widget.name} = new TextField();
${""?left_pad(indent)}textField_${widget.name}.textProperty().bindBidirectional(${widget.viewModelName}.${widget.name}Property());
${""?left_pad(indent)}textField_${widget.name}.setPromptText("Enter ${widget.label?lower_case}");

<#-- Conditionally wrap in an HBox with a unit label -->
<#if widget.unit?? && widget.unit?has_content>
${""?left_pad(indent)}HBox container_${widget.name} = new HBox(6);
${""?left_pad(indent)}container_${widget.name}.setAlignment(javafx.geometry.Pos.CENTER_LEFT);
${""?left_pad(indent)}Label unitLabel_${widget.name} = new Label("${widget.unit}");
${""?left_pad(indent)}container_${widget.name}.getChildren().addAll(textField_${widget.name}, unitLabel_${widget.name});
${""?left_pad(indent)}Node node_${widget.name} = container_${widget.name};
<#else>
${""?left_pad(indent)}Node node_${widget.name} = textField_${widget.name};
</#if>
</@macro>