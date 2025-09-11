<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4c.ftl" as modelbase4c>
<#if license??>
${c.license(license)}
</#if>
#ifndef __${app.name?upper_case}_2D_H__
#define __${app.name?upper_case}_2D_H__

#include <SDL2/SDL.h>

#ifdef __cplusplus
extern "C"
{
#endif

typedef struct ${namespace}_2d_point_s    ${namespace}_2d_point_t;
typedef        ${namespace}_2d_point_t*   ${namespace}_2d_point_p;

typedef struct ${namespace}_2d_line_s     ${namespace}_2d_line_t;
typedef        ${namespace}_2d_line_t*    ${namespace}_2d_line_p;

typedef struct ${namespace}_2d_image_s    ${namespace}_2d_image_t;
typedef        ${namespace}_2d_image_t*   ${namespace}_2d_image_p;

typedef struct ${namespace}_2d_shape_s    ${namespace}_2d_shape_t;
typedef        ${namespace}_2d_shape_t*   ${namespace}_2d_shape_p;

typedef struct ${namespace}_2d_scene_s    ${namespace}_2d_scene_t;
tyepdef        ${namespace}_2d_scene_t*   ${namespace}_2d_scene_p;

/*!
** Checks which shape is clicked.
*/
${namespace}_2d_shape_p
${namespace}_2d_clicked(${namespace}_2d_scene_p scene, int x, int y);

/*!
** Gets the circle edge coordinate for a point which connects to the circle.
*/
void
${namespace}_2d_circle_edge(int sx, int sy, int tx, int ty, int radius, int* ex, int* ey);

/*!
** 
*/
void
${namespace}_2d_point_to_line(int sx, int sy, int tx, int ty, int px, int py, int* x, int* y);

/*!
** Loads image from path in file system.
*/
${namespace}_2d_image_p
${namespace}_2d_image_load(const char* path);

/*!
** Resizes the image to the given width and height.
*/
void
${namespace}_2d_image_resize(SDL_Renderer* renderer, ${namespace}_2d_image_p image, int width, int height);

#ifdef __cplusplus
}
#endif

#endif // __${app.name?upper_case}_2D_H__
