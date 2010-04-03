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

  it 'EMP: find multi cond' do
    emps = Emp.find(:all, :conditions => ['job = ? and deptno > ?', 'MANAGER', 10], :order => 'empno')
    expected = Emp::DATA.select {|i| i['job'] == 'MANAGER' and i['deptno'] > 10 }
    emps.length.should == expected.length
    emps.map {|i| i['empno'] }.should == expected.map {|i| i['empno'] }
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

  it 'EMP: find limit' do
    emps = Emp.find(:all, :limit => 5)
    emps.length.should == 5
  end

  it 'DEPT: find limit' do
    depts = Dept.find(:all, :limit => 3)
    depts.length.should == 3
  end

  it 'EMP: find limit sort' do
    emps = Emp.find(:all, :conditions => {:job => 'MANAGER'}, :limit => 2, :order => 'empno desc')
    expected = Emp::DATA.select {|i| i['job'] == 'MANAGER' }.sort_by {|i| i['empno'] }.reverse.slice(0, 2)
    emps.map {|i| i['empno'] }.should == expected.map {|i| i['empno'] }
  end

  it 'DEPT: count limit' do
    Dept.count(:limit => 2).should == 2
  end

  it 'EMP: save' do
    emp = Emp.find(:first, :conditions => ["empno = 7782"])
    emp.should_not be_nil

    emp.job = 'ANALYST'
    emp.age = 48
    emp.save.should be_true

    emps = Emp.find(:all, :conditions => ["age = 48"])
    emps.length.should == 1
    emps[0].should_not be_nil
    emps[0].empno.should == 7782
    emps[0]['job'].should == 'ANALYST'
    emps[0].age.should == 48
  end

  it 'DATA: update all' do
    Dept.update_all('age = 20', ['deptno >= ?', 20])

    Dept.find(:all).each do |dept|
      if dept.deptno >= 20
        dept.age.should == 20
      end
    end
  end

  it 'EMP: destoroy' do
    emp = Emp.find(:first, :conditions => ["empno = 7566"])
    emp.destroy

    emps = Emp.find(:all, :order => 'empno')
    expected = Emp::DATA.select {|i| i['empno'] != 7566 }
    emps.length.should == expected.length

    emps.each_with_index do |emp, i|
      emp.should == expected[i]
      emp.empno.should_not == 7566
    end
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
