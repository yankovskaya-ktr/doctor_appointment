/* eslint-disable object-curly-spacing */
/* eslint-disable max-len */
/* eslint-disable indent */
require("firebase-functions/logger/compat");
const moment = require("moment");
// The Cloud Functions for Firebase SDK to create Cloud Functions and triggers.
const onDocumentCreated = require("firebase-functions/v2/firestore");
// The Firebase Admin SDK to access Firestore.
const admin = require("firebase-admin");

admin.initializeApp();

exports.notifyDoctorOnAppointment =
    onDocumentCreated("appointments/{appointmentId}", async (event) => {
        console.log("==== start function on new appointment");
        const db = admin.firestore();

        const appointment = event.data.data();
        const doctorId = appointment.doctorId;

        // Get notification tokens for doctor
        const doctor = await db.collection("users").doc(doctorId).get()
            .then((snapshot) => snapshot.data());

        if (!Object.hasOwn(doctor, "notificationTokens") ||
            doctor.notificationTokens.length == 0) {
            console.log("==== No device tokens registered for  doctor");
            return;
        }

        // Notification details
        const message = {
            notification: {
                title: "New appointment!",
                body: `${moment(Date(appointment.start)).format("DD.MM HH:mm")} with ${appointment.patientName}`,
            },
            tokens: doctor.notificationTokens,
        };

        return admin.messaging().sendEachForMulticast(message)
            .then((response) => {
                console.log(response.successCount + " messages were sent successfully");
            });
    });
