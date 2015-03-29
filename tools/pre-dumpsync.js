conn = new Mongo();
db = conn.getDB("appratings");
db.dropDatabase();
