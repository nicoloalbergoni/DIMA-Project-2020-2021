let admin = require("firebase-admin");
const faker = require('faker');

const db = admin.firestore();
const products = db.collection('products');
const users = db.collection('users');
const reviews = db.collection('reviews');

let { getRandomInt, deleteCollection, loadJson, getAllDocumentReferences, generateRandomDate } = require('./utils');

let possibleCategories = ['Furniture', 'Design', 'Electronic', 'Handmade', 'Rustic', 'Practical', 'Unbranded',
    'Ergonomic', 'Mechanical', 'Wood', 'Iron', 'Plastic'];

let arPackages = ['AssetBundles/capsule'];


exports.seedProducts = async function (productCount) {
  console.log('Starting seed of product collection...');
  await deleteCollection(products);
  console.log('Previous products deleted');

  for (let i = 0; i < productCount; i++) {
    let categories = [];
    for (let j = 0; j < getRandomInt(1, 5); j++) {
      categories.push(possibleCategories[getRandomInt(0, possibleCategories.length)]);
    }

    let images = [];
    for (let j = 0; j < getRandomInt(1, 8); j++) {
      images.push(faker.image.imageUrl())
    }

    let price = faker.random.number({min: 0, max: 1000, precision: 0.01});
    let discount = faker.random.number({min: 0, max: 95});
    let discountedPrice = Math.fround(price * (1 - discount / 100)) + 0.09;
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
      "thumbnail": faker.image.imageUrl(400, 400),
      "images": images,
      "created_at": generateRandomDate(new Date(2019, 0), new Date(2021, 1))
    };
    if (has_AR) {
      data.ar_package = arPackages[getRandomInt(0, arPackages.length)];
    }
    await products.add(data);
  }
  console.log(`Added ${productCount} products`);
};

exports.seedUsers = async function () {
  console.log('Starting seed of users collection...');

  let count = 0;
  let usersUID = [];
  let productsReferences = await getAllDocumentReferences(products);
  // Deletion of users is disabled for now as there is no simple way to delete subcollections in Firestore.
  // Remember to delete the entire collection from the firebase console in order to perform a true seed.
  // await deleteCollection(users); 
  let usersAuthData = loadJson("userData.json");
  for(let i in usersAuthData) {
    usersUID.push(i);
  }

  for(let i = usersUID.length - 1; i>=0; i--) {
    // Extract and then remove a random element from the array
    let uid = usersUID.splice(Math.floor(Math.random()*usersUID.length), 1)[0];
    
    let addresses = [];
    let payment_methods = [];
    for (let j = 0; j < getRandomInt(1, 5); j++) {
      addresses.push({
          "state": faker.address.state(),
          "city": faker.address.city(),
          "street": faker.address.streetName(),
          "zip_code": faker.address.zipCode()
        });     
    }
    for (let j = 0;  j < getRandomInt(1, 5); j++) {
      payment_methods.push({
          "CC_number": faker.finance.creditCardCVV(),
          "CC_expiry_date": generateRandomDate(new Date(2016, 0), new Date(2025, 11)),
      });
    }

    let data = {
      "firstname": faker.name.firstName(),
      "lastname": faker.name.lastName(),
      "email": usersAuthData[uid].email,
      "photoURL": faker.image.imageUrl(), // Check if the generated links work
      "addresses": addresses,
      "payment_methods": payment_methods,
      "birth_date": generateRandomDate(new Date(1950, 0), new Date(2002, 11, 31)),     
    };
    
    await users.doc(uid).set(data);
    await seedCart(uid, getRandomInt(1, 6), productsReferences);
    await seedOrders(uid, getRandomInt(1, 21), productsReferences);
    count++;

  }  
  
  console.log(`Added ${count} users`);
};

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
      "in_progress": Math.random() > 0.5,
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
};

