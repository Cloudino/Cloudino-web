<%-- 
    Document   : rule
    Created on : 15-oct-2015, 0:04:21
    Author     : javiersolis
--%>
<%@page import="org.semanticwb.datamanager.DataMgr"%>
<%@page import="org.semanticwb.datamanager.SWBDataSource"%>
<%@page import="org.semanticwb.datamanager.SWBScriptEngine"%>
<%@page import="org.semanticwb.datamanager.DataObject"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
        ds.updateObj(obj);
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

    </category>
    <category id="actions" name="Actions">
        <block type="cdino_send_device_message"></block>
        <block type="cdino_invoke_after"></block>
        <block type="cduino_change_context"></block>
        <block type="cdino_push_notification"></block>
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
        <block type="cdino_parse_number"></block>
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
        return [["En Casa", "contx1"], ["Fuera de Casa", "contx2"], ["Durmiendo", "contx3"]];
    }

    function getDevices()
    {
        return [["Alarma", "dev1"], ["Casa", "dev2"], ["Jardin", "dev3"]];
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
        media: '/plugins/blockly/media/',
        toolbox: document.getElementById('toolbox')
    });
  
<%if(xml!=null){%>
    Blockly.Cloudino.loadXML('<%=xml%>');
<%}%>

    $('a[data-toggle="tab"]').on('shown.bs.tab', function(e) {
        //e.target // newly activated tab
        //e.relatedTarget // previous active tab
        //console.lo
        Blockly.fireUiEvent(window, 'resize');
        workspace.render();
        //console.log('shown.bs.tab', e);
    });
</script>
