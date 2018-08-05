package com.zhuhaoran.crud.controller;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.zhuhaoran.crud.po.Employee;
import com.zhuhaoran.crud.service.EmployeeService;
import com.zhuhaoran.crud.utils.Msg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 处理CRUD请求
 */
@Controller
public class EmployeeController {

    @Autowired
    EmployeeService employeeService;


    @ResponseBody
    @RequestMapping(value = "/emp/{ids}" , method = RequestMethod.DELETE)
    public Msg deleteEmp(@PathVariable("ids") String ids){
        if (ids.contains("-")){
            List<Integer> del_ids = new ArrayList<>();
            String[] str_ids = ids.split("-");
            for (String id :str_ids){
                del_ids.add(Integer.parseInt(id));
            }
            employeeService.deleteBatch(del_ids);
        }else {
            Integer id = Integer.parseInt(ids);
            employeeService.deleteEmp(id);
        }

        return Msg.success();
    }


    @RequestMapping(value = "/emp/{empId}",method = RequestMethod.PUT)
    @ResponseBody
    public Msg updateEmp(Employee employee){
        employeeService.updateEmp(employee);
        return Msg.success();
    }

    @RequestMapping(value = "/emp/{id}",method = RequestMethod.GET)
    @ResponseBody
    public Msg getEmp(@PathVariable("id") Integer id){
        Employee employee = employeeService.getEmp(id);
        return Msg.success().add("emp",employee);
    }

    @RequestMapping("/checkuser")
    @ResponseBody
    public  Msg checkUser(String empName){
        //后端判断是否合法
        String reg = "(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5}$)";
        if (!empName.matches(reg)){
            return Msg.fail().add("va_msg","用户名必须为2-5位中文或6-16位英文数字的组合(包含大小写和下划线)");
        }
        //数据库校验
        boolean b = employeeService.checkUser(empName);
        if (b)
            return Msg.success();
        else
            return Msg.fail().add("va_msg","用户名不可用");
    }


    //员工保存
    @RequestMapping(value = "/emp",method = RequestMethod.POST)
    @ResponseBody
    public Msg saveEmp(@Valid Employee employee, BindingResult result){
        if(result.hasErrors()){
            Map<String,Object> map = new HashMap<>();
            List<FieldError> errors = (List<FieldError>) result.getFieldError();
            for (FieldError fieldError : errors){
                System.out.println("错误的字段名"+fieldError.getField());
                System.out.println("错误的信息"+fieldError.getDefaultMessage());
                map.put(fieldError.getField(),fieldError.getDefaultMessage());
            }
            return Msg.fail().add("error",map);
        }else {
            employeeService.saveEmp(employee);
            return Msg.success();
        }

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
