local raw_uri = ngx.var.request_uri;
local uri = string.lower(ngx.var.uri);
local length = string.len(uri);

--drop the last '/'
if string.sub(uri, length, length) == '/' and length >1  then
	uri = string.sub(uri, 1, -2);
end
----------------write some function to a var, then you will use it in router table-----------------

--local user_batch_create=require "user_batch_create.lua"

local to_php = function (uri)
    local is_args = ngx.var.is_args or "";
    local args = ngx.var.args or "";
    ngx.exec("/router.php" .. is_args .. args)   
end

local to_thumb = function ()
    local width = 640;
    if ngx.var.arg_W ~= nil and ngx.var.arg_W ~= ''then
        width = ngx.var.arg_W
    end
    local height = 480;
    if ngx.var.arg_H ~= nil and ngx.var.arg_H ~= '' then
        height = ngx.var.arg_H
    end
    local hash = "hash";
    if ngx.var.arg_HASH ~= nil and ngx.var.arg_HASH ~= '' then
        hash = ngx.var.arg_HASH
    end
    ngx.var.args=nil
    --ngx.log(ngx.ERR, "width: ", width)
    --ngx.log(ngx.ERR, "height: ", height)
    --ngx.log(ngx.ERR, "contr: ", uri)
    local rest_uri = string.sub(uri, 8, -1)
    --ngx.log(ngx.ERR, "rest_uri: ", rest_uri)
    ngx.exec('/_thumb/'..rest_uri, 'width='..width..'&height='..height..'&hash='..hash..'&X-LENOVOWS-OP=preview');
end

local to_404 = function()
    ngx.exit(ngx.HTTP_NOT_FOUND);
end
--------------------------------------------------------------------------------------
-------------------------config router as key -> value----------------
--key is regular express and value is a var which defined up------------
--
local router = {
	 ['^/example/index']			=	to_php
	,['^/example/log$']				=	to_php
	,['^/svn/up$']					=	to_php
	,['^/svn/log$']					=	to_php
	,['^/svn/export$']				=	to_php
	,['^/index/api_login']			=	to_php
	,['^/api']	            		=	to_php
	,['^/admin/index$']				=	to_php
	,['^/admin/top$']				=	to_php
	,['^/admin/bottom$']			=	to_php
	,['^/admin/content$']			=	to_php
	,['^/admin/menu$']				=	to_php
	,['^/admin/signin$']			=	to_php
	,['^/admin/']	        		=	to_php
	--,['^/admin/account_list$']		=	to_php
	--,['^/admin/account_detail/']	=	to_php
	--,['^/admin/account_info/']		=	to_php
	--,['^/admin/modify_account_info']=	to_php
	--,['^/admin/account_log_view/']	=	to_php
	--,['^/admin/account_search$']	=	to_php
	--,['^/admin/manager_list$']      =	to_php
	--,['^/admin/signout$']			=	to_php
	--,['^/admin/login']			    = 	to_php
	--,['^/admin/add_manager$']       =   to_php
	--,['^/admin/update_display']     =   to_php
	--,['^/admin/update_manager']     =   to_php
	--,['^/admin/delete']				=   to_php
	--,['^/admin/log']				=   to_php
	,['^/client/']      			=   to_php
	,['^/edm/']          			=   to_php
	,['^/client/']          		=   to_php
	,['^/agent/']         			=   to_php
	,['^/agent/add']				=   to_php
	,['^/guide/']         			=   to_php
	,['^/example/phpinfo$']			=	to_php
	,['^/user']     				=	to_php
	,['^/user/signup']				=	to_php
	,['^/user/signin']				=	to_php
	,['^/user/signout']				=	to_php
	,['^/user/reset_password']		=	to_php
	,['^/user/forgot_password']		=	to_php
	,['^/user/noactivate']			=	to_php
	,['^/user/expired']				=	to_php
	,['^/user/frozen']				=	to_php
	,['^/user/manage']				=	to_php
	,['^/log/manage']				=	to_php
	,['^/team/auth']	    		=	to_php
	,['^/team/member']  			=	to_php
	,['^/mail/activate']			=	to_php
	,['^/mail/user_activate']		=	to_php
	,['^/mail/reset_password']		=	to_php
	,['^/mail/sendlink']    		=	to_php
	,['^/mail/success']     		=	to_php
	,['^/captcha/create']			=	to_php
	,['^/captcha/check']	   		=	to_php
	,['^/captcha/send']	    		=	to_php
	,['^/account/setting']	   		=	to_php
	,['^/account/security']    		=	to_php
	,['^/account/user_setting']     =	to_php
	,['^/account/customize']		=	to_php
	,['^/account/upgrade']          =	to_php
	,['^/language/']    			=	to_php
	,['^/$']						=	to_php
	,['^/link/view/.*']			   	=	to_php
	,['^/link/list']        		=	to_php
	,['^/auth/list']	        	=	to_php

--	,['^/user/batch_create']		=	user_batch_create
	,['^/thumb/.*.(jpg|png|jpeg|gif)$']	    	=	to_thumb
};
----------------------------------------------------------------------

--ngx.header['content-type']="text/plain"
local match = nil;
local location = nil;
--ngx.say("now start time :   "..ngx.now())
for k, v in pairs(router) do
--ngx.say("k is ".. k .."-------")
  match = ngx.re.match(uri, k, 'iojs')
  if match ~= nil then
--ngx.say("matched =============== "..match[0])
    location = v
    break
  end
end
ngx.update_time()
--ngx.say("now end time :   ".. ngx.now())

if location == nil then
  ngx.exit(ngx.HTTP_GONE);
else
    local ret, reason = pcall(location, uri)
    ngx.log(ngx.ERR, "pcall :  reason: ", ret, reason)
end
