PGDMP      &                |            postgres    16.1    16.1 \    9           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            :           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            ;           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            <           1262    5    postgres    DATABASE     |   CREATE DATABASE postgres WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Russian_Russia.1251';
    DROP DATABASE postgres;
                postgres    false            =           0    0    DATABASE postgres    COMMENT     N   COMMENT ON DATABASE postgres IS 'default administrative connection database';
                   postgres    false    4924            >           0    0    DATABASE postgres    ACL     �   GRANT CONNECT ON DATABASE postgres TO manager;
GRANT CONNECT ON DATABASE postgres TO my_user;
GRANT CONNECT ON DATABASE postgres TO read_only_role;
GRANT CONNECT ON DATABASE postgres TO my_user1;
                   postgres    false    4924                        2615    24577    main    SCHEMA        CREATE SCHEMA main;
    DROP SCHEMA main;
                postgres    false            ?           0    0    SCHEMA main    ACL     N   GRANT USAGE ON SCHEMA main TO name2;
GRANT USAGE ON SCHEMA main TO manager77;
                   postgres    false    7            @           0    0    SCHEMA public    ACL     0   GRANT USAGE ON SCHEMA public TO read_only_role;
                   pg_database_owner    false    6                        3079    16384 	   adminpack 	   EXTENSION     A   CREATE EXTENSION IF NOT EXISTS adminpack WITH SCHEMA pg_catalog;
    DROP EXTENSION adminpack;
                   false            A           0    0    EXTENSION adminpack    COMMENT     M   COMMENT ON EXTENSION adminpack IS 'administrative functions for PostgreSQL';
                        false    2                       1255    41278    age_increased() 	   PROCEDURE     �   CREATE PROCEDURE public.age_increased()
    LANGUAGE plpgsql
    AS $$
BEGIN
    RAISE NOTICE 'Обновленный возраст клиента меньше старого!';
END;
$$;
 '   DROP PROCEDURE public.age_increased();
       public          postgres    false            
           1255    41276    age_update()    FUNCTION     �   CREATE FUNCTION public.age_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.age < OLD.age THEN
        CALL age_increased();
    END IF;
    RETURN NEW;
END;
$$;
 #   DROP FUNCTION public.age_update();
       public          postgres    false                       1255    41269    check_age()    FUNCTION     �   CREATE FUNCTION public.check_age() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
IF NEW.age <= 20 THEN
RAISE EXCEPTION 'Возраст клиента не может быть меньше 20!';
END IF;
RETURN NEW;
END;
$$;
 "   DROP FUNCTION public.check_age();
       public          postgres    false            �            1255    32923    check_condition()    FUNCTION     �   CREATE FUNCTION public.check_condition() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
IF NEW.age > 30 THEN
RAISE EXCEPTION 'Возраст не может быть больше 30';
END IF;
RETURN NEW;
END;
$$;
 (   DROP FUNCTION public.check_condition();
       public          postgres    false                       1255    41268 )   createnewtable(integer, integer, integer)    FUNCTION     U  CREATE FUNCTION public.createnewtable(p_tableid integer, p_countplace integer, p_number integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO main.tables (tableid, countplace, number)
    VALUES (p_tableid, p_countplace, p_number);

    RAISE NOTICE 'Новая запись о столе добавлена!';
END;
$$;
 `   DROP FUNCTION public.createnewtable(p_tableid integer, p_countplace integer, p_number integer);
       public          postgres    false            �            1255    32956    debug_delete_function()    FUNCTION     �   CREATE FUNCTION public.debug_delete_function() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    PERFORM debug_procedure('Deleted record with tableid ' || OLD.tableid);
    RETURN OLD;
END;
$$;
 .   DROP FUNCTION public.debug_delete_function();
       public          postgres    false            �            1255    32952    debug_insert_function()    FUNCTION     �   CREATE FUNCTION public.debug_insert_function() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    PERFORM debug_procedure('Inserted new record with tableid ' || NEW.tableid);
    RETURN NEW;
END;
$$;
 .   DROP FUNCTION public.debug_insert_function();
       public          postgres    false            �            1255    32951    debug_procedure(text) 	   PROCEDURE     �   CREATE PROCEDURE public.debug_procedure(IN p_message text)
    LANGUAGE plpgsql
    AS $$
BEGIN
 RAISE NOTICE 'Debug procedure: %', p_message;
END;
$$;
 :   DROP PROCEDURE public.debug_procedure(IN p_message text);
       public          postgres    false            �            1255    32954    debug_update_function()    FUNCTION     �   CREATE FUNCTION public.debug_update_function() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    PERFORM debug_procedure('Updated record with tableid ' || NEW.tableid);
    RETURN NEW;
END;
$$;
 .   DROP FUNCTION public.debug_update_function();
       public          postgres    false                       1255    32970    delete_high_countplace() 	   PROCEDURE     �   CREATE PROCEDURE public.delete_high_countplace()
    LANGUAGE plpgsql
    AS $$
BEGIN
    RAISE NOTICE 'Deleted record with high countplace';
    -- Дополнительные операции, если необходимо
END;
$$;
 0   DROP PROCEDURE public.delete_high_countplace();
       public          postgres    false                        1255    32969    delete_low_countplace() 	   PROCEDURE     �   CREATE PROCEDURE public.delete_low_countplace()
    LANGUAGE plpgsql
    AS $$
BEGIN
    RAISE NOTICE 'Deleted record with low countplace';
    -- Дополнительные операции, если необходимо
END;
$$;
 /   DROP PROCEDURE public.delete_low_countplace();
       public          postgres    false                       1255    41266    get_tableinfo(integer) 	   PROCEDURE     �  CREATE PROCEDURE public.get_tableinfo(IN p_tableid integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
    guest_name VARCHAR;
    reservation_id INT;
BEGIN
    -- Ищем информацию о госте за столом
    SELECT
        c.firstname || ' ' || c.lastname,
        r.reservationid
    INTO
		guest_name,
        reservation_id
    FROM
        main.customer c
    LEFT JOIN
        main.reservation r ON c.customerid = r.customerid
    WHERE
        r.tableid = p_tableid;

    -- Выводим результат
    IF FOUND THEN
        RAISE NOTICE 'На столе % сидит гость %', p_tableid, guest_name;
        IF reservation_id IS NOT NULL THEN
            RAISE NOTICE 'И есть резерв с номером %', reservation_id;
        ELSE
            RAISE NOTICE 'Резерва нет';
        END IF;
    ELSE
        RAISE NOTICE 'Стол % свободен', p_tableid;
    END IF;
END;
$$;
 ;   DROP PROCEDURE public.get_tableinfo(IN p_tableid integer);
       public          postgres    false                       1255    41265    gettableinfo(integer) 	   PROCEDURE     �  CREATE PROCEDURE public.gettableinfo(IN p_tableid integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
    guest_name VARCHAR;
    reservation_id INT;
BEGIN
    -- Ищем информацию о госте за столом
    SELECT
        c.firstname || ' ' || c.lastname,
        r.reservationid
    INTO
		guest_name,
        reservation_id
    FROM
        main.customer c
    LEFT JOIN
        main.reservation r ON c.customerid = r.customerid
    WHERE
        r.tableid = p_tableid;

    -- Выводим результат
    IF FOUND THEN
        RAISE NOTICE 'На столе % сидит гость %', p_tableid, guest_name;
        IF reservation_id IS NOT NULL THEN
            RAISE NOTICE 'И есть резерв с номером %', reservation_id;
        ELSE
            RAISE NOTICE 'Резерва нет';
        END IF;
    ELSE
        RAISE NOTICE 'Стол % свободен', p_tableid;
    END IF;
END;
$$;
 :   DROP PROCEDURE public.gettableinfo(IN p_tableid integer);
       public          postgres    false            �            1255    32966    insert_high_countplace() 	   PROCEDURE     �   CREATE PROCEDURE public.insert_high_countplace()
    LANGUAGE plpgsql
    AS $$
	BEGIN
		RAISE NOTICE 'Inserted record with high countplace';
		-- Дополнительные операции, если необходимо
	END;
	$$;
 0   DROP PROCEDURE public.insert_high_countplace();
       public          postgres    false            �            1255    32965    insert_low_countplace() 	   PROCEDURE     �   CREATE PROCEDURE public.insert_low_countplace()
    LANGUAGE plpgsql
    AS $$
	BEGIN
		RAISE NOTICE 'Inserted record with low countplace';
		-- Дополнительные операции, если необходимо
	END;
	$$;
 /   DROP PROCEDURE public.insert_low_countplace();
       public          postgres    false                       1255    41248    my_procedure() 	   PROCEDURE     �   CREATE PROCEDURE public.my_procedure()
    LANGUAGE plpgsql
    AS $$
BEGIN
    RAISE NOTICE 'Стол удален!';
END;
$$;
 &   DROP PROCEDURE public.my_procedure();
       public          postgres    false                       1255    41215    mytable_trigger_function()    FUNCTION     �   CREATE FUNCTION public.mytable_trigger_function() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    RAISE NOTICE 'Trigger activated on mytable';
    RETURN NEW;
END;
$$;
 1   DROP FUNCTION public.mytable_trigger_function();
       public          postgres    false            	           1255    41331 	   nupdate()    FUNCTION       CREATE FUNCTION public.nupdate() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Ваше условие
    IF NEW.age < 30 THEN
        -- Ваш оператор INSERT
        INSERT INTO main.customer (firstname, lastname, phonenumber, customerid, age, email)
        VALUES (NEW.firstname, NEW.lastname, NEW.phonenumber, NEW.customerid, NEW.age, NEW.email)
        ON CONFLICT (customerid) DO UPDATE
        SET
            firstname = EXCLUDED.firstname,
            lastname = EXCLUDED.lastname,
            phonenumber = EXCLUDED.phonenumber,
            customerid = EXCLUDED.customerid,
            age = EXCLUDED.age;
    END IF;
    -- Любая другая логика, которую вы хотите включить
    RETURN NEW;
END;
$$;
     DROP FUNCTION public.nupdate();
       public          postgres    false                       1255    41280    table_delete_trigger_function()    FUNCTION     �   CREATE FUNCTION public.table_delete_trigger_function() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    CALL my_procedure();
    RETURN OLD;
END;
$$;
 6   DROP FUNCTION public.table_delete_trigger_function();
       public          postgres    false                       1255    32975    trigger_delete_function()    FUNCTION       CREATE FUNCTION public.trigger_delete_function() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF OLD.countplace < 3 THEN
        PERFORM delete_low_countplace();
    ELSE
        PERFORM delete_high_countplace();
    END IF;
    RETURN OLD;
END;
$$;
 0   DROP FUNCTION public.trigger_delete_function();
       public          postgres    false            �            1255    32971    trigger_insert_function()    FUNCTION       CREATE FUNCTION public.trigger_insert_function() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.countplace < 5 THEN
        PERFORM insert_low_countplace();
    ELSE
        PERFORM insert_high_countplace();
    END IF;
    RETURN NEW;
END;
$$;
 0   DROP FUNCTION public.trigger_insert_function();
       public          postgres    false                       1255    32973    trigger_update_function()    FUNCTION     .  CREATE FUNCTION public.trigger_update_function() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.number > OLD.number THEN
        PERFORM update_increasing_number();
    ELSIF NEW.number < OLD.number THEN
        PERFORM update_decreasing_number();
    END IF;
    RETURN NEW;
END;
$$;
 0   DROP FUNCTION public.trigger_update_function();
       public          postgres    false            �            1255    32968    update_decreasing_number() 	   PROCEDURE     �   CREATE PROCEDURE public.update_decreasing_number()
    LANGUAGE plpgsql
    AS $$
BEGIN
    RAISE NOTICE 'Updated record with decreasing number';
    -- Дополнительные операции, если необходимо
END;
$$;
 2   DROP PROCEDURE public.update_decreasing_number();
       public          postgres    false            �            1255    32967    update_increasing_number() 	   PROCEDURE     �   CREATE PROCEDURE public.update_increasing_number()
    LANGUAGE plpgsql
    AS $$
BEGIN
    RAISE NOTICE 'Updated record with increasing number';
    -- Дополнительные операции, если необходимо
END;
$$;
 2   DROP PROCEDURE public.update_increasing_number();
       public          postgres    false            �            1259    24585    customer    TABLE     �   CREATE TABLE main.customer (
    customerid integer NOT NULL,
    firstname character varying(50),
    lastname character varying(50),
    phonenumber character varying(12),
    age integer,
    email character varying(20)
);
    DROP TABLE main.customer;
       main         heap    postgres    false    7            B           0    0    TABLE customer    ACL       GRANT SELECT ON TABLE main.customer TO reader_role;
GRANT INSERT ON TABLE main.customer TO inserter_role;
GRANT UPDATE ON TABLE main.customer TO updater_role;
GRANT DELETE ON TABLE main.customer TO deleter_role;
GRANT INSERT ON TABLE main.customer TO fish;
          main          postgres    false    217            �            1259    41288    newview1    VIEW     T   CREATE VIEW main.newview1 AS
 SELECT firstname,
    lastname
   FROM main.customer;
    DROP VIEW main.newview1;
       main       
   BellaAdmin    false    217    217    7            C           0    0    TABLE newview1    ACL     .   GRANT SELECT ON TABLE main.newview1 TO name2;
          main       
   BellaAdmin    false    230            �            1259    24590    reservation    TABLE     �   CREATE TABLE main.reservation (
    reservationid integer NOT NULL,
    customerid integer NOT NULL,
    restaurantid integer NOT NULL,
    tableid integer NOT NULL,
    numberofguests integer NOT NULL
);
    DROP TABLE main.reservation;
       main         heap    postgres    false    7            D           0    0    TABLE reservation    ACL     A  GRANT SELECT ON TABLE main.reservation TO reader_role;
GRANT INSERT ON TABLE main.reservation TO inserter_role;
GRANT UPDATE ON TABLE main.reservation TO updater_role;
GRANT DELETE ON TABLE main.reservation TO deleter_role;
GRANT SELECT ON TABLE main.reservation TO name2;
GRANT UPDATE ON TABLE main.reservation TO fish;
          main          postgres    false    218            �            1259    40961    predsoed    VIEW     �   CREATE VIEW main.predsoed AS
 SELECT reservation.reservationid,
    reservation.customerid,
    reservation.numberofguests
   FROM (main.customer
     LEFT JOIN main.reservation ON ((reservation.customerid = customer.customerid)));
    DROP VIEW main.predsoed;
       main          postgres    false    218    218    218    217    7            E           0    0    TABLE predsoed    ACL       GRANT SELECT ON TABLE main.predsoed TO reader_role;
GRANT INSERT ON TABLE main.predsoed TO inserter_role;
GRANT UPDATE ON TABLE main.predsoed TO updater_role;
GRANT DELETE ON TABLE main.predsoed TO deleter_role;
GRANT SELECT ON TABLE main.predsoed TO name2;
          main          postgres    false    226            �            1259    32769    tables    TABLE     }   CREATE TABLE main.tables (
    tableid integer NOT NULL,
    countplace integer,
    number integer,
    waiterid integer
);
    DROP TABLE main.tables;
       main         heap    postgres    false    7            F           0    0    TABLE tables    ACL     �   GRANT SELECT ON TABLE main.tables TO reader_role;
GRANT INSERT ON TABLE main.tables TO inserter_role;
GRANT UPDATE ON TABLE main.tables TO updater_role;
GRANT DELETE ON TABLE main.tables TO deleter_role;
GRANT DELETE ON TABLE main.tables TO fish;
          main          postgres    false    220            �            1259    41308 	   predsoed1    VIEW     �   CREATE VIEW main.predsoed1 AS
 SELECT customer.customerid,
    customer.firstname,
    customer.lastname,
    tables.tableid,
    tables.number
   FROM (main.customer
     LEFT JOIN main.tables ON ((tables.tableid = customer.customerid)));
    DROP VIEW main.predsoed1;
       main          postgres    false    220    217    217    217    220    7            �            1259    41312 	   predsoed2    VIEW       CREATE VIEW main.predsoed2 AS
 SELECT customer.customerid,
    customer.firstname,
    customer.lastname,
    customer.age,
    tables.tableid,
    tables.number
   FROM (main.customer
     LEFT JOIN main.tables ON ((tables.tableid = customer.customerid)));
    DROP VIEW main.predsoed2;
       main          postgres    false    220    220    217    217    217    217    7            �            1259    32806    restaurants    TABLE     �   CREATE TABLE main.restaurants (
    restaurantid integer NOT NULL,
    restaurantname character varying(255),
    address character varying(255),
    phonenumber character varying(15),
    reservationid integer
);
    DROP TABLE main.restaurants;
       main         heap    postgres    false    7            G           0    0    TABLE restaurants    ACL       GRANT SELECT ON TABLE main.restaurants TO reader_role;
GRANT INSERT ON TABLE main.restaurants TO inserter_role;
GRANT UPDATE ON TABLE main.restaurants TO updater_role;
GRANT DELETE ON TABLE main.restaurants TO deleter_role;
GRANT SELECT ON TABLE main.restaurants TO name2;
          main          postgres    false    221            �            1259    24595    waiter    TABLE     �   CREATE TABLE main.waiter (
    waiterid integer NOT NULL,
    firstname character varying(50) NOT NULL,
    lastname character varying(50) NOT NULL,
    phonenumber character varying(12) NOT NULL
);
    DROP TABLE main.waiter;
       main         heap    postgres    false    7            H           0    0    TABLE waiter    ACL     #  GRANT SELECT ON TABLE main.waiter TO reader_role;
GRANT INSERT ON TABLE main.waiter TO inserter_role;
GRANT UPDATE ON TABLE main.waiter TO updater_role;
GRANT DELETE ON TABLE main.waiter TO deleter_role;
GRANT SELECT ON TABLE main.waiter TO name2;
GRANT SELECT ON TABLE main.waiter TO fish;
          main          postgres    false    219            �            1259    32904    ssa    VIEW     �   CREATE VIEW main.ssa AS
 SELECT concat(waiter.firstname, ' ', customer.firstname) AS "Клиентура"
   FROM main.waiter,
    main.customer;
    DROP VIEW main.ssa;
       main          postgres    false    219    217    7            I           0    0 	   TABLE ssa    ACL     �   GRANT SELECT ON TABLE main.ssa TO reader_role;
GRANT INSERT ON TABLE main.ssa TO inserter_role;
GRANT UPDATE ON TABLE main.ssa TO updater_role;
GRANT DELETE ON TABLE main.ssa TO deleter_role;
GRANT SELECT ON TABLE main.ssa TO name2;
          main          postgres    false    222            �            1259    41217    waiter_view    VIEW     ^   CREATE VIEW main.waiter_view AS
 SELECT customerid,
    email,
    age
   FROM main.customer;
    DROP VIEW main.waiter_view;
       main          postgres    false    217    217    217    7            J           0    0    TABLE waiter_view    ACL       GRANT SELECT ON TABLE main.waiter_view TO reader_role;
GRANT INSERT ON TABLE main.waiter_view TO inserter_role;
GRANT UPDATE ON TABLE main.waiter_view TO updater_role;
GRANT DELETE ON TABLE main.waiter_view TO deleter_role;
GRANT SELECT ON TABLE main.waiter_view TO name2;
          main          postgres    false    227            �            1259    32977    my_nested_view    VIEW     �  CREATE VIEW public.my_nested_view AS
 SELECT waiterid,
    firstname AS waiterfirstname,
    lastname AS waiterlastname,
    phonenumber AS waiterphonenumber,
    ( SELECT c.customerid
           FROM main.customer c
          WHERE ((c.firstname)::text = (w.firstname)::text)
         LIMIT 1) AS customerid,
    ( SELECT c.firstname
           FROM main.customer c
          WHERE ((c.firstname)::text = (w.firstname)::text)
         LIMIT 1) AS customerfirstname
   FROM main.waiter w;
 !   DROP VIEW public.my_nested_view;
       public          postgres    false    219    217    217    219    219    219            K           0    0    TABLE my_nested_view    ACL       GRANT SELECT,UPDATE ON TABLE public.my_nested_view TO manager;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.my_nested_view TO my_user;
GRANT SELECT ON TABLE public.my_nested_view TO read_only_role;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.my_nested_view TO my_user1;
          public          postgres    false    225            �            1259    49500    newpredsoed2    VIEW     �   CREATE VIEW public.newpredsoed2 AS
 SELECT customerid,
    firstname,
    lastname
   FROM main.customer
  WHERE (age < 30)
  WITH CASCADED CHECK OPTION;
    DROP VIEW public.newpredsoed2;
       public          postgres    false    217    217    217    217            �            1259    41320    newpredsoed6    VIEW     �   CREATE VIEW public.newpredsoed6 AS
 SELECT customerid,
    firstname,
    lastname,
    age,
    tableid,
    number
   FROM main.predsoed2
  WHERE (age > 30);
    DROP VIEW public.newpredsoed6;
       public          postgres    false    232    232    232    232    232    232            �            1259    32912    ssa    VIEW     �   CREATE VIEW public.ssa AS
 SELECT restaurantid,
    phonenumber,
    count(*) AS restaurant_count
   FROM main.restaurants
  GROUP BY restaurantid, phonenumber;
    DROP VIEW public.ssa;
       public          postgres    false    221    221            L           0    0 	   TABLE ssa    ACL     �   GRANT SELECT,UPDATE ON TABLE public.ssa TO manager;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.ssa TO my_user;
GRANT SELECT ON TABLE public.ssa TO read_only_role;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.ssa TO my_user1;
          public          postgres    false    224            �            1259    32908    ssa2    VIEW     �   CREATE VIEW public.ssa2 AS
 SELECT restaurantid,
    phonenumber,
    count(*) AS restaurant_count
   FROM main.restaurants
  GROUP BY restaurantid, phonenumber;
    DROP VIEW public.ssa2;
       public          postgres    false    221    221            M           0    0 
   TABLE ssa2    ACL     �   GRANT SELECT,UPDATE ON TABLE public.ssa2 TO manager;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.ssa2 TO my_user;
GRANT SELECT ON TABLE public.ssa2 TO read_only_role;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.ssa2 TO my_user1;
          public          postgres    false    223            �            1259    41221    ssa4    VIEW     �   CREATE VIEW public.ssa4 AS
 SELECT customerid,
    firstname,
    lastname,
    phonenumber,
    age,
    email
   FROM main.customer
  WHERE (age < 30);
    DROP VIEW public.ssa4;
       public          postgres    false    217    217    217    217    217    217            N           0    0 
   TABLE ssa4    ACL     �   GRANT SELECT ON TABLE public.ssa4 TO read_only_role;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.ssa4 TO my_user;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.ssa4 TO my_user1;
          public          postgres    false    228            �            1259    41244    ssa9    VIEW     �   CREATE VIEW public.ssa9 AS
 SELECT restaurantname,
    phonenumber
   FROM main.restaurants
  GROUP BY restaurantname, phonenumber
 LIMIT 10;
    DROP VIEW public.ssa9;
       public          postgres    false    221    221            2          0    24585    customer 
   TABLE DATA           Z   COPY main.customer (customerid, firstname, lastname, phonenumber, age, email) FROM stdin;
    main          postgres    false    217   u�       3          0    24590    reservation 
   TABLE DATA           e   COPY main.reservation (reservationid, customerid, restaurantid, tableid, numberofguests) FROM stdin;
    main          postgres    false    218   K�       6          0    32806    restaurants 
   TABLE DATA           f   COPY main.restaurants (restaurantid, restaurantname, address, phonenumber, reservationid) FROM stdin;
    main          postgres    false    221   ��       5          0    32769    tables 
   TABLE DATA           E   COPY main.tables (tableid, countplace, number, waiterid) FROM stdin;
    main          postgres    false    220   &�       4          0    24595    waiter 
   TABLE DATA           J   COPY main.waiter (waiterid, firstname, lastname, phonenumber) FROM stdin;
    main          postgres    false    219   ��       x           2606    24589    customer customer_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY main.customer
    ADD CONSTRAINT customer_pkey PRIMARY KEY (customerid);
 >   ALTER TABLE ONLY main.customer DROP CONSTRAINT customer_pkey;
       main            postgres    false    217            z           2606    24594    reservation reservation_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY main.reservation
    ADD CONSTRAINT reservation_pkey PRIMARY KEY (reservationid);
 D   ALTER TABLE ONLY main.reservation DROP CONSTRAINT reservation_pkey;
       main            postgres    false    218            �           2606    32812    restaurants restaurants_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY main.restaurants
    ADD CONSTRAINT restaurants_pkey PRIMARY KEY (restaurantid);
 D   ALTER TABLE ONLY main.restaurants DROP CONSTRAINT restaurants_pkey;
       main            postgres    false    221            �           2606    32773    tables tables_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY main.tables
    ADD CONSTRAINT tables_pkey PRIMARY KEY (tableid);
 :   ALTER TABLE ONLY main.tables DROP CONSTRAINT tables_pkey;
       main            postgres    false    220            |           2606    49534    reservation unique_customerid 
   CONSTRAINT     \   ALTER TABLE ONLY main.reservation
    ADD CONSTRAINT unique_customerid UNIQUE (customerid);
 E   ALTER TABLE ONLY main.reservation DROP CONSTRAINT unique_customerid;
       main            postgres    false    218            ~           2606    49510    reservation unique_idrestaurant 
   CONSTRAINT     a   ALTER TABLE ONLY main.reservation
    ADD CONSTRAINT unique_idrestaurant UNIQUE (reservationid);
 G   ALTER TABLE ONLY main.reservation DROP CONSTRAINT unique_idrestaurant;
       main            postgres    false    218            �           2606    49514     reservation unique_idrestaurants 
   CONSTRAINT     a   ALTER TABLE ONLY main.reservation
    ADD CONSTRAINT unique_idrestaurants UNIQUE (restaurantid);
 H   ALTER TABLE ONLY main.reservation DROP CONSTRAINT unique_idrestaurants;
       main            postgres    false    218            �           2606    49521    reservation unique_tableid 
   CONSTRAINT     V   ALTER TABLE ONLY main.reservation
    ADD CONSTRAINT unique_tableid UNIQUE (tableid);
 B   ALTER TABLE ONLY main.reservation DROP CONSTRAINT unique_tableid;
       main            postgres    false    218            �           2606    49541    tables unique_waiterid 
   CONSTRAINT     S   ALTER TABLE ONLY main.tables
    ADD CONSTRAINT unique_waiterid UNIQUE (waiterid);
 >   ALTER TABLE ONLY main.tables DROP CONSTRAINT unique_waiterid;
       main            postgres    false    220            �           2606    24599    waiter waiter_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY main.waiter
    ADD CONSTRAINT waiter_pkey PRIMARY KEY (waiterid);
 :   ALTER TABLE ONLY main.waiter DROP CONSTRAINT waiter_pkey;
       main            postgres    false    219            0           2618    41327    predsoed2 update_rule    RULE     �   CREATE RULE update_rule AS
    ON UPDATE TO main.predsoed2
   WHERE (new.age >= 30) DO INSTEAD  UPDATE main.predsoed2 SET firstname = new.firstname, lastname = new.lastname, age = new.age
  WHERE (predsoed2.customerid = old.customerid);
 )   DROP RULE update_rule ON main.predsoed2;
       main          postgres    false    232    232    232    232    232    232    232            �           2620    41270    customer check_age    TRIGGER     t   CREATE TRIGGER check_age BEFORE INSERT OR UPDATE ON main.customer FOR EACH ROW EXECUTE FUNCTION public.check_age();
 )   DROP TRIGGER check_age ON main.customer;
       main          postgres    false    217    264            �           2620    41225     customer check_condition_trigger    TRIGGER     �   CREATE TRIGGER check_condition_trigger BEFORE INSERT OR UPDATE ON main.customer FOR EACH ROW EXECUTE FUNCTION public.check_condition();
 7   DROP TRIGGER check_condition_trigger ON main.customer;
       main          postgres    false    217    235            �           2620    41277     customer customer_update_trigger    TRIGGER     x   CREATE TRIGGER customer_update_trigger AFTER UPDATE ON main.customer FOR EACH ROW EXECUTE FUNCTION public.age_update();
 7   DROP TRIGGER customer_update_trigger ON main.customer;
       main          postgres    false    217    266            �           2620    41279 !   customer customer_update_trigger1    TRIGGER     y   CREATE TRIGGER customer_update_trigger1 AFTER UPDATE ON main.customer FOR EACH ROW EXECUTE FUNCTION public.age_update();
 8   DROP TRIGGER customer_update_trigger1 ON main.customer;
       main          postgres    false    266    217            �           2620    41332    customer nupdate_trigger    TRIGGER     n   CREATE TRIGGER nupdate_trigger BEFORE INSERT ON main.customer FOR EACH ROW EXECUTE FUNCTION public.nupdate();
 /   DROP TRIGGER nupdate_trigger ON main.customer;
       main          postgres    false    217    265            �           2620    41281    tables table_delete_trigger    TRIGGER     �   CREATE TRIGGER table_delete_trigger AFTER DELETE ON main.tables FOR EACH ROW EXECUTE FUNCTION public.table_delete_trigger_function();
 2   DROP TRIGGER table_delete_trigger ON main.tables;
       main          postgres    false    220    268            �           2606    49535    customer cust_reserv    FK CONSTRAINT     �   ALTER TABLE ONLY main.customer
    ADD CONSTRAINT cust_reserv FOREIGN KEY (customerid) REFERENCES main.reservation(customerid) NOT VALID;
 <   ALTER TABLE ONLY main.customer DROP CONSTRAINT cust_reserv;
       main          postgres    false    4732    217    218            �           2606    49515    restaurants res_reserv    FK CONSTRAINT     �   ALTER TABLE ONLY main.restaurants
    ADD CONSTRAINT res_reserv FOREIGN KEY (restaurantid) REFERENCES main.reservation(restaurantid) NOT VALID;
 >   ALTER TABLE ONLY main.restaurants DROP CONSTRAINT res_reserv;
       main          postgres    false    221    218    4736            �           2606    49522    tables table_reserv    FK CONSTRAINT     �   ALTER TABLE ONLY main.tables
    ADD CONSTRAINT table_reserv FOREIGN KEY (tableid) REFERENCES main.reservation(tableid) NOT VALID;
 ;   ALTER TABLE ONLY main.tables DROP CONSTRAINT table_reserv;
       main          postgres    false    218    4738    220            �           2606    49542    waiter waiter_tables    FK CONSTRAINT     �   ALTER TABLE ONLY main.waiter
    ADD CONSTRAINT waiter_tables FOREIGN KEY (waiterid) REFERENCES main.tables(waiterid) NOT VALID;
 <   ALTER TABLE ONLY main.waiter DROP CONSTRAINT waiter_tables;
       main          postgres    false    220    219    4744            2   �   x�u����0E׷��J�Ҙd��a@p�,ܸ�l$i����{cG! ��9�ry�|���<�s��"��z���;Ln�>��sNM���6�7��Z�1�l90�?X�+��yp>�b.�B3�,����:��u��O
��hZ��$��p-��Ų���N�آJ\�U���o��>O�Z��J��T~c��W�c�4�#6_O      3   L   x����0�f�*4$!�t�9z�!|9G�LU�xe�6>e��iM|ɔ~�u��&��݋]���d1�g[X��'"~L�      6   o  x�]��NA�u�W��af��Rq!J���M���h?P�ޚ6�j�3�VWw�2�j�����Fe�Ot�e��U�i�I�P�堬��a�
�ޑ8��nZ\�?�͋|N;Bj��T�L�і�7޲ѻ��"�p�[r����p��7*r�#U|p��z�c���?��9&8�����/��R`�*Xҩ��ywd�W�k�ӻ������֚��LP�j�~}D�u`��W��4����{����Š��k����Z&��C۶�J�Ɛܳ>��-��J�c\9aѱ�,�sٳg�@��Bv$�U��L?����1�y�VA����ِ�-�J�Pe�ȟ�,)�,3=�l�R���ž�����]+�~ 	��      5   M   x����0�������ؽ��:"�,��$lB�&k�I,349�1S�E�Y�T�������i[���*��ֵ�=�~
|      4   �   x�-��j�0���l�dɒ�M/�P�������R�C ߭�wގ¹��S�Pzdc'v~H�jĲ�[��O���@#��W췽��
k-]G/k.��=opα��g	Y\�w
��#��úA)�Zk%4a	=$�*%vc���$�v��%�+D�Y�y��|�A�ԸA��Z�,����{x��!�<�K�MҼ��#�!,�}>�m�G�     