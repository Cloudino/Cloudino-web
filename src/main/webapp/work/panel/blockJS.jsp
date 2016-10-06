<%-- 
    Document   : rule
    Created on : 15-oct-2015, 0:04:21
    Author     : javiersolis
--%>
<%@page import="org.apache.commons.io.FileUtils"%>
<%@page import="java.io.FileOutputStream"%>
<%@page import="io.cloudino.utils.Utils"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.File"%>
<%@page import="org.semanticwb.datamanager.DataMgr"%>
<%@page import="org.semanticwb.datamanager.SWBDataSource"%>
<%@page import="org.semanticwb.datamanager.SWBScriptEngine"%>
<%@page import="org.semanticwb.datamanager.DataObject"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String id = request.getParameter("ID");
    DataObject user = (DataObject) session.getAttribute("_USER_");
    SWBScriptEngine engine = DataMgr.getUserScriptEngine("/cloudino.js", user);
    String act = request.getParameter("act");
    String xml = null;

    String workPath = DataMgr.getApplicationPath() + "/work/";
    String blockPath = workPath + engine.getScriptObject().get("config").getString("usersWorkPath") + "/" + user.getNumId() + "/cloudinojs/blocks/" + id;

    File blockDir = new File(blockPath);
    if (blockPath.indexOf("..")>-1 || !blockDir.exists()) {
        response.sendError(404);
        return;
    } else {
        File fx = new File(blockDir, id + ".xml");
        if (fx.exists()) {
            FileInputStream in = new FileInputStream(fx);
            xml = Utils.textInputStreamToString(in, "utf8");
        }
    }

    if ("update".equals(act)) {
        String script = request.getParameter("script");
        xml = request.getParameter("xml");
        try {
            FileOutputStream fout = new FileOutputStream(new File(blockDir, id + ".js"));
            fout.write(script.getBytes());
            fout.close();

            fout = new FileOutputStream(new File(blockDir, id + ".xml"));
            fout.write(xml.getBytes());
            fout.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    //remove
    if ("remove".equals(act)) {
        FileUtils.deleteDirectory(new File(blockPath));
        out.println("<script type=\"text/javascript\">Blockly.resize();loadContent('/panel/cloudinojs?act=bl','#cloudinojs');</script>");
%>
<!-- Custom Tabs -->
<div class="nav-tabs-custom">
    <div class="tab-content">
        <div class="tab-pane active" id="tab_1">
            <h3>Block was delete successfully...</h3>
        </div><!-- /.tab-pane -->
    </div>    
</div>
<%
        return;
    }
%>
<div id="blocklyDiv" style="height: 410px; width: 100%;"></div>
<div class="box-footer">
    <button type="submit" class="btn btn-primary" onclick="codeSubmit();">Submit</button>
    <button class="btn btn-danger" onclick="return removeBlock(this);">Delete</button>  
</div>
<hr/>
<div class_="form-group has-feedback">
    <label>Console</label>
    <div class="callout callout-info">
        <div id="consoleLog"></div>
    </div>
</div>    

<script type="text/javascript">
    function removeBlock(alink){
            if(confirm('Are you sure to remove this Block?')){
                var urlRemove = 'blockJS?ID=<%=id%>&act=remove';
                loadContent(urlRemove,"#main_content");
                //alink.href=urlRemove;
                //alink.click(); 
            }
        return false;
     }
</script>

<xml id="toolbox" style="display: none">
    <category name="Cloudino" colour="0">
        <block type="cdinojs_print"></block>
        <block type="cdino_post"></block>
        <block type="cdinojs_on"></block>       
    </category>    
    <category id="catInputOutput" name="Input/Output" colour="250">    
        <block type="io_digitalwrite">      
            <value name="STATE">        
                <block type="io_highlow"></block>      
            </value>    
        </block>    
        <block type="io_digitalread"></block>    
        <block type="io_builtin_led">      
            <value name="STATE">        
                <block type="io_highlow"></block>      
            </value>    
        </block>    
        <block type="io_analogwrite"></block>    
        <block type="io_analogread"></block>    
        <block type="io_highlow"></block>  
<!--        
        <block type="io_pulsein">      
            <value name="PULSETYPE">        
                <shadow type="io_highlow"></shadow>      
            </value>    
        </block>    
        <block type="io_pulsetimeout">      
            <value name="PULSETYPE">        
                <shadow type="io_highlow"></shadow>      
            </value>      
            <value name="TIMEOUT">        
                <block type="math_number"></block>      
            </value>    
        </block>  
-->
    </category>  
<!--    
    <category name="Input/Output">
        <block type="inout_highlow"></block>
        <block type="inout_digital_write"></block>
        <block type="inout_digital_read"></block>
        <block type="inout_analog_write">
            <value name="NUM">
                <block type="math_number">
                    <field name="NUM">0</field>
                </block>
            </value>
        </block>
        <block type="inout_analog_read"></block>
    </category>  
-->
    <category name="Timer" colour="0">
        <block type="cdinojs_setinterval">
            <value name="time">
                <block type="math_number">
                    <field name="NUM">1000</field>
                </block>
            </value>            
        </block>
        <block type="cdinojs_settimeout">
            <value name="time">
                <block type="math_number">
                    <field name="NUM">1000</field>
                </block>
            </value>               
        </block>
        <block type="cdino_cleartimer"></block>         
    </category>    
    <category name="Logic" colour="210">
      <block type="controls_if"></block>
      <block type="logic_compare"></block>
      <block type="logic_operation"></block>
      <block type="logic_negate"></block>
      <block type="logic_boolean"></block>
      <block type="logic_null"></block>
      <block type="logic_ternary"></block>
    </category>
    <category name="Loops" colour="120">
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
    <category name="Math" colour="230">
      <block type="math_number"></block>
      <block type="parseint"></block> 
      <block type="unar_op">
        <value name="val">
          <block type="math_number">
            <field name="NUM">1</field>
          </block>
        </value>          
      </block> 
      <block type="math_arithmetic"></block>
      <!--<block type="math_single"></block>-->
      <!--<block type="math_trig"></block>-->
      <!--<block type="math_constant"></block>-->
      <block type="math_number_property"></block>
      <!--
      <block type="math_change">
        <value name="DELTA">
          <block type="math_number">
            <field name="NUM">1</field>
          </block>
        </value>
      </block>
      -->
      <!--
      <block type="math_on_list"></block>
      -->
      <block type="math_modulo"></block>
      <!-- TODO -->
      <!--
      <block type="math_round"></block>
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
      <block type="math_random_int">
        <value name="FROM">
          <block type="math_number">
            <field name="NUM">1</field>
          </block>
        </value>
        <value name="TO">
          <block type="math_number">
            <field name="NUM">100</field>
          </block>
        </value>
      </block>
      <block type="math_random_float"></block>
      -->
    </category>
    <category name="Text" colour="160">
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
            <field name="VAR" class="textVar">txt</field>
          </block>
        </value>
      </block>
      <block type="text_charAt">
        <value name="VALUE">
          <block type="variables_get">
            <field name="VAR" class="textVar">txt</field>
          </block>
        </value>
      </block>
      <block type="text_getSubstring">
        <value name="STRING">
          <block type="variables_get">
            <field name="VAR" class="textVar">txt</field>
          </block>
        </value>
      </block>
      <!--
      <block type="text_changeCase"></block>
      <block type="text_trim"></block>
      <block type="text_print"></block>
      <block type="text_prompt_ext">
        <value name="TEXT">
          <block type="text"></block>
        </value>
      </block>
      -->
    </category>
    <category name="Lists" colour="260">
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
      <!--
      <block type="lists_indexOf">
        <value name="VALUE">
          <block type="variables_get">
            <field name="VAR" class="listVar">arr</field>
          </block>
        </value>
      </block>
      -->
      <block type="lists_getIndex">
        <value name="VALUE">
          <block type="variables_get">
            <field name="VAR" class="listVar">arr</field>
          </block>
        </value>
      </block>
      <block type="lists_setIndex">
        <value name="LIST">
          <block type="variables_get">
            <field name="VAR" class="listVar">arr</field>
          </block>
        </value>
      </block>
      <!--
      <block type="lists_getSublist">
        <value name="LIST">
          <block type="variables_get">
            <field name="VAR" class="listVar">arr</field>
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
      -->
    </category>    
    <sep></sep>
    <category name="Variables" custom="VARIABLE" colour="330"></category>
    <category name="Functions" custom="PROCEDURE" colour="290">
        <block type="procedures_defnoreturn"></block>        
    </category>    
</xml>

<script>
    function codeSubmit()
    {
        var data = {ID: "<%=id%>", act: "update", script: Blockly.Cloudino.getBlockJSCode(), xml: Blockly.Cloudino.getXML()};
        loadContent('blockJS', "#tab2", data, function(){consoleLog.innerHTML="Block saved...";});
    }
</script>

<script>
    if(Blockly.Blocks['arduino_functions']!==undefined)
    {
        Blockly.Blocks['arduino_functions_']=Blockly.Blocks['arduino_functions'];
        Blockly.Blocks['arduino_functions']=undefined;
    }
        
    var blocklyDiv = document.getElementById('blocklyDiv');
    var workspace = Blockly.inject(blocklyDiv, {
        grid: false,
        zoom: {
            controls: true,
            wheel: false,
            startScale: 1.0,
            maxScale: 2,
            minScale: 0.2,
            scaleSpeed: 1.2
        },
        media: '/plugins/blockly/media/',
        toolbox: document.getElementById('toolbox')
    });
    
    Blockly.Arduino.Boards.changeBoard(workspace,"esp8266_cloudino");    
    //profile.default.analog=[["A0","A0"]];
    //profile.default.digital=[["1","1"],["2","2"],["3","3"],["4","4"],["5","5"],["6","6"],["7","7"],["8","8"],["9","9"],["10","10"],["11","11"],["12","12"],["13","13"],["14","14"],["15","15"],["16","16"],["A0","A0"]];

    <%if (xml != null) {%>
    Blockly.Cloudino.loadXML('<%=xml%>');
    <%}%>

    $('a[data-toggle="tab"]').on('shown.bs.tab', function(e) {
        //e.target // newly activated tab
        //e.relatedTarget // previous active tab
        //console.lo
        Blockly.resize();
        workspace.render();
        myCodeMirror.setValue(Blockly.Cloudino.getBlockJSCode());
        myCodeMirror.refresh();
        //console.log('shown.bs.tab', e);
    });
</script>
