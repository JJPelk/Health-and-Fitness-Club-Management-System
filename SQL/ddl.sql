--
-- PostgreSQL database dump
--

-- Dumped from database version 16.1
-- Dumped by pg_dump version 16.1

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: billing; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.billing (
    billid integer NOT NULL,
    memberid integer NOT NULL,
    amount numeric(10,2) NOT NULL,
    billdate date NOT NULL,
    cardnumber character varying(16)
);


--
-- Name: billing_billid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.billing_billid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: billing_billid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.billing_billid_seq OWNED BY public.billing.billid;


--
-- Name: classes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.classes (
    classid integer NOT NULL,
    classname character varying(100) NOT NULL,
    roomid integer NOT NULL,
    trainerid integer NOT NULL,
    datetime timestamp without time zone NOT NULL,
    groupsession boolean DEFAULT false NOT NULL
);


--
-- Name: classes_classid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.classes_classid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: classes_classid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.classes_classid_seq OWNED BY public.classes.classid;


--
-- Name: classregistrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.classregistrations (
    registrationid integer NOT NULL,
    memberid integer NOT NULL,
    classid integer NOT NULL
);


--
-- Name: classregistrations_registrationid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.classregistrations_registrationid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: classregistrations_registrationid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.classregistrations_registrationid_seq OWNED BY public.classregistrations.registrationid;


--
-- Name: equipment; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.equipment (
    equipmentid integer NOT NULL,
    roomid integer NOT NULL,
    trainerid integer NOT NULL,
    lastchecked date NOT NULL
);


--
-- Name: equipment_equipmentid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.equipment_equipmentid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: equipment_equipmentid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.equipment_equipmentid_seq OWNED BY public.equipment.equipmentid;


--
-- Name: fitnessachievements; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fitnessachievements (
    achievementid integer NOT NULL,
    memberid integer NOT NULL,
    achievementtype character varying(50) NOT NULL,
    achievementvalue character varying(100) NOT NULL,
    exercisetype character varying(50),
    achievementdate date NOT NULL
);


--
-- Name: fitnessachievements_achievementid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.fitnessachievements_achievementid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: fitnessachievements_achievementid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.fitnessachievements_achievementid_seq OWNED BY public.fitnessachievements.achievementid;


--
-- Name: fitnessgoals; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fitnessgoals (
    goalid integer NOT NULL,
    memberid integer NOT NULL,
    goaltype character varying(50) NOT NULL,
    exercisetype character varying(50),
    currentstrengthweight integer,
    goalstrengthweight integer,
    currentweight integer,
    desiredweight integer
);


--
-- Name: fitnessgoals_goalid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.fitnessgoals_goalid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: fitnessgoals_goalid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.fitnessgoals_goalid_seq OWNED BY public.fitnessgoals.goalid;


--
-- Name: healthmetrics; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.healthmetrics (
    metricid integer NOT NULL,
    memberid integer NOT NULL,
    metrictype character varying(50) NOT NULL,
    metricvalue character varying(100) NOT NULL,
    daterecorded date NOT NULL
);


--
-- Name: healthmetrics_metricid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.healthmetrics_metricid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: healthmetrics_metricid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.healthmetrics_metricid_seq OWNED BY public.healthmetrics.metricid;


--
-- Name: members; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.members (
    memberid integer NOT NULL,
    firstname character varying(50) NOT NULL,
    lastname character varying(50) NOT NULL,
    email character varying(100) NOT NULL,
    password character varying(100) NOT NULL,
    dateofbirth date NOT NULL,
    isadmin boolean DEFAULT false
);


--
-- Name: members_memberid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.members_memberid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: members_memberid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.members_memberid_seq OWNED BY public.members.memberid;


--
-- Name: trainers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.trainers (
    trainerid integer NOT NULL,
    firstname character varying(50) NOT NULL,
    lastname character varying(50) NOT NULL,
    specialization character varying(100) NOT NULL,
    memberid integer
);


--
-- Name: trainers_trainerid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.trainers_trainerid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: trainers_trainerid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.trainers_trainerid_seq OWNED BY public.trainers.trainerid;


--
-- Name: billing billid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.billing ALTER COLUMN billid SET DEFAULT nextval('public.billing_billid_seq'::regclass);


--
-- Name: classes classid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.classes ALTER COLUMN classid SET DEFAULT nextval('public.classes_classid_seq'::regclass);


--
-- Name: classregistrations registrationid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.classregistrations ALTER COLUMN registrationid SET DEFAULT nextval('public.classregistrations_registrationid_seq'::regclass);


--
-- Name: equipment equipmentid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.equipment ALTER COLUMN equipmentid SET DEFAULT nextval('public.equipment_equipmentid_seq'::regclass);


--
-- Name: fitnessachievements achievementid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fitnessachievements ALTER COLUMN achievementid SET DEFAULT nextval('public.fitnessachievements_achievementid_seq'::regclass);


--
-- Name: fitnessgoals goalid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fitnessgoals ALTER COLUMN goalid SET DEFAULT nextval('public.fitnessgoals_goalid_seq'::regclass);


--
-- Name: healthmetrics metricid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.healthmetrics ALTER COLUMN metricid SET DEFAULT nextval('public.healthmetrics_metricid_seq'::regclass);


--
-- Name: members memberid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.members ALTER COLUMN memberid SET DEFAULT nextval('public.members_memberid_seq'::regclass);


--
-- Name: trainers trainerid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trainers ALTER COLUMN trainerid SET DEFAULT nextval('public.trainers_trainerid_seq'::regclass);


--
-- Name: billing billing_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.billing
    ADD CONSTRAINT billing_pkey PRIMARY KEY (billid);


--
-- Name: classes classes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.classes
    ADD CONSTRAINT classes_pkey PRIMARY KEY (classid);


--
-- Name: classregistrations classregistrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.classregistrations
    ADD CONSTRAINT classregistrations_pkey PRIMARY KEY (registrationid);


--
-- Name: equipment equipment_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.equipment
    ADD CONSTRAINT equipment_pkey PRIMARY KEY (equipmentid);


--
-- Name: fitnessachievements fitnessachievements_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fitnessachievements
    ADD CONSTRAINT fitnessachievements_pkey PRIMARY KEY (achievementid);


--
-- Name: fitnessgoals fitnessgoals_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fitnessgoals
    ADD CONSTRAINT fitnessgoals_pkey PRIMARY KEY (goalid);


--
-- Name: healthmetrics healthmetrics_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.healthmetrics
    ADD CONSTRAINT healthmetrics_pkey PRIMARY KEY (metricid);


--
-- Name: members members_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.members
    ADD CONSTRAINT members_email_key UNIQUE (email);


--
-- Name: members members_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.members
    ADD CONSTRAINT members_pkey PRIMARY KEY (memberid);


--
-- Name: trainers trainers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trainers
    ADD CONSTRAINT trainers_pkey PRIMARY KEY (trainerid);


--
-- Name: billing billing_memberid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.billing
    ADD CONSTRAINT billing_memberid_fkey FOREIGN KEY (memberid) REFERENCES public.members(memberid);


--
-- Name: classes classes_trainerid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.classes
    ADD CONSTRAINT classes_trainerid_fkey FOREIGN KEY (trainerid) REFERENCES public.trainers(trainerid);


--
-- Name: classregistrations classregistrations_classid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.classregistrations
    ADD CONSTRAINT classregistrations_classid_fkey FOREIGN KEY (classid) REFERENCES public.classes(classid);


--
-- Name: classregistrations classregistrations_memberid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.classregistrations
    ADD CONSTRAINT classregistrations_memberid_fkey FOREIGN KEY (memberid) REFERENCES public.members(memberid);


--
-- Name: equipment equipment_trainerid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.equipment
    ADD CONSTRAINT equipment_trainerid_fkey FOREIGN KEY (trainerid) REFERENCES public.trainers(trainerid);


--
-- Name: fitnessachievements fitnessachievements_memberid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fitnessachievements
    ADD CONSTRAINT fitnessachievements_memberid_fkey FOREIGN KEY (memberid) REFERENCES public.members(memberid);


--
-- Name: fitnessgoals fitnessgoals_memberid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fitnessgoals
    ADD CONSTRAINT fitnessgoals_memberid_fkey FOREIGN KEY (memberid) REFERENCES public.members(memberid);


--
-- Name: trainers fk_member; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trainers
    ADD CONSTRAINT fk_member FOREIGN KEY (memberid) REFERENCES public.members(memberid);


--
-- Name: healthmetrics healthmetrics_memberid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.healthmetrics
    ADD CONSTRAINT healthmetrics_memberid_fkey FOREIGN KEY (memberid) REFERENCES public.members(memberid);


--
-- PostgreSQL database dump complete
--

