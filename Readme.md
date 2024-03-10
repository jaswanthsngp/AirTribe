# Online Courses Appliation

An application built to maintain a learning system which allows students to enroll 
into courses created and updated by students and instructor to accept or reject
enrollment applications submitted by the students.

## Database

The database consists of the following schemas to store the data

Users Schema
```sql
TABLE public.users (
    id integer NOT NULL,
    name character varying NOT NULL,
    pwd bytea NOT NULL,
    email character varying NOT NULL,
    linkedin character varying NOT NULL,
    role public.role NOT NULL,
    CONSTRAINT mail_valid CHECK (((email)::text ~* '^[A-Za-z0-9.-_]+@[A-Za-z]+[.][A-Za-z]+$'::text))
);
```
where the password is stored in a hashed format with the help of a trigger, and the role is restricted to
three values 'student','instructor' and 'admin' by using a enumerated data type.

Courses Schema
```sql
TABLE public.courses (
    id integer NOT NULL,
    course_name character varying NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    no_of_hours integer NOT NULL,
    max_seats integer NOT NULL,
    instructor integer NOT NULL,
    CONSTRAINT courses_instructor_check CHECK (public.valid_instructor(instructor)),
    CONSTRAINT valid_date CHECK ((end_date > start_date))
);
```
Where the courses can only be created by the instructors with a valid date range.

Leads Schema
```sql
TABLE public.leads (
    id integer NOT NULL,
    student_id integer NOT NULL,
    course_id integer NOT NULL,
    status public.status DEFAULT 'wait list'::public.status,
    comment character varying,
    CONSTRAINT leads_student_id_check CHECK (public.valid_student(student_id))
);
```
Where the status field is limited to three values 'accepted', 'rejected' and 'wait list' using
an enum is defaulted to 'wait list' and courses can only be enrolled by students

Note: For more details about the database, you can check `db.sql` file

## Application

The application is divided into two files, one for handling the database and one for APIs.

The database file `dbConnection` contains a script using `pg` library to connect to the database,
along with some methods which query the database using SQL commands, and return appropriate results.

The API file `server.js` uses express.js to connect to the internet, and contains the APIs to 
login, signup, create and update courses, and leads repectively, and uses the methods in dbConnection
to update the data.

An HTML file is used to simplify testing the APIs

## Starting Scripts

- Make sure you have PostgreSQL and NodeJS installed on your system
- Use `pg_restore -d db_name db.sql` to initialize the database with schemas and test values
- Create a `.env` file in the directory with the following data
    ```
    PGUSER=<user_name>
    PGHOST=<host_name>
    PGPASSWORD=<password>
    PGDATABASE=<db_name>
    PGPORT=<port>
    ```
- Install the reuqired libraries using `npm install` command
- Run `npm start` to run the project.
