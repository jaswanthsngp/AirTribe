--
-- PostgreSQL database dump
--

-- Dumped from database version 15.3
-- Dumped by pg_dump version 15.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: role; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.role AS ENUM (
    'student',
    'instructor',
    'admin'
);


ALTER TYPE public.role OWNER TO postgres;

--
-- Name: status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.status AS ENUM (
    'accepted',
    'rejected',
    'wait list'
);


ALTER TYPE public.status OWNER TO postgres;

--
-- Name: hash_pwd(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.hash_pwd() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
	begin
		NEW.pwd := sha256(NEW.pwd);
		return NEW;
	end;
$$;


ALTER FUNCTION public.hash_pwd() OWNER TO postgres;

--
-- Name: valid_instructor(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.valid_instructor(uid integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
begin
	return 'instructor' in (select role from users where id = uid);
end;
$$;


ALTER FUNCTION public.valid_instructor(uid integer) OWNER TO postgres;

--
-- Name: valid_student(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.valid_student(uid integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
	begin
		return 'student' in (select role from users where id = uid);
	end;
$$;


ALTER FUNCTION public.valid_student(uid integer) OWNER TO postgres;

--
-- Name: validate_login(character varying, bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.validate_login(mail character varying, pass bytea) RETURNS integer
    LANGUAGE plpgsql
    AS $$
	begin
		if sha256(pass) in (select pwd from users where email = mail) then
            return id from users where email = mail;
        else
            return NULL;
        end if;
	end;
$$;


ALTER FUNCTION public.validate_login(mail character varying, pass bytea) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: courses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.courses (
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


ALTER TABLE public.courses OWNER TO postgres;

--
-- Name: courses_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.courses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.courses_id_seq OWNER TO postgres;

--
-- Name: courses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.courses_id_seq OWNED BY public.courses.id;


--
-- Name: leads; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.leads (
    id integer NOT NULL,
    student_id integer NOT NULL,
    course_id integer NOT NULL,
    status public.status DEFAULT 'wait list'::public.status,
    comment character varying,
    CONSTRAINT leads_student_id_check CHECK (public.valid_student(student_id))
);


ALTER TABLE public.leads OWNER TO postgres;

--
-- Name: lead_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.lead_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.lead_id_seq OWNER TO postgres;

--
-- Name: lead_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.lead_id_seq OWNED BY public.leads.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    name character varying NOT NULL,
    pwd bytea NOT NULL,
    email character varying NOT NULL,
    linkedin character varying NOT NULL,
    role public.role NOT NULL,
    CONSTRAINT mail_valid CHECK (((email)::text ~* '^[A-Za-z0-9.-_]+@[A-Za-z]+[.][A-Za-z]+$'::text))
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: courses id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.courses ALTER COLUMN id SET DEFAULT nextval('public.courses_id_seq'::regclass);


--
-- Name: leads id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leads ALTER COLUMN id SET DEFAULT nextval('public.lead_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: courses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.courses (id, course_name, start_date, end_date, no_of_hours, max_seats, instructor) FROM stdin;
3	course 1	2024-03-01	2024-03-09	45	25	3
4	course 2	2024-03-08	2024-03-09	24	63	3
5	course 3	2024-03-09	2024-03-14	24	63	3
11	course 4	2024-03-09	2024-03-10	24	63	3
12	course 4	2024-03-09	2024-03-10	24	63	3
14	course 4	2024-03-09	2024-03-10	24	63	3
7	course 4	2024-03-10	2024-03-12	24	63	3
8	course 5	2024-03-09	2024-03-10	24	63	3
9	course 4	2024-03-09	2024-03-10	93	63	3
10	course 4	2024-03-09	2024-03-10	24	50	3
\.


--
-- Data for Name: leads; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.leads (id, student_id, course_id, status, comment) FROM stdin;
1	2	3	wait list	\N
4	2	7	wait list	\N
2	2	5	accepted	\N
3	2	5	rejected	duplicate entry
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, name, pwd, email, linkedin, role) FROM stdin;
2	abc	\\xa665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3	abc@email.com	abc	student
3	def	\\xa665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3	def@email.com	def	instructor
\.


--
-- Name: courses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.courses_id_seq', 14, true);


--
-- Name: lead_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.lead_id_seq', 4, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 4, true);


--
-- Name: courses courses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_pkey PRIMARY KEY (id);


--
-- Name: leads lead_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leads
    ADD CONSTRAINT lead_pkey PRIMARY KEY (id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_linkedin_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_linkedin_key UNIQUE (linkedin);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: courses_course_name_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX courses_course_name_idx ON public.courses USING btree (course_name);


--
-- Name: users hash_pwd; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER hash_pwd BEFORE INSERT OR UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION public.hash_pwd();


--
-- Name: courses courses_instructor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_instructor_fkey FOREIGN KEY (instructor) REFERENCES public.users(id);


--
-- Name: leads fk_course_lead; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leads
    ADD CONSTRAINT fk_course_lead FOREIGN KEY (course_id) REFERENCES public.courses(id);


--
-- Name: leads fk_student_lead; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leads
    ADD CONSTRAINT fk_student_lead FOREIGN KEY (student_id) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

