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
    getBlockJSCode:function(){
        return Blockly.JavaScript.workspaceToCode(workspace);
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

Blockly.JavaScript['cdino_onchange_context'] = function(block) {
  var dropdown_action = block.getFieldValue('action');
  var statements_actions = Blockly.JavaScript.statementToCode(block, 'ACTIONS');
  var code='_cdino_events.push({context:_cdino_cntx,type:"cdino_onchange_context",funct:function(){'+statements_actions+'},params:{action:"'+dropdown_action+'"}});';
  return code;
};

Blockly.Blocks['cdino_ondevice_connection'] = {
  init: function() {
    this.appendDummyInput()
        .appendField("onDeviceConnection");
    this.appendDummyInput()
        .setAlign(Blockly.ALIGN_RIGHT)
        .appendField("Device:")
        .appendField(new Blockly.FieldDropdown(getDevices), "device");
    this.appendDummyInput()
        .setAlign(Blockly.ALIGN_RIGHT)
        .appendField("Action:")
        .appendField(new Blockly.FieldDropdown([["Connected", "connected"], ["Disconnected", "disconnected"]]), "action");
    this.appendStatementInput("ACTIONS")
        .setCheck("Action")
        .appendField("do");
    this.setInputsInline(true);
    this.setPreviousStatement(true, "Event");
    this.setNextStatement(true, "Event");
    this.setColour(20);
    this.setTooltip('');
    this.setHelpUrl('http://www.example.com/');
  }
};

Blockly.JavaScript['cdino_ondevice_connection'] = function(block) {
  var dropdown_device = block.getFieldValue('device');
  var dropdown_action = block.getFieldValue('action');
  var statements_actions = Blockly.JavaScript.statementToCode(block, 'ACTIONS');
  // TODO: Assemble JavaScript into code variable.
  var code='_cdino_events.push({context:_cdino_cntx,type:"cdino_ondevice_connection",funct:function(){'+statements_actions+'},params:{device:"'+dropdown_device+'",action:"'+dropdown_action+'"}});';
  return code;
};

Blockly.Blocks['cdino_send_device_message'] = {
  init: function() {
    this.appendDummyInput()
        .appendField("sendMessage");
    this.appendDummyInput()
        .setAlign(Blockly.ALIGN_RIGHT)
        .appendField("Device:")
        .appendField(new Blockly.FieldDropdown(getDevices), "device");
    this.appendValueInput("topic")
        .setCheck("String")
        .setAlign(Blockly.ALIGN_RIGHT)
        .appendField("Topic:");
    this.appendValueInput("msg")
        .setAlign(Blockly.ALIGN_RIGHT)
        .appendField("msg:");
    this.setInputsInline(true);
    this.setPreviousStatement(true,"Action");
    this.setNextStatement(true,"Action");
    this.setColour(330);
    this.setTooltip('');
    this.setHelpUrl('http://www.example.com/');
  }
};


Blockly.JavaScript['cdino_send_device_message'] = function(block) {
  var dropdown_device = block.getFieldValue('device');
  var value_topic = Blockly.JavaScript.valueToCode(block, 'topic', Blockly.JavaScript.ORDER_ATOMIC);
  var value_msg = Blockly.JavaScript.valueToCode(block, 'msg', Blockly.JavaScript.ORDER_ATOMIC);
  Blockly.JavaScript.definitions_["RuleUtils"] = 'var RuleUtils=Java.type("io.cloudino.rules.scriptengine.RuleUtils");';    
  var code = 'RuleUtils.sendMessage(\''+dropdown_device+'\','+value_topic+','+value_msg+');';
  return code;
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
    this.appendValueInput("title")
        .setCheck("String")
        .appendField("pushNotification")
        .appendField("Title:");
    this.appendValueInput("msg")
        .setCheck("String")
        .setAlign(Blockly.ALIGN_RIGHT)
        .appendField("Message:");
    this.setInputsInline(true);
    this.setPreviousStatement(true, "Action");
    this.setNextStatement(true, "Action");
    this.setColour(330);
    this.setTooltip('');
    this.setHelpUrl('http://www.example.com/');
  }
};

Blockly.JavaScript['cdino_push_notification'] = function(block) {
  var value_title = Blockly.JavaScript.valueToCode(block, 'title', Blockly.JavaScript.ORDER_ATOMIC);
  var value_msg = Blockly.JavaScript.valueToCode(block, 'msg', Blockly.JavaScript.ORDER_ATOMIC);
  Blockly.JavaScript.definitions_["RuleUtils"] = 'var RuleUtils=Java.type("io.cloudino.rules.scriptengine.RuleUtils");';    
  var code = 'RuleUtils.pushNotification(_cdino_user,'+value_title+','+value_msg+');';
  return code;
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
    this.setColour(330);
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

/********************************************** BLOCKS **********************************************/


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

Blockly.Blocks['cdino_setinterval'] = {
  init: function() {
    this.appendValueInput("time")
        .setCheck("Number")
        .setAlign(Blockly.ALIGN_RIGHT)
        .appendField("setInterval")
        .appendField(new Blockly.FieldTextInput("name"), "name")
        .appendField("time (ms)");
    this.appendDummyInput()
        .setAlign(Blockly.ALIGN_RIGHT)
        .appendField("with")
        .appendField(new Blockly.FieldVariable("timer"), "timer");
    this.appendStatementInput("NAME");
    this.setInputsInline(false);
    this.setPreviousStatement(true);
    this.setNextStatement(true);
    this.setColour(0);
    this.setTooltip('');
    this.getVars = function() {
            return [this.getFieldValue('timer')];
            //return ["msg"];
        };     
    this.setHelpUrl('http://www.example.com/');
  }
};

Blockly.Blocks['cdino_settimeout'] = {
  init: function() {
    this.appendValueInput("time")
        .setCheck("Number")
        .setAlign(Blockly.ALIGN_RIGHT)
        .appendField("setTimeout")
        .appendField(new Blockly.FieldTextInput("name"), "name")
        .appendField("time (ms)");
    this.appendDummyInput()
        .setAlign(Blockly.ALIGN_RIGHT)
        .appendField("with")
        .appendField(new Blockly.FieldVariable("timer"), "timer");
    this.appendStatementInput("NAME");
    this.setInputsInline(false);
    this.setPreviousStatement(true);
    this.setNextStatement(true);
    this.setColour(0);
    this.setTooltip('');
    this.getVars = function() {
            return [this.getFieldValue('timer')];
            //return ["msg"];
        };     
    this.setHelpUrl('http://www.example.com/');
  }
};

Blockly.Blocks['cdino_cleartimer'] = {
  init: function() {
    this.appendDummyInput()
        .appendField("clearTimer")
        .appendField(new Blockly.FieldVariable("timer"), "timer");
    this.setPreviousStatement(true);
    this.setNextStatement(true);
    this.setColour(0);
    this.setTooltip('');
    this.setHelpUrl('http://www.example.com/');
  }
};

Blockly.Blocks['parseint'] = {
  init: function() {
    this.appendValueInput("str")
        .setCheck("String")
        .appendField("parseNumber");
    this.setOutput(true, "Number");
    this.setColour(230);
    this.setTooltip('');
    this.setHelpUrl('http://www.example.com/');
  }
};

Blockly.Blocks['unar_op'] = {
  init: function() {
    this.appendValueInput("val")
        .setCheck("Number")
        .appendField(new Blockly.FieldVariable("item"), "NAME")
        .appendField(new Blockly.FieldDropdown([["+=", "+="], ["-=", "-="], ["/=", "/="], ["*=", "*="]]), "op");
    this.setPreviousStatement(true);
    this.setNextStatement(true);
    this.setColour(230);
    this.setTooltip('');
    this.setHelpUrl('http://www.example.com/');
  }
};

/********************************************** CDINOJS BLOCKS **********************************************/

Blockly.Blocks['cdinojs_print'] = {
  init: function() {
    this.appendValueInput("txt")
        //.setCheck("String")
        .appendField("Print");
    this.setPreviousStatement(true);
    this.setNextStatement(true);
    this.setColour(0);
    this.setTooltip('');
    this.setHelpUrl('http://www.example.com/');
  }
};

Blockly.Blocks['cdinojs_on'] = {
  init: function() {
    this.appendValueInput("topic")
        .setCheck("String")
        .setAlign(Blockly.ALIGN_RIGHT)
        .appendField("onMessage")
        .appendField("topic");
    this.appendDummyInput()
        .setAlign(Blockly.ALIGN_RIGHT)
        .appendField("with")
        .appendField(new Blockly.FieldVariable("msg"), "msg");
    this.appendStatementInput("NAME")
        .setAlign(Blockly.ALIGN_RIGHT);
    this.setInputsInline(false);
    this.setPreviousStatement(true);
    this.setNextStatement(true);    
    this.setColour(0);
    this.setTooltip('');
    this.getVars = function() {
            return [this.getFieldValue('msg')];
            //return ["msg"];
        };      
    this.setHelpUrl('http://www.example.com/');
  }
};

Blockly.Blocks['cdinojs_setinterval'] = {
  init: function() {
    this.appendValueInput("time")
        .setCheck("Number")
        .setAlign(Blockly.ALIGN_RIGHT)
        .appendField("setInterval")
        .appendField("time (ms)");
    this.appendDummyInput()
        .setAlign(Blockly.ALIGN_RIGHT)
        .appendField("with")
        .appendField(new Blockly.FieldVariable("timer"), "timer");
    this.appendStatementInput("NAME");
    this.setInputsInline(false);
    this.setPreviousStatement(true);
    this.setNextStatement(true);
    this.setColour(0);
    this.setTooltip('');
    this.getVars = function() {
            return [this.getFieldValue('timer')];
            //return ["msg"];
        };     
    this.setHelpUrl('http://www.example.com/');
  }
};

Blockly.Blocks['cdinojs_settimeout'] = {
  init: function() {
    this.appendValueInput("time")
        .setCheck("Number")
        .setAlign(Blockly.ALIGN_RIGHT)
        .appendField("setTimeout")
        .appendField("time (ms)");
    this.appendDummyInput()
        .setAlign(Blockly.ALIGN_RIGHT)
        .appendField("with")
        .appendField(new Blockly.FieldVariable("timer"), "timer");
    this.appendStatementInput("NAME");
    this.setInputsInline(false);
    this.setPreviousStatement(true);
    this.setNextStatement(true);
    this.setColour(0);
    this.setTooltip('');
    this.getVars = function() {
            return [this.getFieldValue('timer')];
            //return ["msg"];
        };     
    this.setHelpUrl('http://www.example.com/');
  }
};

Blockly.Blocks['text_charAt'] = {
  init: function() {
    this.WHERE_OPTIONS =
        [[Blockly.Msg.TEXT_CHARAT_FROM_START, 'FROM_START'],
         [Blockly.Msg.TEXT_CHARAT_FROM_END, 'FROM_END'],
         [Blockly.Msg.TEXT_CHARAT_FIRST, 'FIRST'],
         [Blockly.Msg.TEXT_CHARAT_LAST, 'LAST'],
        ];
    this.setHelpUrl(Blockly.Msg.TEXT_CHARAT_HELPURL);
    this.setColour(Blockly.Blocks.texts.HUE);
    this.setOutput(true, 'String');
    this.appendValueInput('VALUE')
        .setCheck('String')
        .appendField(Blockly.Msg.TEXT_CHARAT_INPUT_INTEXT);
    this.appendDummyInput('AT');
    this.setInputsInline(true);
    this.updateAt_(true);
    this.setTooltip(Blockly.Msg.TEXT_CHARAT_TOOLTIP);
  },
  /**
   * Create XML to represent whether there is an 'AT' input.
   * @return {!Element} XML storage element.
   * @this Blockly.Block
   */
  mutationToDom: function() {
    var container = document.createElement('mutation');
    var isAt = this.getInput('AT').type == Blockly.INPUT_VALUE;
    container.setAttribute('at', isAt);
    return container;
  },
  /**
   * Parse XML to restore the 'AT' input.
   * @param {!Element} xmlElement XML storage element.
   * @this Blockly.Block
   */
  domToMutation: function(xmlElement) {
    // Note: Until January 2013 this block did not have mutations,
    // so 'at' defaults to true.
    var isAt = (xmlElement.getAttribute('at') != 'false');
    this.updateAt_(isAt);
  },
  /**
   * Create or delete an input for the numeric index.
   * @param {boolean} isAt True if the input should exist.
   * @private
   * @this Blockly.Block
   */
  updateAt_: function(isAt) {
    // Destroy old 'AT' and 'ORDINAL' inputs.
    this.removeInput('AT');
    this.removeInput('ORDINAL', true);
    // Create either a value 'AT' input or a dummy input.
    if (isAt) {
      this.appendValueInput('AT').setCheck('Number');
      if (Blockly.Msg.ORDINAL_NUMBER_SUFFIX) {
        this.appendDummyInput('ORDINAL')
            .appendField(Blockly.Msg.ORDINAL_NUMBER_SUFFIX);
      }
    } else {
      this.appendDummyInput('AT');
    }
    if (Blockly.Msg.TEXT_CHARAT_TAIL) {
      this.removeInput('TAIL', true);
      this.appendDummyInput('TAIL')
          .appendField(Blockly.Msg.TEXT_CHARAT_TAIL);
    }
    var menu = new Blockly.FieldDropdown(this.WHERE_OPTIONS, function(value) {
      var newAt = (value == 'FROM_START') || (value == 'FROM_END');
      // The 'isAt' variable is available due to this function being a closure.
      if (newAt != isAt) {
        var block = this.sourceBlock_;
        block.updateAt_(newAt);
        // This menu has been destroyed and replaced.  Update the replacement.
        block.setFieldValue(value, 'WHERE');
        return null;
      }
      return undefined;
    });
    this.getInput('AT').appendField(menu, 'WHERE');
  }
};

Blockly.Blocks['lists_getIndex'] = {
  /**
   * Block for getting element at index.
   * @this Blockly.Block
   */
  init: function() {
    var MODE =
        [[Blockly.Msg.LISTS_GET_INDEX_GET, 'GET'],
         [Blockly.Msg.LISTS_GET_INDEX_REMOVE, 'REMOVE']];
    this.WHERE_OPTIONS =
        [[Blockly.Msg.LISTS_GET_INDEX_FROM_START, 'FROM_START'],
         [Blockly.Msg.LISTS_GET_INDEX_FROM_END, 'FROM_END'],
         [Blockly.Msg.LISTS_GET_INDEX_FIRST, 'FIRST'],
         [Blockly.Msg.LISTS_GET_INDEX_LAST, 'LAST']
        ];
    this.setHelpUrl(Blockly.Msg.LISTS_GET_INDEX_HELPURL);
    this.setColour(Blockly.Blocks.lists.HUE);
    var modeMenu = new Blockly.FieldDropdown(MODE, function(value) {
      var isStatement = (value == 'REMOVE');
      this.sourceBlock_.updateStatement_(isStatement);
    });
    this.appendValueInput('VALUE')
        .setCheck('Array')
        .appendField(Blockly.Msg.LISTS_GET_INDEX_INPUT_IN_LIST);
    this.appendDummyInput()
        .appendField(modeMenu, 'MODE')
        .appendField('', 'SPACE');
    this.appendDummyInput('AT');
    if (Blockly.Msg.LISTS_GET_INDEX_TAIL) {
      this.appendDummyInput('TAIL')
          .appendField(Blockly.Msg.LISTS_GET_INDEX_TAIL);
    }
    this.setInputsInline(true);
    this.setOutput(true);
    this.updateAt_(true);
    // Assign 'this' to a variable for use in the tooltip closure below.
    var thisBlock = this;
    this.setTooltip(function() {
      var combo = thisBlock.getFieldValue('MODE') + '_' +
          thisBlock.getFieldValue('WHERE');
      return Blockly.Msg['LISTS_GET_INDEX_TOOLTIP_' + combo];
    });
  },
  /**
   * Create XML to represent whether the block is a statement or a value.
   * Also represent whether there is an 'AT' input.
   * @return {Element} XML storage element.
   * @this Blockly.Block
   */
  mutationToDom: function() {
    var container = document.createElement('mutation');
    var isStatement = !this.outputConnection;
    container.setAttribute('statement', isStatement);
    var isAt = this.getInput('AT').type == Blockly.INPUT_VALUE;
    container.setAttribute('at', isAt);
    return container;
  },
  /**
   * Parse XML to restore the 'AT' input.
   * @param {!Element} xmlElement XML storage element.
   * @this Blockly.Block
   */
  domToMutation: function(xmlElement) {
    // Note: Until January 2013 this block did not have mutations,
    // so 'statement' defaults to false and 'at' defaults to true.
    var isStatement = (xmlElement.getAttribute('statement') == 'true');
    this.updateStatement_(isStatement);
    var isAt = (xmlElement.getAttribute('at') != 'false');
    this.updateAt_(isAt);
  },
  /**
   * Switch between a value block and a statement block.
   * @param {boolean} newStatement True if the block should be a statement.
   *     False if the block should be a value.
   * @private
   * @this Blockly.Block
   */
  updateStatement_: function(newStatement) {
    var oldStatement = !this.outputConnection;
    if (newStatement != oldStatement) {
      this.unplug(true, true);
      if (newStatement) {
        this.setOutput(false);
        this.setPreviousStatement(true);
        this.setNextStatement(true);
      } else {
        this.setPreviousStatement(false);
        this.setNextStatement(false);
        this.setOutput(true);
      }
    }
  },
  /**
   * Create or delete an input for the numeric index.
   * @param {boolean} isAt True if the input should exist.
   * @private
   * @this Blockly.Block
   */
  updateAt_: function(isAt) {
    // Destroy old 'AT' and 'ORDINAL' inputs.
    this.removeInput('AT');
    this.removeInput('ORDINAL', true);
    // Create either a value 'AT' input or a dummy input.
    if (isAt) {
      this.appendValueInput('AT').setCheck('Number');
      if (Blockly.Msg.ORDINAL_NUMBER_SUFFIX) {
        this.appendDummyInput('ORDINAL')
            .appendField(Blockly.Msg.ORDINAL_NUMBER_SUFFIX);
      }
    } else {
      this.appendDummyInput('AT');
    }
    var menu = new Blockly.FieldDropdown(this.WHERE_OPTIONS, function(value) {
      var newAt = (value == 'FROM_START') || (value == 'FROM_END');
      // The 'isAt' variable is available due to this function being a closure.
      if (newAt != isAt) {
        var block = this.sourceBlock_;
        block.updateAt_(newAt);
        // This menu has been destroyed and replaced.  Update the replacement.
        block.setFieldValue(value, 'WHERE');
        return null;
      }
      return undefined;
    });
    this.getInput('AT').appendField(menu, 'WHERE');
    if (Blockly.Msg.LISTS_GET_INDEX_TAIL) {
      this.moveInputBefore('TAIL', null);
    }
  }
};

Blockly.Blocks['lists_setIndex'] = {
  /**
   * Block for setting the element at index.
   * @this Blockly.Block
   */
  init: function() {
    var MODE =
        [[Blockly.Msg.LISTS_SET_INDEX_SET, 'SET']
         //[Blockly.Msg.LISTS_SET_INDEX_INSERT, 'INSERT']
        ];
    this.WHERE_OPTIONS =
        [[Blockly.Msg.LISTS_GET_INDEX_FROM_START, 'FROM_START'],
         [Blockly.Msg.LISTS_GET_INDEX_FROM_END, 'FROM_END'],
         [Blockly.Msg.LISTS_GET_INDEX_FIRST, 'FIRST'],
         [Blockly.Msg.LISTS_GET_INDEX_LAST, 'LAST']
        ];
    this.setHelpUrl(Blockly.Msg.LISTS_SET_INDEX_HELPURL);
    this.setColour(Blockly.Blocks.lists.HUE);
    this.appendValueInput('LIST')
        .setCheck('Array')
        .appendField(Blockly.Msg.LISTS_SET_INDEX_INPUT_IN_LIST);
    this.appendDummyInput()
        .appendField(new Blockly.FieldDropdown(MODE), 'MODE')
        .appendField('', 'SPACE');
    this.appendDummyInput('AT');
    this.appendValueInput('TO')
        .appendField(Blockly.Msg.LISTS_SET_INDEX_INPUT_TO);
    this.setInputsInline(true);
    this.setPreviousStatement(true);
    this.setNextStatement(true);
    this.setTooltip(Blockly.Msg.LISTS_SET_INDEX_TOOLTIP);
    this.updateAt_(true);
    // Assign 'this' to a variable for use in the tooltip closure below.
    var thisBlock = this;
    this.setTooltip(function() {
      var combo = thisBlock.getFieldValue('MODE') + '_' +
          thisBlock.getFieldValue('WHERE');
      return Blockly.Msg['LISTS_SET_INDEX_TOOLTIP_' + combo];
    });
  },
  /**
   * Create XML to represent whether there is an 'AT' input.
   * @return {Element} XML storage element.
   * @this Blockly.Block
   */
  mutationToDom: function() {
    var container = document.createElement('mutation');
    var isAt = this.getInput('AT').type == Blockly.INPUT_VALUE;
    container.setAttribute('at', isAt);
    return container;
  },
  /**
   * Parse XML to restore the 'AT' input.
   * @param {!Element} xmlElement XML storage element.
   * @this Blockly.Block
   */
  domToMutation: function(xmlElement) {
    // Note: Until January 2013 this block did not have mutations,
    // so 'at' defaults to true.
    var isAt = (xmlElement.getAttribute('at') != 'false');
    this.updateAt_(isAt);
  },
  /**
   * Create or delete an input for the numeric index.
   * @param {boolean} isAt True if the input should exist.
   * @private
   * @this Blockly.Block
   */
  updateAt_: function(isAt) {
    // Destroy old 'AT' and 'ORDINAL' input.
    this.removeInput('AT');
    this.removeInput('ORDINAL', true);
    // Create either a value 'AT' input or a dummy input.
    if (isAt) {
      this.appendValueInput('AT').setCheck('Number');
      if (Blockly.Msg.ORDINAL_NUMBER_SUFFIX) {
        this.appendDummyInput('ORDINAL')
            .appendField(Blockly.Msg.ORDINAL_NUMBER_SUFFIX);
      }
    } else {
      this.appendDummyInput('AT');
    }
    var menu = new Blockly.FieldDropdown(this.WHERE_OPTIONS, function(value) {
      var newAt = (value == 'FROM_START') || (value == 'FROM_END');
      // The 'isAt' variable is available due to this function being a closure.
      if (newAt != isAt) {
        var block = this.sourceBlock_;
        block.updateAt_(newAt);
        // This menu has been destroyed and replaced.  Update the replacement.
        block.setFieldValue(value, 'WHERE');
        return null;
      }
      return undefined;
    });
    this.moveInputBefore('AT', 'TO');
    if (this.getInput('ORDINAL')) {
      this.moveInputBefore('ORDINAL', 'TO');
    }

    this.getInput('AT').appendField(menu, 'WHERE');
  }
};

/********************************************** ARDUINO **********************************************/
Blockly.Arduino['cdino_print'] = function(block) {
  var value_txt = Blockly.Arduino.valueToCode(block, 'txt', Blockly.Arduino.ORDER_ATOMIC);
  // TODO: Assemble Arduino into code variable.
  Blockly.Arduino.definitions_['define_cdino'] = '#include<Cloudino.h>\n';
  Blockly.Arduino.definitions_['var_cdino'] = 'Cloudino cdino;\n';
  Blockly.Arduino.setups_['setup_cdino'] = 'cdino.begin();\n';
  var code = 'cdino.print('+value_txt+');\n';
  return code;
};

Blockly.Arduino['cdino_post'] = function(block) {
  var value_topic = Blockly.Arduino.valueToCode(block, 'topic', Blockly.Arduino.ORDER_ATOMIC);
  var value_msg = Blockly.Arduino.valueToCode(block, 'msg', Blockly.Arduino.ORDER_ATOMIC);
  Blockly.Arduino.definitions_['define_cdino'] = '#include<Cloudino.h>\n';
  Blockly.Arduino.definitions_['var_cdino'] = 'Cloudino cdino;\n';
  Blockly.Arduino.setups_['setup_cdino'] = 'cdino.begin();\n';
  // TODO: Assemble Arduino into code variable.
  var code = 'cdino.post('+value_topic+','+value_msg+');\n';
  return code;
};

Blockly.Arduino['cdino_on'] = function(block) {
  var text_name = block.getFieldValue('name');
  var value_topic = Blockly.Arduino.valueToCode(block, 'topic', Blockly.Arduino.ORDER_ATOMIC);
  var statements_name = Blockly.Arduino.statementToCode(block, 'NAME');
  Blockly.Arduino.definitions_['define_cdino'] = '#include<Cloudino.h>\n';
  Blockly.Arduino.definitions_['var_cdino'] = 'Cloudino cdino;\n';
   
  Blockly.Arduino.definitions_['define_cdino_event_'+text_name] = 'void '+text_name+'(String msg){\n'+statements_name+'}\n';  
   
  Blockly.Arduino.setups_['setup_cdino_'+text_name] = 'cdino.on('+value_topic+','+text_name+');\n';
  Blockly.Arduino.setups_['setup_cdino'] = 'cdino.begin();\n';
  
  Blockly.Arduino.loops_['loop_cdino'] = 'cdino.loop();\n';
  // TODO: Assemble Arduino into code variable.
  var code = '';
  return code;
};

Blockly.Arduino['cdino_setinterval'] = function(block) {
  var text_name = block.getFieldValue('name');
  var value_time = Blockly.Arduino.valueToCode(block, 'time', Blockly.Arduino.ORDER_ATOMIC);
  var variable_timer = Blockly.Arduino.variableDB_.getName(block.getFieldValue('timer'), Blockly.Variables.NAME_TYPE);
  var statements_name = Blockly.Arduino.statementToCode(block, 'NAME');
  
  Blockly.Arduino.definitions_['define_cdino'] = '#include<Cloudino.h>\n';
  Blockly.Arduino.definitions_['var_cdino'] = 'Cloudino cdino;\n';   
  Blockly.Arduino.definitions_['define_cdino_event_'+text_name] = 'void '+text_name+'(){\n'+statements_name+'}\n';  
  
  Blockly.Arduino.setups_['setup_cdino_'+text_name] = variable_timer+'=cdino.setInterval('+value_time+','+text_name+');\n';
  Blockly.Arduino.setups_['setup_cdino'] = 'cdino.begin();\n';
  
  Blockly.Arduino.loops_['loop_cdino'] = 'cdino.loop();\n';
  // TODO: Assemble Arduino into code variable.
  var code = '';  
  
  return code;
};

Blockly.Arduino['cdino_settimeout'] = function(block) {
  var text_name = block.getFieldValue('name');
  var value_time = Blockly.Arduino.valueToCode(block, 'time', Blockly.Arduino.ORDER_ATOMIC);
  var variable_timer = Blockly.Arduino.variableDB_.getName(block.getFieldValue('timer'), Blockly.Variables.NAME_TYPE);
  var statements_name = Blockly.Arduino.statementToCode(block, 'NAME');
  Blockly.Arduino.definitions_['define_cdino'] = '#include<Cloudino.h>\n';
  Blockly.Arduino.definitions_['var_cdino'] = 'Cloudino cdino;\n';   
  Blockly.Arduino.definitions_['define_cdino_event_'+text_name] = 'void '+text_name+'(){\n'+statements_name+'}\n';  
  
  Blockly.Arduino.setups_['setup_cdino_'+text_name] = variable_timer+'=cdino.setTimeout('+value_time+','+text_name+');\n';
  Blockly.Arduino.setups_['setup_cdino'] = 'cdino.begin();\n';
  
  Blockly.Arduino.loops_['loop_cdino'] = 'cdino.loop();\n';
  // TODO: Assemble Arduino into code variable.
  var code = '';  
  return code;
};

Blockly.Arduino['cdino_cleartimer'] = function(block) {
  var variable_timer = Blockly.Arduino.variableDB_.getName(block.getFieldValue('timer'), Blockly.Variables.NAME_TYPE);
  Blockly.Arduino.definitions_['Timer'] = "require(\"Timer\");"; 
  var code = 'clearInterval('+variable_timer+');\n';
  return code;
};

Blockly.Arduino['text_join'] = function(block) {
  // Create a string made up of any number of elements of any type.
  var code;
  if (block.itemCount_ == 0) {
    return ['\'\'', Blockly.Arduino.ORDER_ATOMIC];
  } else {
    code = "";
    for (var n = 0; n < block.itemCount_; n++) {
      code+="+"+"String("+(Blockly.Arduino.valueToCode(block, 'ADD' + n, Blockly.Arduino.ORDER_COMMA) || '\'\'')+")";
    }
    if(code.length>0)code=code.substr(1);
    return [code, Blockly.Arduino.ORDER_ATOMIC];
  }
};

Blockly.Arduino['text_append'] = function(block) {
  // Append to a variable in place.
  var varName = Blockly.Arduino.variableDB_.getName(
      block.getFieldValue('VAR'), Blockly.Variables.NAME_TYPE);
  var argument0 = Blockly.Arduino.valueToCode(block, 'TEXT',
      Blockly.Arduino.ORDER_NONE) || '\'\'';
  return varName + ' = ' + varName + ' + String(' + argument0 + ');\n';
};

Blockly.Arduino['parseint'] = function(block) {
  var value_str = Blockly.Arduino.valueToCode(block, 'str', Blockly.Arduino.ORDER_ATOMIC);
  // TODO: Assemble JavaScript into code variable.
  var code = 'String('+value_str+').toInt()';
  // TODO: Change ORDER_NONE to the correct strength.
  return [code, Blockly.Arduino.ORDER_FUNCTION_CALL];
};

Blockly.Arduino['unar_op'] = function(block) {
  var variable_name = Blockly.Arduino.variableDB_.getName(block.getFieldValue('NAME'), Blockly.Variables.NAME_TYPE);
  var dropdown_op = block.getFieldValue('op');
  var value_val = Blockly.Arduino.valueToCode(block, 'val', Blockly.Arduino.ORDER_ATOMIC);
  // TODO: Assemble JavaScript into code variable.
  var code = variable_name+dropdown_op+value_val+";\n";
  return code;
};

/********************************************** JAVASCRIPT **********************************************/


Blockly.JavaScript['cdinojs_print'] = function(block) {
    
  //var argument0 = Blockly.Arduino.valueToCode(block, 'txt', Blockly.Arduino.ORDER_ATOMIC);
  var argument0 = Blockly.JavaScript.valueToCode(block, 'txt', Blockly.JavaScript.ORDER_NONE) || '\'\'';
  Blockly.JavaScript.definitions_["Cloudino"] = "require(\"Cloudino\");";    
  return 'Cloudino.print(' + argument0 + ');\n';
};

Blockly.JavaScript['cdino_post'] = function(block) {
  var value_topic = Blockly.JavaScript.valueToCode(block, 'topic', Blockly.JavaScript.ORDER_ATOMIC);
  var value_msg = Blockly.JavaScript.valueToCode(block, 'msg', Blockly.JavaScript.ORDER_ATOMIC);
  Blockly.JavaScript.definitions_["Cloudino"] = "require(\"Cloudino\");"; 
  // TODO: Assemble Arduino into code variable.
  var code = 'Cloudino.post('+value_topic+','+value_msg+');\n';
  return code;
};

Blockly.JavaScript['cdinojs_on'] = function(block) {
  var value_topic = Blockly.JavaScript.valueToCode(block, 'topic', Blockly.JavaScript.ORDER_ATOMIC);
  var variable_msg = Blockly.JavaScript.variableDB_.getName(block.getFieldValue('msg'), Blockly.Variables.NAME_TYPE);
  var statements_name = Blockly.JavaScript.statementToCode(block, 'NAME');
  Blockly.JavaScript.definitions_['Cloudino'] = "require(\"Cloudino\");"; 
  var code = 'Cloudino.on('+value_topic+',function('+variable_msg+'){\n'+statements_name+'});\n';
  return code;
};

Blockly.JavaScript.inout_highlow = function() {
  // Boolean values HIGH and LOW.  
  Blockly.JavaScript.definitions_['GPIO'] = "require(\"GPIO\");"; 
  var code = (this.getFieldValue('BOOL') == 'HIGH') ? 'HIGH' : 'LOW';
  return [code, Blockly.JavaScript.ORDER_ATOMIC];
};

Blockly.JavaScript.inout_digital_write = function() {
  var dropdown_pin = this.getFieldValue('PIN');
  var dropdown_stat = this.getFieldValue('STAT');
  Blockly.JavaScript.definitions_['GPIO'] = "require(\"GPIO\");"; 
  Blockly.JavaScript.definitions_['setup_output_' + dropdown_pin] = 'pinMode(' + dropdown_pin + ', OUTPUT);';
  var code = 'digitalWrite(' + dropdown_pin + ', ' + dropdown_stat + ');\n'
  return code;
};

Blockly.JavaScript.inout_digital_read = function() {
  var dropdown_pin = this.getFieldValue('PIN');
  Blockly.JavaScript.definitions_['GPIO'] = "require(\"GPIO\");"; 
  Blockly.JavaScript.definitions_['setup_input_' + dropdown_pin] = 'pinMode(' + dropdown_pin + ', INPUT);';
  var code = 'digitalRead(' + dropdown_pin + ')';
  return [code, Blockly.JavaScript.ORDER_ATOMIC];
};

Blockly.JavaScript.inout_analog_write = function() {
  var dropdown_pin = this.getFieldValue('PIN');
  //var dropdown_stat = this.getFieldValue('STAT');
  Blockly.JavaScript.definitions_['GPIO'] = "require(\"GPIO\");"; 
  var value_num = Blockly.JavaScript.valueToCode(this, 'NUM', Blockly.JavaScript.ORDER_ATOMIC);
  //Blockly.Arduino.setups_['setup_output'+dropdown_pin] = 'pinMode('+dropdown_pin+', OUTPUT);';
  var code = 'analogWrite(' + dropdown_pin + ', ' + value_num + ');\n';
  return code;
};

Blockly.JavaScript.inout_analog_read = function() {
  var dropdown_pin = this.getFieldValue('PIN');
  //Blockly.Arduino.setups_['setup_input_'+dropdown_pin] = 'pinMode('+dropdown_pin+', INPUT);';
  Blockly.JavaScript.definitions_['GPIO'] = "require(\"GPIO\");"; 
  var code = 'analogRead(' + dropdown_pin + ')';
  return [code, Blockly.JavaScript.ORDER_ATOMIC];
};

Blockly.JavaScript['cdinojs_setinterval'] = function(block) {
  var value_time = Blockly.JavaScript.valueToCode(block, 'time', Blockly.JavaScript.ORDER_ATOMIC);
  var variable_timer = Blockly.JavaScript.variableDB_.getName(block.getFieldValue('timer'), Blockly.Variables.NAME_TYPE);
  var statements_name = Blockly.JavaScript.statementToCode(block, 'NAME');
  Blockly.JavaScript.definitions_['Timer'] = "require(\"Timer\");"; 
  var code = variable_timer+'=setInterval(function(){\n'+statements_name+'},'+value_time+');\n';
  return code;
};

Blockly.JavaScript['cdinojs_settimeout'] = function(block) {
  var value_time = Blockly.JavaScript.valueToCode(block, 'time', Blockly.JavaScript.ORDER_ATOMIC);
  var variable_timer = Blockly.JavaScript.variableDB_.getName(block.getFieldValue('timer'), Blockly.Variables.NAME_TYPE);
  var statements_name = Blockly.JavaScript.statementToCode(block, 'NAME');
  Blockly.JavaScript.definitions_['Timer'] = "require(\"Timer\");"; 
  var code = variable_timer+'=setTimeout(function(){\n'+statements_name+'},'+value_time+');\n';
  return code;
};

Blockly.JavaScript['cdino_cleartimer'] = function(block) {
  var variable_timer = Blockly.JavaScript.variableDB_.getName(block.getFieldValue('timer'), Blockly.Variables.NAME_TYPE);
  Blockly.JavaScript.definitions_['Timer'] = "require(\"Timer\");"; 
  var code = 'clearInterval('+variable_timer+');\n';
  return code;
};

Blockly.JavaScript['text_join'] = function(block) {
  // Create a string made up of any number of elements of any type.
  var code;
  if (block.itemCount_ == 0) {
    return ['\'\'', Blockly.JavaScript.ORDER_ATOMIC];
  } else {
    code = "";
    for (var n = 0; n < block.itemCount_; n++) {
      code+="+"+Blockly.JavaScript.valueToCode(block, 'ADD' + n, Blockly.JavaScript.ORDER_COMMA) || '\'\'';
    }
    if(code.length>0)code=code.substr(1);
    return [code, Blockly.JavaScript.ORDER_ATOMIC];
  }
};

Blockly.JavaScript['text_append'] = function(block) {
  // Append to a variable in place.
  var varName = Blockly.JavaScript.variableDB_.getName(
      block.getFieldValue('VAR'), Blockly.Variables.NAME_TYPE);
  var argument0 = Blockly.JavaScript.valueToCode(block, 'TEXT',
      Blockly.JavaScript.ORDER_NONE) || '\'\'';
  return varName + ' = ' + varName + ' + ' + argument0 + ';\n';
};

Blockly.JavaScript['text_indexOf'] = function(block) {
  // Search the text for a substring.
  var operator = block.getFieldValue('END') == 'FIRST' ?
      'indexOf' : 'lastIndexOf';
  var argument0 = Blockly.JavaScript.valueToCode(block, 'FIND',
      Blockly.JavaScript.ORDER_NONE) || '\'\'';
  var argument1 = Blockly.JavaScript.valueToCode(block, 'VALUE',
      Blockly.JavaScript.ORDER_MEMBER) || '\'\'';
  Blockly.JavaScript.definitions_['String'] = "require(\"String\");"; 
  var code = argument1 + '.' + operator + '(' + argument0 + ') + 1';
  return [code, Blockly.JavaScript.ORDER_MEMBER];
};

Blockly.JavaScript['text_charAt'] = function(block) {
  // Get letter at index.
  // Note: Until January 2013 this block did not have the WHERE input.
  var where = block.getFieldValue('WHERE') || 'FROM_START';
  var at = Blockly.JavaScript.valueToCode(block, 'AT',
      Blockly.JavaScript.ORDER_UNARY_NEGATION) || '1';
  var text = Blockly.JavaScript.valueToCode(block, 'VALUE',
      Blockly.JavaScript.ORDER_MEMBER) || '\'\'';
  Blockly.JavaScript.definitions_['String'] = "require(\"String\");"; 
  switch (where) {
    case 'FIRST':
      var code = text + '.charAt(0)';
      return [code, Blockly.JavaScript.ORDER_FUNCTION_CALL];
    case 'LAST':
      var code = text + '.charAt('+text+'.length-1)';
      return [code, Blockly.JavaScript.ORDER_FUNCTION_CALL];
    case 'FROM_START':
      // Blockly uses one-based indicies.
      if (Blockly.isNumber(at)) {
        // If the index is a naked number, decrement it right now.
        at = parseFloat(at) - 1;
      } else {
        // If the index is dynamic, decrement it in code.
        at += ' - 1';
      }
      var code = text + '.charAt(' + at + ')';
      return [code, Blockly.JavaScript.ORDER_FUNCTION_CALL];
    case 'FROM_END':
      var code = text + '.charAt('+text+'.length-' + at + ')';
      return [code, Blockly.JavaScript.ORDER_FUNCTION_CALL];
  }
  throw 'Unhandled option (text_charAt).';
};

Blockly.JavaScript['text_getSubstring'] = function(block) {
  // Get substring.
  var text = Blockly.JavaScript.valueToCode(block, 'STRING',
      Blockly.JavaScript.ORDER_MEMBER) || '\'\'';
  var where1 = block.getFieldValue('WHERE1');
  var where2 = block.getFieldValue('WHERE2');
  var at1 = Blockly.JavaScript.valueToCode(block, 'AT1',
      Blockly.JavaScript.ORDER_NONE) || '1';
  var at2 = Blockly.JavaScript.valueToCode(block, 'AT2',
      Blockly.JavaScript.ORDER_NONE) || '1';
  Blockly.JavaScript.definitions_['String'] = "require(\"String\");"; 
  
  var code;
  
  if (where1 == 'FIRST' && where2 == 'LAST') {
      code = text;
  } else {
      function getAt(where, at) 
      {
          if (where == 'FROM_START') {
            at--;
          } else if (where == 'FROM_END') {
            at = text+'.length - '+at;
          } else if (where == 'FIRST') {
            at = 0;
          } else if (where == 'LAST') {
            at = text+'.length';
          } 
          return at;
      }
      at1 = getAt(where1, at1);      
      at2 = getAt(where2, at2);
      
      if(where2=="FROM_END")at2+="+1";
      if(where2=="FROM_START")at2++;
      code = text + '.substring('+at1 + ',' + at2 + ')';
  }
  return [code, Blockly.JavaScript.ORDER_FUNCTION_CALL];
};

Blockly.JavaScript['lists_getIndex'] = function(block) {
  // Get element at index.
  // Note: Until January 2013 this block did not have MODE or WHERE inputs.
  var mode = block.getFieldValue('MODE') || 'GET';
  var where = block.getFieldValue('WHERE') || 'FROM_START';
  var at = Blockly.JavaScript.valueToCode(block, 'AT',
      Blockly.JavaScript.ORDER_UNARY_NEGATION) || '1';
  var list = Blockly.JavaScript.valueToCode(block, 'VALUE',
      Blockly.JavaScript.ORDER_MEMBER) || '[]';

  if (where == 'FIRST') {
    if (mode == 'GET') {
      var code = list + '[0]';
      return [code, Blockly.JavaScript.ORDER_MEMBER];
    } else if (mode == 'REMOVE') {
      return list + '.remove('+list+'[0]);\n';
    }
  } else if (where == 'LAST') {
    if (mode == 'GET') {
      var code = list + '['+list+'.length-1]';
      return [code, Blockly.JavaScript.ORDER_MEMBER];
    } else if (mode == 'REMOVE') {
//      return list + '.pop();\n';
        return list + '.remove('+list+'['+list+'.length-1]);\n';
    }
  } else if (where == 'FROM_START') {
    // Blockly uses one-based indicies.
    if (Blockly.isNumber(at)) {
      // If the index is a naked number, decrement it right now.
      at = parseFloat(at) - 1;
    } else {
      // If the index is dynamic, decrement it in code.
      at += ' - 1';
    }
    if (mode == 'GET') {
      var code = list + '[' + at + ']';
      return [code, Blockly.JavaScript.ORDER_MEMBER];
    } else if (mode == 'REMOVE') {
        return list + '.remove('+list+'['+at+'-1]);\n';
    }
  } else if (where == 'FROM_END') {
    if (mode == 'GET') {
      var code = list + '['+list+'.length - '+at+']';   
      return [code, Blockly.JavaScript.ORDER_FUNCTION_CALL];
    } else if (mode == 'REMOVE') {
      return list + '.remove('+list + '['+list+'.length - '+at+']);\n';
    }
  }
  throw 'Unhandled combination (lists_getIndex).';
};

Blockly.JavaScript['lists_setIndex'] = function(block) {
  // Set element at index.
  // Note: Until February 2013 this block did not have MODE or WHERE inputs.
  var list = Blockly.JavaScript.valueToCode(block, 'LIST',
      Blockly.JavaScript.ORDER_MEMBER) || '[]';
  var mode = block.getFieldValue('MODE') || 'GET';
  var where = block.getFieldValue('WHERE') || 'FROM_START';
  var at = Blockly.JavaScript.valueToCode(block, 'AT',
      Blockly.JavaScript.ORDER_NONE) || '1';
  var value = Blockly.JavaScript.valueToCode(block, 'TO',
      Blockly.JavaScript.ORDER_ASSIGNMENT) || 'null';
  // Cache non-trivial values to variables to prevent repeated look-ups.
  // Closure, which accesses and modifies 'list'.
  function cacheList() {
    if (list.match(/^\w+$/)) {
      return '';
    }
    var listVar = Blockly.JavaScript.variableDB_.getDistinctName(
        'tmp_list', Blockly.Variables.NAME_TYPE);
    var code = 'var ' + listVar + ' = ' + list + ';\n';
    list = listVar;
    return code;
  }
  if (where == 'FIRST') {
    if (mode == 'SET') {
      return list + '[0] = ' + value + ';\n';
    }
  } else if (where == 'LAST') {
    if (mode == 'SET') {
      var code = cacheList();
      code += list + '[' + list + '.length - 1] = ' + value + ';\n';
      return code;
    }
  } else if (where == 'FROM_START') {
    // Blockly uses one-based indicies.
    if (Blockly.isNumber(at)) {
      // If the index is a naked number, decrement it right now.
      at = parseFloat(at) - 1;
    } else {
      // If the index is dynamic, decrement it in code.
      at += ' - 1';
    }
    if (mode == 'SET') {
      return list + '[' + at + '] = ' + value + ';\n';
    }
  } else if (where == 'FROM_END') {
    var code = cacheList();
    if (mode == 'SET') {
      code += list + '[' + list + '.length - ' + at + '] = ' + value + ';\n';
      return code;
    }
  }
  throw 'Unhandled combination (lists_setIndex).';
};

Blockly.JavaScript['parseint'] = function(block) {
  var value_str = Blockly.JavaScript.valueToCode(block, 'str', Blockly.JavaScript.ORDER_ATOMIC);
  // TODO: Assemble JavaScript into code variable.
  var code = 'parseInt('+value_str+')';
  // TODO: Change ORDER_NONE to the correct strength.
  return [code, Blockly.JavaScript.ORDER_FUNCTION_CALL];
};

Blockly.JavaScript['unar_op'] = function(block) {
  var variable_name = Blockly.JavaScript.variableDB_.getName(block.getFieldValue('NAME'), Blockly.Variables.NAME_TYPE);
  var dropdown_op = block.getFieldValue('op');
  var value_val = Blockly.JavaScript.valueToCode(block, 'val', Blockly.JavaScript.ORDER_ATOMIC);
  // TODO: Assemble JavaScript into code variable.
  var code = variable_name+dropdown_op+value_val+";\n";
  return code;
};