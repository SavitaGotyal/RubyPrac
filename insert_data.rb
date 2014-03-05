#!/usr/bin/ruby
$LOAD_PATH.unshift("/usr/local/rvm/gems/ruby-1.9.3-p484/gems/ruby-mysql-2.9.12/lib")
$LOAD_PATH.unshift("/usr/local/rvm/gems/ruby-1.9.3-p484/extensions/x86-linux/1.9.1/rmagick-2.13.2")
$LOAD_PATH.unshift("/usr/local/rvm/gems/ruby-1.9.3-p484/gems/rmagick-2.13.2/lib")
$LOAD_PATH.unshift("/usr/local/rvm/gems/ruby-1.9.3-p484/gems/rmagick-2.13.2/ext")
$LOAD_PATH.unshift("/usr/local/rvm/gems/ruby-1.9.3-p484/gems/gruff-0.5.1/lib")
require 'gruff'
require 'mysql'
require 'cgi'
log=File.open("log.txt","a")


#log.syswrite("")

cgi = CGI.new
puts cgi.header
g = Gruff::Bar.new
file =cgi["file"]
if(file == '')
  log.syswrite("File not selected")

#Read the file and store value in array
else
   arr = IO.readlines(file)	
   len =arr.size
end

begin
#create table and insert values into the table
con = Mysql.new 'localhost', 'savita', 'savita' ,'Assignment'
if(con == '')
    log.syswrite("Something wrong sql connection is not created.")
else	
    con.query("DROP TABLE IF  EXISTS Report")
    con.query("CREATE TABLE IF NOT EXISTS \
        Report(Id INT PRIMARY KEY AUTO_INCREMENT, Client_Name VARCHAR(50),raw INT,raw_inprocess INT,raw_completed           INT,processed INT,processed_uploading INT,processed_completed INT)")

    for i in (1...len)
	v=arr[i].split(",")
	
	con.query("INSERT INTO Report(Client_Name,raw,raw_inprocess,raw_completed,processed,processed_uploading,processed_completed) VALUES('#{v[0]}','#{v[1]}','#{v[2]}','#{v[3]}','#{v[4]}','#{v[5]}','#{v[6]}')")
    end




    rs=con.query("SELECT * FROM Report")
    if(rs != '')
       puts "<html><body>"
       puts "<form action=\"draw_graph.rb \" target=\"frame3\" enctype=\"multipart/form-data\">"
       (0...rs.num_rows).each do |i|
      		fields= rs.fetch_row
		puts "<div id=\"client_name\">"
      		puts "<input type='submit' value='#{fields[1]}' name = 'client_name'></input>"  
		puts "</div>" 
       end  
       puts "</form>"   
       puts "</body></html>"

   else
       log.syswrite("Query not executed properly")
   end
end
rescue Mysql::Error => e
    puts e.errno
    puts e.error
    
ensure
    con.close if con
end

