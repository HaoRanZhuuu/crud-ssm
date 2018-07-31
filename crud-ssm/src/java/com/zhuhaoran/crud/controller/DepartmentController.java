package com.zhuhaoran.crud.controller;


import com.zhuhaoran.crud.po.Department;
import com.zhuhaoran.crud.service.DepartmentService;
import com.zhuhaoran.crud.utils.Msg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
public class DepartmentController {

    @Autowired
    private DepartmentService departmentService;

    @RequestMapping("depts")
    @ResponseBody
    public Msg getDepts(){
        //查询到的所有信息
        List<Department> list = departmentService.getAll();
        return Msg.success().add("dept",list);
    }

}
