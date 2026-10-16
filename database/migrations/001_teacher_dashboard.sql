BEGIN;
CREATE TABLE IF NOT EXISTS topics (
 id VARCHAR(100) PRIMARY KEY, title VARCHAR(200) NOT NULL, description TEXT NOT NULL DEFAULT '',
 content TEXT NOT NULL DEFAULT '', image_url TEXT, icon VARCHAR(30) NOT NULL DEFAULT '📘',
 display_order INTEGER NOT NULL DEFAULT 0, is_published BOOLEAN NOT NULL DEFAULT FALSE,
 created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(), updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE TABLE IF NOT EXISTS quizzes (
 id VARCHAR(100) PRIMARY KEY, topic_id VARCHAR(100) NOT NULL UNIQUE REFERENCES topics(id) ON DELETE CASCADE,
 title VARCHAR(200) NOT NULL DEFAULT 'Topic Quiz', is_published BOOLEAN NOT NULL DEFAULT FALSE,
 created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(), updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE TABLE IF NOT EXISTS quiz_questions (
 id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, quiz_id VARCHAR(100) NOT NULL REFERENCES quizzes(id) ON DELETE CASCADE,
 question TEXT NOT NULL, options JSONB NOT NULL DEFAULT '[]'::jsonb, correct_answer VARCHAR(20) NOT NULL,
 display_order INTEGER NOT NULL DEFAULT 0, created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE TABLE IF NOT EXISTS activities (
 id VARCHAR(100) PRIMARY KEY, topic_id VARCHAR(100) NOT NULL UNIQUE REFERENCES topics(id) ON DELETE CASCADE,
 title VARCHAR(200) NOT NULL DEFAULT 'Topic Activity', instructions TEXT NOT NULL DEFAULT '',
 drive_url TEXT NOT NULL DEFAULT '', is_published BOOLEAN NOT NULL DEFAULT FALSE,
 created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(), updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS topics_published_order_idx ON topics(is_published, display_order);
CREATE INDEX IF NOT EXISTS quiz_questions_quiz_order_idx ON quiz_questions(quiz_id, display_order);
CREATE INDEX IF NOT EXISTS reading_progress_student_topic_idx ON reading_progress(student_id, topic_id);
CREATE INDEX IF NOT EXISTS activity_submissions_student_activity_idx ON activity_submissions(student_id, activity_id);
CREATE UNIQUE INDEX IF NOT EXISTS quiz_attempts_one_per_quiz ON quiz_attempts(student_id, quiz_id);
COMMIT;
