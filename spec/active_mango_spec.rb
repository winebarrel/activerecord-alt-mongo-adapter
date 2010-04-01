require 'rubygems'
require 'active_record'
require 'active_mongo/collection'
require 'mongo' # for test

# global setup  ###############################################################

Mongo::Connection.new.drop_database('scott')
ActiveRecord::Base.establish_connection(:adapter  => 'mongo', :database => 'scott')

# spec ########################################################################

describe ActiveMongo do
  before do
    Emp.setup
    Dept.setup
  end

  it 'EMP: find(:all)' do
    emps = Emp.find(:all).sort_by {|i| i.empno }
    emps.length.should == Emp::DATA.length

    emps.each_with_index do |emp, i|
      emp.should == Emp::DATA[i]
    end
  end

  it 'DEPT: find(:all)' do
    depts = Dept.find(:all).sort_by {|i| i.deptno }
    depts.length.should == Dept::DATA.length

    depts.each_with_index do |dept, i|
      dept.should == Dept::DATA[i]
    end
  end

  it 'EMP: count' do
    Emp.count.should == Emp::DATA.length
  end

  it 'DATA: count' do
    Dept.count.should == Dept::DATA.length
  end

  it 'EMP: count with cond' do
    Emp.count(:conditions => ['job = ?', 'MANAGER']).should == Emp::DATA.select {|i| i['job'] == 'MANAGER' }.length
  end

  it 'DATA: count with cond' do
    Dept.count(:conditions => ['deptno >= ?', 30]).should == Dept::DATA.select {|i| i['deptno'] >= 30 }.length
  end

  it 'EMP: order asc' do
    emps = Emp.find(:all, :conditions => {:job => 'MANAGER'}, :order => 'sal')
    expected = Emp::DATA.select {|i| i['job'] == 'MANAGER' }.sort_by {|i| i['sal'] }
    emps.map {|i| i['empno'] }.should == expected.map {|i| i['empno'] }

    emps = Emp.find(:all, :conditions => {:job => 'SALESMAN'}, :order => 'sal asc')
    expected = Emp::DATA.select {|i| i['job'] == 'SALESMAN' }.sort_by {|i| i['sal'] }
    emps.map {|i| i['empno'] }.should == expected.map {|i| i['empno'] }
  end

  it 'DATA: order desc' do
    depts = Dept.find(:all, :order => 'deptno desc')
    expected = Dept::DATA.sort_by {|i| i['deptno'] }.reverse
    depts.map {|i| i['deptno'] }.should == expected.map {|i| i['deptno'] }
  end

  after do
    Emp.teardown
    Dept.teardown
  end
end

# model #######################################################################

class Emp < ActiveRecord::Base
  include ActiveMongo::Collection

  NAMES = %w(empno ename job mgr hiredate sal comm deptno)

  DATA = [
    [7369, 'SMITH'       , 'CLERK'          , 7902, '17-DEC-1980',  800.0,    nil,  20],
    [7499, 'ALLEN'       , 'SALESMAN'       , 7698, '20-FEB-1981', 1600.0,  300.0,  30],
    [7521, 'WARD'        , 'SALESMAN'       , 7698, '22-FEB-1981', 1250.0,  500.0,  30],
    [7566, 'JONES'       , 'MANAGER'        , 7839, '2-APR-1981' , 2975.0,    nil,  20],
    [7654, 'MARTIN'      , 'SALESMAN'       , 7698, '28-SEP-1981', 1250.1, 1400.0,  30],
    [7698, 'BLAKE'       , 'MANAGER'        , 7839, '1-MAY-1981' , 2850.0,    nil,  30],
    [7782, 'CLARK'       , 'MANAGER'        , 7839, '9-JUN-1981' , 2450.0,    nil,  10],
    [7788, 'SCOTT'       , 'ANALYST'        , 7566, '09-DEC-1982', 3000.0,    nil,  20],
    [7839, 'KING'        , 'PRESIDENT'      ,  nil, '17-NOV-1981', 5000.0,    nil,  10],
    [7844, 'TURNER'      , 'SALESMAN'       , 7698, '8-SEP-1981' , 1500.0,    0.0,  30],
    [7876, 'ADAMS'       , 'CLERK'          , 7788, '12-JAN-1983', 1100.0,    nil,  20],
    [7900, 'JAMES'       , 'CLERK'          , 7698, '3-DEC-1981' ,  950.0,    nil,  30],
    [7902, 'FORD'        , 'ANALYST'        , 7566, '3-DEC-1981' , 3000.0,    nil,  20],
    [7934, 'MILLER'      , 'CLERK'          , 7782, '23-JAN-1982', 1300.0,    nil,  10],
  ].map {|i| Hash[*NAMES.zip(i).flatten] }

  def self.setup
    db = connection.raw_connection
    coll = db.collection(table_name)
    DATA.each {|doc| coll.insert(doc) }
  end

  def self.teardown
    db = connection.raw_connection
    db.drop_collection(table_name)
  end

  def ==(obj)
    NAMES.all? do |name|
      self.send(name) == obj[name] and self[name] == obj[name]
    end
  end
end

class Dept < ActiveRecord::Base
  include ActiveMongo::Collection

  NAMES = %w(deptno dname loc)

  DATA = [
    [10, 'ACCOUNTING', 'NEW YORK'],
    [20, 'RESEARCH'  , 'DALLAS'  ],
    [30, 'SALES'     , 'CHICAGO' ],
    [40, 'OPERATIONS', 'BOSTON'  ],
  ].map {|i| Hash[*NAMES.zip(i).flatten] }

  def self.setup
    db = connection.raw_connection
    coll = db.collection(table_name)
    DATA.each {|doc| coll.insert(doc) }
  end

  def self.teardown
    db = connection.raw_connection
    db.drop_collection(table_name)
  end

  def ==(obj)
    NAMES.all? do |name|
      self.send(name) == obj[name] and self[name] == obj[name]
    end
  end
end
