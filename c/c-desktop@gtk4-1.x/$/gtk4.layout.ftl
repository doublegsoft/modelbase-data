<#import "/$/modelbase.ftl" as modelbase>
<#-- 
 ### 文本输入框
 -->
<#macro print_layout_input_text attr indent>
${""?left_pad(indent)}GtkWidget* vbox_${attr.name} = gtk_box_new(GTK_ORIENTATION_VERTICAL, 10);
${""?left_pad(indent)}gtk_box_set_spacing(GTK_BOX(vbox_${attr.name}), 0);
${""?left_pad(indent)}GtkWidget* entry_unit_${attr.name} = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 10);
${""?left_pad(indent)}GtkWidget* entry_${attr.name} = gtk_entry_new();
${""?left_pad(indent)}gtk_widget_set_hexpand(entry_${attr.name}, TRUE);
${""?left_pad(indent)}gtk_box_append(GTK_BOX(entry_unit_${attr.name}), entry_${attr.name});
${""?left_pad(indent)}gtk_box_append(GTK_BOX(vbox_${attr.name}), entry_unit_${attr.name});
<#if attr.getLabelledOptions("name")["unit"]??> 
${""?left_pad(indent)}GtkWidget* unit_label_${attr.name} = gtk_label_new("${attr.getLabelledOptions("name")["unit"]}");
${""?left_pad(indent)}gtk_box_append(GTK_BOX(entry_unit_${attr.name}), unit_label_${attr.name});
</#if>
${""?left_pad(indent)}GtkWidget* error_${attr.name} = gtk_label_new(NULL);
${""?left_pad(indent)}gtk_label_set_xalign(GTK_LABEL(error_${attr.name}), 0.0); 
${""?left_pad(indent)}gtk_label_set_markup(GTK_LABEL(error_${attr.name}), "<span font_desc='10'>请输入点东西</span>");
${""?left_pad(indent)}gtk_box_append(GTK_BOX(vbox_${attr.name}), error_${attr.name});
</#macro>

<#-- 
 ### 文本日期输入框
 -->
<#macro print_layout_input_date attr indent>
${""?left_pad(indent)}GtkWidget* vbox_${attr.name} = gtk_box_new(GTK_ORIENTATION_VERTICAL, 10);
${""?left_pad(indent)}gtk_box_set_spacing(GTK_BOX(vbox_${attr.name}), 0);
${""?left_pad(indent)}GtkWidget* entry_unit_${attr.name} = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 10);
${""?left_pad(indent)}GtkWidget* entry_${attr.name} = gtk_entry_new();
${""?left_pad(indent)}gtk_entry_set_placeholder_text(GTK_ENTRY(entry_${attr.name}), "YYYY-MM-DD");
${""?left_pad(indent)}gtk_editable_set_editable(GTK_EDITABLE(entry_${attr.name}), FALSE);
${""?left_pad(indent)}gtk_widget_set_can_focus(entry_${attr.name}, TRUE);

${""?left_pad(indent)}GtkGesture* click_${attr.name} = gtk_gesture_click_new();
${""?left_pad(indent)}g_signal_connect(click_${attr.name}, "pressed", G_CALLBACK(gtkx_date_picker_show), entry_${attr.name});
${""?left_pad(indent)}gtk_widget_add_controller(label_${attr.name}, GTK_EVENT_CONTROLLER(click_${attr.name}));

${""?left_pad(indent)}gtk_widget_set_hexpand(entry_${attr.name}, TRUE);
${""?left_pad(indent)}gtk_box_append(GTK_BOX(entry_unit_${attr.name}), entry_${attr.name});
${""?left_pad(indent)}gtk_box_append(GTK_BOX(vbox_${attr.name}), entry_unit_${attr.name});

${""?left_pad(indent)}GtkWidget* error_${attr.name} = gtk_label_new(NULL);
${""?left_pad(indent)}gtk_label_set_xalign(GTK_LABEL(error_${attr.name}), 0.0); 
${""?left_pad(indent)}gtk_label_set_markup(GTK_LABEL(error_${attr.name}), "<span font_desc='10'>请输入点东西</span>");
${""?left_pad(indent)}gtk_box_append(GTK_BOX(vbox_${attr.name}), error_${attr.name});
</#macro>

<#--
 ### 可编辑表单
 -->
<#macro print_layout_form_editable obj indent>
${""?left_pad(indent)}GtkWidget* vbox_${obj.name} = gtk_box_new(GTK_ORIENTATION_VERTICAL, 10);
${""?left_pad(indent)}gtk_widget_set_margin_top(vbox_${obj.name}, 20);
${""?left_pad(indent)}gtk_widget_set_margin_bottom(vbox_${obj.name}, 20);
${""?left_pad(indent)}gtk_widget_set_margin_start(vbox_${obj.name}, 20);
${""?left_pad(indent)}gtk_widget_set_margin_end(vbox_${obj.name}, 20);
  <#list obj.attributes as attr>
    <#if modelbase.is_attribute_system(attr)><#continue></#if>
${""?left_pad(indent)}// 【${modelbase.get_attribute_label(attr)}】
${""?left_pad(indent)}GtkWidget* hbox_${attr.name} = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 6);
${""?left_pad(indent)}GtkWidget* label_${attr.name} = gtk_label_new(NULL);
${""?left_pad(indent)}gtk_widget_set_margin_top(label_${attr.name}, -15);
${""?left_pad(indent)}gtk_label_set_markup(GTK_LABEL(label_${attr.name}), "<span font_desc='bold 14'>${modelbase.get_attribute_label(attr)}：</span>");
${""?left_pad(indent)}gtk_label_set_xalign(GTK_LABEL(label_${attr.name}), 0.0); 
${""?left_pad(indent)}gtk_widget_set_size_request(label_${attr.name}, 80, -1);
${""?left_pad(indent)}gtk_label_set_ellipsize(GTK_LABEL(label_${attr.name}), PANGO_ELLIPSIZE_END);
${""?left_pad(indent)}gtk_box_append(GTK_BOX(hbox_${attr.name}), label_${attr.name});   
    <#if attr.type.name == "date" || attr.type.name == "datetime">
<@print_layout_input_date attr=attr indent=indent />
    <#else>
<@print_layout_input_text attr=attr indent=indent />    
    </#if>
${""?left_pad(indent)}gtk_box_append(GTK_BOX(hbox_${attr.name}), vbox_${attr.name});     
${""?left_pad(indent)}gtk_box_append(GTK_BOX(vbox_${obj.name}), hbox_${attr.name});    
  </#list>
</#macro>  