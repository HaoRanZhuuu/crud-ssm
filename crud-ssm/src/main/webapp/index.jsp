<%@ page contentType="text/html;charset=UTF-8"
         language="java" pageEncoding="UTF-8" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <!-- Bootstrap -->
    <link href="https://cdn.bootcss.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
    <!-- jQuery (Bootstrap 的所有 JavaScript 插件都依赖 jQuery，所以必须放在前边) -->
    <script src="https://cdn.bootcss.com/jquery/1.12.4/jquery.min.js"></script>
    <!-- 加载 Bootstrap 的所有 JavaScript 插件。你也可以根据需要只加载单个插件。 -->
    <script src="https://cdn.bootcss.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>

    <title>员工列表</title>
</head>
<body>

<!-- 员工添加的模态框 -->
<div class="modal fade" id="empAddModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">员工添加</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">
                    <div class="form-group">
                        <label for="empName_add_input" class="col-sm-2 control-label">empName</label>
                        <div class="col-sm-8">
                            <input name="empName" type="text" class="form-control" id="empName_add_input" placeholder="empName">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="email_add_input" class="col-sm-2 control-label">email</label>
                        <div class="col-sm-8">
                            <input name="email" type="text" class="form-control" id="email_add_input" placeholder="email@email.com">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">sex</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input type="radio" name="sex" id="sex1_add_input" value="M" checked="checked"> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="sex" id="sex2_add_input" value="F"> 女
                            </label>
                        </div>
                    </div>
                    <%--部门提交部门id--%>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">deptName</label>
                        <div class="col-sm-4">
                            <select class="form-control" name="dId" id="dept_add_select">

                            </select>
                        </div>
                    </div>

                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-danger" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-success" id="emp_save_btn">提交</button>
            </div>
        </div>
    </div>
</div>

<%--搭建显示页面--%>
<div class="container">
    <%--标题行--%>
    <div class="row">
        <div class="col-md-12">
            <h1>SSM-CRUD</h1>
        </div>
    </div>
    <%--两个按钮--%>
    <div class="row">
        <div class="col-md-4 col-md-offset-8">
            <button class="btn btn-primary" id="emp_add_modal_btn">新增</button>
            <button class="btn btn-danger">删除</button>
        </div>
    </div>
    <%--表格数据--%>
    <div class="row"></div>
    <div class="col-md-12">
        <table class="table table table-striped table table-hover" id="emps_table">
            <thead>
                <tr>
                    <th>#</th>
                    <th>empName</th>
                    <th>sex</th>
                    <th>email</th>
                    <th>deptName</th>
                    <th>操作</th>
                </tr>
            </thead>
            <tbody>

            </tbody>
        </table>
    </div>
    <%--分页信息--%>
    <div class="row">
        <%--分页文字信息--%>
        <div class="col-md-6" id="page_info_div"></div>
        <%--分页条--%>
        <div class="col-md-6" id="page_info_nav">
        </div>
    </div>
</div>

<script type="text/javascript">
    //1.当页面加载完成后，发送ajax请求，获取分页数据
    $(function () {
        to_page(1);
    });

    //跳转请求的封装
    function to_page(page_num) {
        $.ajax({
            url:"/emps",
            data:"page_num="+page_num,
            type:"get",
            success:function (result) {
                //console.log(result);
                //1.解析并显示员工数据
                build_emps_table(result);
                //2.解析并显示分页信息
                build_page_info(result);
                //3.显示分页条
                build_page_nav(result);
            }
        });
    }
    //构建table显示员工数据
    function build_emps_table(result) {
        $("#emps_table tbody").empty();
        var emps = result.extend.pageInfo.list;
        $.each(emps,function (index,item) {
            var empIdTd = $("<td></td>").append(item.empId);
            var empNameTd = $("<td></td>").append(item.empName);
            var sexTd = $("<td></td>").append(item.sex =='M'?"男":"女");
            var emailTd = $("<td></td>").append(item.email);
            var deptNameTd = $("<td></td>").append(item.department.deptName);

            var editBtn = $("<button></button>").addClass("btn btn-primary btn-sm")
                                                  .append($("<span></span>").addClass("glyphicon glyphicon-pencil")).append("编辑");
            var delBtn = $("<button></button>").addClass("btn btn-danger btn-sm")
                                                 .append($("<span></span>").addClass("glyphicon glyphicon-trash")).append("删除");
            var btnTD =  $("<td></td>").append(editBtn).append(" ").append(delBtn);
            $("<tr></tr>").append(empIdTd)
                           .append(empNameTd)
                           .append(sexTd)
                           .append(emailTd)
                           .append(deptNameTd)
                           .append(btnTD)
                           .appendTo("#emps_table tbody");
        });
    }

    //构建显示分页信息
    function build_page_info(result) {
        $("#page_info_div").empty();
        var pageInfo = result.extend.pageInfo;
        //var infoSpan = $("<span></span>").addClass("label label-default");
        $("#page_info_div").append("当前"+pageInfo.pageNum+"页,总"+pageInfo.pages+"页,总"+pageInfo.total+"条记录")
    }

    //构建显示分页条相关内容
    function build_page_nav(result) {
        $("#page_info_nav").empty();
        var ul = $("<ul></ul>").addClass("pagination");
        var fristPageLi = $("<li></li>").append($("<a></a>").append("首页"));
        var prePageLi = $("<li></li>").append($("<a></a>").append("&laquo;"));

        if (result.extend.pageInfo.hasPreviousPage == false) {
            fristPageLi.addClass("disabled");
            prePageLi.addClass("disabled");
        }else {
            fristPageLi.click(function () {
                to_page(1);
            });
            prePageLi.click(function () {
                to_page(result.extend.pageInfo.pageNum - 1);
            });
        }

        var nextPageLi = $("<li></li>").append($("<a></a>").append("&raquo;"));
        var lastPageLi = $("<li></li>").append($("<a></a>").append("尾页"));

        if (result.extend.pageInfo.hasNextPage == false) {
            nextPageLi.addClass("disabled");
            lastPageLi.addClass("disabled");
        }else {
            lastPageLi.click(function () {
                to_page(result.extend.pageInfo.pages);
            });

            nextPageLi.click(function () {
                to_page(result.extend.pageInfo.pageNum + 1);
            });
        }

        ul.append(fristPageLi).append(prePageLi);
        $.each(result.extend.pageInfo.navigatepageNums,function (index,item) {
            var  numLi = $("<li></li>").append($("<a></a>").append(item));
            if (item == result.extend.pageInfo.pageNum){
                numLi.addClass("active");
            }
            numLi.click(function () {
                to_page(item);
            });
                ul.append(numLi);
        });
        ul.append(nextPageLi).append(lastPageLi);
        var nav = $("<nav></nav>").append(ul);
        $("#page_info_nav").append(nav);
    }
    $("#emp_add_modal_btn").click(function () {
        getDepts();
        $("#empAddModal").modal({
            backdrop:"static"
        });
    });
    //查询所有的部门信息
    function getDepts() {
        $.ajax({
            url:"/depts",
            type:"get",
            success:function (result) {
                //console.log(result);
                //$("#dept_add_select")
                $.each(result.extend.dept,function () {
                    var optionEle = $("<option></option>").append(this.deptName)
                                                            .attr("value",this.deptId);
                    optionEle.appendTo("#dept_add_select");
                });
            }
        });
    }
    $("#emp_save_btn").click(function () {
        //1.将填写的表单数据提交给服务器进行保存
        //发送ajax请求
        $.ajax({
            url:"/emp",
            type:"post",
            data:$("#empAddModal form").serialize(),
            success:function (result) {
                //alert(result.msg);
                //保存成功1.关闭窗口2.跳转到最后一页码
                $("#empAddModal").modal('hide');
                //发送ajax显示最后一页
                to_page(2147483647);
            }
        });
    });
</script>
</body>
</html>
