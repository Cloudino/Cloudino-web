/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

var getAsynchData = function(url, data, method, callback)
{

    //alert(url + '\n\r' + data + '\n\r' + method);
    if (typeof XMLHttpRequest === "undefined")
    {
        XMLHttpRequest = function() {
            try {
                return new ActiveXObject("Msxml2.XMLHTTP.6.0");
            }
            catch (e) {
            }
            try {
                return new ActiveXObject("Msxml2.XMLHTTP.3.0");
            }
            catch (e) {
            }
            try {
                return new ActiveXObject("Microsoft.XMLHTTP");
            }
            catch (e) {
            }
            // Microsoft.XMLHTTP points to Msxml2.XMLHTTP and is redundant
            throw new Error("This browser does not support XMLHttpRequest.");
        };
    }

    var aRequest = new XMLHttpRequest();
    var aRequest = new XMLHttpRequest();
    aRequest.onreadystatechange = function()
    {
        if (aRequest.readyState == 4 && aRequest.status == 200)
        {
            callback(aRequest.responseText);
        }
    }
    if (!data)
    {
        if (!method)
            method = "GET";
        aRequest.open(method, url, true);
        aRequest.send();
    } else
    {
        //alert('post>>>>>>>>>>>>> ' + url);
        if (!method)
            method = "POST";
        aRequest.open(method, url, true);
        aRequest.send(data);
    }
};

var getSynchData = function(url, data, method)
{

    //alert(url + '\n\r' + data + '\n\r' + method);
    if (typeof XMLHttpRequest === "undefined")
    {
        XMLHttpRequest = function() {
            try {
                return new ActiveXObject("Msxml2.XMLHTTP.6.0");
            }
            catch (e) {
            }
            try {
                return new ActiveXObject("Msxml2.XMLHTTP.3.0");
            }
            catch (e) {
            }
            try {
                return new ActiveXObject("Microsoft.XMLHTTP");
            }
            catch (e) {
            }
            // Microsoft.XMLHTTP points to Msxml2.XMLHTTP and is redundant
            throw new Error("This browser does not support XMLHttpRequest.");
        };
    }

    var aRequest = new XMLHttpRequest();
    if (!data)
    {
        if (!method)
            method = "GET";
        aRequest.open(method, url, false);
        aRequest.send();
    } else
    {
        //alert('post>>>>>>>>>>>>> ' + url);
        if (!method)
            method = "POST";
        aRequest.open(method, url, false);
        aRequest.send(data);
    }
    return aRequest;
};

var loadContent = function(url, target, data, callback)
{
    if(data)
    {
        $.post(url, data, function(data) {
            $(target).html(
                    cdino_parse(data)
                    );
            $(target).tree();
            if(callback)callback();
        });
    }else
    {
        $.get(url, function(data) {
            $(target).html(
                    cdino_parse(data)
                    );
            $(target).tree();
            if(callback)callback();
        });
    }
}

var cdino_alert = function(title, content, type, delay)
{
    var am=$("#alert_main");
    am.toggleClass("alert-info",false); 
    am.toggleClass("alert-success",false);
    am.toggleClass("alert-warning",false);
    am.toggleClass("alert-danger",false);
    
    var icon=$("#alert_icon");
    icon.toggleClass("fa-ban",false);
    icon.toggleClass("fa-check",false);
    icon.toggleClass("fa-info",false);
    icon.toggleClass("fa-warning",false);
    
    if(type=="success")
    {
        am.toggleClass("alert-success",true);  
        icon.toggleClass("fa-check",true);
    }else if(type=="info")
    {
        am.toggleClass("alert-info",true);  
        icon.toggleClass("fa-info",true);
    }else if(type=="warning")
    {
        am.toggleClass("alert-warning",true);  
        icon.toggleClass("fa-warning",true);
    }else if(type=="danger")
    {
        am.toggleClass("alert-danger",true);  
        icon.toggleClass("fa-ban",true);
    }
    
    $("#alert_title").html(title);
    $("#alert_content").html(content);
    am.show(500);
    if(delay)window.setTimeout(function() { am.hide(500) }, delay);
}

var cdino_parse = function(html)
{
    var root = $;
    if (html)
        root = $(html);
    $(root.find('[data-load="ajax"]')).click(function(e) {
        var $this = $(this),
                loadurl = $this.attr('href'),
                targ = $this.attr('data-target');

        $.get(loadurl, function(data) {
            //todo validar si hay cambios
            if(Blockly)
            {
              if (typeof workspace !== 'undefined') {
                workspace.dispose();
              }
              //Blockly.fireUiEvent(window, 'resize');
            }
            $(targ).html(cdino_parse(data));
        });
        return false;
    });

    $(root.find('[role="form"]')).validator();

    $(root.find('[data-submit="ajax"]')).submit(function(event) {
        // Stop form from submitting normally
        event.preventDefault();
        // Get some values from elements on the page:
        var $form = $(this);
        var params = $form.serialize();
        var url = $form.attr("action");
        var targ = $form.attr('data-target');

        // Send the data using post
        var posting = $.post(url, params);

        // Put the results in a div
        posting.done(function(data) {
            $(targ).html(cdino_parse(data));
        });
        return false;
    });    
    return root;
};

cdino_parse();