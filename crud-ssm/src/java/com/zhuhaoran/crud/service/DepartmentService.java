package com.zhuhaoran.crud.service;

import com.zhuhaoran.crud.mapper.DepartmentMapper;
import com.zhuhaoran.crud.po.Department;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class DepartmentService {

    @Autowired
    private DepartmentMapper departmentMapper;

    public List<Department> getAll(){
        return  departmentMapper.selectByExample(null);
    }
}
