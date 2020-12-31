let admin = require("firebase-admin");
const serviceAccount = require("./service_account.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://dima-project-polimi.firebaseio.com"
});

let { seedProducts, seedUsers, seedReviews } = require("./src/seedFunctions");

async function main() {
  console.log("Starting DB seeding...");
  await seedProducts(40);
  await seedUsers();
  await seedReviews(50); // This function can leads to multiple reviews from the same user on the same product
  console.log("Finished DB seeding");
}

main();
