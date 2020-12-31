let admin = require("firebase-admin");
const path = require("path");
const auth = admin.auth();
const FileSystem = require("fs");

/**
 * The maximum is exclusive and the minimum is inclusive
 * @param min
 * @param max
 * @returns {number}
 */
exports.getRandomInt = function (min, max) {
  min = Math.ceil(min);
  max = Math.floor(max);
  return Math.floor(Math.random() * (max - min) + min);
};

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

exports.registerUsers = function (number) {

  let outputData = {};
  let promises = [];

  for (let i = 0; i < number; i++) {
    let userAuthData = {      
      "email": faker.internet.exampleEmail(),
      "password": faker.internet.password()
    };
    promises.push(createUserRegistrationPromise(userAuthData, outputData));
  }

  Promise.all(promises).then(() => {
    let jsonObj = JSON.stringify(outputData, null, 2);
    FileSystem.writeFile('./userData.json', jsonObj , (err) => {
        if (err) throw err;
      });
  }).catch((error) => {
    console.log('Error:', error);
  });
};

exports.deleteCollection = async function (collectionRef) {

  let snapshot = await collectionRef.get();
  snapshot.forEach(async (element) => {
    await element.ref.delete();
  });

  console.log(`Deleted documents in ${collectionRef.id} collection`);
};

exports.loadJson = function (fileName) {
  let fullPath = path.join(__dirname, '..', fileName);
  let rawdata = FileSystem.readFileSync(fullPath);
  return JSON.parse(rawdata);
};

exports.getAllDocumentReferences = async function(collectionRef) {
  let referenceList = [];
  let snapshot = await collectionRef.get();
  snapshot.forEach(async (element) => {
    referenceList.push(element);
  });

  return referenceList;
};

exports.generateRandomDate = function (start, end) {
  return new Date(start.getTime() + Math.random() * (end.getTime() - start.getTime()));
};



