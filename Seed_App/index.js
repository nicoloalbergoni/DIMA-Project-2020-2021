var admin = require("firebase-admin");
const serviceAccount = require("./service_account.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://dima-project-polimi.firebaseio.com"
});

let { seedProducts, seedUsers } = require("./src/seedFunctions");

async function main() {
  console.log("Starting DB seeding...");
  await seedProducts(15);
  await seedUsers(15);
  console.log("Finished DB seeding");
}

main();