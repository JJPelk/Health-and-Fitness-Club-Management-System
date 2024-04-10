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

--
-- Data for Name: members; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.members (memberid, firstname, lastname, email, password, dateofbirth, isadmin) VALUES (3, 'Noah', 'Potter', 'noahpotter@email.com', 'Test1234', '1998-03-08', false);
INSERT INTO public.members (memberid, firstname, lastname, email, password, dateofbirth, isadmin) VALUES (4, 'Noah', 'Pelkey', 'noahpelkey@email.com', 'Test', '2024-04-09', false);
INSERT INTO public.members (memberid, firstname, lastname, email, password, dateofbirth, isadmin) VALUES (2, 'Jonah', 'Pelkey', 'jonahpelkey@cmail.carleton.ca', 'Test1234', '1999-12-18', true);
INSERT INTO public.members (memberid, firstname, lastname, email, password, dateofbirth, isadmin) VALUES (5, 'David', 'Pelkey', 'David@email.com', 'Test', '1965-03-03', false);
INSERT INTO public.members (memberid, firstname, lastname, email, password, dateofbirth, isadmin) VALUES (6, 'Adam', 'Farmer', 'adam@email.com', 'Test', '1999-03-03', false);
INSERT INTO public.members (memberid, firstname, lastname, email, password, dateofbirth, isadmin) VALUES (7, 'Norm', 'Macdonald', 'norm@email.com', 'Test', '2024-04-10', false);
INSERT INTO public.members (memberid, firstname, lastname, email, password, dateofbirth, isadmin) VALUES (8, 'Bryden', 'Bray', 'Bryden@email.com', 'Test', '1998-08-07', false);


--
-- Data for Name: billing; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.billing (billid, memberid, amount, billdate, cardnumber) VALUES (1, 4, 50.00, '2024-04-09', '1111111111111111');
INSERT INTO public.billing (billid, memberid, amount, billdate, cardnumber) VALUES (2, 2, 50.00, '2024-04-09', '1111111111111111');
INSERT INTO public.billing (billid, memberid, amount, billdate, cardnumber) VALUES (3, 2, 50.00, '2024-04-09', '1111111111111111');
INSERT INTO public.billing (billid, memberid, amount, billdate, cardnumber) VALUES (4, 2, 50.00, '2024-04-09', '1111111111111111');
INSERT INTO public.billing (billid, memberid, amount, billdate, cardnumber) VALUES (5, 5, 50.00, '2024-04-10', '1111111111111111');
INSERT INTO public.billing (billid, memberid, amount, billdate, cardnumber) VALUES (6, 7, 50.00, '2024-04-10', '1111111111111111');
INSERT INTO public.billing (billid, memberid, amount, billdate, cardnumber) VALUES (7, 8, 50.00, '2024-04-10', '1111111111111111');


--
-- Data for Name: trainers; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.trainers (trainerid, firstname, lastname, specialization, memberid) VALUES (3, 'Jonah', 'Pelkey', 'Physiotherapy', 2);
INSERT INTO public.trainers (trainerid, firstname, lastname, specialization, memberid) VALUES (4, 'David', 'Pelkey', 'Powerlifting', 5);
INSERT INTO public.trainers (trainerid, firstname, lastname, specialization, memberid) VALUES (5, 'Adam', 'Farmer', 'Powerlifting', 6);
INSERT INTO public.trainers (trainerid, firstname, lastname, specialization, memberid) VALUES (6, 'Bryden', 'Bray', 'Physiotherapy', 8);


--
-- Data for Name: classes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.classes (classid, classname, roomid, trainerid, datetime, groupsession) VALUES (2, 'Stretches', 1, 3, '2024-04-10 17:30:00', false);
INSERT INTO public.classes (classid, classname, roomid, trainerid, datetime, groupsession) VALUES (4, 'Calisthenics', 1, 3, '2024-04-11 17:30:00', false);
INSERT INTO public.classes (classid, classname, roomid, trainerid, datetime, groupsession) VALUES (8, 'Olympic Lifting', 3, 4, '2024-04-13 17:30:00', true);


--
-- Data for Name: classregistrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.classregistrations (registrationid, memberid, classid) VALUES (2, 4, 4);
INSERT INTO public.classregistrations (registrationid, memberid, classid) VALUES (6, 5, 2);


--
-- Data for Name: equipment; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.equipment (equipmentid, roomid, trainerid, lastchecked) VALUES (1, 1, 3, '2024-04-12');
INSERT INTO public.equipment (equipmentid, roomid, trainerid, lastchecked) VALUES (2, 2, 3, '2024-04-16');
INSERT INTO public.equipment (equipmentid, roomid, trainerid, lastchecked) VALUES (3, 3, 3, '2024-04-11');
INSERT INTO public.equipment (equipmentid, roomid, trainerid, lastchecked) VALUES (4, 1, 6, '2024-04-10');


--
-- Data for Name: fitnessachievements; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.fitnessachievements (achievementid, memberid, achievementtype, achievementvalue, exercisetype, achievementdate) VALUES (20, 2, 'Strength', '225', 'Bench Press', '2024-04-09');
INSERT INTO public.fitnessachievements (achievementid, memberid, achievementtype, achievementvalue, exercisetype, achievementdate) VALUES (21, 2, 'Strength', '400', 'Squat', '2024-04-09');
INSERT INTO public.fitnessachievements (achievementid, memberid, achievementtype, achievementvalue, exercisetype, achievementdate) VALUES (23, 2, 'Strength', '400', 'Deadlift', '2024-04-09');
INSERT INTO public.fitnessachievements (achievementid, memberid, achievementtype, achievementvalue, exercisetype, achievementdate) VALUES (28, 4, 'Strength', '400', 'Squat', '2024-04-10');
INSERT INTO public.fitnessachievements (achievementid, memberid, achievementtype, achievementvalue, exercisetype, achievementdate) VALUES (30, 5, 'Strength', '135', 'Lat pulldown', '2024-04-10');
INSERT INTO public.fitnessachievements (achievementid, memberid, achievementtype, achievementvalue, exercisetype, achievementdate) VALUES (32, 6, 'Strength', '225', 'Bench Press', '2024-04-10');
INSERT INTO public.fitnessachievements (achievementid, memberid, achievementtype, achievementvalue, exercisetype, achievementdate) VALUES (34, 8, 'Strength', '225', 'Bench Press', '2024-04-10');


--
-- Data for Name: fitnessgoals; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.fitnessgoals (goalid, memberid, goaltype, exercisetype, currentstrengthweight, goalstrengthweight, currentweight, desiredweight) VALUES (29, 2, 'Strength', 'Deadlift', 400, 400, NULL, NULL);
INSERT INTO public.fitnessgoals (goalid, memberid, goaltype, exercisetype, currentstrengthweight, goalstrengthweight, currentweight, desiredweight) VALUES (28, 2, 'Weight', NULL, NULL, NULL, 175, 205);
INSERT INTO public.fitnessgoals (goalid, memberid, goaltype, exercisetype, currentstrengthweight, goalstrengthweight, currentweight, desiredweight) VALUES (30, 4, 'Strength', 'Bench Press', 135, 175, NULL, NULL);
INSERT INTO public.fitnessgoals (goalid, memberid, goaltype, exercisetype, currentstrengthweight, goalstrengthweight, currentweight, desiredweight) VALUES (25, 4, 'Strength', 'Squat', 400, 400, NULL, NULL);
INSERT INTO public.fitnessgoals (goalid, memberid, goaltype, exercisetype, currentstrengthweight, goalstrengthweight, currentweight, desiredweight) VALUES (32, 5, 'Weight', NULL, NULL, NULL, 205, 175);
INSERT INTO public.fitnessgoals (goalid, memberid, goaltype, exercisetype, currentstrengthweight, goalstrengthweight, currentweight, desiredweight) VALUES (33, 5, 'Strength', 'Weighted Pullup', 45, 90, NULL, NULL);
INSERT INTO public.fitnessgoals (goalid, memberid, goaltype, exercisetype, currentstrengthweight, goalstrengthweight, currentweight, desiredweight) VALUES (34, 5, 'Strength', 'Lat pulldown', 135, 135, NULL, NULL);
INSERT INTO public.fitnessgoals (goalid, memberid, goaltype, exercisetype, currentstrengthweight, goalstrengthweight, currentweight, desiredweight) VALUES (35, 5, 'Strength', 'Dumbbell Bench Press', 80, 95, NULL, NULL);
INSERT INTO public.fitnessgoals (goalid, memberid, goaltype, exercisetype, currentstrengthweight, goalstrengthweight, currentweight, desiredweight) VALUES (36, 5, 'Strength', 'Seated Rows', 125, 145, NULL, NULL);
INSERT INTO public.fitnessgoals (goalid, memberid, goaltype, exercisetype, currentstrengthweight, goalstrengthweight, currentweight, desiredweight) VALUES (31, 5, 'Strength', 'Deadlift', 185, 325, NULL, NULL);
INSERT INTO public.fitnessgoals (goalid, memberid, goaltype, exercisetype, currentstrengthweight, goalstrengthweight, currentweight, desiredweight) VALUES (38, 6, 'Weight', NULL, NULL, NULL, 175, 185);
INSERT INTO public.fitnessgoals (goalid, memberid, goaltype, exercisetype, currentstrengthweight, goalstrengthweight, currentweight, desiredweight) VALUES (37, 6, 'Strength', 'Bench Press', 225, 225, NULL, NULL);
INSERT INTO public.fitnessgoals (goalid, memberid, goaltype, exercisetype, currentstrengthweight, goalstrengthweight, currentweight, desiredweight) VALUES (22, 3, 'Strength', 'Bench Press', 175, 175, NULL, NULL);
INSERT INTO public.fitnessgoals (goalid, memberid, goaltype, exercisetype, currentstrengthweight, goalstrengthweight, currentweight, desiredweight) VALUES (23, 3, 'Weight', NULL, NULL, NULL, 195, 195);
INSERT INTO public.fitnessgoals (goalid, memberid, goaltype, exercisetype, currentstrengthweight, goalstrengthweight, currentweight, desiredweight) VALUES (39, 8, 'Strength', 'Bench Press', 225, 225, NULL, NULL);
INSERT INTO public.fitnessgoals (goalid, memberid, goaltype, exercisetype, currentstrengthweight, goalstrengthweight, currentweight, desiredweight) VALUES (40, 8, 'Weight', NULL, NULL, NULL, 185, 195);


--
-- Data for Name: healthmetrics; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.healthmetrics (metricid, memberid, metrictype, metricvalue, daterecorded) VALUES (9, 2, 'Blood pressure', '120/80', '2024-04-08');
INSERT INTO public.healthmetrics (metricid, memberid, metrictype, metricvalue, daterecorded) VALUES (10, 2, 'BMI', '20', '2024-04-08');
INSERT INTO public.healthmetrics (metricid, memberid, metrictype, metricvalue, daterecorded) VALUES (11, 2, 'Cholesterol', '100', '2024-04-08');
INSERT INTO public.healthmetrics (metricid, memberid, metrictype, metricvalue, daterecorded) VALUES (12, 4, 'Blood pressure', '120/80', '2024-04-09');
INSERT INTO public.healthmetrics (metricid, memberid, metrictype, metricvalue, daterecorded) VALUES (13, 4, 'BMI', '20', '2024-04-09');
INSERT INTO public.healthmetrics (metricid, memberid, metrictype, metricvalue, daterecorded) VALUES (14, 4, 'Cholesterol', '105', '2024-04-09');
INSERT INTO public.healthmetrics (metricid, memberid, metrictype, metricvalue, daterecorded) VALUES (15, 5, 'Blood pressure', '130/90', '2024-04-10');
INSERT INTO public.healthmetrics (metricid, memberid, metrictype, metricvalue, daterecorded) VALUES (16, 5, 'BMI', '20', '2024-04-10');
INSERT INTO public.healthmetrics (metricid, memberid, metrictype, metricvalue, daterecorded) VALUES (17, 5, 'Cholesterol', '200', '2024-04-10');
INSERT INTO public.healthmetrics (metricid, memberid, metrictype, metricvalue, daterecorded) VALUES (18, 6, 'Blood pressure', '180/90', '2024-04-10');
INSERT INTO public.healthmetrics (metricid, memberid, metrictype, metricvalue, daterecorded) VALUES (19, 6, 'BMI', '20', '2024-04-10');
INSERT INTO public.healthmetrics (metricid, memberid, metrictype, metricvalue, daterecorded) VALUES (20, 8, 'Blood pressure', '120/80', '2024-04-10');
INSERT INTO public.healthmetrics (metricid, memberid, metrictype, metricvalue, daterecorded) VALUES (21, 8, 'BMI', '20', '2024-04-10');


--
-- Name: billing_billid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.billing_billid_seq', 7, true);


--
-- Name: classes_classid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.classes_classid_seq', 11, true);


--
-- Name: classregistrations_registrationid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.classregistrations_registrationid_seq', 8, true);


--
-- Name: equipment_equipmentid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.equipment_equipmentid_seq', 4, true);


--
-- Name: fitnessachievements_achievementid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.fitnessachievements_achievementid_seq', 35, true);


--
-- Name: fitnessgoals_goalid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.fitnessgoals_goalid_seq', 40, true);


--
-- Name: healthmetrics_metricid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.healthmetrics_metricid_seq', 21, true);


--
-- Name: members_memberid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.members_memberid_seq', 8, true);


--
-- Name: trainers_trainerid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.trainers_trainerid_seq', 6, true);


--
-- PostgreSQL database dump complete
--

