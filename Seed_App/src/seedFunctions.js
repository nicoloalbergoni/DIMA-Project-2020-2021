let admin = require("firebase-admin");
let fs = require('fs-extra');
const faker = require('faker');

const db = admin.firestore();
const products = db.collection('products');
const users = db.collection('users');
const reviews = db.collection('reviews');

let u = require('./utils');

let possibleCategories = ['Furniture', 'Design', 'Electronic', 'Handmade', 'Rustic', 'Practical', 'Unbranded',
    'Ergonomic', 'Mechanical', 'Wood', 'Iron', 'Plastic'];

let arPackages = ['AssetBundles/capsule', 'AssetBundles/shelf', 'AssetBundles/sofa_chair', 'AssetBundles/stegosaur'];


exports.seedProducts = async function (productCount) {
  console.log('Starting seed of product collection...');
  await u.deleteCollection(products);
  console.log('Previous products deleted');

  let dumpJson = {};

  for (let i = 0; i < productCount; i++) {
    let categories = u.extractionWithNoDuplicates(possibleCategories, u.getRandomInt(2, 5));

    let images = [];
    for (let j = 0; j < u.getRandomInt(1, 8); j++) {
      images.push(u.generateRandomImageUrl());
    }

    let price = u.makeTwoDecimalsPrice(faker.random.number({min: 0, max: 1000, precision: 0.01}));
    let discount = faker.random.number({min: 0, max: 95});
    let discountedPrice = u.makeTwoDecimalsPrice(price * (1 - discount / 100));
    let has_AR = Math.random() < 0.8;

    let data = {
      "name": faker.commerce.productName(),
      "price": price,
      "discount": discount,
      "discounted_price": discountedPrice,
      "description": faker.commerce.productDescription(),
      "rating": faker.random.number({min: 1, max: 5, precision: 0.1}),
      "categories": categories,
      "hot_deal": Math.random() > 0.5,
      "popular": Math.random() > 0.5,
      "has_AR": has_AR,
      "thumbnail": u.generateRandomImageUrl(400, 400),
      "images": images,
      "created_at": u.generateRandomDate(new Date(2019, 0), new Date(2021, 1))
    };
    if (has_AR) {
      data.ar_package = arPackages[u.getRandomInt(0, arPackages.length)];
    }

    await products.add(data);
    dumpJson[`p${i}`] = data;
  }

  console.log(`Added ${productCount} products`);
  fs.outputJson('../data/products.json', dumpJson);
};

exports.seedUsers = async function () {
  console.log('Starting seed of users collection...');

  let count = 0;
  let usersUID = [];
  let productsReferences = await u.getAllDocumentReferences(products);
  // Deletion of users is disabled for now as there is no simple way to delete subcollections in Firestore.
  // Remember to delete the entire collection from the firebase console in order to perform a true seed.
  // await u.deleteCollection(users); 
  let usersAuthData = u.loadJson("userData.json");
  for(let i in usersAuthData) {
    usersUID.push(i);
  }

  let dumpJson = {};
  while (usersUID.length > 0) {
    // Extract and then remove a random element from the array
    let uid = usersUID.splice(u.getRandomInt(0, usersUID.length), 1)[0];
    
    let addresses = [];
    let payment_methods = [];
    for (let j = 0; j < u.getRandomInt(1, 5); j++) {
      addresses.push({
          "state": faker.address.state(),
          "city": faker.address.city(),
          "street": faker.address.streetName(),
          "zip_code": faker.address.zipCode()
        });     
    }
    for (let j = 0;  j < u.getRandomInt(1, 5); j++) {
      payment_methods.push({
          "CC_number": faker.finance.creditCardNumber(),
          "CC_expiry_date": u.generateRandomDate(new Date(2016, 0), new Date(2025, 11)),
      });
    }

    let data = {
      "firstname": faker.name.firstName(),
      "lastname": faker.name.lastName(),
      "email": usersAuthData[uid].email,
      "photoURL": faker.image.imageUrl(),
      "addresses": addresses,
      "payment_methods": payment_methods,
      "birth_date": u.generateRandomDate(new Date(1950, 0), new Date(2002, 11, 31)),     
    };
    count++;
    dumpJson[`u${count}`] = data;
    
    await users.doc(uid).set(data);
    await seedCart(uid, u.getRandomInt(1, 6), productsReferences);
    await seedOrders(uid, u.getRandomInt(1, 21), productsReferences);

    console.log(`User ${count} seeded`);
  }  
  
  console.log(`Added ${count} users`);
  fs.outputJson('../data/users.json', dumpJson);
};

async function seedCart(userDocRef, number, productsReferences) {
  let pRefs = u.extractionWithNoDuplicates(productsReferences, number);
  for (let i = 0; i < number; i++) {
    let data = {
      "product_id": products.doc(pRefs[i].id),
      "quantity": u.getRandomInt(1, 15)
    };
    await users.doc(userDocRef).collection('cart').add(data);    
  }  
}

async function seedOrders(userDocRef, number, productsReferences) {
  let dumpJson = {};
  for (let i = 0; i < number; i++) {
    let issue_date = u.generateRandomDate(new Date(2000, 0), new Date(2021, 11, 31));    
    let orderData = {
      "issue_date": issue_date,
      "delivery_date": u.generateRandomDate(issue_date, new Date(issue_date.getFullYear(), 11, 31)),
      "in_progress": Math.random() > 0.5,
      "total_cost": u.makeTwoDecimalsPrice(faker.random.number({min: 10, max: 5000, precision: 0.01})),
      "delivery_address": `${faker.address.streetName()}, ${faker.address.city()}, ${faker.address.state()}, ${faker.address.zipCode()}`,
      "payment_card": `${faker.finance.creditCardNumber()}, ${u.generateRandomDate(new Date(2016, 0), new Date(2025, 11))}`
    };
    
    let orderRef = (await users.doc(userDocRef).collection('orders').add(orderData)).id;
    dumpJson[`o${i}`] = orderData;

    let cartData = generateCartItemsData(u.getRandomInt(0, 6), productsReferences);
    let promises = cartData.map(cartItem => users.doc(userDocRef).collection('orders')
        .doc(orderRef).collection('orderItems')
        .add(cartItem));

    await Promise.all(promises);
  }

  fs.outputJson('../data/orders.json', dumpJson);
}

function generateCartItemsData(number, productsReferences) {
  let dataList = [];
  let pRefs = u.extractionWithNoDuplicates(productsReferences, number);
  for (let i = 0; i < number; i++) {
     dataList.push({
      "product_id": products.doc(pRefs[i].id),
      "quantity": u.getRandomInt(1, 15),
      "item_cost": u.makeTwoDecimalsPrice(faker.random.number({min: 0, max: 1000, precision: 0.01}))
     });  
  }

  return dataList;
}

exports.seedReviews = async function(number) {
  console.log(`Starting seed of reviews collection...`);
  
  let productsReferences = await u.getAllDocumentReferences(products);
  let usersReferences = await u.getAllDocumentReferences(users);
  await u.deleteCollection(reviews);

  let dumpJson = {};
  for (let i = 0; i < number; i++) {
    let randomProductDoc = productsReferences[u.getRandomInt(0, productsReferences.length)];
    let randomUserDoc = usersReferences[u.getRandomInt(0, usersReferences.length)];
    let data = {
      "comment": faker.lorem.sentence(),
      "rating": faker.random.number({min:0, max:5}),
      "product_id": products.doc(randomProductDoc.id),
      "user_id": users.doc(randomUserDoc.id)
    };
    
    await reviews.add(data);
    dumpJson[`r${i}`] = data;
  }

  console.log(`Added ${number} reviews`);
  fs.outputJson('../data/reviews.json', dumpJson);
};

