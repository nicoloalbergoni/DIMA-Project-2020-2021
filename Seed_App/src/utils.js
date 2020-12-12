var admin = require("firebase-admin");
const auth = admin.auth();
const FileSystem = require("fs");

exports.getRandomInt = function (min, max) {
  min = Math.ceil(min);
  max = Math.floor(max);
  return Math.floor(Math.random() * (max - min) + min); //The maximum is exclusive and the minimum is inclusive
}

function createUserRegistrationPromise(userAuthData, outputData) {
  return new Promise((resolve, reject) => {
    auth.createUser(userAuthData).then((userRecord) => {
      // See the UserRecord reference doc for the contents of userRecord.
      outputData[userRecord.uid] = userAuthData;
      console.log('Successfully created new user:', userRecord.uid);
      resolve();
    })
    .catch((error) => {
      console.log('Error creating new user:', error);
      reject();
    });
  });  
}

function registerUsers(number) {

  var outputData = {};
  var promises = [];

  for (let i = 0; i < number; i++) {
    var userAuthData = {      
      "email": faker.internet.exampleEmail(),
      "password": faker.internet.password()
    };
    promises.push(createUserRegistrationPromise(userAuthData, outputData));
  }

  Promise.all(promises).then(() => {
    var jsonObj = JSON.stringify(outputData, null, 2);
    FileSystem.writeFile('./userData.json', jsonObj , (err) => {
        if (err) throw err;
      });
  }).catch((error) => {
    console.log('Error:', error);
  });
}

exports.deleteCollection = async function (collectionRef) {
  console.log("Starting seed of products collection...");

  let snapshot = await collectionRef.get();
  snapshot.forEach(async (element) => {
    await element.ref.delete();
  });

  console.log("Deleted all products");
}

exports.loadJson = function (path) {
  return obj = JSON.parse(FileSystem.readFileSync(path, 'utf8'));
}