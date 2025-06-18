CREATE DATABASE IF NOT EXISTS edoc;
USE edoc;


-- admin table 

DROP TABLE IF EXISTS admin;
CREATE TABLE admin (
  aemail VARCHAR(255) NOT NULL,
  apassword VARCHAR(255) DEFAULT NULL,
  PRIMARY KEY (aemail)
);
INSERT INTO admin VALUES ('admin@edoc.com', '123');



-- webuser table  


DROP TABLE IF EXISTS webuser;
CREATE TABLE webuser (
  email VARCHAR(255) NOT NULL,
  usertype CHAR(1), -- a = admin, d = doctor, p = patient
  PRIMARY KEY (email)
);
INSERT INTO webuser VALUES
('admin@edoc.com', 'a'),
('doctor@edoc.com', 'd'),
('patient@edoc.com', 'p'),
('emhashenudara@gmail.com', 'p');


-- table : specialties 

DROP TABLE IF EXISTS specialties;
CREATE TABLE specialties (
  id INT(2) PRIMARY KEY,
  sname VARCHAR(50)
);
INSERT INTO specialties VALUES
(1, 'Accident and emergency medicine'),
(5, 'Cardiology'),
(13, 'Dermatology');

-- TABLE: doctor

DROP TABLE IF EXISTS doctor;
CREATE TABLE doctor (
  docid INT AUTO_INCREMENT PRIMARY KEY,
  docemail VARCHAR(255),
  docname VARCHAR(255),
  docpassword VARCHAR(255),
  docnic VARCHAR(15),
  doctel VARCHAR(15),
  specialties INT,
  FOREIGN KEY (specialties) REFERENCES specialties(id)
);
INSERT INTO doctor VALUES
(1, 'doctor@edoc.com', 'Test Doctor', '123', '000000000', '0110000000', 1);

-- TABLE: patient

INSERT INTO patient VALUES
(1, 'patient@edoc.com', 'Test Patient', '123', 'Sri Lanka', '0000000000', '2000-01-01', '0120000000'),
(2, 'emhashenudara@gmail.com', 'Hashen Udara', '123', 'Sri Lanka', '0110000000', '2022-06-03', '0700000000');

-- TABLE: schedule
DROP TABLE IF EXISTS schedule;
CREATE TABLE schedule (
  scheduleid INT AUTO_INCREMENT PRIMARY KEY,
  docid INT,
  title VARCHAR(255),
  scheduledate DATE,
  scheduletime TIME,
  nop INT,
  FOREIGN KEY (docid) REFERENCES doctor(docid)
);
INSERT INTO schedule VALUES
(1, 1, 'Test Session', '2050-01-01', '18:00:00', 50);

-- TABLE: appointment
DROP TABLE IF EXISTS appointment;
CREATE TABLE appointment (
  appoid INT AUTO_INCREMENT PRIMARY KEY,
  pid INT,
  apponum INT,
  scheduleid INT,
  appodate DATE,
  meeting_link VARCHAR(255),
  status ENUM('Scheduled', 'Cancelled', 'Completed') DEFAULT 'Scheduled',
  FOREIGN KEY (pid) REFERENCES patient(pid),
  FOREIGN KEY (scheduleid) REFERENCES schedule(scheduleid)
);
INSERT INTO appointment VALUES
(1, 1, 1, 1, '2022-06-03', 'https://meet.edoc.com/abc123', 'Scheduled');



-- TABLE: consultation_records
DROP TABLE IF EXISTS consultation_records;
CREATE TABLE consultation_records (
  consultation_id INT AUTO_INCREMENT PRIMARY KEY,
  appoid INT,
  notes TEXT,
  prescription TEXT,
  outcome TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (appoid) REFERENCES appointment(appoid)
);
INSERT INTO consultation_records (appoid, notes, prescription, outcome) VALUES
(1, 'Patient reported chest pain.', 'Paracetamol 500mg', 'Advised to follow up in a week');

-- TABLE: notifications
DROP TABLE IF EXISTS notifications;
CREATE TABLE notifications (
  notification_id INT AUTO_INCREMENT PRIMARY KEY,
  pid INT,
  appoid INT,
  type ENUM('Reminder', 'Confirmation', 'Cancellation'),
  status ENUM('Pending', 'Sent'),
  sent_at DATETIME,
  FOREIGN KEY (pid) REFERENCES patient(pid),
  FOREIGN KEY (appoid) REFERENCES appointment(appoid)
);
INSERT INTO notifications (pid, appoid, type, status, sent_at) VALUES
(1, 1, 'Reminder', 'Sent', NOW());

-- TABLE: audit_log
DROP TABLE IF EXISTS audit_log;
CREATE TABLE audit_log (
  log_id INT AUTO_INCREMENT PRIMARY KEY,
  appoid INT,
  action_type ENUM('Created', 'Updated', 'Cancelled'),
  details TEXT,
  action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (appoid) REFERENCES appointment(appoid)
);
INSERT INTO audit_log (appoid, action_type, details) VALUES
(1, 'Created', 'Appointment booked via online portal');

-- BONUS FEATURE: feedback
DROP TABLE IF EXISTS feedback;
CREATE TABLE feedback (
  feedback_id INT AUTO_INCREMENT PRIMARY KEY,
  appoid INT,
  pid INT,
  docid INT,
  rating INT CHECK (rating BETWEEN 1 AND 5),
  comments TEXT,
  submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (appoid) REFERENCES appointment(appoid),
  FOREIGN KEY (pid) REFERENCES patient(pid),
  FOREIGN KEY (docid) REFERENCES doctor(docid)
);
INSERT INTO feedback (appoid, pid, docid, rating, comments)
VALUES (1, 1, 1, 5, 'Very professional and helpful consultation.');




