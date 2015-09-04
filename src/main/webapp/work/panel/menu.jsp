<%@page import="java.io.IOException"%>
<%@page import="java.io.PrintWriter"%>
<%@page import="io.cloudino.engine.DeviceMgr"%>
<%@page import="java.io.File"%>
<%@page import="org.semanticwb.datamanager.*"%>
<%!
    void addFile(File file, JspWriter out, File base, String tool) throws IOException
    {
        if (file.isDirectory() && !file.isHidden()) {
            out.println("<li><a href=\"#\"><i class=\"fa fa-file-code-o\"></i>" + file.getName() + "<i class=\"fa fa-angle-left pull-right\"></i></a>");
            out.println("<ul class=\"treeview-menu\">");
            File[] sketcherFiles = file.listFiles();
            for (File sktFile : sketcherFiles) {
                if(sktFile.isDirectory())
                {
                    addFile(sktFile, out,base,tool);
                }
                else
                {
                    if(!sktFile.getName().equals("config.properties")){
                        if(base!=null)
                        {
                            out.println("<li><a data-target=\".content-wrapper\" data-load=\"ajax\" href=\""+tool+"?fp=" + sktFile.getCanonicalPath() + "&skt=" + file.getName() + "\"><i class=\"fa fa-code\"></i>" + sktFile.getName() + "</a></li>");
                        }else
                        {
                            out.println("<li><a data-target=\".content-wrapper\" data-load=\"ajax\" href=\""+tool+"?fn=" + sktFile.getName() + "&skt=" + file.getName() + "\"><i class=\"fa fa-code\"></i>" + sktFile.getName() + "</a></li>");
                        }
                    }
                }
            }
            out.println("</ul>");
            out.println("</li>");
        }        
    }
%>
<%
    DataObject user = (DataObject) session.getAttribute("_USER_");
    SWBScriptEngine engine = DataMgr.getUserScriptEngine("/cloudino.js", user);
    String act=request.getParameter("act");
    File arduinoPath=new File(engine.getScriptObject().get("config").getString("arduinoPath"));
    File usersWorkPath=new File(engine.getScriptObject().get("config").getString("usersWorkPath"));
%>
    <!-- sidebar: style can be found in sidebar.less -->
    <section class="sidebar">
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
            <li class="header">MENU</li>
            <li class="treeview<%=("dev".equals(act)?" active":"")%>">
                <a href="#">
                    <i class="fa fa-gears"></i>
                    <span>Devices</span>
                    <i class="fa fa-angle-left pull-right"></i>
                </a>
                <ul class="treeview-menu">
                    <%
                        SWBDataSource ds = engine.getDataSource("Device");
                        DataObject query = new DataObject();
                        DataObject data = new DataObject();
                        query.put("data", data);
                        data.put("user", user.getId());
                        DataObject ret = ds.fetch(query);
                        //System.out.println(ret);
                        DataList<DataObject> devices = ret.getDataObject("response").getDataList("data");
                        if (devices != null) {
                            for (DataObject dev : devices) {
                                String id = dev.getNumId();
                                out.print("<li><a href=\"deviceDetail?ID=" + id + "\" data-target=\".content-wrapper\" data-load=\"ajax\"><i class=\"fa fa-circle-o\"></i><span>" + dev.getString("name") + "</span>");
                                if (DeviceMgr.getInstance().isDeviceConnected(id)) {
                                    out.print("<small class=\"label pull-right bg-green\">online</small>");
                                }
                                out.println("</a></li>");
                            }
                        }
                    %>                
                    <li><a href="addDevice" data-target=".content-wrapper" data-load="ajax"><i class="fa fa-gear"></i> Add Device</a></li>
                </ul>
            </li>
            <li class="treeview<%=("sket".equals(act)?" active":"")%>">
                <a href="#">
                    <i class="fa fa-laptop"></i>
                    <span>Sketchers</span>
                    <i class="fa fa-angle-left pull-right"></i>
                </a>
                <ul class="treeview-menu">
                    <%
                    {
                        //+ request.getRequestURI().substring(1, request.getRequestURI().lastIndexOf("/")) + "/"
                        String dir = config.getServletContext().getRealPath("/") + "/work/";
                        // leer estructura de archivos del usuario
                        String userBasePath = dir + engine.getScriptObject().get("config").getString("usersWorkPath") + "/" + user.getNumId() + "/sketchers";
                        File f = new File(userBasePath);
                        if (!f.exists()) {
                            f.mkdirs();
                        }
                        File[] listFiles = f.listFiles();
                        for (File file : listFiles) {
                            addFile(file, out,null,"sketcherDetail");
                        }
                    }
                    %>
                    <li><a href="addSketcher" data-target=".content-wrapper" data-load="ajax"><i class="fa fa-gear"></i> Agregar Sketcher</a></li> 
                </ul>
            </li>
            <li class="treeview<%=("exa".equals(act)?" active":"")%>">
                <a href="#">
                    <i class="fa fa-laptop"></i>
                    <span>Examples</span>
                    <i class="fa fa-angle-left pull-right"></i>
                </a>
                <ul class="treeview-menu">
                    <%
                    {
                        File fexa = new File(arduinoPath+"/examples");
                        File[] listFiles = fexa.listFiles();
                        for (File file : listFiles) {
                            addFile(file, out,fexa,"exampleDetail");
                        }
                    }
                    %>

                    <li><a href="addSketcher" data-target=".content-wrapper" data-load="ajax"><i class="fa fa-gear"></i> Agregar Sketcher</a></li> 
                    <!--  
                    <li><a href="#"><i class="fa fa-file-code-o"></i> Programa uno<i class="fa fa-angle-left pull-right"></i></a>
                    <ul class="treeview-menu">
                        <li><a href="#"><i class="fa fa-code"></i> Version 1</a></li>
                      </ul>
                      </li>
                    <li>
                      <a href="#"><i class="fa fa-file-code-o"></i> Programa dos <i class="fa fa-angle-left pull-right"></i></a>
                      <ul class="treeview-menu">
                        <li><a href="#"><i class="fa fa-code"></i> Version 1</a></li>
                        <li><a href="#"><i class="fa fa-code"></i> Version 2</a></li>
                      </ul>
                    </li>
                    <li><a href="#"><i class="fa fa-file-code-o"></i> Programa tres<i class="fa fa-angle-left pull-right"></i></a>
                      <ul class="treeview-menu">
                          <li><a href="#"><i class="fa fa-code"></i> Version 1</a></li>
                          <li><a href="#"><i class="fa fa-code"></i> Version 2</a></li>
                          <li><a href="#"><i class="fa fa-code"></i> Version 3</a></li>
                        </ul>
                      </li> -->
                </ul>
            </li>            
            
            <li class="treeview<%=("lib".equals(act)?" active":"")%>">
                <a href="#">
                    <i class="fa fa-book"></i>
                    <span>Libraries</span>
                    <i class="fa fa-angle-left pull-right"></i>
                </a>
                <ul class="treeview-menu">
                    <li>
                        <a href="#"><i class="fa fa-globe"></i> Global<i class="fa fa-angle-left pull-right"></i></a>
                        <ul class="treeview-menu">
                            <li><a href="#"><i class="fa fa-book"></i> Library 1</a></li>
                            <li><a href="#"><i class="fa fa-book"></i> Library 2</a></li>
                        </ul>
                    </li>
                    <li><a href="#"><i class="fa fa-book"></i> Local<i class="fa fa-angle-left pull-right"></i></a>
                        <ul class="treeview-menu">
                            <li><a href="#"><i class="fa fa-book"></i> Library 1</a></li>
                            <li><a href="#"><i class="fa fa-book"></i> Library 2</a></li>
                            <li><a href="#"><i class="fa fa-book"></i> Library 3</a></li>
                        </ul>
                    </li>
                </ul>
            </li>
            <li class="treeview<%=("ds".equals(act)?" active":"")%>">
                <a href="#">
                    <i class="fa fa-cubes"></i>
                    <span>Data Sets</span>
                    <i class="fa fa-angle-left pull-right"></i>
                </a>
                <ul class="treeview-menu">
                    <li><a href="#"><i class="fa fa-cube"></i> Data set uno<i class="fa fa-angle-left pull-right"></i></a>
                        <ul class="treeview-menu">
                            <li><a href="#"><i class="fa fa-cube"></i> Version 1</a></li>
                        </ul>
                    </li>
                    <li>
                        <a href="#"><i class="fa fa-cube"></i> Data set dos <i class="fa fa-angle-left pull-right"></i></a>
                        <ul class="treeview-menu">
                            <li><a href="#"><i class="fa fa-cube"></i> Version 1</a></li>
                            <li><a href="#"><i class="fa fa-cube"></i> Version 2</a></li>
                        </ul>
                    </li>
                </ul>
            </li>
            <li class="treeview<%=("dp".equals(act)?" active":"")%>">
                <a href="#">
                    <i class="fa fa-clock-o"></i>
                    <span>Data Procesors</span>
                    <i class="fa fa-angle-left pull-right"></i>
                </a>
                <ul class="treeview-menu">
                    <li><a href="#"><i class="fa fa-clock-o"></i> Procesor uno</a></li>
                </ul>
            </li>
            <li class="treeview<%=("dsv".equals(act)?" active":"")%>">
                <a href="#">
                    <i class="fa fa-server"></i>
                    <span>Data Services</span>
                    <i class="fa fa-angle-left pull-right"></i>
                </a>
                <ul class="treeview-menu">
                    <li><a href="#"><i class="fa fa-exchange"></i> Service uno</a>
                    </li>
                    <li>
                        <a href="#"><i class="fa fa-exchange"></i> Service dos</a>
                    </li>
                    <li><a href="#"><i class="fa fa-exchange"></i> Service tres</a>
                    </li>
                </ul>
            </li>
            <li class="treeview<%=("rul".equals(act)?" active":"")%>">
                <a href="#">
                    <i class="fa fa-eye"></i>
                    <span>Rules</span>
                    <i class="fa fa-angle-left pull-right"></i>
                </a>
                <ul class="treeview-menu">
                    <li><a href="#"><i class="fa fa-warning"></i> Regla uno</a></li>

                    <li>
                        <a href="#"><i class="fa fa-warning"></i> Regla dos</a>

                    </li>
                </ul>
            </li>
<!--
            <li class="treeview">
              <a href="#">
                <i class="fa fa-edit"></i> <span>Forms</span>
                <i class="fa fa-angle-left pull-right"></i>
              </a>
              <ul class="treeview-menu">
                <li><a href="pages/forms/general.html"><i class="fa fa-circle-o"></i> General Elements</a></li>
                <li><a href="pages/forms/advanced.html"><i class="fa fa-circle-o"></i> Advanced Elements</a></li>
                <li><a href="pages/forms/editors.html"><i class="fa fa-circle-o"></i> Editors</a></li>
              </ul>
            </li>
            <li class="treeview">
              <a href="#">
                <i class="fa fa-table"></i> <span>Tables</span>
                <i class="fa fa-angle-left pull-right"></i>
              </a>
              <ul class="treeview-menu">
                <li><a href="pages/tables/simple.html"><i class="fa fa-circle-o"></i> Simple tables</a></li>
                <li><a href="pages/tables/data.html"><i class="fa fa-circle-o"></i> Data tables</a></li>
              </ul>
            </li>
            <li>
              <a href="pages/calendar.html">
                <i class="fa fa-calendar"></i> <span>Calendar</span>
                <small class="label pull-right bg-red">3</small>
              </a>
            </li>
            <li>
              <a href="pages/mailbox/mailbox.html">
                <i class="fa fa-envelope"></i> <span>Mailbox</span>
                <small class="label pull-right bg-yellow">12</small>
              </a>
            </li>
            <li class="treeview">
              <a href="#">
                <i class="fa fa-folder"></i> <span>Examples</span>
                <i class="fa fa-angle-left pull-right"></i>
              </a>
              <ul class="treeview-menu">
                <li><a href="pages/examples/invoice.html"><i class="fa fa-circle-o"></i> Invoice</a></li>
                <li><a href="pages/examples/login.html"><i class="fa fa-circle-o"></i> Login</a></li>
                <li><a href="pages/examples/register.html"><i class="fa fa-circle-o"></i> Register</a></li>
                <li><a href="pages/examples/lockscreen.html"><i class="fa fa-circle-o"></i> Lockscreen</a></li>
                <li><a href="pages/examples/404.html"><i class="fa fa-circle-o"></i> 404 Error</a></li>
                <li><a href="pages/examples/500.html"><i class="fa fa-circle-o"></i> 500 Error</a></li>
                <li><a href="pages/examples/blank.html"><i class="fa fa-circle-o"></i> Blank Page</a></li>
              </ul>
            </li>
            <li class="treeview">
              <a href="#">
                <i class="fa fa-share"></i> <span>Multilevel</span>
                <i class="fa fa-angle-left pull-right"></i>
              </a>
              <ul class="treeview-menu">
                <li><a href="#"><i class="fa fa-circle-o"></i> Level One</a></li>
                <li>
                  <a href="#"><i class="fa fa-circle-o"></i> Level One <i class="fa fa-angle-left pull-right"></i></a>
                  <ul class="treeview-menu">
                    <li><a href="#"><i class="fa fa-circle-o"></i> Level Two</a></li>
                    <li>
                      <a href="#"><i class="fa fa-circle-o"></i> Level Two <i class="fa fa-angle-left pull-right"></i></a>
                      <ul class="treeview-menu">
                        <li><a href="#"><i class="fa fa-circle-o"></i> Level Three</a></li>
                        <li><a href="#"><i class="fa fa-circle-o"></i> Level Three</a></li>
                      </ul>
                    </li>
                  </ul>
                </li>
                <li><a href="#"><i class="fa fa-circle-o"></i> Level One</a></li>
              </ul>
            </li>
            <li><a href="documentation/index.html"><i class="fa fa-book"></i> <span>Documentation</span></a></li>
-->
<!--            
            <li class="header">LABELS</li>
            <li><a href="#"><i class="fa fa-circle-o text-red"></i> <span>Important</span></a></li>
            <li><a href="#"><i class="fa fa-circle-o text-yellow"></i> <span>Warning</span></a></li>
            <li><a href="#"><i class="fa fa-circle-o text-aqua"></i> <span>Information</span></a></li>
-->
        </ul>
    </section>