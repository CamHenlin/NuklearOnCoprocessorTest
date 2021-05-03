/*
 * Nuklear - 1.32.0 - public domain
 * no warranty implied; use at your own risk.
 * based on allegro5 version authored from 2015-2016 by Micha Mettke
 * quickdraw version camhenlin 2021
 * 
 * v1 intent:
 * - only default system font support
 * - no graphics/images support - quickdraw has very limited support for this
 */
/*
 * ==============================================================
 *
 *                              API
 *
 * ===============================================================
 */
#ifndef NK_QUICKDRAW_H_
#define NK_QUICKDRAW_H_
#include <MacTypes.h>
#include <Types.h>
#include <Quickdraw.h>
#include <Scrap.h>
#include <Serial.h>
#include "SerialHelper.h"
#include <stdlib.h>

void nk_quickdraw_init(unsigned int width, unsigned int height);
void nk_quickdraw_handle_event(EventRecord *event);
void nk_quickdraw_render(WindowPtr window, char *command);

#endif


// constant keyboard mappings for convenenience
// See Inside Macintosh: Text pg A-7, A-8
char homeKey = (char)0x01;
char enterKey = (char)0x03;
char endKey = (char)0x04;
char helpKey = (char)0x05;
char backspaceKey = (char)0x08;
char deleteKey = (char)0x7F;
char tabKey = (char)0x09;
char pageUpKey = (char)0x0B;
char pageDownKey = (char)0x0C;
char returnKey = (char)0x0D;
char rightArrowKey = (char)0x1D;
char leftArrowKey = (char)0x1C;
char downArrowKey = (char)0x1F;
char upArrowKey = (char)0x1E;
char eitherShiftKey = (char)0x0F;
char escapeKey = (char)0x1B;

// #define NK_QUICKDRAW_GRAPHICS_DEBUGGING
#//def define NK_QUICKDRAW_EVENTS_DEBUGG

// bezier code is from http://preserve.mactech.com/articles/mactech/Vol.05/05.01/BezierCurve/index.html
// as it is not built in to quickdraw like other "modern" graphics environments
/*
   The greater the number of curve segments, the smoother the curve, 
and the longer it takes to generate and draw.  The number below was pulled 
out of a hat, and seems to work o.k.
 */
#define SEGMENTS 16

static Fixed weight1[SEGMENTS + 1];
static Fixed weight2[SEGMENTS + 1];

#define w1(s) weight1[s]
#define w2(s) weight2[s]
#define w3(s) weight2[SEGMENTS - s]
#define w4(s) weight1[SEGMENTS - s]

/*
 *  SetupBezier  --  one-time setup code.
 * Compute the weights for the Bezier function.
 *  For the those concerned with space, the tables can be precomputed. 
Setup is done here for purposes of illustration.
 */
void setupBezier() {

    Fixed t, zero, one;
    int s;

    zero = FixRatio(0, 1);
    one = FixRatio(1, 1);
    weight1[0] = one;
    weight2[0] = zero;

    for (s = 1; s < SEGMENTS; ++s) {

        t = FixRatio(s, SEGMENTS);
        weight1[s] = FixMul(one - t, FixMul(one - t, one - t));
        weight2[s] = 3 * FixMul(t, FixMul(t - one, t - one));
    }

    weight1[SEGMENTS] = zero;
    weight2[SEGMENTS] = zero;
}

/*
 *  computeSegments  --  compute segments for the Bezier curve
 * Compute the segments along the curve.
 *  The curve touches the endpoints, so don’t bother to compute them.
 */
static void computeSegments(p1, p2, p3, p4, segment) Point  p1, p2, p3, p4; Point  segment[]; {

    int s;

    segment[0] = p1;

    for (s = 1; s < SEGMENTS; ++s) {

        segment[s].v = FixRound(w1(s) * p1.v + w2(s) * p2.v + w3(s) * p3.v + w4(s) * p4.v);
        segment[s].h = FixRound(w1(s) * p1.h + w2(s) * p2.h + w3(s) * p3.h + w4(s) * p4.h);
    }

    segment[SEGMENTS] = p4;
}

/*
 *  BezierCurve  --  Draw a Bezier Curve
 * Draw a curve with the given endpoints (p1, p4), and the given 
 * control points (p2, p3).
 *  Note that we make no assumptions about pen or pen mode.
 */
void BezierCurve(p1, p2, p3, p4) Point  p1, p2, p3, p4; {

    int s;
    Point segment[SEGMENTS + 1];

    computeSegments(p1, p2, p3, p4, segment);
    MoveTo(segment[0].h, segment[0].v);

    for (s = 1 ; s <= SEGMENTS ; ++s) {

        if (segment[s].h != segment[s - 1].h || segment[s].v != segment[s - 1].v) {

            LineTo(segment[s].h, segment[s].v);
        }
    }
}

// ex usage:
// Point   control[4] = {{144,72}, {72,144}, {216,144}, {144,216}};
// BezierCurve(c[0], c[1], c[2], c[3]);


static int nk_color_to_quickdraw_bw_color(int color) {

    // check the equivalent function in headless_nuklear if you need color int understanding

    if (color == 0) {

        // writeSerialPortDebug(boutRefNum, "nk_color_to_quickdraw_bw_color COLOR BLACK");
       
        return blackColor;
    }

        // writeSerialPortDebug(boutRefNum, "nk_color_to_quickdraw_bw_color COLOR WHITE");
    // otherwise the number *should* be 1, meaning white here
    return whiteColor;
}

// i split this in to a 2nd routine because we can use the various shades of gray when filling rectangles and whatnot
static Pattern nk_color_to_quickdraw_color(int color) {


    // check the equivalent function in headless_nuklear if you need color int understanding

    if (color == 0) {
        // writeSerialPortDebug(boutRefNum, "nk_color_to_quickdraw_color PATTERN BLACK");

        return qd.black;
    } else if (color == 1) {
        // writeSerialPortDebug(boutRefNum, "nk_color_to_quickdraw_color PATTERN dkGray");

        return qd.dkGray;
    } else if (color == 2) {
        // writeSerialPortDebug(boutRefNum, "nk_color_to_quickdraw_color PATTERN gray");

        return qd.gray;
    } else if (color == 3) {
        // writeSerialPortDebug(boutRefNum, "nk_color_to_quickdraw_color PATTERN ltGray");

        return qd.ltGray;
    }

        // writeSerialPortDebug(boutRefNum, "nk_color_to_quickdraw_color PATTERN white");
    // otherwise the color is 4 (white)
    return qd.white;
}

typedef struct {
    Ptr Address;
    long RowBytes;
    GrafPtr bits;
    Rect bounds;
    
    BitMap  BWBits;
    GrafPort BWPort;
    
    Handle  OrigBits;
    
} ShockBitmap;

void NewShockBitmap(ShockBitmap *theMap, short width, short height) {

    theMap->bits = 0L;
    SetRect(&theMap->bounds, 0, 0, width, height);
    
    theMap->BWBits.bounds = theMap->bounds;
    theMap->BWBits.rowBytes = ((width+15) >> 4)<<1;         // round to even
    theMap->BWBits.baseAddr = NewPtr(((long) height * (long) theMap->BWBits.rowBytes));

    theMap->BWBits.baseAddr = StripAddress(theMap->BWBits.baseAddr);
    
    OpenPort(&theMap->BWPort);
    SetPort(&theMap->BWPort);
    SetPortBits(&theMap->BWBits);

    SetRectRgn(theMap->BWPort.visRgn, theMap->bounds.left, theMap->bounds.top, theMap->bounds.right, theMap->bounds.bottom);
    SetRectRgn(theMap->BWPort.clipRgn, theMap->bounds.left, theMap->bounds.top, theMap->bounds.right, theMap->bounds.bottom);
    EraseRect(&theMap->bounds);
      
    theMap->Address = theMap->BWBits.baseAddr;
    theMap->RowBytes = (long) theMap->BWBits.rowBytes;
    theMap->bits = (GrafPtr) &theMap->BWPort;
}

ShockBitmap gMainOffScreen;

char commandCache[1024][255];
int cacheCounter = 0;
int color; // Color QuickDraw colors are integers - see Retro68/InterfacesAndLibraries/Interfaces&Libraries/Interfaces/CIncludes/Quickdraw.h:122 for more info
char *command = NULL;

void nk_quickdraw_render(WindowPtr window, char* commands) {
        // writeSerialPortDebug(boutRefNum, "nk_quickdraw_render");
        // writeSerialPortDebug(boutRefNum, commands);

    if (strlen(commands) == 0) {

        // writeSerialPortDebug(boutRefNum, "empty commands list! bail!");
        return;
    }
CGrafPtr origPort;
GDHandle origDevice;
GWorldPtr myOffScreenWorld;
PixMapHandle offPixMapHandle;
    GetGWorld(&origPort, &origDevice);

    NewGWorld(&myOffScreenWorld, 0, &origPort->portRect, NULL, NULL, 0);
    SetGWorld(myOffScreenWorld, NULL); //{set current graphics port to offscreen}
    offPixMapHandle = GetGWorldPixMap(myOffScreenWorld);
    LockPixels(offPixMapHandle);
    // OpenPort(&gMainOffScreen.BWPort);
    // SetPort(&gMainOffScreen.BWPort);
    // SetPortBits(&gMainOffScreen.BWBits);
    //EraseRect(&gMainOffScreen.bounds); // we don't actually need to bother erasing the rect because nuklear will want to draw a filled rect over the entire port

    command = strtok(commands, "\n");

    while (command != NULL) {

        #ifdef NK_QUICKDRAW_GRAPHICS_DEBUGGING

            writeSerialPortDebug(boutRefNum, "command!");
            writeSerialPortDebug(boutRefNum, command);
        #endif

        // my reasoning here is that if the command is shorter than any possible command, it must be cached
        if (strlen(command) < 10) {

            command = commandCache[atoi(command)];
            // writeSerialPortDebug(boutRefNum, "CACHED command!");
            // writeSerialPortDebug(boutRefNum, command);
        } else {

            strcpy(commandCache[cacheCounter++], command);
        }

        char type = command[0];

        // TODO this needs to match the output of "nuklear_commands_only"
        // "NK_COMMAND_*" cases are left as comments for clarity of what is being implemented 
        switch (type) {

            // case NK_COMMAND_LINE: {
            case 'L': {

                    #ifdef NK_QUICKDRAW_GRAPHICS_DEBUGGING

                        writeSerialPortDebug(boutRefNum, "NK_COMMAND_LINE");
                    #endif

                    // const struct nk_command_line *l = (const struct nk_command_line *)cmd;
                    // color = nk_color_to_quickdraw_bw_color(atoi(l)->color);
                    // // great reference: http://mirror.informatimago.com/next/developer.apple.com/documentation/mac/QuickDraw/QuickDraw-60.html
                    // // al_draw_line((float)l->begin.x, (float)l->begin.y, (float)l->end.x, (float)l->end.y, color, (float)l->line_thickness); // TODO: look up and convert al_draw_line
                    // ForeColor(color);
                    // PenSize((float)l->line_thickness, (float)l->line_thickness);
                    // MoveTo((float)l->begin.x, (float)l->begin.y);
                    // LineTo((float)l->end.x, (float)l->end.y);
                }

                break;
            //case NK_COMMAND_RECT: {
            case 'R': {

                    #ifdef NK_QUICKDRAW_GRAPHICS_DEBUGGING

                        writeSerialPortDebug(boutRefNum, "NK_COMMAND_RECT");
                    #endif

                    int decodedColor;
                    int decodedLineThickness;
                    int decodedX;
                    int decodedY;
                    int decodedBottom;
                    int decodedRight;
                    int decodedRounding;

                    sscanf(command, "R%01d%01d%04d%04d%04d%04d%04d", &decodedColor, &decodedLineThickness, &decodedX, &decodedY, &decodedBottom, &decodedRight, &decodedRounding);
                    // http://mirror.informatimago.com/next/developer.apple.com/documentation/mac/QuickDraw/QuickDraw-102.html#MARKER-9-372
                    // http://mirror.informatimago.com/next/developer.apple.com/documentation/mac/QuickDraw/QuickDraw-103.html#HEADING103-0

                    char logMessage[255];

                    // sprintf(logMessage, "RECT: decodedColor: %d, decodedLineThickness: %d, decodedX: %d, decodedY: %d, decodedBottom: %d, decodedRight: %d, decodedRounding: %d", decodedColor, decodedLineThickness, decodedX, decodedY, decodedBottom, decodedRight, decodedRounding);
                    // writeSerialPortDebug(boutRefNum, logMessage);
                    color = nk_color_to_quickdraw_bw_color(decodedColor);
                    ForeColor(color);

                    PenSize((float)decodedLineThickness, (float)decodedLineThickness);

                    Rect quickDrawRectangle;
                    quickDrawRectangle.top = decodedY;
                    quickDrawRectangle.left = decodedX;
                    quickDrawRectangle.bottom = decodedBottom;
                    quickDrawRectangle.right = decodedRight;

                    FrameRoundRect(&quickDrawRectangle, (float)decodedRounding, (float)decodedRounding);
                }

                break;
            // case NK_COMMAND_RECT_FILLED: {
            case 'Z': {
                
                    #ifdef NK_QUICKDRAW_GRAPHICS_DEBUGGING

                        writeSerialPortDebug(boutRefNum, "NK_COMMAND_RECT_FILLED");
                    #endif

                    int decodedColor;
                    int decodedColorPattern;
                    int decodedX;
                    int decodedY;
                    int decodedBottom;
                    int decodedRight;
                    int decodedRounding;

                    sscanf(command, "Z%01d%01d%04d%04d%04d%04d%04d", &decodedColor, &decodedColorPattern, &decodedX, &decodedY, &decodedBottom, &decodedRight, &decodedRounding);

                    char logMessage[255];

                    // sprintf(logMessage, "RECT FILLED: decodedColor: %d, decodedColorPattern: %d, decodedX: %d, decodedY: %d, decodedBottom: %d, decodedRight: %d, decodedRounding: %d", decodedColor, decodedColorPattern, decodedX, decodedY, decodedBottom, decodedRight, decodedRounding);
                    // writeSerialPortDebug(boutRefNum, logMessage);

                    color = nk_color_to_quickdraw_bw_color(decodedColor);
                    
                    ForeColor(color);
                    Pattern colorPattern = nk_color_to_quickdraw_color(decodedColorPattern);

                    // BackPat(&colorPattern); // inside macintosh: imaging with quickdraw 3-48
                    PenSize(1.0, 1.0); // no member line thickness on this struct so assume we want a thin line
                    // might actually need to build this with SetRect, search inside macintosh: imaging with quickdraw
                    Rect quickDrawRectangle;
                    quickDrawRectangle.top = decodedY;
                    quickDrawRectangle.left = decodedX;
                    quickDrawRectangle.bottom = decodedBottom;
                    quickDrawRectangle.right = decodedRight;

                    PenPat(&colorPattern);
                    //FillRoundRect(&quickDrawRectangle, (float)decodedRounding, (float)decodedRounding, &colorPattern);
                    PaintRoundRect(&quickDrawRectangle, (float)decodedRounding, (float)decodedRounding);
                    PenNormal();
                }

                break;
            // case NK_COMMAND_CIRCLE: {
            case 'C': {

                    #ifdef NK_QUICKDRAW_GRAPHICS_DEBUGGING

                        writeSerialPortDebug(boutRefNum, "NK_COMMAND_CIRCLE");
                    #endif

                    // const struct nk_command_circle *c = (const struct nk_command_circle *)cmd;
                    // color = nk_color_to_quickdraw_bw_color(atoi(c)->color);
                    
                    // ForeColor(color);  
                    
                    // Rect quickDrawRectangle;
                    // quickDrawRectangle.top = (int)c->y;
                    // quickDrawRectangle.left = (int)c->x;
                    // quickDrawRectangle.bottom = (int)c->y + (int)c->h;
                    // quickDrawRectangle.right = (int)c->x + (int)c->w;

                    // FrameOval(&quickDrawRectangle); // An oval is a circular or elliptical shape defined by the bounding rectangle that encloses it. inside macintosh: imaging with quickdraw 3-25
               }

                break;
            //case NK_COMMAND_CIRCLE_FILLED: {
            case 'X': {

                    #ifdef NK_QUICKDRAW_GRAPHICS_DEBUGGING

                        writeSerialPortDebug(boutRefNum, "NK_COMMAND_CIRCLE_FILLED");
                    #endif

                    // const struct nk_command_circle_filled *c = (const struct nk_command_circle_filled *)cmd;
                    
                    // color = nk_color_to_quickdraw_bw_color(atoi(c)->color);
                    
                    // ForeColor(color);
                    // Pattern colorPattern = nk_color_to_quickdraw_color(&c->color);
                    // // BackPat(&colorPattern); // inside macintosh: imaging with quickdraw 3-48
                    // PenSize(1.0, 1.0);
                    // Rect quickDrawRectangle;
                    // quickDrawRectangle.top = (int)c->y;
                    // quickDrawRectangle.left = (int)c->x;
                    // quickDrawRectangle.bottom = (int)c->y + (int)c->h;
                    // quickDrawRectangle.right = (int)c->x + (int)c->w;

                    // FillOval(&quickDrawRectangle, &colorPattern); 
                    // FrameOval(&quickDrawRectangle);// An oval is a circular or elliptical shape defined by the bounding rectangle that encloses it. inside macintosh: imaging with quickdraw 3-25
                    // // http://mirror.informatimago.com/next/developer.apple.com/documentation/mac/QuickDraw/QuickDraw-111.html#HEADING111-0
                }

                break;
            //case NK_COMMAND_TRIANGLE: {
                case 'T': {

                    #ifdef NK_QUICKDRAW_GRAPHICS_DEBUGGING

                        writeSerialPortDebug(boutRefNum, "NK_COMMAND_TRIANGLE");
                    #endif

                    // const struct nk_command_triangle *t = (const struct nk_command_triangle*)cmd;
                    // color = nk_color_to_quickdraw_bw_color(atoi(t)->color);
                    
                    // ForeColor(color);
                    // PenSize((float)t->line_thickness, (float)t->line_thickness);

                    // MoveTo((float)t->a.x, (float)t->a.y);
                    // LineTo((float)t->b.x, (float)t->b.y);
                    // LineTo((float)t->c.x, (float)t->c.y);
                    // LineTo((float)t->a.x, (float)t->a.y);
                }

                break;
            // case NK_COMMAND_TRIANGLE_FILLED: {
            case 'Y': {

                    #ifdef NK_QUICKDRAW_GRAPHICS_DEBUGGING

                        writeSerialPortDebug(boutRefNum, "NK_COMMAND_TRIANGLE_FILLED");
                    #endif

                    // const struct nk_command_triangle_filled *t = (const struct nk_command_triangle_filled *)cmd;
                    // Pattern colorPattern = nk_color_to_quickdraw_color(&t->color);
                    // color = nk_color_to_quickdraw_bw_color(atoi(t)->color);
                    // PenSize(1.0, 1.0);
                    // // BackPat(&colorPattern); // inside macintosh: imaging with quickdraw 3-48
                    // ForeColor(color);

                    // PolyHandle trianglePolygon = OpenPoly(); 
                    // MoveTo((float)t->a.x, (float)t->a.y);
                    // LineTo((float)t->b.x, (float)t->b.y);
                    // LineTo((float)t->c.x, (float)t->c.y);
                    // LineTo((float)t->a.x, (float)t->a.y);
                    // ClosePoly();

                    // FillPoly(trianglePolygon, &colorPattern);
                    // KillPoly(trianglePolygon);
                }

                break;
                // TODO: havent implemented these yet
            /*case NK_COMMAND_POLYGON: {
                
                    
                    if (NK_QUICKDRAW_GRAPHICS_DEBUGGING) {

                        writeSerialPortDebug(boutRefNum, "NK_COMMAND_POLYGON");
                    }

                    const struct nk_command_polygon *p = (const struct nk_command_polygon*)cmd;

                    color = nk_color_to_quickdraw_bw_color(atoi(p)->color);

                    int i;

                    for (i = 0; i < p->point_count; i++) {
                        
                        if (i == 0) {
                            
                            MoveTo(p->points[i].x, p->points[i].y);
                        }
                        
                        LineTo(p->points[i].x, p->points[i].y);
                        
                        if (i == p->point_count - 1) {
                            
                            
                            LineTo(p->points[0].x, p->points[0].y);
                        }
                    }
                }
                
                break;
            case NK_COMMAND_POLYGON_FILLED: {
                    
                    
                    if (NK_QUICKDRAW_GRAPHICS_DEBUGGING) {

                        writeSerialPortDebug(boutRefNum, "NK_COMMAND_POLYGON_FILLED");
                    }

                    const struct nk_command_polygon *p = (const struct nk_command_polygon*)cmd;

                    Pattern colorPattern = nk_color_to_quickdraw_color(&p->color);
                    color = nk_color_to_quickdraw_bw_color(atoi(p)->color);
                    // BackPat(&colorPattern); // inside macintosh: imaging with quickdraw 3-48 -- but might actually need PenPat -- look into this
                    ForeColor(color);

                    int i;

                    PolyHandle trianglePolygon = OpenPoly(); 
                    for (i = 0; i < p->point_count; i++) {
                        
                        if (i == 0) {
                            
                            MoveTo(p->points[i].x, p->points[i].y);
                        }
                        
                        LineTo(p->points[i].x, p->points[i].y);
                        
                        if (i == p->point_count - 1) {
                            
                            
                            LineTo(p->points[0].x, p->points[0].y);
                        }
                    }
                    
                    ClosePoly();

                    FillPoly(trianglePolygon, &colorPattern);
                    KillPoly(trianglePolygon);
                }
                
                break;
            case NK_COMMAND_POLYLINE: {

                    if (NK_QUICKDRAW_GRAPHICS_DEBUGGING) {

                        writeSerialPortDebug(boutRefNum, "NK_COMMAND_POLYLINE");
                    }

                    // this is similar to polygons except the polygon does not get closed to the 0th point
                    // check out the slight difference in the for loop
                    const struct nk_command_polygon *p = (const struct nk_command_polygon*)cmd;

                    color = nk_color_to_quickdraw_bw_color(atoi(p)->color);
                    ForeColor(color);

                    int i;

                    for (i = 0; i < p->point_count; i++) {
                        
                        if (i == 0) {
                            
                            MoveTo(p->points[i].x, p->points[i].y);
                        }
                        
                        LineTo(p->points[i].x, p->points[i].y);
                    }
                }

                break;*/
            //case NK_COMMAND_TEXT: {

            case 'S': {
                    
                    #ifdef NK_QUICKDRAW_GRAPHICS_DEBUGGING

                        writeSerialPortDebug(boutRefNum, "NK_COMMAND_TEXT");
                        char log[255];
                        //sprintf(log, "%f: %s, %d", (float)t->height, &t->string, (int)t->length);
                        writeSerialPortDebug(boutRefNum, log);
                    #endif

                    int decodedColor;
                    int decodedHeight;
                    int decodedX;
                    int decodedY;
                    int decodedLength;
                    char decodedString[240];

                    sscanf(command, "S%01d%04d%04d%04d%04d", &decodedColor, &decodedHeight, &decodedX, &decodedY, &decodedLength);
                    // 18 until string
                    memcpy(decodedString, command + 18, strlen(command) - 18);

                    color = nk_color_to_quickdraw_bw_color(decodedColor);
                    ForeColor(color);
                    MoveTo((float)decodedX, (float)decodedY + decodedHeight);
                    TextSize(decodedHeight); 
                    DrawText((const char*)decodedString, 0, decodedLength);
                }

                break;/* TODO
            case NK_COMMAND_CURVE: {
                    
                    if (NK_QUICKDRAW_GRAPHICS_DEBUGGING) {

                        writeSerialPortDebug(boutRefNum, "NK_COMMAND_CURVE");
                    }

                    const struct nk_command_curve *q = (const struct nk_command_curve *)cmd;
                    color = nk_color_to_quickdraw_bw_color(atoi(q)->color);
                    ForeColor(color);
                    Point p1 = { (float)q->begin.x, (float)q->begin.y};
                    Point p2 = { (float)q->ctrl[0].x, (float)q->ctrl[0].y};
                    Point p3 = { (float)q->ctrl[1].x, (float)q->ctrl[1].y};
                    Point p4 = { (float)q->end.x, (float)q->end.y};

                    BezierCurve(p1, p2, p3, p4);
                }

                break;
            case NK_COMMAND_ARC: {

                    if (NK_QUICKDRAW_GRAPHICS_DEBUGGING) {

                        writeSerialPortDebug(boutRefNum, "NK_COMMAND_ARC");
                    }

                    const struct nk_command_arc *a = (const struct nk_command_arc *)cmd;
                    color = nk_color_to_quickdraw_bw_color(atoi(a)->color);
                    ForeColor(color);
                    
                    Rect arcBoundingBoxRectangle;
                    // this is kind of silly because the cx is at the center of the arc and we need to create a rectangle around it 
                    // http://mirror.informatimago.com/next/developer.apple.com/documentation/mac/QuickDraw/QuickDraw-60.html#MARKER-2-116
                    float x1 = (float)a->cx - (float)a->r;
                    float y1 = (float)a->cy - (float)a->r;
                    float x2 = (float)a->cx + (float)a->r;
                    float y2 = (float)a->cy + (float)a->r;
                    SetRect(&arcBoundingBoxRectangle, x1, y1, x2, y2);
                    // SetRect(secondRect,90,20,140,70);

                    FrameArc(&arcBoundingBoxRectangle, a->a[0], a->a[1]);
                }

                break;
            case NK_COMMAND_IMAGE: {

                    if (NK_QUICKDRAW_GRAPHICS_DEBUGGING) {

                        writeSerialPortDebug(boutRefNum, "NK_COMMAND_IMAGE");  
                    }

                    const struct nk_command_image *i = (const struct nk_command_image *)cmd;
                    // al_draw_bitmap_region(i->img.handle.ptr, 0, 0, i->w, i->h, i->x, i->y, 0); // TODO: look up and convert al_draw_bitmap_region
                    // TODO: consider implementing a bitmap drawing routine. we could iterate pixel by pixel and draw
                    // here is some super naive code that could work, used for another project that i was working on with a custom format but would be
                    // easy to modify for standard bitmap files (just need to know how many bytes represent each pixel and iterate from there):
                    // 
                    // for (int i = 0; i < strlen(string); i++) {
                    //     printf("\nchar: %c", string[i]);
                    //     char pixel[1];
                    //     memcpy(pixel, &string[i], 1);
                    //     if (strcmp(pixel, "0") == 0) { // white pixel
                    //         MoveTo(++x, y);
                    //      } else if (strcmp(pixel, "1") == 0) { // black pixel
                    //          // advance the pen and draw a 1px x 1px "line"
                    //          MoveTo(++x, y);
                    //          LineTo(x, y);
                    //      } else if (strcmp(pixel, "|") == 0) { // next line
                    //          x = 1;
                    //          MoveTo(x, ++y);
                    //      } else if (strcmp(pixel, "/") == 0) { // end
                    //      }
                    //  }
                }
                
                break;
                
            // why are these cases not implemented?
            case NK_COMMAND_RECT_MULTI_COLOR:
            case NK_COMMAND_ARC_FILLED:*/
            default:
            
                #ifdef NK_QUICKDRAW_GRAPHICS_DEBUGGING

                    writeSerialPortDebug(boutRefNum, "NK_COMMAND_RECT_MULTI_COLOR/NK_COMMAND_ARC_FILLED/default");
                #endif
                break;
        }

        command = strtok(NULL, "\n");
    }

    // writeSerialPortDebug(boutRefNum, "done with commands, copying bits to current window");
    memset(commands, 0, 102400);

    //setPort(window);

    CopyBits(&((GrafPtr)myOffScreenWorld)->portBits, &((GrafPtr)origPort)->portBits, &myOffScreenWorld->portRect, &origPort->portRect, srcCopy, NULL);
    UnlockPixels(offPixMapHandle);
    DisposeGWorld(myOffScreenWorld);

    // our offscreen bitmap is the same size as our port rectangle, so we
    // get away with using the portRect sizing for source and destination
    // CopyBits(&gMainOffScreen.bits->portBits, &window->portBits, &window->portRect, &window->portRect, srcCopy, 0L);
}

void nk_quickdraw_handle_event(EventRecord *event) { 
    // see: inside macintosh: toolbox essentials 2-4
    // and  inside macintosh toolbox essentials 2-79

    WindowPtr window;
    FindWindow(event->where, &window); 
    // char *logb;
    // sprintf(logb, "nk_quickdraw_handle_event event %d", event->what);
    // writeSerialPortDebug(boutRefNum, logb);

    switch (event->what) {
        case updateEvt: {
                return;
            }
            break;
        case osEvt: { 
            // the quicktime osEvts are supposed to cover mouse movement events
            // notice that we are actually calling nk_input_motion in the EventLoop for the program
            // instead, as handling this event directly does not appear to work for whatever reason
            // TODO: research this
            writeSerialPortDebug(boutRefNum, "osEvt");

                switch (event->message) {

                    case mouseMovedMessage: {

                        #ifdef NK_QUICKDRAW_EVENTS_DEBUGGING
                            
                            writeSerialPortDebug(boutRefNum, "mouseMovedMessage");
                        #endif


                        // event->where should have coordinates??? or is it just a pointer to what the mouse is over?
                        // TODO need to figure this out
                        // nk_input_motion(nuklear_context, event->where.h, event->where.v); // TODO figure out mouse coordinates - not sure if this is right
                        //callFunctionOnCoprocessor("runEvent", "M100,100", jsFunctionResponse); // TODO fix coordinates

                        char output[128];
                        sprintf(output, "M%d,%d", event->where.h, event->where.v);

                        callFunctionOnCoprocessor("runEvent", output, jsFunctionResponse);
                        break;
                    }
                }
            }
            break;
        
        case mouseUp: 
            #ifdef NK_QUICKDRAW_EVENTS_DEBUGGING

                writeSerialPortDebug(boutRefNum, "mouseUp!!!");
            #endif
        case mouseDown: {
            #ifdef NK_QUICKDRAW_EVENTS_DEBUGGING

                writeSerialPortDebug(boutRefNum, "mouseUp/Down");
            #endif
            
            short part = FindWindow(event->where, &window);

			switch (part) {
                case inContent: {
                    // event->where should have coordinates??? or is it just a pointer to what the mouse is over?
                    // TODO need to figure this out
                    #ifdef NK_QUICKDRAW_EVENTS_DEBUGGING

                        writeSerialPortDebug(boutRefNum, "mouseUp/Down IN DEFAULT ZONE!!!!");
                    #endif

                    // this converts the offset of the window to the actual location of the mouse within the window
                    Point tempPoint;
                    SetPt(&tempPoint, event->where.h, event->where.v);
                    GlobalToLocal(&tempPoint);
                    
                    if (!event->where.h) {
                        
                        #ifdef NK_QUICKDRAW_EVENTS_DEBUGGING

                            writeSerialPortDebug(boutRefNum, "no event location for mouse!!!!");
                        #endif
                        return;
                    }
                    int x = tempPoint.h;
                    int y = tempPoint.v;

                    #ifdef NK_QUICKDRAW_EVENTS_DEBUGGING

                        char *logx;
                        sprintf(logx, "xxxx h: %d,  v: %d", x, y);
                        writeSerialPortDebug(boutRefNum, logx);
                    #endif

                    // nk_input_motion(nuklear_context, x, y); // TODO let's do this on the headless end!!
                    // nk_input_button(nuklear_context, NK_BUTTON_LEFT, x, y, event->what == mouseDown);
                    // TODO coordinates
                    if (event->what == mouseDown) {

                        char output[128];
                        sprintf(output, "D%d,%d", x, y);

                        callFunctionOnCoprocessor("runEvent", output, jsFunctionResponse);
                    } else {
                        char output[128];
                        sprintf(output, "U%d,%d", x, y);

                        callFunctionOnCoprocessor("runEvent", output, jsFunctionResponse);
                    }
                }
                break;
            }
            
            break;
        case keyDown:
		case autoKey: {/* check for menukey equivalents */
                #ifdef NK_QUICKDRAW_EVENTS_DEBUGGING

                    writeSerialPortDebug(boutRefNum, "keyDown/autoKey");
                #endif

                char key = event->message & charCodeMask;
                //    writeSerialPortDebug(boutRefNum, key);
                const Boolean keyDown = event->what == keyDown;

                if (event->modifiers & cmdKey) {/* Command key down */

                    if (keyDown) {

                        // AdjustMenus();						/* enable/disable/check menu items properly */
                        // DoMenuCommand(MenuKey(key));
                    }
                    
                    if (key == 'c') {
                        
                        // nk_input_key(nuklear_context, NK_KEY_COPY, 1);
                        callFunctionOnCoprocessor("runEvent", "KcC", jsFunctionResponse);
                    } else if (key == 'v') {
                        
                        callFunctionOnCoprocessor("runEvent", "KvC", jsFunctionResponse);
                    } else if (key == 'x') {
                        
                        callFunctionOnCoprocessor("runEvent", "KxC", jsFunctionResponse);
                    } else if (key == 'z') {
                        
                        callFunctionOnCoprocessor("runEvent", "KzC", jsFunctionResponse);
                    } else if (key == 'r') {
                        
                        callFunctionOnCoprocessor("runEvent", "KrC", jsFunctionResponse);
                    } 
                } else if (key == eitherShiftKey) {
                    
                    // TODO
                    // nk_input_key(nuklear_context, NK_KEY_SHIFT, keyDown);
                } else if (key == deleteKey) {
                    
                    // TODO
                    // nk_input_key(nuklear_context, NK_KEY_DEL, keyDown);
                } else if (key == enterKey) {
                    
                    // TODO
                    // nk_input_key(nuklear_context, NK_KEY_ENTER, keyDown);
                } else if (key == tabKey) {
                    
                    // TODO
                    // nk_input_key(nuklear_context, NK_KEY_TAB, keyDown);
                } else if (key == leftArrowKey) {
                    
                    // TODO
                    // nk_input_key(nuklear_context, NK_KEY_LEFT, keyDown);
                } else if (key == rightArrowKey) {
                    
                    // TODO
                    // nk_input_key(nuklear_context, NK_KEY_RIGHT, keyDown);
                } else if (key == upArrowKey) {
                    
                    // TODO
                    // nk_input_key(nuklear_context, NK_KEY_UP, keyDown);
                } else if (key == downArrowKey) {
                    
                    // TODO
                    // nk_input_key(nuklear_context, NK_KEY_DOWN, keyDown);
                } else if (key == backspaceKey) {
                    
                    // TODO
                    // nk_input_key(nuklear_context, NK_KEY_BACKSPACE, keyDown);
                } else if (key == escapeKey) {
                    
                    // TODO
                    // nk_input_key(nuklear_context, NK_KEY_TEXT_RESET_MODE, keyDown);
                } else if (key == pageUpKey) {
                 
                    // TODO
                    // nk_input_key(nuklear_context, NK_KEY_SCROLL_UP, keyDown);
                } else if (key == pageDownKey) {
                    
                    // TODO
                    // nk_input_key(nuklear_context, NK_KEY_SCROLL_DOWN, keyDown);
                } else if (key == homeKey) {

                    // TODO
                    // nk_input_key(nuklear_context, NK_KEY_TEXT_START, keyDown);
                    // TODO
                    // nk_input_key(nuklear_context, NK_KEY_SCROLL_START, keyDown);
                } else if (key == endKey) {

                    // TODO
                    // nk_input_key(nuklear_context, NK_KEY_TEXT_END, keyDown);
                    // TODO
                    // nk_input_key(nuklear_context, NK_KEY_SCROLL_END, keyDown);
                } else {
                    
                    // nk_input_unicode(nuklear_context, key);
                    char output[3];
                    sprintf(output, "K%c ", key);
                    callFunctionOnCoprocessor("runEvent", output, jsFunctionResponse);
                    // writeSerialPortDebug(boutRefNum, "got response after key input");
                    // writeSerialPortDebug(boutRefNum, jsFunctionResponse);
                }
            }
			break;
        default: {
                #ifdef NK_QUICKDRAW_EVENTS_DEBUGGING

                    writeSerialPortDebug(boutRefNum, "default unhandled event");
                #endif
            
                return; 
            }
            break;
        }
    }

    nk_quickdraw_render(window, jsFunctionResponse);
}

// it us up to our "main" function to call this code
void nk_quickdraw_init(unsigned int width, unsigned int height) {

    // needed to calculate bezier info, see mactech article.
    setupBezier();

    NewShockBitmap(&gMainOffScreen, width, height);
}