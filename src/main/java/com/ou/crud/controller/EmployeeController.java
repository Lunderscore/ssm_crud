package com.ou.crud.controller;

import java.util.ArrayList;
import java.util.List;

import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.ObjectError;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.ou.crud.bean.Department;
import com.ou.crud.bean.Employee;
import com.ou.crud.bean.Msg;
import com.ou.crud.service.DepartmentService;
import com.ou.crud.service.EmployeeService;

//@SessionAttributes("user")
@Controller
public class EmployeeController {

	@Autowired
	EmployeeService employeeService;
	
	@Autowired
	DepartmentService departmentService;
	
	@ResponseBody
	@RequestMapping(value="/emp/{ids}", method=RequestMethod.DELETE)
	public Msg delEmp(@PathVariable("ids")String ids){		

		if (ids.contains("-")){
			List<Integer> idBatch = new ArrayList<Integer>();
			String[] id = ids.split("-");
			for (String string : id){
				idBatch.add(Integer.valueOf(string));
			}
			employeeService.delEmpBatch(idBatch);
			return Msg.success();
		}else{
			employeeService.delEmp(Integer.valueOf(ids));
			return Msg.success();
		}
	}
	
	@ResponseBody
	@RequestMapping(value="/emp/{empId}", method=RequestMethod.PUT)
	public Msg updateEmp(@Valid Employee employee, BindingResult result){
		if (result.hasErrors()){
			return Msg.failure().add("error", "错误");
		}
//		防止主动修改用户名
		if (null != employee.getEmpName()){
			return Msg.failure().add("error", "不能修改用户名");
		}
		
//		判断是否数据库中是否存在该部门
		Department department = departmentService.getDept(employee.getdId());
		if(null == department){
			return Msg.failure().add("error", "不存在该数据库");
		}
		
		boolean b = employeeService.updateEmp(employee);

		if (b){
			return Msg.success();
		}else{
			return Msg.failure();
		}
	}
	
	
	@ResponseBody
	@RequestMapping(value="/emp/{id}", method=RequestMethod.GET)
	public Msg getEmp(@PathVariable("id")Integer id){
		Employee employee = employeeService.getEmpByPrimaryKey(id);
		
		return Msg.success().add("emp", employee);
	}
	
	
	@ResponseBody
	@RequestMapping(value="/checkEmp/{name}", method=RequestMethod.GET)
	public Msg checkEmployee(@PathVariable("name")String name){

		boolean b = employeeService.checkEmployee(name);		
		if (b){
			return Msg.success().add("msg", "");
		}else{
			return Msg.failure().add("msg", "存在该员工, 反正就是不能重名");
		}
	}
	
	
	@ResponseBody
	@RequestMapping(value="/emp", method=RequestMethod.POST)
	public Msg saveEmployee(@Valid Employee employee, BindingResult result){
		if (result.hasErrors()){
			List<ObjectError> errorList = result.getAllErrors();
			return Msg.failure().add("error", errorList);
		}
		
//		判断是否数据库中是否存在该员工姓名
		boolean unique = employeeService.checkEmployee(employee.getEmpName());
		if (!unique){
			return Msg.failure().add("error", "已经存在该员工名");
		}
		
//		判断是否数据库中是否存在该部门
		Department department = departmentService.getDept(employee.getdId());
		if(null == department){
			return Msg.failure().add("error", "不存在该数据库");
		}
		
		employeeService.save(employee);
		return Msg.success();
	}

	@ResponseBody
	@RequestMapping(value="/emps", method=RequestMethod.GET)
	public Msg getEmpsWithJson(@RequestParam(value = "pn", defaultValue = "1") Integer pn) {

		PageHelper.startPage(pn, 5);
		List<Employee> emps = employeeService.getAll();
		PageInfo page = new PageInfo(emps, 5);
		
		return Msg.success().add("pageInfo", page);
	}

}
