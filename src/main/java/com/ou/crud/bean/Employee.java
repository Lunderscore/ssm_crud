package com.ou.crud.bean;

import javax.validation.constraints.Pattern;

public class Employee {
    private Integer empId;

    @Pattern(regexp="(^[a-zA-Z0-9_-]{4,8}$)|(^[\u2E80-\u9FFF]{2,5}$)", message="4到8个数字字母组合或2个到5个汉字组合")
    private String empName;

    @Pattern(regexp="F|M", message="性别错误")
    private String gender;
    
    @Pattern(regexp="^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$", message="邮箱格式错误")
    private String email;

    private Integer dId;
    
    private Department departMent;

    public Integer getEmpId() {
        return empId;
    }

    public void setEmpId(Integer empId) {
        this.empId = empId;
    }

    public Employee(Integer empId, String empName, String gender, String email, Integer dId) {
		super();
		this.empId = empId;
		this.empName = empName;
		this.gender = gender;
		this.email = email;
		this.dId = dId;
	}

	public Employee() {
		super();
	}

	public String getEmpName() {
        return empName;
    }

    public void setEmpName(String empName) {
        this.empName = empName == null ? null : empName.trim();
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender == null ? null : gender.trim();
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email == null ? null : email.trim();
    }

    public Integer getdId() {
        return dId;
    }

    public void setdId(Integer dId) {
        this.dId = dId;
    }

	public Department getDepartMent() {
		return departMent;
	}

	public void setDepartMent(Department departMent) {
		this.departMent = departMent;
	}
}