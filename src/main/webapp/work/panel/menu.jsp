<%@page import="java.io.FileFilter"%>
<%@page import="io.cloudino.utils.ParamsMgr"%>
<%@page import="java.io.IOException"%>
<%@page import="java.io.PrintWriter"%>
<%@page import="io.cloudino.engine.DeviceMgr"%>
<%@page import="java.io.File"%>
<%@page import="org.semanticwb.datamanager.*"%>
<%!

%>
<%
    DataObject user = (DataObject) session.getAttribute("_USER_");
    SWBScriptEngine engine = DataMgr.getUserScriptEngine("/cloudino.js", user);
    String act=request.getParameter("act");
%>
    <!-- sidebar: style can be found in sidebar.less -->
    <section class="sidebar" style="overflow: scroll">
        <!-- Sidebar user panel -->
        <div class="user-panel">
            <div class="pull-left image">
                <img src="/photo" class="img-circle" alt="User Image" />
            </div>
            <div class="pull-left info">
                <p><%=user.getString("fullname")%></p>

                <a href="#"><i class="fa fa-circle text-success"></i> Online</a>
            </div>
        </div>
        <!-- sidebar menu: : style can be found in sidebar.less -->
        <ul class="sidebar-menu">
            <li class="header">THINGING</li>
            <li class="treeview<%=("dev".equals(act)?" active":"")%>">
                <a href="#">
                    <i class="fa fa-gears"></i>
                    <span>Devices</span>
                    <i class="fa fa-angle-left pull-right"></i>
                </a>
                <ul class="treeview-menu devices">
                    <jsp:include page="devices.jsp" />
                </ul>
            </li>
            <li class="treeview<%=("dg".equals(act)?" active":"")%>">
                <a href="#">
                    <i class="fa fa-cubes"></i>
                    <span>Device Groups</span>
                    <i class="fa fa-angle-left pull-right"></i>
                </a>
                <ul class="treeview-menu">
                    <%
                    {
                        SWBDataSource ds = engine.getDataSource("DeviceGroup");
                        DataObject query = new DataObject();
                        DataObject data = new DataObject();
                        query.put("data", data);
                        data.put("user", user.getId());
                        DataObject ret = ds.fetch(query);
                        //System.out.println(ret);
                        DataList<DataObject> list = ret.getDataObject("response").getDataList("data");
                        if (list != null) {
                            for (DataObject obj : list) {
                                String id = obj.getNumId();
                                %>
                                <li><a href="deviceGroupDetail?ID=<%=id%>" data-target=".content-wrapper" data-load="ajax"><i class="fa fa-cube"></i><%=obj.getString("name")%></a></li>
                                <%
                            }
                        }
                    }
                    %>                
                    <li><a href="addDeviceGroup" data-target=".content-wrapper" data-load="ajax"><i class="fa fa-gear"></i> Add Device Group</a></li>
                </ul>
            </li>
            <li class="treeview<%=("uc".equals(act)?" active":"")%>">
                <a href="#">
                    <i class="fa fa-cubes"></i>
                    <span>User Context</span>
                    <i class="fa fa-angle-left pull-right"></i>
                </a>
                <ul class="treeview-menu">
                    <%
                    {
                        SWBDataSource ds = engine.getDataSource("UserContext");
                        DataObject query = new DataObject();
                        DataObject data = new DataObject();
                        query.put("data", data);
                        data.put("user", user.getId());
                        DataObject ret = ds.fetch(query);
                        //System.out.println(ret);
                        DataList<DataObject> list = ret.getDataObject("response").getDataList("data");
                        if (list != null) {
                            for (DataObject obj : list) {
                                String id = obj.getNumId();
                                %>
                                <li><a href="userContextDetail?ID=<%=id%>" data-target=".content-wrapper" data-load="ajax"><i class="fa fa-cube"></i><%=obj.getString("name")%></a></li>
                                <%
                            }
                        }
                    }
                    %>                
                    <li><a href="addUserContext" data-target=".content-wrapper" data-load="ajax"><i class="fa fa-gear"></i> Add User Context</a></li>
                </ul>
            </li>
            
            <li class="header">CLOUDING</li>
            
            <li class="treeview<%=("cr".equals(act)?" active":"")%>">
                <a href="#">
                    <i class="fa fa-cubes"></i>
                    <span>Cloud Rules</span>
                    <i class="fa fa-angle-left pull-right"></i>
                </a>
                <ul class="treeview-menu">
                    <%
                    {
                        SWBDataSource ds = engine.getDataSource("CloudRule");
                        DataObject query = new DataObject();
                        DataObject data = new DataObject();
                        query.put("data", data);
                        data.put("user", user.getId());
                        DataObject ret = ds.fetch(query);
                        //System.out.println(ret);
                        DataList<DataObject> list = ret.getDataObject("response").getDataList("data");
                        if (list != null) {
                            for (DataObject obj : list) {
                                String id = obj.getNumId();
                                %>
                                <li><a href="cloudRuleDetail?ID=<%=id%>" data-target=".content-wrapper" data-load="ajax"><i class="fa fa-cube"></i><%=obj.getString("name")%></a></li>
                                <%
                            }
                        }
                    }
                    %>                
                    <li><a href="addCloudRule" data-target=".content-wrapper" data-load="ajax"><i class="fa fa-gear"></i> Add Cloud Rule</a></li>
                </ul>
            </li>
            <li class="treeview<%=("ds".equals(act)?" active":"")%>">
                <a href="#">
                    <i class="fa fa-cubes"></i>
                    <span>Data Sets</span>
                    <i class="fa fa-angle-left pull-right"></i>
                </a>
                <ul class="treeview-menu">
                    <%
                    {
                        SWBDataSource ds = engine.getDataSource("DataSet");
                        DataObject query = new DataObject();
                        DataObject data = new DataObject();
                        query.put("data", data);
                        data.put("user", user.getId());
                        DataObject ret = ds.fetch(query);
                        //System.out.println(ret);
                        DataList<DataObject> list = ret.getDataObject("response").getDataList("data");
                        if (list != null) {
                            for (DataObject obj : list) {
                                String id = obj.getNumId();
                                %>
                                <li><a href="datasetDetail?ID=<%=id%>" data-target=".content-wrapper" data-load="ajax"><i class="fa fa-cube"></i><%=obj.getString("name")%></a></li>
                                <%
                            }
                        }
                    }
                    %>                
                    <li><a href="addDataSet" data-target=".content-wrapper" data-load="ajax"><i class="fa fa-gear"></i> Add Data Set</a></li>
                </ul>
            </li>
            <li class="header">LINKING</li>
            <li class="treeview<%=("ds".equals(act)?" active":"")%>">
                <a href="#">
                    <i class="fa fa-cubes"></i>
                    <span>FIWARE ContextBroker</span>
                    <i class="fa fa-angle-left pull-right"></i>
                </a>
                <ul class="treeview-menu">
                    <li><a href="addDataSet" data-target=".content-wrapper" data-load="ajax"><i class="fa fa-gear"></i> Add Data Set</a></li>
                </ul>
            </li>
            <li class="treeview<%=("ds".equals(act)?" active":"")%>">
                <a href="#">
                    <i class="fa fa-cubes"></i>
                    <span>MQTT Server</span>
                    <i class="fa fa-angle-left pull-right"></i>
                </a>
                <ul class="treeview-menu">
                    <li><a href="addDataSet" data-target=".content-wrapper" data-load="ajax"><i class="fa fa-gear"></i> Add Data Set</a></li>
                </ul>
            </li>
            <li class="treeview<%=("ds".equals(act)?" active":"")%>">
                <a href="#">
                    <i class="fa fa-cubes"></i>
                    <span>COAP Server</span>
                    <i class="fa fa-angle-left pull-right"></i>
                </a>
                <ul class="treeview-menu">
                    <li><a href="addDataSet" data-target=".content-wrapper" data-load="ajax"><i class="fa fa-gear"></i> Add Data Set</a></li>
                </ul>
            </li>

        </ul>
    </section>