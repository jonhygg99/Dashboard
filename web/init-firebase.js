var firebaseConfig = {
    apiKey: "AIzaSyCgY5EjcwAm3VId4VHe3emBMK7aQZXhHuI",
    authDomain: "dashboard-75f2c.firebaseapp.com",
    databaseURL: "https://dashboard-75f2c.firebaseio.com",
    projectId: "dashboard-75f2c",
    storageBucket: "dashboard-75f2c.appspot.com",
    messagingSenderId: "209813133937",
    appId: "1:209813133937:web:eda78f4778925c8d5a99d0"
};
// Initialize Firebase
firebase.initializeApp(firebaseConfig);
firebase.analytics();
var database = firebase.database();