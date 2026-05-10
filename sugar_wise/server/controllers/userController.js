const User = require('../models/User');
const Patient = require('../models/Patient');
const Doctor = require('../models/Doctor');
const Admin = require('../models/Admin');
const SuperAdmin = require('../models/SuperAdmin');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

const JWT_SECRET = process.env.JWT_SECRET || 'your-secret-key';
const JWT_EXPIRES_IN = process.env.JWT_EXPIRES_IN || '7d';

// --- Helper Functions ---

const signToken = (user) =>
    jwt.sign(
        {
            id: user._id,
            role: user.role,
            email: user.email,
        },
        JWT_SECRET,
        { expiresIn: JWT_EXPIRES_IN }
    );

const normalizePresence = (value) => {
    const normalized = String(value || '').trim().toLowerCase();
    return normalized === 'online' ? 'online' : 'offline';
};

const sanitizeUser = (userDoc) => {
    const user = userDoc.toObject ? userDoc.toObject() : userDoc;
    delete user.password;
    return user;
};

const comparePasswordSafe = async (enteredPassword, storedPassword) => {
    if (!storedPassword) return false;
    try {
        const matched = await bcrypt.compare(enteredPassword, storedPassword);
        if (matched) return true;
        // Fallback for plain-text legacy passwords (if applicable)
        return enteredPassword === storedPassword;
    } catch (error) {
        return false;
    }
};

const syncUserFromLinkedCollections = async (email) => {
    const loweredEmail = email.toLowerCase();

    // Check Admin
    const admin = await Admin.findOne({ email: loweredEmail });
    if (admin) {
        return User.findOneAndUpdate(
            { email: loweredEmail },
            {
                admin: admin._id,
                name: admin.name,
                role: admin.role || 'Admin',
                image: admin.Image || '',
                email: loweredEmail,
                password: admin.password,
            },
            { new: true, upsert: true, setDefaultsOnInsert: true }
        );
    }

    // Check SuperAdmin
    const superAdmin = await SuperAdmin.findOne({ email: loweredEmail });
    if (superAdmin) {
        return User.findOneAndUpdate(
            { email: loweredEmail },
            {
                superAdmin: superAdmin._id,
                name: superAdmin.name,
                role: superAdmin.role || 'Super Admin',
                image: superAdmin.Image || '',
                email: loweredEmail,
                password: superAdmin.password,
            },
            { new: true, upsert: true, setDefaultsOnInsert: true }
        );
    }

    // Check Doctor
    const doctor = await Doctor.findOne({ email: loweredEmail });
    if (doctor) {
        return User.findOneAndUpdate(
            { email: loweredEmail },
            {
                doctor: doctor._id,
                name: `${doctor.firstName || ''} ${doctor.lastName || ''}`.trim(),
                role: doctor.role || 'Doctor',
                image: doctor.profileImage || '',
                email: loweredEmail,
                password: doctor.password,
            },
            { new: true, upsert: true, setDefaultsOnInsert: true }
        );
    }

    // Check Patient
    const patient = await Patient.findOne({ email: loweredEmail });
    if (patient) {
        return User.findOneAndUpdate(
            { email: loweredEmail },
            {
                patient: patient._id,
                name: `${patient.firstName || ''} ${patient.lastName || ''}`.trim(),
                role: patient.role || 'Patient',
                image: patient.profileImage || '',
                email: loweredEmail,
                password: patient.password,
            },
            { new: true, upsert: true, setDefaultsOnInsert: true }
        );
    }

    return null;
};

const setPresenceStatus = async (userDoc, nextStatus) => {
    if (!userDoc?._id) return;

    const normalizedStatus = normalizePresence(nextStatus);
    await User.findByIdAndUpdate(userDoc._id, { status: normalizedStatus });

    const role = String(userDoc.role || '').trim().toLowerCase();
    const capitalized = normalizedStatus === 'online' ? 'Online' : 'Offline';

    const updateData = { status: capitalized }; // Generic field name
    const updateDataCapital = { Status: capitalized }; // Legacy capitalized field name

    if (role === 'patient' && userDoc.patient) {
        await Patient.findByIdAndUpdate(userDoc.patient, updateDataCapital);
    } else if (role === 'doctor' && userDoc.doctor) {
        await Doctor.findByIdAndUpdate(userDoc.doctor, updateDataCapital);
    } else if (role === 'admin' && userDoc.admin) {
        await Admin.findByIdAndUpdate(userDoc.admin, updateData);
    } else if (role.includes('superadmin') && userDoc.superAdmin) {
        await SuperAdmin.findByIdAndUpdate(userDoc.superAdmin, updateData);
    }
};

// --- Controllers ---

const getUsers = async (req, res, next) => {
    try {
        const users = await User.find().select('-password').sort({ createdAt: -1 });
        res.status(200).json({ success: true, count: users.length, data: users });
    } catch (error) {
        next(error);
    }
};

const getUserById = async (req, res, next) => {
    try {
        const user = await User.findById(req.params.id).select('-password');
        if (!user) {
            return res.status(404).json({ success: false, message: 'User not found' });
        }
        res.status(200).json({ success: true, data: user });
    } catch (error) {
        next(error);
    }
};

const createUser = async (req, res, next) => {
    try {
        const { name, email, password, role } = req.body;
        const hashedPassword = await bcrypt.hash(password, 10);
        const user = await User.create({ 
            name, 
            email: email.toLowerCase(), 
            password: hashedPassword, 
            role 
        });
        res.status(201).json({ success: true, data: sanitizeUser(user) });
    } catch (error) {
        if (error.code === 11000) {
            return res.status(400).json({ success: false, message: 'Email already exists' });
        }
        next(error);
    }
};

const registerUser = async (req, res, next) => {
    try {
        const { name, email, password, role = 'Guest' } = req.body;
        if (!email || !password) {
            return res.status(400).json({ success: false, message: 'Email and password are required' });
        }

        const normalizedRole = String(role || 'Guest').trim().toLowerCase();
        const forbiddenRoles = ['admin', 'super admin', 'superadmin', 'subadmin'];
        
        if (forbiddenRoles.includes(normalizedRole)) {
            return res.status(403).json({
                success: false,
                message: 'This role is not allowed via public registration',
            });
        }

        const exists = await User.findOne({ email: email.toLowerCase() });
        if (exists) {
            return res.status(400).json({ success: false, message: 'Email already exists' });
        }

        const hashedPassword = await bcrypt.hash(password, 10);
        const createdUser = await User.create({
            name: name || email.split('@')[0],
            email: email.toLowerCase(),
            password: hashedPassword,
            role,
        });

        const token = signToken(createdUser);
        return res.status(201).json({
            success: true,
            data: { token, user: sanitizeUser(createdUser) },
        });
    } catch (error) {
        next(error);
    }
};

const loginUser = async (req, res, next) => {
    try {
        const { email, password } = req.body;
        if (!email || !password) {
            return res.status(400).json({ success: false, message: 'Email and password are required' });
        }

        const loweredEmail = email.toLowerCase();
        let user = await User.findOne({ email: loweredEmail });
        
        if (!user) {
            user = await syncUserFromLinkedCollections(loweredEmail);
        }

        if (!user || !user.password) {
            return res.status(401).json({ success: false, message: 'Invalid email or password' });
        }

        const isValid = await comparePasswordSafe(password, user.password);
        if (!isValid) {
            return res.status(401).json({ success: false, message: 'Invalid email or password' });
        }

        const token = signToken(user);
        await setPresenceStatus(user, 'online');
        
        // 🔥 دمج البيانات التفصيلية (Populate) قبل الإرجاع
        const freshUser = await User.findById(user._id)
            .select('-password')
            .populate('doctor')
            .populate('patient');

        return res.status(200).json({
            success: true,
            data: { token, user: freshUser },
        });
    } catch (error) {
        next(error);
    }
};

const logoutUser = async (req, res, next) => {
    try {
        const userId = req.user?.id || req.body?.userId;
        if (userId) {
            const user = await User.findById(userId);
            if (user) await setPresenceStatus(user, 'offline');
        }
        return res.status(200).json({ success: true, message: 'Logged out successfully' });
    } catch (error) {
        next(error);
    }
};

const deleteUser = async (req, res, next) => {
    try {
        const targetUserId = req.params.id;

        // 1. Prevent self-deletion
        if (req.user && req.user.id === targetUserId) {
            return res.status(400).json({ success: false, message: "You cannot delete your own account." });
        }

        const user = await User.findById(targetUserId);
        if (!user) {
            return res.status(404).json({ success: false, message: 'User not found' });
        }

        // 2. Safeguard SuperAdmins from accidental deletion
        if (user.role.toLowerCase().includes('superadmin')) {
            return res.status(403).json({ success: false, message: "Super Admin accounts cannot be deleted." });
        }

        // 3. Perform Cascade Deletion
        const deletionPromises = [];
        if (user.patient) deletionPromises.push(Patient.findByIdAndDelete(user.patient));
        if (user.doctor) deletionPromises.push(Doctor.findByIdAndDelete(user.doctor));
        if (user.admin) deletionPromises.push(Admin.findByIdAndDelete(user.admin));
        if (user.superAdmin) deletionPromises.push(SuperAdmin.findByIdAndDelete(user.superAdmin));

        await Promise.allSettled(deletionPromises);
        await User.findByIdAndDelete(targetUserId);

        res.status(200).json({ success: true, message: 'User and all linked data deleted successfully' });
    } catch (error) {
        next(error);
    }
};

module.exports = { 
    getUsers, 
    getUserById, 
    createUser, 
    deleteUser, 
    registerUser, 
    loginUser, 
    logoutUser 
};