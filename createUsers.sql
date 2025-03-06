/*DEVELOPERS*/
-- CREATE user dev1 WITH PASSWORD 'dev1pass';
GRANT CONNECT ON DATABASE mustream TO dev1;
GRANT USAGE ON SCHEMA public TO dev1;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO dev1;
GRANT developer TO dev1;

-- CREATE user dev2 WITH PASSWORD 'dev2pass';
GRANT CONNECT ON DATABASE mustream TO dev2;
GRANT USAGE ON SCHEMA public TO dev2;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO dev2;
GRANT developer TO dev2;

-- CREATE user dev3 WITH PASSWORD 'dev1pass';
GRANT CONNECT ON DATABASE mustream TO dev3;
GRANT USAGE ON SCHEMA public TO dev3;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO dev3;
GRANT developer TO dev3;

-- CREATE user dev4 WITH PASSWORD 'dev1pass';
GRANT CONNECT ON DATABASE mustream TO dev4;
GRANT USAGE ON SCHEMA public TO dev4;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO dev4;
GRANT developer TO dev4;

/*MANAGERS*/
-- CREATE USER manager1 WITH PASSWORD 'manager1pass';
GRANT CONNECT ON DATABASE mustream TO manager1;
GRANT USAGE ON SCHEMA mustream_schm TO manager1;
GRANT management TO manager1;

-- CREATE USER manager2 WITH PASSWORD 'manager2pass';
GRANT CONNECT ON DATABASE mustream TO manager2;
GRANT USAGE ON SCHEMA mustream_schm TO manager2;
GRANT management TO manager2;

-- CREATE USER manager3 WITH PASSWORD 'manager3pass';
GRANT CONNECT ON DATABASE mustream TO manager3;
GRANT USAGE ON SCHEMA mustream_schm TO manager3;
GRANT management TO manager3;

-- CREATE USER manager4 WITH PASSWORD 'manager4pass';
GRANT CONNECT ON DATABASE mustream TO manager4;
GRANT USAGE ON SCHEMA mustream_schm TO manager4;
GRANT management TO manager4;

-- CREATE USER manager5 WITH PASSWORD 'manager5pass';
GRANT CONNECT ON DATABASE mustream TO manager5;
GRANT USAGE ON SCHEMA mustream_schm TO manager5;
GRANT management TO manager5;

/*CREATORS*/
-- CREATE USER creator1 WITH PASSWORD 'creator1pass';
GRANT CONNECT ON DATABASE mustream TO creator1;
GRANT USAGE ON SCHEMA mustream_schm TO creator1;
GRANT creator TO creator1;

-- CREATE USER creator2 WITH PASSWORD 'creator2pass';
GRANT CONNECT ON DATABASE mustream TO creator2;
GRANT USAGE ON SCHEMA mustream_schm TO creator2;
GRANT creator TO creator2;

-- CREATE USER creator3 WITH PASSWORD 'creator3pass';
GRANT CONNECT ON DATABASE mustream TO creator3;
GRANT USAGE ON SCHEMA mustream_schm TO creator3;
GRANT creator TO creator3;

-- CREATE USER creator4 WITH PASSWORD 'creator4pass';
GRANT CONNECT ON DATABASE mustream TO creator4;
GRANT USAGE ON SCHEMA mustream_schm TO creator4;
GRANT creator TO creator4;

-- CREATE USER creator5 WITH PASSWORD 'creator5pass';
GRANT CONNECT ON DATABASE mustream TO creator5;
GRANT USAGE ON SCHEMA mustream_schm TO creator5;
GRANT creator TO creator5;

-- CREATE USER creator6 WITH PASSWORD 'creator6pass';
GRANT CONNECT ON DATABASE mustream TO creator6;
GRANT USAGE ON SCHEMA mustream_schm TO creator6;
GRANT creator TO creator6;

-- CREATE USER creator7 WITH PASSWORD 'creator7pass';
GRANT CONNECT ON DATABASE mustream TO creator7;
GRANT USAGE ON SCHEMA mustream_schm TO creator7;
GRANT creator TO creator7;

-- CREATE USER creator8 WITH PASSWORD 'creator8pass';
GRANT CONNECT ON DATABASE mustream TO creator8;
GRANT USAGE ON SCHEMA mustream_schm TO creator8;
GRANT creator TO creator8;

-- CREATE USER creator9 WITH PASSWORD 'creator9pass';
GRANT CONNECT ON DATABASE mustream TO creator9;
GRANT USAGE ON SCHEMA mustream_schm TO creator9;
GRANT creator TO creator9;

-- CREATE USER creator10 WITH PASSWORD 'creator10pass';
GRANT CONNECT ON DATABASE mustream TO creator10;
GRANT USAGE ON SCHEMA mustream_schm TO creator10;
GRANT creator TO creator10;

/*LISTENERS*/
-- CREATE USER listener1 WITH PASSWORD 'listener1pass';
GRANT CONNECT ON DATABASE mustream TO listener1;
GRANT USAGE ON SCHEMA mustream_schm TO listener1;
GRANT listener TO listener1;

-- CREATE USER listener2 WITH PASSWORD 'listener2pass';
GRANT CONNECT ON DATABASE mustream TO listener2;
GRANT USAGE ON SCHEMA mustream_schm TO listener2;
GRANT listener TO listener2;

-- CREATE USER listener3 WITH PASSWORD 'listener3pass';
GRANT CONNECT ON DATABASE mustream TO listener3;
GRANT USAGE ON SCHEMA mustream_schm TO listener3;
GRANT listener TO listener3;

-- CREATE USER listener4 WITH PASSWORD 'listener4pass';
GRANT CONNECT ON DATABASE mustream TO listener4;
GRANT USAGE ON SCHEMA mustream_schm TO listener4;
GRANT listener TO listener4;

-- CREATE USER listener5 WITH PASSWORD 'listener5pass';
GRANT CONNECT ON DATABASE mustream TO listener5;
GRANT USAGE ON SCHEMA mustream_schm TO listener5;
GRANT listener TO listener5;

-- CREATE USER listener6 WITH PASSWORD 'listener6pass';
GRANT CONNECT ON DATABASE mustream TO listener6;
GRANT USAGE ON SCHEMA mustream_schm TO listener6;
GRANT listener TO listener6;

-- CREATE USER listener7 WITH PASSWORD 'listener7pass';
GRANT CONNECT ON DATABASE mustream TO listener7;
GRANT USAGE ON SCHEMA mustream_schm TO listener7;
GRANT listener TO listener7;

-- CREATE USER listener8 WITH PASSWORD 'listener8pass';
GRANT CONNECT ON DATABASE mustream TO listener8;
GRANT USAGE ON SCHEMA mustream_schm TO listener8;
GRANT listener TO listener8;

-- CREATE USER listener9 WITH PASSWORD 'listener9pass';
GRANT CONNECT ON DATABASE mustream TO listener9;
GRANT USAGE ON SCHEMA mustream_schm TO listener9;
GRANT listener TO listener9;

-- CREATE USER listener10 WITH PASSWORD 'listener10pass';
GRANT CONNECT ON DATABASE mustream TO listener10;
GRANT USAGE ON SCHEMA mustream_schm TO listener10;
GRANT listener TO listener10;

-- CREATE USER listener11 WITH PASSWORD 'listener11pass';
GRANT CONNECT ON DATABASE mustream TO listener11;
GRANT USAGE ON SCHEMA mustream_schm TO listener11;
GRANT listener TO listener11;

-- CREATE USER listener12 WITH PASSWORD 'listener12pass';
GRANT CONNECT ON DATABASE mustream TO listener12;
GRANT USAGE ON SCHEMA mustream_schm TO listener12;
GRANT listener TO listener12;

-- CREATE USER listener13 WITH PASSWORD 'listener13pass';
GRANT CONNECT ON DATABASE mustream TO listener13;
GRANT USAGE ON SCHEMA mustream_schm TO listener13;
GRANT listener TO listener13;

-- CREATE USER listener14 WITH PASSWORD 'listener14pass';
GRANT CONNECT ON DATABASE mustream TO listener14;
GRANT USAGE ON SCHEMA mustream_schm TO listener14;
GRANT listener TO listener14;

-- CREATE USER listener15 WITH PASSWORD 'listener15pass';
GRANT CONNECT ON DATABASE mustream TO listener15;
GRANT USAGE ON SCHEMA mustream_schm TO listener15;
GRANT listener TO listener15;