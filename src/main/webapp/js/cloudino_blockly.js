/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

Blockly.Cloudino={
    getCloudRuleCode:function(){
        return "var _cdino_events=[];\n"+Blockly.JavaScript.workspaceToCode(workspace);
    },
    getBlockCode:function(){
        return Blockly.Arduino.workspaceToCode(workspace);
    },
    getXML:function(){
        var xml = Blockly.Xml.workspaceToDom(workspace);
        return Blockly.Xml.domToText(xml);        
    },
    loadXML:function(txt_xml)
    {
        var xml = Blockly.Xml.textToDom(txt_xml);
        Blockly.Xml.domToWorkspace(workspace, xml);
    }
};

/********************************************** CLOUDRULES **********************************************/

Blockly.Blocks['cdino_context'] = {
    init: function() {
        this.appendDummyInput()
                .appendField("Context")
                .appendField(new Blockly.FieldDropdown(getContexts), "context");
        this.appendStatementInput("EVENTS")
                .setCheck("Event")
                .appendField("events");
        this.setColour(160);
        this.setTooltip('');
        this.setHelpUrl('http://www.example.com/');
    }
};

Blockly.JavaScript['cdino_context'] = function(block) {
    var dropdown_context = block.getFieldValue('context');
    var statements_events = Blockly.JavaScript.statementToCode(block, 'EVENTS');
    // TODO: Assemble JavaScript into code variable.
    var code = '{ var _cdino_cntx="' + dropdown_context + '"; ' + statements_events + ' }';
    return code;
};

Blockly.Blocks['cdino_ondevice_message'] = {
    init: function() {
        this.appendDummyInput()
                .appendField("onMessage")
                .appendField("Device:")
                .appendField(new Blockly.FieldDropdown(getDevices), "device")
                //.appendField("Topic:")
                //.appendField(new Blockly.FieldTextInput("topic"), "topic")
                .appendField("with: topic,msg");
        this.appendStatementInput("ACTIONS")
                .setCheck("Action")
                .appendField("do");
        this.setPreviousStatement(true, "Event");
        this.setNextStatement(true, "Event");
        this.setColour(20);
        this.setTooltip('');
        this.setHelpUrl('http://www.example.com/');
        /**
         * Return all variables referenced by this block.
         * @return {!Array.<string>} List of variable names.
         * @this Blockly.Block
         */
        this.getVars = function() {
            //return [this.getFieldValue('msg')];
            return ["topic","msg"];
        };
    }
};

Blockly.JavaScript['cdino_ondevice_message'] = function(block) {
    var dropdown_device = block.getFieldValue('device');
    //var text_topic = block.getFieldValue('topic');
    var statements_actions = Blockly.JavaScript.statementToCode(block, 'ACTIONS');
    // TODO: Assemble JavaScript into code variable.
    var code='_cdino_events.push({context:_cdino_cntx,type:"cdino_ondevice_message",funct:function(topic,msg){'+statements_actions+'},params:{device:"'+dropdown_device+'"}});';
    return code;
};

Blockly.Blocks['cdino_onchange_context'] = {
    init: function() {
        this.appendDummyInput()
                .appendField("onChangeContext")
                .appendField(new Blockly.FieldDropdown([["Enter", "enter"], ["Exit", "exit"]]), "NAME");
        this.appendStatementInput("ACTIONS")
                .setCheck("Action")
                .appendField("do");
        this.setPreviousStatement(true, "Event");
        this.setNextStatement(true, "Event");
        this.setColour(20);
        this.setTooltip('');
        this.setHelpUrl('http://www.example.com/');
    }
};

Blockly.Blocks['cdino_send_device_message'] = {
    init: function() {
        this.appendDummyInput()
                .appendField("sendMessage");
        this.appendDummyInput()
                .setAlign(Blockly.ALIGN_RIGHT)
                .appendField("Device:")
                .appendField(new Blockly.FieldDropdown(getDevices), "device");
        this.appendDummyInput()
                .setAlign(Blockly.ALIGN_RIGHT)
                .appendField("Topic:")
                .appendField(new Blockly.FieldTextInput("topic"), "topic");
        this.appendValueInput("msg")
                .setCheck("String")
                .setAlign(Blockly.ALIGN_RIGHT)
                .appendField("Msg:");
        this.setInputsInline(true);
        this.setPreviousStatement(true, "Action");
        this.setNextStatement(true, "Action");
        this.setColour(330);
        this.setTooltip('');
        this.setHelpUrl('http://www.example.com/');
    }
};

Blockly.Blocks['cdino_invoke_after'] = {
    init: function() {
        this.appendDummyInput()
                .appendField("invoke after:")
                .appendField(new Blockly.FieldTextInput("10"), "time")
                .appendField(new Blockly.FieldDropdown([["seconds", "s"], ["minuts", "m"], ["hours", "h"], ["days", "d"]]), "metric");
        this.appendStatementInput("ACTIONS")
                .setCheck("Action")
                .appendField("do");
        this.setPreviousStatement(true, "Action");
        this.setColour(330);
        this.setTooltip('');
        this.setHelpUrl('http://www.example.com/');
    }
};

Blockly.Blocks['cduino_change_context'] = {
    init: function() {
        this.appendDummyInput()
                .appendField("changeContext")
                .appendField(new Blockly.FieldDropdown(getContexts), "NAME");
        this.setPreviousStatement(true, "Action");
        this.setColour(330);
        this.setTooltip('');
        this.setHelpUrl('http://www.example.com/');
    }
};

Blockly.Blocks['cdino_push_notification'] = {
    init: function() {
        this.appendValueInput("NAME")
                .setCheck("String")
                .appendField("pushNotification")
                .appendField("Text:");
        this.setInputsInline(true);
        this.setPreviousStatement(true, "Action");
        this.setNextStatement(true, "Action");
        this.setColour(330);
        this.setTooltip('');
        this.setHelpUrl('http://www.example.com/');
    }
};

/********************************************** UTILS **********************************************/

//Debug
Blockly.Blocks['cdino_debug'] = {
  init: function() {
    this.appendValueInput("NAME")
        .setCheck("String")
        .appendField("debug");
    this.setInputsInline(true);
    this.setPreviousStatement(true);
    this.setNextStatement(true);
    this.setColour(0);
    this.setTooltip('');
    this.setHelpUrl('http://www.example.com/');
  }
};

Blockly.JavaScript['cdino_debug'] = function(block) {
  var value_name = Blockly.JavaScript.valueToCode(block, 'NAME', Blockly.JavaScript.ORDER_ATOMIC);
  // TODO: Assemble JavaScript into code variable.
  var code = 'print('+value_name+');';
  return code;
};


//Math
Blockly.Blocks['cdino_parse_number'] = {
    init: function() {
        this.appendValueInput("NAME")
                .setCheck("String")
                .appendField("parseNumber");
        this.setInputsInline(true);
        this.setOutput(true, "Number");
        this.setColour(225);
        this.setTooltip('Convert Text to Number');
        this.setHelpUrl('http://www.example.com/');
    }
};

/********************************************** ARDUINO **********************************************/


Blockly.Blocks['cdino_print'] = {
  init: function() {
    this.appendValueInput("txt")
        .setCheck("String")
        .appendField("Print");
    this.setPreviousStatement(true);
    this.setNextStatement(true);
    this.setColour(0);
    this.setTooltip('');
    this.setHelpUrl('http://www.example.com/');
  }
};

Blockly.Arduino['cdino_print'] = function(block) {
  var value_txt = Blockly.Arduino.valueToCode(block, 'txt', Blockly.Arduino.ORDER_ATOMIC);
  // TODO: Assemble Arduino into code variable.
  Blockly.Arduino.definitions_['define_cduno'] = '#include<Cloudino.h>\n';
  Blockly.Arduino.definitions_['var_cduno'] = 'Cloudino cdino;\n';
  Blockly.Arduino.setups_['setup_cdino'] = 'cdino.begin();\n';
  var code = 'cdino.print('+value_txt+');\n';
  return code;
};

Blockly.Blocks['cdino_post'] = {
  init: function() {
    this.appendDummyInput()
        .appendField("postMessage");
    this.appendValueInput("topic")
        .setCheck("String")
        .appendField("topic");
    this.appendValueInput("msg")
        .setCheck("String")
        .appendField("msg");
    this.setInputsInline(true);
    this.setPreviousStatement(true);
    this.setNextStatement(true);
    this.setColour(0);
    this.setTooltip('');
    this.setHelpUrl('http://www.example.com/');
  }
};

Blockly.Arduino['cdino_post'] = function(block) {
  var value_topic = Blockly.Arduino.valueToCode(block, 'topic', Blockly.Arduino.ORDER_ATOMIC);
  var value_msg = Blockly.Arduino.valueToCode(block, 'msg', Blockly.Arduino.ORDER_ATOMIC);
  Blockly.Arduino.definitions_['define_cduno'] = '#include<Cloudino.h>\n';
  Blockly.Arduino.definitions_['var_cduno'] = 'Cloudino cdino;\n';
  Blockly.Arduino.setups_['setup_cdino'] = 'cdino.begin();\n';
  // TODO: Assemble Arduino into code variable.
  var code = 'cdino.post('+value_topic+','+value_msg+');\n';
  return code;
};

Blockly.Blocks['cdino_on'] = {
  init: function() {
    this.appendDummyInput()
        .appendField("onMessage")
        .appendField(new Blockly.FieldTextInput("name"), "name");
    this.appendValueInput("topic")
        .setCheck("String")
        .setAlign(Blockly.ALIGN_RIGHT)
        .appendField("topic");
    this.appendStatementInput("NAME")
        .appendField("do");
    this.setColour(0);
    this.setTooltip('');
    this.setHelpUrl('http://www.example.com/');
  }
};

Blockly.Arduino['cdino_on'] = function(block) {
  var text_name = block.getFieldValue('name');
  var value_topic = Blockly.Arduino.valueToCode(block, 'topic', Blockly.Arduino.ORDER_ATOMIC);
  var statements_name = Blockly.Arduino.statementToCode(block, 'NAME');
  Blockly.Arduino.definitions_['define_cduno'] = '#include<Cloudino.h>\n';
  Blockly.Arduino.definitions_['var_cduno'] = 'Cloudino cdino;\n';
   
  Blockly.Arduino.definitions_['define_cdino_event_'+text_name] = 'void led(String msg){\n'+statements_name+'}\n';  
   
  Blockly.Arduino.setups_['setup_cdino_'+text_name] = 'cdino.on('+value_topic+','+text_name+');\n';
  Blockly.Arduino.setups_['setup_cdino'] = 'cdino.begin();\n';
  // TODO: Assemble Arduino into code variable.
  var code = 'cdino.loop();\n';
  return code;
};

