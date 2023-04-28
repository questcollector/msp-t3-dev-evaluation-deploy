db = new Mongo().getDB("students");

db.createCollection('message_data', {
   validator: { $jsonSchema: {
      bsonType: "object",
      properties: {
         _id: {
            bsonType: "binData",
            description: "must be a UUID string and is required"
         },
         slackUserId: {
            bsonType: "string",
            description: "slack user id string and is nullable"
         },
         instanceId: {
            bsonType: "string",
            description: "id of instance which the message came from"
         }
      }
   }},
   validationAction: "error"
});

db.message_data.createIndex( { slackUserId: 1 } )
db.message_data.createIndex( { instanceId: 1 } )

db.createUser({
    user: 'eval',
    pwd: '${rand_passwd}',
    roles: [
        {
            role: 'readWrite',
            db: 'students',
        },
    ],
});