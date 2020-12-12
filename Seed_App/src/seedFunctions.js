var admin = require("firebase-admin");
const faker = require('faker');

const db = admin.firestore();
const products = db.collection('products');
const users = db.collection('users');

let { getRandomInt, deleteCollection, loadJson } = require('./utils');


exports.seedProducts = async function (number) { 

  let count = 0;

  await deleteCollection(products);  

  for (let i = 0; i < number; i++) {
    let categories = [];
    for (let j = 0; j < getRandomInt(1, 5); j++) {
      categories.push(faker.commerce.productAdjective());      
    }

    var data = {
      "name": faker.commerce.productName(),
      "price": faker.commerce.price(),
      "discount": faker.random.number({min:0, max:100}),
      "description": faker.commerce.productDescription(),
      "rating": faker.random.number({min:0, max:5}),
      "categories": categories
    };

    await products.add(data);
    count++;    
  }
  console.log(`Added ${count} products`);
}


exports.seedUsers = async function (number) {

  let count = 0;
  await deleteCollection(users);
  //TODO: Fix loadJson
  let usersAuthData = loadJson("./../userData.json");

  for (let i = 0; i < number; i++) {    
    
  }
}