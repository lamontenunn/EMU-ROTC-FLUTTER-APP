const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.addUserToChannel = functions.firestore
  .document("users/{userId}")
  .onCreate(async (snap, context) => {
    const newUser = snap.data();

    if (!newUser) {
      console.error("User data not found");
      return;
    }

    const userType = newUser.userType;
    const userId = context.params.userId;

    // Find the corresponding chat channel based on the UserType.
    const channelsQuerySnapshot = await admin.firestore()
      .collection("channels")
      .where("userTypes", "array-contains", userType)
      .get();

    if (channelsQuerySnapshot.empty) {
      console.error("No channel found for UserType:", userType);
      return;
    }

    // Assuming there's only one channel for each UserType.
    const channelDoc = channelsQuerySnapshot.docs[0];

    // Add the user to the channel.
    const channelRef = admin.firestore().collection("channels").doc(channelDoc.id);
    await channelRef.update({
      members: admin.firestore.FieldValue.arrayUnion(userId)
    });

    console.log("User added to channel:", channelDoc.id);
  });
