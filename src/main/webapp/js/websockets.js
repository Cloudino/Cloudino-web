var WS = {
    
    ws:null,
    
    setConnected:function(connected) {
        document.getElementById('connect').disabled = connected;
        document.getElementById('disconnect').disabled = !connected;
        document.getElementById('send').disabled = !connected;
    },

    connect:function(target) {
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
            console.log(event.data);
            if(event.data.startsWith("msg:$CDINOJSRSP"))
            {
                WS.log(event.data.substring(15),"ws_jsrsp");
            }else if(event.data.startsWith("msg:"))
            {
                WS.log(event.data.substring(4),"ws_msg");
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
        return "|M"+topic.length+"|"+topic+"S"+message.length+"|"+message;
    },

    send: function () {
        if (WS.ws != null) {
            var topic = document.getElementById('topic').value;
            var message = document.getElementById('message').value;
            var enc=WS.encodeMessage(topic,message);
            WS.ws.send(enc);
            WS.log(topic+"->"+message);
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
            WS.log("> "+message,"ws_jsrsp");
        } else {
            alert('WebSocket connection not established, please connect.');
        }
    },
    
    post:function (topic, message){
        if (WS.ws != null) {
            var enc=WS.encodeMessage(topic,message);
            WS.ws.send(enc);
            WS.log(topic+"->"+message);
        } else {
            alert('WebSocket connection not established, please connect.');
        }
    },
    
    log:function (message,div) {
        if(!div)div="ws_msg";
        var console = document.getElementById(div);
        if(console)
        {
            var p = document.createElement('div');
            //p.style.wordWrap = 'break-word';
            p.innerHTML=message;
            console.appendChild(p);
            while (console.childNodes.length > 25) {
                console.removeChild(console.firstChild);
            }
        }
        //console.scrollTop = console.scrollHeight;
    },
    
};