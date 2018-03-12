package com.ou.crud.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ou.crud.bean.Department;
import com.ou.crud.dao.DepartmentMapper;

@Service
public class DepartmentService {

	@Autowired
	private DepartmentMapper departmentMapper;
	
	public List<Department> getDepts() {
		return departmentMapper.selectByExample(null);
	}
	
	public Department getDept(Integer id) {
		return departmentMapper.selectByPrimaryKey(id);
	}

}
