package com.zhuhaoran.crud.controller;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.zhuhaoran.crud.po.Employee;
import com.zhuhaoran.crud.service.EmployeeService;
import com.zhuhaoran.crud.utils.Msg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

/**
 * 处理CRUD请求
 */
@Controller
public class EmployeeController {

    @Autowired
    EmployeeService employeeService;


    //员工保存
    @RequestMapping(value = "/emp",method = RequestMethod.POST)
    @ResponseBody
    public Msg saveEmp(Employee employee){
        employeeService.saveEmp(employee);
        return Msg.success();
    }



    /**
     * 分页查询员工
     * @return
     */

    /**
     * 要使得@ResponseBody正常工作需要导入jackson包
     * @param page_num
     * @return
     */
    @RequestMapping("/emps")
    @ResponseBody
    public Msg getEmpWithJson(@RequestParam(value = "page_num",defaultValue = "1") Integer page_num){

        PageHelper.startPage(page_num,5);
        List<Employee> emps = employeeService.getAll();
        PageInfo pageInfo = new PageInfo(emps,5);
        return Msg.success().add("pageInfo",pageInfo);

    }

    //需要传入页码参数
    /*@RequestMapping("/emps")
    public String getEmps(@RequestParam(value = "page_num",defaultValue = "1") Integer page_num , Model model){
        //引入pageHelper插件方便分页
        PageHelper.startPage(page_num,5);

        List<Employee> emps = employeeService.getAll();

        PageInfo pageInfo = new PageInfo(emps,5);

        model.addAttribute("pageInfo",pageInfo);
        return "list";
    }*/
}
