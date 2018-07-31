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
                <button class="btn btn-primary">新增</button>
                <button class="btn btn-danger">删除</button>
            </div>
        </div>
            <%--表格数据--%>
        <div class="row"></div>
                <div class="col-md-12">
                    <table class="table table table-striped table table-hover">
                        <tr>
                            <th>#</th>
                            <th>empName</th>
                            <th>sex</th>
                            <th>email</th>
                            <th>deptName</th>
                            <th>操作</th>
                        </tr>
                        <c:forEach items="${pageInfo.list}" var="emp">

                            <tr>
                                <th>${emp.empId}</th>
                                <th>${emp.empName}</th>
                                <th>${emp.sex=="M"?"男":"女"}</th>
                                <th>${emp.email}</th>
                                <th>${emp.department.deptName}</th>
                                <th>
                                    <button class="btn btn-primary btn-sm">
                                        <span class="glyphicon glyphicon-pencil" aria-hidden="true"/>编辑
                                    </button>
                                    <button class="btn btn-danger btn-sm">
                                        <span class="glyphicon glyphicon-trash" aria-hidden="true"/>删除
                                    </button>
                                </th>
                            </tr>

                        </c:forEach>

                    </table>
                </div>
            <%--分页信息--%>
        <div class="row">
            <%--分页文字信息--%>
            <div class="col-md-6">
                当前${pageInfo.pageNum}页,总${pageInfo.pages}页,总${pageInfo.total}条记录
            </div>
            <%--分页条--%>
            <div class="col-md-6">
                <nav aria-label="Page navigation">
                    <ul class="pagination">
                        <c:if test="${pageInfo.isFirstPage}">
                            <li class="disabled">
                                <span>
                                    <span aria-hidden="true">首页</span>
                                </span>
                            </li>
                        </c:if>
                        <c:if test="${!pageInfo.isFirstPage}">
                            <li><a href="/">首页</a></li>
                        </c:if>

                        <c:if test="${pageInfo.hasPreviousPage}">
                            <li><a href="/emps?page_num=${pageInfo.pageNum-1}" aria-label="Previous">
                                    <span aria-hidden="true">&laquo;</span>
                            </a></li>
                        </c:if>
                        <c:forEach items="${pageInfo.navigatepageNums}" var="page_Num">
                            <c:if test="${page_Num == pageInfo.pageNum}">
                                <li class="active">
                                    <span>${page_Num}
                                        <span class="sr-only"></span>
                                    </span>
                                </li>
                            </c:if>
                            <c:if test="${page_Num != pageInfo.pageNum}">
                                <li><a href="/emps?page_num=${page_Num}">${page_Num}</a></li>
                            </c:if>
                        </c:forEach>

                        <c:if test="${pageInfo.hasNextPage}">
                            <li><a href="/emps?page_num=${pageInfo.pageNum+1}" aria-label="Next">
                                <span aria-hidden="true">&raquo;</span>
                            </a></li>
                        </c:if>

                        <c:if test="${pageInfo.isLastPage}">
                            <li class="disabled">
                                <span>
                                    <span aria-hidden="true">尾页</span>
                                </span>
                            </li>
                        </c:if>
                        <c:if test="${!pageInfo.isLastPage}">
                            <li><a href="/emps?page_num=${pageInfo.pages}">尾页</a></li>
                        </c:if>

                    </ul>
                </nav>
            </div>
        </div>
    </div>

</body>
</html>
