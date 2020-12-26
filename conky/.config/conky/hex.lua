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

-- white
cw = {r=1,g=1,b=1}
-- grey
cg = {r=0.7,g=0.7,b=0.7}
-- blue
cb = {r=38/255,g=139/255,b=210/255}
-- black
ck = {r=0,g=0,b=0}

-- Utilities

-- Draw hexagon, given centre point

function draw_hex_helper( cr, x, y, length, linewidth, color, opaqueness)
    cairo_set_source_rgba(cr,color.r,color.g,color.b,opaqueness)
    cairo_set_line_width(cr,linewidth)
    xstart = x-length*(0.5+cos60)
    cairo_move_to(cr,xstart,y)
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
    draw_hex_helper(cr,x,y,length,width,cb,1.0)
    -- Add cheap blur
    draw_hex_helper(cr,x,y,length,width+10,cb,0.02)
    draw_hex_helper(cr,x,y,length,width+8,cb,0.05)
    draw_hex_helper(cr,x,y,length,width+6,cb,0.07)
    draw_hex_helper(cr,x,y,length,width+4,cb,0.1)
    draw_hex_helper(cr,x,y,length,width+3,cb,0.2)
    draw_hex_helper(cr,x,y,length,width+2,cb,0.3)
    -- This solution will, unfortunately, result in thicker
    -- lines in between hexagones than at the outer edges.
    -- The effect is strongest where 3 hexes meet. Much simpler
    -- than doing a real blur with cairo though...
end

-- Move around hexagon grid

function hex_move(x,y,length,dir)
    xleft = x-length*(0.5+cos60)
    xright = x+length*(0.5+cos60)
    if dir=="top left" then
        return xleft - length*cos60, y - length*sin60
    elseif dir=="bottom left" then
        return xleft - length*cos60, y + length*sin60
    elseif dir=="top right" then
        return xright + length*cos60, y - length*sin60
    elseif dir=="bottom right" then
        return xright + length*cos60, y + length*sin60
    elseif dir=="top" then
        return x, y - 2*length*sin60
    elseif dir=="bottom" then
        return x, y + 2*length*sin60
    else
        return x,y
    end
end

-- Draw line, given start and end points

function draw_line( cr, xstart, xend, ystart, yend, width, color, opaqueness)
    cairo_set_source_rgba(cr,color.r,color.g,color.b,opaqueness)
    cairo_set_line_width(cr,width)
    cairo_move_to(cr,xstart,ystart)
    cairo_rel_line_to(cr, xend-xstart, yend-ystart)
    cairo_close_path(cr)
    cairo_stroke(cr)
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

function draw_circle_gauge( cr, x, y, fill, radius)
    ring_width=8
    ring_start=rad(90)
    ring_end=rad(360)
    -- Background
    cairo_set_line_width(cr,ring_width)
    cairo_set_source_rgba(cr,cw.r,cw.g,cw.b,0.4)
    cairo_arc(cr,x,y,radius,ring_start-0.04,ring_end+0.04)
    cairo_stroke(cr)
    -- Cheap blur
    cairo_set_line_width(cr,ring_width+2)
    cairo_set_source_rgba(cr,cw.r,cw.g,cw.b,0.2)
    cairo_arc(cr,x,y,radius,ring_start-0.08,ring_end+0.08)
    cairo_stroke(cr)
    cairo_set_line_width(cr,ring_width+6)
    cairo_set_source_rgba(cr,cw.r,cw.g,cw.b,0.1)
    cairo_arc(cr,x,y,radius,ring_start-0.12,ring_end+0.12)
    cairo_stroke(cr)
    -- Black fill
    cairo_set_line_width(cr,ring_width-4)
    cairo_set_source_rgb(cr,ck.r,ck.g,ck.b)
    cairo_arc(cr,x,y,radius,ring_start,ring_end)
    cairo_stroke(cr)
    -- Blue meter
    meter_end=ring_start + (ring_end-ring_start)*fill
    cairo_set_line_width(cr,ring_width-6)
    cairo_set_source_rgb(cr,cb.r,cb.g,cb.b)
    cairo_arc(cr,x,y,radius,ring_start,meter_end)
    cairo_stroke(cr)
end

function draw_flat_gauge( cr, x, y, fill, width)
    height=8
    line_start=x-0.5*width
    line_end=x+0.5*width
    -- Background
    draw_line(cr,line_start-2,line_end+2,y,y,height,cw,0.4)
    -- Blur
    draw_line(cr,line_start-4,line_end+4,y,y,height+2,cw,0.2)
    draw_line(cr,line_start-8,line_end+8,y,y,height+4,cw,0.1)
    -- Black fill
    draw_line(cr,line_start,line_end,y,y,height-4,ck,1.0)
    -- Blue meter
    meter_end = line_start + fill*(line_end-line_start)
    draw_line(cr,line_start,meter_end,y,y,height-6,cb,1.0)
end

-- Colours

function set_white(cr)
    cairo_set_source_rgb(cr,cw.r,cw.g,cw.b)
end
function set_grey(cr)
    cairo_set_source_rgb(cr,cg.r,cg.g,cg.b)
end
function set_blue(cr)
    cairo_set_source_rgb(cr,cb.r,cb.g,cb.b)
end
function set_black(cr)
    cairo_set_source_rgb(cr,ck.r,ck.g,ck.b)
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

    -- Begin drawing in bottom-right corner
    x,y=500,500
    -- Save starting point. We'll begin going left, then going up
    x_start,y_start=x,y

    -- Decorative hex
    draw_hex(cr,x,y,hex_length,hex_width)

    -- CPU hex
    x,y=hex_move(x,y,hex_length,"top left")
    draw_hex(cr,x,y,hex_length,hex_width)
    cpu=tonumber(conky_parse('${cpu}'))
    cpu_max=100
    set_white(cr)
    write_text_centered(cr,x,y-5,"CPU",extents)
    set_grey(cr)
    write_text_centered(cr,x,y+5,tostring(cpu).."%",extents)
    draw_circle_gauge(cr,x,y,cpu/cpu_max,gauge_radius)

    -- RAM hex
    x,y=hex_move(x,y,hex_length,"bottom left")
    draw_hex(cr,x,y,hex_length,hex_width)
    mem=conky_parse('${mem}')
    mem_max=conky_parse('${memmax}')
    mem_perc=tonumber(conky_parse('${memperc}'))
    set_white(cr)
    write_text_centered(cr,x,y-10,"RAM",extents)
    set_grey(cr)
    write_text_centered(cr,x,y,mem.."/"..mem_max,extents)
    write_text_centered(cr,x,y+10,tostring(mem_perc).."%",extents)
    draw_circle_gauge(cr,x,y,mem_perc/100,gauge_radius)

    -- Swap hex
    x,y=hex_move(x,y,hex_length,"top left")
    draw_hex(cr,x,y,hex_length,hex_width)
    swap=conky_parse('${swap}')
    swap_max=conky_parse('${swapmax}')
    swap_perc=tonumber(conky_parse('${swapperc}'))
    set_white(cr)
    write_text_centered(cr,x,y-10,"SWAP",extents)
    set_grey(cr)
    write_text_centered(cr,x,y,swap.."/"..swap_max,extents)
    write_text_centered(cr,x,y+10,tostring(swap_perc).."%",extents)
    draw_circle_gauge(cr,x,y,swap_perc/100,gauge_radius)

    -- File system hex
    x,y=hex_move(x,y,hex_length,"bottom left")
    draw_hex(cr,x,y,hex_length,hex_width)
    fs=conky_parse('${fs_used}')
    fs_max=conky_parse('${fs_size}')
    fs_perc=tonumber(conky_parse('${fs_used_perc}'))
    set_white(cr)
    write_text_centered(cr,x,y-10,"/",extents)
    set_grey(cr)
    write_text_centered(cr,x,y,fs.."/"..fs_max,extents)
    write_text_centered(cr,x,y+10,tostring(fs_perc).."%",extents)
    draw_circle_gauge(cr,x,y,fs_perc/100,gauge_radius)

    -- back to start...
    x,y=x_start,y_start

    -- Network hex
    x,y=hex_move(x,y,hex_length,"top")
    draw_hex(cr,x,y,hex_length,hex_width)
    set_white(cr)
    write_text_centered(cr,x,y-25,"NETWORK",extents)
    write_text_centered(cr,x,y-10,"UPSPEED",extents)
    set_grey(cr)
    write_text_centered(cr,x,y,conky_parse('${upspeed '..wlan..'}'),extents)
    set_white(cr)
    write_text_centered(cr,x,y+10,"DOWNSPEED",extents)
    set_grey(cr)
    write_text_centered(cr,x,y+20,conky_parse('${downspeed '..wlan..'}'),extents)

    -- Processes hex
    x,y=hex_move(x,y,hex_length,"top left")
    draw_hex(cr,x,y,hex_length,hex_width)
    set_white(cr)
    write_text_centered(cr,x,y-15,"PROCESSES",extents)
    set_grey(cr)
    write_text_centered(cr,x,y-5,conky_parse('${processes}'),extents)
    set_white(cr)
    write_text_centered(cr,x,y+5,"RUNNING",extents)
    set_grey(cr)
    write_text_centered(cr,x,y+15,conky_parse('${running_processes}'),extents)

    -- Home dir
    x,y=hex_move(x,y,hex_length,"top right")
    draw_hex(cr,x,y,hex_length,hex_width)
    if tonumber(conky_parse('${if_mounted /home}1${endif}')) then
        fs=conky_parse('${fs_used /home}')
        fs_max=conky_parse('${fs_size /home}')
        fs_perc=tonumber(conky_parse('${fs_used_perc /home}'))
        set_white(cr)
        write_text_centered(cr,x,y-10,"/home",extents)
        set_grey(cr)
        write_text_centered(cr,x,y,fs.."/"..fs_max,extents)
        write_text_centered(cr,x,y+10,tostring(fs_perc).."%",extents)
        draw_circle_gauge(cr,x,y,fs_perc/100,gauge_radius)
    end

    -- Decorative hex
    x,y=hex_move(x,y,hex_length,"top")
    draw_hex(cr,x,y,hex_length,hex_width)

    -- clean up cairo
    cairo_destroy(cr)
    cairo_surface_destroy(cs)
    cr=nil
end
