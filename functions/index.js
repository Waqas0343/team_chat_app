/**
 * Firebase Functions v2 – Firestore Triggers + Notifications
 */

const { onRequest } = require("firebase-functions/v2/https");
const { onDocumentCreated } = require("firebase-functions/v2/firestore");
const logger = require("firebase-functions/logger");

const admin = require("firebase-admin");
admin.initializeApp();

// --- Example HTTP Function ---
exports.helloWorld = onRequest((req, res) => {
  logger.info("Hello logs!", { structuredData: true });
  res.send("Hello from Firebase!");
});

// --- Firestore Trigger: One-to-one chat notifications ---
exports.sendChatNotification = onDocumentCreated(
  "chats/{chatId}/messages/{messageId}",
  async (event) => {
    const message = event.data.data();
    const chatId = event.params.chatId;

    const chatDoc = await admin.firestore().collection("chats").doc(chatId).get();
    const participants = chatDoc.data().participants;
    const recipientId = participants.find((id) => id !== message.senderId);

    const userDoc = await admin.firestore().collection("users").doc(recipientId).get();
    const recipientToken = userDoc.data().fcmToken;

    if (!recipientToken) return null;

    const payload = {
      notification: {
        title: `New Message from ${message.senderId}`,
        body:
          message.type === "text"
            ? message.content
            : message.type === "image"
            ? "New image"
            : "New voice message",
      },
      data: { chatId: chatId },
    };

    return admin.messaging().sendToDevice(recipientToken, payload);
  }
);

// --- Firestore Trigger: Group chat notifications ---
exports.sendGroupNotification = onDocumentCreated(
  "groups/{groupId}/messages/{messageId}",
  async (event) => {
    const message = event.data.data();
    const groupId = event.params.groupId;

    const groupDoc = await admin.firestore().collection("groups").doc(groupId).get();
    const members = groupDoc.data().members;

    const tokens = [];
    for (const memberId of members) {
      if (memberId !== message.senderId) {
        const userDoc = await admin.firestore().collection("users").doc(memberId).get();
        if (userDoc.exists && userDoc.data().fcmToken) {
          tokens.push(userDoc.data().fcmToken);
        }
      }
    }

    if (tokens.length === 0) return null;

    const payload = {
      notification: {
        title: `New Message in ${groupDoc.data().name}`,
        body:
          message.type === "text"
            ? message.content
            : message.type === "image"
            ? "New image"
            : "New voice message",
      },
      data: { groupId: groupId },
    };

    return admin.messaging().sendToDevice(tokens, payload);
  }
);

// --- Firestore Trigger: Call notifications ---
exports.sendCallNotification = onDocumentCreated(
  "calls/{callId}",
  async (event) => {
    const call = event.data.data();

    const userDoc = await admin.firestore().collection("users").doc(call.receiverId).get();
    const token = userDoc.data().fcmToken;

    if (!token) return null;

    const payload = {
      notification: {
        title: "Incoming Call",
        body: `Call from ${call.callerId}`,
      },
      data: { callId: event.params.callId },
    };

    return admin.messaging().sendToDevice(token, payload);
  }
);
