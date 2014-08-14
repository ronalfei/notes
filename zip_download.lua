function getfileSize(fileName)
	local file,err = io.open(fileName,"r")
	if(file == nil) then
		ngx.say(err)
		return -1
	end
	local current = file:seek()
	local size = file:seek("end")
	file:seek("set",current)
	file:close()
	return size
end

function getfileName(fileName)
	local str = fileName;
	local i = 0
	while true do
		i = string.find(str,"/",i)
		if(i ~= nil) then
			str = string.sub(str,i + 1,-1)
		else
			break
		end
	end
	return str
end


function outputFormat(size, path, fileName)
	return string.format("- %d /zip/files/%s %s", size, path, fileName)
	--return string.format("- %d /v1/file/%s %s", size, path, fileName)
	--return "- 3984407 /data/1401944400/140006068962688423T1401969602_1.mp4 xx.mp4"
end

--3984407 Jun  5 13:05 140006068962688423T1401969602_1.mp4
--3432785 Jun  5 13:07 140006068962688423T1401970961_1.mp4

function stringSplit(str, sp)
	local temp = str;
	local ret = {}
	local i = 0;
	while true do
		i = string.find(str,sp)
		if(i ~= nil) then
			table.insert(ret,string.sub(str,0,i - 1))
			str = string.sub(str,i + 1, -1)
		else
			break;
		end
	end
	table.insert(ret,str)
	return ret
end

ngx.req.read_body()
local args, err = ngx.req.get_post_args()
local device_id = ngx.var.arg_device_id
local token = ngx.var.arg_token


local string = ""
--local rootPath = "/opt/srv/nginx-1.4.5/html"
local rootPath = "/mnt/highdisk/moviesx/data/"

if not args then
	ngx.say("failed to get post args:",err)
	return 
end
for key, val in pairs(args) do
    if type(val) == "table" then
        --local str = table.concat(val, ",")
        --string = string..str.."\\r\\n"
		for num, data in pairs(val) do
			_, _, file, size = string.find(data, "([%w_]+.mp4)||(%d+)")
			--local absolutePath = rootPath..file
			--ngx.say(absolutePath)
			--string = string..outputFormat(getfileSize(absolutePath),"/"..file,getfileName(file)).."\r\n"
			--string = string..outputFormat(size , "/"..file.."?device_id="..device_id.."&token="..token, getfileName(file)).."\r\n"
			string = string..outputFormat(size , file.."?device_id="..device_id.."&token="..token, getfileName(file)).."\r\n"
		end
    else
		local absolutePath = rootPath..val
		_, _, file, size = string.find(val, "([%w_]+.mp4)||(%d+)")
		--string = string..outputFormat(size , "/"..file.."?device_id="..device_id.."&token="..token, getfileName(file)).."\r\n"
		string = string..outputFormat(size , file.."?device_id="..device_id.."&token="..token, getfileName(file)).."\r\n"
    end
end
filename=os.date("%Y%m%d.zip",time);
ngx.header["content-type"] = "text/plain"
ngx.header["X-Archive-Files"] = "zip"
ngx.header["Content-disposition"] = "attachment; filename="..filename
ngx.say(string)

