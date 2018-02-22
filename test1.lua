wrk.method = "POST"
wrk.headers["Content-Type"] = "application/xml"
wrk.headers["Accept"] = "application/xml"

function readAll(file)
    local f = assert(io.open(file, "rb"))
    local content = f:read("*all")
    f:close()
    return content
end

wrk.body = readAll("search.xml")

--print(wrk.body)

local counter = 1
local threads = {}

function setup(thread)
   thread:set("id", counter)
   table.insert(threads, thread)
   counter = counter + 1
end

function init(args)
   requests  = 0
   responses = 0
   correctResponse = 0
   errorCode = {}
   local msg = "thread %d created"
   print(msg:format(id))
end

function request()
   requests = requests + 1
   return wrk.request()
end

function response(status, headers, body)
   responses = responses + 1
   if status == 200 then
   	 correctResponse = correctResponse + 1
   elseif errorCode[status] then
       errorCode[status] = errorCode[status] + 1
   else
       errorCode[status] = 1
   end
end

function printErrorCode(errorCode)
   for code, number in ipairs(errorCode) do
      local msg = "Code: %d, count: %d"
      print(msg:format(code, number))
   end
end

--summary is NOT thread specific
function done(summary, latency, requests)
   for index, thread in ipairs(threads) do
      local id        = thread:get("id")
      local requests  = thread:get("requests")
      local responses = thread:get("responses")
      local errorCode = thread:get("errorCode")
      local correctResponse = thread:get("correctResponse")
      local msg = "thread %d made %d requests and got %d responses, %d responses are 200 OK"
      print(msg:format(id, requests, responses, correctResponse))
      printErrorCode(errorCode)
   end
end