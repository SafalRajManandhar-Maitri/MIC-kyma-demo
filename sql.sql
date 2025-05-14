-- Create the Tag table
CREATE TABLE "Tag" (
  "id" TEXT PRIMARY KEY DEFAULT gen_random_uuid(),
  "name" TEXT UNIQUE NOT NULL,
  "color" TEXT,
  "createdAt" TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Create the MediaFile table
CREATE TABLE "MediaFile" (
  "id" TEXT PRIMARY KEY DEFAULT gen_random_uuid(),
  "filename" TEXT NOT NULL,
  "originalName" TEXT NOT NULL,
  "mimeType" TEXT NOT NULL,
  "fileSize" INTEGER NOT NULL,
  "bucketPath" TEXT NOT NULL,
  "uploadedAt" TIMESTAMP NOT NULL DEFAULT NOW(),
  "updatedAt" TIMESTAMP NOT NULL DEFAULT NOW(),
  "createdBy" TEXT
);

-- Trigger function to auto-update "updatedAt"
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
   NEW."updatedAt" = NOW();
   RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger for "MediaFile" table
CREATE TRIGGER update_mediafile_updated_at
BEFORE UPDATE ON "MediaFile"
FOR EACH ROW
EXECUTE PROCEDURE update_updated_at_column();

-- Create the join table for many-to-many relation
CREATE TABLE "_MediaFileToTag" (
  "A" TEXT NOT NULL,
  "B" TEXT NOT NULL,
  PRIMARY KEY ("A", "B"),
  FOREIGN KEY ("A") REFERENCES "MediaFile"("id") ON DELETE CASCADE,
  FOREIGN KEY ("B") REFERENCES "Tag"("id") ON DELETE CASCADE
);
