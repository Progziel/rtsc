# JavaScript Fuction
# const functions = require('firebase-functions');
# const admin = require('firebase-admin');
# admin.initializeApp();
#
# exports.sendTargetedNotifications = functions.firestore
# .document('companies/{companyID}/posts/{postID}')
# .onCreate(async (snapshot, context) => {
#                                        // const company = context.params.company;
# const post = snapshot.data();
#
# // Ensure the companyName and userName are strings
#                                            // const title = String(post.companyName);
# // const content = String(post.userName);
#
# const payload = {
#     notification: {
#         title: 'Post by ' + String(post.userName),
#         body: 'Company: ' + String(post.companyName),
#     },
#     topic: String(post.companyId),
# };
#
# return admin.messaging().send(payload);
# });




# Welcome to Cloud Functions for Firebase for Python!
# To get started, simply uncomment the below code or create your own.
# Deploy with `firebase deploy`

from firebase_functions import https_fn
from firebase_admin import initialize_app

# initialize_app()
#
#
# @https_fn.on_request()
# def on_request_example(req: https_fn.Request) -> https_fn.Response:
#     return https_fn.Response("Hello world!")