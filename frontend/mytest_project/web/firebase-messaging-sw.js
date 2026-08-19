importScripts(
  "https://www.gstatic.com/firebasejs/10.13.2/firebase-app-compat.js"
);

importScripts(
  "https://www.gstatic.com/firebasejs/10.13.2/firebase-messaging-compat.js"
);

firebase.initializeApp({
  apiKey: "AIzaSyARqBYdJ9ObTyt704E03X6sxEkpa6Nbbro",
  authDomain: "tradewisser.firebaseapp.com",
  projectId: "tradewisser",
  storageBucket: "tradewisser.firebasestorage.app",
  messagingSenderId: "134271975393",
  appId: "1:134271975393:web:c9e24ee484ca115cf85ca0"
});

const messaging = firebase.messaging();