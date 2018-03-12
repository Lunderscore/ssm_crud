<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<title>员工列表JSON</title>

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
	<div class="modal fade" id="addEmpModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
	  <div class="modal-dialog" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
	        <h4 class="modal-title">新增员工</h4>
	      </div>
	      <div class="modal-body">
	        <form class="form-horizontal">
			  <div class="form-group">
			    <label for="addEmpNameIuput" class="col-sm-2 control-label">员工姓名</label>
			    <div class="col-sm-10">
			      <input type="text" class="form-control" id="addEmpNameIuput" placeholder="张三" name="empName">
			      <span id="helpBlock" class="help-block"></span>
			    </div>
			  </div>
			  <div class="form-group">
			    <label for="addEmailInput" class="col-sm-2 control-label">员工邮箱</label>
			    <div class="col-sm-10">
			      <input type="text" class="form-control" id="addEmailInput" placeholder="1696229469@qq.com" name="email">
			      <span id="helpBlock" class="help-block"></span>
			    </div>
			  </div>
			  <div class="form-group">
			    <label class="col-sm-2 control-label">性别</label>
			      <div class="col-sm-10">
					<label class="radio-inline">
				  		<input type="radio" name="gender" value="M" checked="checked"> 男
			  		</label>
					<label class="radio-inline">
				  		<input type="radio" name="gender" value="F"> 女
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
	        <button type="button" class="btn btn-primary" id="addEmpSaveBtn">保存</button>
	      </div>
	    </div>
	  </div>
	</div>
	
	<!-- 员工修改 -->
<!-- Modal -->
	<div class="modal fade" id="updateEmpModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
	  <div class="modal-dialog" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
	        <h4 class="modal-title">修改员工</h4>
	      </div>
	      <div class="modal-body">
	        <form class="form-horizontal">
			  <div class="form-group">
			    <label for="updateEmpNameP" class="col-sm-2 control-label">员工姓名</label>
			    <div class="col-sm-10">
			      <p class="form-control-static" id="updateEmpNameP"></p>
			      <span id="helpBlock" class="help-block"></span>
			    </div>
			  </div>
			  <div class="form-group">
			    <label for="updateEmailInput" class="col-sm-2 control-label">员工邮箱</label>
			    <div class="col-sm-10">
			      <input type="text" class="form-control" id="updateEmailInput" placeholder="1696229469@qq.com" name="email">
			      <span id="helpBlock" class="help-block"></span>
			    </div>
			  </div>
			  <div class="form-group">
			    <label class="col-sm-2 control-label">性别</label>
			      <div class="col-sm-10">
					<label class="radio-inline">
				  		<input type="radio" name="gender" value="M"> 男
			  		</label>
					<label class="radio-inline">
				  		<input type="radio" name="gender" value="F"> 女
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
	        <button type="button" class="btn btn-primary" id="updateEmpSaveBtn">保存</button>
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
				<button class="btn btn-success" id="addEmpModalBtn">新增</button>
				<button class="btn btn-danger" id="delBatch">删除</button>
			</div>
		</div>
		<div class="row">
			<div class="col-md-12">
				<table class="table table-hover">
					<thead>
						<tr>
							<td><input type='checkbox' id='checkAll' /></td>
							<td>ID</td>
							<td>员工名字</td>
							<td>性别</td>
							<td>email</td>
							<td>部门名称</td>
							<td>操作</td>
						</tr>
					</thead>
					<tbody>
					</tbody>
				</table>
			</div>
		</div>
		<div class="row">
			<div class="col-md-6" id="pageInfo"></div>
			<div class="col-md-6" id="nav"></div>
		</div>
	</div>
	
	<script src="${APP_PATH }/static/js/crud.js" type="text/javascript"></script>
</body>
</html>