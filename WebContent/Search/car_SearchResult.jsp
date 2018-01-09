<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page session="false" contentType="text/html;charset=utf-8"
	import="com.sinosoft.search.*"
	import="com.sinosoft.cms.api.*" 
	import="com.sinosoft.framework.*"
	import="com.sinosoft.framework.utility.*"
	import="com.sinosoft.framework.data.*"
	import="java.util.*"
%>
<%@ taglib uri="controls" prefix="z"%>
 
<%
	request.setCharacterEncoding(Constant.GlobalCharset);
    response.setContentType("text/html;charset=utf-8"); 
    String keyword = request.getParameter("keyword");
    String query = request.getParameter("query");

	String qer = new String(request.getParameter("query").getBytes(
		    "ISO-8859-1"), "UTF-8");
	if ((StringUtil.isEmpty(query)) && (StringUtil.isNotEmpty(keyword))) {
		query = keyword;//和旧版本保持一致
	}
	query = StringUtil.isEmpty(query)?"":StringUtil.escapeSpecialLetter(query);
	String strpage = request.getParameter("page");
	strpage = StringUtil.isEmpty(strpage)?"1":strpage;
	if (!strpage.matches("\\d+"))
	{
		StringUtil.invalidInputCope(out, "页码不合法！");
		return;
		//strpage = "1";
	}
	String order = request.getParameter("order");
	order = StringUtil.isEmpty(order)?"rela":order;
	if (!order.matches("(rela)|(time)"))
	{
		StringUtil.invalidInputCope(out, "排序方式不合法！");
		return;
		//order = "time";
	}

	String time = request.getParameter("time");
	time = StringUtil.isEmpty(time)?"all":time;
	if (!time.matches("(all)|(week)|(month)|(quarter)"))
	{
		StringUtil.invalidInputCope(out, "时间类型不合法！");
		return;
		//time = "";
	}
	
	String site = request.getParameter("site");
	site = StringUtil.isEmpty(site)?"":site;
	if (!site.matches("\\d+"))
	{
		StringUtil.invalidInputCope(out, "站点id不合法！");
		return;
		//site = "221";
	}

	String id = request.getParameter("id");
	id  = StringUtil.isEmpty(id)?"":id;
	if (!id.matches("\\d+"))
	{
		StringUtil.invalidInputCope(out, "索引id不合法！");
		return;
		//id = "26";
	}

	String size = request.getParameter("size");
	size  = StringUtil.isEmpty(size)?"10":size;
	if (!size.matches("\\d+"))
	{
		StringUtil.invalidInputCope(out, "每页记录数不合法！");
		return;
		//size = "10";
	}
	
	int pageSize = Integer.parseInt(size);
	int pageIndex = Integer.parseInt(strpage) - 1;
	
	Mapx map = ServletUtil.getParameterMap(request,false);
	map.put("query", qer);
	map.put("page", strpage);
	map.put("size", size);
	map.put("time", time);
	map.put("id", id);
	map.put("site", site);
	SearchResult r = ArticleSearcher.search(map);
	if(r==null){
		out.println("<br><br><br><b><font color='red'>全文检索索引未建立。</font></b>");
		return;
	}
	DataTable dt = r.Data;
	int total = r.Total;
	double usedTime = r.UsedTime;
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html;charset=utf-8">
<title>搜索结果_<%=qer%></title>
<style type="text/css">
	.InsuQASearchArea{}
	.InsuQASearchArea .InsuQASearchBg{border:1px solid #f9b041; background:#fff url('<%=Config.getValue("StaticResourcePath")%>/images/Bg_1.gif') 0 -490px repeat-x; height:80px;}
	.InsuQASearchArea .InputTxtArea{width:530px; height:30px; line-height:30px; border:1px solid #CC6600; background:#fff url('<%=Config.getValue("StaticResourcePath")%>/images/Bg_1.gif') 0 -382px repeat-x; margin-top:20px; margin-left:25px; padding-left:8px; font-size:12px; color:#666666; margin-right:5px; float:left;}
	.InsuQASearchArea .Btn_1, .InsuQASearchArea .Btn_2{background:url('<%=Config.getValue("StaticResourcePath")%>/images/BtnImg.gif') 0 -113px; width:100px; height:31px; border:none; cursor:pointer; margin-right:5px; margin-top:20px; }
	.InsuQASearchArea .Btn_2{background-position:0 -174px;}
</style>
<link href="<%=Config.getValue("StaticResourcePath")%>/style/new/global.css" rel="stylesheet" type="text/css"/>
<link href="<%=Config.getValue("StaticResourcePath")%>/style/car/base.css" rel="stylesheet" type="text/css"/>
<link href="<%=Config.getValue("StaticResourcePath")%>/style/new_information.css" rel="stylesheet" type="text/css" />
<link href="<%=Config.getValue("StaticResourcePath")%>/style/car/information.css" rel="stylesheet" type="text/css"/>
</head>

<body >
<%@include file="../wwwroot/kxb/block/car_header.shtml"%>
	<div class="wrapper">
		<div class="center" style="width:1020px;">
			<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="bi">
				<tr>
					<td width="81%" valign="bottom" nowrap>
					<div id=div1
						style="background-color: #eee; border-top: 1px solid #ddd; border-bottom: 1px solid #ddd; CLEAR: right; Z-INDEX: 20; FLOAT: left; WIDTH: 100%; HEIGHT: 24px; FONT-SIZE: 13px;">
					<div style="padding: 0 1em; border-top: 1px solid #fff;"><span
						style="float: right;">约有<b><%=total%></b>项符合搜索<b> <%=qer%>
					</b>的查询结果，耗时<%=usedTime%>秒，以下是第<b><%=(pageIndex * pageSize + 1)%></b>-<b><%=((pageIndex + 1) * pageSize)%></b>项。</span>
					</div>
					</div>
					</td>
				</tr>
			</table>
		
		 
		
			<div id="mleft" style="width: 900px;  padding-top:0px; text-align:left;word-wrap: break-word; word-break: normal;">
				<ul>
					<%
						for (int i = 0; i < dt.getRowCount(); i++) {
							DataRow dr = dt.getDataRow(i);
							if(i != dt.getRowCount()-1){
					%>     
						   <li class="g1" style="border-bottom: 1px dashed #CDCAC6;padding-top: 10px ;padding-bottom: 10px;">
						   <%  } else {%>
						   <li class="g1"  >
						   <% } %>
						        <ul>
							       	<li class="lip2"> <a class=l href="<%=dr.getString("URL")%>" target=_blank style="font-weight: bold;color: #000000;font-size: 15px;">
							        <%=dr.getString("Title")%></a></li>
									
								    <li class="lip2"><span style="font-size: 13px; "><%=dr.getString("Content")%>...</span></li>
								    <li class="lip2"><span style="color: #875"><a href="<%=dr.getString("URL")%>"><%=dr.getString("URL")%></a> - <%=dr.getString("PublishDate")%></span></li>
							   		<li class="lip2">栏目：<%=dr.getString("CatalogName")%></li>
							    </ul>
						   </li>
					<%
						}
					%>
					
				</ul>
				<ul style=" text-align: center;padding-top: 40px;">
					<li ><span style="font-size: 13px;">结果页码:&nbsp;</span> 
					<%
						int pageCount = new Double(Math.ceil(total * 1.0 / pageSize)).intValue();
						int start = pageIndex - 9 < 1 ? 1 : pageIndex - 9;
						int end = pageIndex + 9 > pageCount ? pageCount : pageIndex + 9;
						if (pageIndex >= 1) {
							out.println(" <td nowrap><a href='"+ SearchAPI.getPageURL(map, pageIndex)+ "'>上一页</a></td>");
						}
						for (int i = start; i <= end; i++) {
							if (i == pageIndex + 1) {
								out.println("<td nowrap><span class=i>" + i	+ "</span></td>");
							} else {
								out.println("<td nowrap><a href='"+ SearchAPI.getPageURL(map, i) + "'>[" + i+ "]</a></td>");
							}
						}
						if (pageIndex < pageCount - 1) {
							out.println(" <td nowrap><a href='"+ SearchAPI.getPageURL(map, pageIndex + 2)+ "'>下一页</a></td>");
						}
					%></li>
				</ul>
			</div>
		</div>
	</div>
	 <%@include file="../wwwroot/kxb/block/car_footer.shtml" %>
<script type="text/javascript"
	src="<%=Config.getValue("JsResourcePath")%>/js/template/common/js/jquery.js"></script>
<script type="text/javascript"
	src="<%=Config.getValue("JsResourcePath")%>/js/template/common/js/jquery.cookie.js"></script>
<script type="text/javascript"
	src="<%=Config.getValue("JsResourcePath")%>/js/template/shop/js/header1.js"></script>
<script type="text/javascript"
	src="<%=Config.getValue("JsResourcePath")%>/js/productCompare.js"></script>
<script type="text/javascript"
	src="<%=Config.getValue("JsResourcePath")%>/js/premcalculate.js"></script>
<%@include file="../wwwroot/kxb/block/community.shtml"%>
</body>
</html>