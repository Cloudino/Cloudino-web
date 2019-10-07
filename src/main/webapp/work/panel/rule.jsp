<%-- 
    Document   : rule
    Created on : 15-oct-2015, 0:04:21
    Author     : javiersolis
--%>
<%@page import="io.cloudino.engine.Device"%>
<%@page import="io.cloudino.engine.DeviceMgr"%>
<%@page import="java.io.IOException"%>
<%@page import="org.semanticwb.datamanager.DataList"%>
<%@page import="java.util.Iterator"%>
<%@page import="jdk.nashorn.api.scripting.ScriptObjectMirror"%>
<%@page import="javax.script.ScriptEngine"%>
<%@page import="java.util.concurrent.TimeUnit"%>
<%@page import="io.cloudino.rules.scriptengine.NashornEngineFactory"%>
<%@page import="io.cloudino.rules.scriptengine.RuleEngineProvider"%>
<%@page import="org.semanticwb.datamanager.DataMgr"%>
<%@page import="org.semanticwb.datamanager.SWBDataSource"%>
<%@page import="org.semanticwb.datamanager.SWBScriptEngine"%>
<%@page import="org.semanticwb.datamanager.DataObject"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%!

    public DataList getList(String ds, SWBScriptEngine engine, DataObject user, DataList def) throws IOException
    {
        SWBDataSource dsctx=engine.getDataSource(ds); 
        DataObject query=new DataObject();
        query.addSubObject("data").addParam("user", user.getId());
        //System.out.println(query);
        DataObject res=dsctx.fetch(query);
        DataList list=res.getDataObject("response").getDataList("data");
        //System.out.println(list);
        DataList ret=new DataList();
        for(int x=0;x<list.size();x++)
        {
            DataList l=new DataList();
            l.add(list.getDataObject(x).getString("name"));
            l.add(list.getDataObject(x).getNumId());
            ret.add(l);
        }
        if(def!=null && ret.size()==0)ret.add(def);
        //System.out.println(ret);
        return ret;
    }

%>
<%
    String id=request.getParameter("ID");
    DataObject user=(DataObject)session.getAttribute("_USER_");
    SWBScriptEngine engine=DataMgr.getUserScriptEngine("/cloudino.js",user);
    SWBDataSource ds=engine.getDataSource("CloudRule");
    DataObject obj=ds.fetchObjByNumId(id);

    if (obj == null || (obj != null && !obj.getString("user").equals(user.getId()))) {
        response.sendError(404);
        return;
    }    
    
    String xml=obj.getString("xml");

    String act=request.getParameter("act");
    if("update".equals(act))
    {
        String script=request.getParameter("script");
        xml=request.getParameter("xml");
        obj.put("script", script);
        obj.put("xml", xml);
        //System.out.println("CloudRule:"+obj);
        ds.updateObj(obj);
        //Remove RuleEngineChache
        RuleEngineProvider.getInstance().removeEngine(obj.getId());
        
        //CloudRuleEvents
        //Remove Previous Events
        SWBDataSource dsevent=engine.getDataSource("CloudRuleEvent");
        DataObject x=new DataObject().addParam("removeByID", false);
        x.addSubObject("data").addParam("user", user.getId()).addParam("cloudRule", obj.getId());
        //System.out.println(x);
        dsevent.remove(x);
        
        ScriptEngine eng=NashornEngineFactory.getEngine(1, TimeUnit.SECONDS);
        ScriptObjectMirror ret=(ScriptObjectMirror)eng.eval(script+"\n_cdino_events;");
        if(ret!=null && ret.isArray())
        {
            for(int i=0;i<ret.size();i++)
            {
                ScriptObjectMirror slot=(ScriptObjectMirror)ret.getSlot(i);
                DataObject dobj=new DataObject();
                dobj.put("user", user.getId());
                dobj.put("cloudRule", obj.getId());
                dobj.put("context", slot.get("context"));
                dobj.put("type", slot.get("type"));  
                dobj.put("arrayIndex", i);                  
                //dobj.put("funct", NashornEngineFactory.serialize((ScriptObjectMirror)slot.get("funct")));  
                DataObject params=new DataObject();
                dobj.put("params", params);  
                
                ScriptObjectMirror sparams=(ScriptObjectMirror)slot.get("params");
                Iterator<String> it=sparams.keySet().iterator();
                while(it.hasNext())
                {
                    String key=it.next();
                    params.put(key,sparams.get(key));
                    //reset Events Device Cache 
                    if(key.equals("device"))
                    {
                        Device dev=DeviceMgr.getInstance().getDeviceIfPresent(sparams.get(key).toString());
                        if(dev!=null)dev.resetEvents();
                    }
                }                                
                //String json=NashornEngineFactory.serialize(slot);
                //System.out.println("ret:"+json);
                //System.out.println("CloudRuleEvent:"+dobj);
                dsevent.addObj(dobj);
            }            
        }
        
        
    }
%>
<div id="blocklyDiv" style="height: 410px; width: 100%;"></div>
<div class="box-footer">
    <button type="submit" class="btn btn-primary" onclick="ruleSubmit();">Submit</button>
</div>

<xml id="toolbox" style="display: none">
    <category id="general" name="General">
        <block type="cdino_context"></block>
    </category>
    <category id="events" name="Events">
        <block type="cdino_ondevice_message"></block>
        <block type="cdino_onchange_context"></block>
        <block type="cdino_ondevice_connection"></block>
    </category>
    <category id="actions" name="Actions">
        <block type="cdino_send_device_message"></block>
        <block type="cdino_invoke_after"></block>
        <block type="cduino_change_context"></block>
        <block type="cdino_push_notification"></block>
        <block type="cdino_email_notification"></block>
        <block type="cdino_sms_notification"></block>
        <block type="cdino_debug"></block>
    </category>         
    <sep></sep>
    <category id="catVariables" custom="VARIABLE" name="Variables"></category>        
    <category id="catLogic" name="Logic">
        <block type="controls_if"></block>
        <block type="logic_ternary"></block>
        <block type="logic_compare"></block>
        <block type="logic_operation"></block>
        <block type="logic_negate"></block>
        <block type="logic_boolean"></block>
        <block type="logic_null"></block>
    </category>
    <category id="catLoops" name="Loops">
        <block type="controls_repeat_ext">
            <value name="TIMES">
                <block type="math_number">
                    <field name="NUM">10</field>
                </block>
            </value>
        </block>
        <block type="controls_whileUntil"></block>
        <block type="controls_for">
            <value name="FROM">
                <block type="math_number">
                    <field name="NUM">1</field>
                </block>
            </value>
            <value name="TO">
                <block type="math_number">
                    <field name="NUM">10</field>
                </block>
            </value>
            <value name="BY">
                <block type="math_number">
                    <field name="NUM">1</field>
                </block>
            </value>
        </block>
        <!--<block type="controls_forEach"></block>-->
        <block type="controls_flow_statements"></block>
    </category>

    <category id="catMath" name="Math">
        <block type="math_number"></block>
        <block type="parseint"></block>
        <block type="math_arithmetic"></block>
        <block type="math_single"></block>
        <block type="math_trig"></block>
        <block type="math_constant"></block>
        <block type="math_number_property"></block>
        <block type="math_change">
            <value name="DELTA">
                <block type="math_number">
                    <field name="NUM">1</field>
                </block>
            </value>
        </block>
        <block type="math_round"></block>
        <block type="math_on_list"></block>
        <block type="math_modulo"></block>
        <block type="math_constrain">
            <value name="LOW">
                <block type="math_number">
                    <field name="NUM">1</field>
                </block>
            </value>
            <value name="HIGH">
                <block type="math_number">
                    <field name="NUM">100</field>
                </block>
            </value>
        </block>
        <!--
        <block type="math_random_int">
            <value name="FROM">
                <block type="math_number">
                    <field name="NUM">1</field>
                </block>
            </value>
            <value name="TO">
                <block type="math_number">s
                    <field name="NUM">100</field>
                </block>
            </value>
        </block>
        <block type="math_random_float"></block>
        -->
    </category>
    <category id="catText" name="Text">
        <block type="text"></block>
        <block type="text_join"></block>
        <block type="text_append">
            <value name="TEXT">
                <block type="text"></block>
            </value>
        </block>
        <block type="text_length"></block>
        <block type="text_isEmpty"></block>
        <block type="text_indexOf">
            <value name="VALUE">
                <block type="variables_get">
                    <field name="VAR" class="textVar">text</field>
                </block>
            </value>
        </block>
        <block type="text_charAt">
            <value name="VALUE">
                <block type="variables_get">
                    <field name="VAR" class="textVar">text</field>
                </block>
            </value>
        </block>
        <block type="text_getSubstring">
            <value name="STRING">
                <block type="variables_get">
                    <field name="VAR" class="textVar">text</field>
                </block>
            </value>
        </block>
        <block type="text_changeCase"></block>
        <block type="text_trim"></block>
        <!--
        <block type="text_print"></block>
        <block type="text_prompt_ext">
            <value name="TEXT">
                <block type="text"></block>
            </value>
        </block>
        -->
    </category>
    <!--
    <category id="catLists" name="Lists">
        <block type="lists_create_with">
            <mutation items="0"></mutation>
        </block>
        <block type="lists_create_with"></block>
        <block type="lists_repeat">
            <value name="NUM">
                <block type="math_number">
                    <field name="NUM">5</field>
                </block>
            </value>
        </block>
        <block type="lists_length"></block>
        <block type="lists_isEmpty"></block>
        <block type="lists_indexOf">
            <value name="VALUE">
                <block type="variables_get">
                    <field name="VAR" class="listVar">list</field>
                </block>
            </value>
        </block>
        <block type="lists_getIndex">
            <value name="VALUE">
                <block type="variables_get">
                    <field name="VAR" class="listVar">list</field>
                </block>
            </value>
        </block>
        <block type="lists_setIndex">
            <value name="LIST">
                <block type="variables_get">
                    <field name="VAR" class="listVar">list</field>
                </block>
            </value>
        </block>
        <block type="lists_getSublist">
            <value name="LIST">
                <block type="variables_get">
                    <field name="VAR" class="listVar">list</field>
                </block>
            </value>
        </block>
        <block type="lists_split">
            <value name="DELIM">
                <block type="text">
                    <field name="TEXT">,</field>
                </block>
            </value>
        </block>
    </category>
    -->       
</xml>

<script>

    function ruleSubmit()
    {
        var data = {ID:"<%=id%>",act:"update",script:Blockly.Cloudino.getCloudRuleCode(),xml:Blockly.Cloudino.getXML()};
        loadContent('rule', "#tab2",data);
    }

    function getContexts()
    {
<%
    DataList def=new DataList();
    def.add("No Context");
    def.add("-");
%>        return <%=getList("UserContext",engine,user, def)%>;
    }

    function getDevices()
    {
        return <%=getList("Device",engine,user,null)%>;
    }
</script>

<script>
    var blocklyDiv = document.getElementById('blocklyDiv');
    var workspace = Blockly.inject(blocklyDiv, {
        grid: {
            spacing: 25,
            length: 3,
            colour: '#ccc',
            snap: true
        },
        media: '/static/plugins/blockly/media/',
        toolbox: document.getElementById('toolbox')
    });
  
<%if(xml!=null){%>
    Blockly.Cloudino.loadXML('<%=xml%>');
<%}%>

    var blockly_tab=$('a[data-toggle="tab"]');

    blockly_tab.off("shown.bs.tab");
    blockly_tab.on('shown.bs.tab', function(e) {
        //e.target // newly activated tab
        //e.relatedTarget // previous active tab
        //console.lo
        Blockly.resize();
        workspace.render();
        //console.log('shown.bs.tab', e);
    });
    
    var blockly_resize=function(){
        Blockly.resize();
        workspace.render(); 
    };
    
    var blockly_animate_resize=function(){
        for(var x=0;x<30;x++)
        {
            setTimeout(function(){
                blockly_resize();            
            },10*x);
        }
    };    
    
    $(window).off("resize.blockly");
    $(window).on("resize.blockly",blockly_resize);
    
    
    $(document).off("expanded.pushMenu");
    $(document).on('expanded.pushMenu', blockly_animate_resize);
    
    $(document).off("collapsed.pushMenu");
    $(document).on('collapsed.pushMenu', blockly_animate_resize);     
    
    var control_sidebar=$('[data-toggle="control-sidebar"]');
    
    control_sidebar.off("expanded.controlsidebar");
    control_sidebar.on('expanded.controlsidebar', blockly_animate_resize);
    
    control_sidebar.off("collapsed.controlsidebar");
    control_sidebar.on('collapsed.controlsidebar', blockly_animate_resize);      
</script>
