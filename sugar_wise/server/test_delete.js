const mongoose = require('mongoose');
const User = require('./models/User');
const Patient = require('./models/Patient');
const Doctor = require('./models/Doctor');
const Admin = require('./models/Admin');
const SuperAdmin = require('./models/SuperAdmin');

mongoose.connect('mongodb+srv://sugarwiseteam01_db_user:o86pKzryIOljwEl8@sugarwise.69cnxmg.mongodb.net/sugarwise?retryWrites=true&w=majority').then(async () => {
    try {
        const users = await User.find({}).limit(5);
        for(let user of users) {
             console.log(user._id, user.name);
             if (user.patient) await Patient.findByIdAndDelete(user.patient);
             if (user.doctor) await Doctor.findByIdAndDelete(user.doctor);
             if (user.admin) await Admin.findByIdAndDelete(user.admin);
             if (user.superAdmin) await SuperAdmin.findByIdAndDelete(user.superAdmin);
             console.log('Cascade deleted for:', user.name);
        }
    } catch (e) {
        console.error('ERROR Test:', e);
    }
    process.exit(0);
});
