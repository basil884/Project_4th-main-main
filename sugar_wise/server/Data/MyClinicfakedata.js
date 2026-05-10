const myClinicFakeData = [
    {
        "name": "City Care Clinic - Branch 1",
        "image": "https://example.com/clinic_1.jpg",
        "address": "40 Street B, Alex",
        "GoogleMapUrl": "https://maps.google.com/?q=clinic_1",
        "workingDays": [
            "Sunday",
            "Monday"
        ],
        "startTime": "09:00 AM",
        "endTime": "05:00 PM",
        "minPerCase": 20,
        "dailyLimit": 21,
        "price": 250
    },
    {
        "name": "Sunrise Specialized Center - Branch 2",
        "image": "https://example.com/clinic_2.jpg",
        "address": "80 St C, Giza",
        "GoogleMapUrl": "https://maps.google.com/?q=clinic_2",
        "workingDays": [
            "Monday",
            "Tuesday"
        ],
        "startTime": "09:00 AM",
        "endTime": "05:00 PM",
        "minPerCase": 25,
        "dailyLimit": 22,
        "price": 300
    },
    {
        "name": "Hope Polyclinic - Branch 3",
        "image": "https://example.com/clinic_3.jpg",
        "address": "105 Street D, Mansoura",
        "GoogleMapUrl": "https://maps.google.com/?q=clinic_3",
        "workingDays": [
            "Tuesday",
            "Wednesday"
        ],
        "startTime": "09:00 AM",
        "endTime": "05:00 PM",
        "minPerCase": 30,
        "dailyLimit": 23,
        "price": 350
    },
    {
        "name": "El-Nour Medical Center - Branch 4",
        "image": "https://example.com/clinic_4.jpg",
        "address": "12 Street A, Cairo",
        "GoogleMapUrl": "https://maps.google.com/?q=clinic_4",
        "workingDays": [
            "Wednesday",
            "Thursday"
        ],
        "startTime": "09:00 AM",
        "endTime": "05:00 PM",
        "minPerCase": 35,
        "dailyLimit": 24,
        "price": 400
    },
    {
        "name": "Health First Medical Center - Branch 5",
        "image": "https://example.com/clinic_5.jpg",
        "address": "40 Street B, Alex",
        "GoogleMapUrl": "https://maps.google.com/?q=clinic_5",
        "workingDays": [
            "Thursday",
            "Friday"
        ],
        "startTime": "09:00 AM",
        "endTime": "05:00 PM",
        "minPerCase": 40,
        "dailyLimit": 25,
        "price": 450
    },
    {
        "name": "City Care Clinic - Branch 6",
        "image": "https://example.com/clinic_6.jpg",
        "address": "80 St C, Giza",
        "GoogleMapUrl": "https://maps.google.com/?q=clinic_6",
        "workingDays": [
            "Friday",
            "Saturday"
        ],
        "startTime": "09:00 AM",
        "endTime": "05:00 PM",
        "minPerCase": 15,
        "dailyLimit": 26,
        "price": 500
    },
    {
        "name": "Sunrise Specialized Center - Branch 7",
        "image": "https://example.com/clinic_7.jpg",
        "address": "105 Street D, Mansoura",
        "GoogleMapUrl": "https://maps.google.com/?q=clinic_7",
        "workingDays": [
            "Saturday",
            "Sunday"
        ],
        "startTime": "09:00 AM",
        "endTime": "05:00 PM",
        "minPerCase": 20,
        "dailyLimit": 27,
        "price": 550
    },
    {
        "name": "Hope Polyclinic - Branch 8",
        "image": "https://example.com/clinic_8.jpg",
        "address": "12 Street A, Cairo",
        "GoogleMapUrl": "https://maps.google.com/?q=clinic_8",
        "workingDays": [
            "Sunday",
            "Monday"
        ],
        "startTime": "09:00 AM",
        "endTime": "05:00 PM",
        "minPerCase": 25,
        "dailyLimit": 28,
        "price": 600
    },
    {
        "name": "El-Nour Medical Center - Branch 9",
        "image": "https://example.com/clinic_9.jpg",
        "address": "40 Street B, Alex",
        "GoogleMapUrl": "https://maps.google.com/?q=clinic_9",
        "workingDays": [
            "Monday",
            "Tuesday"
        ],
        "startTime": "09:00 AM",
        "endTime": "05:00 PM",
        "minPerCase": 30,
        "dailyLimit": 29,
        "price": 650
    },
    {
        "name": "Health First Medical Center - Branch 10",
        "image": "https://example.com/clinic_10.jpg",
        "address": "80 St C, Giza",
        "GoogleMapUrl": "https://maps.google.com/?q=clinic_10",
        "workingDays": [
            "Tuesday",
            "Wednesday"
        ],
        "startTime": "09:00 AM",
        "endTime": "05:00 PM",
        "minPerCase": 35,
        "dailyLimit": 30,
        "price": 200
    },
    {
        "name": "City Care Clinic - Branch 11",
        "image": "https://example.com/clinic_11.jpg",
        "address": "105 Street D, Mansoura",
        "GoogleMapUrl": "https://maps.google.com/?q=clinic_11",
        "workingDays": [
            "Wednesday",
            "Thursday"
        ],
        "startTime": "09:00 AM",
        "endTime": "05:00 PM",
        "minPerCase": 40,
        "dailyLimit": 31,
        "price": 250
    },
    {
        "name": "Sunrise Specialized Center - Branch 12",
        "image": "https://example.com/clinic_12.jpg",
        "address": "12 Street A, Cairo",
        "GoogleMapUrl": "https://maps.google.com/?q=clinic_12",
        "workingDays": [
            "Thursday",
            "Friday"
        ],
        "startTime": "09:00 AM",
        "endTime": "05:00 PM",
        "minPerCase": 15,
        "dailyLimit": 32,
        "price": 300
    },
    {
        "name": "Hope Polyclinic - Branch 13",
        "image": "https://example.com/clinic_13.jpg",
        "address": "40 Street B, Alex",
        "GoogleMapUrl": "https://maps.google.com/?q=clinic_13",
        "workingDays": [
            "Friday",
            "Saturday"
        ],
        "startTime": "09:00 AM",
        "endTime": "05:00 PM",
        "minPerCase": 20,
        "dailyLimit": 33,
        "price": 350
    },
    {
        "name": "El-Nour Medical Center - Branch 14",
        "image": "https://example.com/clinic_14.jpg",
        "address": "80 St C, Giza",
        "GoogleMapUrl": "https://maps.google.com/?q=clinic_14",
        "workingDays": [
            "Saturday",
            "Sunday"
        ],
        "startTime": "09:00 AM",
        "endTime": "05:00 PM",
        "minPerCase": 25,
        "dailyLimit": 34,
        "price": 400
    },
    {
        "name": "Health First Medical Center - Branch 15",
        "image": "https://example.com/clinic_15.jpg",
        "address": "105 Street D, Mansoura",
        "GoogleMapUrl": "https://maps.google.com/?q=clinic_15",
        "workingDays": [
            "Sunday",
            "Monday"
        ],
        "startTime": "09:00 AM",
        "endTime": "05:00 PM",
        "minPerCase": 30,
        "dailyLimit": 35,
        "price": 450
    },
    {
        "name": "City Care Clinic - Branch 16",
        "image": "https://example.com/clinic_16.jpg",
        "address": "12 Street A, Cairo",
        "GoogleMapUrl": "https://maps.google.com/?q=clinic_16",
        "workingDays": [
            "Monday",
            "Tuesday"
        ],
        "startTime": "09:00 AM",
        "endTime": "05:00 PM",
        "minPerCase": 35,
        "dailyLimit": 36,
        "price": 500
    },
    {
        "name": "Sunrise Specialized Center - Branch 17",
        "image": "https://example.com/clinic_17.jpg",
        "address": "40 Street B, Alex",
        "GoogleMapUrl": "https://maps.google.com/?q=clinic_17",
        "workingDays": [
            "Tuesday",
            "Wednesday"
        ],
        "startTime": "09:00 AM",
        "endTime": "05:00 PM",
        "minPerCase": 40,
        "dailyLimit": 37,
        "price": 550
    },
    {
        "name": "Hope Polyclinic - Branch 18",
        "image": "https://example.com/clinic_18.jpg",
        "address": "80 St C, Giza",
        "GoogleMapUrl": "https://maps.google.com/?q=clinic_18",
        "workingDays": [
            "Wednesday",
            "Thursday"
        ],
        "startTime": "09:00 AM",
        "endTime": "05:00 PM",
        "minPerCase": 15,
        "dailyLimit": 38,
        "price": 600
    },
    {
        "name": "El-Nour Medical Center - Branch 19",
        "image": "https://example.com/clinic_19.jpg",
        "address": "105 Street D, Mansoura",
        "GoogleMapUrl": "https://maps.google.com/?q=clinic_19",
        "workingDays": [
            "Thursday",
            "Friday"
        ],
        "startTime": "09:00 AM",
        "endTime": "05:00 PM",
        "minPerCase": 20,
        "dailyLimit": 39,
        "price": 650
    },
    {
        "name": "Health First Medical Center - Branch 20",
        "image": "https://example.com/clinic_20.jpg",
        "address": "12 Street A, Cairo",
        "GoogleMapUrl": "https://maps.google.com/?q=clinic_20",
        "workingDays": [
            "Friday",
            "Saturday"
        ],
        "startTime": "09:00 AM",
        "endTime": "05:00 PM",
        "minPerCase": 25,
        "dailyLimit": 20,
        "price": 200
    },
    {
        "name": "City Care Clinic - Branch 21",
        "image": "https://example.com/clinic_21.jpg",
        "address": "40 Street B, Alex",
        "GoogleMapUrl": "https://maps.google.com/?q=clinic_21",
        "workingDays": [
            "Saturday",
            "Sunday"
        ],
        "startTime": "09:00 AM",
        "endTime": "05:00 PM",
        "minPerCase": 30,
        "dailyLimit": 21,
        "price": 250
    },
    {
        "name": "Sunrise Specialized Center - Branch 22",
        "image": "https://example.com/clinic_22.jpg",
        "address": "80 St C, Giza",
        "GoogleMapUrl": "https://maps.google.com/?q=clinic_22",
        "workingDays": [
            "Sunday",
            "Monday"
        ],
        "startTime": "09:00 AM",
        "endTime": "05:00 PM",
        "minPerCase": 35,
        "dailyLimit": 22,
        "price": 300
    },
    {
        "name": "Hope Polyclinic - Branch 23",
        "image": "https://example.com/clinic_23.jpg",
        "address": "105 Street D, Mansoura",
        "GoogleMapUrl": "https://maps.google.com/?q=clinic_23",
        "workingDays": [
            "Monday",
            "Tuesday"
        ],
        "startTime": "09:00 AM",
        "endTime": "05:00 PM",
        "minPerCase": 40,
        "dailyLimit": 23,
        "price": 350
    },
    {
        "name": "El-Nour Medical Center - Branch 24",
        "image": "https://example.com/clinic_24.jpg",
        "address": "12 Street A, Cairo",
        "GoogleMapUrl": "https://maps.google.com/?q=clinic_24",
        "workingDays": [
            "Tuesday",
            "Wednesday"
        ],
        "startTime": "09:00 AM",
        "endTime": "05:00 PM",
        "minPerCase": 15,
        "dailyLimit": 24,
        "price": 400
    },
    {
        "name": "Health First Medical Center - Branch 25",
        "image": "https://example.com/clinic_25.jpg",
        "address": "40 Street B, Alex",
        "GoogleMapUrl": "https://maps.google.com/?q=clinic_25",
        "workingDays": [
            "Wednesday",
            "Thursday"
        ],
        "startTime": "09:00 AM",
        "endTime": "05:00 PM",
        "minPerCase": 20,
        "dailyLimit": 25,
        "price": 450
    },
    {
        "name": "City Care Clinic - Branch 26",
        "image": "https://example.com/clinic_26.jpg",
        "address": "80 St C, Giza",
        "GoogleMapUrl": "https://maps.google.com/?q=clinic_26",
        "workingDays": [
            "Thursday",
            "Friday"
        ],
        "startTime": "09:00 AM",
        "endTime": "05:00 PM",
        "minPerCase": 25,
        "dailyLimit": 26,
        "price": 500
    },
    {
        "name": "Sunrise Specialized Center - Branch 27",
        "image": "https://example.com/clinic_27.jpg",
        "address": "105 Street D, Mansoura",
        "GoogleMapUrl": "https://maps.google.com/?q=clinic_27",
        "workingDays": [
            "Friday",
            "Saturday"
        ],
        "startTime": "09:00 AM",
        "endTime": "05:00 PM",
        "minPerCase": 30,
        "dailyLimit": 27,
        "price": 550
    },
    {
        "name": "Hope Polyclinic - Branch 28",
        "image": "https://example.com/clinic_28.jpg",
        "address": "12 Street A, Cairo",
        "GoogleMapUrl": "https://maps.google.com/?q=clinic_28",
        "workingDays": [
            "Saturday",
            "Sunday"
        ],
        "startTime": "09:00 AM",
        "endTime": "05:00 PM",
        "minPerCase": 35,
        "dailyLimit": 28,
        "price": 600
    },
    {
        "name": "El-Nour Medical Center - Branch 29",
        "image": "https://example.com/clinic_29.jpg",
        "address": "40 Street B, Alex",
        "GoogleMapUrl": "https://maps.google.com/?q=clinic_29",
        "workingDays": [
            "Sunday",
            "Monday"
        ],
        "startTime": "09:00 AM",
        "endTime": "05:00 PM",
        "minPerCase": 40,
        "dailyLimit": 29,
        "price": 650
    },
    {
        "name": "Health First Medical Center - Branch 30",
        "image": "https://example.com/clinic_30.jpg",
        "address": "80 St C, Giza",
        "GoogleMapUrl": "https://maps.google.com/?q=clinic_30",
        "workingDays": [
            "Monday",
            "Tuesday"
        ],
        "startTime": "09:00 AM",
        "endTime": "05:00 PM",
        "minPerCase": 15,
        "dailyLimit": 30,
        "price": 200
    },
    {
        "name": "City Care Clinic - Branch 31",
        "image": "https://example.com/clinic_31.jpg",
        "address": "105 Street D, Mansoura",
        "GoogleMapUrl": "https://maps.google.com/?q=clinic_31",
        "workingDays": [
            "Tuesday",
            "Wednesday"
        ],
        "startTime": "09:00 AM",
        "endTime": "05:00 PM",
        "minPerCase": 20,
        "dailyLimit": 31,
        "price": 250
    },
    {
        "name": "Sunrise Specialized Center - Branch 32",
        "image": "https://example.com/clinic_32.jpg",
        "address": "12 Street A, Cairo",
        "GoogleMapUrl": "https://maps.google.com/?q=clinic_32",
        "workingDays": [
            "Wednesday",
            "Thursday"
        ],
        "startTime": "09:00 AM",
        "endTime": "05:00 PM",
        "minPerCase": 25,
        "dailyLimit": 32,
        "price": 300
    },
    {
        "name": "Hope Polyclinic - Branch 33",
        "image": "https://example.com/clinic_33.jpg",
        "address": "40 Street B, Alex",
        "GoogleMapUrl": "https://maps.google.com/?q=clinic_33",
        "workingDays": [
            "Thursday",
            "Friday"
        ],
        "startTime": "09:00 AM",
        "endTime": "05:00 PM",
        "minPerCase": 30,
        "dailyLimit": 33,
        "price": 350
    },
    {
        "name": "El-Nour Medical Center - Branch 34",
        "image": "https://example.com/clinic_34.jpg",
        "address": "80 St C, Giza",
        "GoogleMapUrl": "https://maps.google.com/?q=clinic_34",
        "workingDays": [
            "Friday",
            "Saturday"
        ],
        "startTime": "09:00 AM",
        "endTime": "05:00 PM",
        "minPerCase": 35,
        "dailyLimit": 34,
        "price": 400
    },
    {
        "name": "Health First Medical Center - Branch 35",
        "image": "https://example.com/clinic_35.jpg",
        "address": "105 Street D, Mansoura",
        "GoogleMapUrl": "https://maps.google.com/?q=clinic_35",
        "workingDays": [
            "Saturday",
            "Sunday"
        ],
        "startTime": "09:00 AM",
        "endTime": "05:00 PM",
        "minPerCase": 40,
        "dailyLimit": 35,
        "price": 450
    },
    {
        "name": "City Care Clinic - Branch 36",
        "image": "https://example.com/clinic_36.jpg",
        "address": "12 Street A, Cairo",
        "GoogleMapUrl": "https://maps.google.com/?q=clinic_36",
        "workingDays": [
            "Sunday",
            "Monday"
        ],
        "startTime": "09:00 AM",
        "endTime": "05:00 PM",
        "minPerCase": 15,
        "dailyLimit": 36,
        "price": 500
    },
    {
        "name": "Sunrise Specialized Center - Branch 37",
        "image": "https://example.com/clinic_37.jpg",
        "address": "40 Street B, Alex",
        "GoogleMapUrl": "https://maps.google.com/?q=clinic_37",
        "workingDays": [
            "Monday",
            "Tuesday"
        ],
        "startTime": "09:00 AM",
        "endTime": "05:00 PM",
        "minPerCase": 20,
        "dailyLimit": 37,
        "price": 550
    },
    {
        "name": "Hope Polyclinic - Branch 38",
        "image": "https://example.com/clinic_38.jpg",
        "address": "80 St C, Giza",
        "GoogleMapUrl": "https://maps.google.com/?q=clinic_38",
        "workingDays": [
            "Tuesday",
            "Wednesday"
        ],
        "startTime": "09:00 AM",
        "endTime": "05:00 PM",
        "minPerCase": 25,
        "dailyLimit": 38,
        "price": 600
    },
    {
        "name": "El-Nour Medical Center - Branch 39",
        "image": "https://example.com/clinic_39.jpg",
        "address": "105 Street D, Mansoura",
        "GoogleMapUrl": "https://maps.google.com/?q=clinic_39",
        "workingDays": [
            "Wednesday",
            "Thursday"
        ],
        "startTime": "09:00 AM",
        "endTime": "05:00 PM",
        "minPerCase": 30,
        "dailyLimit": 39,
        "price": 650
    },
    {
        "name": "Health First Medical Center - Branch 40",
        "image": "https://example.com/clinic_40.jpg",
        "address": "12 Street A, Cairo",
        "GoogleMapUrl": "https://maps.google.com/?q=clinic_40",
        "workingDays": [
            "Thursday",
            "Friday"
        ],
        "startTime": "09:00 AM",
        "endTime": "05:00 PM",
        "minPerCase": 35,
        "dailyLimit": 20,
        "price": 200
    },
    {
        "name": "City Care Clinic - Branch 41",
        "image": "https://example.com/clinic_41.jpg",
        "address": "40 Street B, Alex",
        "GoogleMapUrl": "https://maps.google.com/?q=clinic_41",
        "workingDays": [
            "Friday",
            "Saturday"
        ],
        "startTime": "09:00 AM",
        "endTime": "05:00 PM",
        "minPerCase": 40,
        "dailyLimit": 21,
        "price": 250
    },
    {
        "name": "Sunrise Specialized Center - Branch 42",
        "image": "https://example.com/clinic_42.jpg",
        "address": "80 St C, Giza",
        "GoogleMapUrl": "https://maps.google.com/?q=clinic_42",
        "workingDays": [
            "Saturday",
            "Sunday"
        ],
        "startTime": "09:00 AM",
        "endTime": "05:00 PM",
        "minPerCase": 15,
        "dailyLimit": 22,
        "price": 300
    },
    {
        "name": "Hope Polyclinic - Branch 43",
        "image": "https://example.com/clinic_43.jpg",
        "address": "105 Street D, Mansoura",
        "GoogleMapUrl": "https://maps.google.com/?q=clinic_43",
        "workingDays": [
            "Sunday",
            "Monday"
        ],
        "startTime": "09:00 AM",
        "endTime": "05:00 PM",
        "minPerCase": 20,
        "dailyLimit": 23,
        "price": 350
    },
    {
        "name": "El-Nour Medical Center - Branch 44",
        "image": "https://example.com/clinic_44.jpg",
        "address": "12 Street A, Cairo",
        "GoogleMapUrl": "https://maps.google.com/?q=clinic_44",
        "workingDays": [
            "Monday",
            "Tuesday"
        ],
        "startTime": "09:00 AM",
        "endTime": "05:00 PM",
        "minPerCase": 25,
        "dailyLimit": 24,
        "price": 400
    },
    {
        "name": "Health First Medical Center - Branch 45",
        "image": "https://example.com/clinic_45.jpg",
        "address": "40 Street B, Alex",
        "GoogleMapUrl": "https://maps.google.com/?q=clinic_45",
        "workingDays": [
            "Tuesday",
            "Wednesday"
        ],
        "startTime": "09:00 AM",
        "endTime": "05:00 PM",
        "minPerCase": 30,
        "dailyLimit": 25,
        "price": 450
    },
    {
        "name": "City Care Clinic - Branch 46",
        "image": "https://example.com/clinic_46.jpg",
        "address": "80 St C, Giza",
        "GoogleMapUrl": "https://maps.google.com/?q=clinic_46",
        "workingDays": [
            "Wednesday",
            "Thursday"
        ],
        "startTime": "09:00 AM",
        "endTime": "05:00 PM",
        "minPerCase": 35,
        "dailyLimit": 26,
        "price": 500
    },
    {
        "name": "Sunrise Specialized Center - Branch 47",
        "image": "https://example.com/clinic_47.jpg",
        "address": "105 Street D, Mansoura",
        "GoogleMapUrl": "https://maps.google.com/?q=clinic_47",
        "workingDays": [
            "Thursday",
            "Friday"
        ],
        "startTime": "09:00 AM",
        "endTime": "05:00 PM",
        "minPerCase": 40,
        "dailyLimit": 27,
        "price": 550
    },
    {
        "name": "Hope Polyclinic - Branch 48",
        "image": "https://example.com/clinic_48.jpg",
        "address": "12 Street A, Cairo",
        "GoogleMapUrl": "https://maps.google.com/?q=clinic_48",
        "workingDays": [
            "Friday",
            "Saturday"
        ],
        "startTime": "09:00 AM",
        "endTime": "05:00 PM",
        "minPerCase": 15,
        "dailyLimit": 28,
        "price": 600
    },
    {
        "name": "El-Nour Medical Center - Branch 49",
        "image": "https://example.com/clinic_49.jpg",
        "address": "40 Street B, Alex",
        "GoogleMapUrl": "https://maps.google.com/?q=clinic_49",
        "workingDays": [
            "Saturday",
            "Sunday"
        ],
        "startTime": "09:00 AM",
        "endTime": "05:00 PM",
        "minPerCase": 20,
        "dailyLimit": 29,
        "price": 650
    },
    {
        "name": "Health First Medical Center - Branch 50",
        "image": "https://example.com/clinic_50.jpg",
        "address": "80 St C, Giza",
        "GoogleMapUrl": "https://maps.google.com/?q=clinic_50",
        "workingDays": [
            "Sunday",
            "Monday"
        ],
        "startTime": "09:00 AM",
        "endTime": "05:00 PM",
        "minPerCase": 25,
        "dailyLimit": 30,
        "price": 200
    }
];

module.exports = myClinicFakeData;
