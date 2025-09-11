<#if license??>
${c.license(license)}
</#if>
#include "gtkx.h"

/*!
** 
*/
void
gtkx_day_selected(GtkCalendar* calendar, gpointer user_data)
{
  GtkWindow* dialog = GTK_WINDOW(user_data);
  GDate* selected_date = selected_date = gtk_calendar_get_date(calendar);

  gtk_window_close(dialog);
  gtk_window_destroy(dialog);
}

/*!
**
*/
void 
gtkx_date_picker_show(GtkGestureClick* gesture, int n_press, double x, double y, gpointer user_data) {
  GtkWindow* parent_window = GTK_WINDOW(gtk_widget_get_root(GTK_WIDGET(user_data)));
  // GtkLabel* label = GTK_LABEL(user_data);

  GtkWidget* dialog = gtk_dialog_new_with_buttons("选择日期",
                                                  parent_window,
                                                  GTK_DIALOG_MODAL,
                                                  "确认", GTK_RESPONSE_OK,
                                                  "取消", GTK_RESPONSE_CANCEL,
                                                  NULL);
  gtk_window_set_decorated(GTK_WINDOW(dialog), FALSE);
                                                  
  GtkWidget* calendar = gtk_calendar_new();
  gtk_window_set_child(GTK_WINDOW(dialog), calendar);

  g_signal_connect(calendar, "day-selected", G_CALLBACK(gtkx_day_selected), dialog);

  gtk_widget_show(dialog);
  gtk_window_present(GTK_WINDOW(dialog));
}

/*!
**
*/
GtkWidget* 
gtkx_form_line_build(GtkWidget* entry, GtkWidget** error, const char* text, const char* unit)
{
  char text_html[1024];
  sprintf(text_html, "<span font_desc='bold 14'>%s：</span>", text);
  GtkWidget* hbox = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 6);
  GtkWidget* label = gtk_label_new(NULL);
  gtk_widget_set_margin_top(label, -15);
  gtk_label_set_markup(GTK_LABEL(label), text_html);
  gtk_label_set_xalign(GTK_LABEL(label), 0.0); 
  gtk_widget_set_size_request(label, 80, -1);
  gtk_label_set_ellipsize(GTK_LABEL(label), PANGO_ELLIPSIZE_END);
  gtk_box_append(GTK_BOX(hbox), label);  
  
  GtkWidget* vbox = gtk_box_new(GTK_ORIENTATION_VERTICAL, 10);
  gtk_box_set_spacing(GTK_BOX(vbox), 0);
  GtkWidget* entry_and_unit = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 10);

  gtk_widget_set_hexpand(entry, TRUE);
  gtk_box_append(GTK_BOX(entry_and_unit), entry);
  if (unit != NULL) 
  {
    GtkWidget* unit_label = gtk_label_new(unit);
    gtk_box_append(GTK_BOX(entry_and_unit), unit_label);  
  }
  gtk_box_append(GTK_BOX(vbox), entry_and_unit);

  if (*error == NULL)
  {
    error = gtk_label_new(NULL);
    gtk_label_set_xalign(GTK_LABEL(error), 0.0); 
    gtk_label_set_markup(GTK_LABEL(error), "<span font_desc='10'>错误的提示</span>");
    gtk_box_append(GTK_BOX(vbox), error); 
  }   
  gtk_box_append(GTK_BOX(hbox), vbox); 
  return hbox;
}

GtkWidget* 
gtkx_input_text_build(void)
{
  GtkWidget* entry = gtk_entry_new();
  gtk_widget_set_hexpand(entry, TRUE);
  return entry;
}

GtkWidget* 
gtkx_input_date_build(void) 
{
  GtkWidget* entry = gtk_entry_new();
  gtk_entry_set_placeholder_text(GTK_ENTRY(entry), "YYYY-MM-DD");
  gtk_editable_set_editable(GTK_EDITABLE(entry), FALSE);
  gtk_widget_set_can_focus(entry, TRUE);
  gtk_widget_set_hexpand(entry, TRUE);

  GtkGesture* click = gtk_gesture_click_new();
  g_signal_connect(click, "pressed", G_CALLBACK(gtkx_date_picker_show), entry);
  gtk_widget_add_controller(entry, GTK_EVENT_CONTROLLER(click));
  return entry;
}