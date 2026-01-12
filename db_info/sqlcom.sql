--
-- PostgreSQL database dump
--

-- Dumped from database version 17.0
-- Dumped by pg_dump version 17.0

-- Started on 2024-12-25 22:09:10

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
-- TOC entry 236 (class 1255 OID 26304)
-- Name: add_customer(smallint, character varying, character varying, character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.add_customer(IN c_id smallint, IN c_name character varying, IN c_company character varying, IN c_telephone character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN 
INSERT INTO customers ("customerID","name","company","telephone")
VALUES (c_id, c_name, c_company, c_telephone);
END;
$$;


ALTER PROCEDURE public.add_customer(IN c_id smallint, IN c_name character varying, IN c_company character varying, IN c_telephone character varying) OWNER TO postgres;

--
-- TOC entry 234 (class 1255 OID 26449)
-- Name: add_employee_bonus(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_employee_bonus() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    
    UPDATE "employees"
    SET "bonus" = "bonus" + (NEW."totalPrice" * 0.05)
    WHERE "employeeID" = NEW."employeeID";

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.add_employee_bonus() OWNER TO postgres;

--
-- TOC entry 249 (class 1255 OID 26305)
-- Name: add_stock_quantity(smallint, smallint, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_stock_quantity(p_productid smallint, p_storeid smallint, p_quantity integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    existing_quantity INTEGER := NULL;
    updated_quantity INTEGER := 0;
BEGIN

    SELECT "stockQuantity"
    INTO existing_quantity
    FROM productstores
    WHERE "productID" = p_productID AND "storeID" = p_storeID;


    IF existing_quantity IS NOT NULL THEN
        UPDATE productstores
        SET "stockQuantity" = existing_quantity + p_quantity
        WHERE "productID" = p_productID AND "storeID" = p_storeID;


        SELECT "stockQuantity"
        INTO updated_quantity
        FROM productstores
        WHERE "productID" = p_productID AND "storeID" = p_storeID;
    ELSE
 
        INSERT INTO productstores ("productID", "storeID", "stockQuantity")
        VALUES (p_productID, p_storeID, p_quantity);

   
        updated_quantity := p_quantity;
    END IF;
    RETURN updated_quantity;
END;
$$;


ALTER FUNCTION public.add_stock_quantity(p_productid smallint, p_storeid smallint, p_quantity integer) OWNER TO postgres;

--
-- TOC entry 232 (class 1255 OID 26291)
-- Name: calculate_total_price(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.calculate_total_price() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW."totalPrice" := NEW."quantity" * (
        SELECT "price"
        FROM "products"
        WHERE "productID" = NEW."productID"
    );
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.calculate_total_price() OWNER TO postgres;

--
-- TOC entry 233 (class 1255 OID 26440)
-- Name: disjoint_products(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.disjoint_products() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    
    IF NEW."computer" THEN
        INSERT INTO "computers" ("productID")
        VALUES (NEW."productID");
    END IF;

    
    IF NEW."telephone" THEN
        INSERT INTO "telephones" ("ProductID")
        VALUES (NEW."productID");
    END IF;

    
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.disjoint_products() OWNER TO postgres;

--
-- TOC entry 235 (class 1255 OID 26303)
-- Name: get_employees_sorted_by_salary(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_employees_sorted_by_salary() RETURNS TABLE("employeeID" smallint, name character varying, "position" character varying, salary integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT e."employeeID", e."name", e."position", e."salary"
    FROM employees e
    ORDER BY e."salary" DESC;
END;
$$;


ALTER FUNCTION public.get_employees_sorted_by_salary() OWNER TO postgres;

--
-- TOC entry 237 (class 1255 OID 26453)
-- Name: get_product_stock(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_product_stock() RETURNS TABLE(store_id smallint, product_id smallint, stock_quantity smallint)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        ps."storeID" AS "store_id", 
        ps."productID" AS "product_id", 
        ps."stockQuantity" AS "stock_quantity"
    FROM 
        "productstores" ps
    ORDER BY 
        ps."stockQuantity" DESC; 
END;
$$;


ALTER FUNCTION public.get_product_stock() OWNER TO postgres;

--
-- TOC entry 250 (class 1255 OID 26370)
-- Name: set_order_date(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.set_order_date() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
   
    NEW."orderdate" := CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.set_order_date() OWNER TO postgres;

--
-- TOC entry 251 (class 1255 OID 26332)
-- Name: update_stock_quantity(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_stock_quantity() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

    UPDATE productstores
    SET "stockQuantity" = "stockQuantity" - NEW."quantity"
    WHERE "productID" = NEW."productID"
      AND "storeID" = NEW."storeID";

 
    IF (SELECT "stockQuantity" FROM productstores
        WHERE "productID" = NEW."productID"
          AND "storeID" = NEW."storeID") < 0 THEN
        RAISE EXCEPTION 'Stock quantity cannot be negative for productID: %, storeID: %',
            NEW."productID", NEW."storeID";
    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_stock_quantity() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 221 (class 1259 OID 25549)
-- Name: computers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.computers (
    "productID" smallint NOT NULL,
    type character varying(100),
    color character varying(50)
);


ALTER TABLE public.computers OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 25533)
-- Name: customers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customers (
    "customerID" smallint NOT NULL,
    name character varying(100) NOT NULL,
    company character varying(50),
    telephone character varying(15)
);


ALTER TABLE public.customers OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 25523)
-- Name: employees; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employees (
    "employeeID" smallint NOT NULL,
    "storeID" smallint NOT NULL,
    "position" character varying(50),
    hiredate date NOT NULL,
    salary integer NOT NULL,
    name character varying(50),
    bonus numeric,
    CONSTRAINT bonus_check CHECK ((bonus >= (0)::numeric)),
    CONSTRAINT salary_check CHECK ((salary >= 0))
);


ALTER TABLE public.employees OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 25859)
-- Name: employees_employeeID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.employees ALTER COLUMN "employeeID" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."employees_employeeID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 223 (class 1259 OID 25580)
-- Name: orderdetails; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orderdetails (
    "orderdetailID" smallint NOT NULL,
    "orderID" smallint NOT NULL,
    "productID" smallint,
    quantity smallint NOT NULL,
    "totalPrice" integer,
    "storeID" smallint NOT NULL,
    "customerID" smallint,
    "employeeID" smallint,
    CONSTRAINT "check_totalPrice" CHECK (("totalPrice" >= 0)),
    CONSTRAINT quantity_check CHECK ((quantity > 0))
);


ALTER TABLE public.orderdetails OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 26447)
-- Name: orderdetails_orderdetailID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.orderdetails ALTER COLUMN "orderdetailID" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."orderdetails_orderdetailID_seq"
    START WITH 28
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 222 (class 1259 OID 25569)
-- Name: orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders (
    "orderID" smallint NOT NULL,
    orderdate date NOT NULL
);


ALTER TABLE public.orders OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 26245)
-- Name: orders_orderID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.orders ALTER COLUMN "orderID" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."orders_orderID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 220 (class 1259 OID 25543)
-- Name: products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.products (
    "productID" smallint NOT NULL,
    brand character varying(50),
    telephone boolean,
    computer boolean,
    "Model" character varying(50) NOT NULL,
    price integer NOT NULL,
    CONSTRAINT check_product_type CHECK ((computer <> telephone))
);


ALTER TABLE public.products OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 25856)
-- Name: products_productID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.products ALTER COLUMN "productID" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."products_productID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 226 (class 1259 OID 25821)
-- Name: productstores; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.productstores (
    "productID" smallint NOT NULL,
    "storeID" smallint NOT NULL,
    "stockQuantity" smallint NOT NULL,
    CONSTRAINT "check_stockQuantity" CHECK (("stockQuantity" >= 0))
);


ALTER TABLE public.productstores OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 25514)
-- Name: stores; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stores (
    name character varying(50) NOT NULL,
    email character varying(100) NOT NULL,
    phonenumber character varying(15),
    address text,
    city character varying(50) NOT NULL,
    "storeID" smallint NOT NULL
);


ALTER TABLE public.stores OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 25865)
-- Name: supplierproducts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.supplierproducts (
    "supplierID" smallint NOT NULL,
    "productID" smallint NOT NULL
);


ALTER TABLE public.supplierproducts OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 25597)
-- Name: suppliers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.suppliers (
    "supplierID" smallint NOT NULL,
    name character varying(100) NOT NULL,
    contactemail character varying(100),
    phonenumber character varying(15),
    address text,
    city character varying(50) NOT NULL
);


ALTER TABLE public.suppliers OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 25781)
-- Name: telephones; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.telephones (
    "ProductID" smallint NOT NULL,
    os character varying(50),
    color character varying(50)
);


ALTER TABLE public.telephones OWNER TO postgres;

--
-- TOC entry 4947 (class 0 OID 25549)
-- Dependencies: 221
-- Data for Name: computers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.computers ("productID", type, color) FROM stdin;
4	Laptop	black
5	Desktop	gray
6	Laptop	white
\.


--
-- TOC entry 4945 (class 0 OID 25533)
-- Dependencies: 219
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customers ("customerID", name, company, telephone) FROM stdin;
2	Mauro Grealish	B Tech	7586549685
3	Ahmet Çukur	C Tech	05582563214
5	Alice Johnson	E Tech	7586549686
6	Bob Smith	F Tech	7586549687
7	Charlie Davis	H Tech	7586549688
8	Diana Prince	G Tech	7586549689
9	Ethan Hunt	X Tech	1542265236
11	George Michael	Z Tech	1542265238
12	Helen Carter	W Tech	1542265239
13	Ian Wright	U Tech	1542265230
20	Joe Hart	X INC	05540124563
\.


--
-- TOC entry 4944 (class 0 OID 25523)
-- Dependencies: 218
-- Data for Name: employees; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employees ("employeeID", "storeID", "position", hiredate, salary, name, bonus) FROM stdin;
6	426	Salesman	2020-02-12	2600	Raymond Green	322.5
7	426	Salesman	2021-09-10	2500	Wyatt Nicholson	440
5	135	Salesman	2022-09-17	2400	Hector Elliot	360
8	587	Salesman	2021-07-16	2600	Micheal Geller	320.00
2	426	Manager	2021-03-16	3500	Tom Taylor	0
3	587	Manager	2020-05-22	3700	Henry Dylan	0
1	135	Manager	2019-04-19	4000	Harley Robertson	0
4	135	Salesman	2021-08-12	2500	Alexander Gray	580
\.


--
-- TOC entry 4949 (class 0 OID 25580)
-- Dependencies: 223
-- Data for Name: orderdetails; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orderdetails ("orderdetailID", "orderID", "productID", quantity, "totalPrice", "storeID", "customerID", "employeeID") FROM stdin;
8	5	8	4	3200	135	5	4
9	5	1	7	8400	135	5	4
11	8	1	3	3600	135	6	5
13	7	5	3	3750	426	3	6
14	6	6	8	8800	426	8	7
24	3	6	4	4400	587	2	8
2	7	9	3	2700	426	11	6
21	10	1	3	3600	135	3	5
3	3	10	2	2000	587	9	8
\.


--
-- TOC entry 4948 (class 0 OID 25569)
-- Dependencies: 222
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orders ("orderID", orderdate) FROM stdin;
3	2020-06-24
5	2021-04-25
6	2022-05-24
7	2023-04-21
8	2023-09-11
10	2024-12-21
\.


--
-- TOC entry 4946 (class 0 OID 25543)
-- Dependencies: 220
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.products ("productID", brand, telephone, computer, "Model", price) FROM stdin;
1	Apple	t	\N	IPhone15	1200
2	Apple	t	\N	IPhone14	1000
4	Apple	\N	t	MacBook M1	1000
5	ASUS	\N	t	TUF F15	1250
6	ASUS	\N	t	TUF F14	1100
8	Samsung	t	\N	A21	800
9	Samsung	t	\N	A51	900
10	Samsung	t	\N	Z Flip 6	1000
\.


--
-- TOC entry 4952 (class 0 OID 25821)
-- Dependencies: 226
-- Data for Name: productstores; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.productstores ("productID", "storeID", "stockQuantity") FROM stdin;
2	426	15
1	426	25
1	426	30
4	135	20
8	135	16
5	426	27
1	135	53
6	587	26
5	587	18
9	426	12
10	587	18
\.


--
-- TOC entry 4943 (class 0 OID 25514)
-- Dependencies: 217
-- Data for Name: stores; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.stores (name, email, phonenumber, address, city, "storeID") FROM stdin;
Kevin's Tech Store	kevin_ts12@gmail.com	+1458635234	146 Main St.	Berlin	135
Vatan PC	vatan_ist34@gmail.com	05578562450	\N	İstanbul	426
Teknosa	teknosa_54@gmail.com	05789615243	Çark Cd. No:6	Sakarya	587
\.


--
-- TOC entry 4955 (class 0 OID 25865)
-- Dependencies: 229
-- Data for Name: supplierproducts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.supplierproducts ("supplierID", "productID") FROM stdin;
24	8
24	9
24	10
32	6
32	5
47	1
47	2
48	4
1	8
48	5
\.


--
-- TOC entry 4950 (class 0 OID 25597)
-- Dependencies: 224
-- Data for Name: suppliers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.suppliers ("supplierID", name, contactemail, phonenumber, address, city) FROM stdin;
24	Tech Supplier Inc	tchsupply@gmail.com	1456247852	754 Oak St.	Köln
32	St Tech World Supplier	techworld.0@gmail.com	1452874523	134 Pine St.	Hamburg
47	Ahmet Taşımacalık	ahmet_taşımacalık@gmail.com	05865214123	Beyoğlu 134.Sk	İstanbul
48	App's Supplier	apps_sup@gmail.com	1627524852	\N	Brussels
1	aa	tt@hotmail.com	111111	aaaaaa	aa
\.


--
-- TOC entry 4951 (class 0 OID 25781)
-- Dependencies: 225
-- Data for Name: telephones; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.telephones ("ProductID", os, color) FROM stdin;
1	IOS	red
2	IOS	gray
8	Android	black
9	Android	dark blue
10	Android	black
\.


--
-- TOC entry 4963 (class 0 OID 0)
-- Dependencies: 228
-- Name: employees_employeeID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."employees_employeeID_seq"', 11, true);


--
-- TOC entry 4964 (class 0 OID 0)
-- Dependencies: 231
-- Name: orderdetails_orderdetailID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."orderdetails_orderdetailID_seq"', 3, true);


--
-- TOC entry 4965 (class 0 OID 0)
-- Dependencies: 230
-- Name: orders_orderID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."orders_orderID_seq"', 15, true);


--
-- TOC entry 4966 (class 0 OID 0)
-- Dependencies: 227
-- Name: products_productID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."products_productID_seq"', 17, true);


--
-- TOC entry 4766 (class 2606 OID 26319)
-- Name: computers computers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.computers
    ADD CONSTRAINT computers_pkey PRIMARY KEY ("productID");


--
-- TOC entry 4762 (class 2606 OID 25537)
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY ("customerID");


--
-- TOC entry 4760 (class 2606 OID 25527)
-- Name: employees employees_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY ("employeeID");


--
-- TOC entry 4772 (class 2606 OID 25586)
-- Name: orderdetails orderdetails_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orderdetails
    ADD CONSTRAINT orderdetails_pkey PRIMARY KEY ("orderdetailID");


--
-- TOC entry 4770 (class 2606 OID 25574)
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY ("orderID");


--
-- TOC entry 4764 (class 2606 OID 25548)
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY ("productID");


--
-- TOC entry 4754 (class 2606 OID 25522)
-- Name: stores stores_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stores
    ADD CONSTRAINT stores_email_key UNIQUE (email);


--
-- TOC entry 4756 (class 2606 OID 26433)
-- Name: stores stores_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stores
    ADD CONSTRAINT stores_pkey PRIMARY KEY ("storeID");


--
-- TOC entry 4780 (class 2606 OID 26321)
-- Name: supplierproducts supplierproducts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.supplierproducts
    ADD CONSTRAINT supplierproducts_pkey PRIMARY KEY ("productID", "supplierID");


--
-- TOC entry 4774 (class 2606 OID 25603)
-- Name: suppliers suppliers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suppliers
    ADD CONSTRAINT suppliers_pkey PRIMARY KEY ("supplierID");


--
-- TOC entry 4776 (class 2606 OID 26317)
-- Name: telephones telephones_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.telephones
    ADD CONSTRAINT telephones_pkey PRIMARY KEY ("ProductID");


--
-- TOC entry 4768 (class 2606 OID 26298)
-- Name: computers unique_computers_productID; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.computers
    ADD CONSTRAINT "unique_computers_productID" UNIQUE ("productID");


--
-- TOC entry 4758 (class 2606 OID 25891)
-- Name: stores unique_stores_storeID; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stores
    ADD CONSTRAINT "unique_stores_storeID" UNIQUE ("storeID");


--
-- TOC entry 4778 (class 2606 OID 26296)
-- Name: telephones unique_telephones_ProductID; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.telephones
    ADD CONSTRAINT "unique_telephones_ProductID" UNIQUE ("ProductID");


--
-- TOC entry 4795 (class 2620 OID 26294)
-- Name: orderdetails calculate_total_price; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER calculate_total_price BEFORE INSERT OR UPDATE ON public.orderdetails FOR EACH ROW EXECUTE FUNCTION public.calculate_total_price();


--
-- TOC entry 4794 (class 2620 OID 26372)
-- Name: orders order_date_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER order_date_trigger BEFORE INSERT OR UPDATE ON public.orders FOR EACH ROW EXECUTE FUNCTION public.set_order_date();


--
-- TOC entry 4796 (class 2620 OID 26450)
-- Name: orderdetails trigger_add_bonus; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_add_bonus AFTER INSERT ON public.orderdetails FOR EACH ROW EXECUTE FUNCTION public.add_employee_bonus();


--
-- TOC entry 4793 (class 2620 OID 26441)
-- Name: products trigger_products_disjoint; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_products_disjoint AFTER INSERT OR UPDATE ON public.products FOR EACH ROW EXECUTE FUNCTION public.disjoint_products();


--
-- TOC entry 4797 (class 2620 OID 26342)
-- Name: orderdetails update_stock_quantity; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_stock_quantity AFTER INSERT ON public.orderdetails FOR EACH ROW EXECUTE FUNCTION public.update_stock_quantity();


--
-- TOC entry 4782 (class 2606 OID 26306)
-- Name: computers computers_productID; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.computers
    ADD CONSTRAINT "computers_productID" FOREIGN KEY ("productID") REFERENCES public.products("productID") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4781 (class 2606 OID 26379)
-- Name: employees employees_storeID_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT "employees_storeID_fk" FOREIGN KEY ("storeID") REFERENCES public.stores("storeID") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4783 (class 2606 OID 26434)
-- Name: orderdetails link_products_orderdetails; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orderdetails
    ADD CONSTRAINT link_products_orderdetails FOREIGN KEY ("productID") REFERENCES public.products("productID") MATCH FULL ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 4784 (class 2606 OID 26409)
-- Name: orderdetails orderdetails_customerID_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orderdetails
    ADD CONSTRAINT "orderdetails_customerID_fk" FOREIGN KEY ("customerID") REFERENCES public.customers("customerID") MATCH FULL ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 4785 (class 2606 OID 26414)
-- Name: orderdetails orderdetails_employeeID_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orderdetails
    ADD CONSTRAINT "orderdetails_employeeID_fk" FOREIGN KEY ("employeeID") REFERENCES public.employees("employeeID") MATCH FULL ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 4786 (class 2606 OID 26257)
-- Name: orderdetails orderdetails_orderID_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orderdetails
    ADD CONSTRAINT "orderdetails_orderID_fk" FOREIGN KEY ("orderID") REFERENCES public.orders("orderID") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4787 (class 2606 OID 26337)
-- Name: orderdetails orderdetails_storeID_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orderdetails
    ADD CONSTRAINT "orderdetails_storeID_fk" FOREIGN KEY ("storeID") REFERENCES public.stores("storeID") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4789 (class 2606 OID 25829)
-- Name: productstores productstores_productID_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.productstores
    ADD CONSTRAINT "productstores_productID_fk" FOREIGN KEY ("productID") REFERENCES public.products("productID") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4790 (class 2606 OID 25902)
-- Name: productstores productstores_storeID_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.productstores
    ADD CONSTRAINT "productstores_storeID_fk" FOREIGN KEY ("storeID") REFERENCES public.stores("storeID") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4791 (class 2606 OID 25868)
-- Name: supplierproducts supplierproducts_productID_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.supplierproducts
    ADD CONSTRAINT "supplierproducts_productID_fk" FOREIGN KEY ("productID") REFERENCES public.products("productID") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4792 (class 2606 OID 26279)
-- Name: supplierproducts supplierproducts_supplierID_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.supplierproducts
    ADD CONSTRAINT "supplierproducts_supplierID_fk" FOREIGN KEY ("supplierID") REFERENCES public.suppliers("supplierID") MATCH FULL ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 4788 (class 2606 OID 26311)
-- Name: telephones telephones_productID_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.telephones
    ADD CONSTRAINT "telephones_productID_fk" FOREIGN KEY ("ProductID") REFERENCES public.products("productID") MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


-- Completed on 2024-12-25 22:09:10

--
-- PostgreSQL database dump complete
--

