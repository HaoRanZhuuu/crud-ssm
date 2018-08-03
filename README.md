# crud-ssm
简单的SSM整合练习，实现CRUD功能
本项目记录了联系SSM整合的具体步骤及遇到的问题
----------SSM整合学习笔记----------
1.环境搭建

1.1创建Maven webapp项目

1.2在pom.xml文件中设置要引用的jar包
    具体jar包在Maven仓库http://mvnrepository.com中查找，需要引用以下
   
    <dependencys> 
    <!--JUNIT包-->
    <dependency>
      <groupId>junit</groupId>
      <artifactId>junit</artifactId>
      <version>4.12</version>
      <scope>test</scope>
    </dependency>

    <!--Spring-SpringMVC相关jar包-->

    <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-web</artifactId>
      <version>5.0.7.RELEASE</version>
    </dependency>

    <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-webmvc</artifactId>
      <version>5.0.7.RELEASE</version>
    </dependency>

    <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-jdbc</artifactId>
      <version>5.0.7.RELEASE</version>
    </dependency>

    <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-aop</artifactId>
      <version>5.0.7.RELEASE</version>
    </dependency>

    <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-context</artifactId>
      <version>5.0.7.RELEASE</version>
    </dependency>

    <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-aspects</artifactId>
      <version>5.0.7.RELEASE</version>
    </dependency>

    <dependency>
      <groupId>commons-logging</groupId>
      <artifactId>commons-logging</artifactId>
      <version>1.2</version>
    </dependency>

    <!--Mybatis相关jar包-->

    <dependency>
      <groupId>org.mybatis</groupId>
      <artifactId>mybatis</artifactId>
      <version>3.4.6</version>
    </dependency>

    <dependency>
      <groupId>org.mybatis</groupId>
      <artifactId>mybatis-spring</artifactId>
      <version>1.3.2</version>
    </dependency>

    <!--数据库连接池以及jdbc-->

    <dependency>
      <groupId>com.mchange</groupId>
      <artifactId>c3p0</artifactId>
      <version>0.9.5.2</version>
    </dependency>

    <dependency>
      <groupId>mysql</groupId>
      <artifactId>mysql-connector-java</artifactId>
      <version>8.0.11</version>
    </dependency>

    <!--jstl，servlet(设置为provided在tomcat打包时不会引入)-->

    <dependency>
      <groupId>javax.servlet.jsp.jstl</groupId>
      <artifactId>jstl</artifactId>
      <version>1.2</version>
    </dependency>

    <dependency>
      <groupId>javax.servlet</groupId>
      <artifactId>javax.servlet-api</artifactId>
      <version>4.0.1</version>
      <scope>provided</scope>
    </dependency>
    </dependencys>

1.3引入Bootstrap方便前端的开发
	在<head>.....</head>标签中添加相关的CDN提供的css以及js文件
	<!-- Bootstrap -->
        <link href="https://cdn.bootcss.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
	<!-- jQuery (Bootstrap 的所有 JavaScript 插件都依赖 jQuery，所以必须放在前边) -->
	<script src="https://cdn.bootcss.com/jquery/1.12.4/jquery.min.js"></script>
	<!-- 加载 Bootstrap 的所有 JavaScript 插件。你也可以根据需要只加载单个插件。 -->
	<script src="https://cdn.bootcss.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
	
1.4配置web.xml

  1.4.1配置启动Spring容器
	指定本地配置文件applicationContext.xml用来进行spring的配置
	ContextLoaderListener监听器可以在web容器启动时自动装配spring中的bean

    <context-param>
        <param-name>contextConfigLocation</param-name>
        <param-value>classpath:applicationContext.xml</param-value>
    </context-param>
    <listener>
        <listener-class>org.springframework.web.context.ContextLoaderListener</listener-class>
    </listener>

  1.4.2配置SpringMVC的前端控制器，拦截所有请求

	url为/拦截所有请求，设置<load-on-startup>1</load-on-startup>启动服务器就启动springmvc
	指定本地配置文件springmvc.xml用来进行springmvc的配置
	当前端提交请求时，所有请求都被前端控制器DispatcherServlet所拦截，并在之后进行处理

    <servlet>
      <servlet-name>dispatcherServlet</servlet-name>
      <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
      <init-param>
        <param-name>contextConfigLocation</param-name>
        <param-value>classpath:springmvc.xml</param-value>
      </init-param>
      <load-on-startup>1</load-on-startup>
    </servlet>
    <servlet-mapping>
      <servlet-name>dispatcherServlet</servlet-name>
      <url-pattern>/</url-pattern>
    </servlet-mapping>

  1.4.3配置字符编码的过滤器

	注意，在配置<filter>标签后，自动生成的web.xml文件的<web-app>标签会报错
	修改标签如下即可：
	<web-app xmlns="http://java.sun.com/xml/ns/javaee"
		 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
		 xsi:schemaLocation="http://java.sun.com/xml/ns/javaee http://java.sun.com/xml/ns/javaee/web-app_3_0.xsd"
		 version="3.0">
	配置spring提供的CharacterEncodingFilter字符过滤器，CharacterEncodingFilter中
	自带三个参数encoding、forceRequestEncoding和forceResponseEncoding
	将编码格式encoding设置为utf-8，req和resp拦截设置成true
	设置<filter-mapping>为过滤所有请求(/*)为utf-8

    <filter>
      <filter-name>characterEncodingFilter</filter-name>
      <filter-class>org.springframework.web.filter.CharacterEncodingFilter</filter-class>
      <init-param>
        <param-name>encoding</param-name>
        <param-value>utf-8</param-value>
      </init-param>
      <init-param>
        <param-name>forceRequestEncoding</param-name>
        <param-value>true</param-value>
      </init-param>
      <init-param>
        <param-name>forceResponseEncoding</param-name>
        <param-value>true</param-value>
      </init-param>
    </filter>
    <filter-mapping>
      <filter-name>characterEncodingFilter</filter-name>
      <url-pattern>/*</url-pattern>
    </filter-mapping>

  1.4.4配置使用RESTful URI的过滤器

	配置HiddenHttpMethodFilter过滤器，将普通页面的post/get请求转换为delete/put等请求
	来满足REST风格的需求，同样过滤所有的请求
	注意！！一定要放在字符编码拦截器之后，以防止出现问题

   <filter>
      <filter-name>hiddenHttpMethodFilter</filter-name>
      <filter-class>org.springframework.web.filter.HiddenHttpMethodFilter</filter-class>
    </filter>
    <filter-mapping>
      <filter-name>hiddenHttpMethodFilter</filter-name>
      <url-pattern>/*</url-pattern>
    </filter-mapping>
    
1.5建立包结构

	分别建立：
	com.zhuhaoran.crud.po用来放持久层类
	com.zhuhaoran.crud.controller用来放控制器类
	com.zhuhaoran.crud.dao用来放数据库访问类
	com.zhuhaoran.crud.service用来放业务层类
	com.zhuhaoran.crud.utils用来放工具类
	。。。。。。。	

1.6建立数据库表

1.7建立applicationContext.xml文件作为Spring的配置文件，主要配置和业务逻辑有关的相关内容

  1.7.1配置数据源

	引入数据库配置文件db.properties的内容

        <context:property-placeholder location="classpath:db.properties"/>

	db.properties的内容为：记录了数据库连接的相关信息

	jdbc.driver=com.mysql.cj.jdbc.Driver
	jdbc.url=jdbc:mysql://localhost:3306/ssm?serverTimezone=GMT%2B8&characterEncoding=utf-8&useSSL=false
	jdbc.username=root
	jdbc.password=961120

	配置id为dataSource的bean指向C3P0连接池的ComboPooledDataSource，并在其中配置上连接的
	相关参数：

	<bean id="dataSource" class="com.mchange.v2.c3p0.ComboPooledDataSource" destroy-method="close">
            <property name="driverClass" value="${jdbc.driver}"/>
            <property name="jdbcUrl" value="${jdbc.url}"/>
            <property name="user" value="${jdbc.username}"/>
            <property name="password" value="${jdbc.password}"/>
        </bean>

  1.7.2配置组件扫描

	与springMVC配置不同，spring中配置除了Controller以外都扫描

	<context:component-scan base-package="com.zhuhaoran.crud">
            <context:exclude-filter type="annotation" expression="org.springframework.stereotype.Controller"/>
        </context:component-scan>

  1.7.3配置Spring与Mybatis的整合，以及mapper扫描器

	配置sqlSessionFactory，指定configLocation属性为mybatis配置文件的地址
	配置指定dataSource

	<bean id="sqlSessionFactory" class="org.mybatis.spring.SqlSessionFactoryBean">
            <property name="configLocation" value="classpath:mybatis/mybatis-config.xml"/>
            <property name="dataSource" ref="dataSource"/>
        </bean>

	配置MapperScannerConfigurer，来配置mapper扫描器，他会自动扫描指定包下的mapper文件

	<bean class="org.mybatis.spring.mapper.MapperScannerConfigurer">
            <property name="basePackage" value="com.zhuhaoran.crud.mapper"/>
            <property name="sqlSessionFactoryBeanName" value="sqlSessionFactory"/>
        </bean>

	注意！！要使用sqlSessionFactoryBeanName来指定sqlSessionFactory的名字，而不是直接指定
	sqlSessionFactory，否则的话会导致component-scan无法正常运行

  1.7.4配置开启基于xml配置文件的事务控制，并配置事务增强

	配置transactionManager指定数据源，开启事务管理控制
	使用<aop:config>标签开启事务控制，在标签中配置切入点表达式以及指定的事务增强
	使用<tx:advice>标签配置事务增强，将所有方法加入事务管理，所有get开头的方法设为只读

	<bean id="transactionManager" class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
            <property name="dataSource" ref="dataSource"/>
        </bean>

	<aop:config>
            <!--切入点表达式-->
            <aop:pointcut id="txPoint" expression="execution(* com.zhuhaoran.crud.service..*(..))"/>
            <aop:advisor advice-ref="txAdvice" pointcut-ref="txPoint"/>
        </aop:config>
        <tx:advice id="txAdvice" transaction-manager="transactionManager">
            <tx:attributes>
                <tx:method name="*"/>
                <tx:method name="get*" read-only="true"/>
            </tx:attributes>
        </tx:advice>

1.8建立springmvc.xml文件作为SpringMVC的配置文件

  1.8.1配置包扫描器，使springMVC扫描特定包内的类
	
	设置过滤器，使springMVC只扫描到controller控制器
	使用context的包扫描器，use-default-filters属性设置为fales为不使用默认的扫描过滤器
	<context:include-filter>引入注解（annotation）类型的stereotype.Controller过滤器来
	实现只扫描控制器的注解

	<context:component-scan base-package="com.zhuhaoran.crud.controller" use-default-filters="false">
            <context:include-filter type="annotation" expression="org.springframework.stereotype.Controller"/>
        </context:component-scan>

  1.8.2配置视图解析器，方便页面的返回

	将InternalResourceViewResolver加入bean中及配置完成
	设置prefix属性为视图页面的地址前缀
	设置suffix属性为视图页面文件的后缀

	<bean class="org.springframework.web.servlet.view.InternalResourceViewResolver">
        <property name="prefix" value="/WEB-INF/views/"></property>
        <property name="suffix" value=".jsp"></property>
        </bean>

  1.8.3配置其他配置

	配置<mvc:default-servlet-handler/>将所有拦截的请求进行判断
	将springMVC不能处理的请求，例如静态资源等，交由tomcat等web容器来处理

	配置<mvc:annotation-driven/>将开启注解驱动，默认支持默认的处理器映射器与
	处理器适配器，配置完此标签后，不用在单独配置处理器适配器与处理器映射器
	开启后，可以在代码中使用注解进行配置，并且可以实现一些高级功能如：
	JSR303校验，快捷的ajax...映射动态请求等。。。
	
1.9建立mybatis-config文件作为Mybatis的配置文件

  1.9.1配置mybatis-config.xml文件

	在配置文件中，设置settings标签的mapUnderscoreToCamelCase为true来使用驼峰命名规则
	在typeAliases中配置，指定po包名，来开启别名，之后的配置中就不用指定包全名而用别名来代替了

	<settings>
            <setting name="mapUnderscoreToCamelCase" value="true"/>
        </settings>
        <typeAliases>
            <package name="com.zhuhaoran.crud.po"/>
        </typeAliases>

  1.9.2配置mybatisGenerator文件用来配合mybatisGenerator插件生成类

    1.9.2.1引入Maven插件
	
	在pom.xml文件中引入插件实现mybatisGenerator的功能自动生成代码

	<plugins>
          <plugin>
            <groupId>org.mybatis.generator</groupId>
            <artifactId>mybatis-generator-maven-plugin</artifactId>
            <version>1.3.7</version>
            <configuration>
              <verbose>true</verbose>
              <overwrite>true</overwrite>
            </configuration>
          </plugin>
        </plugins>

	导入generator核心jar包

    1.9.2.2编写mybatisGenerator.xml文件

	按照mybatis官方文档中http://www.mybatis.org/generator/configreference/xmlconfig.html
	的实例xml配置自己的xml
	注意！！在使用Maven插件的情况下，需要将配置文件命名为generatorConfig.xml
	并将其放在main/resources下才能正常运行

	<generatorConfiguration>
	    <!--需要指定本地jdbc的jar包所在的路径-->
	    <classPathEntry location="C:\Users\15522\.m2\repository\mysql\mysql-connector-java\8.0.11\mysql-connector-java-8.0.11.jar"/>
	    <context id="DB2Tables" targetRuntime="MyBatis3">
		<!-- commentGenerator参数是否生成注释，true为不生成 -->
		<commentGenerator>
		    <property name="suppressDate" value="true"/>
		    <property name="suppressAllComments" value="true"/>
		</commentGenerator>
		<!--设置jdbc连接的相关参数-->
		<jdbcConnection driverClass="com.mysql.cj.jdbc.Driver"
				connectionURL="jdbc:mysql://localhost:3306/ssm?serverTimezone=GMT%2B8&amp;characterEncoding=utf-8&amp;useSSL=false"
				userId="root"
				password="961120">
		    <property name="useInformationSchema" value="true"/>
		</jdbcConnection>
		<!--设置生成Modle类的包名以及目标工程路径-->
		<javaModelGenerator targetPackage="com.zhuhaoran.crud.po"
				    targetProject=".\src\java">
		</javaModelGenerator>
		<!--设置生成Mapper接口的包名以及目标工程路径-->
		<sqlMapGenerator targetPackage="com.zhuhaoran.crud.mapper"
				 targetProject=".\src\java">
		</sqlMapGenerator>
		<!--设置生成Mapper.xml的包名以及目标工程路径-->
		<javaClientGenerator type="XMLMAPPER"
				     targetPackage="com.zhuhaoran.crud.mapper"
				     targetProject=".\src\java">
		</javaClientGenerator>
		<!--指定自动生成代码的表名以及生成后命名的规则-->
		<table tableName="tbl_emp" domainObjectName="Employee"></table>
		<table tableName="tbl_dept" domainObjectName="Department"></table>
	    </context>
	</generatorConfiguration>

	注意！！！在使用较新版本的jdbc驱动或mysql时，务必要在<jdbcConnection>中配置
	<property name="useInformationSchema" value="true"/>
	否则将无法生成select，insert，delete，update的ByPrimaryKey方法

2.开始编程

2.1根据需求，修改生成的mapper接口和mapper.xml

	由于需要某些特定的业务，往往会在自动生成的文件的基础上进行修改，以满足自己的需求
	例如本次查询员工时，需要联合查询部门信息，所以首先修改mapper接口，添加如下两个接口

	List<Employee> selectByExampleWithDept(EmployeeExample example);

        Employee selectByPrimaryKeyWithDept(Integer empId);

	在xml文件中，添加同名的两个查询语句

	  <select id="selectByExampleWithDept" parameterType="com.zhuhaoran.crud.po.EmployeeExample" resultMap="WithDeptResultMap">
	    select
	    <if test="distinct">
	      distinct
	    </if>
	    <include refid="Withdept_Column_List" />
	    from tbl_emp e
	    left join tbl_dept d
	    on e.'d_id' = d.'dept_id'
	    <if test="_parameter != null">
	      <include refid="Example_Where_Clause" />
	    </if>
	    <if test="orderByClause != null">
	      order by ${orderByClause}
	    </if>
	  </select>

	  <select id="selectByPrimaryKeyWithDept" parameterType="java.lang.Integer" resultMap="WithDeptResultMap">
	    select
	    <include refid="Withdept_Column_List" />
	    from tbl_emp e
	    left join tbl_dept d
	    on e.'d_id' = d.'dept_id'
	    where emp_id = #{empId,jdbcType=INTEGER}
	  </select>

        同时需要重写自带的动态sql代码端以及ResultMap

	  <resultMap id="WithDeptResultMap" type="com.zhuhaoran.crud.po.Employee">
	    <id column="emp_id" jdbcType="INTEGER" property="empId" />
	    <result column="emp_name" jdbcType="VARCHAR" property="empName" />
	    <result column="sex" jdbcType="CHAR" property="sex" />
	    <result column="email" jdbcType="VARCHAR" property="email" />
	    <result column="d_id" jdbcType="INTEGER" property="dId" />
	    <association property="department" javaType="com.zhuhaoran.crud.po.Department">
	      <id column="dept_id" property="deptId"/>
	      <result column="dept_name" property="deptName"/>
	    </association>
	  </resultMap>

	  <sql id="Withdept_Column_List">
	    e.emp_id, e.emp_name, e.sex, e.email, e.d_id, d.dept_id, d.dept_name
	  </sql>

2.2测试mybatis能否正常使用，准备正式编写程序
	
	编写Mapper的测试类，在类的前面加上 @RunWith(SpringJUnit4ClassRunner.class)
	表明使用Spring提供的测试，方便对测试中的springioc进行注入
	使用 @ContextConfiguration 注解，指定spring配置文件的路径
	@ContextConfiguration(locations = {"classpath:spring/applicationContext.xml"})
	使用 @Autowired 标签，将对象自动注入
	  @Autowired
          DepartmentMapper departmentMapper;
	  。。。
	之后直接使用mapper对象的方法，调用插入，查询等方法，验证环境搭建是否正确

	  departmentMapper.insertSelective(department1);

2.3编写首页分页显示所有员工信息的后端代码
	
	编写Service层，使用 @Service 注释，将service类加入bean中管理
	使用 @Autowired 注入mapper对象，调用查询方法返回一个Employee类型的List

	  public List<Employee> getAll() {
		return employeeMapper.selectByExampleWithDept(null);
	    }

	编写Controller层，使用 @Controller 表明是一个Controller
	使用 @Autowired 注入service对象，使用 @RequestMapping("/emps") 
	标明访问的URL

	编写获取员工列表的方法

	通过service的对象直接获取到员工信息的List
	此时的数据还做不到分页，需要引入分页，首先规定前端传过来一个页码信息
	通过在方法的参数列表中加入注解
	@RequestParam(value = "page_num",defaultValue = "1") Integer page_num
	获取到前端传来的页码信息，同时配置了在没有传过来信息时，默认值为1
	同时在参数中加入Model，可以在方法中添加回调的Model对象

	需要使用PageHelper包来进行分页的处理
	详细内容参见作者的GitHub中的帮助文档
	https://github.com/pagehelper/Mybatis-PageHelper
	首先要添加jar包到项目中，在pom.xml文件中添加如下内容

	    <dependency>
	      <groupId>com.github.pagehelper</groupId>
	      <artifactId>pagehelper</artifactId>
	      <version>5.0.0</version>
	    </dependency>
	
	会自动添加pagehelper.jar以及依赖的jsqlparser.jar包
	之后在mybatis配置文件中配置插件

	    <plugins>
		<plugin interceptor="com.github.pagehelper.PageInterceptor">
		</plugin>
	    </plugins>

	注意！！！<plugins>标签务必要加在<typeAliases>别名标签后边，否则要报错
	之后就可以使用了，在Controller中，使用PageHelper.startPage()方法调用分页插件
	其中两个参数为当前页码以及每一页所容纳的条目数量，在使用时，要紧接着PageHelper
	后面调用获取员工信息的方法，这个方法为分页查询的方法，将结果存在List中，如下所示

		PageHelper.startPage(page_num,5);
		List<Employee> emps = employeeService.getAll();

	为了方便使用，在前端显示页码的相关信息，定义PageInfo对象，来存放查询到的List

		PageInfo pageInfo = new PageInfo(emps,5);

	第一个参数为List，第二个参数为每次显示页码导航的数量，最后使用addAttribute()
	方法将pageInfo放到Model中，return要访问的前端页面，之后交给前端控制器来处理

	完整Controller如下

	@Controller
	public class EmployeeController {
	    @Autowired
	    EmployeeService employeeService; 
	    @RequestMapping("/emps")
	    public String getEmps(@RequestParam(value = "page_num",defaultValue = "1") Integer page_num , Model model){
		PageHelper.startPage(page_num,5);
		List<Employee> emps = employeeService.getAll();
		PageInfo pageInfo = new PageInfo(emps,5);
		model.addAttribute("pageInfo",pageInfo);
		return "list";}}

2.4使用Spring测试分页是否正常

	编写测试类，通过MockMvc对象来获取虚拟Mvc的请求
	首先要使用注解方式开启测试的支持，使用如下注解

	@RunWith(SpringJUnit4ClassRunner.class)
	@WebAppConfiguration
	@ContextConfiguration(locations = {"classpath:spring/applicationContext.xml",
	"classpath:spring/springmvc.xml"})

	@RunWith指定为Spring测试环境
	@WebAppConfiguration开始web测试
	@ContextConfiguration分别配置了spring的配置文件和mvc的配置文件，用逗号隔开

	创建MockMvc对象，创建WebApplicationContext对象并使用 @Autowired自动注入
	使用 mockMvc = MockMvcBuilders.webAppContextSetup(context).build();
	得到一个mockMvc对象实例，使用
	MvcResult result = mockMvc.perform(MockMvcRequestBuilders.get("/emps").param("page_num","1"))
                .andReturn();
	方法，向控制器请求一个/emps地址，并且带有参数page_num的值为1的请求，并得到一个
	MvcResult类型的返回值
	使用MockHttpServletRequest request = result.getRequest();
	得到一个request，使用request的getAttribute方法得到PageInfo对象，通过
	Debug看到内部存在数据，测试完成

2.5搭建Bootstrap的前端分页页面

	参见Bootstrap中文网上的文档编写web前端页面 http://www.bootcss.com/
	之后使用EL表达式取出员工列表数据${pageInfo.list}，取出分页信息${pageInfo}

2.6为了适应多端，改造成使用json传递数据使用ajax查询

	首先使用maven导入json相关的jar包

	    <dependency>
	      <groupId>com.fasterxml.jackson.core</groupId>
	      <artifactId>jackson-databind</artifactId>
	      <version>2.9.6</version>
	    </dependency>

	之后使用 @ResponseBody 标签，表示方法返回时会包装为json对象
	其余方法与返回view的方法相同，不同的是，为了多平台，不再返回view和model
	创建包装类包装需要返回的数据，直接返回，在添加了 @ResponseBody注解的情况下
	会自动转换为json格式

	创建信息包装类Msg

	    private int code;
	    private String msg;
	    private Map<String,Object> extend = new HashMap<String, Object>();

	带有三条属性，分别存放提示码，提示信息和存放数据的map对象
	类中还包含这三条属性的getter方法和setter方法
	包含success和fail的静态方法，用来返回成功或错误信息，
	add方法使用键值对的方法，将数据保存到map中，再由json提供的方法
	转换为json的形式。

2.7使用Bootstrap搭建前端页面，配合ajax发送请求，解析json数据，并显示

	具体见代码

2.8继续完善增删该查功能以及校验功能


	



	

	
