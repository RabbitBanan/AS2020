PGDMP         ;                x            AS2020    12.3    12.3 Z    u           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            v           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            w           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            x           1262    16393    AS2020    DATABASE     �   CREATE DATABASE "AS2020" WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'Russian_Russia.1251' LC_CTYPE = 'Russian_Russia.1251';
    DROP DATABASE "AS2020";
                postgres    false            �            1255    16489    add_role(character, character)    FUNCTION     �   CREATE FUNCTION public.add_role(sys_name character, nomination character) RETURNS integer
    LANGUAGE plpgsql
    AS $$
begin
  INSERT INTO roles VALUES
  	(sys_name, nomination);

  RETURN 1;
end;
$$;
 I   DROP FUNCTION public.add_role(sys_name character, nomination character);
       public          postgres    false            �            1255    16805 /   add_role_user(character, character, date, date)    FUNCTION     �  CREATE FUNCTION public.add_role_user(nuser character, nrole character, ndt_start date, ndt_end date) RETURNS integer
    LANGUAGE plpgsql
    AS $$
declare
  nid_user integer;
  nid_role integer;
begin

  select id into nid_user from users where login = nuser;
  select id into nid_role from roles where sys_name = nrole;
    
  insert into roles_users 
  (id_user, id_roles, dt_start, dt_end)
  values
  (nid_user, nid_role, ndt_start, ndt_end);
  return 1;
  
	
end;

$$;
 d   DROP FUNCTION public.add_role_user(nuser character, nrole character, ndt_start date, ndt_end date);
       public          postgres    false            �            1255    16773 f   add_user(character, character, character, character, character, date, character, character, character)    FUNCTION       CREATE FUNCTION public.add_user(n_login character, n_password character, n_firstname character, n_secondname character, n_lastname character, btday date, u_sex character, u_mail character, u_telephon character) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
  psswd text;
  id_new_user integer;
  id_role_client integer;
begin
   
   
   --добавляем пользователя в таблицу users
   insert into users
   (login, password, first_name, second_name, last_name, dt_birthday, sex, e_mail, telephone)
   values
   (n_login, n_password, n_firstname, n_secondname, n_lastname, btday, u_sex, u_mail, u_telephon);
   
   execute 'CREATE user '||n_login||' WITH ENCRYPTED PASSWORD '||quote_literal(n_password)||' SUPERUSER INHERIT;';
   
   
   return 1;
end;
$$;
 �   DROP FUNCTION public.add_user(n_login character, n_password character, n_firstname character, n_secondname character, n_lastname character, btday date, u_sex character, u_mail character, u_telephon character);
       public          postgres    false            �            1255    16788    delete_roles(character)    FUNCTION     �   CREATE FUNCTION public.delete_roles(u_sys_name character) RETURNS integer
    LANGUAGE plpgsql
    AS $$
begin
  delete from roles where sys_name = u_sys_name;  
end;
$$;
 9   DROP FUNCTION public.delete_roles(u_sys_name character);
       public          postgres    false            �            1255    16785    delete_user(character)    FUNCTION     �   CREATE FUNCTION public.delete_user(u_login character) RETURNS integer
    LANGUAGE plpgsql
    AS $$
begin
  update users set
	isdelete = true
  where 
    login = u_login;
  return 1;
end;
$$;
 5   DROP FUNCTION public.delete_user(u_login character);
       public          postgres    false            �            1255    16806    get_user_login(character)    FUNCTION     �  CREATE FUNCTION public.get_user_login(nlogin character) RETURNS TABLE(upassword character, ufirst_name character, usecond_name character, ulast_name character, udt_birsday date, usex character, ue_mail character, utelephone character)
    LANGUAGE plpgsql
    AS $$ 
BEGIN
  return query
  SELECT  password, first_name, second_name, last_name, dt_birthday, sex, e_mail, telephone
	FROM users
	where login = nlogin;
END;
$$;
 7   DROP FUNCTION public.get_user_login(nlogin character);
       public          postgres    false            �            1255    16803    order_cancel(integer)    FUNCTION     �   CREATE FUNCTION public.order_cancel(num_order integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
begin
  update order_taxi set status = 'Отменен' where id = num_order;
  return 1;
end;
$$;
 6   DROP FUNCTION public.order_cancel(num_order integer);
       public          postgres    false            �            1255    16804 (   order_close(integer, integer, character)    FUNCTION     �  CREATE FUNCTION public.order_close(num_order integer, ntrasport integer, noperator character) RETURNS integer
    LANGUAGE plpgsql
    AS $$
declare
  nid_operator integer;
begin

  select id into nid_operator from users where login = noperator;
  
  
  update order_taxi set id_transport = ntrasport, id_operator = nid_operator, status ='Завершен' where id = num_order;
  
  return 1;
end;

$$;
 ]   DROP FUNCTION public.order_close(num_order integer, ntrasport integer, noperator character);
       public          postgres    false            �            1255    16790 7   order_start(character, character, character, character)    FUNCTION     �  CREATE FUNCTION public.order_start(client character, nadress_start character, nadress_end character, ntype_order character) RETURNS integer
    LANGUAGE plpgsql
    AS $$
declare
  nid_client integer;
begin
  select id into nid_client from users where login = client;

  insert into order_taxi 
  (dt_order, id_client, adress_start, adress_end, status, type_order)
  values
  (current_date, nid_client, nadress_start,  nadress_end, 'Ожидание', ntype_order);
  return 1;
end;
$$;
 {   DROP FUNCTION public.order_start(client character, nadress_start character, nadress_end character, ntype_order character);
       public          postgres    false            �            1255    16755 ,   update_role(character, character, character)    FUNCTION     >  CREATE FUNCTION public.update_role(last_sys_name character, new_sys_name character, new_nomination character) RETURNS integer
    LANGUAGE plpgsql
    AS $$
begin
   update 
     roles
   set
   	 sys_name = new_sys_name,
	 nomination = new_nomination
   where
     sys_name = last_sys_name;
   
   return 1;
end;
$$;
 m   DROP FUNCTION public.update_role(last_sys_name character, new_sys_name character, new_nomination character);
       public          postgres    false            �            1255    16780 i   update_user(character, character, character, character, character, date, character, character, character)    FUNCTION       CREATE FUNCTION public.update_user(old_login character, n_password character, n_firstname character, n_secondname character, n_lastname character, btday date, u_sex character, u_mail character, u_telephon character) RETURNS integer
    LANGUAGE plpgsql
    AS $$
begin
   
  update users set
	password = n_password, 
	first_name = n_firstname, 
	second_name = n_secondname,
	last_name = n_lastname, 
	dt_birthday = btday, 
	sex = u_sex, 
	e_mail = u_mail, 
	telephone = u_telephon
  where 
    login = old_login;
  return 1;
end;
$$;
 �   DROP FUNCTION public.update_user(old_login character, n_password character, n_firstname character, n_secondname character, n_lastname character, btday date, u_sex character, u_mail character, u_telephon character);
       public          postgres    false            �            1259    16648 
   funs_roles    TABLE     _   CREATE TABLE public.funs_roles (
    id_role integer NOT NULL,
    id_funs integer NOT NULL
);
    DROP TABLE public.funs_roles;
       public         heap    postgres    false            �            1259    16646    funs_roles_id_funs_seq    SEQUENCE     �   CREATE SEQUENCE public.funs_roles_id_funs_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.funs_roles_id_funs_seq;
       public          postgres    false    210            y           0    0    funs_roles_id_funs_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.funs_roles_id_funs_seq OWNED BY public.funs_roles.id_funs;
          public          postgres    false    209            �            1259    16644    funs_roles_id_role_seq    SEQUENCE     �   CREATE SEQUENCE public.funs_roles_id_role_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.funs_roles_id_role_seq;
       public          postgres    false    210            z           0    0    funs_roles_id_role_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.funs_roles_id_role_seq OWNED BY public.funs_roles.id_role;
          public          postgres    false    208            �            1259    16636    funs_sys    TABLE     t   CREATE TABLE public.funs_sys (
    nomination character(40),
    sys_name character(40),
    id integer NOT NULL
);
    DROP TABLE public.funs_sys;
       public         heap    postgres    false            �            1259    16634    funs_sys_id_seq    SEQUENCE     �   CREATE SEQUENCE public.funs_sys_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.funs_sys_id_seq;
       public          postgres    false    207            {           0    0    funs_sys_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.funs_sys_id_seq OWNED BY public.funs_sys.id;
          public          postgres    false    206            �            1259    16591    users    TABLE     �  CREATE TABLE public.users (
    login character(20) NOT NULL,
    password character(20) NOT NULL,
    id integer NOT NULL,
    first_name character(50) NOT NULL,
    second_name character(50) NOT NULL,
    last_name character(50),
    dt_birthday date NOT NULL,
    sex character(10),
    e_mail character(100) NOT NULL,
    telephone character(20) NOT NULL,
    isdelete boolean DEFAULT false
);
    DROP TABLE public.users;
       public         heap    postgres    false            �            1259    16589    users_id_seq    SEQUENCE     �   CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.users_id_seq;
       public          postgres    false    203            |           0    0    users_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;
          public          postgres    false    202            �            1259    16728 
   order_taxi    TABLE     �  CREATE TABLE public.order_taxi (
    adress_start character(100) NOT NULL,
    adress_end character(100) NOT NULL,
    status character(30) NOT NULL,
    id_transport integer,
    type_order character(20) NOT NULL,
    id_client integer NOT NULL,
    id_operator integer,
    id integer DEFAULT nextval('public.users_id_seq'::regclass) NOT NULL,
    dt_order timestamp without time zone NOT NULL
);
    DROP TABLE public.order_taxi;
       public         heap    postgres    false    202            �            1259    16601    roles    TABLE     r   CREATE TABLE public.roles (
    sys_name character(20),
    nomination character(100),
    id integer NOT NULL
);
    DROP TABLE public.roles;
       public         heap    postgres    false            �            1259    16599    roles_id_seq    SEQUENCE     �   CREATE SEQUENCE public.roles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.roles_id_seq;
       public          postgres    false    205            }           0    0    roles_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;
          public          postgres    false    204            �            1259    16659    roles_users    TABLE     �   CREATE TABLE public.roles_users (
    dt_start date NOT NULL,
    dt_end date,
    id_user integer NOT NULL,
    id_roles integer NOT NULL
);
    DROP TABLE public.roles_users;
       public         heap    postgres    false            �            1259    16657    roles_users_id_roles_seq    SEQUENCE     �   CREATE SEQUENCE public.roles_users_id_roles_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.roles_users_id_roles_seq;
       public          postgres    false    213            ~           0    0    roles_users_id_roles_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.roles_users_id_roles_seq OWNED BY public.roles_users.id_roles;
          public          postgres    false    212            �            1259    16655    roles_users_id_user_seq    SEQUENCE     �   CREATE SEQUENCE public.roles_users_id_user_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.roles_users_id_user_seq;
       public          postgres    false    213                       0    0    roles_users_id_user_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.roles_users_id_user_seq OWNED BY public.roles_users.id_user;
          public          postgres    false    211            �            1259    16696    sessions    TABLE     t   CREATE TABLE public.sessions (
    id_user integer NOT NULL,
    dt_enter date NOT NULL,
    id integer NOT NULL
);
    DROP TABLE public.sessions;
       public         heap    postgres    false            �            1259    16694    sessions_id_seq    SEQUENCE     �   CREATE SEQUENCE public.sessions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.sessions_id_seq;
       public          postgres    false    217            �           0    0    sessions_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.sessions_id_seq OWNED BY public.sessions.id;
          public          postgres    false    216            �            1259    16688 	   trasports    TABLE       CREATE TABLE public.trasports (
    id integer NOT NULL,
    brand character(30) NOT NULL,
    model character(30) NOT NULL,
    dt_create date NOT NULL,
    reg_num character(20) NOT NULL,
    dt_reg date NOT NULL,
    dt_off date,
    type character(20) NOT NULL
);
    DROP TABLE public.trasports;
       public         heap    postgres    false            �            1259    16686    trasports_id_seq    SEQUENCE     �   CREATE SEQUENCE public.trasports_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.trasports_id_seq;
       public          postgres    false    215            �           0    0    trasports_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.trasports_id_seq OWNED BY public.trasports.id;
          public          postgres    false    214            �            1259    16774    v_user_pore    VIEW     �   CREATE VIEW public.v_user_pore AS
 SELECT u.login,
    r.nomination
   FROM public.users u,
    public.roles r,
    public.roles_users ru
  WHERE ((u.id = ru.id_user) AND (r.id = ru.id_roles));
    DROP VIEW public.v_user_pore;
       public          postgres    false    203    203    205    205    213    213            �
           2604    16651    funs_roles id_role    DEFAULT     x   ALTER TABLE ONLY public.funs_roles ALTER COLUMN id_role SET DEFAULT nextval('public.funs_roles_id_role_seq'::regclass);
 A   ALTER TABLE public.funs_roles ALTER COLUMN id_role DROP DEFAULT;
       public          postgres    false    210    208    210            �
           2604    16652    funs_roles id_funs    DEFAULT     x   ALTER TABLE ONLY public.funs_roles ALTER COLUMN id_funs SET DEFAULT nextval('public.funs_roles_id_funs_seq'::regclass);
 A   ALTER TABLE public.funs_roles ALTER COLUMN id_funs DROP DEFAULT;
       public          postgres    false    210    209    210            �
           2604    16639    funs_sys id    DEFAULT     j   ALTER TABLE ONLY public.funs_sys ALTER COLUMN id SET DEFAULT nextval('public.funs_sys_id_seq'::regclass);
 :   ALTER TABLE public.funs_sys ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    206    207    207            �
           2604    16604    roles id    DEFAULT     d   ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);
 7   ALTER TABLE public.roles ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    205    204    205            �
           2604    16662    roles_users id_user    DEFAULT     z   ALTER TABLE ONLY public.roles_users ALTER COLUMN id_user SET DEFAULT nextval('public.roles_users_id_user_seq'::regclass);
 B   ALTER TABLE public.roles_users ALTER COLUMN id_user DROP DEFAULT;
       public          postgres    false    213    211    213            �
           2604    16663    roles_users id_roles    DEFAULT     |   ALTER TABLE ONLY public.roles_users ALTER COLUMN id_roles SET DEFAULT nextval('public.roles_users_id_roles_seq'::regclass);
 C   ALTER TABLE public.roles_users ALTER COLUMN id_roles DROP DEFAULT;
       public          postgres    false    212    213    213            �
           2604    16699    sessions id    DEFAULT     j   ALTER TABLE ONLY public.sessions ALTER COLUMN id SET DEFAULT nextval('public.sessions_id_seq'::regclass);
 :   ALTER TABLE public.sessions ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    216    217    217            �
           2604    16691    trasports id    DEFAULT     l   ALTER TABLE ONLY public.trasports ALTER COLUMN id SET DEFAULT nextval('public.trasports_id_seq'::regclass);
 ;   ALTER TABLE public.trasports ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    214    215    215            �
           2604    16594    users id    DEFAULT     d   ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);
 7   ALTER TABLE public.users ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    202    203    203            j          0    16648 
   funs_roles 
   TABLE DATA           6   COPY public.funs_roles (id_role, id_funs) FROM stdin;
    public          postgres    false    210   �v       g          0    16636    funs_sys 
   TABLE DATA           <   COPY public.funs_sys (nomination, sys_name, id) FROM stdin;
    public          postgres    false    207   �v       r          0    16728 
   order_taxi 
   TABLE DATA           �   COPY public.order_taxi (adress_start, adress_end, status, id_transport, type_order, id_client, id_operator, id, dt_order) FROM stdin;
    public          postgres    false    218   �v       e          0    16601    roles 
   TABLE DATA           9   COPY public.roles (sys_name, nomination, id) FROM stdin;
    public          postgres    false    205   ^w       m          0    16659    roles_users 
   TABLE DATA           J   COPY public.roles_users (dt_start, dt_end, id_user, id_roles) FROM stdin;
    public          postgres    false    213   x       q          0    16696    sessions 
   TABLE DATA           9   COPY public.sessions (id_user, dt_enter, id) FROM stdin;
    public          postgres    false    217   Mx       o          0    16688 	   trasports 
   TABLE DATA           _   COPY public.trasports (id, brand, model, dt_create, reg_num, dt_reg, dt_off, type) FROM stdin;
    public          postgres    false    215   jx       c          0    16591    users 
   TABLE DATA           �   COPY public.users (login, password, id, first_name, second_name, last_name, dt_birthday, sex, e_mail, telephone, isdelete) FROM stdin;
    public          postgres    false    203   �x       �           0    0    funs_roles_id_funs_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.funs_roles_id_funs_seq', 1, false);
          public          postgres    false    209            �           0    0    funs_roles_id_role_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.funs_roles_id_role_seq', 1, false);
          public          postgres    false    208            �           0    0    funs_sys_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.funs_sys_id_seq', 1, false);
          public          postgres    false    206            �           0    0    roles_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.roles_id_seq', 5, true);
          public          postgres    false    204            �           0    0    roles_users_id_roles_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.roles_users_id_roles_seq', 1, false);
          public          postgres    false    212            �           0    0    roles_users_id_user_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.roles_users_id_user_seq', 1, false);
          public          postgres    false    211            �           0    0    sessions_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.sessions_id_seq', 1, false);
          public          postgres    false    216            �           0    0    trasports_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.trasports_id_seq', 1, false);
          public          postgres    false    214            �           0    0    users_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.users_id_seq', 11, true);
          public          postgres    false    202            �
           2606    16654    funs_roles funs_roles_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.funs_roles
    ADD CONSTRAINT funs_roles_pkey PRIMARY KEY (id_role, id_funs);
 D   ALTER TABLE ONLY public.funs_roles DROP CONSTRAINT funs_roles_pkey;
       public            postgres    false    210    210            �
           2606    16641    funs_sys funs_sys_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.funs_sys
    ADD CONSTRAINT funs_sys_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.funs_sys DROP CONSTRAINT funs_sys_pkey;
       public            postgres    false    207            �
           2606    16733    order_taxi order_taxi_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.order_taxi
    ADD CONSTRAINT order_taxi_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.order_taxi DROP CONSTRAINT order_taxi_pkey;
       public            postgres    false    218            �
           2606    16606    roles roles_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.roles DROP CONSTRAINT roles_pkey;
       public            postgres    false    205            �
           2606    16665    roles_users roles_users_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY public.roles_users
    ADD CONSTRAINT roles_users_pkey PRIMARY KEY (id_user, id_roles);
 F   ALTER TABLE ONLY public.roles_users DROP CONSTRAINT roles_users_pkey;
       public            postgres    false    213    213            �
           2606    16701    sessions sessions_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.sessions DROP CONSTRAINT sessions_pkey;
       public            postgres    false    217            �
           2606    16693    trasports trasports_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.trasports
    ADD CONSTRAINT trasports_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.trasports DROP CONSTRAINT trasports_pkey;
       public            postgres    false    215            �
           2606    16596    users users_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public            postgres    false    203            �
           1259    16643    xak1funs_sys    INDEX     L   CREATE UNIQUE INDEX xak1funs_sys ON public.funs_sys USING btree (sys_name);
     DROP INDEX public.xak1funs_sys;
       public            postgres    false    207            �
           1259    16608 	   xak1roles    INDEX     F   CREATE UNIQUE INDEX xak1roles ON public.roles USING btree (sys_name);
    DROP INDEX public.xak1roles;
       public            postgres    false    205            �
           1259    16597 	   xak1users    INDEX     `   CREATE UNIQUE INDEX xak1users ON public.users USING btree (login, password, e_mail, telephone);
    DROP INDEX public.xak1users;
       public            postgres    false    203    203    203    203            �
           1259    16642    xie1funs_sys    INDEX     G   CREATE INDEX xie1funs_sys ON public.funs_sys USING btree (nomination);
     DROP INDEX public.xie1funs_sys;
       public            postgres    false    207            �
           1259    16756 	   xie1roles    INDEX     A   CREATE INDEX xie1roles ON public.roles USING btree (nomination);
    DROP INDEX public.xie1roles;
       public            postgres    false    205            �
           1259    16598 	   xie1users    INDEX     Y   CREATE INDEX xie1users ON public.users USING btree (first_name, second_name, last_name);
    DROP INDEX public.xie1users;
       public            postgres    false    203    203    203            �
           2606    16666 "   funs_roles funs_roles_id_funs_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.funs_roles
    ADD CONSTRAINT funs_roles_id_funs_fkey FOREIGN KEY (id_funs) REFERENCES public.funs_sys(id);
 L   ALTER TABLE ONLY public.funs_roles DROP CONSTRAINT funs_roles_id_funs_fkey;
       public          postgres    false    2766    207    210            �
           2606    16671 "   funs_roles funs_roles_id_role_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.funs_roles
    ADD CONSTRAINT funs_roles_id_role_fkey FOREIGN KEY (id_role) REFERENCES public.roles(id);
 L   ALTER TABLE ONLY public.funs_roles DROP CONSTRAINT funs_roles_id_role_fkey;
       public          postgres    false    205    210    2762            �
           2606    16734 $   order_taxi order_taxi_id_client_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.order_taxi
    ADD CONSTRAINT order_taxi_id_client_fkey FOREIGN KEY (id_client) REFERENCES public.users(id);
 N   ALTER TABLE ONLY public.order_taxi DROP CONSTRAINT order_taxi_id_client_fkey;
       public          postgres    false    218    203    2758            �
           2606    16739 &   order_taxi order_taxi_id_operator_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.order_taxi
    ADD CONSTRAINT order_taxi_id_operator_fkey FOREIGN KEY (id_operator) REFERENCES public.users(id);
 P   ALTER TABLE ONLY public.order_taxi DROP CONSTRAINT order_taxi_id_operator_fkey;
       public          postgres    false    218    2758    203            �
           2606    16744 '   order_taxi order_taxi_id_transport_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.order_taxi
    ADD CONSTRAINT order_taxi_id_transport_fkey FOREIGN KEY (id_transport) REFERENCES public.trasports(id);
 Q   ALTER TABLE ONLY public.order_taxi DROP CONSTRAINT order_taxi_id_transport_fkey;
       public          postgres    false    218    2774    215            �
           2606    16681 %   roles_users roles_users_id_roles_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.roles_users
    ADD CONSTRAINT roles_users_id_roles_fkey FOREIGN KEY (id_roles) REFERENCES public.roles(id);
 O   ALTER TABLE ONLY public.roles_users DROP CONSTRAINT roles_users_id_roles_fkey;
       public          postgres    false    2762    205    213            �
           2606    16676 $   roles_users roles_users_id_user_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.roles_users
    ADD CONSTRAINT roles_users_id_user_fkey FOREIGN KEY (id_user) REFERENCES public.users(id);
 N   ALTER TABLE ONLY public.roles_users DROP CONSTRAINT roles_users_id_user_fkey;
       public          postgres    false    213    203    2758            �
           2606    16702    sessions sessions_id_user_fkey    FK CONSTRAINT     }   ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_id_user_fkey FOREIGN KEY (id_user) REFERENCES public.users(id);
 H   ALTER TABLE ONLY public.sessions DROP CONSTRAINT sessions_id_user_fkey;
       public          postgres    false    217    203    2758            j      x������ � �      g      x������ � �      r   n   x������;.�]ؠpa���v]�qa/�K�ya����x${���ta�����^؋C�!煥��
6]쾰M҈Ӝӄ����@��\��R���
��b���� ��K�      e   �   x��M�KLO-R@���^��[.l���b��1WrNfj^	���Yv_�r��&Z��ʈ+1%73]����� ݰ����.6\�p���>���!WJjNjIj|Q~N*�C\�wa�����փ�p��b��e�nܧp�Hm Й=Tt�)W� 2���      m   *   x�3202�50�5����4�4�2B�@� �9�1W� �_<      q      x������ � �      o   Y   x�3�ɯ�/IT�8�K�p�*pZZZ���S������������1D����@��\�Ȓ3Ə��ҋ��^�t���NT��b���� �v�      c   #  x��R�J�@<����@K6
՛��'�^6�h7%F�[jE<��у��b$ڦ���?r����P�ò��;3��n�|�;5��pV@�w���n�6�|�F9ÈI�\�m�����H�#R��Cur���O���/tx���@\*��z�aHz[���>��s��r;sn���C}��{�`���gؒ�ݱ�K��l���٢�1��c3l�1P�T5z^��e��&ϴ��$��<U�j��9��x��O��"|؇K1_�Ej�ۭ]n,տۯ-�-���r�     