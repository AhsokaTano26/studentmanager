-- 确保在 studentmanager 数据库中执行
-- \c studentmanager

-----------------------------------
-- 1. CLAZZ (班级表) - 无外键依赖，优先创建
-----------------------------------
DROP TABLE IF EXISTS studentmanager.s_clazz CASCADE; -- 使用 CASCADE 确保清理依赖的外键
CREATE TABLE studentmanager.s_clazz (
                                        id INTEGER PRIMARY KEY, -- 保留原有ID
                                        name VARCHAR(32) NOT NULL,
                                        info VARCHAR(128)
);


-----------------------------------
-- 2. TEACHER (教师表) - 依赖 s_clazz
-----------------------------------
DROP TABLE IF EXISTS studentmanager.s_teacher CASCADE;
CREATE TABLE studentmanager.s_teacher (
                                          id INTEGER PRIMARY KEY, -- 保留原有ID
                                          sn VARCHAR(32) NOT NULL UNIQUE, -- 教师编号唯一
                                          username VARCHAR(32) NOT NULL,
                                          password VARCHAR(32) NOT NULL,
                                          clazz_id INTEGER NOT NULL,
                                          sex VARCHAR(5) NOT NULL DEFAULT '男',
                                          mobile VARCHAR(12),
                                          qq VARCHAR(18),
                                          photo VARCHAR(255),
                                          FOREIGN KEY (clazz_id) REFERENCES studentmanager.s_clazz (id)
);


-----------------------------------
-- 3. STUDENT (学生表) - 依赖 s_clazz
-----------------------------------
DROP TABLE IF EXISTS studentmanager.s_student CASCADE;
CREATE TABLE studentmanager.s_student (
                                          id INTEGER PRIMARY KEY, -- 保留原有ID
                                          sn VARCHAR(32) NOT NULL UNIQUE, -- 学号唯一
                                          username VARCHAR(32) NOT NULL,
                                          password VARCHAR(32) NOT NULL,
                                          clazz_id INTEGER NOT NULL,
                                          sex VARCHAR(5) NOT NULL DEFAULT '男',
                                          mobile VARCHAR(12),
                                          qq VARCHAR(18),
                                          photo VARCHAR(255),
                                          FOREIGN KEY (clazz_id) REFERENCES studentmanager.s_clazz (id)
);


-----------------------------------
-- 4. COURSE (课程表) - 依赖 s_teacher
-----------------------------------
DROP TABLE IF EXISTS studentmanager.s_course CASCADE;
CREATE TABLE studentmanager.s_course (
                                         id INTEGER PRIMARY KEY, -- 保留原有ID
                                         name VARCHAR(32) NOT NULL,
                                         teacher_id INTEGER NOT NULL,
                                         course_date VARCHAR(32),
                                         selected_num INTEGER NOT NULL DEFAULT 0,
                                         max_num INTEGER NOT NULL DEFAULT 50,
                                         info VARCHAR(128),
                                         FOREIGN KEY (teacher_id) REFERENCES studentmanager.s_teacher (id)
);


-----------------------------------
-- 5. ADMIN (管理员表) - 无外键依赖
-----------------------------------
DROP TABLE IF EXISTS studentmanager.s_admin;
CREATE TABLE studentmanager.s_admin (
                                        id INTEGER PRIMARY KEY, -- 保留原有ID
                                        username VARCHAR(32) NOT NULL UNIQUE,
                                        password VARCHAR(32) NOT NULL,
                                        status SMALLINT NOT NULL DEFAULT 1
);


-----------------------------------
-- 6. LEAVE (请假表) - 依赖 s_student
-----------------------------------
DROP TABLE IF EXISTS studentmanager.s_leave;
CREATE TABLE studentmanager.s_leave (
                                        id INTEGER PRIMARY KEY, -- 保留原有ID
                                        student_id INTEGER NOT NULL,
                                        info VARCHAR(512),
                                        status SMALLINT NOT NULL DEFAULT 0,
                                        remark VARCHAR(512),
                                        FOREIGN KEY (student_id) REFERENCES studentmanager.s_student (id)
);


-----------------------------------
-- 7. ATTENDANCE (考勤表) - 依赖 s_course, s_student
-----------------------------------
DROP TABLE IF EXISTS studentmanager.s_attendance;
CREATE TABLE studentmanager.s_attendance (
                                             id INTEGER PRIMARY KEY, -- 保留原有ID
                                             course_id INTEGER NOT NULL,
                                             student_id INTEGER NOT NULL,
                                             type VARCHAR(11) NOT NULL,
                                             date VARCHAR(11) NOT NULL,
                                             FOREIGN KEY (course_id) REFERENCES studentmanager.s_course (id),
                                             FOREIGN KEY (student_id) REFERENCES studentmanager.s_student (id)
);


-----------------------------------
-- 8. SCORE (成绩表) - 依赖 s_course, s_student
-----------------------------------
DROP TABLE IF EXISTS studentmanager.s_score;
CREATE TABLE studentmanager.s_score (
                                        id INTEGER PRIMARY KEY, -- 保留原有ID
                                        student_id INTEGER NOT NULL,
                                        course_id INTEGER NOT NULL,
                                        score NUMERIC(5,2) NOT NULL,
                                        remark VARCHAR(128),
                                        FOREIGN KEY (course_id) REFERENCES studentmanager.s_course (id),
                                        FOREIGN KEY (student_id) REFERENCES studentmanager.s_student (id)
);


-----------------------------------
-- 9. SELECTED_COURSE (选课表) - 依赖 s_course, s_student
-----------------------------------
DROP TABLE IF EXISTS studentmanager.s_selected_course;
CREATE TABLE studentmanager.s_selected_course (
                                                  id INTEGER PRIMARY KEY, -- 保留原有ID
                                                  student_id INTEGER NOT NULL,
                                                  course_id INTEGER NOT NULL,
                                                  UNIQUE (student_id, course_id), -- 确保一个学生不重复选同一门课
                                                  FOREIGN KEY (course_id) REFERENCES studentmanager.s_course (id),
                                                  FOREIGN KEY (student_id) REFERENCES studentmanager.s_student (id)
);

-- 清空命令，确保所有表数据都被清除
TRUNCATE TABLE
    studentmanager.s_attendance,
    studentmanager.s_leave,
    studentmanager.s_score,
    studentmanager.s_selected_course,
    studentmanager.s_course,
    studentmanager.s_student,
    studentmanager.s_teacher,
    studentmanager.s_admin,
    studentmanager.s_clazz
    CASCADE;

-- INSERT 语句,插入数据
-- A. 基础表
INSERT INTO studentmanager.s_clazz (id, name, info) VALUES
                                                        (1, '软件一班', '软件工程专业。'), (4, '数学一班', '大学数学专业'), (5, '计算机科学与技术一班', '计算机专业');

INSERT INTO studentmanager.s_admin (id, username, password, status) VALUES
    (1, 'admin', '123456', 1);

-- B. 第二级表
INSERT INTO studentmanager.s_teacher (id, sn, username, password, clazz_id, sex, mobile, qq, photo) VALUES
                                                                                                        (9, 'T11528608730648', '张三', '111', 4, '男', '13918655656', '1193284480', NULL), (10, 'T11528609224588', '李四老师', '111', 4, '男', '13656565656', '123456', NULL), (11, 'T51528617262403', '李老师', '123456', 5, '男', '18989898989', '1456655565', NULL), (18, 'T11561727746515', '夏青松', '123456', 1, '女', '15174857845', '1745854125', '5d447b8b-ec54-4a8e-919a-453aa7b6d33b.jpg');

INSERT INTO studentmanager.s_student (id, sn, username, password, clazz_id, sex, mobile, qq, photo) VALUES
                                                                                                        (2, 'S51528202992845', '张三纷', '123456', 1, '女', '13545454548', '1332365656', NULL), (4, 'S51528379586807', '王麻子', '111111', 5, '男', '13356565656', '123456', NULL), (9, 'S41528633634989', '马冬梅', '1', 5, '男', '13333332133', '131313132323', 'bb12326f-ef6c-4d3d-a2ae-f9eb30a15ad4.jpg');

-- C. 第三级表
INSERT INTO studentmanager.s_course (id, name, teacher_id, course_date, selected_num, max_num, info) VALUES
                                                                                                         (1, '大学英语', 9, '周三上午8点', 49, 50, '英语。'), (2, '大学数学', 10, '周三上午10点', 4, 50, '数学。'), (3, '计算机基础', 11, '周三上午', 3, 50, '计算机课程。');

-- D. 最终级表
INSERT INTO studentmanager.s_attendance (id, course_id, student_id, type, date) VALUES
                                                                                    (13, 1, 2, '上午', '2018-09-04'), (14, 1, 4, '上午', '2018-09-04'), (15, 2, 2, '上午', '2019-07-02');

INSERT INTO studentmanager.s_leave (id, student_id, info, status, remark) VALUES
    (13, 2, '世界这么大，想去看看', 1, '同意，你很6');

INSERT INTO studentmanager.s_score (id, student_id, course_id, score, remark) VALUES
                                                                                  (67, 4, 2, 78.00, '中等'), (68, 9, 1, 50.00, '不及格');

INSERT INTO studentmanager.s_selected_course (id, student_id, course_id) VALUES
                                                                             (18, 2, 1), (19, 2, 2), (20, 2, 3), (21, 4, 3), (22, 4, 2), (24, 9, 1);