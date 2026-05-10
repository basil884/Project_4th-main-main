# Backend API Matrix

This file is a combined map of the backend APIs for the Sugar Wise project.

It includes:

- the route inventory
- the request/response shape for each API group
- live HTTP probes that were executed against the local server
- notes about auth, GET/POST/PUT/PATCH/DELETE, HEAD, and OPTIONS behavior

## Live Verification

These probes were executed against the local server at `http://localhost:5000`.

### Root and mobile health

- `GET /` -> `200`
- `HEAD /` -> `200`
- `OPTIONS /` -> `204`
- `GET /api/mobile/` -> `200`
- `HEAD /api/mobile/` -> `200`
- `OPTIONS /api/mobile/` -> `204`
- `POST /api/presence/ping` -> `200`
- `OPTIONS /api/presence/ping` -> `204`

### Auth

I logged in with a seeded admin account:

- email: `youssefkhattab@sugarwiseadmin.com`
- password: `Password123!`

That returned a JWT token successfully.

### Verified GET responses

These endpoints returned `200` with the noted top-level JSON shape:

- `GET /api/users` -> `success,count,data`
- `GET /api/doctors` -> `success,count,data`
- `GET /api/patients` -> raw array
- `GET /api/products` -> `success,count,data`
- `GET /api/orders` -> `success,count,data,message`
- `GET /api/notifications` -> `success,count,unreadCount,data,message`
- `GET /api/diabetes-monitoring` -> `success,count,data,message`
- `GET /api/lab-test` -> `success,count,data,message`
- `GET /api/book-doctor` -> `success,count,data,message`
- `GET /api/messages/chats` -> `success,count,data,message`
- `GET /api/admins` -> `success,count,data`
- `GET /api/superadmins` -> `success,count,data`
- `GET /api/cart` -> `success,count,data`
- `GET /api/billings` -> `success,count,data`
- `GET /api/payments` -> `success,data,count`
- `GET /api/myclinic` -> `success,count,data,message`
- `GET /api/my-patient` -> `success,count,data,message`
- `GET /api/subscriptions` -> raw array

### Verified create/update/delete flows

Temporary records were created and then cleaned up successfully:

- `POST /api/notifications` -> `201`
- `PUT /api/notifications/:id` -> `200`
- `DELETE /api/notifications/:id` -> `200`

### 💬 Messages & Chat
- `GET /api/messages/chats` -> Get all chats for current user
- `GET /api/messages/chats/:chatId` -> Get messages in a specific chat
- `POST /api/messages` -> Send a new message
- `DELETE /api/messages/:id` -> Delete a message
- `PUT /api/messages/chats/:chatId/read` -> Mark chat as read
- `POST /api/messages/chats/direct` -> Create or get direct chat
- `POST /api/diabetes-monitoring` -> `201`
- `PUT /api/diabetes-monitoring/:id` -> `200`
- `DELETE /api/diabetes-monitoring/:id` -> `200`

### Verified PATCH

- `PATCH /api/orders/000000000000000000000000/status` -> `404`

This confirms the route exists, but the dummy order id does not.

### Important correction

- `GET /api/presence` is not a valid route.
- The real heartbeat endpoint is `POST /api/presence/ping`.

## Backend Route Inventory

The backend route registration lives in:

- `server/index.js`

The mobile namespace is mounted at:

- `/api/mobile`

The main route groups are below.

## 1. Auth And Users

Files:

- `server/routes/userRoutes.js`
- `server/controllers/userController.js`

### Endpoints

- `POST /api/users/register`
- `POST /api/users/login`
- `POST /api/users/logout`
- `POST /api/users/forgot-password/send-otp`
- `POST /api/users/forgot-password/verify-otp`
- `POST /api/users/forgot-password/reset`
- `GET /api/users`
- `POST /api/users`
- `GET /api/users/:id`
- `PUT /api/users/:id`
- `DELETE /api/users/:id`

### Request shape

- register/login use `email` and `password`
- user create/update uses account fields such as `name`, `email`, `role`, `image`
- forgot password uses `email`, `otp`, and `newPassword`

### Response shape

- login/register returns `success, data: { token, user }`
- list endpoints return `success, count, data`
- single-user endpoints return `success, data`
- mutations usually return `success, data` or `success, message`

## 2. Doctors

Files:

- `server/routes/doctorRoutes.js`
- `server/controllers/doctorController.js`

### Endpoints

- `GET /api/doctors`
- `POST /api/doctors`
- `GET /api/doctors/:id`
- `PUT /api/doctors/:id`
- `DELETE /api/doctors/:id`
- `GET /api/doctors/meta`
- `GET /api/doctors/search`
- `POST /api/doctors/:id/follow`
- `POST /api/doctors/:id/rate`

### Request shape

- create/update doctor uses doctor profile fields like `firstName`, `lastName`, `medicalSpecialty`, `phoneNumber`, `email`, `password`, `university`
- search uses query params such as `q` and `specialty`
- rate uses rating payload, usually a numeric value

### Response shape

- list endpoints return `success,count,data`
- `meta` returns plain JSON lists for universities, specialties, and governorates
- doctor detail returns `success,data`

## 3. Patients

Files:

- `server/routes/patientRoutes.js`
- `server/controllers/patientController.js`

### Endpoints

- `GET /api/patients`
- `POST /api/patients`
- `GET /api/patients/me`
- `PUT /api/patients/me/location`
- `GET /api/patients/search`
- `GET /api/patients/:id`
- `PUT /api/patients/:id`
- `DELETE /api/patients/:id`

### Request shape

- create/update patient uses profile fields like `firstName`, `lastName`, `gender`, `birthday`, `phone`, `address`, `governorate`, `city`, `weight`, `height`, `bloodType`, `medicalCondition`
- location update uses `latitude`, `longitude`, `accuracy`, `label`

### Response shape

- `GET /api/patients` returns a raw array
- `GET /api/patients/me` returns `success,data`
- other endpoints usually return `success,data` or a simple error object

## 4. Diabetes Monitoring

Files:

- `server/routes/DiabetesMonitoringRoutes.js`
- `server/controllers/DiabetesMonitoringController.js`
- `server/models/DiabetesMonitoring.js`

### Endpoints

- `GET /api/diabetes-monitoring`
- `POST /api/diabetes-monitoring`
- `GET /api/diabetes-monitoring/:id`
- `PUT /api/diabetes-monitoring/:id`
- `DELETE /api/diabetes-monitoring/:id`

### Request shape

- `level`
- `unit`
- `date`
- `time`
- `mealType`
- `foods`
- `insulin`
- `insulinUnit`
- `notes`

### Response shape

- list endpoints return `success,count,data,message`
- create/update/get-by-id return `success,data,message`
- delete returns `success,data,message`

## 5. Messages

Files:

- `server/routes/MessagesRoutes.js`
- `server/controllers/MessagesController.js`

### Endpoints

- `GET /api/messages/chats`
- `POST /api/messages/chats/direct`
- `GET /api/messages/chats/:chatId`
- `PUT /api/messages/chats/:chatId/read`
- `DELETE /api/messages/chats/:chatId`
- `POST /api/messages`
- `DELETE /api/messages/:id`

### Request shape

- direct chat uses `senderId` and `receiverId`
- message send uses `chatId`, `senderId`, `receiverId`, `messageText`

### Response shape

- chat list and message list usually return `success,count,data,message`
- create/delete actions return `success,data` or `success,message`

## 6. Products

Files:

- `server/routes/productRoutes.js`
- `server/controllers/productController.js`

### Endpoints

- `GET /api/products`
- `POST /api/products`
- `GET /api/products/:id`
- `PUT /api/products/:id`
- `DELETE /api/products/:id`
- `GET /api/products/search`
- `POST /api/products/:id/rate`

### Request shape

- product create/update uses product fields from the schema
- search uses `query`
- rate uses rating payload

### Response shape

- list and detail endpoints return `success,count,data` or `success,data`
- create/update often return the saved product object

## 7. Orders

Files:

- `server/routes/OrdersRoutes.js`
- `server/controllers/OrdersController.js`

### Endpoints

- `GET /api/orders`
- `POST /api/orders`
- `GET /api/orders/user`
- `GET /api/orders/:id`
- `PUT /api/orders/:id`
- `DELETE /api/orders/:id`
- `PATCH /api/orders/:id/status`

### Request shape

- create order expects `items`, `totalPrice`, and usually `shippingAddress`
- status patch expects the new order status

### Response shape

- list returns `success,count,data,message`
- detail returns `success,data,message`
- create returns `success,data,message`

## 8. Notifications

Files:

- `server/routes/NotificationRoutes.js`
- `server/controllers/NotificationController.js`

### Endpoints

- `GET /api/notifications`
- `POST /api/notifications`
- `GET /api/notifications/:id`
- `PUT /api/notifications/:id`
- `DELETE /api/notifications/:id`

### Request shape

- create uses `title` and `message`
- update can change `isRead` and admin-only fields

### Response shape

- list returns `success,count,unreadCount,data,message`
- create/update/get/delete return `success,data,message` or `success,message`

## 9. Book Doctor

Files:

- `server/routes/BookDoctorRoutes.js`
- `server/controllers/BookDoctorController.js`

### Endpoints

- `GET /api/book-doctor`
- `POST /api/book-doctor`
- `GET /api/book-doctor/:id`
- `PUT /api/book-doctor/:id`
- `DELETE /api/book-doctor/:id`

### Request shape

- booking uses doctor/patient booking fields from the controller/schema

### Response shape

- list returns `success,count,data,message`
- detail/mutation returns `success,data,message`

## 10. Lab Tests

Files:

- `server/routes/LabTestRoutes.js`
- `server/controllers/LabTestController.js`

### Endpoints

- `GET /api/lab-test`
- `POST /api/lab-test`
- `GET /api/lab-test/:id`
- `PUT /api/lab-test/:id`
- `DELETE /api/lab-test/:id`

### Request shape

- lab test create/update follows lab test schema fields and file/report references

### Response shape

- list returns `success,count,data,message`
- create/update/get/delete returns `success,data,message` or a simple error object

## 11. Billing

Files:

- `server/routes/BillingRoutes.js`
- `server/controllers/BillingController.js`

### Endpoints

- `GET /api/billings`
- `POST /api/billings`
- `GET /api/billings/:id`
- `PUT /api/billings/:id`
- `DELETE /api/billings/:id`

### Request shape

- create/update billing uses fields like `cardholderName`, `cardNumber`, `expiryDate`, `cvvCvc`

### Response shape

- list returns `success,count,data`
- detail returns `success,data`
- create/update/delete return `success,data` or `success,message`

## 12. Payments

Files:

- `server/routes/PaymentRoutes.js`
- `server/controllers/PaymentController.js`

### Endpoints

- `POST /api/payments/stripe/checkout-session`
- `POST /api/payments/stripe/finalize`
- `POST /api/payments`
- `GET /api/payments`
- `GET /api/payments/:id`
- `PUT /api/payments/:id`
- `DELETE /api/payments/:id`

### Request shape

- Stripe endpoints use payment/session payloads
- regular payment create/update uses payment fields from the payment schema

### Response shape

- list returns `success,data,count`
- most other endpoints return `success,data` or `success,message`

## 13. Cart

Files:

- `server/routes/cartRoutes.js`
- `server/controllers/cartController.js`

### Endpoints

- `GET /api/cart`
- `POST /api/cart`
- `GET /api/cart/:id`
- `PUT /api/cart/:id`
- `DELETE /api/cart/:id`

### Request shape

- cart item create/update uses cart item schema fields

### Response shape

- list returns `success,count,data`
- create/detail/update/delete return `success,data` or `success,message`

## 14. Promo Codes

Files:

- `server/routes/promocodeRoutes.js`
- `server/controllers/promocodeController.js`

### Endpoints

- `GET /api/promocodes`
- `POST /api/promocodes`
- `POST /api/promocodes/validate`
- `POST /api/promocodes/apply`
- `GET /api/promocodes/:id`
- `PUT /api/promocodes/:id`
- `DELETE /api/promocodes/:id`

### Request shape

- create/update uses promo code fields
- validate/apply uses the promo code value and target order/context

### Response shape

- list/detail/mutation follow the usual `success,data` pattern

## 15. Product Views

Files:

- `server/routes/productviewRoutes.js`
- `server/controllers/productviewController.js`

### Endpoints

- `GET /api/productview`
- `POST /api/productview`
- `GET /api/productview/:id`
- `DELETE /api/productview/:id`

### Response shape

- list returns `success,count,data`
- detail/create/delete return `success,data` or simple message

## 16. Shop

Files:

- `server/routes/shopRoutes.js`
- `server/controllers/shopController.js`

### Endpoints

- `GET /api/shop`
- `POST /api/shop`
- `GET /api/shop/:id`
- `PUT /api/shop/:id`
- `DELETE /api/shop/:id`

### Response shape

- same general pattern as other CRUD modules

## 17. Selling

Files:

- `server/routes/SellingRoutes.js`
- `server/controllers/SellingController.js`

### Endpoints

- `GET /api/selling`
- `POST /api/selling`
- `GET /api/selling/stats`
- `GET /api/selling/:id`
- `PUT /api/selling/:id`
- `DELETE /api/selling/:id`

### Response shape

- list/stats return `success,count,data` or stats objects

## 18. Presence

Files:

- `server/routes/presenceRoutes.js`
- `server/controllers/PresenceController.js`

### Endpoint

- `POST /api/presence/ping`

### Request shape

- heartbeat request, usually no special body required

### Response shape

- verified live response:

```json
{ "success": true, "serverTime": "..." }
```

## 19. Subscriptions

Files:

- `server/routes/SubscriptionsRoutes.js`
- `server/controllers/SubscriptionsController.js`

### Endpoints

- `GET /api/subscriptions`
- `GET /api/subscriptions/me/status`
- `POST /api/subscriptions`
- `POST /api/subscriptions/seed`

### Response shape

- `GET /api/subscriptions` returned a raw array in live testing
- `me/status` returns a status object

## 20. Files

Files:

- `server/routes/FileRoutes.js`
- `server/controllers/FileController.js`
- `server/utils/fileStorage.js`

### Endpoints

- `GET /api/files/:ownerType/:ownerId/:bucket/:filename`
- fallback file path GETs are also supported

### Notes

- the endpoint is protected
- it checks `Authorization`
- it enforces ownership / staff permissions before serving the file

## 21. Admins

Files:

- `server/routes/adminRoutes.js`
- `server/controllers/AdminController.js`

### Endpoints

- `GET /api/admins`
- `POST /api/admins`
- `GET /api/admins/:id`
- `PUT /api/admins/:id`
- `DELETE /api/admins/:id`

### Response shape

- live GET response shape was `success,count,data`

## 22. Super Admins

Files:

- `server/routes/superadminRoutes.js`
- `server/controllers/superadminController.js`

### Endpoints

- `GET /api/superadmins`
- `POST /api/superadmins`
- `GET /api/superadmins/:id`
- `PUT /api/superadmins/:id`
- `DELETE /api/superadmins/:id`

### Response shape

- live GET response shape was `success,count,data`

## 23. Contact Us

Files:

- `server/routes/ContactUsRoutes.js`
- `server/controllers/ContactUsController.js`

### Endpoints

- `POST /api/contacts`
- `GET /api/contacts`
- `GET /api/contacts/:id`
- `PUT /api/contacts/:id`
- `DELETE /api/contacts/:id`

### Response shape

- standard CRUD response pattern

## 24. AI Chat

Files:

- `server/routes/AIChatRoutes.js`
- `server/controllers/AIChatController.js`

### Endpoint

- `POST /api/ai-chat`

### Request shape

- `message`

### Response shape

- assistant response payload with medical context

## 25. My Clinic

Files:

- `server/routes/MyClinicRoutes.js`
- `server/controllers/MyClinicController.js`

### Endpoints

- `GET /api/myclinic`
- `POST /api/myclinic`
- `GET /api/myclinic/:id`
- `PUT /api/myclinic/:id`
- `DELETE /api/myclinic/:id`

### Response shape

- live GET response shape was `success,count,data,message`

## 26. My Patient

Files:

- `server/routes/MyPatientRoutes.js`
- `server/controllers/MyPatientController.js`

### Endpoints

- `GET /api/my-patient`
- `POST /api/my-patient`
- `GET /api/my-patient/:id`
- `PUT /api/my-patient/:id`
- `DELETE /api/my-patient/:id`

### Response shape

- live GET response shape was `success,count,data,message`

## 27. Verification Doctor

Files:

- `server/routes/VerificationDoctorRoutes.js`
- `server/controllers/VerificationDoctorController.js`

### Endpoints

- `GET /api/verification-doctor`
- `POST /api/verification-doctor`
- `GET /api/verification-doctor/:id`
- `PUT /api/verification-doctor/:id`
- `DELETE /api/verification-doctor/:id`

### Response shape

- standard CRUD pattern

## 28. Insulin Units

Files:

- `server/routes/insulinunitsRoutes.js`
- `server/controllers/insulinunitsController.js`

### Endpoints

- `GET /api/insulinunits`
- `POST /api/insulinunits`
- `GET /api/insulinunits/:id`
- `PUT /api/insulinunits/:id`
- `DELETE /api/insulinunits/:id`

### Response shape

- standard CRUD pattern

## 29. Dietly System

Files:

- `server/routes/DietlySystemRoutes.js`
- `server/controllers/DietlySystemController.js`

### Endpoints

- `GET /api/dietly-system`
- `POST /api/dietly-system`
- `GET /api/dietly-system/:id`
- `PUT /api/dietly-system/:id`
- `DELETE /api/dietly-system/:id`

### Response shape

- standard CRUD pattern

## 30. Sensors

Files:

- `server/routes/SinsorRoutes.js`
- `server/controllers/SinsorController.js`

### Endpoints

- `GET /api/sinsors`
- `POST /api/sinsors`
- `GET /api/sinsors/:id`
- `PUT /api/sinsors/:id`
- `DELETE /api/sinsors/:id`

### Response shape

- standard CRUD pattern

## 31. Mobile Namespace

Files:

- `server/routes/mobile/index.js`
- `server/routes/mobile/authMobileRoutes.js`

### Endpoints mounted under `/api/mobile`

- `GET /api/mobile/`
- `POST /api/mobile/auth/register`
- `POST /api/mobile/auth/login`
- `POST /api/mobile/auth/logout`
- `GET /api/mobile/users`
- `GET /api/mobile/doctors`
- `GET /api/mobile/patients`
- `GET /api/mobile/products`
- `GET /api/mobile/shop`
- `GET /api/mobile/productview`
- `GET /api/mobile/promocodes`
- `GET /api/mobile/cart`
- `GET /api/mobile/messages`
- `GET /api/mobile/notifications`
- `GET /api/mobile/bookings`
- `GET /api/mobile/monitoring`
- `GET /api/mobile/lab-tests`
- `GET /api/mobile/orders`
- `GET /api/mobile/billings`
- `GET /api/mobile/payments`
- `GET /api/mobile/contacts`
- `GET /api/mobile/selling`
- `GET /api/mobile/verification-doctor`
- `GET /api/mobile/insulinunits`
- `GET /api/mobile/presence`
- `GET /api/mobile/subscriptions`
- `GET /api/mobile/files`
- `GET /api/mobile/ai-chat`
- `GET /api/mobile/myclinic`
- `GET /api/mobile/my-patient`

### Live verified

- `GET /api/mobile/` returned `{"success":true,"message":"Mobile API is running"}`

## 32. Response Patterns To Remember

Most of the backend follows one of these patterns:

### List

```json
{ "success": true, "count": 12, "data": [...] }
```

### Single item

```json
{ "success": true, "data": { ... } }
```

### Mutations

```json
{ "success": true, "data": { ... }, "message": "..." }
```

### Errors

```json
{ "success": false, "message": "..." }
```

or

```json
{ "success": false, "error": "..." }
```

## 33. How To Read The Backend

The easiest way to understand the project is:

1. Start from `server/index.js`
2. Open the route file for the feature you care about
3. Open the matching controller
4. Check the model fields
5. Look at the response shape

That gives you the full flow from URL to MongoDB to JSON response.

## 34. Notes From The Live Run

- The server booted successfully.
- The root route and mobile health route were reachable.
- The admin seeded account logged in successfully.
- Temporary notification and monitoring records were created, updated, and deleted successfully.
- The dummy PATCH test for order status returned `404`, which is expected because the dummy order id does not exist.

