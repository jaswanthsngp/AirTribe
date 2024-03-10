# AirTribe Internship Assessment - Backend

## Problem Statement
Design a Database and APIs application based courses on AirTribe.

### Database Relations
Any SQL Database is accepted
- There are multiple instructors on airtribe
- Every instructor can start multiple courses
- Multiple learners can apply for a course using application form (leads)
- Instructor can add comments against any lead

### APIs
Create server in any of framework using Node.js and add following APIs
- Create Course
- Update Course Details (name, max_seats, start_date, etc)
- Course Registration (params: course_id, student_token)
- Lead update API (Instructor can change the status of Lead(Accepted, Rejected, Waitlist))
- Lead search API (Instructor can search lead by name / email)
- Add comment on Lead

## How to Submit
- (Good to have) Dockerize your server and Database
- Mention the following in README
    - Docker Commands or Script(s) to spin up the environment
    - A script to load test data

## Judging Parameters
- Code Quality (Clean, Readable, Easy to follow)
- Language specific best practices
- Modularity
- README and Git commits
