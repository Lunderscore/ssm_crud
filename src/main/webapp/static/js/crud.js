		$(function() {
			PATH = "/crud";
			toPage(1);
		});

		
// 		从数据库获取部门信息
		$("#addEmpModalBtn").on("click", function(){
			getDepts("#addEmpModal select");
			$("#addEmpModal").modal();
		});
		
//		更新操作前   员工信息模态框信息展示
		$(document).on("click", ".updateEmpModalBtnClass", function(){
			resetUpdateForm("#updateEmpModal form"); 
			getDepts("#updateEmpModal select");
			$("#updateEmpModal").modal();
			$.ajax({
				url: PATH+"/emp/" + $(this).attr("empid"),
				type: "GET",
				async: false,
				success:function(result){
					$("#updateEmpNameP").text(result.content.emp.empName);
					$("#updateEmailInput").attr("value", result.content.emp.email);
					$("#updateEmpModal input[value="+ result.content.emp.gender +"]").prop("checked", true);
					console.log(result.content.emp);
					
					$("#updateEmpModal option[value="+ result.content.emp.dId +"]").prop("selected", true);
					
//					$("#updateEmpModal select").children().appendTo($("#test"));
					
//					更新保存按钮赋主键值
					$("#updateEmpSaveBtn").attr("empid", result.content.emp.empId);
				}
			});
		});
		
//		删除操作
		$(document).on("click", ".delEmpClass", function(){
			var empName = $(this).parents("tr").find("td:eq(2)").text();
			if (confirm("是否删除" + empName + "?")){
				$.ajax({
					url: PATH+"/emp/" + $(this).attr("empid"),
					type: "POST",
					data: "_method=DELETE",
					success:function(result){
						if (result.code == 100){
							alert("删除成功");
							toPage($("#nav li[class=active]").first().text());
						}else if(result.code == 200){
							alert("删除失败");
						}
					}
				});
			}			
		});
		
		$("#delBatch").on("click", function(){
			var empName = "";
			var empId = ""
				
			$.each($(".checkItem:checked"), function(){
				empName += $(this).parents("tr").find("td:eq(2)").text() + ", ";
				empId += $(this).parents("tr").find("td:eq(1)").text() + "-";
			});
			empName = empName.substr(0, empName.length-2);
			empId = empId.substr(0, empId.length-1);

			if (empName!="" && confirm("是否删除" + empName + "?")){
				$.ajax({
					url: PATH+"/emp/"+ empId,
					type: "POST",
					data: "_method=DELETE",
					success:function(result){
						if (result.code == 100){
							alert("删除成功");
							toPage($("#nav li[class=active]").first().text());
						}else if(result.code == 200){
							alert("删除失败");
						}
					}
				});
			}			
		});
		
		$("#checkAll").on("click", function(){
			if ($(this).prop("checked")){
				$(".checkItem").prop("checked", true);
			}else{
				$(".checkItem").prop("checked", false);
			}
		});
		$(document).on("click", ".checkItem", function(){
			if ($(".checkItem:checked").length == $(".checkItem").length){
				$("#checkAll").prop("checked", true);
			}else{
				$("#checkAll").prop("checked", false);
			}
		});
		
		$("#addEmpSaveBtn").on("click", function(){
//			如果前台验证失败则不提交
			if (!validateAddForm()){
				return;
			};
			$.ajax({
				url: PATH+"/emp",
				type: "POST",
				async: false,
				data: $("#addEmpModal form").serialize(),
				success:function(result){
					if (result.code == 100){
						$('#addEmpModal').modal('hide');
						toPage(PAGE_NUMS);
					}else if(result.code == 200){
						alert("提交失败: " + result.content.error);
					}
				}
			});
		});
		
		$("#updateEmpSaveBtn").on("click", function(){
//			如果前台修改验证失败则不提交
			if (!validateUpdateForm()){
				return;
			};
			$.ajax({
				url: PATH+"/emp/"+$(this).attr("empid"),
				type: "POST",
				async: false,
				data: "_method=PUT&" + $("#updateEmpModal form").serialize(),
				success:function(result){
					if (result.code == 100){
						$('#updateEmpModal').modal('hide');
						resetUpdateForm("#resetAddForm form");
						toPage($("#nav li[class=active]").first().text());
					}else if(result.code == 200){
						alert("更新失败");
					}
				}
			});
		});
		
//		如果数据库没有该员工名  则添加zzz属性标识可以提交该员工名
		$("#addEmpNameIuput").on("change", function(){
			if (!validateEmpName("#addEmpNameIuput")){
				return;
			}
			$.ajax({
				url:PATH+"/checkEmp/"+$("#addEmpNameIuput").val(),
				type: "GET",
				async: false,
				success: function(data){
					if (data.code == 200){
						shouValidateMsg("#addEmpNameIuput", "failure", data.content.msg);
						$("#addEmpNameIuput").removeAttr("zzz");
					}else if(data.code == 100){
						$("#addEmpNameIuput").attr("zzz", "zzz");
						shouValidateMsg("#addEmpNameIuput", "success", "");
					}
				}
			});
		});
		
		$("#addEmailInput").on("change", function(){
			validateEmail("#addEmailInput");
		});
		
//		同上
		$("#updateEmailInput").on("change", function(){
			validateEmail("#updateEmailInput");
		});
		
		function toPage(page){
			$.get(PATH+"/emps?pn="+page, function(data) {
				PAGE_NUMS = data.content.pageInfo.total;
				build_emps_table(data);
				pageInfo(data);
				build_page_nav(data);
				$("#checkAll").prop("checked", false);
			});
		}
		
//		构建表格
		function build_emps_table(data) {
			var emps = data.content.pageInfo.list;
			var tableEle = $("tbody");
			tableEle.empty();
			
			$.each(emps, function(index, item) {
				var checkboxTd = $("<td><input type='checkbox' class='checkItem' /></td>");
				var empId = $("<td></td>").append(item.empId);
				var empName = $("<td></td>").append(item.empName);
				var gender = $("<td></td>").append(item.gender == "M" ? "男" : "女");
				var email = $("<td></td>").append(item.email);
				var deptName = $("<td></td>").append(item.departMent.deptName);
				var editBtn = $("<button></button>").addClass("btn btn-primary btn-sm")
													.append("<span></span>")
													.addClass("glyphicon glyphicon-pencil")
													.append("编辑")
													//  标识该员工ID
													.addClass("updateEmpModalBtnClass")
													.attr("empId", item.empId);
				var delBtn = $("<button></button>").addClass("btn btn-danger btn-sm")
												   .append("<span></span>")
												   .addClass("glyphicon glyphicon-trash")
												   .append("删除")
												//  标识该员工ID
													.addClass("delEmpClass")
													.attr("empId", item.empId);
				var button = $("<td></td>").append(editBtn)
										   .append(" ")
										   .append(delBtn);
				$("<tr></tr>").append(checkboxTd)
							  .append(empId)
							  .append(empName)
							  .append(gender)
						      .append(item)
						      .append(email)
						      .append(deptName)
						      .append(button)
						      .appendTo(tableEle);
			});
		}

// 		分页信息展示
		function pageInfo(data) {
			var pi = data.content.pageInfo;
			var piDiv = $("#pageInfo");
			piDiv.empty();
			
			piDiv.append("当前页码：" + pi.pageNum + " 总页数：" + pi.pages + " 总记录数："
					+ pi.total)
		}

// 		构建分页条
		function build_page_nav(data) {
			var navsInfo = data.content.pageInfo;
			var navPlace = $("#nav");
			navPlace.empty();
			
			var nav = $("<nav></nav>");
			var ul = $("<ul></ul>").addClass("pagination").appendTo(nav);
			var firstUrl = $("<a></a>").append("首页").attr("href", "#");
			var first = $("<li></li>").append(firstUrl);
			var preUrl = $("<a></a>").append("&laquo;").attr("href", "#");
			var pre = $("<li></li>").append(preUrl);
			ul.append(first).append(pre);
			
			$.each(navsInfo.navigatepageNums, function(index, v) {
				var itemUrl = $("<a></a>").append(this).attr("href", "#");
				if (this == data.content.pageInfo.pageNum){
					var item = $("<li></li>").append(itemUrl).addClass("active");
				}else{
					var item = $("<li></li>").append(itemUrl);
					item.on("click", function(){
						toPage(v);
					});
				}
				ul.append(item);
			});
			
			var nextUrl = $("<a></a>").append("&raquo;").attr("href", "#");
			var next = $("<li></li>").append(nextUrl);
			var lastUrl = $("<a></a>").append("末页").attr("href", "#");
			var last = $("<li></li>").append(lastUrl);
			
			if (!navsInfo.hasPreviousPage){
				pre.addClass("disabled");
			}else{
				pre.click(function(){
					toPage(navsInfo.prePage);
				});
			}
			if (!navsInfo.hasNextPage){
				next.addClass("disabled");
			}else{
				next.click(function(){
					toPage(navsInfo.nextPage);
				});
			}
			
			first.click(function(){
				toPage(1);
			});
			
			last.click(function(){
				toPage(navsInfo.pages);
			});
			
			ul.append(next).append(last);
			navPlace.append(ul);
		}
		
		

		function getDepts(ele){
			var place = $(ele);
			place.empty();
			
			$.get(PATH+"/deptsJSON",function(data) {
				$.each(data.content.depts, function(){
					$("<option></option>").attr("value", this.deptId).append(this.deptName).appendTo(place);
//					$("<option value="+this.deptId+">"+this.deptName+"</option>").appendTo(place);
				});
			});
		}
		
//		验证提交表单数据
		function validateAddForm(){
			var unique = false;
			if ($("#addEmpNameIuput").attr("zzz") == "zzz"){
				unique = true;
			}

			return validateEmpName("#addEmpNameIuput") && validateEmail("#addEmailInput") && unique;
		}

		function validateUpdateForm(){
			return validateEmail("#updateEmailInput");
		}
		
//		验证员工名
		function validateEmpName(eleInput){
			var empName = $(eleInput).val();
			var regName = /(^[a-zA-Z0-9_-]{4,8}$)|(^[\u2E80-\u9FFF]{2,5}$)/;
			if (!regName.test(empName)){
				shouValidateMsg(eleInput, "failure", "4到8个数字字母组合或2个到5个汉字组合");
				return false;
			}else{
				shouValidateMsg(eleInput, "success", "");
				return true;
			}
		}
		
//		验证邮箱
		function validateEmail(eleInput){
			var email = $(eleInput).val();
			var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
			if (!regEmail.test(email)){
				shouValidateMsg(eleInput, "failure", "邮箱格式错误");
				return false;
			}else{
				shouValidateMsg(eleInput, "success", "");
				return true;
			}
		}
		
//		输出提示信息
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
		
//		提交成功后清空表单  还原表单样式
		function resetAddForm(ele){
			$(ele)[0].reset();
			$(ele).find("input").parent().removeClass("has-error has-success");
		}
		
		function resetUpdateForm(ele){
			//$(ele + " input[checked=checked]").removeAttr("checked");
		}
