--
-- PostgreSQL database dump
--

-- Dumped from database version 17.5 (Debian 17.5-1.pgdg120+1)
-- Dumped by pg_dump version 17.5 (Debian 17.5-1.pgdg120+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: customers; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.customers (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    image_url character varying(255) NOT NULL
);


ALTER TABLE public.customers OWNER TO delvauxo;

--
-- Name: invoices; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.invoices (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    customer_id uuid NOT NULL,
    amount integer NOT NULL,
    status character varying(255) NOT NULL,
    date date NOT NULL
);


ALTER TABLE public.invoices OWNER TO delvauxo;

--
-- Name: revenue; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.revenue (
    month character varying(4) NOT NULL,
    revenue integer NOT NULL
);


ALTER TABLE public.revenue OWNER TO delvauxo;

--
-- Name: users; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.users (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying(255) NOT NULL,
    email text NOT NULL,
    password text NOT NULL
);


ALTER TABLE public.users OWNER TO delvauxo;

--
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.customers (id, name, email, image_url) FROM stdin;
d6e15727-9fe1-4961-8c5b-ea44a9bd81aa	Evil Rabbit	evil@rabbit.com	/customers/evil-rabbit.png
3958dc9e-712f-4377-85e9-fec4b6a6442a	Delba de Oliveira	delba@oliveira.com	/customers/delba-de-oliveira.png
3958dc9e-742f-4377-85e9-fec4b6a6442a	Lee Robinson	lee@robinson.com	/customers/lee-robinson.png
76d65c26-f784-44a2-ac19-586678f7c2f2	Michael Novotny	michael@novotny.com	/customers/michael-novotny.png
cc27c14a-0acf-4f4a-a6c9-d45682c144b9	Amy Burns	amy@burns.com	/customers/amy-burns.png
13d07535-c59e-4157-a011-f8d2ef4e0cbb	Balazs Orban	balazs@orban.com	/customers/balazs-orban.png
\.


--
-- Data for Name: invoices; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.invoices (id, customer_id, amount, status, date) FROM stdin;
dc484d8a-7ba5-4e03-8e0a-95cb23482ac5	d6e15727-9fe1-4961-8c5b-ea44a9bd81aa	15795	pending	2022-12-06
e7bc1e7c-490c-4f35-8706-332051e506b0	3958dc9e-712f-4377-85e9-fec4b6a6442a	20348	pending	2022-11-14
bef55b25-24d2-4f6c-9f6b-dd1d046061c0	cc27c14a-0acf-4f4a-a6c9-d45682c144b9	3040	paid	2022-10-29
67249c3c-35ba-4ce1-9e89-936cc62ccbc8	13d07535-c59e-4157-a011-f8d2ef4e0cbb	34577	pending	2023-08-05
685eda9b-7224-4885-a558-0be2e265b4f2	3958dc9e-742f-4377-85e9-fec4b6a6442a	54246	pending	2023-07-16
d5f40919-80bf-4c5a-ade0-858068fc222d	d6e15727-9fe1-4961-8c5b-ea44a9bd81aa	666	pending	2023-06-27
eee349e5-f0b9-443c-9403-ae6d4c96425b	76d65c26-f784-44a2-ac19-586678f7c2f2	32545	paid	2023-06-09
dda22303-92a0-41ce-90e9-b89ebdcfab2a	cc27c14a-0acf-4f4a-a6c9-d45682c144b9	1250	paid	2023-06-17
c509d91f-d763-4ac8-90ce-f0acd2f4c174	13d07535-c59e-4157-a011-f8d2ef4e0cbb	8546	paid	2023-06-07
90e746aa-0df6-4479-85ad-8c6149f2448c	3958dc9e-712f-4377-85e9-fec4b6a6442a	500	paid	2023-08-19
129aa3da-4485-4d43-b684-ed99996bcec2	13d07535-c59e-4157-a011-f8d2ef4e0cbb	8945	paid	2023-06-03
57d36e6a-9df0-4aca-a713-fa08f577375d	3958dc9e-742f-4377-85e9-fec4b6a6442a	1000	paid	2022-06-05
51450f0f-057c-419e-b477-fba1b5e51adf	76d65c26-f784-44a2-ac19-586678f7c2f2	44800	paid	2023-09-10
\.


--
-- Data for Name: revenue; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.revenue (month, revenue) FROM stdin;
Jan	2000
Feb	1800
Mar	2200
Apr	2500
May	2300
Jun	3200
Jul	3500
Aug	3700
Sep	2500
Oct	2800
Nov	3000
Dec	4800
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.users (id, name, email, password) FROM stdin;
410544b2-4001-4271-9855-fec4b6a6442a	User	user@nextmail.com	123456
\.


--
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (id);


--
-- Name: invoices invoices_pkey; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_pkey PRIMARY KEY (id);


--
-- Name: revenue revenue_month_key; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.revenue
    ADD CONSTRAINT revenue_month_key UNIQUE (month);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: invoices invoices_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

