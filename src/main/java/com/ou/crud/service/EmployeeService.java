package com.ou.crud.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ou.crud.bean.Employee;
import com.ou.crud.bean.EmployeeExample;
import com.ou.crud.bean.EmployeeExample.Criteria;
import com.ou.crud.dao.EmployeeMapper;

@Service
public class EmployeeService{

	@Autowired
	EmployeeMapper employeeMapper;
	
	
	public List<Employee> getAll() {
		EmployeeExample example = new EmployeeExample();
		example.setOrderByClause("emp_id");
		
		return employeeMapper.selectByExampleWithDept(example);
	}


	public void save(Employee employee) {
		employeeMapper.insertSelective(employee);
	}


	public boolean checkEmployee(String name) {
		EmployeeExample example = new EmployeeExample();
		Criteria criteria = example.createCriteria();
		criteria.andEmpNameEqualTo(name);
		
		long count = employeeMapper.countByExample(example);
		return count == 0;
	}

	public Employee getEmpByPrimaryKey(Integer key) {
		return employeeMapper.selectByPrimaryKey(key);
	}


	public boolean updateEmp(Employee employee) {
		int count = employeeMapper.updateByPrimaryKeySelective(employee);
		
		return count != 0;
	}

	public void delEmp(Integer key) {
		employeeMapper.deleteByPrimaryKey(key);
	}
	public void delEmpBatch(List<Integer> ids) {
		EmployeeExample example = new EmployeeExample();
		Criteria criteria = example.createCriteria();
		criteria.andEmpIdIn(ids);
		
		employeeMapper.deleteByExample(example);
	}
	

}
