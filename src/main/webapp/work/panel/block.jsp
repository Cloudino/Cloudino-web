<%-- 
    Document   : rule
    Created on : 15-oct-2015, 0:04:21
    Author     : javiersolis
--%>
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
    String id=request.getParameter("ID");
    DataObject user=(DataObject)session.getAttribute("_USER_");
    SWBScriptEngine engine = DataMgr.getUserScriptEngine("/cloudino.js", user);
    String act=request.getParameter("act");
    String xml=null;
    
    String workPath = DataMgr.getApplicationPath() + "/work/";
    String blockPath = workPath + engine.getScriptObject().get("config").getString("usersWorkPath") + "/" + user.getNumId() + "/blocks/"+id;
                        
    File blockDir=new File(blockPath);
    if(!blockDir.exists())
    {
        response.sendError(404);
        return;        
    }else
    {
        FileInputStream in=new FileInputStream(new File(blockDir,id+".xml"));
        xml=Utils.textInputStreamToString(in, "utf8");
    }
    
    if("update".equals(act))
    {        
        String script=request.getParameter("script");
        xml=request.getParameter("xml");
        try
        {
            FileOutputStream fout=new FileOutputStream(new File(blockDir,id+".ino"));
            fout.write(script.getBytes());
            fout.close();
            
            fout=new FileOutputStream(new File(blockDir,id+".xml"));
            fout.write(xml.getBytes());
            fout.close();            
        }catch(Exception e)
        {
            e.printStackTrace();
        }
    }
    //remove
    if("remove".equals(act))
    {
        //TODO:borrar directorio
        out.println("<script type=\"text/javascript\">loadContent('/panel/menu?act=bl','.main-sidebar');</script>");
%>
            <!-- Custom Tabs -->
            <div class="nav-tabs-custom">
                <div class="tab-content">
                    <div class="tab-pane active" id="tab_1">
                        <h3>Block deleted...</h3>
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
</div>

<xml id="toolbox" style="display: none">
    <category name="Logic">
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
        </category>
        <category name="Variables" custom="VARIABLE"></category>
        <category name="Functions" custom="PROCEDURE"></category>
        <sep></sep>
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
        <category name="Grove Analog">
            <block type="grove_rotary_angle"></block>
            <block type="grove_temporature_sensor"></block>
            <block type="grove_sound_sensor"></block>
            <block type="grove_thumb_joystick"></block>
        </category>
        <category name="Grove">
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
</xml>

<script>
    function codeSubmit()
    {
        var data = {ID:"<%=id%>",act:"update",script:Blockly.Cloudino.getBlockCode(),xml:Blockly.Cloudino.getXML()};
        loadContent('block', "#tab2",data);
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
        myCodeMirror.setValue(Blockly.Cloudino.getBlockCode());
        myCodeMirror.refresh();
        //console.log('shown.bs.tab', e);
    });
</script>
