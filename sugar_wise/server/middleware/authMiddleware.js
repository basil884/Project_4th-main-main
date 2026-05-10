const jwt = require('jsonwebtoken');

const SECRET_KEY = process.env.JWT_SECRET || 'your-secret-key';

const normalizeRole = (role) => {
  const value = String(role || '').trim().toLowerCase();
  if (value === 'super admin' || value === 'superadmin' || value === 'subadmin') return 'superadmin';
  if (value === 'admin') return 'admin';
  if (value === 'doctor') return 'doctor';
  if (value === 'patient') return 'patient';
  return value;
};

function authenticateToken(req, res, next) {
  const authHeader = req.headers.authorization;
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) {
    return res.status(401).json({
      error: 'Access token required',
      message: 'Authorization token is missing or invalid',
    });
  }

  jwt.verify(token, SECRET_KEY, (err, user) => {
    if (err) {
      return res.status(403).json({
        error: 'Invalid or expired token',
        message: 'Please login again',
      });
    }

    req.user = user;
    next();
  });
}

function authorizeRole(allowedRoles = []) {
  return (req, res, next) => {
    if (!req.user) {
      return res.status(401).json({ error: 'User not authenticated' });
    }

    const userRole = normalizeRole(req.user.role);
    const normalizedAllowed = allowedRoles.map((role) => normalizeRole(role));
    if (!normalizedAllowed.includes(userRole)) {
      return res.status(403).json({
        error: 'Insufficient permissions',
        message: 'You do not have access to this resource',
      });
    }

    next();
  };
}

module.exports = { authenticateToken, authorizeRole };
