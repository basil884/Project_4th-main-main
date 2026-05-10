const Patient = require('../models/Patient');
const sanitizePatient = (doc) => {
    const patient = doc.toObject ? doc.toObject() : doc;
    if (patient) delete patient.password;
    return patient;
};

exports.createPatient = async (req, res) => {
    try {
        const newPatient = new Patient(req.body);
        const savedPatient = await newPatient.save();
        res.status(201).json(sanitizePatient(savedPatient));
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
};

exports.getPatients = async (req, res) => {
    try {
        const patients = await Patient.find().select('-password');
        res.status(200).json(patients);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
};

exports.getPatientById = async (req, res) => {
    try {
        const query = req.params.id.startsWith('PID_') ? { Patient_Id: req.params.id } : { _id: req.params.id };
        let patient = await Patient.findOne(query).select('-password');
        
        if (!patient) {
            // 💡 Fallback: Check if the ID provided is a User._id
            const User = require('../models/User');
            const user = await User.findById(req.params.id);
            if (user && user.patient) {
                patient = await Patient.findById(user.patient).select('-password');
            }
        }

        if (!patient) return res.status(404).json({ error: 'Patient not found' });
        res.status(200).json(patient);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
};

exports.updatePatient = async (req, res) => {
    try {
        const query = req.params.id.startsWith('PID_') ? { Patient_Id: req.params.id } : { _id: req.params.id };
        const patient = await Patient.findOneAndUpdate(query, req.body, {
            new: true,
            runValidators: true,
            select: '-password',
        });
        if (!patient) return res.status(404).json({ error: 'Patient not found' });
        res.status(200).json(patient);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
};

exports.deletePatient = async (req, res) => {
    try {
        const query = req.params.id.startsWith('PID_') ? { Patient_Id: req.params.id } : { _id: req.params.id };
        const patient = await Patient.findOneAndDelete(query);
        if (!patient) return res.status(404).json({ error: 'Patient not found' });
        res.status(200).json({ message: 'Patient deleted successfully' });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
};

exports.searchPatients = async (req, res) => {
    try {
        const { query } = req.query;

        if (!query) {
            return res.status(400).json({ success: false, error: 'Search query is required' });
        }

        const searchRegex = new RegExp(query, 'i');
        const patients = await Patient.find({
            $or: [
                { firstName: searchRegex },
                { lastName: searchRegex },
                { email: searchRegex },
                { phone: searchRegex },
                { Patient_Id: searchRegex }
            ]
        }).select('-password');

        res.status(200).json({
            success: true,
            count: patients.length,
            data: patients
        });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
};
