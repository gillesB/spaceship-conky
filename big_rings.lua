--[[
Clock Rings by londonali1010 (2009) , mod by arpinux

This script draws percentage meters as rings, and also draws clock hands if you want! It is fully customisable; all options are described in the script. This script is based off a combination of my clock.lua script and my rings.lua script.

IMPORTANT: if you are using the 'cpu' function, it will cause a segmentation fault if it tries to draw a ring straight away. The if statement on line 145 uses a delay to make sure that this doesn't happen. It calculates the length of the delay by the number of updates since Conky started. Generally, a value of 5s is long enough, so if you update Conky every 1s, use update_num>5 in that if statement (the default). If you only update Conky every 2s, you should change it to update_num>3; conversely if you update Conky every 0.5s, you should use update_num>10. ALSO, if you change your Conky, is it best to use "killall conky; conky" to update it, otherwise the update_num will not be reset and you will get an error.

To call this script in Conky, use the following (assuming that you save this script to ~/scripts/rings.lua):
   lua_load ~/scripts/clock_rings.lua
   lua_draw_hook_pre clock_rings
   
Changelog:
+ v1.0 -- Original release (30.09.2009)
]]

-- Global Variables

settings_table = {
   {
			name='time',
			arg='%M.%S',
			max=60,
			bg_colour=0xffffff,
			bg_alpha=0.1,
			fg_colour=0x3399cc,
			fg_alpha=0.4,
			x=400, y=400,
			radius=56,
			thickness=5,
			start_angle=0,
			end_angle=360,
			positive_direction = true
	   },
	   {
			name='time',
			arg='%S',
			max=60,
			bg_colour=0xffffff,
			bg_alpha=0.1,
			fg_colour=0x3399cc,
			fg_alpha=0.6,
			x=400, y=400,
			radius=62,
			thickness=5,
			start_angle=0,
			end_angle=360,
			positive_direction = false
	   },
	   {
			name='time',
			arg='%d',
			max=31,
			bg_colour=0xffffff,
			bg_alpha=0.1,
			fg_colour=0x3399cc,
			fg_alpha=0.8,
			x=400, y=400,
			radius=70,
			thickness=5,
			start_angle=-90,
			end_angle=90,
			positive_direction = true
   },
	   {
			name='time',
			arg='%m',
			max=12,
			bg_colour=0xffffff,
			bg_alpha=0.1,
			fg_colour=0x3399cc,
			fg_alpha=1,
			x=400, y=400,
			radius=76,
			thickness=5,
			start_angle=-90,
			end_angle=90,
			positive_direction = true
	   },
   {
			name='cpu',
			arg='cpu0',
			max=100,
			bg_colour=0xffffff,
			bg_alpha=0.2,
			fg_colour=0xffff00,
			fg_alpha=0.4,
			x=350, y=400,
			radius=200,
			thickness=50,
			start_angle=220,
			end_angle=320,
			positive_direction = true
   },
   {
			name='memperc',
			arg='',
			max=100,
			bg_colour=0xffffff,
			bg_alpha=0.2,
			fg_colour=0x33ccff,
			fg_alpha=0.8,
			x=450, y=400,
			radius=200,
			thickness=50,
			start_angle=40,
			end_angle=140,
			positive_direction = false
   },
   {
			name='swapperc',
			arg='',
			max=100,
			bg_colour=0xffffff,
			bg_alpha=0.2,
			fg_colour=0x33ccff,
			fg_alpha=0.8,
			x=400, y=305,
			radius=200,
			thickness=20,
			start_angle=-40,
			end_angle=40,
			positive_direction = true
   },
   {
			name='fs_used_perc',
			arg='/',
			max=100,
			bg_colour=0xffffff,
			bg_alpha=0.2,
			fg_colour=0x3399cc,
			fg_alpha=0.3,
			x=400, y=350,
			radius=200,
			thickness=30,
			start_angle=-40,
			end_angle=40,
			positive_direction = true
   },
   {
			name='upspeedf',
			arg='eth2',
			max=100,
			bg_colour=0xffffff,
			bg_alpha=0.2,
			fg_colour=0xffff33,
			fg_alpha=0.3,
			x=400, y=440,
			radius=200,
			thickness=20,
			start_angle=140,
			end_angle=220,
			positive_direction = false
   },
   {
			name='downspeedf',
			arg='eth2',
			max=1000,
			bg_colour=0xffffff,
			bg_alpha=0.2,
			fg_colour=0xccff33,
			fg_alpha=0.3,
			x=400, y=470,
			radius=210,
			thickness=20,
			start_angle=140,
			end_angle=220,
			positive_direction = true

   },
   {
			name='fs_used_perc',
			arg='/media/datasba7/',
			max=100,
			bg_colour=0xffffff,
			bg_alpha=0.2,
			fg_colour=0x3399cc,
			fg_alpha=0.8,
			x=380, y=400,
			radius=300,
			thickness=50,
			start_angle=220,
			end_angle=320,
			positive_direction = true
   },
   {
			name='acpitemp',
			arg='',
			max=107,
			bg_colour=0xffffff,
			bg_alpha=0.2,
			fg_colour=0xff4444,
			fg_alpha=0.8,
			x=420, y=400,
			radius=300,
			thickness=50,
			start_angle=40,
			end_angle=140,
			positive_direction = false
   },
}

old_track_elapsed_time = ""

corner_r = 35
--bg_colour=0x000000
bg_colour = 0x210A01
bg_alpha = 0.65

require 'cairo'

function rgb_to_r_g_b(colour,alpha)
	return ((colour / 0x10000) % 0x100) / 255., ((colour / 0x100) % 0x100) / 255., (colour % 0x100) / 255., alpha
end

function conky_cairo_iteration()

	if conky_window==nil then return end
	
	local cs=cairo_xlib_surface_create(conky_window.display, conky_window.drawable, conky_window.visual, conky_window.width, conky_window.height)   
	local cr=cairo_create(cs)

	conky_draw_bg(cr)
	conky_clock_rings(cr)
	
	
	cairo_surface_destroy(cs)
	cairo_destroy(cr)


end

function draw_ring(cr, percent, setting)
	local w,h=conky_window.width,conky_window.height
   
	local xc,yc,ring_r,ring_w,sa,ea=setting['x'],setting['y'],setting['radius'],setting['thickness'],setting['start_angle'],setting['end_angle']
	local bgc, bga, fgc, fga=setting['bg_colour'], setting['bg_alpha'], setting['fg_colour'], setting['fg_alpha']
	local positive_direction = setting['positive_direction']

	local angle_0=sa*(2*math.pi/360)-math.pi/2
	local angle_f=ea*(2*math.pi/360)-math.pi/2
	local t_arc=percent*(angle_f-angle_0)

	-- Draw background ring

	cairo_arc(cr,xc,yc,ring_r,angle_0,angle_f)
	cairo_set_source_rgba(cr,rgb_to_r_g_b(bgc,bga))
	cairo_set_line_width(cr,ring_w)
	cairo_stroke(cr)
   
	-- Draw indicator ring
	if positive_direction then
		cairo_arc(cr,xc,yc,ring_r,angle_0,angle_0+t_arc)
	else
		cairo_arc_negative(cr,xc,yc,ring_r,angle_f,angle_f-t_arc)
	end
	cairo_set_source_rgba(cr,rgb_to_r_g_b(fgc,fga))
	cairo_stroke(cr)	   
end

function conky_clock_rings(cr)
	local function setup_rings(cr, pt)
		local str=''
		local value=0
	   
		str=string.format('${%s %s}',pt['name'],pt['arg'])
		str=conky_parse(str)
		
		value=tonumber(str)
		if value == nil then value = 0 end	 
		local pct=value/pt['max']
	   
		draw_ring(cr, pct, pt)
	end

	if conky_window==nil then return end

	-- Check that Conky has been running for at least 5s
	local updates=conky_parse('${updates}')
	local update_num=tonumber(updates)
   
	if update_num>5 then
		for i in pairs(settings_table) do
			setup_rings(cr, settings_table[i])
		end
	end

end

-- Change these settings to affect your background.
-- "corner_r" is the radius, in pixels, of the rounded corners. If you don't want rounded corners, use 0.

function conky_draw_bg(cr)
	if conky_window==nil then return end
	local w=conky_window.width
	local h=conky_window.height

	cairo_move_to(cr,corner_r,0)
	cairo_line_to(cr,w-corner_r,0)
	cairo_curve_to(cr,w,0,w,0,w,corner_r)
	cairo_line_to(cr,w,h-corner_r)
	cairo_curve_to(cr,w,h,w,h,w-corner_r,h)
	cairo_line_to(cr,corner_r,h)
	cairo_curve_to(cr,0,h,0,h,0,h-corner_r)
	cairo_line_to(cr,0,corner_r)
	cairo_curve_to(cr,0,0,0,0,corner_r,0)
	cairo_close_path(cr)
   
	cairo_set_source_rgba(cr,rgb_to_r_g_b(bg_colour,bg_alpha))
	cairo_fill(cr)
end

function exec_shell(command)
	local handle = io.popen(command)
	local result = handle:read("*a")
	handle:close()
	return result
end

function does_process_exists(name)
	local pid = exec_shell("pidof ".. name)
	pid = tonumber(pid)
	if pid == nil then
		 return false
	else
		 return true
	end
end


--workaround as rhythmbox-client does not provide this information
function rhythmbox_plays_pauses_stopped()
	local current_track_elapsed_time = exec_shell("rhythmbox-client --print-playing-format %te")
	local state = 0
	if current_track_elapsed_time == "Unknown" then
		state = 2 --it stopped
	elseif current_track_elapsed_time == old_track_elapsed_time then
		state = 1 --it pauses
	end
	old_track_elapsed_time = current_track_elapsed_time
	return state
end

function conky_get_information_from_rhythmbox()
	if does_process_exists("rhythmbox") then
		local rhythmbox_state = rhythmbox_plays_pauses_stopped()
		if rhythmbox_state == 0 then --it plays
			local result = exec_shell("rhythmbox-client --print-playing-format \"%tt-\n%aa\"")
			result = string.sub(result, 1, -2)
			return result
		elseif rhythmbox_state == 1 then --it pauses
			return "Paused\n"
		end --it has stopped
	end
	return "Not Playing\n"
end   

























