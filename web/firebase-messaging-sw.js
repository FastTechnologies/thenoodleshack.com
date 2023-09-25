importScripts("https://www.gstatic.com/firebasejs/8.10.1/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.1/firebase-messaging.js");

firebase.initializeApp({
    apiKey: "AIzaSyDYJJpId7vKLxxfxOSQC9rGbwbh16EGzac",
    authDomain: "scalecafe-e41d3.firebaseapp.com",
    projectId: "scalecafe-e41d3",
    storageBucket: "scalecafe-e41d3.appspot.com",
    messagingSenderId: "321185419116",
    appId: "1:321185419116:web:fc43476afcc03630dded49",
    measurementId: "G-1TMNY6FWDK",
    databaseURL: "...",
});

const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((message) => {
});
