const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');
const path = require('path');
const http = require('http'); // ✅ Required for Socket.io
const { Server } = require('socket.io');

// ✅ Best Practice: Load env variables FIRST
dotenv.config();

const connectDB = require('./config/db');
const userRoutes = require('./routes/userRoutes');
const doctorRoutes = require('./routes/doctorRoutes');
const patientRoutes = require('./routes/patientRoutes');
const productRoutes = require('./routes/productRoutes');
const shopRoutes = require('./routes/shopRoutes');
const productviewRoutes = require('./routes/productviewRoutes');
const promocodeRoutes = require('./routes/promocodeRoutes');
const cartRoutes = require('./routes/cartRoutes');
const adminRoutes = require('./routes/adminRoutes');
const insulinunitsRoutes = require('./routes/insulinunitsRoutes');
const superadminRoutes = require('./routes/superadminRoutes');
const billingRoutes = require('./routes/BillingRoutes');
const paymentRoutes = require('./routes/PaymentRoutes');
const contactRoutes = require('./routes/ContactUsRoutes');
const sellingRoutes = require('./routes/SellingRoutes');
const verificationDoctorRoutes = require('./routes/VerificationDoctorRoutes');
const ordersRoutes = require('./routes/OrdersRoutes');
const messagesRoutes = require('./routes/MessagesRoutes');
const labTestRoutes = require('./routes/LabTestRoutes');
const bookDoctorRoutes = require('./routes/BookDoctorRoutes');
const diabetesMonitoringRoutes = require('./routes/DiabetesMonitoringRoutes');
const dietlySystemRoutes = require('./routes/DietlySystemRoutes');
const myClinicRoutes = require('./routes/MyClinicRoutes');
const myPatientRoutes = require('./routes/MyPatientRoutes');
const notificationRoutes = require('./routes/NotificationRoutes');
const sinsorRoutes = require('./routes/SinsorRoutes');
const reviewRoutes = require('./routes/reviewRoutes'); // ✅ New route
const mobileRoutes = require('./routes/mobile');
const { errorHandler } = require('./middleware/errorHandler');

// ✅ Connect to Database
connectDB();

const app = express();
const server = http.createServer(app); // ✅ Create HTTP server
const io = new Server(server, {
    cors: {
        origin: "*",
        methods: ["GET", "POST"]
    }
});

// Middleware
app.use(cors({
    origin: true,
    credentials: true,
}));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// ✅ Global Logger - أول شيء يعمل عند وصول أي طلب
app.use((req, res, next) => {
    console.log(`🚀 [${new Date().toLocaleTimeString()}] Incoming: ${req.method} ${req.url}`);
    next();
});

app.use('/images', express.static(path.join(__dirname, 'public', 'images')));

// Routes
app.get('/', (req, res) => {
    res.json({ message: '🚀 API is running...' });
});

app.use('/api/users', userRoutes);
app.use('/api/doctors', doctorRoutes);
app.use('/api/patients', patientRoutes);
app.use('/api/products', productRoutes);
app.use('/api/shop', shopRoutes);
app.use('/api/productview', productviewRoutes);
app.use('/api/promocodes', promocodeRoutes);
app.use('/api/cart', cartRoutes);
app.use('/api/admins', adminRoutes);
app.use('/api/insulinunits', insulinunitsRoutes);
app.use('/api/superadmins', superadminRoutes);
app.use('/api/billings', billingRoutes);
app.use('/api/payments', paymentRoutes);
app.use('/api/contacts', contactRoutes);
app.use('/api/selling', sellingRoutes);
app.use('/api/verification-doctor', verificationDoctorRoutes);
app.use('/api/orders', ordersRoutes);
app.use('/api/messages', messagesRoutes);
app.use('/api/lab-test', labTestRoutes);
app.use('/api/book-doctor', bookDoctorRoutes);
app.use('/api/diabetes-monitoring', diabetesMonitoringRoutes);
app.use('/api/dietly-system', dietlySystemRoutes);
app.use('/api/myclinic', myClinicRoutes);
app.use('/api/my-patient', myPatientRoutes);
app.use('/api/notifications', notificationRoutes);
app.use('/api/sinsors', sinsorRoutes);
app.use('/api/reviews', reviewRoutes); // ✅ Enable reviews endpoint
app.use('/api/mobile', mobileRoutes);

// --- Socket.io Logic ---
const User = require('./models/User');
const onlineUsers = new Map(); // Store userId -> socketId

io.on('connection', (socket) => {
    console.log('📡 New Socket Connection Attempt...');
    console.log(`📡 New Socket Connection: ${socket.id}`);

    // User identifies themselves
    socket.on('setup', (userData) => {
        if (userData && userData.id) {
            socket.join(userData.id);
            onlineUsers.set(userData.id, socket.id);
            console.log(`👤 User joined: ${userData.id}`);
            socket.emit('connected');
            io.emit('user_status_change', { userId: userData.id, status: 'Online' });
            
            // تحديث قاعدة البيانات
            User.findByIdAndUpdate(userData.id, { status: "online" }).catch(() => {});
        }
    });

    // Join a specific chat room
    socket.on('join_chat', (room) => {
        socket.join(room);
        console.log(`🏠 User Joined Room: ${room}`);
    });

    // Send Message
    socket.on('new_message', (newMessageReceived) => {
        var chat = newMessageReceived.chatId;

        if (!chat) return console.log("chat not defined");

        // Broadcast to everyone in the room except sender
        socket.in(chat).emit('message_received', newMessageReceived);
    });

    // Typing Indicators
    socket.on('typing', (room) => socket.in(room).emit('typing', room));
    socket.on('stop_typing', (room) => socket.in(room).emit('stop_typing', room));

    socket.on('disconnect', () => {
        console.log("🔌 User Disconnected");
        // Find and remove from onlineUsers
        for (let [userId, socketId] of onlineUsers.entries()) {
            if (socketId === socket.id) {
                onlineUsers.delete(userId);
                io.emit('user_status_change', { userId: userId, status: 'Offline', lastSeen: new Date() });
                
                // تحديث قاعدة البيانات وتوثيق وقت الخروج
                User.findByIdAndUpdate(userId, { status: "offline", lastSeen: new Date() }).catch(() => {});
                break;
            }
        }
    });
});

// 404 Handler
app.use((req, res) => {
    res.status(404).json({ success: false, message: 'Route not found' });
});

// Global Error Handler
app.use(errorHandler);

// Start Server
const PORT = process.env.PORT || 5000;
server.listen(PORT, '0.0.0.0', () => {
    console.log(`🚀 Server running on http://192.168.1.7:${PORT}`);
});
