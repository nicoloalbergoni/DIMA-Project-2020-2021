var admin = require("firebase-admin");
const faker = require('faker');

const db = admin.firestore();
const products = db.collection('products');
const users = db.collection('users');
const reviews = db.collection('reviews');

let { getRandomInt, deleteCollection, loadJson, getAllDocumentReferences, generateRandomDate } = require('./utils');


exports.seedProducts = async function (number) { 
  console.log('Starting seed of product collection...');

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

exports.seedUsers = async function () {
  console.log('Starting seed of users collection...');

  let count = 0;
  let usersUID = [];
  let productsReferences = await getAllDocumentReferences(products);
  // Deletion of users is disabled for now as there is no simple way to delete subcollections in Firestore.
  // Remember to delete the entire collection from the firebase console in order to perform a true seed.
  // await deleteCollection(users); 
  let usersAuthData = loadJson("userData.json");
  for(var i in usersAuthData) {
    usersUID.push(i);
  }

  for(var i = usersUID.length - 1; i>=0; i--) {
    // Extract and then remove a random element from the array
    let uid = usersUID.splice(Math.floor(Math.random()*usersUID.length), 1)[0];
    let data = {
      "firstname": faker.name.firstName(),
      "lastname": faker.name.lastName(),
      "email": usersAuthData[uid].email,
      "photoURL": faker.image.imageUrl(), // Check if the generated links work
      "addresses": [
        {
          "state": faker.address.state(),
          "city": faker.address.city(),
          "street": faker.address.streetName(),
          "zip_code": faker.address.zipCode()
        }
      ],
      "payment_methods": [
        {
          "CC_number": faker.finance.creditCardCVV(),
          "CC_expiry_date": new Date(),
        }
      ]      
    };
    
    await users.doc(uid).set(data);
    await seedCart(uid, getRandomInt(1, 6), productsReferences);
    await seedOrders(uid, getRandomInt(1, 21), productsReferences);
    count++;

  }  
  
  console.log(`Added ${count} users`);
}

async function seedCart(userDocRef, number, productsReferences) {

  for (let i = 0; i < number; i++) {
    let randomProductDoc = productsReferences[getRandomInt(0, productsReferences.length)];
    let data = {
      "product_id": products.doc(randomProductDoc.id),
      "quantity": getRandomInt(1, 15)
    };
    await users.doc(userDocRef).collection('cart').add(data);    
  }  
}

async function seedOrders(userDocRef, number, productsReferences) {
  for (let i = 0; i < number; i++) {

    let issue_date = generateRandomDate(new Date(2000, 0), new Date(2021, 11, 31));    
    let orderData = {
      "issue_date": issue_date,
      "delivery_date": generateRandomDate(issue_date, new Date(issue_date.getFullYear(), 11, 31)),
      "in_progress": (Math.random() > 0.5) ? true : false,
      "total_cost": faker.commerce.price()
    };
    
    let orderRef = (await users.doc(userDocRef).collection('orders').add(orderData)).id;
    
    generateCartItemsData(getRandomInt(0, 6), productsReferences).forEach(async (cartItem) => {
        await users.doc(userDocRef).collection('orders').doc(orderRef).collection('orderItems').add(cartItem);
    });
  }
}

function generateCartItemsData(number, productsReferences) {
  let dataList = [];
  for (let i = 0; i < number; i++) {
     let randomProductDoc = productsReferences[getRandomInt(0, productsReferences.length)];
     dataList.push({
      "product_id": products.doc(randomProductDoc.id),
      "quantity": getRandomInt(1, 15),
      "item_cost": faker.commerce.price()
     });  
  }

  return dataList;
}

exports.seedReviews = async function(number) {
  console.log(`Starting seed of reviews collection...`);

  let count = 0;
  let productsReferences = await getAllDocumentReferences(products);
  let usersReferences = await getAllDocumentReferences(users);
  await deleteCollection(reviews);
  
  for (let i = 0; i < number; i++) {
    let randomProductDoc = productsReferences[getRandomInt(0, productsReferences.length)];
    let randomUserDoc = usersReferences[getRandomInt(0, usersReferences.length)];
    let data = {
      "comment": faker.lorem.sentence(),
      "rating": faker.random.number({min:0, max:5}),
      "product_id": products.doc(randomProductDoc.id),
      "user_id": users.doc(randomUserDoc.id)
    };
    await reviews.add(data);
    count++;
  }

  console.log(`Added ${count} reviews`);
}

