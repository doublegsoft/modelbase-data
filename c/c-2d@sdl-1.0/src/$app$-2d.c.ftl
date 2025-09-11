<#import '/$/modelbase.ftl' as modelbase>
<#import '/$/modelbase4c.ftl' as modelbase4c>
<#if license??>
${c.license(license)}
</#if>
#include <stdlib.h>
#include <math.h>
#include "${app.name}-2d.h"

struct ${namespace}_2d_image_s
{
  int           x;
  int           y;
  int           w;
  int           h;
    
  int           orig_w;
  int           orig_h;
  SDL_Surface*  surf;
  SDL_Texture*  tex;
};

${namespace}_2d_shape_p
${namespace}_2d_clicked(${namespace}_2d_scene_p scene, int x, int y)
{

}

/*!
**
*/
void
${namespace}_2d_circle_edge(int sx, int sy, int tx, int ty, int radius, int* ex, int* ey)
{
  int a = abs(tx - sx);
  int b = abs(ty - sy);
  int c = sqrt(a * a + b * b);
  if (sx > tx) 
    *ex = radius * a / c + tx;
  else
    *ex = tx - radius * a / c;
  if (sy < ty)
    *ey = ty - radius * b / c;  
  else
    *ey = ty + radius * b / c;  
}

/*!
**
*/
void
${namespace}_2d_point_to_line(int sx, int sy, int tx, int ty, int px, int py, int* x, int* y)
{
  double x0 = px;
  double y0 = py;
  double x1 = sx;
  double y1 = sy;
  double x2 = tx;
  double y2 = ty;
  double t = ((x0 - x1) * (x2 - x1) + (y0 - y1) * (y2 - y1)) / ((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1));

  *x = x1 + t * (x2 - x1);
  *y = y1 + t * (y2 - y1);
}