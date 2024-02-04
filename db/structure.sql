CREATE TABLE IF NOT EXISTS "schema_migrations" ("version" varchar NOT NULL PRIMARY KEY);
CREATE TABLE IF NOT EXISTS "ar_internal_metadata" ("key" varchar NOT NULL PRIMARY KEY, "value" varchar, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL);
CREATE TABLE IF NOT EXISTS "users" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL);
CREATE TABLE sqlite_sequence(name,seq);
CREATE TABLE IF NOT EXISTS "conversations" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "title" varchar, "user_id" integer NOT NULL, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL, CONSTRAINT "fk_rails_7c15d62a0a"
FOREIGN KEY ("user_id")
  REFERENCES "users" ("id")
);
CREATE INDEX "index_conversations_on_user_id" ON "conversations" ("user_id");
CREATE TABLE IF NOT EXISTS "messages" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "conversation_id" integer NOT NULL, "text" text, "from_system" boolean, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL, CONSTRAINT "fk_rails_7f927086d2"
FOREIGN KEY ("conversation_id")
  REFERENCES "conversations" ("id")
);
CREATE INDEX "index_messages_on_conversation_id" ON "messages" ("conversation_id");
CREATE TABLE IF NOT EXISTS "contents" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar, "metadata" json, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL);
CREATE TABLE IF NOT EXISTS "content_fragments" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "body" varchar, "metadata" json, "content_id" integer NOT NULL, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL, "aasm_state" varchar, CONSTRAINT "fk_rails_73332a9d49"
FOREIGN KEY ("content_id")
  REFERENCES "contents" ("id")
);
CREATE INDEX "index_content_fragments_on_content_id" ON "content_fragments" ("content_id");
CREATE TABLE IF NOT EXISTS "solid_queue_jobs" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "queue_name" varchar NOT NULL, "class_name" varchar NOT NULL, "arguments" text, "priority" integer DEFAULT 0 NOT NULL, "active_job_id" varchar, "scheduled_at" datetime(6), "finished_at" datetime(6), "concurrency_key" varchar, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL);
CREATE INDEX "index_solid_queue_jobs_on_class_name" ON "solid_queue_jobs" ("class_name");
CREATE INDEX "index_solid_queue_jobs_on_active_job_id" ON "solid_queue_jobs" ("active_job_id");
CREATE INDEX "index_solid_queue_jobs_on_finished_at" ON "solid_queue_jobs" ("finished_at");
CREATE INDEX "index_solid_queue_jobs_for_filtering" ON "solid_queue_jobs" ("queue_name", "finished_at");
CREATE INDEX "index_solid_queue_jobs_for_alerting" ON "solid_queue_jobs" ("scheduled_at", "finished_at");
CREATE TABLE IF NOT EXISTS "solid_queue_pauses" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "queue_name" varchar NOT NULL, "created_at" datetime(6) NOT NULL);
CREATE UNIQUE INDEX "index_solid_queue_pauses_on_queue_name" ON "solid_queue_pauses" ("queue_name");
CREATE TABLE IF NOT EXISTS "solid_queue_processes" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "kind" varchar NOT NULL, "last_heartbeat_at" datetime(6) NOT NULL, "supervisor_id" bigint, "pid" integer NOT NULL, "hostname" varchar, "metadata" text, "created_at" datetime(6) NOT NULL);
CREATE INDEX "index_solid_queue_processes_on_last_heartbeat_at" ON "solid_queue_processes" ("last_heartbeat_at");
CREATE INDEX "index_solid_queue_processes_on_supervisor_id" ON "solid_queue_processes" ("supervisor_id");
CREATE TABLE IF NOT EXISTS "solid_queue_semaphores" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "key" varchar NOT NULL, "value" integer DEFAULT 1 NOT NULL, "expires_at" datetime(6) NOT NULL, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL);
CREATE UNIQUE INDEX "index_solid_queue_semaphores_on_key" ON "solid_queue_semaphores" ("key");
CREATE INDEX "index_solid_queue_semaphores_on_expires_at" ON "solid_queue_semaphores" ("expires_at");
CREATE INDEX "index_solid_queue_semaphores_on_key_and_value" ON "solid_queue_semaphores" ("key", "value");
CREATE TABLE IF NOT EXISTS "solid_queue_blocked_executions" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "job_id" integer NOT NULL, "queue_name" varchar NOT NULL, "priority" integer DEFAULT 0 NOT NULL, "concurrency_key" varchar NOT NULL, "expires_at" datetime(6) NOT NULL, "created_at" datetime(6) NOT NULL, CONSTRAINT "fk_rails_4cd34e2228"
FOREIGN KEY ("job_id")
  REFERENCES "solid_queue_jobs" ("id")
 ON DELETE CASCADE);
CREATE UNIQUE INDEX "index_solid_queue_blocked_executions_on_job_id" ON "solid_queue_blocked_executions" ("job_id");
CREATE INDEX "index_solid_queue_blocked_executions_for_maintenance" ON "solid_queue_blocked_executions" ("expires_at", "concurrency_key");
CREATE TABLE IF NOT EXISTS "solid_queue_claimed_executions" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "job_id" integer NOT NULL, "process_id" bigint DEFAULT NULL, "created_at" datetime(6) NOT NULL, CONSTRAINT "fk_rails_9cfe4d4944"
FOREIGN KEY ("job_id")
  REFERENCES "solid_queue_jobs" ("id")
 ON DELETE CASCADE);
CREATE UNIQUE INDEX "index_solid_queue_claimed_executions_on_job_id" ON "solid_queue_claimed_executions" ("job_id");
CREATE INDEX "index_solid_queue_claimed_executions_on_process_id_and_job_id" ON "solid_queue_claimed_executions" ("process_id", "job_id");
CREATE TABLE IF NOT EXISTS "solid_queue_failed_executions" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "job_id" integer NOT NULL, "error" text DEFAULT NULL, "created_at" datetime(6) NOT NULL, CONSTRAINT "fk_rails_39bbc7a631"
FOREIGN KEY ("job_id")
  REFERENCES "solid_queue_jobs" ("id")
 ON DELETE CASCADE);
CREATE UNIQUE INDEX "index_solid_queue_failed_executions_on_job_id" ON "solid_queue_failed_executions" ("job_id");
CREATE TABLE IF NOT EXISTS "solid_queue_ready_executions" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "job_id" integer NOT NULL, "queue_name" varchar NOT NULL, "priority" integer DEFAULT 0 NOT NULL, "created_at" datetime(6) NOT NULL, CONSTRAINT "fk_rails_81fcbd66af"
FOREIGN KEY ("job_id")
  REFERENCES "solid_queue_jobs" ("id")
 ON DELETE CASCADE);
CREATE UNIQUE INDEX "index_solid_queue_ready_executions_on_job_id" ON "solid_queue_ready_executions" ("job_id");
CREATE INDEX "index_solid_queue_poll_all" ON "solid_queue_ready_executions" ("priority", "job_id");
CREATE INDEX "index_solid_queue_poll_by_queue" ON "solid_queue_ready_executions" ("queue_name", "priority", "job_id");
CREATE TABLE IF NOT EXISTS "solid_queue_scheduled_executions" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "job_id" integer NOT NULL, "queue_name" varchar NOT NULL, "priority" integer DEFAULT 0 NOT NULL, "scheduled_at" datetime(6) NOT NULL, "created_at" datetime(6) NOT NULL, CONSTRAINT "fk_rails_c4316f352d"
FOREIGN KEY ("job_id")
  REFERENCES "solid_queue_jobs" ("id")
 ON DELETE CASCADE);
CREATE UNIQUE INDEX "index_solid_queue_scheduled_executions_on_job_id" ON "solid_queue_scheduled_executions" ("job_id");
CREATE INDEX "index_solid_queue_dispatch_all" ON "solid_queue_scheduled_executions" ("scheduled_at", "priority", "job_id");
CREATE VIRTUAL TABLE vss_content_fragments using vss0(
  embedding(1536)
);
CREATE TABLE IF NOT EXISTS "vss_content_fragments_index"(rowid integer primary key autoincrement, idx);
CREATE TABLE IF NOT EXISTS "vss_content_fragments_data"(rowid integer primary key autoincrement, _);
INSERT INTO "schema_migrations" (version) VALUES
('20240128144226'),
('20240127000837'),
('20240126234042'),
('20240126233250'),
('20240126232015'),
('20240126191039'),
('20240126190921'),
('20240126190850');

