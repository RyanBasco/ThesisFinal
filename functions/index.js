const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.sendPasswordResetLink = functions.https.onCall(async (data, context) => {
  const email = data.email;

  try {
    // Generate a password reset link using Firebase Admin SDK
    const resetLink = await admin.auth().generatePasswordResetLink(email, {
      url: "https://thesisapp1.page.link", // Replace with your Firebase Dynamic Link URL prefix
      handleCodeInApp: true,
    });

    return {resetLink};
  } catch (error) {
    console.error("Error generating password reset link:", error);
    throw new functions.https.HttpsError("internal", "Unable to generate reset link");
  }
});
