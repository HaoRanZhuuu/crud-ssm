package com.zhuhaoran.crud.test;

import com.github.pagehelper.PageHelper;
import com.zhuhaoran.crud.mapper.DepartmentMapper;
import com.zhuhaoran.crud.mapper.EmployeeMapper;
import com.zhuhaoran.crud.po.Department;
import com.zhuhaoran.crud.po.Employee;
import kohgylw.kcnamer.core.KCNamer;
import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import sun.awt.geom.AreaOp;

import java.util.List;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:spring/applicationContext.xml"})
public class MapperTest {
    /**
     * 测试部门
     */
    @Autowired
    DepartmentMapper departmentMapper;

    @Autowired
    EmployeeMapper employeeMapper;

    @Autowired
    SqlSession sqlSession;

    @Test
    public void testCRUD(){

        //System.out.println(departmentMapper);
        //1.插入
        /*Department department1 = new Department();
        Department department2 = new Department();
        department1.setDeptName("开发部");
        department2.setDeptName("测试部");
        departmentMapper.insertSelective(department1);
        departmentMapper.insertSelective(department2);
*/
        //2.员工插入
       /* System.out.println(employeeMapper);
        Employee employee = new Employee();
        employee.setEmpName("Jerry");
        employee.setSex("M");
        employee.setEmail("Jerry@123.com");
        employee.setdId(1);
        employeeMapper.insertSelective(employee);*/
       /*Employee employee = new Employee();
       EmployeeMapper employeeMapper = sqlSession.getMapper(EmployeeMapper.class);

        KCNamer kcNamer = new KCNamer();
       for (int i = 0 ;i <1000 ; i++){
           String name = kcNamer.getRandomName();
           employee.setEmpName(name);
           employee.setSex("F");
           employee.setEmail(name+"@123.com");
           employee.setdId(2);
           employeeMapper.insertSelective(employee);
       }
*/

        PageHelper.startPage(2,5);

        System.out.println();
    }
}
