-- Main function for conky Lua scripts

require 'math'
require 'cairo'
require 'os'

-- math set up

function rad(d)
    return d*math.pi/180
end

sin60 = math.sin(rad(60))
cos60 = math.cos(rad(60))

-- Fonts

font="Roboto"
font_size=10
font_slant=CAIRO_FONT_SLANT_NORMAL
font_face=CAIRO_FONT_WEIGHT_NORMAL

-- Colours

-- Colour white
cw_r,cw_g,cw_b=1,1,1
-- Colour grey
cg_r,cg_g,cg_b=0.7,0.7,0.7
-- Colour blue
cb_r,cb_g,cb_b=38/255,139/255,210/255
-- Colour black
ck_r,ck_g,ck_b=0,0,0

-- Hexagon Utilities

-- Draw hexagon, given left-most point
function draw_hex_helper( cr, x, y, length, width, r, g, b, a)
    cairo_set_source_rgba(cr,r,g,b,a)
    cairo_set_line_width(cr,width)
    cairo_move_to(cr,x,y)
    cairo_rel_line_to(cr, length*cos60, length*sin60)
    cairo_rel_line_to(cr, length, 0)
    cairo_rel_line_to(cr, length*cos60, -length*sin60)
    cairo_rel_line_to(cr, -length*cos60, -length*sin60)
    cairo_rel_line_to(cr, -length, 0)
    cairo_rel_line_to(cr, -length*cos60, length*sin60)
    cairo_close_path(cr)
    cairo_stroke(cr)
end
function draw_hex( cr, x, y, length, width)
    draw_hex_helper(cr,x,y,length,width,cb_r,cb_g,cb_b,1.0)
    -- Add cheap blur
    draw_hex_helper(cr,x,y,length,width+10,cb_r,cb_g,cb_b,0.02)
    draw_hex_helper(cr,x,y,length,width+8,cb_r,cb_g,cb_b,0.05)
    draw_hex_helper(cr,x,y,length,width+6,cb_r,cb_g,cb_b,0.07)
    draw_hex_helper(cr,x,y,length,width+4,cb_r,cb_g,cb_b,0.1)
    draw_hex_helper(cr,x,y,length,width+3,cb_r,cb_g,cb_b,0.2)
    draw_hex_helper(cr,x,y,length,width+2,cb_r,cb_g,cb_b,0.3)
    -- This solution will, unfortunately, result in thicker
    -- lines in between hexagones than at the outer edges.
    -- The effect is strongest where 3 hexes meet. Much simpler
    -- than doing a real blur with cairo though...
end

-- Given left-most point on hexagon, get top right point
function to_hex_tr( x, y, length)
    return x+length*(1+cos60), y-length*sin60
end

-- Given top-right point on hexagon, get left point
function from_hex_tr( x, y, length)
    return x-length*(1+cos60), y+length*sin60
end

-- Given left-most point on hexagon, get bottom right point
function to_hex_br( x, y, length)
    return x+length*(1+cos60), y+length*sin60
end

-- Given bottom-right point on hexagon, get left point
function from_hex_br( x, y, length)
    return x-length*(1+cos60), y-length*sin60
end

-- Given left point of hexagon, get center
function to_hex_c( x, y, length)
    return x+length*(0.5+cos60), y
end

-- Given center of hexagon, get left point
function from_hex_c( x, y, length)
    return x-length*(0.5+cos60), y
end

-- Text Utils

-- Write center-aligned text
function write_text_centered(cr,x,y,text,extents)
    cairo_text_extents(cr,text,extents)
    x,y = x - (extents.width/2 + extents.x_bearing), y - (extents.height/2 + extents.y_bearing)
    cairo_move_to(cr,x,y)
    cairo_show_text(cr,text)
    cairo_stroke(cr)
end

-- Gauges

function draw_gauge( cr, x, y, fill, radius)
    ring_width=8
    ring_start=rad(90)
    ring_end=rad(360)
    -- Background
    cairo_set_line_width(cr,ring_width)
    cairo_set_source_rgba(cr,cw_r,cw_g,cw_b,0.6)
    cairo_arc(cr,x,y,radius,ring_start-0.02,ring_end+0.02)
    cairo_stroke(cr)
    -- Cheap blur
    cairo_set_line_width(cr,ring_width+2)
    cairo_set_source_rgba(cr,cw_r,cw_g,cw_b,0.2)
    cairo_arc(cr,x,y,radius,ring_start-0.04,ring_end+0.04)
    cairo_stroke(cr)
    cairo_set_line_width(cr,ring_width+4)
    cairo_set_source_rgba(cr,cw_r,cw_g,cw_b,0.1)
    cairo_arc(cr,x,y,radius,ring_start-0.04,ring_end+0.04)
    cairo_stroke(cr)
    -- Black fill
    cairo_set_line_width(cr,ring_width-4)
    cairo_set_source_rgb(cr,ck_r,ck_g,ck_b)
    cairo_arc(cr,x,y,radius,ring_start,ring_end)
    cairo_stroke(cr)
    -- Blue meter
    meter_end=ring_start + (ring_end-ring_start)*fill
    cairo_set_line_width(cr,ring_width-6)
    cairo_set_source_rgb(cr,cb_r,cb_g,cb_b)
    cairo_arc(cr,x,y,radius,ring_start,meter_end)
    cairo_stroke(cr)
    -- Cheap blur
    cairo_set_line_width(cr,ring_width-4)
    cairo_set_source_rgba(cr,cb_r,cb_g,cb_b,0.8)
    cairo_arc(cr,x,y,radius,ring_start,meter_end)
    cairo_stroke(cr)
    cairo_set_line_width(cr,ring_width)
    cairo_set_source_rgba(cr,cb_r,cb_g,cb_b,0.5)
    cairo_arc(cr,x,y,radius,ring_start,meter_end)
    cairo_stroke(cr)
end

-- Colours

function set_white(cr)
    cairo_set_source_rgb(cr,cw_r,cw_g,cw_b)
end
function set_grey(cr)
    cairo_set_source_rgb(cr,cg_r,cg_g,cg_b)
end
function set_blue(cr)
    cairo_set_source_rgb(cr,cb_r,cb_g,cb_b)
end
function set_black(cr)
    cairo_set_source_rgb(cr,ck_r,ck_g,ck_b)
end

-- Main function

function conky_main()

    if conky_window == nil then
        return
    end

    -- Create cairo drawing surface
    local cs = cairo_xlib_surface_create(conky_window.display,
                                         conky_window.drawable,
                                         conky_window.visual,
                                         conky_window.width,
                                         conky_window.height)
    cr = cairo_create(cs)
    cairo_set_antialias(cr,CAIRO_ANTIALIAS_DEFAULT)

    -- Set up text output
    cairo_select_font_face( cr, font, font_slant, font_face)
    cairo_set_font_size(cr,font_size)
    local extents = cairo_text_extents_t:create()

    -- Get wireless driver
    wlan=os.getenv("WLAN")

    -- Set up shapes
    hex_length=70
    hex_width=1
    gauge_radius=50

    -- Begin drawing
    x,y=10,500

    -- Decorative hex
    draw_hex(cr,x,y,hex_length,hex_width)
    x,y=to_hex_tr(x,y,hex_length)

    -- CPU hex
    draw_hex(cr,x,y,hex_length,hex_width)
    cpu=tonumber(conky_parse('${cpu}'))
    cpu_max=100
    x,y=to_hex_c(x,y,hex_length)
    set_white(cr)
    write_text_centered(cr,x,y-5,"CPU",extents)
    set_grey(cr)
    write_text_centered(cr,x,y+5,tostring(cpu).."%",extents)
    draw_gauge(cr,x,y,cpu/cpu_max,gauge_radius)
    x,y=from_hex_c(x,y,hex_length)

    -- RAM hex
    x,y=to_hex_br(x,y,hex_length)
    draw_hex(cr,x,y,hex_length,hex_width)
    mem=conky_parse('${mem}')
    mem_max=conky_parse('${memmax}')
    mem_perc=tonumber(conky_parse('${memperc}'))
    x,y=to_hex_c(x,y,hex_length)
    set_white(cr)
    write_text_centered(cr,x,y-10,"RAM",extents)
    set_grey(cr)
    write_text_centered(cr,x,y,mem.."/"..mem_max,extents)
    write_text_centered(cr,x,y+10,tostring(mem_perc).."%",extents)
    draw_gauge(cr,x,y,mem_perc/100,gauge_radius)
    x,y=from_hex_c(x,y,hex_length)

    -- Swap hex
    x,y=to_hex_tr(x,y,hex_length)
    draw_hex(cr,x,y,hex_length,hex_width)
    swap=conky_parse('${swap}')
    swap_max=conky_parse('${swapmax}')
    swap_perc=tonumber(conky_parse('${swapperc}'))
    x,y=to_hex_c(x,y,hex_length)
    set_white(cr)
    write_text_centered(cr,x,y-10,"SWAP",extents)
    set_grey(cr)
    write_text_centered(cr,x,y,swap.."/"..swap_max,extents)
    write_text_centered(cr,x,y+10,tostring(swap_perc).."%",extents)
    draw_gauge(cr,x,y,swap_perc/100,gauge_radius)
    x,y=from_hex_c(x,y,hex_length)

    -- File system hex
    x,y=to_hex_br(x,y,hex_length)
    draw_hex(cr,x,y,hex_length,hex_width)
    fs=conky_parse('${fs_used}')
    fs_max=conky_parse('${fs_size}')
    fs_perc=tonumber(conky_parse('${fs_used_perc}'))
    x,y=to_hex_c(x,y,hex_length)
    set_white(cr)
    write_text_centered(cr,x,y-10,"HDD",extents)
    set_grey(cr)
    write_text_centered(cr,x,y,fs.."/"..fs_max,extents)
    write_text_centered(cr,x,y+10,tostring(fs_perc).."%",extents)
    draw_gauge(cr,x,y,fs_perc/100,gauge_radius)
    x,y=from_hex_c(x,y,hex_length)

    -- Network hex
    x,y=from_hex_br(x,y,hex_length)
    x,y=to_hex_tr(x,y,hex_length)
    draw_hex(cr,x,y,hex_length,hex_width)
    x,y=to_hex_c(x,y,hex_length)
    set_white(cr)
    write_text_centered(cr,x,y-25,"NETWORK",extents)
    write_text_centered(cr,x,y-10,"UPSPEED",extents)
    set_grey(cr)
    write_text_centered(cr,x,y,conky_parse('${upspeed '..wlan..'}'),extents)
    set_white(cr)
    write_text_centered(cr,x,y+10,"DOWNSPEED",extents)
    set_grey(cr)
    write_text_centered(cr,x,y+20,conky_parse('${downspeed '..wlan..'}'),extents)
    x,y=from_hex_c(x,y,hex_length)

    -- Processes hex
    x,y=from_hex_br(x,y,hex_length)
    draw_hex(cr,x,y,hex_length,hex_width)
    x,y=to_hex_c(x,y,hex_length)
    set_white(cr)
    write_text_centered(cr,x,y-15,"PROCESSES",extents)
    set_grey(cr)
    write_text_centered(cr,x,y-5,conky_parse('${processes}'),extents)
    set_white(cr)
    write_text_centered(cr,x,y+5,"RUNNING",extents)
    set_grey(cr)
    write_text_centered(cr,x,y+15,conky_parse('${running_processes}'),extents)
    x,y=from_hex_c(x,y,hex_length)

    -- Decorative hexes
    x,y=to_hex_tr(x,y,hex_length)
    draw_hex(cr,x,y,hex_length,hex_width)
    x,y=from_hex_br(x,y,hex_length)
    x,y=to_hex_tr(x,y,hex_length)
    draw_hex(cr,x,y,hex_length,hex_width)

    -- clean up cairo
    cairo_destroy(cr)
    cairo_surface_destroy(cs)
    cr=nil
end
