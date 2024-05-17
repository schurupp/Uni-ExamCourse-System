CREATE TABLE faculties (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE departments (
    id INT AUTO_INCREMENT PRIMARY KEY,
	faculty_id INT,
	FOREIGN KEY (faculty_id) REFERENCES faculties(id),
    name VARCHAR(100) NOT NULL
);

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
	department_id INT,
    role ENUM('assistant', 'secretary', 'head_of_department', 'head_of_secretary', 'dean') NOT NULL,
    name VARCHAR(100) NOT NULL,
	FOREIGN KEY (department_id) REFERENCES departments(id)
);

CREATE TABLE courses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(10) NOT NULL,
    name VARCHAR(100) NOT NULL,
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(id)
);

CREATE TABLE course_schedule (
    id INT AUTO_INCREMENT PRIMARY KEY,
    course_id INT NOT NULL,
    day_of_week ENUM('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday') NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    FOREIGN KEY (course_id) REFERENCES courses(id)
);

CREATE TABLE exams (
    id INT AUTO_INCREMENT PRIMARY KEY,
    course_id INT,
    date DATE,
    start_time TIME,
    end_time TIME,
    num_assistants INT,
    FOREIGN KEY (course_id) REFERENCES courses(id)
);

CREATE TABLE assistants (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    department_id INT,
    score INT DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (department_id) REFERENCES departments(id)
);

CREATE TABLE exam_assistants (
    exam_id INT,
    assistant_id INT,
    PRIMARY KEY (exam_id, assistant_id),
    FOREIGN KEY (exam_id) REFERENCES exams(id),
    FOREIGN KEY (assistant_id) REFERENCES assistants(id)
);

CREATE TABLE course_assistants (
    assistant_id INT,
    course_id INT,
    PRIMARY KEY (assistant_id, course_id),
    FOREIGN KEY (assistant_id) REFERENCES assistants(id),
    FOREIGN KEY (course_id) REFERENCES courses(id)
);

-- Inserting data into the faculties table
INSERT INTO faculties (name) VALUES
('Faculty of Science'),
('Faculty of Arts'),
('Faculty of Engineering'),
('Faculty of Medicine'),
('Faculty of Business');

-- Inserting data into the departments table
INSERT INTO departments (name, faculty_id) VALUES
('Department of Physics', 1),
('Department of Mathematics', 1),
('Department of Astronomy', 1),
('Department of Biology', 1),
('Department of Chemistry', 1),
('Department of English', 2),
('Department of Archaelogy', 2),
('Department of History', 2),
('Department of Philosophy', 2),
('Department of Linguistics', 2),
('Department of Computer Engineering', 3),
('Department of Mechanical Engineering', 3),
('Department of Civil Engineering', 3),
('Department of Electrical Engineering', 3),
('Department of Chemical Engineering', 3),
('Department of Immunology', 4),
('Department of Infectious Disease', 4),
('Department of Public Health', 4),
('Department of Surgery and Cancer', 4),
('Department of Anatomy', 4),
('Department of Economics', 5),
('Department of Business Administration', 5),
('Department of Entrepreneurship', 5),
('Department of Trade and Business', 5),
('Department of Finance', 5);

-- Inserting data into the users table
INSERT INTO users (username, password, role, name, department_id) VALUES
('sebnem_baydere', 'password5', 'dean', 'Şebnem Baydere', 1),
('gulveli_kaya', 'password5', 'dean', 'Gülveli Kaya', 8),
('cem_unsalan', 'password5', 'dean', 'Cem Ünsalan', 11),
('sina_ercan', 'password5', 'dean', 'Sina Ercan', 20),
('duzgun_arslan', 'password5', 'dean', 'Düzgün Arslan', 21),
('bekir_bozkurt', 'password4', 'head_of_secretary', 'Bekir Bozkurt', 1),
('halil_ibrahim_isik', 'password4', 'head_of_secretary', 'Halil İbrahim Işık', 8),
('huseyin_keskin', 'password4', 'head_of_secretary', 'Hüseyin Keskin', 11),
('ismail_sari', 'password4', 'head_of_secretary', 'İsmail Sarı', 20),
('yasar_ozkan', 'password4', 'head_of_secretary', 'Yaşar Özkan', 21),
('yusuf_gul', 'password3', 'head_of_department', 'Yusuf Gül', 1),
('bekir_yalcin', 'password3', 'head_of_department', 'Bekir Yalçın', 2),
('sukru_ozkan', 'password3', 'head_of_department', 'Şükrü Özkan', 3),
('musa_sen', 'password3', 'head_of_department', 'Musa Şen', 4),
('cemal_kara', 'password3', 'head_of_department', 'Cemal Kara', 5),
('orhan_sarin', 'password3', 'head_of_department', 'Orhan Sarın', 6),
('onur_cetin', 'password3', 'head_of_department', 'Onur Çetin', 7),
('kadir_erdogan', 'password3', 'head_of_department', 'Kadir Erdoğan', 8),
('muhammet_yalcin', 'password3', 'head_of_department', 'Muhammet Yalçın', 9),
('mehmet_gunes', 'password3', 'head_of_department', 'Mehmet Güneş', 10),
('salih_cakir', 'password3', 'head_of_department', 'Salih Çakır', 11),
('ahmet_yildiz', 'password3', 'head_of_department', 'Ahmet Yıldız', 12),
('suleyman_ozdemir', 'password3', 'head_of_department', 'Süleyman Özdemir', 13),
('emre_sen', 'password3', 'head_of_department', 'Emre Şen', 14),
('metin_bozkurt', 'password3', 'head_of_department', 'Metin Bozkurt', 15),
('huseyin_demir', 'password3', 'head_of_department', 'Hüseyin Demir', 16),
('suleyman_arslan', 'password3', 'head_of_department', 'Süleyman Aslan', 17),
('mustafa_sanli', 'password3', 'head_of_department', 'Mustafa Canlı', 18),
('kamil_yelek', 'password3', 'head_of_department', 'Kamil Yelek', 19),
('husnu_yenigun', 'password3', 'head_of_department', 'Hüsnü Yenigün', 20),
('ahmet_demirelli', 'password3', 'head_of_department', 'Ahmet Demirelli', 21),
('albert_erkip', 'password3', 'head_of_department', 'Albert Erkip', 22),
('ahmet_gungor', 'password3', 'head_of_department', 'Ahmet Güngör', 23),
('ali_kosar', 'password3', 'head_of_department', 'Ali Koşar', 24),
('alev_topuzoglu', 'password3', 'head_of_department', 'Alev Topuzoğlu', 25),
('ali_rana_atilgan', 'password3', 'secretary', 'Ali Rana Atılgan', 1),
('alp_yurum', 'password3', 'secretary', 'Alp Yürüm', 2),
('altug_tanaltay', 'password3', 'secretary', 'Altuğ Tanaltay', 3),
('asif_sabanovic', 'password3', 'secretary', 'Asif Şabanoviç', 4),
('bahattin_koc', 'password3', 'secretary', 'Bahattin Koç', 5),
('ayhan_bozkurt', 'password3', 'secretary', 'Ayhan Bozkurt', 6),
('ayesha_asloob_topacoglu', 'password3', 'secretary', 'Ayesha Asloob Topaçoğlu', 7),
('atil_utku_ay', 'password3', 'secretary', 'Atıl Utku Ay', 8),
('baris_balcioglu', 'password3', 'secretary', 'Barış Balcıoğlu', 9),
('bekir_bediz', 'password3', 'secretary', 'Bekir Bediz', 10),
('bekir_dizman', 'password3', 'secretary', 'Bekir Dızman', 11),
('berrin_yanikoglu', 'password3', 'secretary', 'Berrin Yanıkoğlu', 12),
('beyhan_pulice', 'password3', 'secretary', 'Beyhan Puliçe', 13),
('beyza_vurusaner_aktas', 'password3', 'secretary', 'Beyza Vuruşaner Aktaş', 14),
('bulent_catay', 'password3', 'secretary', 'Bülent Çatay', 15),
('burak_kocuk', 'password3', 'secretary', 'Burak Kocuk', 16),
('burc_misirlioglu', 'password3', 'secretary', 'Burç Mısırlıoğlu', 17),
('burcin_gul', 'password3', 'secretary', 'Burçin Gül', 18),
('burcu_saner_okan', 'password3', 'secretary', 'Burcu Saner Okan', 19),
('canan_atilgan', 'password3', 'secretary', 'Canan Atılgan', 20),
('cem_guneri', 'password3', 'secretary', 'Cem Güneri', 21),
('cemal_yilmaz', 'password3', 'secretary', 'Cemal Yılmaz', 22),
('duygu_tas', 'password3', 'secretary', 'Duygu Taş', 23),
('emrah_kalemci', 'password3', 'secretary', 'Emrah Kalemci', 24),
('emre_erdem', 'password3', 'secretary', 'Emre Erdem', 25),
('erhan_budak', 'password1', 'assistant', 'Erhan Budak', 1),
('erkay_savas', 'password1', 'assistant', 'Erkay Savaş', 2),
('ersin_gogus', 'password1', 'assistant', 'Ersin Göğüş', 3),
('esra_erdem', 'password1', 'assistant', 'Esra Erdem', 4),
('esra_koca', 'password1', 'assistant', 'Esra Koca', 5),
('ezgi_karabulut', 'password1', 'assistant', 'Ezgi Karabulut Türkseven', 6),
('ferruh_ozbudak', 'password1', 'assistant', 'Ferruh Özbudak', 7),
('fevzi_cakmak_cebeci', 'password1', 'assistant', 'Fevzi Çakmak Cebeci', 8),
('gizem_ozbaygin', 'password1', 'assistant', 'Gizem Özbaygın', 9),
('gokalp_alpan', 'password1', 'assistant', 'Gökalp Alpan', 10),
('gozde_ince', 'password1', 'assistant', 'Gözde İnce', 11),
('gozde_ozbal_sargin', 'password1', 'assistant', 'Gözde Özbal Sargın', 12),
('gul_kozalak', 'password1', 'assistant', 'Gül Kozalak', 13),
('gullu_kiziltas', 'password1', 'assistant', 'Güllü Kızıltaş Şendur', 14),
('gulsen_demiroz', 'password1', 'assistant', 'Gülşen Demiröz', 15),
('gunduz_ulusoy', 'password1', 'assistant', 'Gündüz Ulusoy', 16),
('hasan_mandal', 'password1', 'assistant', 'Hasan Mandal', 17),
('hasan_sait_olmez', 'password1', 'assistant', 'Hasan Sait Ölmez', 18),
('hatice_sinem_sas', 'password1', 'assistant', 'Hatice Sinem Şaş Çaycı', 19),
('huseyin_ozkan', 'password1', 'assistant', 'Hüseyin Özkan', 20),
('husnu_eskigun', 'password1', 'assistant', 'Hüsnü Eskigün', 21),
('huveyda_basaga', 'password1', 'assistant', 'Hüveyda Başağa', 22),
('ibrahim_tekin', 'password1', 'assistant', 'İbrahim Tekin', 23),
('ihsan_sadati', 'password1', 'assistant', 'İhsan Sadati', 24),
('inanc_adagideli', 'password1', 'assistant', 'İnanç Adagideli', 25),
('semih_senturk', 'password1', 'assistant', 'Semih Şentürk', 1),
('berkan_algur', 'password1', 'assistant', 'Berkan Algür', 1);

-- Inserting data into the courses table
INSERT INTO courses (code, name, department_id)  VALUES
('PHYS200', 'Electromagnetism', 1),
('PHYS300', 'Optics', 1),
('PHYS400', 'Quantum Mechanics', 1),
('MATH200', 'Calculus', 2),
('MATH300', 'Lineer Algebra', 2),
('MATH400', 'Equations', 2),
('ASTRO200', 'Stars', 3),
('ASTRO300', 'Cosmological Physics', 3),
('ASTRO300', 'Galaxies', 3),
('BIO200', 'Ecology', 4),
('BIO300', 'Biochemistry', 4),
('BIO400', 'Genetics', 4),
('CHEM200', 'Organic Chemistry', 5),
('CHEM300', 'Analytical Chemistry', 5),
('CHEM400', 'Inorganic Chemistry', 5),
('ENG200', 'English Grammar', 6),
('ENG300', 'Literature and Gender', 6),
('ENG400', 'Ethnic Literatures of the U.S.', 6),
('ARC200', 'Great Discoveries in Archaeology', 7),
('ARC300', 'Archaeology of Cities', 7),
('ARC400', 'Ancient Technology', 7),
('HIS200', 'Europe in the 20th century', 8),
('HIS300', 'France 1774-1794: reform and revolution', 8),
('HIS400', 'Contested nation: Germany, 1871-1918', 8),
('PHI200', 'Metaphysics', 9),
('PHI300', 'Philosophical problems', 9),
('PHI400', 'Realism and normativity', 9),
('LING200', 'Introduction to Linguistics', 10),
('LING300', 'Semantics', 10),
('LING400', 'Corpus linguistics', 10),
('COMP200', 'Object Oriented Programming', 11),
('COMP300', 'Algorithm Analysis', 11),
('COMP400', 'Network', 11),
('MECH200', 'Engineering concepts', 12),
('MECH300', 'Mechatronics', 12),
('MECH400', 'Mechanics of fluids', 12),
('CIV200', 'Structural Engineering', 13),
('CIV300', 'Transportation Engineering', 13),
('CIV400', 'Geotechnical engineering', 13),
('EE200', 'Digital electronics', 14),
('EE300', 'Analysis of circuits', 14),
('EE400', 'Sensing and signals', 14),
('CHEM200', 'Material sciences and engineering', 15),
('CHEM300', 'Engineering design fundamentals', 15),
('CHEM400', 'Industrial chemistry', 15),
('IMMUN200', 'Cell Development', 16),
('IMMUN300', 'Engineering CAR T Cells', 16),
('IMMUN400', 'Redefining Human Immunology', 16),
('INFEC200', 'Introduction to Bioinformatics', 17),
('INFEC300', 'Molecular Pathogenesis', 17),
('INFEC400', 'The History of Infections', 17),
('PUB200', 'Health promotion', 18),
('PUB300', 'Health informatics', 18),
('PUB400', 'Healthcare Management', 18),
('SUR200', 'Intruduction to General surgery', 19),
('SUR300', 'Basic Surgical Skills', 19),
('SUR400', 'Operating Room Techniques', 19),
('ANAT200', 'Molecules and cells', 20),
('ANAT300', 'Functional neuroanatomy', 20),
('ANAT400', 'Practical human anatomy', 20),
('ECON200', 'Microeconomic theory', 21),
('ECON300', 'Economics principles', 21),
('ECON400', 'Principles of marketing and strategy', 21),
('ADM200', 'Introduction to Commercial law', 22),
('ADM300', 'Public Administration', 22),
('ADM400', 'Human Resources', 22),
('ENT200', 'Creativity in entrepreneurship', 23),
('ENT300', 'Finance', 23),
('ENT400', 'Affiliate marketing', 23),
('TRD200', 'International Trade Theories and Policies', 24),
('TRD300', 'International Economic Law', 24),
('TRD400', 'International Trade Operations', 24),
('FIN200', 'Corporate Finance', 25),
('FIN300', 'Advanced Corp Finance', 25),
('FIN400', 'Real Estate Investments', 25);

INSERT INTO course_schedule (course_id, day_of_week, start_time, end_time)
VALUES
    -- PHYS200 - Electromagnetism
    (1, 'Monday', '09:00:00', '11:00:00'),
    (1, 'Wednesday', '13:00:00', '15:00:00'),

    -- PHYS300 - Optics
    (2, 'Tuesday', '10:00:00', '12:00:00'),
    (2, 'Thursday', '14:00:00', '16:00:00'),

    -- PHYS400 - Quantum Mechanics
    (3, 'Monday', '13:00:00', '15:00:00'),
    (3, 'Wednesday', '09:00:00', '11:00:00'),

    -- MATH200 - Calculus
    (4, 'Tuesday', '09:00:00', '11:00:00'),
    (4, 'Thursday', '13:00:00', '15:00:00'),

    -- MATH300 - Linear Algebra
    (5, 'Monday', '10:00:00', '12:00:00'),
    (5, 'Wednesday', '14:00:00', '16:00:00'),

    -- MATH400 - Equations
    (6, 'Tuesday', '13:00:00', '15:00:00'),
    (6, 'Thursday', '10:00:00', '12:00:00'),

    -- ASTRO200 - Stars
    (7, 'Monday', '14:00:00', '16:00:00'),
    (7, 'Wednesday', '10:00:00', '12:00:00'),

    -- ASTRO300 - Cosmological Physics
    (8, 'Tuesday', '11:00:00', '13:00:00'),
    (8, 'Thursday', '15:00:00', '17:00:00'),

    -- ASTRO400 - Galaxies
    (9, 'Monday', '11:00:00', '13:00:00'),
    (9, 'Wednesday', '15:00:00', '17:00:00'),

    -- BIO200 - Ecology
    (10, 'Tuesday', '14:00:00', '16:00:00'),
    (10, 'Thursday', '09:00:00', '11:00:00'),

    -- BIO300 - Biochemistry
    (11, 'Monday', '15:00:00', '17:00:00'),
    (11, 'Wednesday', '11:00:00', '13:00:00'),

    -- BIO400 - Genetics
    (12, 'Tuesday', '15:00:00', '17:00:00'),
    (12, 'Thursday', '14:00:00', '16:00:00'),

    -- CHEM200 - Organic Chemistry
    (13, 'Monday', '16:00:00', '18:00:00'),
    (13, 'Wednesday', '12:00:00', '14:00:00'),

    -- CHEM300 - Analytical Chemistry
    (14, 'Tuesday', '16:00:00', '18:00:00'),
    (14, 'Thursday', '15:00:00', '17:00:00'),

    -- CHEM400 - Inorganic Chemistry
    (15, 'Monday', '17:00:00', '19:00:00'),
    (15, 'Wednesday', '13:00:00', '15:00:00'),

    -- ENG200 - English Grammar
    (16, 'Tuesday', '08:00:00', '10:00:00'),
    (16, 'Thursday', '14:00:00', '16:00:00'),

    -- ENG300 - Literature and Gender
    (17, 'Monday', '09:00:00', '11:00:00'),
    (17, 'Wednesday', '15:00:00', '17:00:00'),

    -- ENG400 - Ethnic Literatures of the U.S.
    (18, 'Tuesday', '10:00:00', '12:00:00'),
    (18, 'Thursday', '16:00:00', '18:00:00'),

    -- ARC200 - Great Discoveries in Archaeology
    (19, 'Monday', '11:00:00', '13:00:00'),
    (19, 'Wednesday', '14:00:00', '16:00:00'),

    -- ARC300 - Archaeology of Cities
    (20, 'Tuesday', '09:00:00', '11:00:00'),
    (20, 'Thursday', '13:00:00', '15:00:00'),

    -- ARC400 - Ancient Technology
    (21, 'Monday', '10:00:00', '12:00:00'),
    (21, 'Wednesday', '16:00:00', '18:00:00'),

    -- HIS200 - Europe in the 20th century
    (22, 'Tuesday', '09:00:00', '11:00:00'),
    (22, 'Thursday', '15:00:00', '17:00:00'),

    -- HIS300 - France 1774-1794: reform and revolution
    (23, 'Monday', '14:00:00', '16:00:00'),
    (23, 'Wednesday', '10:00:00', '12:00:00'),

    -- HIS400 - Contested nation: Germany, 1871-1918
    (24, 'Tuesday', '11:00:00', '13:00:00'),
    (24, 'Thursday', '16:00:00', '18:00:00'),

    -- PHI200 - Metaphysics
    (25, 'Monday', '09:00:00', '11:00:00'),
    (25, 'Wednesday', '13:00:00', '15:00:00'),

    -- PHI300 - Philosophical problems
    (26, 'Tuesday', '10:00:00', '12:00:00'),
    (26, 'Thursday', '14:00:00', '16:00:00'),

    -- PHI400 - Realism and normativity
    (27, 'Monday', '13:00:00', '15:00:00'),
    (27, 'Wednesday', '09:00:00', '11:00:00'),

    -- LING200 - Introduction to Linguistics
    (28, 'Tuesday', '14:00:00', '16:00:00'),
    (28, 'Thursday', '10:00:00', '12:00:00'),
	
	-- LING300 - Semantics
    (29, 'Monday', '13:00:00', '15:00:00'),
	(29, 'Wednesday', '09:00:00', '11:00:00'),

    -- LING400 - Corpus linguistics
    (30, 'Tuesday', '10:00:00', '12:00:00'),
    (30, 'Thursday', '14:00:00', '16:00:00'),

    -- COMP200 - Object Oriented Programming
    (31, 'Monday', '09:00:00', '11:00:00'),
    (31, 'Wednesday', '13:00:00', '15:00:00'),

    -- COMP300 - Algorithm Analysis
    (32, 'Tuesday', '10:00:00', '12:00:00'),
    (32, 'Thursday', '14:00:00', '16:00:00'),

    -- COMP400 - Network
    (33, 'Monday', '13:00:00', '15:00:00'),
    (33, 'Wednesday', '09:00:00', '11:00:00'),

    -- MECH200 - Engineering concepts
    (34, 'Tuesday', '14:00:00', '16:00:00'),
    (34, 'Thursday', '10:00:00', '12:00:00'),

    -- MECH300 - Mechatronics
    (35, 'Monday', '09:00:00', '11:00:00'),
    (35, 'Wednesday', '13:00:00', '15:00:00'),

    -- MECH400 - Mechanics of fluids
    (36, 'Tuesday', '10:00:00', '12:00:00'),
    (36, 'Thursday', '14:00:00', '16:00:00'),

    -- CIV200 - Structural Engineering
    (37, 'Monday', '13:00:00', '15:00:00'),
    (37, 'Wednesday', '09:00:00', '11:00:00'),

    -- CIV300 - Transportation Engineering
    (38, 'Tuesday', '10:00:00', '12:00:00'),
    (38, 'Thursday', '14:00:00', '16:00:00'),

    -- CIV400 - Geotechnical engineering
    (39, 'Monday', '13:00:00', '15:00:00'),
    (39, 'Wednesday', '09:00:00', '11:00:00'),

    -- EE200 - Digital electronics
    (40, 'Tuesday', '14:00:00', '16:00:00'),
    (40, 'Thursday', '10:00:00', '12:00:00'),

    -- EE300 - Analysis of circuits
    (41, 'Monday', '09:00:00', '11:00:00'),
    (41, 'Wednesday', '13:00:00', '15:00:00'),

    -- EE400 - Sensing and signals
    (42, 'Tuesday', '10:00:00', '12:00:00'),
    (42, 'Thursday', '14:00:00', '16:00:00'),

    -- CHEM200 - Material sciences and engineering
    (43, 'Monday', '13:00:00', '15:00:00'),
    (43, 'Wednesday', '09:00:00', '11:00:00'),

    -- CHEM300 - Engineering design fundamentals
    (44, 'Tuesday', '14:00:00', '16:00:00'),
    (44, 'Thursday', '10:00:00', '12:00:00'),

    -- CHEM400 - Industrial chemistry
    (45, 'Monday', '09:00:00', '11:00:00'),
    (45, 'Wednesday', '13:00:00', '15:00:00'),

    -- IMMUN200 - Cell Development
    (46, 'Tuesday', '10:00:00', '12:00:00'),
    (46, 'Thursday', '14:00:00', '16:00:00'),

    -- IMMUN300 - Engineering CAR T Cells
    (47, 'Monday', '13:00:00', '15:00:00'),
    (47, 'Wednesday', '09:00:00', '11:00:00'),

    -- IMMUN400 - Redefining Human Immunology
    (48, 'Tuesday', '14:00:00', '16:00:00'),
    (48, 'Thursday', '10:00:00', '12:00:00'),

    -- INFEC200 - Introduction to Bioinformatics
    (49, 'Monday', '09:00:00', '11:00:00'),
    (49, 'Wednesday', '13:00:00', '15:00:00'),

    -- INFEC300 - Molecular Pathogenesis
    (50, 'Tuesday', '14:00:00', '16:00:00'),
    (50, 'Thursday', '10:00:00', '12:00:00'),

    -- INFEC400 - The History of Infections
    (51, 'Monday', '13:00:00', '15:00:00'),
    (51, 'Wednesday', '09:00:00', '11:00:00'),

    -- PUB200 - Health promotion
    (52, 'Tuesday', '14:00:00', '16:00:00'),
    (52, 'Thursday', '10:00:00', '12:00:00'),

    -- PUB300 - Health informatics
    (53, 'Monday', '09:00:00', '11:00:00'),
    (53, 'Wednesday', '13:00:00', '15:00:00'),

    -- PUB400 - Healthcare Management
    (54, 'Tuesday', '14:00:00', '16:00:00'),
	(54, 'Thursday', '10:00:00', '16:00:00'),
	
	-- ANAT300 - Functional neuroanatomy
    (59, 'Monday', '13:00:00', '15:00:00'),
    (59, 'Wednesday', '09:00:00', '11:00:00'),

    -- ANAT400 - Practical human anatomy
    (60, 'Tuesday', '14:00:00', '16:00:00'),
    (60, 'Thursday', '10:00:00', '12:00:00'),

    -- ECON200 - Microeconomic theory
    (61, 'Monday', '09:00:00', '11:00:00'),
    (61, 'Wednesday', '13:00:00', '15:00:00'),

    -- ECON300 - Economics principles
    (62, 'Tuesday', '14:00:00', '16:00:00'),
    (62, 'Thursday', '10:00:00', '12:00:00'),

    -- ECON400 - Principles of marketing and strategy
    (63, 'Monday', '13:00:00', '15:00:00'),
    (63, 'Wednesday', '09:00:00', '11:00:00'),

    -- ADM200 - Introduction to Commercial law
    (64, 'Tuesday', '14:00:00', '16:00:00'),
    (64, 'Thursday', '10:00:00', '12:00:00'),

    -- ADM300 - Public Administration
    (65, 'Monday', '09:00:00', '11:00:00'),
    (65, 'Wednesday', '13:00:00', '15:00:00'),

    -- ADM400 - Human Resources
    (66, 'Tuesday', '14:00:00', '16:00:00'),
    (66, 'Thursday', '10:00:00', '12:00:00'),

    -- ENT200 - Creativity in entrepreneurship
    (67, 'Monday', '13:00:00', '15:00:00'),
    (67, 'Wednesday', '09:00:00', '11:00:00'),

    -- ENT300 - Finance
    (68, 'Tuesday', '14:00:00', '16:00:00'),
    (68, 'Thursday', '10:00:00', '12:00:00'),

    -- ENT400 - Affiliate marketing
    (69, 'Monday', '09:00:00', '11:00:00'),
    (69, 'Wednesday', '13:00:00', '15:00:00'),

    -- TRD200 - International Trade Theories and Policies
    (70, 'Tuesday', '14:00:00', '16:00:00'),
    (70, 'Thursday', '10:00:00', '12:00:00'),

    -- TRD300 - International Economic Law
    (71, 'Monday', '13:00:00', '15:00:00'),
    (71, 'Wednesday', '09:00:00', '11:00:00'),

    -- TRD400 - International Trade Operations
    (72, 'Tuesday', '14:00:00', '16:00:00'),
    (72, 'Thursday', '10:00:00', '12:00:00'),

    -- FIN200 - Corporate Finance
    (73, 'Monday', '09:00:00', '11:00:00'),
    (73, 'Wednesday', '13:00:00', '15:00:00'),

    -- FIN300 - Advanced Corp Finance
    (74, 'Tuesday', '14:00:00', '16:00:00'),
    (74, 'Thursday', '10:00:00', '12:00:00'),

    -- FIN400 - Real Estate Investments
    (75, 'Monday', '13:00:00', '15:00:00'),
    (75, 'Wednesday', '09:00:00', '11:00:00');

-- Inserting data into the assistants table
INSERT INTO assistants (user_id, department_id, score) VALUES
(61, 1, 1),
(62, 2, 1),
(63, 3, 1),
(64, 4, 1),
(65, 5, 1),
(66, 6, 1),
(67, 7, 1),
(68, 8, 1),
(69, 9, 1),
(70, 10, 1),
(71, 11, 1),
(72, 12, 1),
(73, 13, 1),
(74, 14, 1),
(75, 15, 1),
(76, 16, 1),
(77, 17, 1),
(78, 18, 1),
(79, 19, 1),
(80, 20, 1),
(81, 21, 1),
(82, 22, 1),
(83, 23, 1),
(84, 24, 1),
(85, 25, 1),
(86, 1, 1),
(87, 1, 1);