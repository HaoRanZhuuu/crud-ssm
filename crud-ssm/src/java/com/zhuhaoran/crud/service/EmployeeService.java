package com.zhuhaoran.crud.service;

import com.zhuhaoran.crud.mapper.EmployeeMapper;
import com.zhuhaoran.crud.po.Employee;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

//将service加入bean
@Service
public class EmployeeService {

    //自动注入mapper
    @Autowired
    EmployeeMapper employeeMapper;

    //查询所有员工数据
    public List<Employee> getAll() {

        return employeeMapper.selectByExampleWithDept(null);
    }

    //员工保存
    public void saveEmp(Employee employee) {
        employeeMapper.insertSelective(employee);
    }
}
