// backend/models/Doctor.js
const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');

// 1. Arrays for Dropdowns
const universityNames = [
    "Cairo University (Kasr Al-Ainy)", "Ain Shams University", "Alexandria University",
    "Mansoura University", "Assiut University", "Tanta University", "Helwan University",
    "Zagazig University", "Al-Azhar University", "Suez Canal University", "Minia University",
    "Menoufia University", "Beni Suef University", "Benha University", "Fayoum University",
    "Sohag University", "Kafrelsheikh University", "Port Said University", "Aswan University",
    "Suez University", "Damietta University", "Luxor University", "Arish University",
    "New Valley University", "Galala University (GU)", "King Salman International University (KSIU)",
    "Alamein International University (AIU)", "New Mansoura University", "Beni Suef National University",
    "Assiut National University", "Alexandria National University", "Minia National University",
    "East Port Said National University", "Misr University for Science and Technology (MUST)",
    "October 6 University (O6U)", "Newgiza University (NGU)", "Badr University in Cairo (BUC)",
    "Nahda University (NUB)", "Future University in Egypt (FUE)", "Delta University for Science and Technology",
    "Modern University for Technology and Information (MTI)", "Horus University", "Sinai University", "Merit University"
];

// Role
const roles = [
    "Doctor",
    "Patient",
    "Admin",
    "Super Admin",
    "Guest"
];

const medicalSpecialties = [
    "Cardiology", "Endocrinology", "Neurology", "Pediatrics", "General Surgery",
    "Dermatology", "Orthopedics", "ENT", "Ophthalmology", "Psychiatry"
];

const governorates = [
    "Cairo", "Alexandria", "Giza", "Sharqia", "Dakahlia", "Beheira", "Qalyubia",
    "Minya", "Asyut", "Gharbia", "Monufia", "Damietta", "Ismailia", "Port Said",
    "Suez", "Aswan", "Luxor", "Red Sea", "New Valley", "Matrouh", "North Sinai",
    "South Sinai", "Beni Suef", "Fayoum", "Sohag", "Qena", "Kafr El Sheikh"
];

// 2. The Doctor Schema
const doctorSchema = new mongoose.Schema({
    doctorId: {
        type: String,
        unique: true,
    },
    firstName: {
        type: String,
        required: [true, 'First name is required'],
        trim: true,
    },
    role: {
        type: String,
        enum: roles,
    },
    lastName: {
        type: String,
        required: [true, 'Last name is required'],
        trim: true,
    },
    gender: {
        type: String,
        enum: ['Male', 'Female'],
        required: [true, 'Gender is required'],
    },
    phoneNumber: {
        type: String,
        required: [true, 'Phone number is required'],
        trim: true,
    },
    email: {
        type: String,
        required: [true, 'Email is required'],
        unique: true,
        lowercase: true,
        trim: true,
    },
    password: {
        type: String,
        required: [true, 'Password is required'],
        minlength: 6,
    },
    university: {
        type: String,
        // enum: universityNames, // تعطيله مؤقتاً لنجاح التجربة
        required: [true, 'University is required'],
    },
    medicalSpecialty: {
        type: String,
        // enum: medicalSpecialties, // تعطيله مؤقتاً
        required: [true, 'Medical specialty is required'],
    },
    // --- NEW FIELDS ADDED BELOW ---
    birthday: {
        type: Date, // Date type is best for storing birthdays
        required: [true, 'Birthday is required'],
    },
    idFrontImg: {
        type: String, // String to hold the URL/Path of the uploaded image
        required: [true, 'ID Front Image is required'],
    },
    idBackImg: {
        type: String, // String to hold the URL/Path
        required: [true, 'ID Back Image is required'],
    },
    selfImg: {
        type: String, // String to hold the URL/Path
        required: [true, 'Personal photo is required'],
    },
    graduation: {
        type: String, // E.g., Graduation year or a string path to graduation certificate
        required: [true, 'Graduation info/certificate is required'],
    },
    address: {
        type: String,
        required: [true, 'Address is required'],
        trim: true,
    },
    governorate: {
        type: String,
        // enum: governorates, // تعطيله مؤقتاً لضمان النجاح
        required: [true, 'Governorate is required'],
    },
    city: {
        type: String,
        required: [true, 'City is required'],
        trim: true,
    },
    profileImage: {
        type: String,
        default: "../Images/Users/Default.jpg" //Check this moawad
    },
    joinDate: {
        type: Date,
        default: Date.now
    },Status:{
        type: String,
        enum: ["Online", "Offline"],
        default: "Offline"
    },
    reviews: [
        {
            patientName: { type: String, required: true },
            comment: { type: String, required: true },
            rating: { type: Number, required: true },
            date: { type: String, default: "Just now" }
        }
    ],
}, {
    timestamps: true,
});

// 3. Auto-Generate DR... ID Hook
doctorSchema.pre('save', async function () {
    if (this.isNew) {
        const lastDoctor = await mongoose.model('Doctor').findOne({}, 'doctorId').sort({ createdAt: -1 });

        if (lastDoctor && lastDoctor.doctorId) {
            const lastIdNumber = parseInt(lastDoctor.doctorId.replace('DR', ''), 10);
            this.doctorId = `DR${lastIdNumber + 1}`;
        } else {
            this.doctorId = 'DR1000';
        }
    }
});

// 4. Hash Password Hook
doctorSchema.pre('save', async function () {
    if (!this.isModified('password')) {
        return;
    }
    const salt = await bcrypt.genSalt(10);
    this.password = await bcrypt.hash(this.password, salt);
});

// 5. Match Password Method
doctorSchema.methods.matchPassword = async function (enteredPassword) {
    return await bcrypt.compare(enteredPassword, this.password);
};

// 6. Static helpers for Frontend dropdowns
doctorSchema.statics.getUniversities = () => universityNames;
doctorSchema.statics.getSpecialties = () => medicalSpecialties;
doctorSchema.statics.getGovernorates = () => governorates; // Added Governorate helper

const Doctor = mongoose.model('Doctor', doctorSchema);

module.exports = Doctor;