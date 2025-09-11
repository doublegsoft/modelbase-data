<#if license??>
${c.license(license)}
</#if>
#include <gtk/gtk.h>

void
gtkx_day_selected(GtkCalendar* calendar, gpointer user_data);

void 
gtkx_date_picker_show(GtkGestureClick* gesture, int n_press, double x, double y, gpointer user_data);

GtkWidget* 
gtkx_form_line_build(GtkWidget* entry, GtkWidget** error, const char* text, const char* unit);

GtkWidget* 
gtkx_input_text_build(void);

GtkWidget* 
gtkx_input_date_build(void);