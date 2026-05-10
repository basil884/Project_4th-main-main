const Doctor = require('../models/Doctor');
const sanitizeDoctor = (doc) => {
    const doctor = doc.toObject ? doc.toObject() : doc;
    if (doctor) delete doctor.password;
    return doctor;
};

exports.createDoctor = async (req, res) => {
    try {
        const data = req.body;
        console.log("📥 Incoming Doctor Data:", JSON.stringify(data, null, 2));
        
        // 🛠️ معالجة الحقول لضمان توافقها مع الموديل
        if (data.phone && !data.phoneNumber) {
            data.phoneNumber = data.phone;
        }

        // وضع قيم افتراضية للصور المطلوبة حالياً في الموديل لمنع الـ Validation Error
        data.idFrontImg = data.idFrontImg || "pending";
        data.idBackImg = data.idBackImg || "pending";
        data.selfImg = data.selfImg || "pending";
        data.graduation = data.graduation || "pending";

        const newDoc = new Doctor(data);
        const savedDoc = await newDoc.save();
        res.status(201).json(sanitizeDoctor(savedDoc));
    } catch (err) { 
        console.error("Doctor Registration Error:", err.message);
        res.status(500).json({ error: err.message }); 
    }
};

exports.getDoctors = async (req, res) => {
    try {
        const docs = await Doctor.find().select('-password');
        res.status(200).json(docs);
    } catch (err) { res.status(500).json({ error: err.message }); }
};

exports.getDoctorMeta = async (req, res) => {
    try {
        res.status(200).json({
            universities: Doctor.getUniversities(),
            specialties: Doctor.getSpecialties(),
            governorates: Doctor.getGovernorates(),
        });
    } catch (err) { res.status(500).json({ error: err.message }); }
};

exports.getDoctorById = async (req, res) => {
    try {
        const doc = await Doctor.findById(req.params.id).select('-password');
        if (!doc) return res.status(404).json({ error: 'Not found' });
        res.status(200).json(doc);
    } catch (err) { res.status(500).json({ error: err.message }); }
};

exports.updateDoctor = async (req, res) => {
    try {
        const doc = await Doctor.findByIdAndUpdate(req.params.id, req.body, {
            new: true,
            runValidators: true,
            select: '-password',
        });
        if (!doc) return res.status(404).json({ error: 'Not found' });
        res.status(200).json(doc);
    } catch (err) { res.status(500).json({ error: err.message }); }
};

exports.deleteDoctor = async (req, res) => {
    try {
        const doc = await Doctor.findByIdAndDelete(req.params.id);
        if (!doc) return res.status(404).json({ error: 'Not found' });
        res.status(200).json({ message: 'Deleted successfully' });
    } catch (err) { res.status(500).json({ error: err.message }); }
};

// Search doctors by name, specialty, or other fields
exports.searchDoctors = async (req, res) => {
    try {
        const { query } = req.query;

        if (!query) {
            return res.status(400).json({ 
                success: false,
                error: 'Search query is required' 
            });
        }

        // Search in name, specialty, university, etc.
        const doctors = await Doctor.find({
            $or: [
                { name: { $regex: query, $options: 'i' } },
                { specialty: { $regex: query, $options: 'i' } },
                { university: { $regex: query, $options: 'i' } },
                { governorate: { $regex: query, $options: 'i' } },
                { clinicName: { $regex: query, $options: 'i' } }
            ]
        }).select('-password');

        res.status(200).json({
            success: true,
            count: doctors.length,
            data: doctors
        });
    } catch (err) { 
        res.status(500).json({ 
            success: false,
            error: err.message 
        }); 
    }
};
