INSERT INTO mustream_schm.users (username, email, password_hash, role)
VALUES
    -- Developers
    ('dev1', 'dev1@example.com', 'dev1pass', 'developer'),
    ('dev2', 'dev2@example.com', 'dev2pass', 'developer'),
    ('dev3', 'dev3@example.com', 'dev1pass', 'developer'),
    ('dev4', 'dev4@example.com', 'dev1pass', 'developer'),

    -- Managers
    ('manager1', 'manager1@example.com', 'manager1pass', 'management'),
    ('manager2', 'manager2@example.com', 'manager2pass', 'management'),
    ('manager3', 'manager3@example.com', 'manager3pass', 'management'),
    ('manager4', 'manager4@example.com', 'manager4pass', 'management'),
    ('manager5', 'manager5@example.com', 'manager5pass', 'management'),

    -- Creators
    ('creator1', 'creator1@example.com', 'creator1pass', 'creator'),
    ('creator2', 'creator2@example.com', 'creator2pass', 'creator'),
    ('creator3', 'creator3@example.com', 'creator3pass', 'creator'),
    ('creator4', 'creator4@example.com', 'creator4pass', 'creator'),
    ('creator5', 'creator5@example.com', 'creator5pass', 'creator'),
    ('creator6', 'creator6@example.com', 'creator6pass', 'creator'),
    ('creator7', 'creator7@example.com', 'creator7pass', 'creator'),
    ('creator8', 'creator8@example.com', 'creator8pass', 'creator'),
    ('creator9', 'creator9@example.com', 'creator9pass', 'creator'),
    ('creator10', 'creator10@example.com', 'creator10pass', 'creator'),

    -- Listeners
    ('listener1', 'listener1@example.com', 'listener1pass', 'listener'),
    ('listener2', 'listener2@example.com', 'listener2pass', 'listener'),
    ('listener3', 'listener3@example.com', 'listener3pass', 'listener'),
    ('listener4', 'listener4@example.com', 'listener4pass', 'listener'),
    ('listener5', 'listener5@example.com', 'listener5pass', 'listener'),
    ('listener6', 'listener6@example.com', 'listener6pass', 'listener'),
    ('listener7', 'listener7@example.com', 'listener7pass', 'listener'),
    ('listener8', 'listener8@example.com', 'listener8pass', 'listener'),
    ('listener9', 'listener9@example.com', 'listener9pass', 'listener'),
    ('listener10', 'listener10@example.com', 'listener10pass', 'listener'),
    ('listener11', 'listener11@example.com', 'listener11pass', 'listener'),
    ('listener12', 'listener12@example.com', 'listener12pass', 'listener'),
    ('listener13', 'listener13@example.com', 'listener13pass', 'listener'),
    ('listener14', 'listener14@example.com', 'listener14pass', 'listener'),
    ('listener15', 'listener15@example.com', 'listener15pass', 'listener');