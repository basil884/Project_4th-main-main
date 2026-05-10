const VerificationDoctor = require('../models/VerificationDoctor');
const Doctor = require('../models/Doctor');
const User = require('../models/User');
const Notification = require('../models/Notification');

const createVerification = async (req, res) => {
    try {
        const { doctor, status } = req.body;
        const newVerification = new VerificationDoctor({ doctor, status });
        const savedVerification = await newVerification.save();
        res.status(201).json({ success: true, data: savedVerification });
    } catch (error) {
        res.status(400).json({ success: false, error: error.message });
    }
};

const getVerifications = async (req, res) => {
    try {
        const verifications = await VerificationDoctor.find().populate('doctor');
        res.status(200).json({ success: true, count: verifications.length, data: verifications });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
};

const getVerificationById = async (req, res) => {
    try {
        const verification = await VerificationDoctor.findById(req.params.id).populate('doctor');
        if (!verification) {
            return res.status(404).json({ success: false, error: 'Verification record not found' });
        }
        res.status(200).json({ success: true, data: verification });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
};

const updateVerification = async (req, res) => {
    try {
        const verification = await VerificationDoctor.findByIdAndUpdate(req.params.id, req.body, { new: true, runValidators: true });
        if (!verification) {
            return res.status(404).json({ success: false, error: 'Verification record not found' });
        }

        if (req.body.status) {
            const doctor = await Doctor.findById(verification.doctor);
            if (doctor) {
                const nextDoctorPresence = req.body.status === 'accepted' ? 'Online' : 'Offline';
                doctor.Status = nextDoctorPresence;
                await doctor.save();

                await User.findOneAndUpdate(
                    { email: String(doctor.email || '').toLowerCase() },
                    {
                        doctor: doctor._id,
                        name: `${doctor.firstName || ''} ${doctor.lastName || ''}`.trim(),
                        role: doctor.role || 'Doctor',
                        image: doctor.profileImage || '',
                        email: String(doctor.email || '').toLowerCase(),
                        password: doctor.password,
                        status: nextDoctorPresence.toLowerCase(),
                    },
                    { upsert: true, new: true, setDefaultsOnInsert: true }
                );

                await Notification.create({
                    type: 'system',
                    title: 'Doctor Verification Updated',
                    message: `${doctor.firstName || 'Doctor'} verification status is now ${req.body.status}.`,
                    isRead: false,
                });
            }
        }

        res.status(200).json({ success: true, data: verification });
    } catch (error) {
        res.status(400).json({ success: false, error: error.message });
    }
};

const deleteVerification = async (req, res) => {
    try {
        const verification = await VerificationDoctor.findByIdAndDelete(req.params.id);
        if (!verification) {
            return res.status(404).json({ success: false, error: 'Verification record not found' });
        }
        res.status(200).json({ success: true, data: {} });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
};

module.exports = {
    createVerification,
    getVerifications,
    getVerificationById,
    updateVerification,
    deleteVerification
};
