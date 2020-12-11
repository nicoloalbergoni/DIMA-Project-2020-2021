
var admin = require("firebase-admin");
var faker = require('faker');

var serviceAccount = require("./service_account.json");
const { fake } = require("faker");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://dima-project-polimi.firebaseio.com"
});

const db = admin.firestore();
const products = db.collection('products');


var count = 0;

// const snapshot = db.collection('users').get().then((snapshot) => {
  
//   snapshot.forEach((doc) => {
//     count++;
//     console.log(count);
//     console.log(doc.id, '=>', doc.data());
//   });


// });

function seedProducts(number) {  

  products.get().then((snapshot) => {
    snapshot.forEach((element) => {
      products.doc(element.id).delete();
    });
  });
  console.log("Deleted all products");

  for (let i = 0; i < number; i++) {

    var data = {
      "name": faker.commerce.productName(),
      "price": faker.commerce.price(),
      "discount": faker.random.number({min:0, max:100}),
      "description": faker.commerce.productDescription(),
      "rating": faker.random.number({min:0, max:5}),
      "categories": ["aaaa", "bbbb"]
    }

    products.add(data).then((data) => console.log("Product added"));    
  }

}


seedProducts(10);