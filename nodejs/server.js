const http = require('http')
const mysql = require('mysql')

// DB connection
var conn = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: 'password',
  database: 'nodejsdb'
});

// server 생성 및 DB select
http.createServer( (req, res) => {
  conn.query('select * from users ', (err, results, fields) =>{
    // users table의 모든 데이터를 조회하여 console에 출력하는 코드.
    if(err) throw err;
    console.log(results);
    res.end();
  });
}).listen(8001, () => {
  console.log('8001 : server start!');
});