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
f3c8a224-5fca-46f4-97d5-bf565e7e7e55	d6e15727-9fe1-4961-8c5b-ea44a9bd81aa	15795	pending	2022-12-06
dc9896a0-7b0c-4cdb-8cbe-c767d3fb7202	3958dc9e-712f-4377-85e9-fec4b6a6442a	20348	pending	2022-11-14
9eaeb1ec-1d04-4f07-9dcb-6765ca081872	cc27c14a-0acf-4f4a-a6c9-d45682c144b9	3040	paid	2022-10-29
360f78ac-27a8-4c17-bd43-39bd5be6bbd7	76d65c26-f784-44a2-ac19-586678f7c2f2	44800	paid	2023-09-10
b57906e5-2680-4817-9b68-5f14a0111ee8	13d07535-c59e-4157-a011-f8d2ef4e0cbb	34577	pending	2023-08-05
2900efc6-c6d3-4dfd-8328-ec8f9f5e0b7b	3958dc9e-742f-4377-85e9-fec4b6a6442a	54246	pending	2023-07-16
61df43a6-7ec4-4c4c-996b-747943841243	d6e15727-9fe1-4961-8c5b-ea44a9bd81aa	666	pending	2023-06-27
0e03cd4a-5e0f-4c62-a8b1-266b88a05b26	76d65c26-f784-44a2-ac19-586678f7c2f2	32545	paid	2023-06-09
0ebef2c1-e771-464b-aad1-8f803b7725ad	cc27c14a-0acf-4f4a-a6c9-d45682c144b9	1250	paid	2023-06-17
1e7464af-deaa-45ac-9bbd-84754e9e8774	13d07535-c59e-4157-a011-f8d2ef4e0cbb	8546	paid	2023-06-07
c14bb628-e206-4a1a-8ad9-dba1156da82d	3958dc9e-712f-4377-85e9-fec4b6a6442a	500	paid	2023-08-19
9378a568-5b1d-4826-8cb9-569248dfecb5	13d07535-c59e-4157-a011-f8d2ef4e0cbb	8945	paid	2023-06-03
cf2072f7-3ccc-41e8-8470-db41bf9b2113	3958dc9e-742f-4377-85e9-fec4b6a6442a	1000	paid	2022-06-05
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

