<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>员工列表Web</title>

<%
	pageContext.setAttribute("APP_PATH", request.getContextPath());
%>

<link href="${APP_PATH }/static/bootstrap/css/bootstrap.min.css"
	rel="stylesheet">
<script src="${APP_PATH }/static/js/jquery-3.1.1.min.js"></script>
<script src="${APP_PATH }/static/bootstrap/js/bootstrap.min.js"></script>
</head>
<body>
<!-- 员工添加 -->
<!-- Modal -->
	<div class="modal fade" id="empAddModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
	  <div class="modal-dialog" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
	        <h4 class="modal-title" id="myModalLabel">新增员工</h4>
	      </div>
	      <div class="modal-body">
	        <form class="form-horizontal" id="f">
			  <div class="form-group">
			    <label for="empName" class="col-sm-2 control-label">员工姓名</label>
			    <div class="col-sm-10">
			      <input type="text" class="form-control" id="empNameInput" placeholder="张三" name="empName">
			      <span id="helpBlock" class="help-block"></span>
			    </div>
			  </div>
			  <div class="form-group">
			    <label for="email" class="col-sm-2 control-label">员工邮箱</label>
			    <div class="col-sm-10">
			      <input type="text" class="form-control" id="emailInput" placeholder="123456789@qq.com" name="email">
			      <span id="helpBlock" class="help-block"></span>
			    </div>
			  </div>
			  <div class="form-group">
			    <label class="col-sm-2 control-label">性别</label>
			      <div class="col-sm-10">
					<label class="radio-inline">
				  		<input type="radio" name="gender" id="gender" value="M" checked="checked"> 男
			  		</label>
					<label class="radio-inline">
				  		<input type="radio" name="gender" id="gender" value="F"> 女
			  		</label>
			    </div>
			  </div>
			  
			  <div class="form-group">
			    <label class="col-sm-2 control-label">部门</label>
			    <div class="col-sm-4">
			      <select class="form-control" name="dId">
				  </select>
			    </div>
			  </div>
			  
			</form>
			
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
	        <button type="button" class="btn btn-primary" id="addSaveBtn">保存</button>
	      </div>
	    </div>
	  </div>
	</div>
	<div class="container">
		<div class="row">
			<div class="col-md-12">
				<h1>CRUD</h1>
			</div>
		</div>
		<div class="row">
			<div class="col-md-4 col-md-offset-8">
				<button class="btn btn-success" id="empAddModalBtn">新增</button>
				<button class="btn btn-danger">删除</button>
			</div>
		</div>
		<div class="row">
			<div class="col-md-12">
				<table class="table table-hover">
					<thead>
						<tr>
						<td>#</td>
						<td>员工名字</td>
						<td>性别</td>
						<td>email</td>
						<td>部门名称</td>
						<td>操作</td>
					</tr>
					<c:forEach var="i" items="${pageInfo.list }">
						<tr>
							<td>${i.empId }</td>
							<td>${i.empName }</td>
							<td>${i.gender=="M" ? "男" : "女" }</td>
							<td>${i.email }</td>
							<td>${i.departMent.deptName }</td>
							<td>
								<button class="btn btn-primary btn-sm">
									<span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>新增
								</button>
								<button class="btn btn-danger btn-sm">
									<span class="glyphicon glyphicon-trash" aria-hidden="true"></span>删除
								</button>
							</td>
						</tr>
					</c:forEach>
				</table>
			</div>
		</div>
		<div class="row">
			<div class="col-md-6">当前页码：${pageInfo.pageNum}
				总页数：${pageInfo.pages } 总记录数：${pageInfo.total }</div>
			<div class="col-md-6">
				<nav aria-label="Page navigation">
				<ul class="pagination">
					<li><a href="${APP_PATH }/indexWeb.jsp?pn=1">首页</a></li>
					<c:if test="${pageInfo.hasPreviousPage }">
						<li><a href="${APP_PATH }/indexWeb.jsp?pn=${pageInfo.prePage}"
							aria-label="Previous"> <span aria-hidden="true">&laquo;</span>
						</a></li>
					</c:if>
					<c:forEach var="num" items="${pageInfo.navigatepageNums }">
						<c:if test="${pageInfo.pageNum ==  num}">
							<li class="active"><a href="${APP_PATH }/indexWeb.jsp?pn=${num }">${num }</a></li>
						</c:if>
						<c:if test="${pageInfo.pageNum !=  num}">
							<li><a href="${APP_PATH }/indexWeb.jsp?pn=${num }">${num }</a></li>
						</c:if>
					</c:forEach>
					<c:if test="${pageInfo.hasNextPage }">
						<li><a href="${APP_PATH }/indexWeb.jsp?pn=${pageInfo.pageNum + 1}"
							aria-label="Next"> <span aria-hidden="true">&raquo;</span>
						</a></li>
					</c:if>
					<li><a href="${APP_PATH }/indexWeb.jsp?pn=${pageInfo.pages}">末页</a></li>
				</ul>
				</nav>
			</div>
		</div>
	</div>
	<script type="text/javascript">
		
// 		从数据库获取部门信息
		$("#empAddModalBtn").on("click", function(){
			getDepts();
			$("#empAddModal").modal();
		});
		function getDepts(){
			var place = $("#empAddModal select");
			place.empty();
			
			$.get("${APP_PATH }/deptsJSON",function(data) {
				$.each(data.content.depts, function(){
					$("<option></option>").attr("value", this.deptId).append(this.deptName).appendTo(place);
				});
			});
		}
		
		function validateForm(){
			var empName = $("#empNameInput").val();
			var regName = /(^[a-zA-Z0-9_-]{4,8}$)|(^[\u2E80-\u9FFF]{2,5}$)/;
			var email = $("#emailInput").val();
			var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
			
			var namaFlag = false;
			var uniqueNameFlag = false;
			var emailFlag = false;
			
			if (!regName.test(empName)){
				shouValidateMsg("#empNameInput", "failure", "4到8个数字字母组合或2个到5个汉字组合");
				return false;
			}else{
				shouValidateMsg("#empNameInput", "success", "");
				namaFlag = true;
			}
			
			if (!regEmail.test(email)){
				shouValidateMsg("#emailInput", "failure", "邮箱格式错误");
				return false;
			}else{
				shouValidateMsg("#emailInput", "success", "");
				emailFlag = true;
			}
			
			if ($("#empNameInput").attr("zzz") == "zzz"){
				uniqueNameFlag = true;
			}

			return namaFlag && emailFlag && uniqueNameFlag;
		}
		function shouValidateMsg(ele, status, msg){
			$(ele).parent().removeClass("has-error has-success");
			$(ele).next().text("");
			
			if (status == "failure"){
				$(ele).parent().addClass("has-error");
				$(ele).next().text(msg);
			}else if (status == "success"){
				$(ele).parent().addClass("has-success");
				$(ele).next().text(msg);
			}
		}
		
		function resetForm(ele){
			$(ele)[0].reset();
			$(ele).find("input").parent().removeClass("has-error has-success");
		}
		
		$("#addSaveBtn").on("click", function(){
			if (!validateForm()){
				return;
			};
			$.ajax({
				url: "${APP_PATH}/empJSON",
				type: "POST",
				async: false,
				data: $("#empAddModal form").serialize(),
				success:function(result){
					$('#empAddModal').modal('hide');
					resetForm("#empAddModal form");
					location.href = "emps?pn=${pageInfo.total}";
				}
			});
		});
		$("#empNameInput").on("change", function(){
			$.ajax({
				url:"${APP_PATH}/checkEmpJSON?name="+$("#empNameInput").val(),
				type: "GET",
				async: false,
				success: function(data){
					if (data.code == 200){
						shouValidateMsg("#empNameInput", "failure", data.content.msg);
						$("#empNameInput").removeAttr("zzz");
					}else if(data.code == 100){
						$("#empNameInput").attr("zzz", "zzz");
						shouValidateMsg("#empNameInput", "success", "");
					}
				}
			});
		});
	</script>
</body>
</html>
