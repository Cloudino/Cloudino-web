var WS = {
    
    notify:{},
    
    ws:null,
    
    setConnected:function(connected) {
        if(document.getElementById('connect'))
        {
            document.getElementById('connect').disabled = connected;
            document.getElementById('disconnect').disabled = !connected;
            document.getElementById('send').disabled = !connected;
        }
    },
    
    onMessage:function(topic, callback)
    {
        if(typeof WS.notify[topic] === "undefined")
        {
            WS.notify[topic]=[callback];            
        }else
        {
            WS.notify[topic].push(callback);
        }
    },
    
    notifyObject:function(topic, obj)
    {
        for(var key in obj){
            if(WS.notify[topic+"."+key])
            {                        
                WS.notify[topic+"."+key].forEach(function(entry) 
                {
                    var msg=obj[key];
                    if(typeof msg === 'object')
                    {
                        entry(JSON.stringify(msg));
                        WS.notifyObject(topic+"."+key,msg);
                    }else
                    {
                        entry(msg);
                    }
                });
            }                            
        }
    },

    connect:function(target) {
        WS.notify={};
        //var target = "ws://" + window.location.host+ "/websocket/cdino?ID=<%=id%>";
        if ('WebSocket' in window) {
            WS.ws = new WebSocket(target);
        } else if ('MozWebSocket' in window) {
            WS.ws = new MozWebSocket(target);
        } else {
            alert('WebSocket is not supported by this browser.');
            return;
        }
        WS.ws.onopen = function () {
            WS.setConnected(true);
            //WS.log('Info: WebSocket connection opened.');
        };
        WS.ws.onmessage = function (event) {
            //console.log(event.data);
            if(event.data.startsWith("msg:$CDINOJSRSP"))
            {
                WS.log(event.data.substring(15),"ws_jsrsp");
            }else if(event.data.startsWith("msg:"))
            {
                var tmp=event.data.substring(4);
                var i=tmp.indexOf("\t");
                if(i>-1)
                {
                    var topic=tmp.substring(0,i);
                    var msg=tmp.substring(i+1);                
                    //is object
                    if(WS.notify[topic])
                    {                        
                        WS.notify[topic].forEach(function(entry) {
                            entry(msg);
                        });
                    }                                        
                    if((msg.startsWith('{') && msg.endsWith('}')) || (msg.startsWith('[') && msg.endsWith(']')))
                    {
                        var obj=JSON.parse(msg);
                        WS.notifyObject(topic,obj);
                    }
                }
                WS.log("> "+topic+": "+msg,"ws_msg");
                
            }else if(event.data.startsWith("rmsg:"))
            {
                var tmp=event.data.substring(5);
                var i=tmp.indexOf("\t");
                if(i>-1)
                {
                    var topic=tmp.substring(0,i);
                    var msg=tmp.substring(i+1);                
                    if(WS.notify[topic])
                    {                        
                        WS.notify[topic].forEach(function(entry) {
                            entry(msg);
                        });
                    }
                }
                WS.log("< "+topic+": "+msg,"ws_msg");
                
            }else if(event.data.startsWith("log:"))
            {
                WS.log(event.data.substring(4),"ws_log");
            }else if(event.data.startsWith("cmp:"))
            {
                WS.log(event.data.substring(4),"ws_cmp");
            }
        };
        WS.ws.onclose = function (event) {
            WS.setConnected(false);
            //WS.log('Info: WebSocket connection closed, Code: ' + event.code + (event.reason == "" ? "" : ", Reason: " + event.reason));
        };
    },

    disconnect:function () {
        if (WS.ws != null) {
            WS.ws.close();
            WS.ws = null;
        }
        WS.setConnected(false);
    },

    encodeMessage: function (topic,message)
    {                
        return "|M"+WS.byteLength(topic)+"|"+topic+"S"+WS.byteLength(message)+"|"+message;
    },

    send: function () {
        if (WS.ws != null) {
            var topic = document.getElementById('topic').value;
            var message = document.getElementById('message').value;
            var enc=WS.encodeMessage(topic,message);
            WS.ws.send(enc);
            WS.log("< "+topic+": "+message,"ws_msg");
        } else {
            alert('WebSocket connection not established, please connect.');
        }
    },
    
    sendJS: function () {
        if (WS.ws != null) {
            var topic = "$CDINOJSCMD";
            var message = document.getElementById('jscmd').value;
            var enc=WS.encodeMessage(topic,message);
            WS.ws.send(enc);
            WS.log("< "+message,"ws_jsrsp");
        } else {
            alert('WebSocket connection not established, please connect.');
        }
    },
    
    post:function (topic, message){
        if (WS.ws != null) {
            var enc=WS.encodeMessage(topic,message);
            WS.ws.send(enc);
            WS.log("< "+topic+": "+message,"ws_msg");
        } else {
            alert('WebSocket connection not established, please connect.');
        }
    },
    
    log:function (message,div) {
        if(!div)div="ws_log";
        var console = document.getElementById(div);
        if(console)
        {
            var p = document.createElement('div');
            //p.style.wordWrap = 'break-word';
            p.innerHTML=new Date().toISOString()+": <b>"+message+"</b>";
            console.appendChild(p);
            while (console.childNodes.length > 25) {
                console.removeChild(console.firstChild);
            }
        }
        //console.scrollTop = console.scrollHeight;
    },
    
    byteLength:function(str)
    {
        // returns the byte length of an utf8 string
        var s = str.length;
        for (var i=str.length-1; i>=0; i--) {
          var code = str.charCodeAt(i);
          if (code > 0x7f && code <= 0x7ff) s++;
          else if (code > 0x7ff && code <= 0xffff) s+=2;
        }
        return s;
    }            
    
};