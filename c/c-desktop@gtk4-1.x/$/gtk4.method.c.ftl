<#import "/$/modelbase.ftl" as modelbase>

<#--
 ### 可编辑表单
 -->
<#macro print_method_form_editable obj indent>
/*!
** 获取【${modelbase.get_object_label(obj)}】部件。
*/
GtkWidget* ${namespace}_form_${obj.name}_get(void) 
{
  if (form_${obj.name} == NULL) 
  {
    form_${obj.name} = gtk_box_new(GTK_ORIENTATION_VERTICAL, 10);
    gtk_widget_set_margin_top(form_${obj.name}, 20);
    gtk_widget_set_margin_bottom(form_${obj.name}, 20);
    gtk_widget_set_margin_start(form_${obj.name}, 20);
    gtk_widget_set_margin_end(form_${obj.name}, 20);
    GtkWidget* line = NULL;
  <#list obj.attributes as attr>
    <#if modelbase.is_attribute_system(attr)><#continue></#if>
    //【${modelbase.get_attribute_label(attr)}】
    <#if attr.type.name == "date" || attr.type.name == "datetime">
    entry_${attr.name} = gtkx_input_date_build();
    <#else>
    entry_${attr.name} = gtkx_input_text_build();
    </#if>
    line = gtkx_form_line_build(entry_${attr.name}, 
                                &error_${attr.name}, 
                                "${modelbase.get_attribute_label(attr)}", 
                                <#if attr.getLabelledOptions("name")["unit"]??>"${attr.getLabelledOptions("name")["unit"]}"<#else>NULL</#if>);
    gtk_box_append(GTK_BOX(form_${obj.name}), line);
  </#list>
  }
  return form_${obj.name};
}  
</#macro>
