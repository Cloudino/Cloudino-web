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
    String blockPath = workPath + engine.getScriptObject().get("config").getString("usersWorkPath") + "/" + user.getNumId() + "/arduino/blocks/" + id;

    File blockDir = new File(blockPath);
    if (blockPath.indexOf("..") > -1 || !blockDir.exists()) {
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
            FileOutputStream fout = new FileOutputStream(new File(blockDir, id + ".ino"));
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
        out.println("<script type=\"text/javascript\">Blockly.resize();loadContent('/panel/arduino?act=bl','#arduino');</script>");
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
    function removeBlock(alink) {
        if (confirm('Are you sure to remove this Block?')) {
            var urlRemove = 'block?ID=<%=id%>&act=remove';
            loadContent(urlRemove, "#main_content");
            //alink.href=urlRemove;
            //alink.click(); 
        }
        return false;
    }
</script>


<xml id="toolbox" style="display: none">
    <category name="Cloudino" colour="0">
        <block type="cdino_print"></block>
        <block type="cdino_post"></block>
        <block type="cdino_on"></block>
        <block type="cdino_setinterval">
            <value name="time">
                <block type="math_number">
                    <field name="NUM">1000</field>
                </block>
            </value>            
        </block>
        <block type="cdino_settimeout">
            <value name="time">
                <block type="math_number">
                    <field name="NUM">1000</field>
                </block>
            </value>               
        </block>
        <block type="cdino_cleartimer"></block> 
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
    </category>  
    <category id="catTime" name="Time" colour="140">    
        <block type="time_delay">      
            <value name="DELAY_TIME_MILI">        
                <block type="math_number">          
                    <field name="NUM">1000</field>        
                </block>      
            </value>    
        </block>    
        <block type="time_delaymicros">      
            <value name="DELAY_TIME_MICRO">        
                <block type="math_number">          
                    <field name="NUM">100</field>        
                </block>      
            </value>    
        </block>    
        <block type="time_millis"></block>    
        <block type="time_micros"></block>    
        <block type="infinite_loop"></block>  
    </category>      
    <category id="catLogic" name="Logic" colour="210">    
        <block type="controls_if"></block>    
        <block type="logic_compare"></block>    
        <block type="logic_operation"></block>    
        <block type="logic_negate"></block>    
        <block type="logic_boolean"></block>    
        <block type="logic_null"></block>    
        <block type="logic_ternary"></block>  
    </category>  
    <category id="catLoops" name="Loops" colour="120">    
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
        <block type="controls_flow_statements"></block>  
    </category>
    <category id="catMath" name="Math" colour="230">    
        <block type="math_number"></block>    
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
        <block type="base_map"></block>  
    </category>
    <category id="catText" name="Text" colour="160">    
        <block type="text"></block>    
        <block type="text_join"></block>    
        <block type="text_append">      
            <value name="TEXT">        
                <block type="text"></block>      
            </value>    
        </block>    
        <block type="text_length"></block>    
        <block type="text_isEmpty"></block>  
    </category>
    <sep></sep>
    <category id="catVariables" name="Variables" colour="330">    
        <block type="variables_get"></block>    
        <block type="variables_set"></block>    
        <block type="variables_set">      
            <value name="VALUE">        
                <block type="variables_set_type"></block>      
            </value>    
        </block>    
        <block type="variables_set_type"></block>  
    </category>
    <category id="catFunctions" name="Functions" custom="PROCEDURE" colour="290"></category>  
    <sep></sep>  
    <category id="catMusic" name="Music" colour="250">    
        <block type="io_tone">      
            <field name="TONEPIN">0</field>      
            <value name="FREQUENCY">        
                <shadow type="math_number">          
                    <field name="NUM">220</field>        
                </shadow>      
            </value>    
        </block>    
        <block type="io_notone"></block>  
    </category>  
    <category id="catMotors" name="Motors" colour="80">    
        <block type="servo_write">      
            <value name="SERVO_ANGLE">        
                <block type="math_number">          
                    <field name="NUM">90</field>        
                </block>      
            </value>    
        </block>    
        <block type="servo_read"></block>    
        <block type="stepper_config">      
            <field name="STEPPER_PIN1">1</field>      
            <field name="STEPPER_PIN2">2</field>      
            <value name="STEPPER_STEPS">        
                <block type="math_number">          
                    <field name="NUM">100</field>        
                </block>      
            </value>      
            <value name="STEPPER_SPEED">        
                <block type="math_number">          
                    <field name="NUM">10</field>        
                </block>      
            </value>    
        </block>    
        <block type="stepper_step">      
            <value name="STEPPER_STEPS">        
                <block type="math_number">          
                    <field name="NUM">10</field>        
                </block>      
            </value>    
        </block>  
    </category>  
    <sep></sep>  
    <category id="catComms" name="Comms" colour="170">    
<!--        
        <block type="serial_setup"></block>    
        <block type="serial_print"></block>    
        <block type="text_prompt_ext">      
            <value name="TEXT">        
                <block type="text"></block>      
            </value>    
        </block>    
-->
        <block type="spi_setup"></block>    
        <block type="spi_transfer"></block>    
        <block type="spi_transfer_return"></block>  
    </category>
</xml>

<!--
<xml id="toolbox" style="display: none">
    <category name="Cloudino" colour="0">
        <block type="cdino_print"></block>
        <block type="cdino_post"></block>
        <block type="cdino_on"></block>
    </category>    
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
        <block type="serial_print">
            <value name="CONTENT">
                <block type="text">
                    <field name="TEXT"></field>
                </block>
            </value>
        </block>
        <block type="inout_tone">
            <value name="NUM">
                <block type="math_number">
                    <field name="NUM">440</field>
                </block>
            </value>
        </block>
        <block type="inout_notone"></block>
        <block type="inout_buildin_led"></block>
    </category>    
    <category name="Timer">
        <block type="cdino_setinterval">
            <value name="time">
                <block type="math_number">
                    <field name="NUM">1000</field>
                </block>
            </value>            
        </block>
        <block type="cdino_settimeout">
            <value name="time">
                <block type="math_number">
                    <field name="NUM">1000</field>
                </block>
            </value>               
        </block>
        <block type="cdino_cleartimer"></block>         
    </category>     
    <category name="Logic" colour="230">
        <block type="controls_if"></block>
        <block type="logic_compare"></block>
        <block type="logic_operation"></block>
        <block type="logic_negate"></block>
        <block type="logic_null"></block>
    </category>
    <category name="Control">
        <block type="base_delay">
            <value name="DELAY_TIME">
                <block type="math_number">
                    <field name="NUM">1000</field>
                </block>
            </value>
        </block>
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
        </block>
        <block type="controls_whileUntil"></block>
    </category>
    <category name="Math">
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
        <block type="base_map">
            <value name="DMAX">
                <block type="math_number">
                    <field name="NUM">180</field>
                </block>
            </value>
        </block>
    </category>
    <category name="Text">
        <block type="text"></block>
        <block type="text_join"></block>
        <block type="text_append">
          <value name="TEXT">
            <block type="text"></block>
          </value>
        </block>
    </category>
    <category name="Variables" custom="VARIABLE"></category>
    <category name="Functions" custom="PROCEDURE"></category>
    <sep></sep>
    <category name="Servo">
        <block type="servo_move">
            <value name="DEGREE">
                <block type="math_number">
                    <field name="NUM">0</field>
                </block>
            </value>
        </block>
        <block type="servo_read_degrees"></block>
    </category>
    <category name="Grove">
        <category name="Grove Analog">
            <block type="grove_rotary_angle"></block>
            <block type="grove_temporature_sensor"></block>
            <block type="grove_sound_sensor"></block>
            <block type="grove_thumb_joystick"></block>
        </category>
        <category name="Grove DIgital">
            <block type="grove_led"></block>
            <block type="grove_button"></block>
            <block type="grove_relay"></block>
            <block type="grove_tilt_switch"></block>
            <block type="grove_piezo_buzzer"></block>
            <block type="grove_pir_motion_sensor"></block>
            <block type="grove_line_finder"></block>
            <block type="grove_rgb_led"></block>
            <block type="grove_ultrasonic_ranger"></block>
        </category>
        <category name="Grove LCD">
            <block type="grove_serial_lcd_print">
                <value name="TEXT">
                    <block type="text">
                        <field name="TEXT"></field>
                    </block>
                </value>
                <value name="TEXT2">
                    <block type="text">
                        <field name="TEXT"></field>
                    </block>
                </value>
                <value name="DELAY_TIME">
                    <block type="math_number">
                        <field name="NUM">1000</field>
                    </block>
                </value>
            </block>
            <block type="grove_serial_lcd_power"></block>
            <block type="grove_serial_lcd_effect"></block>
        </category>
        <category name="Grove Motor">
            <block type="grove_motor_shield"></block>
        </category>
    </category>
</xml>
-->

<script>
    function codeSubmit()
    {
        var data = {ID: "<%=id%>", act: "update", script: Blockly.Cloudino.getBlockCode(), xml: Blockly.Cloudino.getXML()};
        loadContent('block', "#tab2", data, function() {
            consoleLog.innerHTML = "Block saved...";
        });
    }
</script>

<script>
    if(Blockly.Blocks['arduino_functions']==undefined)
    {
        Blockly.Blocks['arduino_functions']=Blockly.Blocks['arduino_functions_'];
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
     
    Blockly.Arduino.Boards.changeBoard(workspace,"uno"); 
    //profile.default.analog = [["A0", "A0"], ["A1", "A1"], ["A2", "A2"], ["A3", "A3"], ["A4", "A4"], ["A5", "A5"], ["A6", "A6"], ["A7", "A7"]];
    //profile.default.digital = [["1", "1"], ["2", "2"], ["3", "3"], ["4", "4"], ["5", "5"], ["6", "6"], ["7", "7"], ["8", "8"], ["9", "9"], ["10", "10"], ["11", "11"], ["12", "12"], ["13", "13"], ["A0", "A0"], ["A1", "A1"], ["A2", "A2"], ["A3", "A3"], ["A4", "A4"], ["A5", "A5"], ["A6", "A6"], ["A7", "A7"]];

    <%if (xml != null) {%>
    Blockly.Cloudino.loadXML('<%=xml%>');
    <%}%>

    $('a[data-toggle="tab"]').on('shown.bs.tab', function(e) {
        //e.target // newly activated tab
        //e.relatedTarget // previous active tab
        //console.lo
        Blockly.resize();
        workspace.render();
        myCodeMirror.setValue(Blockly.Cloudino.getBlockCode());
        myCodeMirror.refresh();
        //console.log('shown.bs.tab', e);
    });
</script>
