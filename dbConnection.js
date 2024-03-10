const { Client } = require('pg');
const dotenv = require('dotenv')
dotenv.config();

let client = null;

const connectDB = async () => {
    try {
        client = new Client({
            user: process.env.PGUSER,
            host: process.env.PGHOST,
            password: process.env.PGPASSWORD,
            database: process.env.PGDATABASE,
            port: process.env.PGPORT
        });
        await client.connect();
        console.log((await client.query("SELECT 'Connection Eshtablished'")).rows);
    } catch(error) {
        console.error(error);
    }
}

connectDB();

const signUp = async (name, pwd, email, linkedin, role) => {
    // insert into users(name, pwd, email, linkedin, role) values('abc', '123', 'abc@email.com', 'abc', 'student');
    let x = await client.query({
        text: "insert into users(name, pwd, email, linkedin, role) values($1, $2, $3, $4, $5) returning id",
        values: [name, pwd, email, linkedin, role]
    });
    console.log(x.rows[0]['id']);
    return x.rows[0]['id'];
}

// signUp('abc','123','abc@email.com','abc','student');
// signUp('def','123','def@email.com','def','instructor');

const login = async (email, pwd) => {
    let x = await client.query(`select validate_login('${email}', '${pwd}')`);
    // console.log(x);
    // console.log(x.rows[0]['validate_login']);
    return x.rows[0]['validate_login'];
}

// login('def@email.com', '123');

const createCourse = async (name, start, end, duration, capacity, instructor) => {
    let x = await client.query({
        text: "insert into courses(course_name, start_date, end_date, no_of_hours, max_seats, instructor) values ($1, date($2), date($3), $4, $5, $6) returning id",
        values: [name, start, end, duration, capacity, instructor]
    });
    // console.log(x.rows[0]['id']);
    return x.rows[0]['id'];
}

// createCourse('course 4', new Date(Date.now()), '2024-03-10', 24, 63, 3);

const updateCourse = async (id, field, value) => {
    let x;
    if(field === 'start' || field === 'end') {
        x = await client.query(`update courses set ${field}_date = date('${value}') where id = ${id}`);
    } else if(field === 'name') {
        x = await client.query(`update courses set course_name = '${value}' where id = ${id}`);
    } else if(field === 'duration') {
        x = await client.query(`update courses set no_of_hours = ${parseInt(value)} where id = ${id}`);
    } else if(field === 'capacity') {
        x = await client.query(`update courses set max_seats = ${parseInt(value)} where id = ${id}`);
    }
    // console.log(x.rowCount);
    if(x.rowCount>0)
        return true;
    return false;
}

// updateCourse(7, 'end', '2024-03-12');
// updateCourse(7, 'start', '2024-03-10');
// updateCourse(8, 'name', 'course 5');
// updateCourse(9, 'duration', '93');
// updateCourse(10, 'capacity', '50');

const registerForACourse = async (student_id, course_id) => {
    let x = await client.query(`insert into leads(student_id, course_id) values(${student_id}, ${course_id}) returning id`);
    // console.log(x.rows[0]['id']);
    return x.rows[0]['id'];
}

// registerForACourse(2, 3);

const updateLeadStatus = async (id, status) => {
    let x = await client.query(`update leads set status = '${status}' where id = ${id}`);
    // console.log(x.rowCount);
    if(x.rowCount>0)
        return true;
    return false;
}

// updateLeadStatus(2, 'accepted');
// updateLeadStatus(3, 'rejected');

const addComment = async (id, comment) => {
    let x = await client.query(`update leads set comment = '${comment}' where id = ${id}`);
    // console.log(x.rowCount);
    if(x.rowCount>0)
        return true;
    return false;
}

// addComment(3, 'duplicate entry');

const searchByName = async (name) => {
    let x = await client.query(`select * from leads where student_id in (select id from users where name like '%${name}%')`);
    // console.log(x.rows);
    return x.rows;
}

// searchByName('b');

const searchByEmail = async (mail) => {
    let x = await client.query(`select * from leads where student_id in (select id from users where email like '%${mail}%')`);
    // console.log(x.rows);
    return x.rows;
}

// searchByEmail('b');

module.exports = {signUp, login, createCourse, updateCourse, registerForACourse, updateLeadStatus, addComment, searchByName, searchByEmail}
