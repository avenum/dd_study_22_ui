CREATE TABLE t_User(
	id					TEXT NOT NULL PRIMARY KEY
	,[name]				TEXT
	,email				TEXT
	,birthDate			TEXT NOT NULL
	,avatarLink			TEXT
);
CREATE TABLE t_Post(
	id					TEXT NOT NULL PRIMARY KEY
	,[description]		TEXT
	,authorId			TEXT NOT NULL
	,FOREIGN KEY(authorId) REFERENCES t_User(id)
);
CREATE TABLE t_PostContent(
	id					TEXT NOT NULL PRIMARY KEY
	,[name]				TEXT
	,mimeType			TEXT
	,postId				TEXT
	,contentLink		TEXT
	,FOREIGN KEY(postId) REFERENCES t_Post(id)
);