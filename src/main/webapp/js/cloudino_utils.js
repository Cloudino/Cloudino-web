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

var loadContent = function(url, target, data)
{
    if(data)
    {
        $.post(url, data, function(data) {
            $(target).html(
                    cdino_parse(data)
                    );
            $.AdminLTE.tree($(target));
        });
    }else
    {
        $.get(url, function(data) {
            $(target).html(
                    cdino_parse(data)
                    );
            $.AdminLTE.tree($(target));
        });
    }
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