conn = new Mongo();
db = conn.getDB("app15505665");
db.copyDatabase('app15505665', 'appratings');
db.dropDatabase();
