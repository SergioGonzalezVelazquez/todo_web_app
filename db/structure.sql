CREATE TABLE IF NOT EXISTS "schema_migrations" ("version" varchar NOT NULL PRIMARY KEY);
CREATE TABLE IF NOT EXISTS "ar_internal_metadata" ("key" varchar NOT NULL PRIMARY KEY, "value" varchar, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL);
CREATE TABLE IF NOT EXISTS "tasks" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar, "description" text, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL, "completed" boolean DEFAULT 0, "deadline" datetime);
CREATE TABLE sqlite_sequence(name,seq);
INSERT INTO "schema_migrations" (version) VALUES
('20200225082143'),
('20200229143351'),
('20200229143548');


