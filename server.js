const db = require('./dbConnection')
const express = require('express');
let bodyParser= require('body-parser');
const app = express();
const port = 3000;

// Request parser
app.use(bodyParser.urlencoded({extended: false}));

// Logger
app.use((req, res, next) => {
    console.log(`${req.method} ${req.path} - ${req.ip}`);
    next();
})

// home page
app.get('/', (req, res) => {
    res.sendFile(__dirname+'/views/index.html');
})

// login form
app.post('/login', async (req, res) => {
    // email, pwd
    let x = await db.login(req.body.email, req.body.pwd);
    if(x===null) {
        res.json({success: false});
        return;
    }
    res.json({success: true, id: x})
});

// signup form
app.post('/signup', async (req, res) => {
    // name, pwd, email, linkedin, role
    let x = await db.login(req.body.name, req.body.pwd, req.body.email, req.body.linkedin, req.body.role);
    if(x===null) {
        res.json({success: false});
        return;
    }
    res.json({success: true, id: x});
});

app.post('/create-course', async(req, res) => {
    // name, start, end, duration, capacity, instructor
    let x = await db.createCourse(req.body.name, req.body.start, req.body.end, req.body.duration, req.body.capacity, req.body.instructor);
    if(x===null) {
        res.json({success: false});
        return;
    }
    res.json({success: true, id: x});
});

app.post('/update-course', async(req, res) => {
    // id, field, newvalue
    let x = await db.updateCourse(req.body.id, req.body.field, req.body.newvalue);
    res.json({success: x});
})

app.post('/enroll', async(req, res) => {
    // student_id, course_id
    let x = await db.registerForACourse(req.body.student, req.body.course);
    if(x===null) {
        res.json({success: false});
        return;
    }
    res.json({success: true, id: x});
});

app.post('/update-lead', async(req, res) => {
    // lead_id, status
    let x = await db.updateLeadStatus(req.body.lead, req.body.status);
    res.json({success: x});
});

app.post('/comment', async(req, res) => {
    // lead_id, comment
    let x = await db.addComment(req.body.lead, req.body.comment);
    res.json({success: x});
});

app.get('/search', async(req, res) => {
    // field (email/name), term
    let x;
    if(req.body.field === 'email')
        x = await db.searchByEmail(req.body.term);
    else
        x = await db.searchByName(req.body.term);
    res.json(x);
})

app.listen(port, () => {
    console.log(db);
    console.log(`Express App started on port ${port}`);
});
