ret,result = showUI("ui_home.json")
if ret == 0 then
	return;
end

ver = getOSType()
pdev = 1 --代理定制模式0， 个人发布1

gameMode = tonumber(result["RadioGroup1"])
if gameMode == 0 then
init("0", 1); --以当前应用 Home 键在右边初始化
elseif gameMode == 1 then
init("0", 2);
end
jd_height,jd_width = getScreenSize()
 jd_idzhunxing = createHUD()     --创建一个HUD
 showHUD(jd_idzhunxing,"",12,"0xffff0000","green.png",0,jd_width/2 - 40,jd_height/2 - 40,80,80)

jd_dx,jd_dy = -1,-1;
jd_id = createHUD()     --创建一个HUD
showHUD(jd_id,"雷达已启动！",12,"0xffff0000","msgbox_click.png",0,100,0,178,32)      --显示HUD内容
jd_fcolor = "0|0|0xb05421"
jd_ww = 48
jd_wh = 48
jd_kw = 80
jd_kh = 160
jd_ks = jd_kw / 2
jd_rx = 980
jd_ry = 0
jd_rw = 1136
jd_rh = 143
jd__x = 1058
jd__y = 75
jd_r = 13
jd_ang = 90
jd_hang = jd_ang/2
if jd_width == 1334 then
	jd__x = 1240
	jd__y = 93
	jd_r = 16
end

if jd_width == 2436 then
	jd__x = 1856
	jd__y = 191
	jd_r = 37
end

if jd_width == 2048 then
	jd__x = 1055
	jd__y = 80
	jd_r = 23
end

if jd_width == 1024 then
	jd__x = 927
	jd__y = 95
	jd_r = 17
end

if jd_width == 1440 then
	jd__x = 1350
	jd__y = 89
	jd_r = 16
end

if jd_width == 1920 then
	jd__x = 1785
	jd__y = 134
	jd_r = 23
end

if jd_width == 2160 then
	jd__x = 2025
	jd__y = 134
	jd_r = 23
end

if jd_width == 2208 then
	jd__x = 2052	
	jd__y = 154
	jd_r = 27
end

if jd_width == 2220 then
	jd__x = 2084
	jd__y = 134
	jd_r = 25
end

if jd_width == 1280 then
	jd__x = 1189
	jd__y = 89
	jd_r = 16
end

jd_arrx = {-1000}
jd_arry = {-1000}
for i=0,360,1 do
	x = math.cos(math.pi / 180 * i) * jd_r + jd__x;
	y = math.sin(math.pi / 180 * i) * jd_r + jd__y;
	table.insert(jd_arrx,1,x)
	table.insert(jd_arry,1,y)
end

--距离
function distanceBetween(x1, x2, y1, y2)
	sysLog(x1.." "..x2.." "..y1.." "..y2)
	return  math.sqrt(math.abs(x1 - x2) * math.abs(x1 - x2) + math.abs(y1 - y2) * math.abs(y1 - y2))
end

--角度
function angleBetween(x1, x2, y1, y2)
	sysLog(math.asin(math.abs(x1 - x2) / math.abs(y1 - y2))) 
	return math.asin(math.abs(x1 - x2) / math.abs(y1 - y2)) * 180 / math.pi
end

function getAngleByPos(x1, y1, x2, y2)
      
    x = x2 - x1  
    y = y2 - y1  
             
    local r = math.atan2(y,x)*180/math.pi  
    
    return r  
end  

function getAngle(px,py,mx,my) --获得人物中心和鼠标坐标连线，与y轴正半轴之间的夹角
        x = math.abs(px-mx);
        y = math.abs(py-my);
        z = math.sqrt((x*x)+(y*y));
        cos = y/z;
        radina = math.acos(cos);--用反三角函数求弧度
        angle = math.floor(180/(math.pi/radina));--将弧度转换成角度

        if mx>px and my>py then--鼠标在第四象限
		
            angle = 180 - angle;
        end

        if mx==px and my>py then--鼠标在y轴负方向上
            angle = 180;
        end

        if mx>px and my==py then--鼠标在x轴正方向上
            angle = 90;
        end

        if mx<px and my>py then--鼠标在第三象限
            angle = 180+angle;
        end

        if mx<px and my==py then--鼠标在x轴负方向
            angle = 270;
        end

        if mx<px and my<py then--鼠标在第二象限
            angle = 360 - angle;
        end
        return angle;
 end

local jd_oldx = -1 
local jd_oldy = -1
function getPosition()

	keepScreen(true);

	local nindex = 0
	for key, var in ipairs(jd_arrx) do
		x = tonumber(jd_arrx[key])
		y = tonumber(jd_arry[key])
		if x ~= -1000 then
			r,g,b = getColorRGB(x,y)
--			if r > 200 then
--				sysLog(r..","..g..","..b)
--				showHUD(jd_id,"雷达已启动！",12,"0xffff0000","0xffff0000",0,x,y,10,10)
--			end
			if r>=200 and g >= 200 and b >= 200 then
				if nindex == 0 then
					nindex = nindex + 1
					showHUD(jd_id,"x:"..x..",y:"..y,12,"0xffff0000","msgbox_click.png",0,100,0,528,32)
					local xx = x
					local yy = y
					lang = getAngle(jd__x, jd__y, xx, yy)
					dang = getAngle(jd__x, jd__y, jd_dx, jd_dy)
					
					if lang > 0 and lang <= 90 and dang > 270 and dang <=360 then
						if (math.abs(360 - dang) + lang) > jd_hang then
							showHUD(jd_id1,"",15,"0xffff0000","left.png",0,  0,jd_height/2 - jd_ww/2, jd_ww, jd_wh) 
							
						else
							showHUD(jd_id2,"",15,"0xffff0000","62.png",0, (jd_width/2) *(1 - (math.abs(360 - dang) + lang)/30) - jd_ks,jd_height/3,jd_kw,jd_kh) 
						end
					elseif dang > 0 and dang <=90 and lang > 270 and lang <=360 then
						if (math.abs(360 - lang) + dang) > jd_hang then
							showHUD(jd_id3,"",15,"0xffff0000","right.png",0,  jd_width - jd_ww,jd_height/2 - jd_ww/2, jd_ww, jd_wh) 
						else
							showHUD(jd_id2,"",15,"0xffff0000","62.png",0,(jd_width/2) *( 1 + (math.abs(360 - lang) + dang)/30) - jd_ks,jd_height/3,jd_kw,jd_kh) 
						end
					else
						if lang > dang then
							if math.abs(lang-dang) > jd_hang then
								showHUD(jd_id1,"",15,"0xffff0000","left.png",0,  0,jd_height/3 , jd_ww, jd_wh) 
							else
								showHUD(jd_id2,"",15,"0xffff0000","62.png",0, (jd_width/2) *(1 - math.abs(lang-dang)/30) - jd_ks,jd_height/3,jd_kw,jd_kh) 
							end
							
						elseif lang == dang then
							showHUD(jd_id2,"",15,"0xffff0000","62.png",0,(jd_width/2)  - jd_ks,jd_height/3,jd_kw,jd_kh) 
						elseif lang < dang then
							if math.abs(lang-dang) > jd_hang then
								showHUD(jd_id3,"",15,"0xffff0000","right.png",0,  jd_width - jd_ww,jd_height/3 , jd_ww, jd_wh) 
							else
								showHUD(jd_id2,"",15,"0xffff0000","62.png",0,(jd_width/2) *( 1 + math.abs(lang-dang)/30) - jd_ks,jd_height/3,80,160) 
							end
						end
					end
				end
			end
		end

	end
	keepScreen(false);
end
--/************************************/
local bb = require("badboy")


rheight,rwidth = getScreenSize()
local rws = 720/rheight
local rhs = 1280/rwidth
local gameID = 1 -- 0 荒野 1 终结者 2小米

local scale = 100
local rx = 400
local ry = 66
local rb = 195
local times = 20
local st = 13.6
local kgzm = false
local kglj = false
local nt = 40
local yqms = 120
local zhenshiY = 300
local gameMode = 0
width = 1280
height = 720
if pdev == 0 then
	if ver == "android" then
		ret,result = showUI("mainui-zbdz.json")
		if ret == 0 then
			return;
		end
		gameMode = tonumber(result["RadioGroup1"]) + 1
	else 
		ret,result = showUI("mainuios-zbdz.json")
		if ret == 0 then
			return;
		end
		gameMode = tonumber(result["RadioGroup1"]) + 1
	end
else
	if ver == "android" then
		ret,result = showUI("mainui.json")
		if ret == 0 then
			return;
		end
		gameMode = tonumber(result["RadioGroup1"])
	else
		ret,result = showUI("mainuios.json")
		if ret == 0 then
			return;
		end
		gameMode = tonumber(result["RadioGroup1"])
	end
end
function clickzm(x,y)
	if x >= height/2-105 and x <= height/2 - 5 and y >=width - 50 and y <= width then
		if kgzm then
			kgzm = false
			showHUD(idszm,"开启点击瞄准",20,"0xffffffff","0xf0808000",0,height/2 - 105,width - 50,100,50)
			hideHUD(id)
			hideHUD(id3)
			hideHUD(id4) 
		else
			kgzm = true
			id = createHUD()     --创建一个HUD
			id3 = createHUD()   
			id4 = createHUD() 
			showHUD(idszm,"关闭点击瞄准",20,"0xffffffff","0xf0808000",0,height/2 - 105,width - 50,100,50)
			showHUD(id3,"",12,"0xffff0000","0x69696900",0,0,width/2-1,height,2)
			showHUD(id4,"",12,"0xffff0000","0x69696900",0,height/2-1,0,2,width)
			showHUD(id,"",12,"0xffff0000","Rectangel.png",0,rx,ry,480,459)      --显示HUD内容
		end
	end
end
function reDdJg()
	if rwidth == 1280 and rheight == 720 then --红米
			yqms =  50
			nt = 10
	elseif rwidth == 1334 and rheight == 750 then --p 678
			yqms =  40
			nt = 11
	elseif rwidth == 1024 and rheight == 768 then --pad1
			yqms =  30
			nt = 10
	elseif rwidth == 1920 and rheight == 1080 then --华为普遍
			yqms =  20
			nt = 40
	elseif rwidth == 2208 and rheight == 1242 then -- 678p
			yqms =  20
			nt = 40
	elseif rwidth == 2048 and rheight == 1536 then -- ipad air mini
			yqms =  50
			nt = 60
	end
end
function clidklj(x,y)
	if x >= height/2+5 and x <= height/2 + 105 and y >=width - 50 and y <= width then
		if kglj then
			 kglj = false
			 showHUD(idslj,"开启无后坐连射",20,"0xffffffff","0xf0808000",0,height/2 + 5,width - 50,100,50)
		else
			ret,result = showUI("whzui.json")
			if ret == 0 then
				return;
			end
			rIndex = tonumber(result["RadioGroup1"])
--=====================测试弹道UI
--			ret,result = showUI("uidebug.json")
--			if ret == 0 then
--				return;
--			end
--			yqms = tonumber(result["Edit1"])
--			nt = tonumber(result["Edit3"])
--			if  yqms == nil or nt == nil then  
--				return;
--			end
					
--=====================结尾			

			if rIndex == 0 then
				reDdJg()
			elseif rIndex == 1 then
			  yqms = 50
				nt = 10
			end
			kglj = true
			showHUD(idslj,"关闭无后坐连射",20,"0xffffffff","0xf0808000",0,height/2 + 5,width - 50,100,50)
		end
	end
end


function swip(x1,y1,x2,y2)
x1=x1+100
x2=x2+100
    local step, x, y, index = 10, x1 , y1, 5
    touchDown(index, x, y)
		
		mSleep(times)
    local function move(from, to) 
      if from > to then
        do 
          return -1 * step 
        end
      else 
        return step 
      end 
    end

    while (math.abs(x-x2) >= step) or (math.abs(y-y2) >= step) do
				if math.abs(x-x2) >= step then x = x + move(x1,x2) end
        if math.abs(y-y2) >= step then y = y + move(y1,y2) end
				
        touchMove(index, x, y)
				mSleep(times)
    end
    touchMove(index, x2, y2)
		mSleep(times)
    touchUp(index, x2, y2)
end


function swipyqphone(x1,y1,x2,y2)
    local step, x, y, index = 3, x1 , y1, 5
    touchDown(index, x, y)
    local function move(from, to) 
      if from > to then
        do 
          return -1 * step 
        end
      else 
        return step 
      end 
    end

    while  (math.abs(y-y2) >= step) do
        if math.abs(y-y2) >= step then y = y + move(y1,y2) end
        touchMove(index, x, y)
		mSleep(nt)
    end

    touchMove(index, x2, y2)
	mSleep(100)
    touchUp(index, x2, y2)

end

function swipyq(x1,y1,x2,y2)
    local step, x, y, index = 1.1, x1 , y1, 5
    touchDown(index, x, y)
    local function move(from, to) 
      if from > to then
        do 
          return -1 * step 
        end
      else 
        return step 
      end 
    end

--    while  (math.abs(y-y2) >= step) do
--        if math.abs(y-y2) >= step then y = y + move(y1,y2) end
--        touchMove(index, x, y)
--				mSleep(20)
--    end

--    touchMove(index, x2, y2)
	mSleep(500)
    touchUp(index, x2, y2)

end

function yq()
	mSleep(260)
	touchDown(4, 100, 383)
--	swipyq( height/2 + 200, width /2 -100, height/2 + 200, width /2 -100 + yqms )
	swipyqphone( height/2 + 200, width /2 -100, height/2 + 200, width /2 -100 + yqms )
	touchUp(4, 100, 383)
end

function inShoot1(x, y)
	if gameID == 0 then
		if x >=25 and x <= 101 and y >= 355 and y <= 417 then
			return true
		end
	elseif gameID == 1 then
		if x >=63 and x <= 136 and y >= 318 and y <= 384 then
			return true
		end
	end
		
	return false
end

function inShoot2(x, y)
	if gameID == 0 then
		if x >=1036 and x <= 1110 and y >= 518 and y <= 585 then
			return true
		end
	elseif gameID == 1 then
		if x >=1037 and x <= 1110 and y >= 517 and y <= 588 then
			return true
		end
	end
	return false
end

local nCountShowTime = 0;
function getPositionPower() -- 增强版
		jd_id1 = createHUD() 
		jd_id2 = createHUD()     --创建一个HUD
		jd_id3 = createHUD() 
	local nindex = 0
	
	
	local lang = 0
	local dang = 0
	
	keepScreen(true);
	for key, var in ipairs(jd_arrx) do

		x = tonumber(jd_arrx[key])
		y = tonumber(jd_arry[key])
		if x ~= -1000 then
			r,g,b = getColorRGB(x,y)
--			if r > 200 then
--				sysLog(r..","..g..","..b)
--				showHUD(jd_id,"雷达已启动！",12,"0xffff0000","0xffff0000",0,x,y,10,10)
--			end
			if r>=240 and g >= 240 and b >= 240 then
				if nindex == 0 then
					nindex = nindex + 1
					showHUD(jd_id,"x:"..x..",y:"..y,12,"0xffff0000","msgbox_click.png",0,100,0,528,32)
					local xx = x
					local yy = y
					lang = getAngle(jd__x, jd__y, xx, yy)
					dang = getAngle(jd__x, jd__y, jd_dx, jd_dy)
				end
			end
		end
	end
	keepScreen(false);
			
	local dx, dy = -1, -1
	if jd_width == 1280 then --红米4a
		dx, dy = findColorInRegionFuzzy(0xb76b31, 92, 1100, 0, 1277, 178, 0, 0)
	elseif jd_width == 1024 then  -- ipad
		dx, dy = findColorInRegionFuzzy(0xb76b31, 92, 832, 0, 1022, 191, 0, 0)
	elseif jd_width == 1136 then	--iphonese
		dx, dy = findColorInRegionFuzzy(0xb76b31, 92, 973, 0, 1134, 159, 0, 0)
	elseif jd_width == 1334 then    --iphone6s
		dx, dy = findColorInRegionFuzzy(0xb76b31, 92, 1146, 0, 1332, 186, 0, 0)
	elseif jd_width == 1440 then    --1440*720
		dx, dy = findColorInRegionFuzzy(0xb76b31, 92, 1259, 1, 1437, 179, 0, 0)
	elseif jd_width == 1920 then	--android
		dx, dy = findColorInRegionFuzzy(0xb76b31, 92, 1651, 1, 1916, 271, 0, 0)
	elseif jd_width == 2160 then -- mix2
		dx, dy = findColorInRegionFuzzy(0xb76b31, 92, 1890, 0, 2157, 266, 0, 0)
	elseif jd_width == 2208 then
		dx, dy = findColorInRegionFuzzy(0xb76b31, 92, 1897, 0, 2204, 307, 0, 0)
	elseif jd_width == 2220 then  -- s8 *1080
		dx, dy = findColorInRegionFuzzy(0xb76b31, 92, 1947, 0, 2216, 267, 0, 0)
	elseif jd_width == 2436 then	--iphoneX
		dx, dy =  findColorInRegionFuzzy(0xb76b31, 92, 2155, 2, 2433, 278, 0, 0)
	elseif jd_width == 2048 then -- mini4
		dx, dy = findColorInRegionFuzzy(0xb76b31, 92, 1664, 1, 2044, 381, 0, 0)	
	end
	

	sysLog(dx)
	if dx > -1 then
		jd_dx = dx
		jd_dy = dy
	else
		nCountShowTime = nCountShowTime + 1
		if nCountShowTime == 20 then
			nCountShowTime = 0
			jd_dx = -1
			jd_dy = -1
		end
	end
	if jd_dx > -1 then
		if lang > 0 and lang <= 90 and dang > 270 and dang <=360 then
			if (math.abs(360 - dang) + lang) > 30  then
				showHUD(jd_id1,"",15,"0xffff0000","left.png",0,  0,jd_height/2 - jd_ww/2, jd_ww, jd_wh) 
				
			else
				showHUD(jd_id2,"",15,"0xffff0000","62.png",0, (jd_width/2) *(1 - (math.abs(360 - dang) + lang)/30) - jd_ks,jd_height/3,jd_kw,jd_kh) 
			end
		elseif dang > 0 and dang <=90 and lang > 270 and lang <=360 then
			if (math.abs(360 - lang) + dang) > 30 then
				showHUD(jd_id3,"",15,"0xffff0000","right.png",0,  jd_width - jd_ww,jd_height/2 - jd_ww/2, jd_ww, jd_wh) 
			else
				showHUD(jd_id2,"",15,"0xffff0000","62.png",0,(jd_width/2) *( 1 + (math.abs(360 - lang) + dang)/30) - jd_ks,jd_height/3,jd_kw,jd_kh) 
			end
		else
			if lang > dang then
				if math.abs(lang-dang) > 30 then
					showHUD(jd_id1,"",15,"0xffff0000","left.png",0,  0,jd_height/3 , jd_ww, jd_wh) 
				else
					showHUD(jd_id2,"",15,"0xffff0000","62.png",0, (jd_width/2) *(1 - math.abs(lang-dang)/30) - jd_ks,jd_height/3,jd_kw,jd_kh) 
				end
				
			elseif lang == dang then
				showHUD(jd_id2,"",15,"0xffff0000","62.png",0,(jd_width/2)  - jd_ks,jd_height/3,jd_kw,jd_kh) 
			elseif lang < dang then
				if math.abs(lang-dang) > 30 then
					showHUD(jd_id3,"",15,"0xffff0000","right.png",0,  jd_width - jd_ww,jd_height/3 , jd_ww, jd_wh) 
				else
					showHUD(jd_id2,"",15,"0xffff0000","62.png",0,(jd_width/2) *( 1 + math.abs(lang-dang)/30) - jd_ks,jd_height/3,80,160) 
				end
			end
		end
	end
	mSleep(200)
	hideHUD(jd_id1)
	hideHUD(jd_id2)
	hideHUD(jd_id3)
end




function cary()
	x,y = catchTouchPoint()
	
	x = x*rws
	y = y*rhs
	x1 = height/2
	y1 = width/2
	x2 = y
	y2 = width - x
	--=================校验开关=====================
	clickzm(x2, y2)
	clidklj(x2, y2)
	--=================无后座=======================
	if kglj then
		if inShoot1(x2,y2) or inShoot2(x2,y2) then
			yq()
		end
	end
	--=================点击瞄准=====================
	scalex = 85 + ((1 - math.abs(x2-x1) / (height/2))*st)
	scaley = 85 + ((1 - math.abs(y2-y1) / (width/2))*st)
	scalecx = 100 -scalex
	scalecy = 100 -scaley
	if kgzm then
		if x2 > rx and x2 < (height-rx) and y2 > ry and y2 < (width - rb) then
			mSleep(200)
			if x2 >= x1 and y2 <= y1 then --1向量 
				swip(x1, y1, x2 * scalex / 100, y2 * (100 + scalecy) / 100)
			elseif x2 <= x1 and y2 <= y1 then --2向量
				swip(x1, y1, x2*(100 + scalecx) /100, y2 * (100 + scalecy) / 100)
			elseif x2 <= x1 and y2 >= y1 then --3向量
				swip(x1, y1, x2*(100 + scalecx) /100, y2 * scaley / 100)
			elseif x2 >= x1 and y2 >= y1 then--4向量
				swip(x1, y1, x2 * scalex / 100, y2 * scaley / 100)
			end
			--放枪暂时注释
			touchDown(3, 60, 400)
			mSleep(50)
			touchUp(3, 60, 400)  
		end
	end
end

if gameMode == 2 then
	hideHUD(jd_id)     --隐藏HUD
	ret,result = showUI("ui.json")
	if ret == 0 then
		return;
	end
	times = tonumber(result["Edit2"])
	if  times == nil then  
		return;
	end
	width = 720
	height = 1280
	setScreenScale(720,1280)
	id = createHUD()     --创建一个HUD
	id3 = createHUD()   
	id4 = createHUD() 
	idszm = createHUD()  
	showHUD(idszm,"开启点击瞄准",20,"0xffffffff","0xf0808000",0,height/2 - 105,width - 50,100,50)
	idslj = createHUD() 
	showHUD(idslj,"开启无后坐连射",20,"0xffffffff","0xf0808000",0,height/2 + 5,width - 50,100,50)
	while true do
		cary()
	end
else
	while true do
		if gameMode == 0 then -- 增强模式
			getPositionPower()
		else
			if (ver == "android" and gameMode == 5) or (ver ~= "android" and gameMode == 4) then
								hideHUD(jd_id)
				while true do

					mSleep(100000)
				end
			end
			if (ver == "android" and gameMode == 4) or (ver ~= "android" and gameMode == 3) then
				x1 = (jd_width/2 + 100)
				y1 = (jd_height/2 + 100)
				x2 = (jd_width - jd_width/4)
				y2 = (jd_height - height/4) 

				sysLog( x1..","..y1..","..x2..","..y2)
				x, y = findColorInRegionFuzzy(0xbababc, 99, x1, y1, x2, y2, 0, 0)
				sysLog(x)
			
				if x > -1 then
					touchDown(5, x, y)
					mSleep(50)
					touchUp(5, x, y)  
					mSleep(100)
				end
			end
			local dx, dy = -1, -1

	if jd_width == 1280 then --红米4a
		dx, dy = findColorInRegionFuzzy(0xb76b31, 92, 1100, 0, 1277, 178, 0, 0)
	elseif jd_width == 1024 then  -- ipad
		dx, dy = findColorInRegionFuzzy(0xb76b31, 92, 832, 0, 1022, 191, 0, 0)
	elseif jd_width == 1136 then	--iphonese
		dx, dy = findColorInRegionFuzzy(0xb76b31, 92, 973, 0, 1134, 159, 0, 0)
	elseif jd_width == 1334 then    --iphone6s
		dx, dy = findColorInRegionFuzzy(0xb76b31, 92, 1146, 0, 1332, 186, 0, 0)
	elseif jd_width == 1440 then    --1440*720
		dx, dy = findColorInRegionFuzzy(0xb76b31, 92, 1259, 1, 1437, 179, 0, 0)
	elseif jd_width == 1920 then	--android
		dx, dy = findColorInRegionFuzzy(0xb76b31, 92, 1651, 1, 1916, 271, 0, 0)
	elseif jd_width == 2160 then -- mix2
		dx, dy = findColorInRegionFuzzy(0xb76b31, 92, 1890, 0, 2157, 266, 0, 0)
	elseif jd_width == 2208 then
		dx, dy = findColorInRegionFuzzy(0xb76b31, 92, 1897, 0, 2204, 307, 0, 0)
	elseif jd_width == 2220 then  -- s8 *1080
		dx, dy = findColorInRegionFuzzy(0xb76b31, 92, 1947, 0, 2216, 267, 0, 0)
	elseif jd_width == 2436 then	--iphoneX
		dx, dy =  findColorInRegionFuzzy(0xb76b31, 92, 2155, 2, 2433, 278, 0, 0)
	elseif jd_width == 2048 then -- mini4
		dx, dy = findColorInRegionFuzzy(0xb76b31, 92, 1664, 1, 2044, 381, 0, 0)	
	end
	sysLog(dx..jd_width)
	if dx > -1 then
		jd_dx = dx
		jd_dy = dy
		jd_id1 = createHUD() 
		jd_id2 = createHUD()     --创建一个HUD
		jd_id3 = createHUD() 
		getPosition()
		mSleep(200)
		hideHUD(jd_id1)
		hideHUD(jd_id2)
		hideHUD(jd_id3)
	end
		
		end
	end
	
	
	

end


hideHUD(jd_id)     --隐藏HUD
--/************************************/













